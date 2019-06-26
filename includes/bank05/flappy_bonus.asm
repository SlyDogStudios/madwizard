right_side			=	$05

; Sprite ram
playerA				=	$200
playerB				=	$204
playerC				=	$208
playerD				=	$20c
score_tens			=	$210
score_ones			=	$214

bg					=	$25

flappy_reset:
:	bit $2002
	bpl :-
	ldx #$00
	stx $2000
	stx $2001
	txa
:	sta $000, x
	sta $200, x
	dex
	bne :-

	txa
	sta temp_16bit_1+0
	sta temp_16bit_1+1

clrmem:
	sta (temp_16bit_1),y
	iny
	bne clrmem
	inc temp_16bit_1+1
	dex
	bne clrmem

	tay


clrvid:
	sta $2007
	dex
	bne clrvid
	dey
	bne clrvid

	lda #$00
	sta $2006
	lda #$10
	sta $2006
:	lda flappy_chr, x
	sta $2007
	inx
	cpx #$ee
	bne :-
	lda #$00
	lda #$3f						; Set the values for the palette
	sta $2006						;
	lda #$00						;
	sta $2006						;
	lda #$0f						;
	sta $2007						;
	lda #$19
	sta $2007
	lda #$3f						; Set the values for the palette
	sta $2006						;
	lda #$10
	sta $2006
	lda #$0f						;
	sta $2007						;
	lda #$26
	sta $2007
	lda #$30						;
	sta $2007						;

	ldx #$00						; Pull in bytes for sprites and their
:	lda flappy_sprites, x			;  attributes which are stored in the
	sta playerA, x					;  'the_sprites' table. Use X as an index
	inx								;  to load and store each byte, which
	cpx #24							;  get stored starting in $200 
	bne :-							;

:	bit $2002
	bpl :-

		lda #<flappy_nmi
		sta nmi_pointer+0
		lda #>flappy_nmi
		sta nmi_pointer+1
		lda #<wait
		sta loop_pointer+0
		lda #>wait
		sta loop_pointer+1

	lda #%10000100
	sta $2000
	lda #%00011000
	sta $2001
wait:
	lda control_pad
	and #start_punch
	beq @no_start
		lda #<flappy_loop
		sta loop_pointer+0
		lda #>flappy_loop
		sta loop_pointer+1
		lda #$00
		sta temp_16bit_4+0
		beq flappy_loop					; CHANGED FROM JMP TO BNE TO SAVE A BYTE
@no_start:
	jmp end_loop						; CHANGED FROM JMP TO BEQ TO SAVE A BYTE


flappy_loop:
	lda #$0f
	sta pal_address+0
	sta pal_address+16
	jsr do_random_set

	lda scroll_x
	clc
	adc #$01
	sta scroll_x
	cmp #$92
	bcc :++
	cmp #$b2
	bcs :++
		ldx s_bot
		lda nmi_num, x
		cmp #$0b
		bne :+
			jmp nothing
:		ldx s_left
		lda nmi_num, x
		cmp #$0b
		bne :+
			jmp nothing
:
	lda scroll_x
	cmp #$b3
	bne :+
		jsr do_score
:

	lda scroll_x
	cmp #245
	bne :++
		ldx #$00
		ldy #$00
:		lda #$00
		sta bg, x
		sta bg+1, x
		txa
		clc
		adc #$10
		tax
		iny
		cpy #13
		bne :-
:
	lda temp_16bit_4+0
	bne :++
		ldx s_top
		lda column_lo, x
		sta temp_16bit_1+0
		lda column_hi, x
		sta temp_16bit_1+1
		ldx #$00
		ldy #$00
:		lda (temp_16bit_1), y
		sta bg, x
		sta bg+1, x
		txa
		clc
		adc #$10
		tax
		iny
		cpy #13
		bne :-

:

	lda control_pad
	eor control_old
	and control_pad
	and #a_punch
	beq @no_a
		jsr do_random_set
		lda #$01
		sta temp_16bit_2+1
		ldx #$00
		stx temp_16bit_3+0
@no_a:
	lda temp_16bit_2+1
	beq @moving_down
		ldx temp_16bit_3+0
		lda up_table, x
		clc
		adc playerA
		sta playerA
		sta playerB
		cmp #$04
		bcs :+
			lda #$00
			tax
			stx temp_16bit_3+0
			sta temp_16bit_2+1
			;jmp @moving_down
:		clc
		adc #$f8
		sta playerC
		sta playerD
		inx
		stx temp_16bit_3+0
		cpx #$10
		bne :+
			lda #$00
			sta temp_16bit_2+1
			beq @done_loop
:
		bne @done_move
@moving_down:
	lda playerA
	clc
	adc #$02
	sta playerA
	sta playerB
	clc
	adc #$08
	sta playerC
	sta playerD
	cmp #$f8
	bcc @done_move
		bne nothing
