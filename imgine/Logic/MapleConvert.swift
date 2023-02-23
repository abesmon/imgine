//
//  MapleConvert.swift
//  imgine
//
//  Created by Алексей Лысенко on 12.11.2022.
//

import Foundation
import PythonKit

struct MapleConvert {
    enum Error: Swift.Error {
        case smthStrange
    }

    func convert(ckptURL: URL, destFolderURL destURL: URL) async throws {
        
        let convertions = Python.import("convertions")

        let res = convertions.maple_convert(ckptURL.path(percentEncoded: true), destURL.path(percentEncoded: true))
        if Int(res) == 0 {
            return
        } else {
            throw Error.smthStrange
        }
    }
}
