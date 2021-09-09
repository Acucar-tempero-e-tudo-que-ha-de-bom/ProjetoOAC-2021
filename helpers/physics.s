##################### PROCEDIMENTO PHYSICS ######################
#	ARGUMENTOS:						#
#		fa7 = delta time				#
#################################################################

#
#	fs0 = char x
#	fs1 = char y
#	fs2 = char x velocity
#	fs3 = char y velocity
#
PHYSICS:		la t0,ONGROUND
			lb t1,0(t0)		# t0 = onGround
			beqz t1,PHYSICS.AIR
			
			li t1,1
			fcvt.s.w ft3,t1		# ft3 = mult (1)
			j PHYSICS.MAX
			
PHYSICS.AIR:		la t0,AIR_MULT
			flw ft3,0(t0)		# ft3 = mult (AirMult)

PHYSICS.MAX:		li t0,MAX_RUN
			fcvt.s.w ft1,t0		# ft1 = max
			
			fabs.s ft2,fs2		# ft2 = Abs(Speed.X)
			flt.s t2,ft1,ft2	# t2 = max < Abs(Speed.X)

			la t1,MOVEX
			lb t1,0(t1)		# t1 = moveX
			
			
			mv t3,ra		# saves ra
			
			fmv.s fa0,fs2
			call MATH.SIGN		# a0 = Math.Sign(Speed.X)
			
			sub t0,a0,t1		# t0 = Math.Sign(Speed.X) - moveX
			seqz t0,t0		# t0 = Math.Sign(Speed.X) == moveX (se a subtracao for igual a 0 ambos sao iguais)
			
			and t0,t0,t2		# max < Abs(Speed.X) && Math.Sign(Speed.X) == moveX (t0 & t2)
			beqz t0,PHYSICS.ACC

PHYSICS.RED:		fmv.s fa0,fs2		# fa0 = Speed.X
			
			fcvt.s.w ft2,t1		# ft2 = moveX
			fmul.s fa1,ft1,ft2	# fa1 = max * moveX
			
			li t1,RUN_REDUCE
			fcvt.s.w ft2,t1		# ft2 = RunReduce
			fmul.s fa2,ft2,ft3	# fa2 = RunReduce * mult
			fmul.s fa2,fa2,fa7	# fa2 = RunReduce * mult * deltaTime
			call APPROACH
			
			fmv.s fs2,fa0		# fs2 = Approach(Speed.X, max * moveX, RunReduce * mult * DeltaTime)
			
			j PHYSICS.MOVE

PHYSICS.ACC:		fmv.s fa0,fs2		# fa0 = Speed.X
			
			fcvt.s.w ft2,t1		# ft2 = moveX
			fmul.s fa1,ft1,ft2	# fa1 = max * moveX
			
			li t1,RUN_ACCEL
			fcvt.s.w ft2,t1		# ft2 = RunAccel
			fmul.s fa2,ft2,ft3	# fa2 = RunAccel * mult
			fmul.s fa2,fa2,fa7	# fa2 = RunAccel * mult * deltaTime
			call APPROACH
			
			fmv.s fs2,fa0		# fs2 = Approach(Speed.X, max * moveX, RunAccel * mult * DeltaTime)

PHYSICS.MOVE:		mv ra,t3		# restores ra

			fmul.s ft0,fs2,fa7	# x vel * deltaTime
			fadd.s fs0,fs0,ft0	# x += x vel * deltaTime
			
			fmul.s ft0,fs3,fa7	# y vel * deltaTime
			fadd.s fs1,fs1,fs3	# y += y vel * deltaTime

			ret
