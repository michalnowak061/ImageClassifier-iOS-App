//
//  ModelPathListJSON.swift
//  ImageClassifier
//
//  Created by Michał Nowak on 24/01/2021.
//

import Foundation

struct modelPathListJSON: Codable {
    var firstSave: Bool = true
    var modelNamesList: [String] = []
    var modelPathList: [String] = []
    
    public mutating func setModelPathsList(modelPaths list: [(String, String)]) {
        for model in list {
            modelNamesList.append(model.0)
            modelPathList.append(model.1)
        }
        self.firstSave = false
        if(self.save()) {
            print("modelPathList save ok")
        } else {
            print("modelPathList save error")
        }
    }
    
    public mutating func getModelPathsList() -> [(String, String)] {
        if(self.load()) {
            print("modelPathList load ok")
        } else {
            print("modelPathList load error")
        }
        guard modelNamesList.count != 0 else {
            return []
        }
        var list: [(String, String)] = []
        for index in 0...modelNamesList.count-1 {
            list.append((modelNamesList[index], modelPathList[index]))
        }
        return list
    }
    
    private mutating func load() -> Bool {
        let documentsDirectoryPathString = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let settingsFilePath = documentsDirectoryPathString + "/modelPathList.json"
        if !loadDecodableFromJSON(fromPath: settingsFilePath) {
            return false
        }
        return true
    }
    
    private func save() -> Bool {
        let documentsDirectoryPathString = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let settingsFilePath = documentsDirectoryPathString + "/modelPathList.json"
        if !saveEncodableToJSON(atPath: settingsFilePath) {
            return false
        }
        return true
    }
}

extension Encodable {
    func saveEncodableToJSON(atPath: String) -> Bool {
        do {
            let encodedObject = try JSONEncoder().encode(self)
            FileManager.default.createFile(atPath: atPath, contents: encodedObject, attributes: nil)
            return true
        }
        catch {
            return false
        }
    }
}

extension Decodable {
    mutating func loadDecodableFromJSON(fromPath: String) -> Bool {
        if FileManager.default.fileExists(atPath: fromPath) {
            do {
                let file = FileHandle(forReadingAtPath: fromPath)
                let data = file!.readDataToEndOfFile()
                let settingsDecoded = try JSONDecoder().decode(modelPathListJSON.self, from: data)
                self = settingsDecoded as! Self
                return true
            }
            catch {
                return false
            }
        } else {
            return false
        }
    }
}
