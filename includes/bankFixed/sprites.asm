
flicker_em:
	lda sprite_flicker
	cmp #$01
	beq @go_backward_init

@go_forward_init:
	ldy #$00
@go_forward:
	lda p_top_left, Y
	sta OAM_ram, Y
	iny
	lda p_top_left, Y
	sta OAM_ram, Y
	iny
	lda p_top_left, Y
	sta OAM_ram, Y
	iny
	lda p_top_left, Y
	sta OAM_ram, Y
	iny
	bne @go_forward
		lda #$01
		sta sprite_flicker
		rts
@go_backward_init:
	ldx #$00
	ldy #$00
;	ldy #$FC
@go_backward:
	lda p_top_left, X
	sta OAM_ram, Y
	iny
	inx
	lda p_top_left, X
	sta OAM_ram, Y
	iny
	inx
	lda p_top_left, X
	sta OAM_ram, Y
	iny
	inx
	lda p_top_left, X
	sta OAM_ram, Y
	tya
	sec
	sbc #$08
	tay
	iny
	inx
	bne @go_backward
		lda #$00
		sta sprite_flicker
@done:
	rts

life_table_3:
	.byte $27,$27,$27,$00,$00
life_table_4:
	.byte $27,$27,$27,$27,$00
life_table_5:
	.byte $27,$27,$27,$27,$27

life_meter_routine:
	lda hekl_life_meter
	cmp #$ff
	beq :++
		ldx #$00
		ldy #$00
:		lda lifey_1, x
		sta life1+1, y
		iny
		iny
		iny
		iny
		inx
		cpx #$05
		bne :-
		rts
:	dec p_lives
	lda #<loop_die
	sta loop_pointer+0
	lda #>loop_die
	sta loop_pointer+1
	lda #$0c
	sta p_anim_state
	lda #$00
	sta hekl_hurt
	lda #$b1
	sta temp_8bit_3
	rts


loop_die:
	lda temp_8bit_3
	beq :+
		dec temp_8bit_3
		jsr palette_animation_routine
		jsr cloud_offscreen
		jsr flicker_em
		jsr p_hitboxes
		lda p_anim_state
		jsr p_anim_jumper
		jmp end_loop
:	lda p_lives
	cmp #$ff
	bne :+

	lda #$05
	jsr music_loadsong
		lda #<loop_continue
		sta loop_pointer+0
		lda #>loop_continue
		sta loop_pointer+1
		lda #<nmi_continue
		sta nmi_pointer+0
		lda #>nmi_continue
		sta nmi_pointer+1
		jsr all_other_sprites_offscreen
		jsr flicker_em
		lda #$00
		sta temp_8bit_1
		jmp loop_continue
:
	jsr reload_character
	jsr load_screen_pointers
	lda #<nmi_gameplay
	sta nmi_pointer+0
	lda #>nmi_gameplay
	sta nmi_pointer+1
	jmp end_loop


reload_character:
	lda p_entrance
	sta p_pos
	jsr lay_p_sprites
	lda p_dir_enter
	sta p_dir
	lda	p_anim_enter
	sta p_anim_state
	lda p_state_enter
	sta p_state
	lda p_side_enter
	bne :+
		lda p_up_enter
		bne @no_levitate
:		lda #$06
		sta p_anim_state
		lda #$07
		sta p_state
		lda p_side_enter
		sta levitate_switch
		lda p_up_enter
		sta levitate_up
		jmp :+
@no_levitate:
	lda #$00
	sta levitate_switch
	sta levitate_up
:	jsr flicker_em
	jsr p_hitboxes
	jsr p_anim_jumper
	lda splash
	bne @done_life
	lda life_meter_offset
	clc
	adc #$02
	sta hekl_life_meter
	cmp #$02
	bne :+
		lda #$27
		sta lifey_1
		sta lifey_2
		jmp @done_life
:	cmp #$03
	bne :+
		lda #$27
		sta lifey_1
		sta lifey_2
		sta lifey_3
		jmp @done_life
:	cmp #$04
	bne :+
		lda #$27
		sta lifey_1
		sta lifey_2
		sta lifey_3
		sta lifey_4
		jmp @done_life
:	lda #$27
	sta lifey_1
	sta lifey_2
	sta lifey_3
	sta lifey_4
	sta lifey_5
@done_life:
	lda #$00
	sta splash
	rts





decrement_the_life:
	ldx #$04
:	lda lifey_1, x
	beq :+
		lda #$00
		sta lifey_1, x
		rts
:	dex
	bpl :--
	rts


the_sprites:
	.byte $5f,$01,$00,$50	; player
	.byte $5f,$02,$00,$58	;
	.byte $67,$03,$00,$50	;
	.byte $67,$04,$00,$58	;
	.byte $c7,$28,$00,$10	; lives icon
	.byte $d8,$00,$00,$10	; life
	.byte $d8,$00,$00,$18	;
	.byte $d8,$00,$00,$20	;
	.byte $d8,$00,$00,$28	;
	.byte $d8,$00,$00,$30	;
	.byte $c5,$2a,$01,$44	; selector
	.byte $f0,$26,$01,$f0	; shot
	.byte $f0,$29,$c1,$f0	;
	.byte $ff,$23,$01,$f8	; bridge
	.byte $ff,$23,$01,$ff	;
	.byte $ff,$23,$01,$ff	;
	.byte $ff,$23,$01,$ff	;
	.byte $ff,$23,$01,$ff	;
	.byte $ff,$23,$01,$ff	;
	.byte $ff,$2b,$01,$ff	; cloud1
	.byte $ff,$2b,$41,$ff	;
	.byte $ff,$3d,$01,$ff	; teleport
	.byte $ff,$3e,$01,$ff	;
	.byte $ff,$3f,$01,$ff	;
	.byte $ff,$48,$01,$ff	;
	.byte $ff,$2b,$81,$ff	; cloud2
	.byte $ff,$2b,$c1,$ff	;
	.byte $ff,$2e,$01,$ff


