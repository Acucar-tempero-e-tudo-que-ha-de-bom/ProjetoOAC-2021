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
#		fs8 = dash timer				#
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
			
			fadd.s		ft3, fs0, ft3		# ft0 = char x + offset
			fdiv.s		ft2, ft3, ft1		# ft0 = x / 8
			fcvt.wu.s	t1, ft2			# t1 = floor(ft0)
			
			add		t2, t0, t1		# t2 = t0 + t1
			
			add		s10, s10, t1
						
			lbu		t1, 0(t2)
			bnez		t1, PHYSICS.ONGROUND
			
			fadd.s		ft2, ft3, ft1		# ft2 = char x + offset + 8
			fdiv.s		ft2, ft2, ft1		# ft0 = x / 8
			fcvt.wu.s	t1, ft2			# t1 = floor(ft0)
			
			add		t2, t0, t1		# t0 += t1
			
			lbu		t1, 0(t2)
			bnez		t1, PHYSICS.ONGROUND
			
			li		s0, 0
			j		PHYSICS.BEGIN

PHYSICS.ONGROUND:	li		s0, 1

PHYSICS.BEGIN:		# Goes to dashing
			la		t0, DASHING
			lb		t0, 0(t0)			
			bnez		t0, PHYSICS.DASH
			
			# Reset jump grace
                    	beqz		s0, PHYSICS.JGRACETIMER	# if not onGround, tries to decrement jumpGraceTimer
			la		t0, JUMPGRACETIME	# resets grace timer if onGround
			flw		fs4, 0(t0)		# jumpGraceTimer = JumpGraceTime

PHYSICS.JGRACETIMER:	fcvt.s.w	ft0, zero
			fle.s		t0, fs4, ft0
			bnez		t0, PHYSICS.DASHTIMER	# if jumpGraceTimer <= 0, continue
			fsub.s		fs4, fs4, fa7		# else jumpGraceTimer -= Engine.DeltaTime

PHYSICS.DASHTIMER:	# Reset dashes
			beqz		s0, PHYSICS.CAN.DASH	# if not onGround, continue
			
			la		t0, DASHES
			li		t1, 1
			sb		t1, 0(t0)		# dashes = 1
			
PHYSICS.CAN.DASH:	la		t0, DASH
			lb		t0, 0(t0)		# t0 = dash pressed
			
			fcvt.s.w	ft0, zero
			fle.s		t1, ft0, fs8		# t1 = dash timer <= 0
			
			la		t2, DASHES
			lb		t2, 0(t2)
			slt		t2, zero, t2		# t2 = dashes > 0
			
			and		t0, t0, t1		# t0 = dash pressed && dash timer <= 0
			and		t0, t0, t2		# t0 = dash pressed && dash timer <= 0 && dashes > 0
			beqz		t0, PHYSICS.H
			
PHYSICS.START.DASH:	la		t0, DASHES
			lb		t1, 0(t0)		# t1 = dashes
			
			addi		a0, t1, -1
			mv		a1, zero
			call		MAX

			sb		a0, 0(t0)		# save new dashes value as Math.Max(0, dashes - 1)
			
			la		t0, DASHING
			li		t1, 1
			sb		t1, 0(t0)		# dashing = 1
			
			# Dash timer
			la		t0, DASHTIME
			flw		fs8, 0(t0)		# load inital dash time in dash timer
			
			li		t0, DASH_SPEED
			fcvt.s.w	ft0, t0			# ft0 = dash speed
			# Dash X speed
			la		t1, DASHX
			lb		t1, 0(t1)
			fcvt.s.w	ft1, t1			# ft1 = dash x direction
			
			fmul.s		fs2, ft1, ft0		# Speed.X = dash x speed
			
			# Dash Y speed
			la		t1, DASHY
			lb		t1, 0(t1)
			fcvt.s.w	ft1, t1			# ft1 = dash y direction
			
			fmul.s		fs3, ft1, ft0		# Speed.X = dash y speed
			
			j 		PHYSICS.COLLISION
			
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
            		
            		j		PHYSICS.COLLISION

PHYSICS.DASH:		fsub.s		fs8, fs8 fa7		# dash timer -= DeltaTime
			fcvt.s.w	ft0, zero
			fle.s		t0, fs8, ft0		# if dash timer <= 0
			
			beqz		t0, PHYSICS.COLLISION
			
PHYSICS.END.DASH:	la		t0, DASHING
			sb		zero, 0(t0)
			
			fcvt.s.w	fs8, zero		# zeroes dash timer
			
