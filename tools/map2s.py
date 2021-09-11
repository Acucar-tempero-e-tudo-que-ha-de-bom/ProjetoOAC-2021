import sys

def readBmp(filename):
    pixeis = {}
    
    with open(filename, 'rb') as reader:
        header = reader.read(54)
        
        width = int.from_bytes(header[18:22], byteorder='little')
        height = int.from_bytes(header[22:26], byteorder='little')
        
        padding = 0
        while (width * 3 + padding) % 4 != 0:
            padding += 1
        
        newWidth = width * 3 + padding
        for i in range(height):
            linha = reader.read(newWidth)
            for j in range(0, width * 3, 3):
                index = (i * width * 3) + j
                pixeis[index] = linha[j + 2]
                pixeis[index + 1] = linha[j + 1]
                pixeis[index + 2] = linha[j + 0]
        return pixeis, width, height

if len(sys.argv) == 2:
    filename = sys.argv[1]
    pixeis, width, height = readBmp(filename)
    
    print(width, 'x', height)
    
    newFilename = filename[:-4]
    ext = '.s'
    with open(newFilename + ext, 'w') as writer:
        writer.write(f"{newFilename}:\t.byte")
        
        for i in range(0, height, 8):
            linha = []
            for j in range(0, width, 8):
                index = ((height - 1 - i) * width + j) * 3
                r = pixeis[index]
                g = pixeis[index + 1]
                b = pixeis[index + 2]
                
                # Preto (0, 0, 0) == 0 (nada)
                if r == 0 and g == 0 and b == 0:
                    linha.append('0')
                    continue
                # Branco (255, 255, 255) == 1 (parede)
                elif r == 255 and g == 255 and b == 255:
                    linha.append('1')
                    continue
                # Vermelho (255, 0, 0) == 2 (espinho)
                elif r == 255 and g == 0 and b == 0:
                    linha.append('2')
                    continue
                else:
                    print(f"Cor desconhecida: {r} {g} {b}")
            writer.write(f"\n{', '.join(linha)},")
        print('Done!')
        sys.exit(0)
else:
    print('Uso: map2s.py <arquivo.bmp>')
    sys.exit(2)
