//
//  FileManagerExtensions.swift
//  ImageClassifier
//
//  Created by Michał Nowak on 18/12/2020.
//

import Foundation

extension FileManager {
    func getFileListFromDirectory(withPath path: String, typeOf type: String) -> [(name: String, path: String)] {
        do {
            let files = try FileManager.default.contentsOfDirectory(atPath: path)
            var filesWithType: [(name: String, path: String)] = []
            for fileName in files {
                if fileName.contains(type) {
                    filesWithType.append((fileName, path + "/" + fileName))
                }
            }
            return filesWithType
        } catch {
            return []
        }
    }
}
