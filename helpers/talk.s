TALK:
		addi		sp, sp, -4
		sw		ra, 0(sp)
		
		la		a0, FILE_TALK0	# "como diminui a fonte? kk"
		li		a1, 0
		li		a7, 1024
		ecall
		
		li		a1, 0	# x
		li		a2, 49	# y
		
		la		a3, FILE_TALK0_SIZE
		mv		a4, a3
		xori		a5, s1, 1
		mv		a6, zero
		mv		a7, zero
		call		RENDER
		call		AWAIT.KEYBOARD
		
		li		a7, 57	# close file
		ecall
		
		#####################
		
		la		a0, FILE_TALK1	# "nossa, eh voce..."
		li		a1, 0
		li		a7, 1024
		ecall
		
		li		a1, 18	# x
		li		a2, 46	# y
		
		la		a3, FILE_TALK_JLM_SIZE
		mv		a4, a3
		xori		a5, s1, 1
		mv		a6, zero
		mv		a7, zero
		call		RENDER
		call		AWAIT.KEYBOARD
		
		li		a7, 57
		ecall
		####################
		la		a0, FILE_TALK2	# "bagunca pythonica"
		li		a1, 0
		li		a7, 1024
		ecall
		
		li		a1, 18	# x
		li		a2, 46	# y
		
		la		a3, FILE_TALK_JLM_SIZE
		mv		a4, a3
		xori		a5, s1, 1
		mv		a6, zero
		mv		a7, zero
		call		RENDER
		call		AWAIT.KEYBOARD
		
		li		a7, 57
		ecall
		####################
		
		la		a0, FILE_TALK3	# "sim, sou eu"
		li		a1, 0
		li		a7, 1024
		ecall
		
		li		a1, 18	# x
		li		a2, 46	# y
		
		la		a3, FILE_TALK_ANA_SIZE
		mv		a4, a3
		xori		a5, s1, 1
		mv		a6, zero
		mv		a7, zero
		call		RENDER
		call		AWAIT.KEYBOARD
		
		li		a7, 57
		ecall
		
		#######################
		
		la		t0, ALREADY_TALKED
		li		t1, 1
		sb		t1, 0(t0)
		
		la		t0, GHOST_ACTIVE
		li		t1, 1
		sb		t1, 0(t0)
		
		lw		ra, 0(sp)
		addi		sp, sp, 4
		ret

AWAIT.KEYBOARD:	li 		t1, 0xFF200000		# carrega o endere�o de controle do KDMMIO
		lw 		t0, 0(t1)		# Le bit de Controle Teclado
   		andi 		t0, t0, 1		# mascara o bit menos significativo
   		beq 		t0, zero, AWAIT.KEYBOARD# n�o tem tecla pressionada ent�o volta ao loop
		lw 		t2, 4(t1)		# le o valor da tecla
		li		t3, 'j'			# pular conversa
		bne		t2, t3, AWAIT.KEYBOARD
		ret		# retorna
