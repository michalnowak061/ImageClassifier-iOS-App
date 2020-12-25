//
//  ClassificationResult.swift
//  ImageClassifier
//
//  Created by Michał Nowak on 24/12/2020.
//

import Foundation
import CoreML
import Vision
import ImageIO

public struct ClassificationResult {
    // MARK: -- Private variable's
    private var classifications: [VNClassificationObservation]
    
    // MARK: -- Public variable's
    public var labelsCount: Int {
        get {
            return self.classifications.count
        }
    }
    
    // MARK: -- Public function's
    public init(classifications: [VNClassificationObservation]) {
        self.classifications = classifications
    }
    
    public func classification(atIndex index: Int) -> (label: String, prediction: Float)? {
        guard index <= self.labelsCount else {
            return nil
        }
        
        let classification = self.classifications[index]
        let label = classification.identifier
        let prediction = String(format: "%.2f", classification.confidence)
        
        return (label, (prediction as NSString).floatValue)
    }
}
