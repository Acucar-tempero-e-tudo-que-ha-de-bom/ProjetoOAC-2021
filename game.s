.include "helpers/defs.s"
.include "helpers/files.s"
.include "helpers/data.s"
.include "data/map_hitbox.s"

.data
#
# Posicao do personagem
# x, y
#

CHAR_POS:	.float 8, 111

CHAR_DIR:	.byte 0		# right: 0, left: 1

MOVEX:		.byte 0		# left: -1, right: 1
MOVEY:		.byte 0		# up: -1, down: 1
JUMP:		.byte 0		# jump: 1, nothing: 0

DASH:		.byte 0		# dash: 1, nothing: 0
DASHX:		.byte 0		# left: -1, right: 1
DASHY:		.byte 0		# up: -1, down: 1

DASHES:		.byte 1
DASHING:	.byte 0		# is the char dashing?

SNOWX:		.half 0		# snow effect x

.text		
		# Open MAPA file
		li		a7, 1024
		la		a0, FILE_MAP
		li		a1, 0
		ecall
		mv		s0, a0
		
		# Open CHAR file
		la		a0, FILE_CHAR
		ecall
		mv		s2, a0
		
		# Open DEBUG file
		la		a0, FILE_DEBUG
		ecall
		mv		s9, a0
		
		# Open SNOW file
		la		a0, FILE_SNOW
		ecall
		mv		s8, a0

		li		s1, 1
		
		la		t0, CHAR_POS
		flw		fs0, 0(t0)		# fs0 = char x
		flw		fs1, 4(t0)		# fs1 = char y

		fcvt.s.w	fs2, zero		# fs2 = x velocity
		fcvt.s.w	fs3, zero		# fs3 = y velocity
		fcvt.s.w	fs4, zero		# fs4 = jump grace timer
		fcvt.s.w	fs5, zero		# fs5 = varJumpTimer
		fcvt.s.w	fs6, zero		# fs6 = varJumpSpeed
		fcvt.s.w	fs7, zero		# fs7 = maxfall
		fcvt.s.w	fs8, zero		# fs8 = dash timer
		
		li		t0, MAX_FALL
		fcvt.s.w	fs7, t0			# fs7 = max fall

		#
		# Registradores que devem permanecer durante o loop
		#
		# s0 = MAPA file descriptor
		# s1 = current frame
		# s2 = CHAR file descriptor
		# s11 = last frame time
		#
		# fa7 = delta time
		#
		# Registradores salvos entre a renderizacao do mapa e a do personagem
		# s3 = map x
		# s4 = map y
		#

