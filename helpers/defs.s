# Endereco do Bitmap Display
# (ja foi somado +30 na linha pra compensar a altura da tela que nao e 240)
.eqv F0_INIT_ADDR		0xFF002580
.eqv F1_INIT_ADDR		0xFF102580
.eqv FRAME_CONTROL_ADDRESS	0xFF200604

# KDMMIO
.eqv KDMMIO_CONTROL_ADDRESS	0xFF200000
.eqv KDMMIO_KEYDOWN_ADDRESS	0xFF210000

# Largura e altura da tela
# Sim, a altura nao vai ser 240 pois Celeste se baseia em 16:9 (320:180)
.eqv SCREEN_WIDTH		320
.eqv SCREEN_HEIGHT		180

# Tamanho do mapa (mapa.bin)
.eqv MAPA_WIDTH			1320
.eqv MAPA_HEIGHT		728

# Tamanho do personagem (char.bin)
.eqv CHAR_WIDTH			32
.eqv CHAR_HEIGHT		32

#
# Offset do mapa em relacao ao personagem
# Calculo pra chegar no offset:
#	x = (largura da tela - char width) / 2
#	y = (altura da tela - char height) / 2
# Com MAP_OFFSET_Y = -78 o personagem fica no meio,
# mas acredito que o personagem deveria ficar um pouco mais abaixo da linha do meio,
# por isso coloquei -120.
#
.eqv MAP_OFFSET_X		-144
.eqv MAP_OFFSET_Y		-130

#
# Valor maximo pra "camera de mapa"
# Calculo pra chegar no valor maximo:
#	x = largura do mapa - largura da tela
#	y = altura do mapa - altura da tela
# O valor minimo obviamente e 0
#
.eqv MAP_MAX_X			320
.eqv MAP_MAX_Y			180

#
# Physics
#
.eqv MAX_RUN			90
.eqv RUN_ACCEL			1000
.eqv RUN_REDUCE			400

.eqv MAX_FALL			160
.eqv GRAVITY			900
.eqv FAST_MAX_FALL		240
.eqv FAST_MAX_ACCEL		300

.eqv HALF_GRAV_THRESHOLD	40

.eqv JUMP_SPEED			-105
.eqv JUMP_H_BOOST		40

#
# Hitbox
#
.eqv HITBOX_X_FEET_OFFSET	12
.eqv HITBOX_Y_FEET_OFFSET	32

.eqv HITBOX_X_LEFT_OFFSET	11
.eqv HITBOX_Y_LEFT_OFFSET	22

.eqv HITBOX_X_RIGHT_OFFSET	21
.eqv HITBOX_Y_RIGHT_OFFSET	22

.eqv HITBOX_X_TOP_OFFSET	12
.eqv HITBOX_Y_TOP_OFFSET	22

.eqv HITBOX_MAP_WIDTH		165
.eqv HITBOX_MAP_HEIGHT		91

#
# Dash
#
.eqv DASH_SPEED			240

#
# Trampolim
#
.eqv TRAMPOLIM_SPEED		-300

#
# Snow effect
#
.eqv SNOW_MAX_X			640	# snow width - screen width

#
# Transicoes de fase
#

# Fase 1 para Fase 2
.eqv F1_TO_F2_TARGET_X		1016
.eqv F1_TO_F2_TARGET_Y		360
.eqv F1_TO_F2_CHAR_X		1016
.eqv F1_TO_F2_CHAR_Y		480

# Fase 2 para Fase 3
.eqv F2_TO_F3_TARGET_X		952
.eqv F2_TO_F3_TARGET_Y		184
.eqv F2_TO_F3_CHAR_X		1240
.eqv F2_TO_F3_CHAR_Y		248

# Fase 3 para Fase 4
.eqv F3_TO_F4_TARGET_X		656
.eqv F3_TO_F4_TARGET_Y		0
.eqv F3_TO_F4_CHAR_X		936
.eqv F3_TO_F4_CHAR_Y		104

# Fase 4 para Fase 5
.eqv F4_TO_F5_TARGET_X		320
.eqv F4_TO_F5_TARGET_Y		0
.eqv F4_TO_F5_CHAR_X		600
.eqv F4_TO_F5_CHAR_Y		128
