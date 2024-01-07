import os

# Define the directory path
directory = "lang/"

# Define the file names
all_train_input = open(os.path.join(directory, "train.all.input"), "w")
all_train_output = open(os.path.join(directory, "train.all.output"), "w")
all_dev_input = open(os.path.join(directory, "dev.all.input"), "w")
all_dev_output = open(os.path.join(directory, "dev.all.output"), "w")

# Loop through each language directory
files = os.listdir(directory)
files.sort()
for fileN in files:
    
    file_path = os.path.join(directory, fileN)
    
    # Read the content of the file
    with open(file_path, "r") as file:
        content = file.read()
    
    # Write the content to the corresponding new file
    if "dev" in fileN and "input" in fileN:
        all_dev_input.write(content)
    elif "dev" in fileN and "output" in fileN:
        all_dev_output.write(content)
    elif "train" in fileN and "input" in fileN:
        all_train_input.write(content)
    elif "train" in fileN and "output" in fileN:
        all_train_output.write(content)
    
# Close the new files
all_train_input.close()
all_train_output.close()
all_dev_input.close()
all_dev_output.close()
