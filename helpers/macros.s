.macro load_f_imm(%reg, %temp_reg, %imm)
li		%temp_reg, %imm
fcvt.s.w	%reg, %temp_reg
.end_macro
