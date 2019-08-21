//
//  codeRunner.swift
//  GShortcuts
//
//  Created by Luis Gonzalez on 6/8/19.
//  Copyright © 2019 Luis Gonzalez. All rights reserved.
//

import Foundation

func execCommand(command: String) -> String {
    
    print("running command \(command)")
    
    let task = Process()
    task.launchPath = "/bin/sh"
    task.arguments = ["-c", command]

    let pipe = Pipe()
    task.standardOutput = pipe
    task.launch()

    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output: String = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String

    return output
}
