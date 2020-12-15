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
    var imageClassifierModel = ImageClassifierModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        do {
            let model = try MobileNet.init(configuration: MLModelConfiguration()).model
            imageClassifierModel.loadModel(input: model)
        } catch {
            
        }
        
        if let image = UIImage(named: "banana1.jpg") {
            imageClassifierModel.updateClassifications(for: image)
        }
    }
}

