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
    private var debouncingPreventionTimer: Timer!
    
    // MARK: -- Override function's
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.modelsCVSetup()
        self.searchBarSetup()
    }
    
    override func viewWillLayoutSubviews() {
       super.viewWillLayoutSubviews()
       self.modelsCollectionView.collectionViewLayout.invalidateLayout()
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
            let paths = self.modelsPathList.filter {
                let string = String().removeSpecialCharsFromString(text: $0.0)
                let keyword = String().removeSpecialCharsFromString(text: searchText)
                return string.containsIgnoringCase(find: keyword)
            }
            return paths
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

extension ModelsListVC: UICollectionViewDelegate, UICollectionViewDataSource, SwipeCollectionViewCellDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.view.frame.width * 0.85
        let height = CGFloat(100.0)
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.modelsPathList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.modelsCollectionView.dequeueReusableCell(withReuseIdentifier: ModelsListCVC().identifier,
                                                                 for: indexPath) as! ModelsListCVC
        let modelName = self.modelsPathList[indexPath.row].name
        let modelPath = self.modelsPathList[indexPath.row].path
        let modelURL = URL(fileURLWithPath: modelPath)
        var swiftIcon = UIImage.icon(forFileURL: modelURL, preferredSize: .smallest)
        swiftIcon = swiftIcon.imageWithInsets(insetDimen: 4.0)
        
        let size = FileManager().sizeForLocalFilePath(filePath: modelPath)
        let sizeString = FileManager().covertToFileString(with: size)
        
        let date = (try? FileManager.default.attributesOfItem(atPath: modelPath))?[.creationDate] as? Date
        
        cell.viewSetup()
        cell.modelIcon = swiftIcon
        cell.modelName = modelName
        cell.modelFileSize = sizeString
        cell.modelCreateDate = date?.description ?? ""
        cell.delegate = self
        
        return cell
    }
        
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let seconds = 0.2
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            self.selectedModelIndex = indexPath.row
            self.performSegue(withIdentifier: "showPredictionVC", sender: nil)
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.modelsCollectionView.allowsSelection = false
        debouncingPreventionTimer?.invalidate()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        debouncingPreventionTimer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: false) { timer in
            self.modelsCollectionView.allowsSelection = true
        }
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
        deleteAction.backgroundColor = UIColor(red: 207.0/255.0, green: 73.0/255.0, blue: 79.0/255.0, alpha: 1.0)
        
        let infoAction = SwipeAction(style: .default, title: "Info") { action, indexPath in
            self.selectedModelIndex = indexPath.row
            self.performSegue(withIdentifier: "showModelDescriptionVC", sender: nil)
        }
        infoAction.backgroundColor = UIColor(red: 84.0/255.0, green: 136.0/255.0, blue: 243.0/255.0, alpha: 1.0)
        infoAction.hidesWhenSelected = true
        
        return [deleteAction, infoAction]
    }
}
