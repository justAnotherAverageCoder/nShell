import os
import std/osproc
import std/rdstdin
import strutils
import std/terminal

proc sEcho(color = fgCyan, str: string) =
    stdout.styledWriteLine(color, styleBright, str)

proc read(): string =
    return readLineFromStdin(os.getCurrentDir() & "> ")

proc process(s: string): seq[string] =
    return rsplit(s, " ")




proc exec(cmd: string) = 
    var splitCmd = process(cmd)
    if splitCmd[0] == "cd":
        try:
            os.setCurrentDir(splitCmd[1])
        except:
            sEcho(fgRed, "NOT A DIR")
    elif cmd == "quit":
        quit()
    else:
        var y = execProcess(cmd)
        y.removeSuffix("\n")
        sEcho(fgYellow, y)



proc main() =
    while true:
        var read = read()
        exec(read)


main()