PHYSICS.COLLISION:	la		t6, MAP_HITBOX		# t0 = block address

			fmul.s		ft2, fs2, fa7		# Speed.X * DeltaTime
			fadd.s		ft2, fs0, ft2		# Pos.X + Speed.X * DeltaTime
			
			fmul.s		ft3, fs3, fa7		# Speed.Y * DeltaTime
			fadd.s		ft3, fs1, ft3		# Pos.Y + Speed.Y * DeltaTime
			
			# Colisao horizontal
			li		t1, 8
			fcvt.s.w	ft1, t1			# ft1 = 8
			
			fcvt.s.w	ft0, zero
			flt.s		t1, ft0, fs2		# Speed.X > 0
			bnez		t1, PHYSICS.COLL.X.RIGHT
			flt.s		t1, fs2, ft0		# Speed.X < 0
			bnez		t1, PHYSICS.COLL.X.LEFT
			
			j		PHYSICS.COLL.Y

PHYSICS.COLL.X.RIGHT:	li		t1, HITBOX_Y_RIGHT_OFFSET
			fcvt.s.w	ft4, t1			# ft4 = y offset
			
			fadd.s		ft0, ft3, ft4		# ft0 = y + y offset
			fdiv.s		ft0, ft0, ft1		# ft0 = y / 8
			fcvt.wu.s	t1, ft0			# t1 = floor(ft0)
			fcvt.s.wu	ft0, t1
			
			li		t1, HITBOX_MAP_WIDTH
			fcvt.s.w	ft4, t1			# ft4 = hitbox map width
			
			fmul.s		ft0, ft0, ft4		# ft0 = ft0 * map width
			fcvt.wu.s	t1, ft0			# t1 = floor(ft0)
			add		t4, t6, t1		# t0 += t1
			
			li		t1, HITBOX_X_RIGHT_OFFSET
			fcvt.s.w	ft4, t1			# ft4 = x offset
			
			fadd.s		ft4, ft2, ft4		# ft4 = char x + offset
			fdiv.s		ft5, ft4, ft1		# ft5 = x / 8
			fcvt.wu.s	t1, ft5			# t1 = floor(ft2)
			
			add		t2, t4, t1		# t2 = t0 + t1
			
			lbu		t1, 0(t2)
			bnez		t1, PHYSICS.COLL.X.HIT

			lbu		t1, HITBOX_MAP_WIDTH(t2)
			bnez		t1, PHYSICS.COLL.X.HIT
			
			j		PHYSICS.COLL.Y

PHYSICS.COLL.X.LEFT:	li		t1, HITBOX_Y_LEFT_OFFSET
			fcvt.s.w	ft4, t1			# ft4 = y offset
			
			fadd.s		ft0, ft3, ft4		# ft0 = y + y offset
			fdiv.s		ft0, ft0, ft1		# ft0 = y / 8
			fcvt.wu.s	t1, ft0			# t1 = floor(ft0)
			fcvt.s.wu	ft0, t1
			
			li		t1, HITBOX_MAP_WIDTH
			fcvt.s.w	ft4, t1			# ft4 = hitbox map width
			
			fmul.s		ft0, ft0, ft4		# ft0 = ft0 * map width
			fcvt.wu.s	t1, ft0			# t1 = floor(ft0)
			add		t4, t6, t1		# t0 += t1
			
			li		t1, HITBOX_X_LEFT_OFFSET
			fcvt.s.w	ft4, t1			# ft4 = x offset
			
			fadd.s		ft4, ft2, ft4		# ft4 = char x + offset
			fdiv.s		ft5, ft4, ft1		# ft5 = x / 8
			fcvt.wu.s	t1, ft5			# t1 = floor(ft2)
			
			add		t2, t4, t1		# t2 = t0 + t1
			
			lbu		t1, 0(t2)
			bnez		t1, PHYSICS.COLL.X.HIT

			lbu		t1, HITBOX_MAP_WIDTH(t2)
			bnez		t1, PHYSICS.COLL.X.HIT
			
			j		PHYSICS.COLL.Y

PHYSICS.COLL.X.HIT:	li		t2, 2			# espinhos = 2
			beq		t1, t2, PHYSICS.HIT.SPIKE
			
			la		t0, JUMPGRACETIME	# resets grace timer if onGround
			flw		fs4, 0(t0)		# jumpGraceTimer = JumpGraceTime
			
			fcvt.s.w	fs2, zero		# Speed.X = 0

