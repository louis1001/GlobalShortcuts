
struct Binding{
    var keys: [Key]
    var modifiers: [Key]
    
    var commandActivated: Bool = false
    
    var command: String
    
    init(keys: [Key], modifiers: [Key], command: String){
        self.keys = keys
        self.modifiers = modifiers
        self.command = command

        self.commandActivated = false
    }

    func handlePressRelease(_ keycode: Int){
        for k in keys{
            if k.isValidCode(keycode) {
                if k.isPressed(){
                    k.Release()
                } else if allModsPressed(){
                    k.Press(keycode)
                }
            }
        }
    }

    func allModsPressed() -> Bool{
        return (modifiers.filter{mod in !mod.isPressed()}.count) == 0
    }

    func allKeysPressed() -> Bool{
        return (keys.filter{mod in !mod.isPressed()}.count) == 0
    }

    func findKeyInMe(_ name: String) -> Key?{
        let allK = modifiers + keys
        let keysStr = allK.filter({ $0.name == name })

        if let theKey = keysStr.first {
            return theKey
        }

        return nil
    }

    mutating func updateCommands(){
        if allModsPressed(){
            if allKeysPressed() && !commandActivated {
                commandActivated = true
                // run command
                var runnableCommand = command

                runnableCommand = runnableCommand.replace(original: #"\$\<(\w[\w\d]*)\>"#, basedOn: { matches in
                    let theKey = findKeyInMe(matches[1])
                    guard let pressedVal = theKey?.pressed, pressedVal != -1 else {
                        print("hello")
                        return matches[1]
                    }

                    print("hi \(pressedVal)")

                    let found = Keycodes.findKey(pressedVal) ?? ""

                    print("f: \(found)")

                    return found
                })

                let _ = execCommand(command: command)
            } else {
                commandActivated = false
            }
        } else {
            commandActivated = false

            for key in keys {
                key.Release()
            }
        }
    }

    func toString() -> String{
        let allK = modifiers + keys
        let keysStr = allK.map( { x in x.name } ).joined(separator: "+")

        return "Binding(\(keysStr), '\(self.command)')"
    }
}
