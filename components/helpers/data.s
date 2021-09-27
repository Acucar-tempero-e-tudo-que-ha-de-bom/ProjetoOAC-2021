#
# Posicao do personagem
# x, y
#

CHAR_POS:	.float 8, 111

MOVEX:		.byte 0		# left: -1, right: 1
MOVEY:		.byte 0		# up: -1, down: 1
JUMP:		.byte 0		# jump pressed: 1,  jump not pressed: 0

INPUT_ZEROES:	.byte 0		# may be temporary

AIR_MULT:			.float 0.65
JUMPGRACETIME:			.float 0.1
HALF:				.float 0.5
VARJUMPTIME:			.float 0.2

