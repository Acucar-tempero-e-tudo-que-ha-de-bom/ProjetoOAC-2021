.data
MUSIC_NOTAS:		.word 72,667,72,166,67,166,74,166,76,1167,76,166,77,166,79,833,81,333,79,166,77,333,76,333,74,333,72,166,74,166,76,333,76,166,77,166,79,2334,72,166,74,166,76,166,77,166,76,1667,72,667,72,166,67,166,72,166,79,1167,79,166,81,166,83,833,84,333,83,166,81,333,79,333,77,333,74,166,72,166,76,333,76,166,77,166,79,2334,84,166,86,166,88,2001,89,2334,88,166,86,166,84,2001,83,166,84,166,86,166,83,166,84,333,79,2668,74,166,76,166,77,333,76,1667,79,2334,81,166,83,166,84,2001,86,166,88,166,89,166,86,166,87,333,84,1667,77,166,79,166,83,166,79,166,84,333,79,2334,0,0
MUSIC_STATUS:		.word 0, 0

.text
MUSIC.SETUP:		# guarda endereco da proxima nota nos status
			la		t0, MUSIC_NOTAS
			la		t1, MUSIC_STATUS
			sw		t0, 4(t1)
			sw		zero, 0(t1)
		
			ret

###################### PROCEDIMENTO MUSIC ######################
#	ARGUMENTOS:						#
#		a0 = endereco status				#
#		a1 = instrumento				#
#		a2 = volume					#
#################################################################
MUSIC.PLAY:		la		a0, MUSIC_STATUS
			li		a2, 0
			li		a3, 50

			lw		t0, 0(a0)
			beqz		t0, MUSIC.PLAY.NOTE

			csrr		t1, 3073		# current time
			bltu		t1, t0, MUSIC.RET	# if (now < next note) do nothing ELSE play note

MUSIC.PLAY.NOTE:	lw		t0, 4(a0)		# t0 = current note address
			lw		t1, 0(t0)		# nota
			lw		t2, 4(t0)		# duracao

			beqz		t1, MUSIC.LAST.PLAYED	# nota == 0, só espera

			mv		t3, a0		# salva a0

			mv		a0, t1		# a0 = nota
			mv		a1, t2		# a1 = duracao
			li		a7, 31		# define a chamada de syscall
			ecall				# toca a nota

			mv		a0, t3		# restaura a0

MUSIC.LAST.PLAYED:	beqz		t2, MUSIC.SETUP	# nota == 0 e duracao == 0, recomeca

			csrr		t3, 3073	# current time
			add		t3, t3, t2	# current time + note duration = next note time
			sw		t3, 0(a0)	# save next note time

			addi		t0, t0, 8	# incrementa endereço da proxima nota
			sw		t0, 4(a0)	# salva proxima nota

MUSIC.RET:		ret

			# dash = pitch 22 inst 118 vol 50
SFX.DASH:		li a0, 22		# pitch
			li a1, 1000		# duracao
			li a2, 118		# instrumento
			li a3, 70		# volume
			li a7, 31		# define a chamada de syscall
			ecall
			
			ret