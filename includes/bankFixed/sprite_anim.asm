p_anim_table:
	.addr anim_no-1
	.addr anim_fall-1, anim_left-1, anim_right-1, anim_lev_start-1, anim_lev-1
	.addr anim_lev_left-1, anim_lev_right-1, anim_cast-1, anim_climb-1, anim_climb_still-1
	.addr anim_climb_down-1, anim_death-1
anim_climb_still:
	lda p_anim_state
;	cmp #$8a
;	beq @skip_init
	bmi @skip_init
		lda #<anim_climb_still1
		sta p_anim_addy+0
		lda #>anim_climb_still1
		sta p_anim_addy+1
		jsr p_anim_load
		lda p_anim_state
		clc
		adc #$80
		sta p_anim_state
@skip_init:
	dec p_anim_count
	beq :+
		rts
:	jsr p_anim_load
	rts
anim_climb_still1:
	.byte $38,$40
	.byte $37,$40
	.byte $3a,$40
	.byte $39,$40
	.byte $01
	.byte <anim_climb_still1, >anim_climb_still1
	.byte $ff

anim_climb:
	lda p_anim_state
;	cmp #$89
;	beq @skip_init
	bmi @skip_init
		ldx p_pos
		lda bg_ram, x
		bne :+
			lda #$00
			sta p_state
			sta p_anim_state
			rts
:		lda #<anim_climb1
		sta p_anim_addy+0
		lda #>anim_climb1
		sta p_anim_addy+1
		jsr p_anim_load
		lda p_anim_state
		clc
		adc #$80
		sta p_anim_state
@skip_init:
	dec p_anim_count
	lda p_anim_count
	beq :+
		rts
:		ldx p_pos
		lda bg_ram, x
		bne :+
			lda #$00
			sta p_state
			sta p_anim_state
			sta levitate_up
			sta levitate_switch
:	jsr p_anim_load
	rts
anim_climb1:
	.byte $37,$00
	.byte $38,$00
	.byte $39,$00
	.byte $3a,$00
	.byte $08
	.byte <anim_climb2, >anim_climb2
	.byte $ff
anim_climb2:
	.byte $38,$40
	.byte $37,$40
	.byte $3a,$40
	.byte $39,$40
	.byte $08
	.byte <anim_climb_still1, >anim_climb_still1
	.byte $ff

anim_climb_down:
	lda p_anim_state
;	cmp #$8b
;	beq @skip_init
	bmi @skip_init
		lda #<anim_climb11
		sta p_anim_addy+0
		lda #>anim_climb11
		sta p_anim_addy+1
		jsr p_anim_load
		lda p_anim_state
		clc
		adc #$80
		sta p_anim_state
@skip_init:
	dec p_anim_count
	beq :+
		rts
:	lda p_pos
	clc
	adc #$10
	tax
	lda bg_ram, x
	cmp #$03
	bne :+
		lda #$00
		sta p_state
		sta p_anim_state
:	jsr p_anim_load
	rts
anim_climb11:
	.byte $37,$00
	.byte $38,$00
	.byte $39,$00
	.byte $3a,$00
	.byte $08
	.byte <anim_climb21, >anim_climb21
	.byte $ff
anim_climb21:
	.byte $38,$40
	.byte $37,$40
	.byte $3a,$40
	.byte $39,$40
	.byte $08
	.byte <anim_climb_still1, >anim_climb_still1
	.byte $ff

anim_no:
	lda p_anim_state
;	cmp #$80
;	beq @skip_init
	bmi @skip_init
		lda p_dir
		bne :+
			lda #<anim_no_left
			sta p_anim_addy+0
			lda #>anim_no_left
			sta p_anim_addy+1
			jmp :++
:		lda #<anim_no_right
		sta p_anim_addy+0
		lda #>anim_no_right
		sta p_anim_addy+1
:		jsr p_anim_load
		lda p_anim_state
		clc
		adc #$80
		sta p_anim_state
@skip_init:
	dec p_anim_count
	beq :+
		rts
:	jsr p_anim_load
	rts
