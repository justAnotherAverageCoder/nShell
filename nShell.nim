import nigui
import osproc


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

proc event(tex: TextBox, lab: Label) =
    tex.onKeyDown = proc(event: KeyboardEvent) =
        if $event.key == "Key_Return":
            lab.text = ""
            if tex.text == "clear":
                lab.text = lab.text & ""
            elif tex.text == "quit":
                quit()
            else:
                echo tex.text
                lab.text = lab.text & exe(tex.text)
            tex.text = ""







proc setupWindow(): Window =
    var window = newWindow("nShell")
    window.width = 600.scaleToDpi
    window.height = 400.scaleToDpi
    return window


proc setupContainer(win: Window): Container =
    var container = newLayoutContainer(Layout_Vertical)
    win.add(container)
    return container



proc main() = 
    app.init()
    var window = setupWindow()
    var container = setupContainer(window)

    var input = makeInput(container)
    var label = makeLabel(container)
    event(input, label)
    window.show()
    app.run()




main()

