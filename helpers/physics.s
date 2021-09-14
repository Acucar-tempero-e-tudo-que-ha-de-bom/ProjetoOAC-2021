##################### PROCEDIMENTO PHYSICS ######################
#	ARGUMENTOS:						#
#		fa7 = delta time				#
#	REGISTRADORES:						#
#		fs0 = char x					#
#		fs1 = char y					#
#		fs2 = char x velocity				#
#		fs3 = char y velocity				#
#		fs4 = jump grace timer				#
#		fs5 = varJumpTimer				#
#		fs6 = varJumpSpeed				#
#		fs7 = maxfall					#
#								#
#		s0 = onGround					#
#################################################################

PHYSICS:		addi		sp, sp, -8
			sw		ra, 4(sp)		# salva ra
			sw		s0, 8(sp)		# salva s0
			
			# Decrements varJumpTimer
			# if (varJumpTimer > 0)
                    	# 	varJumpTimer -= Engine.DeltaTime;
                    	fcvt.s.w	ft0, zero
                    	fle.s		t0, fs5, ft0
                    	bnez		t0, PHYSICS.ISONGROUND
                    	fsub.s		fs5, fs5, fa7
			
PHYSICS.ISONGROUND:	# s0 = onGround
			la		t0, MAP_HITBOX		# t0 = block address
			li		t1, 8
			fcvt.s.w	ft1, t1			# ft1 = 8
			
			# Calculo do Y
			li		t1, HITBOX_Y_FEET_OFFSET
			fcvt.s.w	ft2, t1			# ft2 = y offset
			fadd.s		ft0, fs1, ft2		# ft0 = y + y offset
			fdiv.s		ft0, ft0, ft1		# ft0 = y / 8
			fcvt.wu.s	t1, ft0			# t1 = floor(ft0)
			fcvt.s.wu	ft0, t1
			
			li		t1, HITBOX_MAP_WIDTH
			fcvt.s.w	ft2, t1			# ft2 = hitbox map width
			
			fmul.s		ft0, ft0, ft2		# ft0 = ft0 * map width
			fcvt.wu.s	t1, ft0			# t1 = floor(ft0)
			add		t0, t0, t1		# t0 += t1
			
			mv		s10, t1

			# Calculo do X
			li		t1, HITBOX_X_FEET_OFFSET
			fcvt.s.w	ft3, t1			# ft2 = x offset
			
			fadd.s		ft2, fs0, ft3		# ft0 = char x + offset
			fdiv.s		ft2, ft2, ft1		# ft0 = x / 8
			fcvt.wu.s	t1, ft2			# t1 = floor(ft0)
			
			add		t2, t0, t1		# t2 = t0 + t1
			
			add		s10, s10, t1
			
			#addi		t2, t2, -3
			
			lbu		t1, 0(t2)
			#li a7, 1
			#mv a0, t1
			#ecall
			bnez		t1, PHYSICS.ONGROUND
			
			#fadd.s		ft2, fs0, ft3		# ft2 = char x + offset
			#fadd.s		ft2, ft2, ft1		# ft2 = char x + offset + 8
			#fdiv.s		ft2, ft2, ft1		# ft0 = x / 8
			#fcvt.w.s	t1, ft2			# t1 = floor(ft0)
			#add		t2, t0, t1		# t0 += t1
			
			#lb		t1, 0(t2)
			#bnez		t1, PHYSICS.ONGROUND
			
			li		s0, 0
			j PHYSICS.BEGIN

PHYSICS.ONGROUND:	li		s0, 1
			#fcvt.s.w	fs3, zero		# SpeedY = 0

PHYSICS.BEGIN:		# Reset jump grace
                    	beqz		s0, PHYSICS.JGRACETIMER	# if not onGround, tries to decrement jumpGraceTimer
			la		t0, JUMPGRACETIME	# resets grace timer if onGround
			flw		fs4, 0(t0)		# jumpGraceTimer = JumpGraceTime

PHYSICS.JGRACETIMER:	fcvt.s.w	ft0, zero
			fle.s		t0, fs4, ft0
			bnez		t0, PHYSICS.H		# if jumpGraceTimer <= 0, continue to horizontal movement
			fsub.s		fs4, fs4, fa7		# else jumpGraceTimer -= Engine.DeltaTime
			
			# Horizontal Movement
PHYSICS.H:		beqz		s0, PHYSICS.H.AIR
			
			li		t1, 1
			fcvt.s.w	ft3, t1			# ft3 = mult (1)
			j		PHYSICS.H.MAX
			
PHYSICS.H.AIR:		la		t0, AIR_MULT
			flw		ft3, 0(t0)		# ft3 = mult (AirMult)

