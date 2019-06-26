.segment "BANKFIXED"
.include "includes\bankFixed\reset.asm"

loop_main:
	jmp (loop_pointer)
end_loop:
	jsr nmi_wait
	jmp loop_main

loop_gameplay:
	ldx #$00
@song_try:
	lda map_pos
	and music_and_table1, x
	cmp music_cmp_table1, x
	bne :+
		lda prior_map
		and music_and_table2, x
		cmp music_cmp_table2, x
		bne :+
			lda music_song_select, x
			sta prior_map
			jsr music_loadsong
			jmp :++
:	inx
	cpx #(song_table_end - music_song_select)
	bne @song_try
:
	lda boss_wait
	beq :+
			lda #<loop_boss_start2
			sta loop_pointer+0
			lda #>loop_boss_start2
			sta loop_pointer+1
			lda #$06
			jsr music_loadsfx
			lda #$78
			sta boss_wait
:	lda e_types+0
	bne :+
		lda item_type+0
		cmp #$0b
		bne :+
			lda blocker1
			cmp #$ff
			beq :+
				lda #<loop_boss_done
				sta loop_pointer+0
				lda #>loop_boss_done
				sta loop_pointer+1
				lda #$00
				jsr music_loadsong
				lda #$07
				jsr music_loadsfx
				lda #$10
				sta boss_wait
:	lda control_pad
	eor control_old
	and control_pad
	and #start_punch
	beq :+
		lda #$01
		jsr music_loadsfx
		lda #<loop_pause
		sta loop_pointer+0
		lda #>loop_pause
		sta loop_pointer+1
		lda #<nmi_pause
		sta nmi_pointer+0
		lda #>nmi_pause
		sta nmi_pointer+1
		jmp @do_nmi
:
	lda map_pos
	cmp #$45
	bne :+
		lda p_pos
		cmp #$63
		beq :++
:	lda map_pos
	cmp #$70
	bcc :++
		lda p_pos
		and #$f0
		cmp #$a0
		bcc :++
:			lda #$10
			sta splash
			jsr music_loadsfx
			jsr reload_character
			jsr load_screen_pointers
			jmp @do_nmi
:

	lda p_pos
	and #$f0
	cmp #$b0
	bne :+
		lda p_pos
		sec
		sbc #$a0
		sta p_pos
		jsr screen_start_save
		lda #$04
		sta move_back_byte
		jsr restore_sprite_color_test
		lda map_pos
		sta prior_map
		clc
		adc #$10
		tax
		stx map_pos
		jsr load_screen_pointers
		jmp @do_nmi
:	cmp #$00
	bne :+
		lda p_pos
		clc
		adc #$a0
		sta p_pos
		jsr screen_start_save
		lda #$03
		sta move_back_byte
		jsr restore_sprite_color_test
		lda map_pos
		sta prior_map
		sec
		sbc #$10
		tax
		stx map_pos
		jsr load_screen_pointers
		jmp @do_nmi
:	lda p_pos
	and #$0f
	bne :+
		lda p_pos
		clc
		adc #$0e
		sta p_pos
		jsr screen_start_save
		lda #$02
		sta move_back_byte
		jsr restore_sprite_color_test
		lda map_pos
		sta prior_map
		ldx map_pos
		dex
		stx map_pos
		jsr load_screen_pointers
		jmp @do_nmi
:	cmp #$0f
	bne :+
		lda p_pos
		sec
		sbc #$0e
		sta p_pos
		jsr screen_start_save
		lda #$01
		sta move_back_byte
		jsr restore_sprite_color_test
		lda map_pos
		sta prior_map
		ldx map_pos
		inx
		stx map_pos
		jsr load_screen_pointers
		jmp @do_nmi
:	lda item_type
	cmp #$0b
	beq :+
	lda p_pos
	cmp item_pos
	bne :+
		lda #<loop_item1
		sta loop_pointer+0
		lda #>loop_item1
		sta loop_pointer+1
		lda #<nmi_item1
		sta nmi_pointer+0
		lda #>nmi_item1
		sta nmi_pointer+1
		lda #$03
		jsr music_loadsfx
		lda #$b4
		sta temp_8bit_1
		jmp @do_nmi
