.macro print_int(%r)
	save_args()
	
	mv a0, %r
	li a7, 1
	ecall
	
	recover_args()
.end_macro

.macro print_unsigned_int(%r)
	save_args()
	
	mv a0, %r
	li a7, 36
	ecall
	
	recover_args()
.end_macro

.macro print_space()
	save_args()

	la a0, espaco
	li a7, 4
	ecall

	recover_args()
.end_macro

.macro exit()
    	li a7, 10
	ecall
.end_macro

.macro wait()
	save_args()
	
	li a7, 32
	li a0, 1000
	ecall
	
	recover_args()
.end_macro

.macro save_args()
	addi sp, sp, -32
	sw a0, 0(sp)
	sw a1, 4(sp)
	sw a2, 8(sp)
	sw a3, 12(sp)
	sw a4, 16(sp)
	sw a5, 20(sp)
	sw a6, 24(sp)
	sw a7, 28(sp)
.end_macro

.macro recover_args()
	lw a0, 0(sp)
	lw a1, 4(sp)
	lw a2, 8(sp)
	lw a3, 12(sp)
	lw a4, 16(sp)
	lw a5, 20(sp)
	lw a6, 24(sp)
	lw a7, 28(sp)
	addi sp, sp, 32
.end_macro

.data
espaco: .string " "