//
//  ImageClassifierModel.swift
//  ImageClassifier
//
//  Created by Michał Nowak on 14/12/2020.
//
import UIKit
import CoreML
import Vision
import ImageIO

class ImageClassifierModel {
    // MARK: -- Private variable's
    private var model: VNCoreMLModel?
    private var modelMetadata: [MLModelMetadataKey : Any]?
    private var modelClassLabels: [Any]?
    private var fileManager: FileManager!

    // MARK: -- Public variable's
    public weak var presentationController: UIViewController!
    public weak var delegate: ImageClassifierModelDelegate!
    public var modelPathsList: [(name: String, path: String)]!
    public var modelMetadataDictionary: [String : String] {
        get {
            var metadata: [String : String] = [:]
            if let data = self.modelMetadata {
                metadata["description"] = data[MLModelMetadataKey(rawValue: "MLModelDescriptionKey")] as? String
                metadata["author"] = data[MLModelMetadataKey(rawValue: "MLModelAuthorKey")] as? String
                metadata["license"] = data[MLModelMetadataKey(rawValue: "MLModelLicenseKey")] as? String
                metadata["version"] = data[MLModelMetadataKey(rawValue: "MLModelVersionKey")] as? String
            }
            return metadata
        }
    }
    public var classificationResult: ClassificationResult?
    
    // MARK: -- Private function's
    private func loadModel(input model: MLModel) {
        do {
            self.model = try VNCoreMLModel(for: model)
        } catch {
            print("Failed to load ML model: \(error)")
        }
    }
    
    private func compileModel(modelPath path: String) -> String {
        guard path.contains(".mlmodelc") != true else {
            return path
        }
        do {
            let url = try MLModel.compileModel(at: URL(fileURLWithPath: path))
            return url.path
        } catch {
            print("Failed to compile ML model: \(error)")
        }
        return path
    }
    
    // MARK: -- Public function's
    public init() {
        self.fileManager = FileManager()
        self.modelPathsList = []
    }
    
    public func loadModelPathsFromFolder(withPath path: String) {
        self.modelPathsList = fileManager.getFileListFromDirectory(withPath: path, typeOf: "mlmodel")
    }
    
    public func addModelPath(modelName name: String, modelPath path: String) {
        var compiledModelPath: String = path
        if(path.contains(".mlmodelc") == false) {
            compiledModelPath = self.compileModel(modelPath: path)
        }
        if let documentDirectoryPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.path {
            let modelName = name.replacingOccurrences(of: ".mlmodel", with: ".mlmodelc")
            let modelPath = documentDirectoryPath + "/" + modelName
            if FileManager().fileExists(atPath: modelPath) {
                return
            }
            if(FileManager().secureCopyItem(at: URL(fileURLWithPath: compiledModelPath), to: URL(fileURLWithPath: modelPath)) != true) {
                print("Model copy to", modelPath)
            }
            self.modelPathsList.append((modelName, modelPath))
        }
        
        var modelList = modelPathListJSON()
        modelList.setModelPathsList(modelPaths: self.modelPathsList)
        self.modelPathsList = modelList.getModelPathsList()
    }
    
    public func loadModel(withPath path: String) {
        do {
            let url = NSURL.fileURL(withPath: path)
            let model = try MLModel(contentsOf: url)
            self.modelMetadata = model.modelDescription.metadata
            self.loadModel(input: model)
        } catch {
            print("Failed to load ML model: \(error)")
        }
    }
    
    public func deleteModelPath(atIndex index: Int) {
        let modelPath = self.modelPathsList[index].path
        do {
            if FileManager().fileExists(atPath: modelPath) {
                try FileManager().removeItem(atPath: modelPath)
            } else {
                print("File does not exist")
            }
        } catch {
            print("Model remove error: \(error)")
        }
        self.modelPathsList.remove(at: index)
        
        var modelList = modelPathListJSON()
        modelList.setModelPathsList(modelPaths: self.modelPathsList)
        self.modelPathsList = modelList.getModelPathsList()
    }
    
    public func updateClassifications(for image: UIImage) {
        let orientation = CGImagePropertyOrientation(image.imageOrientation)
        guard let ciImage = CIImage(image: image) else { fatalError("Unable to create \(CIImage.self) from \(image).") }
        
        DispatchQueue.global(qos: .userInitiated).async {
            let handler = VNImageRequestHandler(ciImage: ciImage, orientation: orientation)
            do {
                if let request = self.classificationRequest() {
                    try handler.perform([request])
                }
            } catch {
                print("Failed to perform classification.\n\(error.localizedDescription)")
            }
        }
    }
    
    public func classificationRequest() -> VNCoreMLRequest? {
        if self.model != nil {
            let request = VNCoreMLRequest(model: self.model!, completionHandler: { [weak self] request, error in
                self?.processClassifications(for: request, error: error)
            })
            request.imageCropAndScaleOption = .centerCrop
            return request
        }
        return nil
    }
    
    func processClassifications(for request: VNRequest, error: Error?) {
        DispatchQueue.main.async {
            guard let results = request.results else {
                print("Unable to classify image.\n\(error!.localizedDescription)")
                return
            }
            let classifications = results as! [VNClassificationObservation]
            if classifications.isEmpty {
                print("Nothing recognized.")
            } else {
                self.classificationResult = ClassificationResult(classifications: classifications)
                if self.classificationResult != nil {
                    self.delegate?.predictionReady(prediction: self.classificationResult!)
                }
            }
        }
    }
}