loop_continue:
	jsr palette_animation_routine
	jsr flicker_em
	lda temp_8bit_1
	cmp #$08
	beq :+
		jmp @done_control
:		lda control_pad
		eor control_old
		and control_pad
		and #up_punch
		beq @no_up
			lda #$0e
			jsr music_loadsfx
			lda #$25
			sta continue_select+0
			bne @done_control
@no_up:
		lda control_pad
		eor control_old
		and control_pad
		and #down_punch
		beq @no_down
			lda #$0e
			jsr music_loadsfx
			lda #$2d
			sta continue_select+0
			bne @done_control
@no_down:
		lda control_pad
		eor control_old
		and control_pad
		and #a_punch
		beq @no_a
;			lda #$01
;			jsr music_loadsong
			lda continue_select+0
			cmp #$2d
			bne :+
				jmp reset
:			lda #<nmi_cont2
			sta nmi_pointer+0
			lda #>nmi_cont2
			sta nmi_pointer+1
			lda #$01
			jsr music_loadsong
			lda #54
			sta map_pos
			lda #$15
			sta p_pos
			jsr lay_p_sprites
			lda #$00
			sta p_dir
			sta hekl_hurt
			sta levitate_switch
			sta levitate_up
			lda #$01
			sta p_anim_state
			sta p_state
			lda life_meter_offset
			clc
			adc #$02
			sta hekl_life_meter
			tay
			ldx #$00
			lda #$27
:			sta lifey_1, x
			inx
			dey
			bne :-
			jsr life_meter_routine
			lda #$02
			sta p_lives
			jsr p_hitboxes
			jsr p_anim_jumper
;			lda #$04
;			sta move_back_byte
			lda #$00
			tay
:			sta bg_ram, y
			iny
			cpy #$c0
			bne :-
			jsr load_screen_pointers
@no_a:
@done_control:
	jmp end_loop

cont_box0:
	.byte $12,$10,$10,$10, $10,$10,$10,$10, $10,$10,$10,$10, $10,$10,$10,$12
cont_box1:
	.byte $11,"CONTINUE?  YES",$11
cont_box2:
	.byte $11,"           NO ",$11
cont_box3:
	.byte $02,$01,$01,$01, $01,$01,$01,$01, $01,$01,$01,$01, $01,$01,$01,$02
cont_blank:
	.byte $00,$00,$00,$00, $00,$00,$00,$00, $00,$00,$00,$00, $00,$00,$00,$00
cont_ppu_lo:
	.byte $88,$a8,$c8,$e8,$88,$a8,$c8,$e8
cont_lo:
	.byte <cont_blank,<cont_blank,<cont_blank,<cont_blank
	.byte <cont_box0, <cont_box1, <cont_box2, <cont_box3
cont_hi:
	.byte >cont_blank,>cont_blank,>cont_blank,>cont_blank
	.byte >cont_box0, >cont_box1, >cont_box2, >cont_box3
;$23ca, $23cb, $23cc, $23cd <---- #$00 into those attributes
nmi_continue:
	ldx temp_8bit_1
	cpx #$08
	bne :+
		lda #$01
		sta continue_select+2
		lda #$25
		sta continue_select+0
		lda #$98
		sta continue_select+3
		lda #$2a
		sta continue_select+1
		lda #<nmi_gameplay
		sta nmi_pointer+0
		lda #>nmi_gameplay
		sta nmi_pointer+1
		jmp end_nmi
:	lda cont_ppu_lo, x
	sta ppu_addy+0
	lda cont_lo, x
	sta temp_16bit_1+0
	lda cont_hi, x
	sta temp_16bit_1+1
	ldy #$00
	lda #$20
	sta $2006
	lda ppu_addy+0
	sta $2006
:	lda (temp_16bit_1), y
	sta $2007
	iny
	cpy #$10
	bne :-
	inc temp_8bit_1
	lda #$23
	sta $2006
	lda #$ca
	sta $2006
	lda #$00
	sta $2007
	sta $2007
	sta $2007
	sta $2007
	jmp end_nmi

nmi_cont2:
	lda #$23
	sta $2006
	lda #$ca
	sta $2006
	lda #$55
	sta $2007
	sta $2007
	sta $2007
	sta $2007
	jmp end_nmi


lay_p_sprites:
	and #$f0
	sec
	sbc #$01
	sta p_top_left
	sta p_top_right
	clc
	adc #$08
	sta p_bot_left
	sta p_bot_right
	lda p_pos
	and #$0f
	rol
	rol
	rol
	rol
	and #$f0
	sta p_top_left+3
	sta p_bot_left+3
	clc
	adc #$08
	sta p_top_right+3
	sta p_bot_right+3
	rts
