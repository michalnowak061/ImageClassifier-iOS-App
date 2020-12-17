//
//  ModelsListVC.swift
//  ImageClassifier
//
//  Created by Michał Nowak on 16/12/2020.
//

import UIKit
import Vision

// MARK: -- ModelsListVC class
class ModelsListVC: UIViewController {
    // MARK: -- Private variable's
    private var imageClassifierModel: ImageClassifierModel!
    private var selectedModel: VNCoreMLModel?
    
    // MARK: -- Override functions'
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageClassifierModel = ImageClassifierModel(presentationController: self, delegate: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)  {
        if segue.identifier == "showModelDescriptionVC" {
            let modelDescriptionVC = segue.destination as? ModelDescriptionVC
            
            if let path = Bundle.main.resourcePath {
                self.imageClassifierModel.loadModel(withPath: path + "/MobileNet.mlmodelc")
            } else {
                print("Path did not exists")
            }
            
            let name = self.imageClassifierModel.modelName
            let metadata = self.imageClassifierModel.modelMetadataDictionary
            
            modelDescriptionVC?.setModel(name: name)
            modelDescriptionVC?.setModel(metadata: metadata)
        }
    }
    
    // MARK: -- Private function's
    
    // MARK: -- Public function's
    
    // MARK: -- IBAction's
}
// MARK: -- Extensions
extension ModelsListVC: ImageClassifierModelDelegate {
    func predictionReady(prediction: String?) {
    }
}