:
	jsr life_meter_routine
	jsr palette_animation_routine
	jsr bridge_anim
	jsr tele_move
	jsr controls_gameplay

	ldx #$00
		jsr e1_anim_start
		jsr e1_movement_jumper
	inx
		jsr e2_anim_start
		jsr e2_movement_jumper
	inx
		jsr e3_anim_start
		jsr e3_movement_jumper
	inx
		jsr e4_anim_start
		jsr e4_movement_jumper
	jsr p_hitboxes
	jsr e_hitboxes
	jsr e_shots_hitboxes
	jsr e_shot_block_check
	jsr hekl_damage_by_enemies	; check for hekl being hurt by enemy touch
	jsr hekl_damage_by_shots
	jsr e_damage_by_hekl
	jsr flicker_em

@do_nmi:
	jmp end_loop

loop_pause:
	lda control_pad
	eor control_old
	and control_pad
	and #start_punch
	beq :+
		lda #$01
		jsr music_loadsfx
		lda #<loop_gameplay
		sta loop_pointer+0
		lda #>loop_gameplay
		sta loop_pointer+1
		lda #<nmi_gameplay
		sta nmi_pointer+0
		lda #>nmi_gameplay
		sta nmi_pointer+1
:
	jmp end_loop
nmi_pause:
	ldx #$00
	lda #$23
	sta $2006
	lda #$2e
	sta $2006
:	lda pause_words, x
	sta $2007
	inx
	cpx #$10
	bne :-
	jmp end_nmi
pause_words:
	.byte "     PAUSED     "
loop_title:
	lda temp_16bit_4+0
	cmp #$01
	bne :+
		ldy #05
		jsr bank_save
		lda #<nmi_nada
		sta nmi_pointer+0
		lda #>nmi_nada
		sta nmi_pointer+1
		lda #<loop_nada
		sta loop_pointer+0
		lda #>loop_nada
		sta loop_pointer+1

		jmp flappy_reset

:	jsr test_secret_controller_code
	jsr palette_animation_routine
	lda control_pad
	eor control_old
	and control_pad
	and #start_punch
	beq :+
		dec title_switch
		lda #$01
		jsr music_loadsong
		jsr black_three_palettes
		lda #<loop_gameplay
		sta loop_pointer+0
		lda #>loop_gameplay
		sta loop_pointer+1
		jmp end_loop
:	lda control_pad
	eor control_old
	and control_pad
	and #select_punch
	beq :++++
		ldx #$00
		stx temp_8bit_1
		lda #$0f
:		sta pal_address, x
		inx
		cpx #$20
		bne :-
		ldx #$00
		lda #$ff
:		sta $200, x
		sta $400, x
		inx
		bne :-
:	bit $2002
	bpl :-
		lda #$00
		sta $2000
		sta $2001
		jmp loop_chr_load_change
;		lda #<loop_chr_load_change
;		sta loop_pointer+0
;		lda #>loop_chr_load_change
;		sta loop_pointer+1
:	jmp end_loop

loop_stuck:
	jmp loop_stuck



loop_chr_load_change:
	ldx temp_8bit_1
	lda chr_load_lo, x
	sta temp_16bit_1+0
	lda chr_load_hi, x
	sta temp_16bit_1+1
	ldy chr_bank, x
	jsr bank_save

	ldy #0
	sty $2006
	sty $2006
	ldx #16
:
	lda (temp_16bit_1), y
	sta $2007
	iny
	bne :-
		inc temp_16bit_1+1
		dex
		bne :-
	ldx temp_8bit_1
	lda nam_load_lo, x
	sta temp_16bit_1+0
	lda nam_load_hi, x
	sta temp_16bit_1+1
	ldy nam_bank, x
	jsr bank_save

	ldy #$00
	ldx #$04
	lda #$20
	sta $2006
	lda #$00
	sta $2006
:	lda (temp_16bit_1),y
	sta $2007
	iny
	bne :-
		inc temp_16bit_1+1
		dex
		bne :-
