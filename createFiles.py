import os
import sys
from augment import augment

#Function that preprocesses one line of the test set getting the input
def preprocessTest(parts):
    input = "< "
    for part in parts[0]:
        input += part + " "
    input += "> " + parts[1].replace(";", " ")
    return input

#Function that preprocesses one line of the dev/train set getting the input and output
def preprocess(parts):
    input = "< "
    for part in parts[0]:
        input += part + " "
    input += "> " + parts[2].replace(";", " ")
    output = "< "
    for part in parts[1]:
        output += part + " "
    output += ">\n"
    return input, output

    
#Function that creates the files
def createFile(file, tag, factor = 2):

    setTI = file.split('.')[-1]
    if setTI == 'trn':
        setT = 'train'
    elif setTI == 'tst':
        setT = 'test'
    else:
        setT = 'dev'
    # Open the file
    f = open(file, 'r')
    # Create a new file
    fileI = open("lang/" + setT + '.' + tag + '.input', 'w')
    if setT != 'test':
        fileO = open("lang/" + setT + '.' + tag + '.output', 'w')
    # Read the file
    lines = f.readlines()
    data = tuple([line.split('\t') for line in lines])
    if setT == 'train' and factor > 1:
        data = augment(data, factor)
    # Iterate through the lines
    for line in data:
        # Split the line
        if setT == 'test':
            input = preprocessTest(line)
            fileI.write(input)
        else:
            input, output = preprocess(line)
            fileI.write(input)
            fileO.write(output)

    # Close the files
    f.close()
    fileI.close()
    if setT != 'test':
        fileO.close()



if __name__ == '__main__':
    # Define the root directory
    root_dir = 'task0-data/'
    tag = sys.argv[1]
    if len(sys.argv) > 2:
        factor = int(sys.argv[2])
    else:
        factor = 2
     
    #Search through the root directory
    for dir in os.listdir(root_dir):
        # Skip the files
        if os.path.isfile(root_dir + dir):
            continue
        #Search through the subdirectories
        for dir2 in os.listdir(root_dir + dir):
            # Skip the files
            if os.path.isfile(root_dir + dir + "/" + dir2):
                continue
            #Search through the subsubdirectories
            for file in os.listdir(root_dir + dir + "/" + dir2):
                #if the tag is in the file name
                if tag in file:
                    # Create the files
                    createFile(root_dir + dir + "/" + dir2 + "/" + file, tag, factor)
