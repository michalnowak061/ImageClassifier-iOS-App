//
//  ModelDescriptionVC.swift
//  ImageClassifier
//
//  Created by Michał Nowak on 16/12/2020.
//

import UIKit

// MARK: -- ModelDescriptionVC class
class ModelDescriptionVC: UIViewController {
    // MARK: -- Private variable's
    private var modelName: String?
    private var modelMetadata: [String : String]?
    
    // MARK: -- Public variable's
    
    // MARK: -- Override function's
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        updateView()
    }
    
    // MARK: -- Private function's
    private func updateView() {
        if let name = self.modelName {
            self.modelNameLabel.text = name
        }
        if let data = self.modelMetadata {
            self.modelDescriptionTextView.text = data["description"]
            self.modelAuthorTextView.text = data["author"]
            self.modelLicenseTextView.text = data["license"]
            self.modelVersionTextView.text = data["version"]
        }
    }
    
    // MARK: -- Public function's
    public func setRequiredData(selectedModelName name: String, selectedModelMetadata metadata: [String : String]) {
        self.modelName = name
        self.modelMetadata = metadata
    }
    
    // MARK: -- IBOutlet's
    @IBOutlet weak var modelNameLabel: UILabel!
    @IBOutlet weak var modelDescriptionTextView: UITextView!
    @IBOutlet weak var modelAuthorTextView: UITextView!
    @IBOutlet weak var modelLicenseTextView: UITextView!
    @IBOutlet weak var modelVersionTextView: UITextView!
    
    // MARK: -- IBAction's
}
