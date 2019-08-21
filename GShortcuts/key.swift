
class Key{
    var keycodes: [Int]
    var name: String
    var pressed: Int
    var isModifier: Bool

    init(_ name_: String, codes keycodes: [Int], isModifier isModifier_: Bool = false){
        self.name = name_
        self.keycodes = keycodes
        self.pressed = -1
        self.isModifier = isModifier_
    }

    func isPressed() -> Bool{
        return self.pressed != -1
    }

    func isValidCode(_ keycode: Int) -> Bool{
        if isPressed(){
            return keycode == pressed
        }

        return keycodes.contains(keycode)
    }

    func Press(_ keycode: Int){
        self.pressed = keycode
    }

    func Release(){
        self.pressed = -1
    }
}
