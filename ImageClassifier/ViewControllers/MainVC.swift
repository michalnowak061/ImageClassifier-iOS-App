//
//  ViewController.swift
//  ImageClassifier
//
//  Created by Michał Nowak on 14/12/2020.
//
import UIKit
import CoreML
import ImageIO

class MainVC: UIViewController {
    // MARK: -- Private variable's
    private var imageClassifierModel: ImageClassifierModel!
    
    // MARK: -- Override function's
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.imageClassifierModel = ImageClassifierModel()
        
        if let path = Bundle.main.resourcePath {
            self.imageClassifierModel.loadModelPathsFromFolder(withPath: path)
        } else {
            print("Path did not exists")
        }
        
        self.startButtonSetup()
        self.settingsButtonSetup()
        self.aboutButtonSetup()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)  {
        switch segue.identifier {
        case "showModelsListVC":
            let modelsListVC = segue.destination as? ModelsListVC
            modelsListVC?.setRequiredData(imageClassifierModel: self.imageClassifierModel)
            break
        default:
            break
        }
    }
    
    // MARK: -- Private function's
    private func startButtonSetup() {
        self.startButton.setRoundedCorners(cornerRadius: 10.0)
    }
    
    private func settingsButtonSetup() {
        self.settingsButton.setRoundedCorners(cornerRadius: 10.0)
    }
    
    private func aboutButtonSetup() {
        self.aboutButton.setRoundedCorners(cornerRadius: 10.0)
    }
    
    // MARK: -- IBOutlet's
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var aboutButton: UIButton!
    
    // MARK: -- IBAction's
    @IBAction func startButtonPressed(_ sender: UIButton) {
        sender.pressAnimation()
        let seconds = 0.2
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            self.performSegue(withIdentifier: "showModelsListVC", sender: nil)
        }
    }
    
    @IBAction func settingsButtonPressed(_ sender: UIButton) {
        sender.pressAnimation()
    }
    
    @IBAction func aboutButtonPressed(_ sender: UIButton) {
        sender.pressAnimation()
    }
}

