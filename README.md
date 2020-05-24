# Global Shortcuts

A simple utility that let's you set up simple keyboard shortcut events that are being listened to wherever you are on your system. When the shortcut is triggered, the program runs the specific file that you defined on configurations.

---

## Configuration

The configuration file path is hardcoded, but can be changed before compiling.

---

### Configuration syntax

Each configuration command is defined in a single line of the file. Empty lines are ignored.

The kind of commands that can be used are:

- Assignments.
- Keysets.
- Bindings.

#### Assignments

This works like a variable would in a more common programming language.
It stores string.

The syntax is:

`assign variable-name string-value`

A variable can be used in any place that a string value goes. So another variable can have a variable inside. The value of the variable can be taken by typing `${variable-name}`.
For example:
```
assign home "/Users/me"
assign documents "${home}/Documents"
```

#### Keysets

A keyset is a list of different keys that can be used interchangeably in a binding.
The binding can pass the specific key from the script that gets run.

A keyset is defined like this:

`keyset keyset-name keys separated by spaces`

And can be used like this:

```
keyset arrow up down left right
binding ctrl+arrow  "/bin/sh"
```

Which just runs `/bin/sh` whenever we press `ctrl` with any arrow. 

Or like this:

keyset vimkeys h j k l
binding ctrl+shift+vimkeys "/bin/sh $<vimkeys>"

Which runs `/bin/sh` at the press of `ctrl`, `shift` and any ky in the vimkeys keyset,
but also sends the key pressed as vim key through to `sh` (and can be read as $0).

#### Bindings

A binding is the core of this system.
Takes a list of key names, joined by `+`, and a program path as its string value.

The syntax is: `bind keys+names+in+bind program-path`

When this keys are pressed, the program in `program path` is ran.
A keyset name can be used as a key name, and that means 'any of the keys in this set'.

---
An example configuration file can be:

```
assign openapp "open -a"
assign usrhome "/Users/louis1001"
assign scdir "${usrhome}/scripts"

keyset vimk h j k l

keyset num 1 2 3 4 5 6 7 8 9

bind cmd+ctrl+b "${openapp} Firefox"

bind cmd+ctrl+t "${openapp} Terminal"

bind cmd+ctrl+i "${openapp} System\ Preferences"

bind cmd+shift+vimk "${scdir}/echo_params.sh $<vimk>"
```
