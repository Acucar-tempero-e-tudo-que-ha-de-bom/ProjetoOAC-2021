.include "helpers/defs.s"
.include "helpers/files.s"
.include "helpers/data.s"
.include "helpers/debug.s"
.include "data/map_hitbox.s"

.data
#
# Posicao do personagem
# x, y
#

CHAR_POS:	.float 704.0, 648.0

CHAR_DIR:	.byte 0		# right: 0, left: 1

PLACEHOLDER:	.byte 0		# IGNORE

MOVEX:		.byte 0		# left: -1, right: 1
MOVEY:		.byte 0		# up: -1, down: 1
JUMP:		.byte 0		# jump: 1, nothing: 0

DASH:		.byte 0		# dash: 1, nothing: 0
DASHX:		.byte 0		# left: -1, right: 1
DASHY:		.byte 0		# up: -1, down: 1

DASHES:		.byte 1
DASHING:	.byte 0		# is the char dashing?

SNOWX:		.half 0		# snow effect x

MAP_POS:	.half 696, 536	# current map position
MAP_TARGET_POS:	.half 0, 0	# final map pos

FIXED_MAP:	.byte 1		# follow char = 0, fixed pos = 1
MAP_TRANSITION:	.byte 0		# is map transitioning?

RESPAWN_POS:	.half 704, 648	# respawn pos (x, y)

FASE_ATUAL:	.byte 1		# fase atual (1, 2, 3, 4, 5)

REFILL_TIMER:	.word 0, 0, 0, 0, 0, 0

MORANGOS:	.word 1

CHAR_WALK_ANIM:	.word 0

GHOST_ACTIVE:	.byte 0
GHOST_POS:	.half 1096, 184

ALREADY_TALKED:	.byte 0

.text
START:			# Open MAPA file
			li		a7, 1024
			la		a0, FILE_MAP
			li		a1, 0
			ecall
			mv		s0, a0
			
			# Open CHAR file
			la		a0, FILE_CHAR
			ecall
			mv		s2, a0
		
			# Open SNOW file
			la		a0, FILE_SNOW
			ecall
			mv		s8, a0
			
			# Open REFILL file
			la		a0, FILE_REFILL
			ecall
			mv		s6, a0
			
			# Open MORANGO file
			la		a0, FILE_MORANGO
			ecall
			mv		s7, a0
			
			# Open GHOST file
			la		a0, FILE_GHOST
			ecall
			mv		s9, a0

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
			
			call		MUSIC.SETUP

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
			# s5 = transitioning map
			# s6 = refill descriptor
			#

GAME.LOOP:		#
			# O framerate atual do jogo e 60 fps, mas com o passar do desenvolvimento, se o
			# jogo ficar muito pesado, pode ser interessante diminuir esse framerate.
			#
			csrr		t0, time		# t0 = current time
			sub		t0, t0, s11		# t0 = current time - last frame time
			li		t1, 16			# 16ms entre cada frame (1000ms/60fps)
			bltu		t0, t1, GAME.LOOP	# enquanto n tiver passado 16ms, repete

			li		t1, 1000
			fcvt.s.w	ft0, t1			# ft0 = 1000
			fcvt.s.w	fa7, t0			# fa7 = delta time (in ms)
			fdiv.s		fa7, fa7, ft0		# fa7 /= 1000 (delta time in seconds)
			
			call		MUSIC.PLAY
			
			la		t0, MAP_TRANSITION
			lb		s5, 0(t0)
			bnez		s5, GAME.MAP.MOVE
		
			call		PHYSICS
			call		INPUT
			
			bnez		s5, GAME.MAP.MOVE
		
			j		GAME.RNDR.MAP

GAME.MAP.MOVE:		la		t0, MAP_POS
			la		t1, MAP_TARGET_POS
			li		a2, 2

			lhu		a0, 0(t0)
			lhu		a1, 0(t1)
			call		APPROACH.I
			mv		s3, a0

			lhu		a0, 2(t0)
			lhu		a1, 2(t1)
			call		APPROACH.I
			mv		s4, a0

			sh		s3, 0(t0)
			sh		s4, 2(t0)

			la		t1, MAP_TARGET_POS
			lhu		t0, 0(t1)
			bne		s3, t0, GAME.RENDER	# map x != target x

			lhu		t0, 2(t1)
			bne		s4, t0, GAME.RENDER	# map y != target y

			# if both are equal
			la		t0, MAP_TRANSITION
			mv		s5, zero
			sb		s5, 0(t0)		# transition is done

