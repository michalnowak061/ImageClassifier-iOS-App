//
//  ViewController.swift
//  ImageClassifier
//
//  Created by Michał Nowak on 14/12/2020.
//
import UIKit
import CoreML
import ImageIO

class ViewController: UIViewController {
    var imageClassifierModel: ImageClassifierModel!
    var imagePicker: ImagePicker!
    var loadedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.imageClassifierModel = ImageClassifierModel(presentationController: self, delegate: self)
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        
        if let path = Bundle.main.resourcePath {
            self.loadModel(withPath: path + "/MobileNet.mlmodelc")
        } else {
            print("Path did not exists")
        }
    }
    
    private func loadModel(withPath path: String) {
        do {
            let url = NSURL.fileURL(withPath: path)
            let model = try MLModel(contentsOf: url)
            self.imageClassifierModel.loadModel(input: model)
        } catch {
            print("Failed to load ML model: \(error)")
        }
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
extension ViewController: ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        self.loadedImageView.image = image
        self.loadedImage = image
        if let image = loadedImage {
            self.imageClassifierModel?.updateClassifications(for: image)
        }
    }
}

extension ViewController: ImageClassifierModelDelegate {
    func predictionReady(prediction: String?) {
        if prediction != nil {
            self.predictionResultTextView.text = prediction!
        }
    }
}