;	jmp loop_manual
:	bit $2002
	bpl :-
	lda #$00
	sta $2006
	sta $2006
	lda #%10001000
	sta $2000
	lda #%00011010
	sta $2001
		jsr nmi_wait
		lda #<loop_manual
		sta loop_pointer+0
		lda #>loop_manual
		sta loop_pointer+1
	jmp end_loop

chr_bank:
	.byte                 4,                6,                4
	.byte                 4,                6,                6
	.byte                 4,                4,                4
	.byte                 4,                4,                4
	.byte                 4,                4,                4
	.byte                 4,                4,                4
	.byte                 4,                4,                4
	.byte                 4,                4,				  4
chr_load_lo:
	.byte  <manual_controls, <manual_cover_, <manual_controls
	.byte  <manual_enemies1, <manual_story_, <manual_story_
	.byte  <manual_controls, <manual_controls, <manual_controls
	.byte  <manual_controls, <manual_controls, <manual_controls
	.byte  <manual_controls, <manual_enemies1, <manual_enemies1
	.byte  <manual_enemies1, <manual_enemies2, <manual_enemies1
	.byte  <manual_enemies2, <manual_enemies2, <manual_enemies1
	.byte  <manual_controls, <manual_bk_cover, <manual_bk_cover
chr_load_hi:
	.byte  >manual_controls, >manual_cover_, >manual_controls
	.byte  >manual_enemies1, >manual_story_, >manual_story_
	.byte  >manual_controls, >manual_controls, >manual_controls
	.byte  >manual_controls, >manual_controls, >manual_controls
	.byte  >manual_controls, >manual_enemies1, >manual_enemies1
	.byte  >manual_enemies1, >manual_enemies2, >manual_enemies1
	.byte  >manual_enemies2, >manual_enemies2, >manual_enemies1
	.byte  >manual_controls, >manual_bk_cover, >manual_bk_cover
nam_bank:
	.byte                 3,                3,                3
	.byte                 3,                3,                3
	.byte                 3,                3,                3
	.byte                 3,                3,                3
	.byte                 3,                3,                3
	.byte                 5,                5,                5
	.byte                 5,                5,                5
	.byte                 5,                5,				  5
nam_load_lo:
	.byte            <page00,          <page01,         <page02
	.byte            <page03,          <page04,         <page05
	.byte            <page06,          <page07,         <page08
	.byte            <page09,          <page10,         <page11
	.byte            <page12,          <page13,         <page14
	.byte            <page15,          <page16,         <page17
	.byte            <page18,          <page19,         <page20
	.byte            <page21,          <page22,         <page23
nam_load_hi:
	.byte            >page00,          >page01,         >page02
	.byte            >page03,          >page04,         >page05
	.byte            >page06,          >page07,         >page08
	.byte            >page09,          >page10,         >page11
	.byte            >page12,          >page13,         >page14
	.byte            >page15,          >page16,         >page17
	.byte            >page18,          >page19,         >page20
	.byte            >page21,          >page22,         >page23

loop_manual:
	lda control_pad
	eor control_old
	and control_pad
	and #left_punch
	beq :+++
		ldx temp_8bit_1
		beq :+++
			dex
			stx temp_8bit_1
		lda #$0f
:		sta pal_address, x
		inx
		cpx #$20
		bne :-
		jsr nmi_wait
		lda #$00
		sta $2000
		sta $2001
		lda #$3f
		sta $2006
		lda #$00
		sta $2006
		lda #$0f
:		sta $2007
		inx
		cpx #$20
		bne :-
		jmp loop_chr_load_change
		jmp end_loop
:
	lda control_pad
	eor control_old
	and control_pad
	and #right_punch
	beq :+++
		ldx temp_8bit_1
		cpx #23
		beq :+++
			inx
			stx temp_8bit_1
		lda #$0f
:		sta pal_address, x
		inx
		cpx #$20
		bne :-
		jsr nmi_wait
		lda #$00
		sta $2000
		sta $2001
		lda #$3f
		sta $2006
		lda #$00
		sta $2006
		lda #$0f
