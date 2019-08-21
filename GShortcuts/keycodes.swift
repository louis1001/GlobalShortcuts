
struct Keycodes {
    static let keyCodes: [Character: Int] = [
        "a" : 0x00,
        "s" : 0x01,
        "d" : 0x02,
        "f" : 0x03,
        "h" : 0x04,
        "g" : 0x05,
        "z" : 0x06,
        "x" : 0x07,
        "c" : 0x08,
        "v" : 0x09,
        "b" : 0x0B,
        "q" : 0x0C,
        "w" : 0x0D,
        "e" : 0x0E,
        "r" : 0x0F,
        "y" : 0x10,
        "t" : 0x11,
        "1" : 0x12,
        "2" : 0x13,
        "3" : 0x14,
        "4" : 0x15,
        "6" : 0x16,
        "5" : 0x17,
        "=" : 0x18,
        "9" : 0x19,
        "7" : 0x1A,
        "-" : 0x1B,
        "8" : 0x1C,
        "0" : 0x1D,
        "]" : 0x1E,
        "o" : 0x1F,
        "u" : 0x20,
        "[" : 0x21,
        "i" : 0x22,
        "p" : 0x23,
        "l" : 0x25,
        "j" : 0x26,
        "\"": 0x27,
        "k" : 0x28,
        ";" : 0x29,
        "\\": 0x2A,
        "," : 0x2B,
        "/" : 0x2C,
        "n" : 0x2D,
        "m" : 0x2E,
        "." : 0x2F,
        "`" : 0x32
    ]

    /* keycodes for keys that are independent of keyboard layout*/
    static let nonPrintableKeyCodes: [String:Int] = [
        "return"       : 0x24,
        "tab"          : 0x30,
        "space"        : 0x31,
        "delete"       : 0x33,
        "escape"       : 0x35,
        "capslock"     : 0x39,
        "fn"           : 0x3F,
        "f5"           : 0x60,
        "f6"           : 0x61,
        "f7"           : 0x62,
        "f3"           : 0x63,
        "f8"           : 0x64,
        "f9"           : 0x65,
        "f11"          : 0x67,
        "f10"          : 0x6D,
        "f12"          : 0x6F,
        "f4"           : 0x76,
        "f2"           : 0x78,
        "f1"           : 0x7A,
        "left"         : 0x7B,
        "right"        : 0x7C,
        "down"         : 0x7D,
        "up"           : 0x7E
    ]

    static let specialKeyCodes: [String:Int] = [
        "cmd_l"        : 0x37,
        "cmd_r"        : 0x36,
        "shift_l"      : 0x38,
        "shift_r"      : 0x3C,
        "option_l"     : 0x3A,
        "option_r"     : 0x3D,
        "alt_l"        : 0x3A,
        "alt_r"        : 0x3D,
        "ctrl"         : 0x3B
    ]

    static let equivalentCodes: [String:[Int]] = [
        "cmd"          : [0x37, 0x36],  // cmd_l cmd_r
        "shift"        : [0x38, 0x3C],  // shift_l shift_r
        "option"       : [0x3A, 0x3D],  // option_l option_r
        "alt"          : [0x3A, 0x3D],  // alt_l alt_r
        "num"          : [
            0x1D,   // 0
            0x12,   // 1
            0x13,   // 2
            0x14,   // 3
            0x15,   // 4
            0x17,   // 5
            0x16,   // 6
            0x1A,   // 7
            0x1C,   // 8
            0x19    // 9
        ]
    ]
    
    static func findKeyCode(_ key: String) -> [Int] {
        
        var newKeyC: [Int] = []

        if key.count == 1, let theKeycode = keyCodes[key[0]] {
            newKeyC.append(theKeycode)
        } else if let theKeycode = nonPrintableKeyCodes[key] {
            newKeyC.append(theKeycode)
        } else if let equCodes = equivalentCodes[key]{
            newKeyC = equCodes
        }

        assert(!newKeyC.isEmpty, "The key \(key) wasn't found.")

        return newKeyC
    }

    static func findKey(_ key: String, customKeys: [String: [Int]] = [:]) -> Key{
        // Look in every dictionary of keycodes.
        // Maybe return the fact that it is or isn't a Modifier key

        var newKeyC: [Int] = []
        var isSpecial = false

        if key.count == 1, let theKeycode = keyCodes[key[0]] {
            newKeyC.append(theKeycode)
        } else if let theKeycode = nonPrintableKeyCodes[key] {
            newKeyC.append(theKeycode)
        } else if let customCodes = customKeys[key] {
            newKeyC = customCodes
        } else if let equCodes = equivalentCodes[key]{
            isSpecial = true
            newKeyC = equCodes
        } else if let theKeycode = specialKeyCodes[key] {
            isSpecial = true
            newKeyC.append(theKeycode)
        }

        assert(!newKeyC.isEmpty, "The key \(key) wasn't found.")

        let theKey = Key(key, codes: newKeyC, isModifier: isSpecial)

        return theKey;
    }

    static func findKey(_ keycode: Int) -> String?{
        for (val, kc) in keyCodes {
            if kc == keycode{
                return String(val)
            }
        }

        for (val, kc) in nonPrintableKeyCodes {
            if kc == keycode{
                return String(val)
            }
        }

        for (val, kc) in specialKeyCodes {
            if kc == keycode{
                return String(val)
            }
        }

        return nil
    }
}
