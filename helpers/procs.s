####################### PROCEDIMENTO MAX ########################
#	ARGUMENTOS:						#
#		a0 = numero					#
#		a1 = numero					#
#	RETORNO:						#
#		retorna em a0 o maior valor entre a0 e a1	#
#################################################################

MAX:		bge a0,a1,MAX.RET	# IF a0 > a1 JUMP MAX.RET
		mv a0,a1		# returns a1
MAX.RET:	ret

####################### PROCEDIMENTO MIN ########################
#	ARGUMENTOS:						#
#		a0 = numero					#
#		a1 = numero					#
#	RETORNO:						#
#		retorna em a0 o menor valor entre a0 e a1	#
#################################################################

MIN:		ble a0,a1,MIN.RET	# IF a0 < a1 JUMP MIN.RET
		mv a0,a1		# returns a1
MIN.RET:	ret

###################### PROCEDIMENTO MAX.F #######################
#	ARGUMENTOS:						#
#		fa0 = numero					#
#		fa1 = numero					#
#	RETORNO:						#
#		retorna em fa0 o maior valor entre fa0 e fa1	#
#################################################################

MAX.F:		flt.s t0, fa1, fa0
		bnez t0,MAX.F.RET	# IF fa1 < fa0 JUMP MAX.F.RET
		fmv.s fa0,fa1		# returns fa1
MAX.F.RET:	ret

###################### PROCEDIMENTO MIN.F #######################
#	ARGUMENTOS:						#
#		fa0 = numero					#
#		fa1 = numero					#
#	RETORNO:						#
#		retorna em fa0 o menor valor entre fa0 e fa1	#
#################################################################

MIN.F:		fle.s t0, fa0, fa1
		bnez t0,MIN.F.RET	# IF fa0 <= fa1 JUMP MIN.F.RET
		fmv.s fa0,fa1		# returns fa1
MIN.F.RET:	ret

#################### PROCEDIMENTO APPROACH ######################
#	ARGUMENTOS:						#
#		fa0 = val					#
#		fa1 = target					#
#		fa2 = maxMove					#
#	RETORNO:						#
#		retorna em fa0 o novo valor			#
#################################################################

APPROACH:	flt.s t0,fa1,fa0	# target < val
		bnez t0,APPROACH.MAX 

		fadd.s fa0,fa0,fa2	# val + maxMove
		j MIN.F			# min(val + maxMove, target)

APPROACH.MAX:	fsub.s fa0,fa0,fa2	# val - maxMove
		j MAX.F			# max(val - maxMove, target)

###################### PROCEDIMENTO SIGN ########################
#	ARGUMENTOS:						#
#		fa0 = val					#
#	RETORNO:						#
#		retorna em a0 o sinal do float			#
#			-1 = negativo				#
#			0 = zero				#
#			1 = positivo				#
#################################################################

MATH.SIGN:	fcvt.s.w ft0,zero
		flt.s t0,fa0,ft0
		bnez t0,MATH.SIGN.NEG
		
		flt.s t0,ft0,fa0
		bnez t0,MATH.SIGN.POS
		
		li a0, 0
		ret

MATH.SIGN.POS:	li a0, 1
		ret

MATH.SIGN.NEG:	li a0, -1
		ret