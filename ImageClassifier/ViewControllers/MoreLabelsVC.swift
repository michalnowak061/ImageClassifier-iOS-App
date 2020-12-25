//
//  MorePredictionsVC.swift
//  ImageClassifier
//
//  Created by Michał Nowak on 25/12/2020.
//

import UIKit

class MoreLabelsVC: UIViewController {
    // MARK: -- Private variable's
    private var imageClassifierModel: ImageClassifierModel!
    private var classificationResult: ClassificationResult!
    
    // MARK: -- Public variable's
    
    // MARK: -- Override function's
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        labelsTableViewSetup()
    }
    
    // MARK: -- Private function's
    private func labelsTableViewSetup() {
        self.labelsTableView.delegate = self
        self.labelsTableView.dataSource = self
    }
    
    // MARK: -- Public function's
    public func setRequiredData(imageClassifierModel: ImageClassifierModel) {
        self.imageClassifierModel = imageClassifierModel
        self.classificationResult = self.imageClassifierModel.classificationResult
    }
    
    // MARK: -- IBOutlet's
    @IBOutlet weak var labelsTableView: UITableView!
}

extension MoreLabelsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(100.0)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.classificationResult.labelsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.labelsTableView.dequeueReusableCell(withIdentifier: MoreLabelsTVC().identifier, for: indexPath) as! MoreLabelsTVC
        
        if let prediction = self.classificationResult.classification(atIndex: indexPath.row) {
            let label = prediction.label
            let probability = prediction.prediction
            
            cell.labelName = label
            cell.predictionValue = probability
        }
        return cell
    }
}
