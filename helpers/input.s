INPUT:		li		t1, KDMMIO_KEYDOWN_ADDRESS
		lw		t0, 0(t1)
		andi		t0, t0, 1
  	 	beqz		t0, INPUT.ZERO	# se nao tiver input, zera as entradas
 
		lw		t0, 4(t1)	# se houver input, pega o valor que ta no buffer pra comparacao

  		# Movimentos normais (lowercase)
  		li		t1, 'w'
  		beq		t0, t1, INPUT.W
  		li		t1, 'a'
  		beq		t0, t1, INPUT.A
  		li		t1, 's'
  		beq		t0, t1, INPUT.S
  		li		t1, 'd'
  		beq		t0, t1, INPUT.D
  		li		t1, 'e'
  		beq		t0, t1, INPUT.E
  		li		t1, 'q'
  		beq		t0, t1, INPUT.Q
  		
  		# Dash (uppercase)
  		li		t1, 'W'
  		beq		t0, t1, INPUT.DASH.W
  		li		t1, 'A'
  		beq		t0, t1, INPUT.DASH.A
  		li		t1, 'S'
  		beq		t0, t1, INPUT.DASH.S
  		li		t1, 'D'
  		beq		t0, t1, INPUT.DASH.D
  		li		t1, 'Q'
  		beq		t0, t1, INPUT.DASH.Q
  		li		t1, 'E'
  		beq		t0, t1, INPUT.DASH.E
  		li		t1, 'C'
  		beq		t0, t1, INPUT.DASH.C
  		li		t1, 'Z'
  		beq		t0, t1, INPUT.DASH.Z
  		
  		# Teclas especiais
  		# (talvez podemos fazer um pause depois?)
  		li		t1, 'o'
  		beq		t0, t1, INPUT.RESPAWN
  		li		t1, 'y'
  		beq		t0, t1, INPUT.DASHES
  		li		t1, 't'
  		beq		t0, t1, INPUT.CHEAT
  		li		t1, 'p'
  		beq		t0, t1, EXIT
  		
INPUT.ZERO:	la		t0, MOVEX
		sw		zero, 0(t0)		# zera moveX, moveY, jump e dash (cada um eh um byte, por isso usamos word, pra zerar os quatro)
		sh		zero, 4(t0)		# zera dashX e dashY (cada um eh um byte, por isso usamos half)
		ret

INPUT.W:	la		t0, MOVEY
		li		t1, -1
		sb		t1, 0(t0)		# moveY = -1 (cima)
		
		la		t0, JUMP
		li		t1, 1
		sb		t1, 0(t0)		# input jump = 1
		
		ret

INPUT.A:	la		t0, MOVEX
		li		t1, -1
		sb		t1, 0(t0)		# moveX = -1 (esquerda)
		
		la		t0, CHAR_DIR
		li		t1, 1
		sb		t1, 0(t0)		# charDir = 1 (esquerda)
		
		ret

INPUT.S:	la		t0, MOVEY
		li		t1, 1
		sb		t1, 0(t0)		# moveY = 1 (baixo)
		ret

INPUT.D:	la		t0, MOVEX
		li		t1, 1
		sb		t1, 0(t0)		# moveX = 1 (direita)
		
		la		t0, CHAR_DIR
		sb		zero, 0(t0)		# charDir = 0 (direita)
		
		ret

INPUT.Q:	la		t0, MOVEY
		li		t1, -1
		sb		t1, 0(t0)		# moveY = -1 (cima)
		
		la		t0, MOVEX
		li		t1, -1
		sb		t1, 0(t0)		# moveX = -1 (esquerda)
		
		la		t0, JUMP
		li		t1, 1
		sb		t1, 0(t0)		# input jump = 1
		
		la		t0, CHAR_DIR
		li		t1, 1
		sb		t1, 0(t0)		# charDir = 1 (esquerda)
		
		ret

INPUT.E:	la		t0, MOVEY
		li		t1, -1
		sb		t1, 0(t0)		# moveY = -1 (cima)
		
		la		t0, MOVEX
		li		t1, 1
		sb		t1, 0(t0)		# moveX = 1 (direita)
		
		la		t0, JUMP
		li		t1, 1
		sb		t1, 0(t0)		# input jump = 1
		
		la		t0, CHAR_DIR
		sb		zero, 0(t0)		# charDir = 0 (direita)
		
		ret

INPUT.DASH.W:	la		t0, DASHX
		li		t1, 0
		sb		t1, 0(t0)		# dashX = 0 (nem pra esquerda, nem pra direita)
		
		la		t0, DASHY
		li		t1, -1
		sb		t1, 0(t0)		# dashY = -1 (cima)
		
		la		t0, DASH
		li		t1, 1
		sb		t1, 0(t0)		# input dash = 1
		
		ret

