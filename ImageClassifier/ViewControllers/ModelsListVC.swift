//
//  ModelsListVC.swift
//  ImageClassifier
//
//  Created by Michał Nowak on 16/12/2020.
//

import UIKit
import Vision
import SwipeCellKit

// MARK: -- ModelsListVC class
class ModelsListVC: UIViewController {
    // MARK: -- Private variable's
    private var imageClassifierModel: ImageClassifierModel!
    private var modelsPathList: [(name: String, path: String)]!
    private var selectedModel: VNCoreMLModel?
    private var selectedModelIndex: Int?
    
    // MARK: -- Override function's
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.modelsCVSetup()
        self.searchBarSetup()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)  {
        switch segue.identifier {
        case "showPredictionVC":
            if let index = self.selectedModelIndex {
                let path = self.imageClassifierModel.modelPathsList[index].path
                
                self.imageClassifierModel.loadModel(withPath: path)
                
                let predictionVC = segue.destination as? PredictionVC
                predictionVC?.setRequiredData(imageClassifierModel: self.imageClassifierModel)
            }
            break
        case "showModelDescriptionVC":
            if let index = self.selectedModelIndex {
                let path = self.imageClassifierModel.modelPathsList[index].path
                let name = self.imageClassifierModel.modelPathsList[index].name
                
                self.imageClassifierModel.loadModel(withPath: path)
                let metadata = self.imageClassifierModel.modelMetadataDictionary
                
                let modelDescriptionVC = segue.destination as? ModelDescriptionVC
                modelDescriptionVC?.setRequiredData(selectedModelName: name, selectedModelMetadata: metadata)
            }
            break
        default:
            break
        }
    }
    
    // MARK: -- Private function's
    private func modelsCVSetup() {
        self.modelsCollectionView.delegate = self
        self.modelsCollectionView.dataSource = self
        self.modelsCollectionView.keyboardDismissMode = .onDrag
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: self.view.frame.width * 0.9,
                                 height: self.view.frame.height * 0.1)
        
        self.modelsCollectionView.collectionViewLayout = layout
    }
    
    private func searchBarSetup() {
        self.searchBar.delegate = self
    }
    
    private func updateView() {
        self.modelsCollectionView.reloadData()
    }
    
    // MARK: -- Public function's
    public func setRequiredData(imageClassifierModel: ImageClassifierModel) {
        self.imageClassifierModel = imageClassifierModel
        self.modelsPathList = self.imageClassifierModel.modelPathsList
    }
    
    // MARK: -- IBOutlet's
    @IBOutlet weak var modelsCollectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: -- IBAction's
}
// MARK: -- Extensions
extension ModelsListVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        func filteredPaths(searchText: String) -> [(String, String)] {
            let locations = self.modelsPathList.filter {
                $0.0.localizedLowercase.contains(searchText)
            }
            return locations
        }
        if let item = self.searchBar.text, !item.isEmpty {
            self.modelsPathList = self.imageClassifierModel.modelPathsList
            let filteredlist: [(String, String)] = filteredPaths(searchText: searchText)
            self.modelsPathList = filteredlist
            self.updateView()
        } else {
            self.modelsPathList = self.imageClassifierModel.modelPathsList
            self.updateView()
        }
    }
}

extension ModelsListVC: UICollectionViewDelegate, UICollectionViewDataSource, SwipeCollectionViewCellDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.modelsPathList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.modelsCollectionView.dequeueReusableCell(withReuseIdentifier: ModelsListCVC().identifier,
                                                                 for: indexPath) as! ModelsListCVC
        let modelName = self.modelsPathList[indexPath.row].name
        cell.delegate = self
        cell.set(modelName: modelName)
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedModelIndex = indexPath.row
        performSegue(withIdentifier: "showPredictionVC", sender: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, editActionsOptionsForItemAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructiveAfterFill
        options.transitionStyle = .drag
        return options
    }
    
    func collectionView(_ collectionView: UICollectionView, editActionsForItemAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            self.imageClassifierModel.deleteModelPath(atIndex: indexPath.row)
            self.modelsPathList.remove(at: indexPath.row)
        }
        deleteAction.backgroundColor = .red
        
        let infoAction = SwipeAction(style: .default, title: "Info") { action, indexPath in
            self.selectedModelIndex = indexPath.row
            self.performSegue(withIdentifier: "showModelDescriptionVC", sender: nil)
        }
        infoAction.backgroundColor = .systemBlue
        infoAction.hidesWhenSelected = true
        
        return [deleteAction, infoAction]
    }
}

extension UIViewController {

    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)

        if let nav = self.navigationController {
            nav.view.endEditing(true)
        }
    }
}
