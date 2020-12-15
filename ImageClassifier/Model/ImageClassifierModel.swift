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

public protocol ImageClassifierModelDelegate: class {
    func predictionReady(prediction: String?)
}

class ImageClassifierModel {
    private weak var presentationController: UIViewController?
    private weak var delegate: ImageClassifierModelDelegate?
    
    var model: VNCoreMLModel?
    
    public init(presentationController: UIViewController, delegate: ImageClassifierModelDelegate) {
        self.presentationController = presentationController
        self.delegate = delegate
    }
    
    public func loadModel(input model: MLModel) {
        do {
            self.model = try VNCoreMLModel(for: model)
        } catch {
            print("Failed to load ML model: \(error)")
        }
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
        var prediction: String = ""
        DispatchQueue.main.async {
            guard let results = request.results else {
                print("Unable to classify image.\n\(error!.localizedDescription)")
                return
            }
            let classifications = results as! [VNClassificationObservation]
            if classifications.isEmpty {
                print("Nothing recognized.")
            } else {
                let topClassifications = classifications.prefix(2)
                let descriptions = topClassifications.map { classification in
                   return String(format: "  (%.2f) %@", classification.confidence, classification.identifier)
                }
                prediction = "Classification:\n" + descriptions.joined(separator: "\n")
                self.delegate?.predictionReady(prediction: prediction)
            }
        }
    }
};
