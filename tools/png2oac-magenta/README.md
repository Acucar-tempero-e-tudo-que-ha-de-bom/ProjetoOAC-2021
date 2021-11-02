# png2oac

## Versão BETA magenta

Para transformar o transparente do png em um magenta reconhecível pelo RARs, compile o resizer.c "gcc -o resizer.exe resizer.c" e execute o guilherme.py com a flag -t "python guilherme.py -t"

Esses passos são feitos automaticamente pelo magenta.bat

OBS.: PROGRAMA ATUALMENTE FUNCIONA APENAS NO WINDOWS

## Descrição

O projeto consiste em um conversor automático de png para arquivos .s (assembly) RISC-V, que redimensiona as imagens para largura múltipla de 4, e altura par (facilitando a programação em assembly, pois é *word-adressing*), sendo o público alvo os alunos de Introdução a Sistemas Computacionais (ISC) e Organização e Arquitetura de Computadores (OAC) da Universidade de Brasília (UnB).

Os programas contidos nesse repositório foram criados no semestre 2020.1, para uso próprio no trabalho final de OAC, com exceção do [png2bmp](http://www.easy2convert.com/png2bmp/), e do bmp2isc, que foi feito pelo professor Marcus Vinícius Lamar.

## Como usar

Coloque todos os arquivos png que você quer que sejam convertidos em uma pasta, junto com os programas deste repositório. Em seguida, execute o programa `guilherme.py`

Todas as imagens convertidas para `.bmp` estarão um uma pasta separada das imagens convertidas em `.s`