PHYSICS.H.MAX:		li		t0, MAX_RUN
			fcvt.s.w	ft1, t0			# ft1 = max
			
			fabs.s		ft2, fs2		# ft2 = Abs(Speed.X)
			flt.s		t2, ft1, ft2		# t2 = max < Abs(Speed.X)

			la		t1, MOVEX
			lb		t1, 0(t1)		# t1 = moveX
			
			fmv.s		fa0, fs2
			call		MATH.SIGN		# a0 = Math.Sign(Speed.X)
			
			sub		t0, a0, t1		# t0 = Math.Sign(Speed.X) - moveX
			seqz		t0, t0			# t0 = Math.Sign(Speed.X) == moveX (se a subtracao for igual a 0 ambos sao iguais)
			
			and		t0, t0, t2		# max < Abs(Speed.X) && Math.Sign(Speed.X) == moveX (t0 & t2)
			beqz		t0, PHYSICS.H.ACC

PHYSICS.H.DESACC:	fmv.s		fa0, fs2		# fa0 = Speed.X
			
			fcvt.s.w	ft2, t1			# ft2 = moveX
			fmul.s		fa1, ft1, ft2		# fa1 = max * moveX
			
			li		t1, RUN_REDUCE
			fcvt.s.w	ft2, t1			# ft2 = RunReduce
			fmul.s		fa2, ft2, ft3		# fa2 = RunReduce * mult
			fmul.s		fa2, fa2, fa7		# fa2 = RunReduce * mult * deltaTime
			call		APPROACH
			
			fmv.s		fs2, fa0		# fs2 = Approach(Speed.X, max * moveX, RunReduce * mult * DeltaTime)
			
			j		PHYSICS.V

PHYSICS.H.ACC:		fmv.s		fa0, fs2		# fa0 = Speed.X
			
			fcvt.s.w	ft2, t1			# ft2 = moveX
			fmul.s		fa1, ft1, ft2		# fa1 = max * moveX
			
			li		t1, RUN_ACCEL
			fcvt.s.w	ft2, t1			# ft2 = RunAccel
			fmul.s		fa2, ft2, ft3		# fa2 = RunAccel * mult
			fmul.s		fa2, fa2, fa7		# fa2 = RunAccel * mult * deltaTime
			call		APPROACH
			
			fmv.s		fs2, fa0		# fs2 = Approach(Speed.X, max * moveX, RunAccel * mult * DeltaTime)

PHYSICS.V:		# Vertical Movement
			
			# Define maxFall
			li		t0, MAX_FALL
			fcvt.s.w	ft0, t0			# ft0 = mf
			li		t0, FAST_MAX_FALL
			fcvt.s.w	ft1, t0			# ft1 = fmf
			
			la		t0, MOVEY
			lb		t0, 0(t0)
			
			li		t1, 1
			bne		t0, t1, PHYSICS.MAX_FALL	# if moveY != 1, goes to max fall
			flt.s		t0, ft0, fs3
			beq		t0, t1, PHYSICS.MAX_FALL	# if mf < speedY, goes to max fall
			
			fmv.s		fa0, fs7		# maxFall
			fmv.s		fa1, ft1		# fmf
			
			li		t0, FAST_MAX_ACCEL
			fcvt.s.w	fa2, t0			# FastMaxAccel
			fmul.s		fa2, fa2, fa7		# FastMaxAccel * Engine.DeltaTime

			call		APPROACH		# Approach(maxFall, fmf, FastMaxAccel * Engine.DeltaTime)
			fmv.s		fs7, fa0		# maxFall = Approach(maxFall, fmf, FastMaxAccel * Engine.DeltaTime)
			
			j		PHYSICS.GRAVITY

PHYSICS.MAX_FALL:	fmv.s		fa0, fs7		# maxFall
			fmv.s		fa1, ft0		# mf
			
			li		t0, FAST_MAX_ACCEL
			fcvt.s.w	fa2, t0			# FastMaxAccel
			fmul.s		fa2, fa2, fa7		# FastMaxAccel * Engine.DeltaTime
			
			call		APPROACH		# Approach(maxFall, mf, FastMaxAccel * Engine.DeltaTime)
			fmv.s		fs7, fa0		# maxFall = Approach(maxFall, mf, FastMaxAccel * Engine.DeltaTime)

PHYSICS.GRAVITY:	# Gravity
			bnez		s0, PHYSICS.VARJUMP	# if onGround, goes to jump
			
			fabs.s		ft0, fs3		# ft0 = Abs(Speed.Y)
			li		t0, HALF_GRAV_THRESHOLD
			fcvt.s.w	ft1, t0			# ft1 = HalfGravThreshold
			
			flt.s		t0, ft0, ft1		# t0 = Abs(Speed.Y) < HalfGravThreshold
			
			la		t1, JUMP
			lb		t1, 0(t1)		# t1 = Jump
			
			and		t0, t0, t1		# t0 = Abs(Speed.Y) < HalfGravThreshold && Jump
			beqz		t0, PHYSICS.GRAVITY.MULT
			
			la		t0, HALF
			flw		ft0, 0(t0)		# ft0 = mult = 0.5
			
			j		PHYSICS.GRAVITY.CALC

PHYSICS.GRAVITY.MULT:	li		t0, 1
			fcvt.s.w	ft0, t0			# ft0 = mult = 1

