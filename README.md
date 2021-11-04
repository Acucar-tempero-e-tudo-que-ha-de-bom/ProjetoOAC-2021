# Projeto Final - Celeste

Projeto final da disciplina de Organização e Arquitetura de Computadores realizado no semestre 2021.1 pelos alunos Ana Sofia Schweizer Sivestre, Davi Jesus de Almeida Paturi e Victor Hugo França Lisboa.

O jogo é uma implementação em Assembly RISC-V 32IMF que se baseia do [jogo original Celeste](http://www.celestegame.com/) e foi idealizado para ser executado no programa [FPGRARS](https://www.github.com/LeoRiether/FPGRARS) do Leo Riether.

---

Para executar o jogo no Windows:

Baixe a o repositório num diretório e execute o arquivo `game.s` utilizando o `fpgrars.exe` (arrastando o `game.s` para o `fpgrars.s` ou executando pela linha da comando).

---

Para executar o jogo no Linux:

É preciso baixar a versão do [FPGRARS](https://www.github.com/LeoRiether/FPGRARS) para Linux e depois executar o `game.s` com o arquivo do FPGRARS.

---

#### Como jogar:
(Importante notar que os controles são _case sensitive_, ou seja, há diferença entre maiúsculas e minúsculas)

Tecla | Ação
:---: | :---:
w | Pula pra cima
a | Anda para esquerda
d | Anda para direita
q | Pula pra diagonal esquerda
e | Pula pra diagonal direita
W | Arranque para cima
A | Arranque para esquerda
D | Arranque para direita
Q | Arranque para diagonal esquerda superior
E | Arranque para diagonal direita superior
Z | Arranque para diagonal esquerda inferior
C | Arranque para diagonal direita inferior
j | Passa caixa de diálogo
t | Pula para próxima fase
o | Retorna ao início da fase
y | Recebe 10 arranques quando no ar

---

# Final Project - Celeste

Final project for the subject Computer Architecture and Organization made in the semester 2021.1 by the students Ana Sofia Schweizer Sivestre, Davi Jesus de Almeida Paturi and Victor Hugo França Lisboa.

The game is a 32IMF RISC-V Assembly implementation based on the [original Celeste game](http://www.celestegame.com/) and was designed to run on Leo Riether's [FPGRARS](https://www.github.com/LeoRiether/FPGRARS) program.

---

To run the game on Windows:

Download the repository into a directory and run the `game.s` file using `fpgrars.exe` (by dragging `game.s` into `fpgrars.s` or running it from the command line).

---

To run the game on Linux:

You need to download the Linux version of [FPGRARS](https://www.github.com/LeoRiether/FPGRARS) and then run `game.s` with the FPGRARS file.

---

#### How to play:
(Important to note that the controls are _case sensitive_, i.e. there is case difference)

Key | Action
:---: | :---:
w | Jump up
a | Move left
d | Walk right
q | Left diagonal jump
e | Right diagonal jump
W | Dash Up
A | Left Dash
D | Right Dash
Q | Left upper diagonal dash
E | Right upper diagonal dash
Z | Left lower diagonal dash
C | Right lower diagonal dash
j | Go to next dialog box
t | Jump to the next level
o | Respawn
y | Get 10 dashes when in mid-air
