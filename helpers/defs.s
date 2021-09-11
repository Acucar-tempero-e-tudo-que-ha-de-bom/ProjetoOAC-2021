# Endere�o do Bitmap Display
# (ja foi somado +30 na linha pra compensar a altura da tela que nao e 240)
.eqv F0_INIT_ADDR		0xff002580
.eqv F1_INIT_ADDR		0xff102580
.eqv FRAME_CONTROL_ADDRESS	0xFF200604

# KDMMIO
.eqv KDMMIO_CONTROL_ADDRESS	0xFF200000

# Largura e altura da tela
# Sim, a altura nao vai ser 240 pois Celeste se baseia em 16:9 (320:180)
.eqv SCREEN_WIDTH		320
.eqv SCREEN_HEIGHT		180

# Tamanho do mapa (mapa.bin)
.eqv MAPA_WIDTH			640
.eqv MAPA_HEIGHT		360

# Tamanho do personagem (char.bin)
.eqv CHAR_WIDTH			32
.eqv CHAR_HEIGHT		32

#
# Offset do mapa em rela��o ao personagem
# Calculo pra chegar no offset:
#	x = (largura da tela - char width) / 2
#	y = (altura da tela - char height) / 2
# Com MAP_OFFSET_Y = -78 o personagem fica no meio,
# mas acredito que o personagem deveria ficar um pouco mais abaixo da linha do meio,
# por isso coloquei -120.
#
.eqv MAP_OFFSET_X		-144
.eqv MAP_OFFSET_Y		-120

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
#.eqv HITBOX_X_OFFSET		6
#.eqv HITBOX_Y_OFFSET		16
#.eqv HITBOX_WIDTH		16
#.eqv HITBOX_HEIGHT		16

.eqv HITBOX_X_FEET_OFFSET	12
.eqv HITBOX_Y_FEET_OFFSET	32