PHYSICS.GRAVITY.CALC:	fmv.s		fa0, fs3		# Speed.Y
			fmv.s		fa1, fs7		# max
			
			li		t0, GRAVITY
			fcvt.s.w	fa2, t0			# Gravity
			fmul.s		fa2, fa2, ft0		# Gravity * mult
			fmul.s		fa2, fa2, fa7		# Gravity * mult * Engine.DeltaTime
			call		APPROACH
			
			fmv.s		fs3, fa0		# SpeedY = Approach(Speed.Y, max, Gravity * mult * Engine.DeltaTime)

PHYSICS.VARJUMP:	la		t0, JUMP
			lb		t1, 0(t0)		# t1 = jump pressed		
			
			# Variable jumping
                        fcvt.s.w	ft0, zero
                        fle.s		t0, fs5, ft0		# t0 = varJumpTimer <= 0
                        bnez		t0, PHYSICS.JUMP	# if (varJumpTime <= 0) ignores variable jumping
                        
                        beqz		t1, PHYSICS.VARJUMP.RST	# if (jump is not pressed) resets varJumpTimer
			
			fmin.s		fs3, fs3, fs6		# Speed.Y = Math.Min(Speed.Y, varJumpSpeed)
			
			j		PHYSICS.JUMP

PHYSICS.VARJUMP.RST:	fcvt.s.w	fs5, zero		# resets varJumpTimer

PHYSICS.JUMP:		# Jump
                        beqz		t1, PHYSICS.COLLISION	# if jump not pressed, JUMP to move
                        
                        fcvt.s.w	ft0, zero
                        fle.s		t0, fs4, ft0
                        bnez		t0, PHYSICS.COLLISION	# if jumpGraceTimer <= 0, JUMP to move
                        
                        la		t1, MOVEX
			lb		t1, 0(t1)		# t1 = moveX
			
			fcvt.s.w	fs4, zero		# jumpGraceTimer = 0
			
			la		t0, VARJUMPTIME
			flw		fs5, 0(t0)		# varJumpTimer = VarJumpTime
			
			li		t0, JUMP_H_BOOST
			fcvt.s.w	ft0, t0			# ft0 = JumpHBoost
			fcvt.s.w	ft1, t1			# ft1 = moveX
			fmul.s		ft0, ft0, ft1		# ft0 = JumpHBoost * moveX
			fadd.s		fs2, fs2, ft0		# Speed.Y += JumpHBoost * moveX

            		li		t0, JUMP_SPEED
            		fcvt.s.w	fs3, t0			# Speed.Y = JumpSpeed
            		
            		fmv.s		fs6, fs3		# varJumpSpeed = Speed.Y
			
PHYSICS.COLLISION:	la		t0, MAP_HITBOX		# t0 = block address
			li		t1, 8
			fcvt.s.w	ft1, t1			# ft1 = 8
			
			# Calculo do Y
			li		t1, HITBOX_Y_FEET_OFFSET
			addi		t1, t1, -1
			fcvt.s.w	ft2, t1			# ft2 = y offset
			
			fmul.s		ft3, fs3, fa7		# Speed.Y * DeltaTime
			fadd.s		ft3, fs1, ft3		# Pos.Y + Speed.Y * DeltaTime
			fadd.s		ft0, ft3, ft2		# ft0 = y + y offset
			fdiv.s		ft0, ft0, ft1		# ft0 = y / 8
			fcvt.wu.s	t1, ft0			# t1 = floor(ft0)
			fcvt.s.wu	ft0, t1
			
			li		t1, HITBOX_MAP_WIDTH
			fcvt.s.w	ft2, t1			# ft2 = hitbox map width
			
			fmul.s		ft0, ft0, ft2		# ft0 = ft0 * map width
			fcvt.wu.s	t1, ft0			# t1 = floor(ft0)
			add		t0, t0, t1		# t0 += t1
			
			li		t1, HITBOX_X_FEET_OFFSET
			fcvt.s.w	ft3, t1			# ft2 = x offset
			
			fadd.s		ft2, fs0, ft3		# ft0 = char x + offset
			fdiv.s		ft2, ft2, ft1		# ft0 = x / 8
			fcvt.wu.s	t1, ft2			# t1 = floor(ft0)
			
			add		t2, t0, t1		# t2 = t0 + t1
			
			#addi		t2, t2, -3
			
			lbu		t1, 0(t2)
			beqz		t1, PHYSICS.MOVE
			
			fcvt.s.w	fs3, zero		# Speed.Y = 0

PHYSICS.MOVE:		# MoveH
			fmul.s		ft0, fs2, fa7		# x vel * deltaTime
			fadd.s		fs0, fs0, ft0		# x += x vel * deltaTime
			
			# MoveV
			fmul.s		ft0, fs3, fa7		# y vel * deltaTime
			fadd.s		fs1, fs1, ft0		# y += y vel * deltaTime
			
			# TODO: Handle collisions
			
			lw		s0, 8(sp)		# restaura s0
			lw		ra, 4(sp)		# restaura ra
			addi		sp, sp, 8
			
			ret