anim_no_left:
	.byte $02,$40
	.byte $01,$40
	.byte $04,$40
	.byte $03,$40
	.byte $01
	.byte <anim_no_left, >anim_no_left
	.byte $ff
anim_no_right:
	.byte $01,$00
	.byte $02,$00
	.byte $03,$00
	.byte $04,$00
	.byte $01
	.byte <anim_no_right, >anim_no_right
	.byte $ff


anim_fall:
	lda p_anim_state
;	cmp #$81
;	beq @skip_init
	bmi @skip_init
		lda p_dir
		bne :+
			lda #<anim_falll1
			sta p_anim_addy+0
			lda #>anim_falll1
			sta p_anim_addy+1
			jmp :++
:		lda #<anim_fallr1
		sta p_anim_addy+0
		lda #>anim_fallr1
		sta p_anim_addy+1
:		jsr p_anim_load
		lda p_anim_state
		clc
		adc #$80
		sta p_anim_state
@skip_init:
	dec p_anim_count
	beq :+
		rts
:	jsr p_anim_load
	rts
anim_falll1:
	.byte $12,$40
	.byte $11,$40
	.byte $14,$40
	.byte $13,$40
	.byte $10
	.byte <anim_falll1, >anim_falll1
	.byte $ff
anim_fallr1:
	.byte $11,$00
	.byte $12,$00
	.byte $13,$00
	.byte $14,$00
	.byte $10
	.byte <anim_fallr1, >anim_fallr1
	.byte $ff

anim_left:
	lda p_anim_state
;	cmp #$82
;	beq @skip_init
	bmi @skip_init
		lda #<anim_left1
		sta p_anim_addy+0
		lda #>anim_left1
		sta p_anim_addy+1
		jsr p_anim_load
		lda p_anim_state
		clc
		adc #$80
		sta p_anim_state
@skip_init:
	dec p_anim_count
	beq :+
		rts
:	jsr p_anim_load
	rts
anim_left1:
	.byte $16,$40
	.byte $15,$40
	.byte $18,$40
	.byte $17,$40
	.byte $08
	.byte <anim_left2, >anim_left2
	.byte $ff
anim_left2:
	.byte $1a,$40
	.byte $19,$40
	.byte $1c,$40
	.byte $1b,$40
	.byte $08
	.byte <anim_left3, >anim_left3
	.byte $ff
anim_left3:
	.byte $1e,$40
	.byte $1d,$40
	.byte $20,$40
	.byte $1f,$40
	.byte $08
	.byte <anim_left4, >anim_left4
	.byte $ff
anim_left4:
	.byte $1a,$40
	.byte $19,$40
	.byte $1c,$40
	.byte $1b,$40
	.byte $08
	.byte <anim_left1, >anim_left1
	.byte $ff

anim_right:
	lda p_anim_state
;	cmp #$83
;	beq @skip_init
	bmi @skip_init
		lda #<anim_right1
		sta p_anim_addy+0
		lda #>anim_right1
		sta p_anim_addy+1
		jsr p_anim_load
		lda p_anim_state
		clc
		adc #$80
		sta p_anim_state
@skip_init:
	dec p_anim_count
	beq :+
		rts
:	jsr p_anim_load
	rts
anim_right1:
	.byte $15,$00
	.byte $16,$00
	.byte $17,$00
	.byte $18,$00
	.byte $08
	.byte <anim_right2, >anim_right2
	.byte $ff
anim_right2:
	.byte $19,$00
	.byte $1a,$00
	.byte $1b,$00
	.byte $1c,$00
	.byte $08
	.byte <anim_right3, >anim_right3
	.byte $ff
anim_right3:
	.byte $1d,$00
	.byte $1e,$00
	.byte $1f,$00
	.byte $20,$00
	.byte $08
	.byte <anim_right4, >anim_right4
	.byte $ff
anim_right4:
	.byte $19,$00
	.byte $1a,$00
	.byte $1b,$00
	.byte $1c,$00
	.byte $08
	.byte <anim_right1, >anim_right1
	.byte $ff

anim_lev_start:
	lda p_anim_state
;	cmp #$84
;	beq @skip_init
	bmi @skip_init
		lda p_dir
		bne :+
			lda #<anim_lev_start_l1
			sta p_anim_addy+0
			lda #>anim_lev_start_l1
			sta p_anim_addy+1
			jmp :++
