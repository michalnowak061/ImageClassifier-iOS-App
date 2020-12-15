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
    var model: VNCoreMLModel?
    
    public func loadModel(input model: MLModel) {
        do {
            self.model = try VNCoreMLModel(for: model)
        } catch {
            print("Failed to load ML model: \(error)")
        }
    }
    
    public func updateClassifications(for image: UIImage) {
        //classificationLabel.text = "Classifying..."
        print("Classifying...")
        
        let orientation = CGImagePropertyOrientation(image.imageOrientation)
        guard let ciImage = CIImage(image: image) else { fatalError("Unable to create \(CIImage.self) from \(image).") }
        
        DispatchQueue.global(qos: .userInitiated).async {
            let handler = VNImageRequestHandler(ciImage: ciImage, orientation: orientation)
            do {
                if let request = self.classificationRequest() {
                    try handler.perform([request])
                }
            } catch {
                /*
                 This handler catches general image processing errors. The `classificationRequest`'s
                 completion handler `processClassifications(_:error:)` catches errors specific
                 to processing that request.
                 */
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
                //self.classificationLabel.text = "Unable to classify image.\n\(error!.localizedDescription)"
                print("Unable to classify image.\n\(error!.localizedDescription)")
                return
            }
            // The `results` will always be `VNClassificationObservation`s, as specified by the Core ML model in this project.
            let classifications = results as! [VNClassificationObservation]
        
            if classifications.isEmpty {
                //self.classificationLabel.text = "Nothing recognized."
                print("Nothing recognized.")
            } else {
                // Display top classifications ranked by confidence in the UI.
                let topClassifications = classifications.prefix(2)
                let descriptions = topClassifications.map { classification in
                    // Formats the classification for display; e.g. "(0.37) cliff, drop, drop-off".
                   return String(format: "  (%.2f) %@", classification.confidence, classification.identifier)
                }
                //self.classificationLabel.text = "Classification:\n" + descriptions.joined(separator: "\n")
                print("Classification:\n" + descriptions.joined(separator: "\n"))
            }
        }
    }
};
