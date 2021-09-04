####################### PROCEDIMENTO MAX ########################
#	ARGUMENTOS:						#
#		a0 = numero					#
#		a1 = numero					#
#	RETORNO:						#
#		retorna em a0 o maior valor entre a0 e a1	#
#################################################################

MAX:		bgt a0,a1,MAX.RET	# IF a0 > a1 JUMP MAX.RET
		mv a0,a1		# returns a1
MAX.RET:	ret

####################### PROCEDIMENTO MIN ########################
#	ARGUMENTOS:						#
#		a0 = numero					#
#		a1 = numero					#
#	RETORNO:						#
#		retorna em a0 o menor valor entre a0 e a1	#
#################################################################

MIN:		blt a0,a1,MIN.RET	# IF a0 < a1 JUMP MIN.RET
		mv a0,a1		# returns a1
MIN.RET:	ret

###################### PROCEDIMENTO RENDER ######################
#	ARGUMENTOS:						#
#		a0 = file descriptor				#
#		a1 = x na tela					#
#		a2 = y na tela					#
#		a3 = endereço do tamanho da imagem		#
#		a4 = endereco do tam. da area de desenho	#
#		a5 = frame (0 ou 1)				#
#		a6 = x na imagem				#
#		a7 = y na imagem				#
#################################################################

#
#	AVISO:
#	Estourou os argumentos desse procedimento, como no bin nao tem a informacao da largura/altura da imagem,
#	temos que passa-la manualmente, mas tambem precisamos passar a largura/altura que sera desenhado no frame.
#	Nao tem argumentos suficientes, tava pensando em:
#		a3 = endereco da memoria com a largura e altura da imagem
#		a4 = endereco da memoria com a largura e altura que sera desenhada
#	Vai ficar um pouco mais lento por ter que ler da memoria, mas e melhor que alguma gambiarra pra passar mais de 8 argumentos.
#
#	No momento ta funcionando + ou - sem a largura e altura a ser desenhada, mas e importante implementar principalmente
#	pra renderizar o mapa dinamico sem nenhum problema.
#	Atualmente a ultima faixa de pixels do mapa ta meio zuada, talvez esse seja o problema.
#

RENDER:		lhu t1,0(a3)

		# Calculo do offset na imagem
		mul t0,a7,t1		# t0 = y na imagem * tamanho de cada linha
		add t0,t0,a6		# offset imagem += x na imagem
		
		# Calculo frame
		li t1,0xFF0		# t1 = 0xFF0
		add a5,a5,t1		# frame = 0xFF0 + frame
		slli a5,a5,16		# frame << 16
		addi a5,a5,0x258	# soma 258 pra fazer o efeito de barra preta em cima
		slli a5,a5,4		# frame << 4
		
		# Calculo do offset na tela
		li t1,SCREEN_WIDTH
		mul t1,t1,a2		# t1 = 320 * y
		add t1,t1,a1		# t1 = (320 * y) + x
		add a5,t1,a5		# a5 = a5 + (320 * y) + x
		
		lhu t2,2(a4)
		# Calculo do endereço final na tela
		li t1,SCREEN_WIDTH
		mul t1,t1,t2		# t1 = 320 * h
		add t1,t1,a5		# t1 = a5 + (320 * h) + w
		
		lhu a3,0(a3)
		lhu a4,0(a4)
		
		# t0 = offset na imagem
		# s5 = offset na tela
		# t1 = endereço final da tela
		
RENDER.LOOP:	# salva a0 antes de fazer as syscalls
		mv t5,a0
		
		# seek no arquivo da imagem
		li a7,62
		mv a1,t0		# t0 = offset na imagem
		li a2,0
		ecall
		
		# restaura a0 pra proxima syscall
		mv a0,t5
		
		# read no arquivo da imagem
		li a7,63
		mv a1,a5		# a5 = offset na tela
		mv a2,a4		# TODO: problema aq
		ecall			# write line
		
		# restaura a0 pro proximo loop
		mv a0,t5
		
		# incrementar offset da imagem
		add t0,t0,a3		# offset da imagem += largura da imagem
		
		# incrementar offset da tela
		addi a5,a5,SCREEN_WIDTH	# offset da tela += largura da tela
		
		# a5 = endereco atual da tela
		# t1 = endereco final da tela
		# while a5 < t1 continue loop	
		bltu a5,t1,RENDER.LOOP

		ret
