//
//  MapleConvert.swift
//  imgine
//
//  Created by Алексей Лысенко on 12.11.2022.
//

import Foundation
import PythonKit

struct MapleConvert {
    func setup(fileManager: FileManager) throws -> URL {
        let appSupportFolder = try fileManager.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let mapleConvertPath = appSupportFolder.appendingPathComponent("maple-convert.py")
        if fileManager.fileExists(atPath: mapleConvertPath.path) {
            try fileManager.setUnixPermissions([.ownerReadWriteExecute, .groupReadWriteExecute, .otherReadWriteExecute],
                                               atPath: mapleConvertPath.path)
            
            return mapleConvertPath
        } else {
            let convertScriptPath = Bundle.main.url(forResource: "maple-convert", withExtension: "py")!
            try fileManager.copyItem(at: convertScriptPath, to: mapleConvertPath)
            try fileManager.setUnixPermissions([.ownerReadWriteExecute, .groupReadWriteExecute, .otherReadWriteExecute],
                                               atPath: mapleConvertPath.path)
            
            return mapleConvertPath
        }
    }
    
    func convert(ckptURL: URL, destFolderURL destURL: URL) async throws {
        let convertScriptPath = Bundle.main.url(forResource: "maple-convert", withExtension: "py")!
        
        let shell = Shell()
        let installLibsRes = try await shell.asyncExecute(
            executable: "/usr/bin/env",
            arguments: ["python3", "-m", "pip", "install", "--no-input", "torch", "torchvision", "torchaudio", "numpy"]
        )
        print(installLibsRes)
        
        let res = try await shell.asyncExecute(
            executable: "/usr/bin/env",
            arguments: [
                "python3",
                convertScriptPath.path,
                ckptURL.path,
                destURL.path
            ]
        )
        print(res)
    }
}

struct Shell {
    func getPythonExecutable() -> String {
        return "/opt/anaconda3/bin/python"
    }
    
    func executePython(scriptPath: String, arguments: [String]) throws -> String? {
        try execute(executable: getPythonExecutable(), arguments: [scriptPath] + arguments)
    }
    
    func asyncExecutePython(scriptPath: String, arguments: [String]) async throws -> String? {
        try await asyncExecute(executable: getPythonExecutable(), arguments: [scriptPath] + arguments)
    }
    
    func execute(executable: String, arguments: [String]) throws -> String? {
        let task = Process()
        let pipe = Pipe()
        
        task.standardOutput = pipe
        task.standardError = pipe
        task.executableURL = URL(fileURLWithPath: executable)
        task.arguments = arguments.map { $0.replacingOccurrences(of: " ", with: "\\ ") }
        
        task.standardInput = nil
        try task.run()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        return String(data: data, encoding: .utf8)
    }
    
    func asyncExecute(executable: String, arguments: [String]) async throws -> String? {
        
        try await withCheckedThrowingContinuation { c in
//            do {
//                let process = try Process.run(
//                    URL(fileURLWithPath: executable),
//                    arguments: arguments) { p in
//                        let pipe = p.standardOutput as? Pipe
//                        let fileHandle = p.standardOutput as? FileHandle
//                        if let data = (pipe?.fileHandleForReading ?? fileHandle)?.readDataToEndOfFile() {
//                            c.resume(returning: String(data: data, encoding: .utf8))
//                        } else {
//                            c.resume(returning: nil)
//                        }
//                    }
//            } catch {
//                c.resume(throwing: error)
//            }
            DispatchQueue.global(qos: .background)
                .async {
                    do {
                        let res = try execute(executable: executable, arguments: arguments)
                        c.resume(returning: res)
                    } catch {
                        c.resume(throwing: error)
                    }
                }
        }
    }
}
