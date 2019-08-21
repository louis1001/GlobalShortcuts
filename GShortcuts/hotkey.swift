

import Foundation

class Hotkey {
    var bindings: [Binding]
    var modifiers: [Key]
    
    var customAssignments: [String:String] = [:]
    
    var customKeySets: [String: [Int]]
    
    func parseAssignment(_ line: String) -> String{
        let pattern = #"\$\{(\w[\w\d]*)\}"#
        var parsedLine = line

        return parsedLine.replace(original: pattern, basedOn: { values in customAssignments[values[1]]! })
    }
    
    init(configs: String){
        self.bindings = []
        self.modifiers = []
        self.customKeySets = [:]

        var bind_lines: [String] = []

        let config_lines: [String] = configs.splitBy(sep: "\n")

        for line in config_lines{
            let split_line = line.splitBy()

            let cmd_name = split_line.first!.lowercased()

            if cmd_name == "bind"{
                let commandStr = split_line[2...].joined(separator: " ")
                bind_lines.append("\(split_line[1].lowercased()) \"\(parseAssignment(commandStr))\"")
            } else if cmd_name == "assign" {
                customAssignments[split_line[1]] = parseAssignment(split_line[2...].joined(separator: " "))
            } else if cmd_name == "keyset" {
                let setKeys = Array(split_line[2...].map { x in Keycodes.findKeyCode(x) }.joined())
                self.customKeySets[split_line[1]] = setKeys
            }
        }

        var newBinds: [Binding] = []
        var myModifiers: [Key] = []

        for bind in bind_lines{
            let splitBind = bind.splitBy()
            
            let keys = splitBind[0]
            let command = splitBind[1]
            
            var bindKeys: [Key] = []
            var bindMods: [Key] = []
            
            for splitKey in keys.splitBy(sep: "+") {
                var foundMod = false
                for knownMod in myModifiers {
                    if knownMod.name == splitKey{
                        bindMods.append(knownMod)
                        foundMod = true
                        break
                    }
                }

                if !foundMod{
                    let newKey = Keycodes.findKey(splitKey, customKeys: self.customKeySets)
                    if newKey.isModifier{
                        myModifiers.append(newKey)
                        bindMods.append(newKey)
                    } else {
                        bindKeys.append(newKey)
                    }
                }
            }

            let b: Binding = Binding(keys: bindKeys, modifiers: bindMods, command: command)
            print(b.toString())

            newBinds.append(b)
        }

        self.bindings = newBinds
        self.modifiers = myModifiers
    }

    func handlePressRelease(_ keycode: Int){
        var foundInMods = false

        for mod in modifiers{
            if mod.isValidCode(keycode){

                if mod.isPressed(){
                    mod.Release()
                } else {
                    mod.Press(keycode)
                }

                foundInMods = true
                break
            }
        }

        if !foundInMods{
            for var bind in bindings{
                bind.handlePressRelease(keycode)
                bind.updateCommands()
            }
        }
    }
}
