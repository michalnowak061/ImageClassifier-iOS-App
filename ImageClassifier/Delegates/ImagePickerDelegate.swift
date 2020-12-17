//
//  ImagePickerDelegate.swift
//  ImageClassifier
//
//  Created by Michał Nowak on 16/12/2020.
//
import UIKit

public protocol ImagePickerDelegate: class {
    func didSelect(image: UIImage?)
}
