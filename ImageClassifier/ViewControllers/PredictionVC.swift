//
//  PredictionVC.swift
//  ImageClassifier
//
//  Created by Michał Nowak on 18/12/2020.
//

import UIKit
import CoreML
import ImageIO
import MBCircularProgressBar
import YPImagePicker
import PhotoEditorSDK

class PredictionVC: UIViewController {
    // MARK: -- Private parameter's
    private let buttonsFontScaleFactor: CGFloat = 0.4
    private let roundedCornersRadius: CGFloat = 10.0
    private let predictionProgressBarDuration: Double = 2.0
    
    // MARK: -- Private variable's
    private var imageClassifierModel: ImageClassifierModel!
    private var modelPath: String!
    private var loadedImage: UIImage?
    private var photoEditViewController: PhotoEditViewController!
    
    // MARK: -- Override function's
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.infoViewSetup()
        self.loadedImageViewSetup()
        self.defaultViewSetup()
        self.loadModel()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showMoreLabelsVC":
            let moreLabelsVC = segue.destination as? MoreLabelsVC
            moreLabelsVC?.setRequiredData(imageClassifierModel: self.imageClassifierModel)
            break
        default:
            break
        }
    }
    
    // MARK: -- Private function's
    private func defaultViewSetup() {
        self.predictionProgressBar.value = 0
        self.predictionLabel.text = "Prediction label"
        self.showMoreLabelsButtonSetup()
        self.menuButtonSetup()
    }
    
    private func infoViewSetup() {
        self.infoView.isHidden = false
        self.infoView.setRoundedCorners(cornerRadius: self.roundedCornersRadius)
    }
    
    private func loadedImageViewSetup() {
        self.loadedImageView.setRoundedCorners(cornerRadius: self.roundedCornersRadius)
    }
    
    private func showMoreLabelsButtonSetup() {
        self.showMoreLabelsButton.setRoundedCorners(cornerRadius: self.roundedCornersRadius)
        self.showMoreLabelsButton.isHidden = true
    }
    
    private func menuButtonSetup() {
        self.menuButton.setRoundedCorners(cornerRadius: self.roundedCornersRadius)
        self.menuButton.isHidden = true
    }
    
    private func loading(continues: Bool) {
        self.activityIndicator.isHidden = !continues
        self.modelLoadingLabel.isHidden = !continues
        if continues {
            self.activityIndicator.startAnimating()
        } else {
            self.activityIndicator.stopAnimating()
        }
        self.addImageButton.isEnabled = !continues
        self.loadedImageView.isHidden = continues
        self.infoView.isHidden = continues
        self.predictionView.isHidden = continues
    }
    
    private func loadModel() {
        self.loading(continues: true)
        DispatchQueue.main.async {
            self.imageClassifierModel.loadModel(withPath: self.modelPath)
        }
        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { timer in
            self.loading(continues: false)
        }
    }
    
    private func showMoreLabelsButtonShow(withDuration duration: Double) {
        Timer.scheduledTimer(withTimeInterval: duration, repeats: false) { timer in
            self.showMoreLabelsButton.isHidden = false
        }
    }
    
    private func menuButtonShow(withDuration duration: Double) {
        Timer.scheduledTimer(withTimeInterval: duration, repeats: false) { timer in
            self.menuButton.isHidden = false
        }
    }
    
    private func predictionProgressBarShowProgress(prediction: ClassificationResult, withDuration duration: Double) {
        UIView.animate(withDuration: duration) {
            if let progress = prediction.classification(atIndex: 0)?.prediction {
                self.predictionProgressBar.value = CGFloat(progress * 100)
            }
        }
    }
    
    private func predictionLabelShowPrediction(prediction: ClassificationResult, withDuration duration: Double) {
        let timeInterval = 0.1
        let numberOfIteration = Int(duration / timeInterval)
        var counter = 0
        Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true) { timer in
            let randomIndex = Int.random(in: 0...prediction.labelsCount-1)
            self.predictionLabel.text = prediction.classification(atIndex: randomIndex)?.label
            
            counter += 1
            if counter >= numberOfIteration {
                timer.invalidate()
                self.predictionLabel.text = prediction.classification(atIndex: 0)?.label
            }
        }
    }
    
    // MARK: -- Public function's
    public func setRequiredData(imageClassifierModel model: ImageClassifierModel, modelPath path: String) {
        self.imageClassifierModel = model
        self.modelPath = path
        self.imageClassifierModel.delegate = self
        self.imageClassifierModel.presentationController = self
    }
    
    // MARK: -- @IBOutle's
    @IBOutlet weak var addImageButton: UIBarButtonItem!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var modelLoadingLabel: UILabel!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var predictionView: UIView!
    @IBOutlet weak var loadedImageView: UIImageView!
    @IBOutlet weak var predictionProgressBar: MBCircularProgressBarView!
    @IBOutlet weak var predictionLabel: UILabel!
    @IBOutlet weak var showMoreLabelsButton: UIButton!
    @IBOutlet weak var menuButton: UIButton!
    
    // MARK: -- @IBAction's
    @IBAction func loadImageButtonPressed(_ sender: Any) {
        var config = YPImagePickerConfiguration()
        config.showsPhotoFilters = false
        config.targetImageSize = YPImageSize.original
        config.library.isSquareByDefault = false
        let picker = YPImagePicker(configuration: config)
        picker.didFinishPicking { [unowned picker] items, cancelled in
            if let image = items.singlePhoto?.image {
                self.loadedImage = image
            }
            picker.dismiss(animated: true, completion: nil)
            
            if(cancelled) {
                return
            }
            if self.loadedImage != nil {
                let photo = Photo(image: self.loadedImage!)
                self.photoEditViewController = PhotoEditViewController(photoAsset: photo)
                self.photoEditViewController.delegate = self
                self.present(self.photoEditViewController, animated: true, completion: nil)
            }
        }
        present(picker, animated: true, completion: nil)
    }
    
    @IBAction func showMoreLabelsButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "showMoreLabelsVC", sender: nil)
    }
    
    @IBAction func menuButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "showMainVC", sender: nil)
    }
}

// MARK: -- extension's
extension PredictionVC: PhotoEditViewControllerDelegate {
    func photoEditViewController(_ photoEditViewController: PhotoEditViewController, didSave image: UIImage, and data: Data) {
        photoEditViewController.dismiss(animated: true, completion: nil)
        self.infoView.isHidden = true
        self.loadedImageView.image = image
        self.loadedImage = image
        self.imageClassifierModel?.updateClassifications(for: image)
    }
    
    func photoEditViewControllerDidFailToGeneratePhoto(_ photoEditViewController: PhotoEditViewController) {
        photoEditViewController.dismiss(animated: true, completion: nil)
    }
    
    func photoEditViewControllerDidCancel(_ photoEditViewController: PhotoEditViewController) {
        photoEditViewController.dismiss(animated: true, completion: nil)
    }
}

extension PredictionVC: ImageClassifierModelDelegate {
    func predictionReady(prediction: ClassificationResult) {
        self.predictionProgressBarShowProgress(prediction: prediction, withDuration: self.predictionProgressBarDuration)
        self.predictionLabelShowPrediction(prediction: prediction, withDuration: self.predictionProgressBarDuration)
        self.showMoreLabelsButtonShow(withDuration: self.predictionProgressBarDuration)
        self.menuButtonShow(withDuration: self.predictionProgressBarDuration)
    }
}