:		lda #<anim_lev_start_r1
		sta p_anim_addy+0
		lda #>anim_lev_start_r1
		sta p_anim_addy+1
:		jsr p_anim_load
		lda p_anim_state
		clc
		adc #$80
		sta p_anim_state
@skip_init:
	dec p_anim_count
	beq :+
		rts
:	jsr p_anim_load
	rts
; levitate start right
anim_lev_start_r1:
	.byte $05,$00
	.byte $06,$00
	.byte $07,$00
	.byte $08,$00
	.byte $18		; frames
	.byte <anim_lev_start_r2, >anim_lev_start_r2
	.byte $ff
anim_lev_start_r2:
	.byte $09,$00
	.byte $0a,$00
	.byte $0b,$00
	.byte $0c,$00
	.byte $04
	.byte <anim_lev_start_r3, >anim_lev_start_r3
	.byte $ff
anim_lev_start_r3:
	.byte $0d,$00
	.byte $0e,$00
	.byte $0f,$00
	.byte $10,$00
	.byte $04
	.byte <anim_lev_start_r2, >anim_lev_start_r2
	.byte $ff
; levitate start left
anim_lev_start_l1:
	.byte $06,$40
	.byte $05,$40
	.byte $08,$40
	.byte $07,$40
	.byte $18		; frames
	.byte <anim_lev_start_l2, >anim_lev_start_l2
	.byte $ff
anim_lev_start_l2:
	.byte $0a,$40
	.byte $09,$40
	.byte $0c,$40
	.byte $0b,$40
	.byte $04
	.byte <anim_lev_start_l3, >anim_lev_start_l3
	.byte $ff
anim_lev_start_l3:
	.byte $0e,$40
	.byte $0d,$40
	.byte $10,$40
	.byte $0f,$40
	.byte $04
	.byte <anim_lev_start_l2, >anim_lev_start_l2
	.byte $ff




anim_lev:

	rts
anim_lev_left:
	lda p_anim_state
;	cmp #$86
;	beq @skip_init
	bmi @skip_init
		lda p_dir
		bne :+
			lda #<anim_lev_left1
			sta p_anim_addy+0
			lda #>anim_lev_left1
			sta p_anim_addy+1
			jmp :++
:		lda #<anim_lev_right1
		sta p_anim_addy+0
		lda #>anim_lev_right1
		sta p_anim_addy+1
:		jsr p_anim_load
		lda p_anim_state
		clc
		adc #$80
		sta p_anim_state
@skip_init:
	dec p_anim_count
	beq :+
		rts
:	jsr p_anim_load
	rts
anim_lev_left1:
	.byte $0a,$40
	.byte $09,$40
	.byte $0c,$40
	.byte $0b,$40
	.byte $04
	.byte <anim_lev_left2, >anim_lev_left2
	.byte $ff
anim_lev_left2:
	.byte $0e,$40
	.byte $0d,$40
	.byte $10,$40
	.byte $0f,$40
	.byte $04
	.byte <anim_lev_left1, >anim_lev_left1
	.byte $ff
anim_lev_right1:
	.byte $09,$00
	.byte $0a,$00
	.byte $0b,$00
	.byte $0c,$00
	.byte $04
	.byte <anim_lev_right2, >anim_lev_right2
	.byte $ff
anim_lev_right2:
	.byte $0d,$00
	.byte $0e,$00
	.byte $0f,$00
	.byte $10,$00
	.byte $04
	.byte <anim_lev_right1, >anim_lev_right1
	.byte $ff	

anim_lev_right:

	rts
anim_cast:
	lda p_anim_state
;	cmp #$88
;	beq @skip_init
	bmi @skip_init
		lda p_dir
		bne :+
			lda #<anim_cast_left1
			sta p_anim_addy+0
			lda #>anim_cast_left1
			sta p_anim_addy+1
			jmp :++
:		lda #<anim_cast_right1
		sta p_anim_addy+0
		lda #>anim_cast_right1
		sta p_anim_addy+1
