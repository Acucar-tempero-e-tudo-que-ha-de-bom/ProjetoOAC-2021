# branch anasofia/fisica
# a ideia eh basicamente formular toda a física do personagem com base em velocidade
# comecando pela velocidade horizontal (a mais facil)
# 'd' -> a velocidade incrementa até chegar nesse ponto
# e aí decrementa até voltar pro estado de repouso
.eqv	MAX_VEL.X 10
.eqv	MIN_VEL.Y -10


.include "helpers/defs.s"
.include "helpers/files.s"

.data
#
# Posicao do personagem
# x, y
#
BRKLN: .string "aeooooooooo\n"

CHAR_POS:	.half 8,112
CHAO:		.byte 1

.text		
		# Open MAPA file
		li a7,1024
		la a0,FILE_MAP
		li a1,0
		ecall
		mv s0,a0
		
		
		# Open CHAR file
		la a0,FILE_CHAR
		ecall
		mv s2,a0

		li s1,1

		#
		# Registradores que devem permanecer durante o loop
		#
		# s0 = MAPA file descriptor
		# s1 = current frame
		# s2 = CHAR file descriptor
		# s7 = last frame time
		#
		# Registradores salvos entre a renderizacao do mapa e a do personagem
		# s3 = map x
		# s4 = map y
		#
		# Registradores salvos para velocidade do personagem
		# s5 = velocidade vertical
		# s6 = velocidade horizontal						...me desculpa qualquer coisa
		#
GAME_LOOP:	call INPUT
		

		#
		# O framerate atual do jogo e 60 fps, mas com o passar do desenvolvimento, se o
		# jogo ficar muito pesado, pode ser interessante diminuir esse framerate.
		#
		csrr t0,3073			# t0 = current time
		sub t0,t0,s7			# t0 = current time - last frame time
		li t1,16			# 16ms entre cada frame (1000ms/60fps)
		bltu t0,t1,GAME_LOOP		# enquanto n tiver passado 16ms, repete
		
		jal FISICA
		
		# Calcular posicao do mapa de acordo com o personagem
		# O personagem deve ficar sempre que possível no centro da tela
		la t0,CHAR_POS
		
		# Calculo do x
		lhu a0,0(t0)			# a0 = char x
		addi a0,a0,MAP_OFFSET_X		# a0 = char x - offset x do mapa (o mapa fica x pixels pra esquerda do personagem)
		mv a1,zero			# a1 = 0
		call MAX			# faz um MAX entre o resultado da conta e 0 (garante que o x do mapa seja >= 0)
		
		li a1,MAP_MAX_X			# a1 = maximo que o mapa pode ir no eixo X
		call MIN			# faz um MIN entre o resultado da conta e o MAXIMO que o mapa pode ir no eixo X
		
		mv s3,a0			# move o resultado pra s3
		
		# Calculo do y
		lhu a0,2(t0)			# a0 = char y
		addi a0,a0,MAP_OFFSET_Y		# a0 = char y - offset y do mapa (o mapa fica x pixels pra cima do personagem)
		mv a1,zero			# a1 = zero
		call MAX			# faz um MAX entre o resultado da conta e 0 (garante que o y do mapa seja >= 0)
		
		li a1,MAP_MAX_Y			# a1 = maximo que o mapa pode ir no eixo Y
		call MIN			# faz um MIN entre o resultado da conta e o MAXIMO que o mapa pode ir no eixo Y
		
		mv s4,a0			# move o resultado pra s4

		# Define os argumentos a0-a5 e desenha o mapa
		# os calculos pros argumentos a6-a7 são definidos acima
		mv a0,s0
		li a1,0
		li a2,0
		la a3,FILE_MAP_SIZE
		la a4,SCREEN_SIZE
		mv a5,s1
		mv a6,s3
		mv a7,s4
		call RENDER
		
		# Draw char
		
		mv a0,s2
		
		# Calculo da posicao do personagem na tela em relacao ao mapa
		la t0,CHAR_POS
		# x = char x - map x
		lhu a1,0(t0)
		sub a1,a1,s3
		
		# y = char y - map y
		lhu a2,2(t0)
		sub a2,a2,s4
		
		la a3,FILE_CHAR_SIZE
		la a4,FILE_CHAR_SIZE
		mv a5,s1
		li a6,0
		li a7,0
		call RENDER
		
		# Salva quando esse frame terminou de renderizar
		# Usado pra garantir um framerate fixo no jogo
		csrr s7,3073
		
		# Troca de frame
		# Agora que esta tudo renderizado pode mostrar pro usuario
		li t0,FRAME_CONTROL_ADDRESS
		sw s1,0(t0)
		xori s1,s1,1
		
		j GAME_LOOP
		
EXIT:		# Closes MAPA file
		li a7,57
		mv a0,s0
		ecall
		
		# Closes CHAR file
		li a7,57
		mv a0,s2
		ecall

		# Exit
		li a7,10
		ecall

INPUT:	li t1,KDMMIO_CONTROL_ADDRESS
		lw t0,0(t1)		
		andi t0,t0,1
  	 	beqz t0,NO_INPUT	# se nao tiver input, retorna
 
		lw t0,4(t1)		# caso contrario, pega o valor que ta no buffer
		
  		# compara pra saber qual input foi
  		li t1,'w'
  		beq t0,t1,INPUT_W
  		li t1,'a'
  		beq t0,t1,INPUT_A
  		li t1,'s'
  		beq t0,t1,INPUT_S
  		li t1,'d'
  		beq t0,t1,INPUT_D
  		li t1,'p'
  		beq t0,t1,EXIT

NO_INPUT:	#beqz s5, INPUT_RET

INPUT_RET:	ret

INPUT_W:	la t0, CHAO
		sb zero, 0(t0)
		addi s5, s5, -10
		la a0, BRKLN
		li a7, 4
		ecall
		j INPUT_RET

INPUT_A:	la t0,CHAR_POS
		lhu t1,0(t0)
		addi t1,t1,-4	# x -= 4
		sh t1,0(t0)
		j INPUT_RET

INPUT_S:	la t0,CHAR_POS
		lhu t1,2(t0)
		addi t1,t1,4	# y += 4
		sh t1,2(t0)
		j INPUT_RET

INPUT_D:	li t0, MAX_VEL.X
		bge s6, t0, INPUT_RET
		addi s6, s6, 3
		j INPUT_RET

FISICA:	
		la t0, CHAR_POS
		
		lhu t1, 0(t0)
		add t1, t1, s6
		sh t1, 0(t0)
		
		lhu t1,2(t0)
		add t1,t1,s5
		sh t1,2(t0)
		
		la t0, CHAO
		lb t1, 0(t0)
		bnez t1, FISICA_RET
		addi s5, s5, 1
		
FISICA_RET:	ret

MOVE_CHAR.X:
		ret

MOVE_CHAR.Y:
		ret

.include "helpers/procs.s"
