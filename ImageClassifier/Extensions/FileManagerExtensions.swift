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
    
    func sizeOfFile(atPath path: String) -> Int64? {
            guard let attrs = try? attributesOfItem(atPath: path) else {
                return nil
            }

            return attrs[.size] as? Int64
    }
    
    func sizeForLocalFilePath(filePath:String) -> UInt64 {
        do {
            let fileAttributes = try FileManager.default.attributesOfItem(atPath: filePath)
            if let fileSize = fileAttributes[FileAttributeKey.size]  {
                return (fileSize as! NSNumber).uint64Value
            } else {
                print("Failed to get a size attribute from path: \(filePath)")
            }
        } catch {
            print("Failed to get file attributes for local path: \(filePath) with error: \(error)")
        }
        return 0
    }
    func covertToFileString(with size: UInt64) -> String {
        var convertedValue: Double = Double(size)
        var multiplyFactor = 0
        let tokens = ["bytes", "KB", "MB", "GB", "TB", "PB",  "EB",  "ZB", "YB"]
        while convertedValue > 1024 {
            convertedValue /= 1024
            multiplyFactor += 1
        }
        return String(format: "%4.2f %@", convertedValue, tokens[multiplyFactor])
    }
}
