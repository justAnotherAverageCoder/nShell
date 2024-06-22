import os
import std/osproc
import std/rdstdin
import strutils
import std/terminal
import std/json








proc sEcho(color: ForegroundColor, str: string) =
    stdout.styledWriteLine(color, styleBright, str)

proc read(): string =
    return readLineFromStdin(os.getCurrentDir() & ">")

proc process(s: string): seq[string] =
    return rsplit(s, " ")


proc getConf(): string =
    if fileExists("nShell.conf"):
        return readFile("nShell.conf")
    else:
        writeFile("nShell.conf", $parseJson("""{"color": "fgDefault"}"""))
        return readFile("nShell.conf")

proc stringToFg(str: string): ForegroundColor =
    for x in ForegroundColor:
        if x == parseEnum[ForegroundColor]($(replace($str, """"""", ""))):
            return x
        else:
            discard
    return fgRed






proc exec(cmd: string, color: ForegroundColor) = 
    var splitCmd = process(cmd)
    if splitCmd[0] == "cd":
        try:
            os.setCurrentDir(splitCmd[1])
        except:
            sEcho(fgRed, "NOT A DIR")
    elif cmd == "quit":
        quit()
    else:
        var res = execProcess(cmd)
        res.removeSuffix("\n")
        sEcho(color, res)



proc main() =
    let configs = parseJson(getConf())
    while true:
        exec(read(), stringToFg($configs["color"]))


main()