:		jsr p_anim_load
		lda p_anim_state
		clc
		adc #$80
		sta p_anim_state
@skip_init:
	dec p_anim_count
	beq :+
		rts
:	jsr p_anim_load
	rts
anim_cast_left1:
	.byte $06,$40
	.byte $05,$40
	.byte $08,$40
	.byte $07,$40
	.byte $08
	.byte <anim_cast_left2, >anim_cast_left2
	.byte $ff ; $08
anim_cast_left2:
	.byte $22,$40
	.byte $05,$40
	.byte $08,$40
	.byte $07,$40
	.byte $08
	.byte <anim_cast_left3, >anim_cast_left3
	.byte $ff
anim_cast_left3:
	.byte $06,$40
	.byte $05,$40
	.byte $08,$40
	.byte $07,$40
	.byte $08
	.byte <anim_cast_left4, >anim_cast_left4
	.byte $ff ; $08
anim_cast_left4:
	.byte $22,$40
	.byte $05,$40
	.byte $08,$40
	.byte $07,$40
	.byte $08
	.byte <anim_cast_left5, >anim_cast_left5
	.byte $ff
anim_cast_left5:
	.byte $06,$40
	.byte $05,$40
	.byte $08,$40
	.byte $07,$40
	.byte $08
	.byte <anim_cast_left6, >anim_cast_left6
	.byte $ff ; $08
anim_cast_left6:
	.byte $22,$40
	.byte $05,$40
	.byte $08,$40
	.byte $07,$40
	.byte $08
	.byte <anim_cast_left7, >anim_cast_left7
	.byte $ff
anim_cast_left7:
	.byte $06,$40
	.byte $05,$40
	.byte $08,$40
	.byte $07,$40
	.byte $08
	.byte <anim_cast_left8, >anim_cast_left8
	.byte $ff ; $08
anim_cast_left8:
	.byte $22,$40
	.byte $05,$40
	.byte $08,$40
	.byte $07,$40
	.byte $08
	.byte <anim_no, >anim_no
	.byte $00

anim_cast_right1:
	.byte $05,$00
	.byte $06,$00
	.byte $07,$00
	.byte $08,$00
	.byte $08
	.byte <anim_cast_right2, >anim_cast_right2
	.byte $ff
anim_cast_right2:
	.byte $05,$00
	.byte $22,$00
	.byte $07,$00
	.byte $08,$00
	.byte $08
	.byte <anim_cast_right3, >anim_cast_right3
	.byte $ff
anim_cast_right3:
	.byte $05,$00
	.byte $06,$00
	.byte $07,$00
	.byte $08,$00
	.byte $08
	.byte <anim_cast_right4, >anim_cast_right4
	.byte $ff
anim_cast_right4:
	.byte $05,$00
	.byte $22,$00
	.byte $07,$00
	.byte $08,$00
	.byte $08
	.byte <anim_cast_right5, >anim_cast_right5
	.byte $ff
anim_cast_right5:
	.byte $05,$00
	.byte $06,$00
	.byte $07,$00
	.byte $08,$00
	.byte $08
	.byte <anim_cast_right6, >anim_cast_right6
	.byte $ff
anim_cast_right6:
	.byte $05,$00
	.byte $22,$00
	.byte $07,$00
	.byte $08,$00
	.byte $08
	.byte <anim_cast_right7, >anim_cast_right7
	.byte $ff
anim_cast_right7:
	.byte $05,$00
	.byte $06,$00
	.byte $07,$00
	.byte $08,$00
	.byte $08
	.byte <anim_cast_right8, >anim_cast_right8
	.byte $ff
anim_cast_right8:
	.byte $05,$00
	.byte $22,$00
	.byte $07,$00
	.byte $08,$00
	.byte $08
	.byte <anim_no, >anim_no
	.byte $00



p_anim_jumper:
	lda p_anim_state
	and #%01111111
	asl a
	tay
	lda p_anim_table+1,y
	pha
	lda p_anim_table,y
	pha
	rts