:		sta $2007
		inx
		cpx #$20
		bne :-
		jmp loop_chr_load_change
:
	lda control_pad
	eor control_old
	and control_pad
	and #b_punch
	beq :+
		jmp reset
:
	lda temp_8bit_1
	beq :+
	cmp #$01
	beq :+++
	cmp #23
	bne :++
:		lda #$0f
		sta pal_address+0
		sta pal_address+16
		lda #$00
		sta pal_address+1
		lda #$10
		sta pal_address+2
		lda #$30
		sta pal_address+3
		sta pal_address+5
		jmp end_loop
:
	lda #$30
	sta pal_address+0
	sta pal_address+16
	lda #$0c
	sta pal_address+1
	sta pal_address+9
	lda #$22
	sta pal_address+2
	lda #$32
	sta pal_address+3
	lda #$0f
	sta pal_address+5
	sta pal_address+10
	jmp end_loop
:	lda #$0f
	sta pal_address+0
	sta pal_address+4
	sta pal_address+8
	sta pal_address+12
	lda #$00
	sta pal_address+1
	sta pal_address+5
	lda #$30
	sta pal_address+3
	sta pal_address+7
	lda #$24
	sta pal_address+2
	sta pal_address+10
	lda #$2a
	sta pal_address+6
	sta pal_address+14
	lda #$12
	sta pal_address+9
	sta pal_address+13
	lda #$21
	sta pal_address+11
	sta pal_address+15
	jmp end_loop

pal_cover:
	.incbin "includes\bankFixed\manual_cover.pal"
code_check:
	.byte down_punch, down_punch, down_punch, right_punch
	.byte right_punch, right_punch, up_punch

test_secret_controller_code:
	ldx temp_8bit_2
	lda control_pad
	eor control_old
	and control_pad
	and code_check, x
	beq :+
		lda #$10
		sta temp_8bit_3
		lda temp_8bit_2
		clc
		adc #$01
		sta temp_8bit_2
		cmp #$07
		bne :+
			lda #$01
			sta temp_16bit_4+0	;success
			rts
:	lda temp_8bit_3
	beq :+
		sec
		sbc #$01
		sta temp_8bit_3
		rts
:	lda #$00
	sta temp_8bit_2
	rts


nmi:
	pha								; Save the registers
	txa								;
	pha								;
	tya								;
	pha								;

	lda $2002

	inc nmi_num

	lda #$02						; Do sprite transfer
	sta $4014						;

	ldx #$00
	lda #$3f						; refresh the palette
	sta $2006						;
	lda #$00						;
	sta $2006						;
:	lda pal_address, x				;
	sta $2007						;
	inx								;
	cpx #32						;
	bne :-							;

	jmp (nmi_pointer)
end_nmi:
	lda #$01
	sta $4016
	lda #$00
	sta $4016
	lda control_pad
	sta control_old
	ldx #$08
:	lda $4016
	lsr A
	ror control_pad
	dex
	bne :-

	lda #$00
	sta $2006
	sta $2006
	lda scroll_x
	sta $2005
	lda scroll_y
	sta $2005

	jsr music_play

	pla								; Restore the registers
	tay								;
	pla								;
	tax								;
	pla								;
irq:
	rti


nmi_wait:
	lda nmi_num						; Wait for an NMI to happen before running
:	cmp nmi_num						; the main loop again
	beq :-							;
	rts

nmi_gameplay:
	lda p_lives
	bmi :+
		clc
		adc #$30
		tay
		lda #$23
		sta $2006
		lda #$24
		sta $2006
		tya
		sta $2007
:	ldx #$00
	lda #$23
	sta $2006
	lda #$2e
	sta $2006
:	lda room_words, x
	sta $2007
	inx
	cpx #$10
	bne :-
	jmp end_nmi

screen_start_save:
	sta p_entrance
	lda p_dir
	sta p_dir_enter
	lda p_anim_state
;	and #$7f
	sta p_anim_enter
	lda p_state
	sta p_state_enter
	lda levitate_switch
	sta p_side_enter
	lda levitate_up
	sta p_up_enter
	rts

