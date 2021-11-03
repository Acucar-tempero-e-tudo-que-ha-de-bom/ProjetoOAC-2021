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
        writer.write(f"{newFilename.upper()}:\t.byte\n\t\t")
        
        linhas = []
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
                # Marrom (120, 50, 0) == 3 (trampolim)
                elif r == 120 and g == 50 and b == 0:
                    linha.append('3')
                    continue
                # Laranja (255, 100, 0) == 4 (fase 1 pra fase 2)
                elif r == 255 and g == 100 and b == 0:
                    linha.append('4')
                    continue
                # Rosa (255, 0, 100) == 5 (fase 2 pra fase 3)
                elif r == 255 and g == 0 and b == 100:
                    linha.append('5')
                # Azul (0, 150, 255) == 7 (fase 3 para fase 4)
                elif r == 0 and g == 150 and b == 255:
                    linha.append('7')
                    continue
                # Amarelo (255, 255, 0) == 8 (fase 4 para fase 5)
                elif r == 255 and g == 255 and b == 0:
                    linha.append('8')
                    continue
                # Verde (0, 255, 0) == 2 + [idx] (refill)
                elif g == 255 and b == 0:
                    linha.append('2' + str(r))
                    continue
                
                # Cor desconhecida
                else:
                    print(f"Cor desconhecida: {r} {g} {b}")
            linhas.append(', '.join(linha))
        writer.write(',\n\t\t'.join(linhas))
        print('Done!')
        sys.exit(0)
else:
    print('Uso: map2s.py <arquivo.bmp>')
    sys.exit(2)