GAME.RNDR.MAP:		la		t0, FIXED_MAP
			lb		t0, 0(t0)
			bnez		t0, GAME.FIXED.MAP

			# Calcular posicao do mapa de acordo com o personagem
			# O personagem deve ficar sempre que possivel no centro da tela
			# Calculo do x
GAME.DYN.MAP:		fcvt.w.s	a0, fs0			# a0 = char x

			addi		a0, a0, MAP_OFFSET_X	# a0 = char x - offset x do mapa (o mapa fica x pixels pra esquerda do personagem)
			mv		a1, zero		# a1 = 0
			call		MAX			# faz um MAX entre o resultado da conta e 0 (garante que o x do mapa seja >= 0)

			li		a1, MAP_MAX_X		# a1 = maximo que o mapa pode ir no eixo X
			call		MIN			# faz um MIN entre o resultado da conta e o MAXIMO que o mapa pode ir no eixo X

			mv		s3, a0			# move o resultado pra s3

			# Calculo do y
			fcvt.w.s	a0, fs1			# a0 = char y
			addi		a0, a0, MAP_OFFSET_Y	# a0 = char y - offset y do mapa (o mapa fica x pixels pra cima do personagem)
			mv		a1, zero		# a1 = zero
			call		MAX			# faz um MAX entre o resultado da conta e 0 (garante que o y do mapa seja >= 0)

			li		a1, MAP_MAX_Y		# a1 = maximo que o mapa pode ir no eixo Y
			call		MIN			# faz um MIN entre o resultado da conta e o MAXIMO que o mapa pode ir no eixo Y

			mv		s4, a0			# move o resultado pra s4

			j		GAME.RENDER

GAME.FIXED.MAP:		la		t0, MAP_POS
			lhu		s3, 0(t0)
			lhu		s4, 2(t0)

GAME.RENDER:		# Define os argumentos a0-a5 e desenha o mapa
			# os calculos pros argumentos a6-a7 sao definidos acima
			mv		a0, s0
			li		a1, 0
			li		a2, 0
			la		a3, FILE_MAP_SIZE
			la		a4, SCREEN_SIZE
			mv		a5, s1
			mv		a6, s3
			mv		a7, s4
			call		RENDER

			bnez		s5, GAME.SNOW
		
			# Draw refill level 4
			la		t6, REFILL_TIMER
			
			li		t0, 4
			la		t1, FASE_ATUAL
			lb		t1, 0(t1)
			bne		t0, t1, DRAW.REFILL.LVL5
			
			lw		t0, 0(t6)
			beqz		t0, REFILL.CRYSTAL0
			addi		t0, t0, -1
			sw		t0, 0(t6)
			j		REFILL.TIMER1

REFILL.CRYSTAL0:	li		a0, 868
			li		a1, 68
			call		PRINT.REFILL
			
REFILL.TIMER1:		lw		t0, 4(t6)
			beqz		t0, REFILL.CRYSTAL1
			addi		t0, t0, -1
			sw		t0, 4(t6)
			j		REFILL.TIMER2

REFILL.CRYSTAL1:	li		a0, 828
			li		a1, 44
			call		PRINT.REFILL
			
REFILL.TIMER2:		lw		t0, 8(t6)
			beqz		t0, REFILL.CRYSTAL2
			addi		t0, t0, -1
			sw		t0, 8(t6)
			j		REFILL.TIMER3

REFILL.CRYSTAL2:	li		a0, 796
			li		a1, 84
			call		PRINT.REFILL
			
REFILL.TIMER3:		lw		t0, 12(t6)
			beqz		t0, REFILL.CRYSTAL3
			addi		t0, t0, -1
			sw		t0, 12(t6)
			j		DRAW.MORANGO

REFILL.CRYSTAL3:	li		a0, 764		# x
			li		a1, 60		# y
			call		PRINT.REFILL
			
			j		DRAW.MORANGO
			
DRAW.REFILL.LVL5:	lw		t0, 20(t6)
			beqz		t0, REFILL.CRYSTAL4
			addi		t0, t0, -1
			sw		t0, 20(t6)
			j		DRAW.MORANGO

REFILL.CRYSTAL4:	li		a0, 124
			bgt		s3, a0, DRAW.MORANGO
			li		a1, 52
			call		PRINT.REFILL

