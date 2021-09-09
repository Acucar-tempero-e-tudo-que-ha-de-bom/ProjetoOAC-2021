# Endereço do Bitmap Display
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
# Offset do mapa em relação ao personagem
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
# Aceleracao em pixeis/s da movimentacao horizontal
# Velocidade maxima em pixeis/s da movimentacao horizontal
#
.eqv MOV_X_ACC_LEFT		-60
.eqv MOV_X_ACC_RIGHT		60
.eqv MOV_X_DESACC_LEFT		30
.eqv MOV_X_DESACC_RIGHT		-30

.eqv MOV_X_MAX_RIGHT		240
.eqv MOV_X_MAX_LEFT		-240


#
# Physics
#
.eqv MAX_RUN			90
.eqv RUN_ACCEL			1000
.eqv RUN_REDUCE			400
