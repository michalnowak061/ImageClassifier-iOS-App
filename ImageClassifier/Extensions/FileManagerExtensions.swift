//
//  FileManagerExtensions.swift
//  ImageClassifier
//
//  Created by Michał Nowak on 18/12/2020.
//

import Foundation

extension FileManager {
    func getFileName(withPath path: String) -> String {
        let fileName = URL(fileURLWithPath: path).lastPathComponent
        return fileName
    }
    
    func extractFileCreatedDate(withPath path: String) -> String {
        var dateString = ""
        do {
            let aFileAttributes = try FileManager.default.attributesOfItem(atPath: path) as [FileAttributeKey:Any]
            let theCreationDate = aFileAttributes[FileAttributeKey.creationDate] as? Date ?? Date()

            let formatter: DateFormatter = DateFormatter()
            formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
            formatter.timeZone = TimeZone.init(abbreviation: "GMT")
            formatter.dateFormat = "dd-MM-yyyy HH:mm:ss"

            //MARK:- Share App Submit Date
            let readDate: String = formatter.string(from: theCreationDate)
            dateString = readDate
        } catch let theError {
            print("file not found \(theError)")
        }
        return dateString
    }
    
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
    
    public func secureCopyItem(at srcURL: URL, to dstURL: URL) -> Bool {
        do {
            if FileManager.default.fileExists(atPath: dstURL.path) {
                try FileManager.default.removeItem(at: dstURL)
            }
            try FileManager.default.copyItem(at: srcURL, to: dstURL)
        } catch (let error) {
            print("Cannot copy item at \(srcURL) to \(dstURL): \(error)")
            return false
        }
        return true
    }
}