palette:
	.incbin "includes\bankFixed\hekl_title.pal"



palette_animation_routine:
	dec anim_ticker					; anim_ticker was set to #$08 towards
	bne :++							;  the beginning of the program.
		lda #$08					;  When it is zero, reset it to the
		sta anim_ticker				;  same value (it's a delay).
		ldx anim_offset				; If anim_offset is 1, then set it
		cpx #$01					;  back to zero. This is used to find
		bne :+						;  the proper value in pal_animation1.
			ldx #$00				;
			stx anim_offset			;
			jmp @next
:		inx
		stx anim_offset
		jmp @next
:	ldx anim_offset					; Put the data in the proper palette
	lda pal_animation1, x			;  using the value in anim_offset
	sta pal_address+21				;

	lda title_switch
	beq :+
		lda pal_animation1, x
		sta pal_address+5
		lda fire_title, x
		sta pal_address+14
:

	lda map_pos
	cmp #60
	beq :+
		cmp #61
		beq :+
			cmp #$45
			beq :+
			cmp #$44
			beq :+
			cmp #$43
			beq :+
			cmp #$70
			bcc :++
:		lda water1, x
		sta pal_address+13
		lda water2, x
		sta pal_address+14
:
	lda hekl_hurt
	and #%10000000
	cmp #$80
	bne :+
		lda pal_animation1, x
		sta pal_address+17
		sta pal_address+18
		jmp :++
:	lda #$01
	sta pal_address+17
	lda #$11
	sta pal_address+18
:

	lda map_pos
	and #$0f
	cmp #$0b
		bcc @nope
	cmp #$10
		bcs @nope
	lda map_pos
	and #$f0
	cmp #$40
		bcc @nope
	cmp #$70
		bcs @nope
			lda fire1, x
			sta pal_address+13
			lda fire2, x
			sta pal_address+14
			lda map_pos
			cmp #$6c
			beq @nope
			cmp #$5d
			beq @nope
				lda #$1c
				sta pal_address+29
				lda #$16
				sta pal_address+30
				lda #$27
				sta pal_address+31
@nope:
	lda map_pos
	cmp #$71
	bcc @next
		lda #$17
		sta pal_address+29
@next:
	rts
pal_animation1:
	.byte $2a,$25
water1:
	.byte $12,$21
water2:
	.byte $21,$12
fire1:
	.byte $0f,$27
fire2:
	.byte $27,$0f
fire_title:
	.byte $16,$27

music_and_table1:
	.byte $f0,$f0,$ff,$ff,$ff,$ff,$ff,$ff
music_cmp_table1:
	.byte $40,$30,$4e,$70,$60,$02,$03,$32
music_and_table2:
	.byte $f0,$f0,$ff,$ff,$ff,$ff,$ff,$ff
music_cmp_table2:
	.byte $30,$40,$4f,$60,$70,$03,$02,$22
music_song_select:
	.byte $06,$01,$07,$08,$06,$09,$01,$01
song_table_end:

nmi_empty:
	jmp end_nmi

.include "includes\bankFixed\sprite_anim.asm"
.include "includes\bankFixed\sprites.asm"
.include "includes\bankFixed\magic.asm"
.include "includes\bankFixed\controls.asm"
.include "includes\bankFixed\overworld_map.asm"
.include "includes\bankFixed\metatiles.asm"
.include "includes\bankFixed\items.asm"
.include "includes\bankFixed\enemies.asm"
.include "includes\bankFixed\ending.asm"
.include "includes\bankFixed\music_engine.asm"
.include "includes\bankFixed\music_data.asm"

.segment "BANKTABLE"
banks:
	.byte $00,$01,$02,$03,$04,$05,$06
bank_save:
	sty bank
bankswitch:
	lda banks, y		; read a byte from the banktable (banks)
	sta banks, y		;  and write it back, switching banks
	rts					;  store the current bank in RAM

.segment "VECTORS"
	.addr nmi
	.addr reset
	.addr irq