p_anim_load:
	ldy #$00
	lda (p_anim_addy), y
	sta p_top_left+1
	iny
	lda (p_anim_addy), y
	sta p_top_left+2
	iny
	lda (p_anim_addy), y
	sta p_top_right+1
	iny
	lda (p_anim_addy), y
	sta p_top_right+2
	iny
	lda (p_anim_addy), y
	sta p_bot_left+1
	iny
	lda (p_anim_addy), y
	sta p_bot_left+2
	iny
	lda (p_anim_addy), y
	sta p_bot_right+1
	iny
	lda (p_anim_addy), y
	sta p_bot_right+2
	iny
	lda (p_anim_addy), y
	sta p_anim_count
	iny
	lda (p_anim_addy), y
	sta temp_addy+0
	iny
	lda (p_anim_addy), y
	sta temp_addy+1
	iny
	lda (p_anim_addy), y
	cmp #$ff
	beq :+
		sta p_anim_state
:
	lda temp_addy+0
	sta p_anim_addy+0
	lda temp_addy+1
	sta p_anim_addy+1

	lda p_anim_state
	cmp #$82
	bne @test_right
		lda move_counter
		bne :+
		lda control_pad
		and #$40
		bne :+
			lda #$00
			sta p_anim_state
			lda anim_no+0
			sta p_anim_addy+0
			lda anim_no+1
			sta p_anim_addy+1
:			rts
		
@test_right:
	lda p_anim_state
	cmp #$83
	bne :+
		lda move_counter
		bne :+
		lda control_pad
		and #$80
		bne :+
			lda #$00
			sta p_anim_state
			lda anim_no+0
			sta p_anim_addy+0
			lda anim_no+1
			sta p_anim_addy+1
:			rts

anim_death:
	lda p_anim_state
;	cmp #$8c
;	beq @skip_init
	bmi @skip_init
		lda p_dir
		bne :+
			lda #<anim_deathl1
			sta p_anim_addy+0
			lda #>anim_deathl1
			sta p_anim_addy+1
			jmp :++
:		lda #<anim_deathr1
		sta p_anim_addy+0
		lda #>anim_deathr1
		sta p_anim_addy+1
:		jsr p_anim_load
		lda p_anim_state
		clc
		adc #$80
		sta p_anim_state
@skip_init:
	dec p_anim_count
	beq :+
		rts
:	jsr p_anim_load
	rts
anim_deathl1:
	.byte $22,$40
	.byte $3b,$40
	.byte $08,$40
	.byte $3c,$40
	.byte $10
	.byte <anim_deathl2, >anim_deathl2
	.byte $ff
anim_deathl2:
	.byte $00,$40
	.byte $00,$40
	.byte $00,$40
	.byte $00,$40
	.byte $10
	.byte <anim_deathl1, >anim_deathl1
	.byte $ff
anim_deathr1:
	.byte $3b,$00
	.byte $22,$00
	.byte $3c,$00
	.byte $08,$00
	.byte $10
	.byte <anim_deathr2, >anim_deathr2
	.byte $ff
anim_deathr2:
	.byte $00,$00
	.byte $00,$00
	.byte $00,$00
	.byte $00,$00
	.byte $10
	.byte <anim_deathr1, >anim_deathr1
	.byte $ff

state_table:
	.addr not_moving-1
	.addr falling-1, moving_left-1, moving_right-1, climbing_up-1, climbing_down-1
	.addr levitate_start-1, levitating-1, lev_left-1, lev_right-1

not_moving:
	lda levitate_switch
	beq @no_down
	lda control_pad
	and #down_punch
	beq @no_down
		lda p_pos
		clc
		adc #$10
		tax
		lda bg_ram, x
		cmp #$03
		beq @no_down
			lda #$08
			sta move_counter
			lda #$01
			sta p_state
			sta p_anim_state
			lda #$00
			sta levitate_switch
			sta levitate_up
@no_down:
rts
falling:
	lda move_counter
	bne @move
		lda p_pos
		clc
		adc #$10
		sta p_pos
		lda #$00
		sta p_state
			sta levitate_switch
			sta levitate_up
		lda p_pos
		clc
		adc #$10
		tax
		lda bg_ram, x
		beq :+
		lda #$0c
		jsr music_loadsfx
		lda #$00
		sta p_anim_state
		rts
