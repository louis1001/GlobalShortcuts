import ApplicationServices

class LoopManager{
    var eventTap: CFMachPort?

    init(_ hotkeyManager: Hotkey){

        func eventCallback(
            proxy: CGEventTapProxy,
            type: CGEventType,
            event: CGEvent,
            refcon: UnsafeMutableRawPointer?)
                -> Unmanaged<CGEvent>?
        {
            let keyCode: Int = Int(event.getIntegerValueField(.keyboardEventKeycode))

            hk.handlePressRelease(keyCode)

            return Unmanaged.passRetained(event)
        }

        let mask =
            (1 << CGEventType.keyDown.rawValue) |
            (1 << CGEventType.keyUp.rawValue)   |
            (1 << CGEventType.flagsChanged.rawValue)

        eventTap = CGEvent.tapCreate(
            tap: .cgSessionEventTap,
            place: .headInsertEventTap,
            options: .defaultTap,
            eventsOfInterest: CGEventMask(mask),
            callback: eventCallback,
            userInfo: nil
        )

        if eventTap == nil {
            print("failed to create event tap")
            exit(1)
        }
    }

    func runLoop(){
        if let et = eventTap {
            let runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, et, 0)
            CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
            CGEvent.tapEnable(tap: et, enable: true)
            CFRunLoopRun()
        } else {
            print("Couldn't start the event loop")
        }
    }
}