GAME.LOOP:	#
		# O framerate atual do jogo e 60 fps, mas com o passar do desenvolvimento, se o
		# jogo ficar muito pesado, pode ser interessante diminuir esse framerate.
		#
		csrr		t0, 3073		# t0 = current time
		sub		t0, t0, s11		# t0 = current time - last frame time
		li		t1, 16			# 16ms entre cada frame (1000ms/60fps)
		bltu		t0, t1, GAME.LOOP	# enquanto n tiver passado 16ms, repete

		li		t1, 1000
		fcvt.s.w	ft0, t1			# ft0 = 1000
		fcvt.s.w	fa7, t0			# fa7 = delta time (in ms)
		fdiv.s		fa7, fa7, ft0		# fa7 /= 1000 (delta time in seconds)
		
		call		PHYSICS
		call		INPUT
	
		# Calcular posicao do mapa de acordo com o personagem
		# O personagem deve ficar sempre que poss�vel no centro da tela

		# Calculo do x
		fcvt.w.s	a0, fs0			# a0 = char x

		addi		a0, a0, MAP_OFFSET_X	# a0 = char x - offset x do mapa (o mapa fica x pixels pra esquerda do personagem)
		mv		a1, zero		# a1 = 0
		call		MAX			# faz um MAX entre o resultado da conta e 0 (garante que o x do mapa seja >= 0)
		
		li		a1, MAP_MAX_X		# a1 = maximo que o mapa pode ir no eixo X
		call		MIN			# faz um MIN entre o resultado da conta e o MAXIMO que o mapa pode ir no eixo X
		
		mv		s3, a0			# move o resultado pra s3
		
		# Calculo do y
		fcvt.w.s		a0, fs1		# a0 = char y
		addi		a0, a0, MAP_OFFSET_Y	# a0 = char y - offset y do mapa (o mapa fica x pixels pra cima do personagem)
		mv		a1, zero		# a1 = zero
		call		MAX			# faz um MAX entre o resultado da conta e 0 (garante que o y do mapa seja >= 0)
		
		li		a1, MAP_MAX_Y		# a1 = maximo que o mapa pode ir no eixo Y
		call		MIN			# faz um MIN entre o resultado da conta e o MAXIMO que o mapa pode ir no eixo Y
		
		mv		s4, a0			# move o resultado pra s4

		# Define os argumentos a0-a5 e desenha o mapa
		# os calculos pros argumentos a6-a7 s�o definidos acima
		mv		a0, s0
		li		a1, 0
		li		a2, 0
		la		a3, FILE_MAP_SIZE
		la		a4, SCREEN_SIZE
		mv		a5, s1
		mv		a6, s3
		mv		a7, s4
		call		RENDER
		
		# Draw char
		mv		a0, s2
		
		# Calculo da posicao do personagem na tela em relacao ao mapa

		# x = char x - map x
		fcvt.w.s	a1, fs0
		sub		a1, a1, s3
		
		# y = char y - map y
		fcvt.w.s	a2, fs1
		sub		a2, a2, s4
		
		la		a3, FILE_CHAR_SIZE
		la		a4, FILE_CHAR_DRAW
		mv		a5, s1
		
		la		t0, CHAR_DIR
		lb		t0, 0(t0)
		
		li		t1, 32
		mul		a6, t0, t1
		
		li		a7, 0
		call		RENDER
		
		# Draw DEBUG
		mv		a0, s9
		
		li		t0, 80
		li		t1, 8
		rem		a1, s10, t0
		mul		a1, a1, t1
		sub		a1, a1, s3

		div		a2, s10, t0
		mul		a2, a2, t1
		sub		a2, a2, s4
		
		la		a3, FILE_DEBUG_SIZE
		la		a4, FILE_DEBUG_SIZE
		mv		a5, s1
		li		a6, 0
		li		a7, 0
		call		RENDER
		
		# Draw SNOW
		la		t3, SNOWX
		
		mv		a0, s8
		mv		a1, zero
		mv		a2, zero
		la		a3, FILE_SNOW_SIZE
		la		a4, SCREEN_SIZE
		mv		a5, s1
		lhu		a6, 0(t3)
		mv		a7, zero
		call		RENDER
		
		lhu		t0, 0(t3)
		addi		t0, t0, 1
		li		t1, SNOW_MAX_X
		blt		t0, t1, SNOW.SAVE.X		# snow x < max snow x
		mv		t0, zero

SNOW.SAVE.X:	sh		t0, 0(t3)
		
		# Salva quando esse frame terminou de renderizar
		# Usado pra garantir um framerate fixo no jogo
		csrr		s11, 3073
		
		# Troca de frame
		# Agora que esta tudo renderizado pode mostrar pro usuario
		li		t0, FRAME_CONTROL_ADDRESS
		sw		s1, 0(t0)
		xori		s1, s1, 1
		
		j GAME.LOOP
		
EXIT:		# Closes MAPA file
		li		a7, 57
		mv		a0, s0
		ecall
		
		# Closes CHAR file
		li		a7, 57
		mv		a0, s2
		ecall

		# Exit
		li		a7, 10
		ecall

.include "helpers/input.s"
.include "helpers/render.s"
.include "helpers/physics.s"
.include "helpers/procs.s"

