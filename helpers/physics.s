##################### PROCEDIMENTO PHYSICS ######################
#	ARGUMENTOS:						#
#		fa2 = delta time				#
#		a2 = char status address			#
#################################################################
PHYSICS:		mv a6,ra		# saves ra
		
			#fmv.s ft0,fs4		# ft0 = acc
			#fmul.s ft0,ft0,fa2	# acc * deltaTime
			#fadd.s fa0,fs2,ft0	# vel -= acc * deltaTime
			
			#li t0,MOV_X_MAX_RIGHT
			#fcvt.s.w fa1,t0
			#call MIN.F
			
			#li t0,MOV_X_MAX_LEFT
			#fcvt.s.w fa1,t0
			#call MAX.F
			#fmv.s fs2,fa0

			#fmul.s ft0,fs2,fa2	# ft0 = x vel * deltaTime
			fadd.s fs0,fs0,fs2	# x += x vel * deltaTime

			#fmul.s ft0,fs3,fa2	# ft0 = y vel * deltaTime
			fadd.s fs1,fs1,fs3	# y += y vel * deltaTime

			mv ra,a6
			ret
