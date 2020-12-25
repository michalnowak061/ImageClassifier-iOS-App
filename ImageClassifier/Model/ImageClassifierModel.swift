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
    
    // MARK: -- Public function's
    public init() {
        self.fileManager = FileManager()
        self.modelPathsList = []
    }
    
    public func loadModelPathsFromFolder(withPath path: String) {
        self.modelPathsList = fileManager.getFileListFromDirectory(withPath: path, typeOf: "mlmodel")
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
        self.modelPathsList.remove(at: index)
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
};
