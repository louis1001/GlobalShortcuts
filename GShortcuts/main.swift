//
//  main.swift
//  GShortcuts
//
//  Created by Luis Gonzalez on 6/8/19.
//  Copyright © 2019 Luis Gonzalez. All rights reserved.
//

import ApplicationServices
import Foundation

let CONFIG_FILE = "/Users/louis1001/.config/gshortcuts/config"

var customAssignments: [String:String] = [:]

func loadConfiguration() -> String{
    let configs = FileManager.default.contents(atPath: CONFIG_FILE)
    
    if let lines = String(data: configs!, encoding: String.Encoding.utf8) {
        return lines
    }

    return ""
}

let bindings = loadConfiguration()

let hk = Hotkey(configs: bindings)

let lm = LoopManager(hk)

lm.runLoop()
