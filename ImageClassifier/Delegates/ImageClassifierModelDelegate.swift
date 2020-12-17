//
//  ImageClassifierModelDelegate.swift
//  ImageClassifier
//
//  Created by Michał Nowak on 16/12/2020.
//
import Foundation

public protocol ImageClassifierModelDelegate: class {
    func predictionReady(prediction: String?)
}
