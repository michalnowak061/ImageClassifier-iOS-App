//
//  PredictionVC.swift
//  ImageClassifier
//
//  Created by Michał Nowak on 18/12/2020.
//

import UIKit
import CoreML
import ImageIO

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
    }
    
    // MARK: -- Private function's
    
    // MARK: -- Public function's
    public func setRequiredData(imageClassifierModel: ImageClassifierModel) {
        self.imageClassifierModel = imageClassifierModel
        self.imageClassifierModel.delegate = self
        self.imageClassifierModel.presentationController = self
    }
    
    // MARK: -- @IBOutle's
    @IBOutlet weak var loadedImageView: UIImageView!
    @IBOutlet weak var predictionResultTextView: UITextView!
    
    // MARK: -- @IBAction's
    @IBAction func loadButtonPressed(_ sender: UIButton) {
        self.imagePicker.present(from: sender)
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
    func predictionReady(prediction: String?) {
        if prediction != nil {
            self.predictionResultTextView.text = prediction!
        }
    }
}
