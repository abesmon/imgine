//
//  FileManager+unixPermissioons.swift
//  imgine
//
//  Created by Алексей Лысенко on 12.11.2022.
//

import Foundation
import System

extension FileManager {
    func setUnixPermissions(_ permissions: FilePermissions, atPath: String) throws {
        try FileManager.default.setAttributes(
            [.posixPermissions: permissions.rawValue],
            ofItemAtPath: atPath
        )
    }
}
