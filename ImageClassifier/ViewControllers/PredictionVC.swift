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
    // MARK: -- Private variable's
    private var imageClassifierModel: ImageClassifierModel!
    private var imagePicker: ImagePicker!
    private var loadedImage: UIImage?
    
    // MARK: -- Override function's
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        showMoreLabelsButtonSetup()
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
    private func showMoreLabelsButtonSetup() {
        self.showMoreLabelsButton.setRoundedCorners(cornerRadius: 10.0)
    }
    
    private func predictionProgressBarShowProgress(_ progress: CGFloat) {
        UIView.animate(withDuration: 5.0) {
            self.predictionProgressBar.value = progress * 100
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
    
    // MARK: -- @IBAction's
    @IBAction func loadButtonPressed(_ sender: UIButton) {
        self.imagePicker.present(from: sender)
    }
    
    @IBAction func showMoreLabelsButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "showMoreLabelsVC", sender: nil)
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
        if let prediction = prediction.classification(atIndex: 0) {
            let label = prediction.label
            let probability = prediction.prediction
            
            self.predictionProgressBarShowProgress(CGFloat(probability))
            self.predictionLabel.text = label
        }
    }
}
