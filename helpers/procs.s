####################### PROCEDIMENTO MAX ########################
#	ARGUMENTOS:						#
#		a0 = numero					#
#		a1 = numero					#
#	RETORNO:						#
#		retorna em a0 o maior valor entre a0 e a1	#
#################################################################

MAX:		bge		a0, a1, MAX.RET	# IF a0 > a1 JUMP MAX.RET
		mv		a0, a1		# returns a1
MAX.RET:	ret

####################### PROCEDIMENTO MIN ########################
#	ARGUMENTOS:						#
#		a0 = numero					#
#		a1 = numero					#
#	RETORNO:						#
#		retorna em a0 o menor valor entre a0 e a1	#
#################################################################

MIN:		ble		a0, a1, MIN.RET	# IF a0 < a1 JUMP MIN.RET
		mv		a0, a1		# returns a1
MIN.RET:	ret

#################### PROCEDIMENTO APPROACH ######################
#	ARGUMENTOS:						#
#		fa0 = val					#
#		fa1 = target					#
#		fa2 = maxMove					#
#	RETORNO:						#
#		retorna em fa0 o novo valor			#
#################################################################

APPROACH:	flt.s		t0, fa1, fa0	# target < val
		bnez		t0, APPROACH.MAX 

		fadd.s		fa0, fa0, fa2	# val + maxMove
		fmin.s		fa0, fa0, fa1	# return Min(val + maxMove, target)
		ret

APPROACH.MAX:	fsub.s		fa0, fa0, fa2	# val - maxMove
		fmax.s		fa0, fa0, fa1	# return Max(val - maxMove, target)
		ret

################### PROCEDIMENTO APPROACH.I #####################
#	ARGUMENTOS:						#
#		a0 = val					#
#		a1 = target					#
#		a2 = maxMove					#
#	RETORNO:						#
#		retorna em a0 o novo valor			#
#################################################################

APPROACH.I:	slt		t0, a1, a0	# target < val
		bnez		t0, APPROACH.MAX 

		add		a0, a0, a2	# val + maxMove
		j		MIN

APPROACH.I.MAX:	sub		a0, a0, a2	# val - maxMove
		j		MAX

###################### PROCEDIMENTO SIGN ########################
#	ARGUMENTOS:						#
#		fa0 = val					#
#	RETORNO:						#
#		retorna em a0 o sinal do float			#
#			-1 = negativo				#
#			0 = zero				#
#			1 = positivo				#
#################################################################

MATH.SIGN:	fcvt.s.w 	ft0, zero
		flt.s		t0, fa0, ft0
		bnez 		t0, MATH.SIGN.NEG	# if fa0 < zero, returns -1
		
		flt.s		t0, ft0, fa0
		bnez		t0, MATH.SIGN.POS	# else if zero < fa0, returns 1
		
		li		a0, 0			# else returns 0
		ret

MATH.SIGN.POS:	li		a0, 1
		ret

MATH.SIGN.NEG:	li		a0, -1
		ret
