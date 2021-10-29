INPUT:		li		t1, KDMMIO_KEYDOWN_ADDRESS
		lw		t0, 0(t1)		
		andi		t0, t0, 1	
  	 	beqz		t0, INPUT_ZERO	# se nao tiver input, retorna
 
		lw		t0, 4(t1)		# caso contrario, pega o valor que ta no buffer

  		# compara pra saber qual input foi
  		li		t1, 'w'
  		beq		t0, t1, INPUT_W
  		li		t1, 'a'
  		beq		t0, t1,INPUT_A
  		li		t1, 's'
  		beq		t0, t1, INPUT_S
  		li		t1, 'd'
  		beq		t0, t1, INPUT_D
  		li		t1, 'e'
  		beq		t0, t1, INPUT_E
  		li		t1, 'q'
  		beq		t0, t1, INPUT_Q
  		
  		li		t1, 'W'
  		beq		t0, t1, INPUT_DASH_W
  		li		t1, 'A'
  		beq		t0, t1, INPUT_DASH_A
  		li		t1, 'S'
  		beq		t0, t1, INPUT_DASH_S
  		li		t1, 'D'
  		beq		t0, t1, INPUT_DASH_D
  		li		t1, 'Q'
  		beq		t0, t1, INPUT_DASH_Q
  		li		t1, 'E'
  		beq		t0, t1, INPUT_DASH_E
  		li		t1, 'C'
  		beq		t0, t1, INPUT_DASH_C
  		li		t1, 'Z'
  		beq		t0, t1, INPUT_DASH_Z
  		
  		li		t1, 'p'
  		beq		t0, t1, EXIT
  		
INPUT_ZERO:	la		t0, MOVEX
		sw		zero, 0(t0)		# zera moveX, moveY, jump e dash (cada um e um byte, por isso usamos word, pra zerar os quatro)
		sh		zero, 4(t0)
		ret

INPUT_INCR:	addi		t1, t1, 1
		sb		t1, 0(t0)
		ret

INPUT_W:	la		t0,MOVEY
		li		t1, -1
		sb		t1, 0(t0)
		
		la		t0, JUMP
		li		t1, 1
		sb		t1, 0(t0)
		
		ret

INPUT_A:	la		t0, MOVEX
		li		t1, -1
		sb		t1, 0(t0)
		
		la		t0, CHAR_DIR
		li		t1, 1
		sb		t1, 0(t0)
		
		ret

INPUT_S:	la		t0, MOVEY
		li		t1, 1
		sb		t1, 0(t0)
		ret

INPUT_D:	la		t0, MOVEX
		li		t1, 1
		sb		t1, 0(t0)
		
		la		t0, CHAR_DIR
		sb		zero, 0(t0)
		
		ret

INPUT_Q:	la		t0, MOVEY
		li		t1, -1
		sb		t1, 0(t0)
		
		la		t0, MOVEX
		li		t1, -1
		sb		t1, 0(t0)
		
		la		t0, JUMP
		li		t1, 1
		sb		t1, 0(t0)
		
		la		t0, CHAR_DIR
		li		t1, 1
		sb		t1, 0(t0)
		
		ret

INPUT_E:	la		t0, MOVEY
		li		t1, -1
		sb		t1, 0(t0)
		
		la		t0, MOVEX
		li		t1, 1
		sb		t1, 0(t0)
		
		la		t0, JUMP
		li		t1, 1
		sb		t1, 0(t0)
		
		la		t0, CHAR_DIR
		sb		zero, 0(t0)
		
		ret

INPUT_DASH_W:	la		t0, DASHX
		li		t1, 0
		sb		t1, 0(t0)
		
		la		t0, DASHY
		li		t1, -1
		sb		t1, 0(t0)
		
		la		t0, DASH
		li		t1, 1
		sb		t1, 0(t0)
		
		ret

INPUT_DASH_A:	la		t0, DASHX
		li		t1, -1
		sb		t1, 0(t0)
		
		la		t0, DASHY
		li		t1, 0
		sb		t1, 0(t0)
		
		la		t0, DASH
		li		t1, 1
		sb		t1, 0(t0)
		
		la		t0, CHAR_DIR
		li		t1, 1
		sb		t1, 0(t0)
		
		ret
		
INPUT_DASH_S:	la		t0, DASHX
		li		t1, 0
		sb		t1, 0(t0)
		
		la		t0, DASHY
		li		t1, 1
		sb		t1, 0(t0)
		
		la		t0, DASH
		li		t1, 1
		sb		t1, 0(t0)
		
		ret
		
INPUT_DASH_D:	la		t0, DASHX
		li		t1, 1
		sb		t1, 0(t0)
		
		la		t0, DASHY
		li		t1, 0
		sb		t1, 0(t0)
		
		la		t0, DASH
		li		t1, 1
		sb		t1, 0(t0)
		
		la		t0, CHAR_DIR
		sb		zero, 0(t0)
		
		ret

INPUT_DASH_Q:	la		t0, DASHX
		li		t1, -1
		sb		t1, 0(t0)
		
		la		t0, DASHY
		li		t1, -1
		sb		t1, 0(t0)
		
		la		t0, DASH
		li		t1, 1
		sb		t1, 0(t0)
		
		la		t0, CHAR_DIR
		li		t1, 1
		sb		t1, 0(t0)
		
		ret

INPUT_DASH_E:	la		t0, DASHX
		li		t1, 1
		sb		t1, 0(t0)
		
		la		t0, DASHY
		li		t1, -1
		sb		t1, 0(t0)
		
		la		t0, DASH
		li		t1, 1
		sb		t1, 0(t0)
		
		la		t0, CHAR_DIR
		sb		zero, 0(t0)
		
		ret

INPUT_DASH_C:	la		t0, DASHX
		li		t1, 1
		sb		t1, 0(t0)
		
		la		t0, DASHY
		li		t1, 1
		sb		t1, 0(t0)
		
		la		t0, DASH
		li		t1, 1
		sb		t1, 0(t0)
		
		la		t0, CHAR_DIR
		sb		zero, 0(t0)
		
		ret

INPUT_DASH_Z:	la		t0, DASHX
		li		t1, -1
		sb		t1, 0(t0)
		
		la		t0, DASHY
		li		t1, 1
		sb		t1, 0(t0)
		
		la		t0, DASH
		li		t1, 1
		sb		t1, 0(t0)
		
		la		t0, CHAR_DIR
		li		t1, 1
		sb		t1, 0(t0)
		
		ret