@done_move:
	lda playerA
	clc
	adc #10
	and #%11110000
	clc
	adc #right_side
	sta s_bot

	lda playerA
	clc
	adc #32
	and #%11110000
	clc
	adc #right_side
	sta s_left
@done_loop:

	jmp end_loop
	
	
	
	
nothing:
	lda control_pad
	and #start_punch
	beq @no_start
		jmp flappy_reset
@no_start:
	lda control_pad
	and #b_punch
	beq @no_b
		jmp reset
@no_b:
	jmp nothing
	
	
	
up_table:
	.byte $fe,$fe,$fe,$fe,$fe,$fe,$fe,$fe,$fe,$fe,$fe,$fe,$fe,$fe,$fe,$fe

do_random_set:
	lda temp_16bit_3+1
	beq @do_eor
	clc
	asl
	beq @no_eor    ;if the input was $80, skip the EOR
	bcc @no_eor
@do_eor:
	eor #$1d
@no_eor:
	sta temp_16bit_3+1
	ldx #$ff
:	inx
	lda temp_16bit_3+1
	cmp random_big, x
	bcc :-
		lda random_small, x
		sta s_top
@done:
	rts


random_big:
	.byte 213, 171, 129, 87, 45, 0
random_small:
	.byte   5,   4,   3,  2,  1, 0

do_score:
	lda score_tens+1
	cmp #$0a
	bne :+
		lda score_ones+1
		cmp #$0a
		bne :+
			beq @done			; CHANGED FROM JMP TO BEQ TO SAVE A BYTE
:	lda score_ones+1
	cmp #$0a
	beq :+
		clc
		adc #$01
		sta score_ones+1
		bne @done
:	lda #$01
	sta score_ones+1
		lda score_tens+1
		cmp #$0a
		beq :+
			clc
			adc #$01
			sta score_tens+1
			bne @done				; CHANGED FROM JMP TO BEQ TO SAVE A BYTE
:
@done:
	rts


flappy_nmi:
	lda temp_16bit_4+0
	bne :++
	ldx #$00
	ldy #$00
:	lda hi, x
	sta $2006
	lda lo, x
	sta $2006
	lda bg, y
	sta $2007
	sta $2007
	lda hi, x
	sta $2006
	lda lo, x
	clc
	adc #$01
	sta $2006
	lda bg, y
	sta $2007
	sta $2007
	tya
	clc
	adc #$10
	tay
	inx
	cpx #13
	bne :-
	lda #$01
	sta temp_16bit_4+0
:

	lda scroll_x
	cmp #245
	bne :++
	ldx #$00
:	lda hi, x
	sta $2006
	lda lo, x
	sta $2006
	lda #$00
	sta $2007
	sta $2007
	lda hi, x
	sta $2006
	lda lo, x
	clc
	adc #$01
	sta $2006
	lda #$00
	sta $2007
	sta $2007
	clc
	adc #$10
	inx
	cpx #13
	bne :-
	lda #$00
	sta temp_16bit_4+0
:
	lda #$3f
	sta $2006
	lda #$00
	sta $2006
	lda #$0f
	sta $2007
	lda #$3f
	sta $2006
	lda #$10
	sta $2006
	lda #$0f
	sta $2007
	jmp end_nmi


lo:
	.byte $5e,$9e,$de,$1e,$5e,$9e,$de,$1e,$5e,$9e,$de,$1e,$5e
hi:
	.byte $20,$20,$20,$21,$21,$21,$21,$22,$22,$22,$22,$23,$23
column_lo:
	.byte <column0,<column1,<column2,<column3,<column4,<column5
column_hi:
	.byte >column0,>column1,>column2,>column3,>column4,>column5
column0:
	.byte $0b,$0b,$0b,$00,$00,$00,$00,$0b,$0b,$0b,$0b,$0b,$0b
column1:
	.byte $0b,$0b,$0b,$0b,$00,$00,$00,$00,$0b,$0b,$0b,$0b,$0b
column2:
	.byte $0b,$0b,$0b,$0b,$0b,$00,$00,$00,$00,$0b,$0b,$0b,$0b
column3:
	.byte $0b,$0b,$0b,$0b,$0b,$0b,$00,$00,$00,$00,$0b,$0b,$0b
column4:
	.byte $0b,$0b,$0b,$0b,$0b,$0b,$0b,$00,$00,$00,$00,$0b,$0b
column5:
	.byte $0b,$0b,$00,$00,$00,$00,$0b,$0b,$0b,$0b,$0b,$0b,$0b

flappy_chr:
.incbin "includes\bank05\flappy_bonus.chr"

; Sprite definitions
flappy_sprites:
	.byte $5f,$0b,$00,$50			; playerA
	.byte $5f,$0b,$00,$58			; playerB
	.byte $67,$0b,$00,$50			; playerC
	.byte $67,$0b,$00,$58			; playerD
	.byte $20,$01,$00,$40			; score tens
	.byte $20,$01,$00,$48			; score ones

