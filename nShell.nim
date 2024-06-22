import nigui
import osproc
import std/os
import std/strutils

proc exe(cmd: string): string =
    return execProcess(cmd)

proc makeInput(con: Container): TextBox = 
    var input = newTextBox()
    con.add(input)
    return input

proc makeLabel(con: Container): Label =
    var label = newLabel()
    con.add(label)
    return label


proc split(str: string): seq[string] =
    return rsplit(str, " ")

proc event(tex: TextBox, lab: Label) =
    tex.onKeyDown = proc(event: KeyboardEvent) =
        if $event.key == "Key_Return":
            var spl = split(tex.text)
            lab.text = ""
            if tex.text == "clear":
                lab.text = lab.text & ""
            elif tex.text == "quit":
                quit()
            elif spl[0] == "cd":
                if spl[1] == "~":
                    setCurrentDir(getHomeDir())
                else:
                    try:
                        setCurrentDir(spl[1])
                    except:
                        lab.text = "NOT A DIR"


            else:
                lab.text = lab.text & exe(tex.text)
            tex.text = ""







proc setupWindow(): Window =
    var window = newWindow("nShell")
    window.width = 600.scaleToDpi
    window.height = 400.scaleToDpi
    return window


proc setupContainer(win: Window): Container =
    var container = newLayoutContainer(Layout_Vertical)
    container.padding = 50
    container.frame = newFrame("nShell")
    win.add(container)
    return container



proc main() = 
    app.init()
    var window = setupWindow()
    var container = setupContainer(window)

    var label = makeLabel(container)
    var input = makeInput(container)
    event(input, label)
    window.show()
    app.run()




main()

