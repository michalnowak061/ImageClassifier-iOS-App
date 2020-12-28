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

class PredictionVC: UIViewController {
    // MARK: -- Private parameter's
    private let buttonsFontScaleFactor: CGFloat = 0.4
    private let roundedCornersRadius: CGFloat = 10.0
    private let predictionProgressBarDuration: Double = 2.0
    
    // MARK: -- Private variable's
    private var imageClassifierModel: ImageClassifierModel!
    private var imagePicker: ImagePicker!
    private var loadedImage: UIImage?
    
    // MARK: -- Override function's
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        self.defaultViewSetup()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showMoreLabelsVC":
            let moreLabelsVC = segue.destination as? MoreLabelsVC
            moreLabelsVC?.setRequiredData(imageClassifierModel: self.imageClassifierModel)
            break
        case "showMainVC":
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
    
    private func showMoreLabelsButtonSetup() {
        self.showMoreLabelsButton.setRoundedCorners(cornerRadius: self.roundedCornersRadius)
        self.showMoreLabelsButton.isHidden = true
    }
    
    private func menuButtonSetup() {
        self.menuButton.setRoundedCorners(cornerRadius: self.roundedCornersRadius)
        self.menuButton.isHidden = true
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
            let randomIndex = Int.random(in: 0...prediction.labelsCount)
            self.predictionLabel.text = prediction.classification(atIndex: randomIndex)?.label
            
            counter += 1
            if counter >= numberOfIteration {
                timer.invalidate()
                self.predictionLabel.text = prediction.classification(atIndex: 0)?.label
            }
        }
    }
    
    // MARK: -- Public function's
    public func setRequiredData(imageClassifierModel: ImageClassifierModel) {
        self.imageClassifierModel = imageClassifierModel
        self.imageClassifierModel.delegate = self
        self.imageClassifierModel.presentationController = self
    }
    
    // MARK: -- @IBOutle's
    @IBOutlet weak var loadedImageView: UIImageView!
    @IBOutlet weak var predictionProgressBar: MBCircularProgressBarView!
    @IBOutlet weak var predictionLabel: UILabel!
    @IBOutlet weak var showMoreLabelsButton: UIButton!
    @IBOutlet weak var menuButton: UIButton!
    
    // MARK: -- @IBAction's
    @IBAction func loadButtonPressed(_ sender: UIButton) {
        self.defaultViewSetup()
        self.imagePicker.present(from: sender)
    }
    
    @IBAction func showMoreLabelsButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "showMoreLabelsVC", sender: nil)
    }
    
    @IBAction func menuButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "showMainVC", sender: nil)
    }
}

// MARK: -- extension's
extension PredictionVC: ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        self.loadedImageView.image = image
        self.loadedImage = image
        if let image = loadedImage {
            self.imageClassifierModel?.updateClassifications(for: image)
        }
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
