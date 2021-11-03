F1.TO.F2:		la		t0, MAP_TRANSITION
			li		s5, 1
			sb		s5, 0(t0)		# map trasitioning = 1
			
			la		t0, MAP_TARGET_POS
			
			li		t1, F1_TO_F2_TARGET_X
			sh		t1, 0(t0)		# target x
			
			li		t1, F1_TO_F2_TARGET_Y
			sh		t1, 2(t0)		# target y
			
			la		t0, RESPAWN_POS
			
			li		t1, F1_TO_F2_CHAR_X
			fcvt.s.w	fs0, t1			# char x
			sh		t1, 0(t0)
			
			li		t1, F1_TO_F2_CHAR_Y
			fcvt.s.w	fs1, t1			# char y
			sh		t1, 2(t0)
			
			fcvt.s.w	fs2, zero
			fcvt.s.w	fs3, zero		# zeroes char speed
			
			la		t0, FASE_ATUAL
			li		t1, 2
			sb		t1, 0(t0)		# fase atual = 5
			
			ret

F2.TO.F3:		la		t0, MAP_TRANSITION
			li		s5, 1
			sb		s5, 0(t0)		# map trasitioning = 1
			
			la		t0, MAP_TARGET_POS
			
			li		t1, F2_TO_F3_TARGET_X
			sh		t1, 0(t0)		# target x
			
			li		t1, F2_TO_F3_TARGET_Y
			sh		t1, 2(t0)		# target y
			
			la		t0, RESPAWN_POS
			
			li		t1, F2_TO_F3_CHAR_X
			fcvt.s.w	fs0, t1			# char x
			sh		t1, 0(t0)
			
			li		t1, F2_TO_F3_CHAR_Y
			fcvt.s.w	fs1, t1			# char y
			sh		t1, 2(t0)
			
			fcvt.s.w	fs2, zero
			fcvt.s.w	fs3, zero		# zeroes char speed
			
			la		t0, FASE_ATUAL
			li		t1, 3
			sb		t1, 0(t0)		# fase atual = 5
			
			la		t0, CHAR_DIR
			li		t1, 1
			sb		t1, 0(t0)		# direcao do char = esquerda
			
			ret

F3.TO.F4:		la		t0, MAP_TRANSITION
			li		s5, 1
			sb		s5, 0(t0)		# map trasitioning = 1
			
			la		t0, MAP_TARGET_POS
			
			li		t1, F3_TO_F4_TARGET_X
			sh		t1, 0(t0)		# target x
			
			li		t1, F3_TO_F4_TARGET_Y
			sh		t1, 2(t0)		# target y
			
			la		t0, RESPAWN_POS
			
			li		t1, F3_TO_F4_CHAR_X
			fcvt.s.w	fs0, t1			# char x
			sh		t1, 0(t0)
			
			li		t1, F3_TO_F4_CHAR_Y
			fcvt.s.w	fs1, t1			# char y
			sh		t1, 2(t0)
			
			fcvt.s.w	fs2, zero
			fcvt.s.w	fs3, zero		# zeroes char speed
			
			la		t0, FASE_ATUAL
			li		t1, 4
			sb		t1, 0(t0)		# fase atual = 5
			
			la		t0, CHAR_DIR
			li		t1, 1
			sb		t1, 0(t0)		# direcao do char = esquerda
			
			ret

F4.TO.F5:		la		t0, MAP_TRANSITION
			li		s5, 1
			sb		s5, 0(t0)		# map trasitioning = 1
			
			la		t0, MAP_TARGET_POS
			
			li		t1, F4_TO_F5_TARGET_X
			sh		t1, 0(t0)		# target x
			
			li		t1, F4_TO_F5_TARGET_Y
			sh		t1, 2(t0)		# target y
			
			la		t0, RESPAWN_POS
			
			li		t1, F4_TO_F5_CHAR_X
			fcvt.s.w	fs0, t1			# char x
			sh		t1, 0(t0)
			
			li		t1, F4_TO_F5_CHAR_Y
			fcvt.s.w	fs1, t1			# char y
			sh		t1, 2(t0)
			
			la		t0, FIXED_MAP
			sb		zero, 0(t0)
			
			fcvt.s.w	fs2, zero
			fcvt.s.w	fs3, zero		# zeroes char speed
			
			la		t0, FASE_ATUAL
			li		t1, 5
			sb		t1, 0(t0)		# fase atual = 5
			
			la		t0, CHAR_DIR
			li		t1, 1
			sb		t1, 0(t0)		# direcao do char = esquerda
			
			ret
