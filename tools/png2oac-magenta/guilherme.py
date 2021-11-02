import os
import sys
import magenta

def criaPasta(nome : str):
    try:
        os.mkdir(nome)
    except FileExistsError:
        print(f'A pasta {nome} ja existe. Arquivos repetidos serão reescritos.')
    except:
        print(f"Erro desconhecido ao criar pasta {nome}.")
    else:
        print(f'Pasta criada: {nome}')

FOLDER_PATH = dir_path = os.path.dirname(os.path.realpath(__file__))
print(FOLDER_PATH)
os.chdir(FOLDER_PATH)
imgNames = os.listdir(FOLDER_PATH)

criaPasta('imagensOriginal') 
criaPasta('imagensPNG') 
criaPasta('imagens')    # TODO mudar nome para imagensBMP
criaPasta('S')          # TODO mudar nome para imagensS

if __name__ == "__main__":
    args = sys.argv[1:]
    if len(args) > 0:
        if args[0] == '-transparencia' or '-t':
            for imgName in imgNames:
                if imgName[-4:] == '.png':
                    magenta.transparente2magenta(imgName, 'magenta' + imgName, True, 'png')
                    os.rename(imgName, 'imagensOriginal/' + imgName)
        else:
            print(f'Parametro {args[0]} nao reconhecido. Encerrando.')
            exit()

imgNames = os.listdir(FOLDER_PATH)
# TODO substituir dll e bmp2isc por funcoes opencv
for imgName in imgNames:
    if imgName[-4:] == '.png':
        x = 'png2bmpcmd -i ' + imgName + ' --bmp-bpp=24'
        print(x)
        os.system(x)

        os.rename(imgName, 'imagensPNG/' + imgName)

        # x = 'del '  + imgName
        # os.system(x)

f = open("list.txt", 'w')

# x = 'mkdir imagens'
# os.system(x)

imgNames = os.listdir(FOLDER_PATH)

# TODO extinguir todas as ocorrencias de os.system

for imgNames in imgNames:
    if imgNames[-1] == 'p':
        imgNames = imgNames[:-4]
        x = 'bmp2isc ' + imgNames
        print(x)
        os.system(x)

        x = 'rename ' + imgNames + ".data " + imgNames + 'N.s'
        os.system(x)

        x = 'move ' + imgNames + '.bmp imagens'
        os.system(x)

        f.write(imgNames + 'N.s\n')

f.close()

# TODO substituir necessidade de um arquivo .c usando opencv e padding
x = "resizer"
os.system(x)

f = open("list.txt", "r")

text = f.read()
text = text.strip().split('\n')
newText = []

# x = 'mkdir S'
# os.system(x)

for archive in text:
    x = 'del ' + archive
    os.system(x)
    temp = archive.rsplit('N')
    x = 'move ' + ''.join(temp) + ' S'
    os.system(x)

f.close()

x = 'del list.txt'
os.system(x)