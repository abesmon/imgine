//
//  imgineApp.swift
//  imgine
//
//  Created by Алексей Лысенко on 12.11.2022.
//

import SwiftUI
import Python
import PythonKit

@main
struct imgineApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    let resourcesPath = "Python/Resources"
                    let pythonStdLib = "\(resourcesPath)/python-stdlib"
                    guard let stdLibPath = Bundle.main.path(forResource: pythonStdLib, ofType: nil) else { return }
                    guard let libDynloadPath = Bundle.main.path(forResource: "\(pythonStdLib)/lib-dynload", ofType: nil) else { return }
                    guard let appPackages = Bundle.main.path(forResource: "\(resourcesPath)/app_packages", ofType: nil) else { return }
                    guard let appScripts = Bundle.main.path(forResource: "\(resourcesPath)/app_scripts", ofType: nil) else { return }
                    setenv("PYTHONHOME", stdLibPath, 1)
                    setenv("PYTHONPATH", "\(stdLibPath):\(libDynloadPath):\(appPackages):\(appScripts)", 1)
                    Py_Initialize()

                    let convertions = Python.import("convertions")
                    print(convertions)
//                    let random = Python.import("random")
////
//                    print(Python.hasattr(random, "randint"))
//                    if let numpy = try? Python.attemptImport("numpy") {
//                        print("numpy sucessfully made it here: \(numpy)")
//                    } else {
//                        print("fuck")
//                    }

//                    if let pythonPath = Bundle.main.path(forResource: "Python/Resources/python-stdlib", ofType: nil) {
//                        print(pythonPath)
//                        setenv("PYTHONPATH", pythonPath, 1)
//                        setenv("PYTHONHOME", pythonPath, 1)
//                        let random = Python.import("random")
//                        if let random = try? Python.attemptImport("random") {
//                            print(random)
//                        }
//                    }
//                    if let numpy = try? Python.attemptImport("numpy") {
//                        print(numpy)
//                    }
//                    print(getenv("PYTHONHOME"))
//                    print(getenv("PYTHONPATH"))
//                    setenv("PYTHONHOME", "")
//                    Py_Initialize()
                }
        }
    }
}
