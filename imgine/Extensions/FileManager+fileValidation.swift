//
//  FileManager+fileValidation.swift
//  imgine
//
//  Created by Алексей Лысенко on 12.11.2022.
//

import Foundation

extension FileManager {
    func validateFileAndReplaceIfNeeded(fileFolder: URL, fileName: String, resourceToReplaceWith: (String, String)) throws {
        let validatingURL = fileFolder.appendingPathComponent(fileName)
        if !fileExists(atPath: validatingURL.path),
           let replacor = Bundle.main.url(forResource: resourceToReplaceWith.0, withExtension: resourceToReplaceWith.1) {
            try copyItem(at: replacor, to: validatingURL)
        }
    }
}