PHYSICS.COLL.Y:		li		t1, 8
			fcvt.s.w	ft1, t1			# ft1 = 8
			
			# Colisao cabeca
			li		t1, HITBOX_Y_TOP_OFFSET
			fcvt.s.w	ft4, t1			# ft4 = y offset
			
			fadd.s		ft0, ft3, ft4		# ft0 = y + y offset
			fdiv.s		ft0, ft0, ft1		# ft0 = y / 8
			fcvt.wu.s	t1, ft0			# t1 = floor(ft0)
			fcvt.s.wu	ft0, t1
			
			li		t1, HITBOX_MAP_WIDTH
			fcvt.s.w	ft4, t1			# ft4 = hitbox map width
			
			fmul.s		ft0, ft0, ft4		# ft0 = ft0 * map width
			fcvt.wu.s	t1, ft0			# t1 = floor(ft0)
			add		t4, t6, t1		# t0 += t1
			
			li		t1, HITBOX_X_TOP_OFFSET
			fcvt.s.w	ft4, t1			# ft4 = x offset
			
			fadd.s		ft4, ft2, ft4		# ft4 = char x + offset
			fdiv.s		ft5, ft4, ft1		# ft5 = x / 8
			fcvt.wu.s	t1, ft5			# t1 = floor(ft2)
			
			add		t2, t4, t1		# t2 = t0 + t1
			
			lbu		t1, 0(t2)
			bnez		t1, PHYSICS.COLL.Y.HIT

			lbu		t1, 1(t2)
			bnez		t1, PHYSICS.COLL.Y.HIT
			
			# Colisao do pe
			# 	Calculo do Y
			li		t1, HITBOX_Y_FEET_OFFSET
			addi		t1, t1, -1
			fcvt.s.w	ft4, t1			# ft4 = y offset
			
			fadd.s		ft0, ft3, ft4		# ft0 = y + y offset
			fdiv.s		ft0, ft0, ft1		# ft0 = y / 8
			fcvt.wu.s	t1, ft0			# t1 = floor(ft0)
			fcvt.s.wu	ft0, t1
			
			# 	Calculo do X
			li		t1, HITBOX_MAP_WIDTH
			fcvt.s.w	ft4, t1			# ft4 = hitbox map width
			
			fmul.s		ft0, ft0, ft4		# ft0 = ft0 * map width
			fcvt.wu.s	t1, ft0			# t1 = floor(ft0)
			add		t6, t6, t1		# t6 += t1
			
			li		t1, HITBOX_X_FEET_OFFSET
			fcvt.s.w	ft4, t1			# ft4 = x offset
			
			fadd.s		ft4, fs0, ft4		# ft4 = char x + offset
			fdiv.s		ft5, ft4, ft1		# ft5 = x / 8
			fcvt.wu.s	t1, ft5			# t1 = floor(ft5)
			
			add		t2, t6, t1		# t2 = t0 + t1
			
			lbu		t1, 0(t2)
			bnez		t1, PHYSICS.COLL.Y.HIT
			
			fadd.s		ft5, ft4, ft1		# ft5 = (char x + offset) + 8
			fdiv.s		ft5, ft5, ft1		# ft5 = x / 8
			fcvt.wu.s	t1, ft5			# t1 = floor(ft5)
			
			add		t2, t6, t1		# t2 = t0 + t1
			
			lbu		t1, 0(t2)
			bnez		t1, PHYSICS.COLL.Y.HIT
			
			j		PHYSICS.MOVE

PHYSICS.COLL.Y.HIT:	li		t2, 2			# espinhos = 2
			beq		t1, t2, PHYSICS.HIT.SPIKE
			
			li		t2, 3			# trampolim = 3
			beq		t1, t2, PHYSICS.HIT.TRAMPOLIM
			
			fcvt.s.w	fs3, zero		# Speed.Y = 0

PHYSICS.MOVE:		# MoveH
			fmul.s		ft0, fs2, fa7		# x vel * deltaTime
			fadd.s		fs0, fs0, ft0		# x += x vel * deltaTime
			
			# MoveV
			fmul.s		ft0, fs3, fa7		# y vel * deltaTime
			fadd.s		fs1, fs1, ft0		# y += y vel * deltaTime
			
			lw		s0, 8(sp)		# restaura s0
			lw		ra, 4(sp)		# restaura ra
			addi		sp, sp, 8
			
PHYSICS.END:		ret

PHYSICS.HIT.SPIKE:	j		EXIT

PHYSICS.HIT.TRAMPOLIM:	#fsgnjn.s	fs3, fs3, fs3
			li		t0, TRAMPOLIM_SPEED
			li		t1, -1
			mul		t0, t0, t1
			fcvt.s.w	fs3, t0			# ft0 = dash speed
			j		PHYSICS.MOVE