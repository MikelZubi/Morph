import sys

language = sys.argv[1]
filename = "lang/test."+language+".output"
fileO = open("test/tst."+language+".output", "w")
with open(filename, "r") as file:
    for line in file:
        lineP = "AA " +"\t" + line.replace(" ", "").replace(">", "").replace("<", "")
        fileO.write(lineP)
fileO.close()