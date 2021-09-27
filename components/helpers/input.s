################# INPUT #################
# Recebe o input do teclado e		#
# altera os valores de moveX e moveY	#
#########################################

INPUT:		li t1, KDMMIO_KEYDOWN_ADDRESS
		lw t0, 0(t1)
		andi t0, t0, 1		# flag bit mask	
  	 	beqz t0, INPUT_ZERO	# se nao tiver input, retorna
 
		lw t0, 4(t1)		# caso contrario, pega o valor que ta no buffer

  		# compara pra saber qual input foi
  		li 	t1, 'w'
  		beq 	t0, t1, INPUT_W
  		li 	t1, 'a'
  		beq 	t0, t1, INPUT_A
  		li 	t1, 's'
  		beq 	t0, t1, INPUT_S
  		li 	t1, 'd'
  		beq 	t0, t1, INPUT_D
  		li 	t1, 'e'
  		beq 	t0, t1, INPUT_E
  		li 	t1, 'q'
  		beq 	t0, t1, INPUT_Q
  		
  		li t1,'p'
  		beq t0,t1,EXIT
  		
INPUT_ZERO:	# caso nao tenha input
		la t0, MOVEX
		sh zero, 0(t0)		# zera moveX e moveY (cada um eh um byte, por isso usamos halfword, pra zerar os dois)
		
		la t0, JUMP
		sb zero, 0(t0)		# zera o JUMP tambem
		
		ret

INPUT_W:	# Pula
		la t0, MOVEY
		li t1, -1
		sb t1, 0(t0)		# moveY = -1
		
		la t0, JUMP
		li t1, 1
		sb t1, 0(t0)		# jump = 1
		
		ret

INPUT_A:	# Esquerda
		la t0, MOVEX
		li t1, -1
		sb t1, 0(t0)		# moveX = -1
		ret

INPUT_S:	# Abaixa
		la t0, MOVEY
		li t1, 1
		sb t1, 0(t0)		# moveY = 1
		ret

INPUT_D:	# Direita
		la t0, MOVEX
		li t1, 1
		sb t1, 0(t0)		# moveX = 1
		ret

INPUT_Q:	# Dash pra esquerda
		la t0, MOVEY
		li t1, -1
		sb t1, 0(t0)		# moveY = -1
		
		la t0, MOVEX
		li t1, -1
		sb t1, 0(t0)		# moveX = -1
		
		la t0, JUMP
		li t1, 1
		sb t1, 0(t0)		# jump = 1
		
		ret

INPUT_E:	# Dash pra direita
		la t0, MOVEY
		li t1, -1
		sb t1,0(t0)		# moveY = -1
		
		la t0, MOVEX
		li t1, 1
		sb t1, 0(t0)		# moveX = 1
		
		la t0, JUMP
		li t1, 1
		sb t1, 0(t0)		# jump = 1
		
		ret