DRAW.MORANGO:		la		t0, MORANGOS
			lw		t1, 0(t0)
			beqz		t1, DRAW.CHAR

			li		a0, 288
			bgt		s3, a0, DRAW.CHAR
			li		a1, 32
			call		PRINT.MORANGO
			
DRAW.CHAR:		fcvt.w.s	t0, fs2
			beqz		t0, DRAW.CHAR.ZERO.X
			
			la		t0, CHAR_WALK_ANIM
			lw		t1, 0(t0)
			addi		t1, t1, 1
			sw		t1, 0(t0)
			
			li		t2, 12
			bgt		t1, t2, DRAW.CHAR.MAX.X
			
			j		DRAW.CHAR.START

DRAW.CHAR.ZERO.X:	la		t0, CHAR_WALK_ANIM
			sw		zero, 0(t0)
			
			j DRAW.CHAR.START

DRAW.CHAR.MAX.X:	la		t0, CHAR_WALK_ANIM
			li		t1, 1
			sw		t1, 0(t0)

DRAW.CHAR.START:	# Draw char
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
			
			la		t0, CHAR_WALK_ANIM
			lw		t0, 0(t0)
			li		t1, 32
			mul		a7, t0, t1
		
			la		t0, DASHES
			lbu		t0, 0(t0)
			sltiu		t1, t0, 1
			li		t0, 416
			mul		t1, t1, t0
			add		a7, a7, t1

			call		RENDER
			
GAME.GHOST:		la		t0, GHOST_ACTIVE
			lb		t1, 0(t0)
			beqz		t1, GAME.SNOW
			
			mv		a0, zero
			li		a1, 100
			li		a7, 42
			ecall
			
			li		t1, 70
			blt		a0, t1, GAME.GHOST.NOTHING
			
			la		t0, GHOST_POS
			lhu		a0, 0(t0)
			fcvt.w.s	a1, fs0
			li		a2, 1
			call		APPROACH.I
			mv		t3, a0		# t3 = ghost x
			
			lhu		a0, 2(t0)
			fcvt.w.s	a1, fs1
			li		a2, 1
			call		APPROACH.I
			mv		t4, a0		# t4 = ghost y
			
			sh		t3, 0(t0)
			sh		t4, 2(t0)
			
			j		GAME.DRAW.GHOST

GAME.GHOST.NOTHING:	la		t0, GHOST_POS
			lhu		t3, 0(t0)
			lhu		t4, 2(t0)
			
GAME.DRAW.GHOST:	mv		a0, s9
			sub		a1, t3, s3
			sub		a2, t4, s4
			la		a3, FILE_GHOST_SIZE
			mv		a4, a3
			mv		a5, s1
			mv		a6, zero
			mv		a7, zero
			call		RENDER

GAME.GHOST.COLL.X:	la		t0, GHOST_POS
			lhu		t1, 0(t0)
			fcvt.w.s	t2, fs0
			addi		t2, t2, -12
			blt		t1, t2, GAME.SNOW
			addi		t2, t2, 32
			bgt		t1, t2, GAME.SNOW
			
			lhu		t1, 2(t0)
			fcvt.w.s	t2, fs1
			addi		t2, t2, -8
			blt		t1, t2, GAME.SNOW
			addi		t2, t2, 40
			bgt		t1, t2, GAME.SNOW
			
			call		DEATH
		
GAME.SNOW:		# Draw SNOW
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
			addi		t0, t0, 2
			li		t1, SNOW_MAX_X
			blt		t0, t1, SNOW.SAVE.X		# snow x < max snow x
			mv		t0, zero

SNOW.SAVE.X:		sh		t0, 0(t3)
		
			# Salva quando esse frame terminou de renderizar
			# Usado pra garantir um framerate fixo no jogo
			csrr		s11, time
		
			# Troca de frame
			# Agora que esta tudo renderizado pode mostrar pro usuario
			li		t0, FRAME_CONTROL_ADDRESS
			sw		s1, 0(t0)
			xori		s1, s1, 1
		
			j GAME.LOOP
		
EXIT:			# Closes MAPA file
			li		a7, 57
			mv		a0, s0
			ecall
		
			# Closes CHAR file
			mv		a0, s2
			ecall
			
			# Closes SNOW file
			mv		a0, s8
			ecall

			# Exit
			li		a7, 10
			ecall

.include "helpers/input.s"
.include "helpers/render.s"
.include "helpers/physics.s"
.include "helpers/fases.s"
.include "helpers/music.s"
.include "helpers/procs.s"
.include "helpers/talk.s"