:		lda #$01
		sta p_anim_state
		rts
@move:
	dec move_counter
	inc p_top_left
	inc p_top_left
	rts
moving_left:
		lda move_counter
		bne @move
			ldx p_pos
			dex
			stx p_pos
			lda #$00
			sta p_state
			rts
@move:
	dec move_counter
	dec p_top_left+3
	rts
moving_right:
		lda move_counter
		bne @move
			ldx p_pos
			inx
			stx p_pos
			lda #$00
			sta p_state
			rts
@move:
	dec move_counter
	inc p_top_left+3
	rts
rts
levitate_start:
	lda move_counter
	bne :+
		lda p_pos
		sec
		sbc #$10
		sta p_pos
		lda #$07
		sta p_state
		rts
:	dec move_counter
	lda p_speed_lo
	sec
	sbc levitate_speed
	sta p_speed_lo
	lda p_top_left
	sbc #$00
	sta p_top_left
rts
levitating:

	lda control_pad
	and #a_punch
	beq @no_a
		lda levitate_up
		cmp levitate_up_amount
		beq @no_a
			lda p_pos
			sec
			sbc #$10
			tax
			lda bg_ram, x
			cmp #$03
			beq @no_a
				lda p_pos
				tax
				lda bg_ram, x
				cmp #$01
				beq @no_a
					inc levitate_up
					lda levitate_counter
					sta move_counter
					lda levitate_side_amount
					sta levitate_switch
					lda #$06
					sta p_state
					lda #$04
;					sta p_anim_state
				rts
@no_a:
	lda levitate_counter
	sta move_counter
	lda control_pad
	and #down_punch
	beq @no_down
		lda #$08
		sta move_counter
		lda #$01
		sta p_state
		sta p_anim_state
		lda #$00
		sta levitate_switch
		sta levitate_up
@no_down:
	rts
lev_left:
	lda move_counter
	bne @levitate
		ldx p_pos
		dex
		stx p_pos
		lda #$00
		sta p_state
		lda levitate_switch
		bne :+
			lda #$00
			sta p_anim_state
:		dec levitate_switch
		lda p_pos
		clc
		adc #$10
		tax
		lda bg_ram, x
		cmp #$03
		beq :+
			cmp #$01
			bne :++
:			lda #$00
			sta levitate_switch
			sta levitate_up
			sta p_anim_state
:
		rts
@levitate:
	lda #$00
	sta p_dir
	dec move_counter
	lda p_speed_lo
	sec
	sbc levitate_speed
	sta p_speed_lo
	lda p_top_left+3
	sbc #$00
	sta p_top_left+3
	rts
lev_right:
	lda move_counter
	bne @levitate
		ldx p_pos
		inx
		stx p_pos
		lda #$00
		sta p_state
		lda levitate_switch
		bne :+
			lda #$00
			sta p_anim_state
:		dec levitate_switch
		lda p_pos
		clc
		adc #$10
		tax
		lda bg_ram, x
		cmp #$03
		beq :+
			cmp #$01
			bne :++
:			lda #$00
			sta levitate_switch
			sta levitate_up
			sta p_anim_state
:
		rts
@levitate:
	lda #$01
	sta p_dir
	dec move_counter
	lda p_speed_lo
	clc
	adc levitate_speed
	sta p_speed_lo
	lda p_top_left+3
	adc #$00
	sta p_top_left+3
	rts
climbing_up:
	lda move_counter
	bne @move
		lda p_pos
		sec
		sbc #$10
		sta p_pos
		tax
		lda bg_ram, x
		cmp #$01
		bne :+
			lda #$00
			sta levitate_switch
			sta levitate_up
:
		lda #$00
		sta p_state
		rts
@move:
	dec move_counter
	dec p_top_left
	rts
climbing_down:
	lda move_counter
	bne @move_it
		lda p_pos
		clc
		adc #$10
		sta p_pos
		lda #$00
		sta p_state
		rts
@move_it:
	dec move_counter
	inc p_top_left
	rts
state_jumper:
	lda p_state
	asl a
	tay
	lda state_table+1,y
	pha
	lda state_table,y
	pha
	rts