INPUT.DASH.A:	la		t0, DASHX
		li		t1, -1
		sb		t1, 0(t0)		# dashX = -1 (esquerda)
		
		la		t0, DASHY
		li		t1, 0
		sb		t1, 0(t0)		# dashY = 0 (nem pra cima, nem pra baixo)
		
		la		t0, DASH
		li		t1, 1
		sb		t1, 0(t0)		# input dash = 1
		
		la		t0, CHAR_DIR
		li		t1, 1
		sb		t1, 0(t0)		# charDir = 1 (esquerda)
		
		ret
		
INPUT.DASH.S:	la		t0, DASHX
		li		t1, 0
		sb		t1, 0(t0)		# dashX = 0 (nem pra esquerda, nem pra direita)
		
		la		t0, DASHY
		li		t1, 1
		sb		t1, 0(t0)		# dashY = 1 (baixo)
		
		la		t0, DASH
		li		t1, 1
		sb		t1, 0(t0)		# input dash = 1
		
		ret
		
INPUT.DASH.D:	la		t0, DASHX
		li		t1, 1
		sb		t1, 0(t0)		# dashX = 1 (direita)
		
		la		t0, DASHY
		li		t1, 0
		sb		t1, 0(t0)		# dashY = 0 (nem pra cima, nem pra baixo)
		
		la		t0, DASH
		li		t1, 1
		sb		t1, 0(t0)		# input dash = 1
		
		la		t0, CHAR_DIR
		sb		zero, 0(t0)		# charDir = 0 (direita)
		
		ret

INPUT.DASH.Q:	la		t0, DASHX
		li		t1, -1
		sb		t1, 0(t0)		# dashX = -1 (esquerda)
		
		la		t0, DASHY
		li		t1, -1
		sb		t1, 0(t0)		# dashY = -1 (cima)
		
		la		t0, DASH
		li		t1, 1
		sb		t1, 0(t0)		# input dash = 1
		
		la		t0, CHAR_DIR
		li		t1, 1
		sb		t1, 0(t0)		# charDir = 1 (esquerda)
		
		ret

INPUT.DASH.E:	la		t0, DASHX
		li		t1, 1
		sb		t1, 0(t0)		# dashX = 1 (direita)
		
		la		t0, DASHY
		li		t1, -1
		sb		t1, 0(t0)		# dashY = -1 (cima)
		
		la		t0, DASH
		li		t1, 1
		sb		t1, 0(t0)		# input dash = 1
		
		la		t0, CHAR_DIR
		sb		zero, 0(t0)		# charDir = 0 (direita)
		
		ret

INPUT.DASH.C:	la		t0, DASHX
		li		t1, 1
		sb		t1, 0(t0)		# dashX = 1 (direita)
		
		la		t0, DASHY
		li		t1, 1
		sb		t1, 0(t0)		# dashY = 1 (baixo)
		
		la		t0, DASH
		li		t1, 1
		sb		t1, 0(t0)		# input dash = 1
		
		la		t0, CHAR_DIR
		sb		zero, 0(t0)		# charDir = 0 (direita)
		
		ret

INPUT.DASH.Z:	la		t0, DASHX
		li		t1, -1
		sb		t1, 0(t0)		# dashX = -1 (esquerda)
		
		la		t0, DASHY
		li		t1, 1
		sb		t1, 0(t0)		# dashY = 1 (baixo)
		
		la		t0, DASH
		li		t1, 1
		sb		t1, 0(t0)		# input dash = 1
		
		la		t0, CHAR_DIR
		li		t1, 1
		sb		t1, 0(t0)		# charDir = 1 (esquerda)
		
		ret

INPUT.RESPAWN:	la		t0, RESPAWN_POS

		lhu		t1, 0(t0)
		fcvt.s.w	fs0, t1			# respawn x pos
			
		lhu		t1, 2(t0)
		fcvt.s.w	fs1, t1			# respawn y pos

		fcvt.s.w	fs2, zero
		fcvt.s.w	fs3, zero		# zeroes char speed

		ret

INPUT.DASHES:	la		t0, DASHES
		li		t1, 10
		sb		t1, 0(t0)		# dashes = 10
		
		ret

INPUT.CHEAT:	la		t0, FASE_ATUAL
		lb		t0, 0(t0)
		
		addi		sp, sp, -4
		sw		ra, 4(sp)		# salva ra
		
		li		t1, 1
		beq		t0, t1, INPUT.CHEAT.2
		li		t1, 2
		beq		t0, t1, INPUT.CHEAT.3
		li		t1, 3
		beq		t0, t1, INPUT.CHEAT.4
		li		t1, 4
		beq		t0, t1, INPUT.CHEAT.5
		
		j		INPUT.CHEAT.RT

INPUT.CHEAT.2:	call		F1.TO.F2
		j		INPUT.CHEAT.RT

INPUT.CHEAT.3:	call		F2.TO.F3
		j		INPUT.CHEAT.RT

INPUT.CHEAT.4:	call		F3.TO.F4
		j		INPUT.CHEAT.RT

INPUT.CHEAT.5:	call		F4.TO.F5
		j		INPUT.CHEAT.RT

INPUT.CHEAT.RT:	lw		ra, 4(sp)		# restaura ra
		addi		sp, sp, 4
		ret