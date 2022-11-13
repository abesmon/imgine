//
//  ModelsRepository.swift
//  imgine
//
//  Created by Алексей Лысенко on 12.11.2022.
//

import Foundation
import Combine
import ZIPFoundation
import System

public typealias ProgressClosure = (Double) -> Void

@MainActor
class ModelsRepository: ObservableObject {
    enum Error: Swift.Error {
        case unsupportedURL
    }
    
    @Published private(set) var models: [Model] = []
    
    private let fileManager = FileManager.default
    private var applicationFolder: URL { try! fileManager.url(for: .applicationDirectory, in: .userDomainMask, appropriateFor: nil, create: true) }
    private var modelsFolder: URL { applicationFolder.appendingPathComponent("Models", isDirectory: true) }
    private var modelsPathsList: [URL] {
        ((try? fileManager.contentsOfDirectory(atPath: modelsFolder.path)) ?? []).map {
            modelsFolder.appendingPathComponent($0, isDirectory: true)
        }
    }
    
    init() {
        if !fileManager.fileExists(atPath: modelsFolder.path) {
            try? fileManager.createDirectory(atPath: modelsFolder.path, withIntermediateDirectories: true)
        }
        
        for modelFolder in modelsPathsList {
            if modelFolder.lastPathComponent.hasPrefix(".") { continue }
            let modelName = modelFolder.lastPathComponent.removingPercentEncoding ?? modelFolder.lastPathComponent
            models.append(Model(name: modelName, modelFolder: modelFolder))
        }
        
        if models.isEmpty {
            Task { await appendDefaultModel() }
        }
    }
    
    private func appendDefaultModel() async {
        guard let defaultModelArchive = Bundle.main.url(forResource: "SDModel", withExtension: "zip") else { return }
        
        do {
            let model = try await makeModel(fromArchiveURL: defaultModelArchive, modelName: "Default Model")
            models.append(model)
        } catch {
            return
        }
    }
    
    private func makeModelFromArchive(archiveURL url: URL, completion: ProgressClosure? = nil) async throws -> URL {
        let cacheFolder = try fileManager.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let modelFolderName = UUID().uuidString
        let finalLocalUrl = cacheFolder.appendingPathComponent(modelFolderName, isDirectory: true)
        
        let progress = Progress()
        var bin = Set<AnyCancellable>()
        progress.publisher(for: \.fractionCompleted)
            .map { Double(integerLiteral: $0) }
            .sink { value in
                completion?(value)
            }.store(in: &bin)
        try FileManager.default.unzipItem(at: url, to: finalLocalUrl, progress: progress)
        
        let subdirs = (try? fileManager.contentsOfDirectory(atPath: finalLocalUrl.path)) ?? []
        if subdirs.count <= 1, let nestedFolder = subdirs.first {
            return finalLocalUrl.appendingPathComponent(nestedFolder, isDirectory: true)
        } else {
            return finalLocalUrl
        }
    }
    
    private func makeModel(fromArchiveURL archiveURL: URL, modelName: String) async throws -> Model {
        let tempFolder = try await makeModelFromArchive(archiveURL: archiveURL)
        return try await makeModel(fromFolder: tempFolder, modelName: modelName, deleteSourceFolder: true)
    }
    
    private func makeModel(fromFolder sourceFolder: URL, modelName: String, deleteSourceFolder: Bool) async throws -> Model {
        defer {
            if deleteSourceFolder {
                try? fileManager.removeItem(atPath: sourceFolder.absoluteString)
            }
        }
        
        let newModelFolder = modelsFolder.appendingPathComponent(modelName, isDirectory: true)
        try fileManager.copyItem(at: sourceFolder, to: newModelFolder)
        
        try fileManager.validateFileAndReplaceIfNeeded(fileFolder: newModelFolder,
                                                       fileName: "alphas_cumprod_prev.bin",
                                                       resourceToReplaceWith: ("alphas_cumprod_prev", "bin"))
        try fileManager.validateFileAndReplaceIfNeeded(fileFolder: newModelFolder,
                                                       fileName: "alphas_cumprod.bin",
                                                       resourceToReplaceWith: ("alphas_cumprod", "bin"))
        
        return Model(name: modelName, modelFolder: newModelFolder)
    }
    
    private func makeModel(fromCheckpoint ckptURL: URL, modelName: String) async throws -> Model {
        let cacheFolder = try fileManager.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let modelFolderName = UUID().uuidString
        let tempModelFolder = cacheFolder.appendingPathComponent(modelFolderName, isDirectory: true)
        
        try await MapleConvert().convert(ckptURL: ckptURL, destFolderURL: tempModelFolder)
        
        return try await makeModel(fromFolder: tempModelFolder, modelName: modelName, deleteSourceFolder: true)
    }
    
    // MARK: public
    @discardableResult
    func addModel(from url: URL, modelName: String) async throws -> Model {
        if url.isFileURL {
            if url.hasDirectoryPath {
                let model = try await makeModel(fromFolder: url, modelName: modelName, deleteSourceFolder: false)
                DispatchQueue.main.async { self.models.append(model) }
                return model
            } else {
                if fileManager.isCheckpoint(atPath: url.path) {
                    throw Error.unsupportedURL
//                    let model = try await makeModel(fromCheckpoint: url, modelName: modelName)
//                    DispatchQueue.main.async { self.models.append(model) }
//                    return model
                } else {
                    let model = try await makeModel(fromArchiveURL: url, modelName: modelName)
                    DispatchQueue.main.async { self.models.append(model) }
                    return model
                }
            }
        } else {
            throw Error.unsupportedURL
        }
    }
    
    func remove(model: Model) {
        do {
            try fileManager.removeItem(atPath: model.modelFolder.path)
            models.removeAll { $0.id == model.id }
        } catch {
            print(error.localizedDescription)
        }
    }
}
