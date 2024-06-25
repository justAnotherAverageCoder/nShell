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


proc history(str: string, his: seq[string]): seq[string] =
    var ret = his
    if his.len() >= 26:
        ret = @[""]
    else:
        ret.add(str)
        return ret

proc returnBehavior(lab: Label, box: TextBox) =
    var spl = split(box.text)
    lab.text = ""
    if box.text == "clear":
        lab.text = lab.text & ""
    elif box.text == "quit":
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
        lab.text = lab.text & exe(box.text)
    box.text = ""


proc upBehavior(lab: Label, box: TextBox, coun: int, his: seq[string]) =
    try:
        box.text = his[his.len - coun - 1]
    except:
        lab.text = "TOO FAR"


proc downBehavior(lab: Label, box: TextBox, coun: int, his: seq[string]) =
    if coun == 0:
        box.text = ""
    elif coun != 0:
        try:
            box.text = his[coun - 1]
        except:
            lab.text = "TOO FAR"





    




proc event(tex: TextBox, lab: Label) =
    var his = @[""]
    var count = 0
    tex.onKeyDown = proc(event: KeyboardEvent) =
        echo his
        echo count
        if $event.key == "Key_Return":
            his = history($tex.text, his)
            returnBehavior(lab, tex)
            count = 0
        elif $event.key == "Key_Up":
            if count > his.len():
                discard
            else:
                upBehavior(lab, tex, count, his)
                count = count + 1
        elif $event.key == "Key_Down":
            if count <=  0:
                discard
            else:
                downBehavior(lab, tex, count, his)
                count = count - 1

        








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

