import os
import csv
import sys

def convert_txt_to_csv(path):
    # Obtener la lista de archivos en el directorio "results/"
    files = os.listdir(path)
    trainLen = {"ceb":420,"dje":56,"gmh":496,"izh":763,"lin":159,"mao":145,"mlg":447,"mlt":1233,"tgk":53,"xno":178}
    files.sort(key=lambda x: trainLen[x.split(".")[0]] + int(x.split(".")[1][6:])/100)
    results = []
    langz = files[0].split(".")[0]
    # Crear el archivo CSV de salida
    
    with open(path+"output.csv", "w", newline="") as csvfile:
        writer = csv.writer(csvfile)

        # Escribir el encabezado del CSV
        writer.writerow(["Language", "TrainLen" ,"Factor 1","Factor 30","Factor 50","Factor 70"])

        # Recorrer cada archivo en el directorio
        for file in files:
            # Comprobar si es un archivo de texto

            if file.endswith(".txt"):
                # Leer la primera línea del archivo
                
                lang = file.split(".")[0]
                if lang != langz:
                    writer.writerow([langz, trainLen[langz],results[0],results[1],results[2],results[3]])
                    langz = lang
                    results.clear()
                
                with open(os.path.join(path, file), "r") as txtfile:
                    first_line = str(txtfile.readline().strip()).replace(".", ",")
                    results.append(first_line)

                # Escribir el nombre del archivo y la primera línea en el CSV
        writer.writerow([langz, trainLen[langz],results[0],results[1],results[2],results[3]])
               

    print("CSV generado exitosamente.")

# Ejemplo de uso
if len(sys.argv) > 1:
    if os.path.exists(str(sys.argv[1]) + "output.csv"):
        os.remove(str(sys.argv[1]) + "output.csv") 
    convert_txt_to_csv(str(sys.argv[1]))
else:
    if os.path.exists(str("results/output.csv")):
        os.remove("results/output.csv")
    convert_txt_to_csv("results/")
