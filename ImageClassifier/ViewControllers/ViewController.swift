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
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        
        self.imageClassifierModel = ImageClassifierModel()
        do {
            let model = try MobileNet.init(configuration: MLModelConfiguration()).model
            imageClassifierModel.loadModel(input: model)
        } catch {
            
        }
        
        if let image = UIImage(named: "banana1.jpg") {
            self.imageClassifierModel.updateClassifications(for: image)
        }
    }
    
    // MARK: -- @IBOutle's
    @IBOutlet weak var loadedImageView: UIImageView!
    
    // MARK: -- @IBAction's
    @IBAction func loadButtonPressed(_ sender: UIButton) {
        self.imagePicker.present(from: sender)
        //self.loadedImage = UIImage(named: "banana1.jpg")
        //self.loadedImageView.image = self.loadedImage
    }
}

extension ViewController: ImagePickerDelegate {

    func didSelect(image: UIImage?) {
        self.loadedImageView.image = image
    }
}
