controls_gameplay:

	lda p_anim_state
	cmp #$88
	beq :+
		jmp @done_cast
:		lda p_anim_addy+0
		cmp #<anim_cast_right8
		bne @left_cast
			lda p_anim_addy+1
			cmp #>anim_cast_right8
			bne @left_cast
				lda magic_switch
				cmp #$01
				bne :+
					lda cloud1
					cmp #$ff
					bne @done_cast
						jsr lay_cloud
						dec magic_switch
						jmp @done_cast
:				cmp #$02
				bne :+
					lda bridge1
					cmp #$ff
					bne @done_cast
						jsr lay_bridge
						lda #$00
						sta magic_switch
						jmp @done_cast
:				cmp #$03
				bne @done_cast
					lda tele1
					cmp #$ff
					bne @done_cast
						jsr lay_tele
						lda #$00
						sta magic_switch
						jmp @done_cast
@left_cast:
		lda p_anim_addy+0
		cmp #<anim_cast_left8
		bne @done_cast
			lda p_anim_addy+1
			cmp #>anim_cast_left8
			bne @done_cast
				lda magic_switch
				cmp #$01
				bne @cast_bridge
					lda cloud1
					cmp #$ff
					bne @done_cast
						jsr lay_cloud
						dec magic_switch
						jmp @done_cast
@cast_bridge:
				cmp #$02
				bne @cast_tele
					lda bridge1
					cmp #$ff
					bne @done_cast
						jsr lay_bridge
						lda #$00
						sta magic_switch
						jmp @done_cast
@cast_tele:
				cmp #$03
				bne @done_cast
					lda tele1
					cmp #$ff
					bne @done_cast
						jsr lay_tele
						lda #$00
						sta magic_switch
@done_cast:
	lda hekl_hurt
	and #%10000000
	cmp #$80
	beq :+
	ldx p_pos
	lda bg_ram, x
	cmp #$02
	bne :++
		lda hekl_hurt
		and #%10000000
		cmp #$80
		beq :+
			lda #$0b
			jsr music_loadsfx
			lda #$f8
			sta hekl_hurt
			dec hekl_life_meter
			jsr decrement_the_life
	jsr life_meter_routine
:	lda hekl_hurt
	and #%01111111
	beq :+
		sec
		sbc #$01
		sta temp
		clc
		adc #$80
		sta hekl_hurt
		jmp @done_hurt
:	lda #$00
	sta hekl_hurt
@done_hurt:



	lda p_state
	cmp #$01
	bne :+
		jmp @do_state
:	lda levitate_switch
	bne @do_state
		lda p_pos
		clc
		adc #$10
		tax
		lda bg_ram, x
		cmp #$03
		beq @do_state
			cmp #$01
			beq @do_state
				ldx p_pos
				lda bg_ram, x
				cmp #$01
				beq @do_state
					lda #$01
					sta p_state
					sta p_anim_state
					lda #$08
					sta move_counter
@do_state:
	jsr state_jumper
	jsr p_anim_jumper

	lda tele1
	cmp #$ff
	beq :+
		jmp @done_control
:
	lda p_state
	beq :++
		lda p_state
		cmp #$07
		bne :+
			jmp @no_b
:			jmp @done_control
:
	lda levitate_switch
	beq :+
		jmp @no_b
:
	lda control_pad
	eor control_old
	and control_pad
	and #a_punch
	bne :+
		jmp @no_a
:		lda control_pad
		and #up_punch
		beq @not_cloud
			lda cloud1
			cmp #$ff
			bne :+++
				lda cloud_write_offset
				bne :+
					jmp @done_control
:				lda magic_join_offset
				bne :+
					jsr bridge_offscreen
:				lda #$08
				sta p_anim_state
				lda #$01
				sta magic_switch
				jmp @done_control
:			jsr cloud_offscreen
			jmp @done_control
@not_cloud:
		lda control_pad
		and #down_punch
		beq @not_bridge
			lda bridge1
			cmp #$ff
			bne :+++
				lda bridge_write_offset
				bne :+
					jmp @done_control
:				lda magic_join_offset
				bne :+
					jsr cloud_offscreen
:				lda #$08
				sta p_anim_state
				lda #$02
				sta magic_switch
				jmp @done_control
:			jsr bridge_offscreen
			jmp @done_control
@not_bridge:
	lda p_pos
	clc
	adc #$10
	tax
	lda bg_ram, x
	cmp #$03
	beq :+
	cmp #$01
	beq :+
		jmp @done_control
:		lda p_pos
		sec
		sbc #$10
		tax
		lda bg_ram, x
		cmp #$03
		beq @no_a
		ldx p_pos
		lda bg_ram, x
		cmp #$01
		beq @no_a
			inc levitate_up
			lda levitate_side_amount
			sta levitate_switch
			lda levitate_counter
			sta move_counter
			lda #$06
			sta p_state
			lda #$04
			sta p_anim_state
			jmp @done_control
@no_a:
	lda control_pad
	eor control_old
	and control_pad
	and #b_punch
	beq @no_b
		lda control_pad
		and #up_punch
		beq @no_b
				lda tele_write_offset
				bne :+
					jmp @done_control
:			lda control_pad
			eor #%00000010
			sta control_pad
			lda tele1
			cmp #$ff
			bne :++
				lda magic_join_offset
				bne :+
					jsr bridge_offscreen
					jsr cloud_offscreen
:				lda #$02
				sta tele_ticker
				lda #$08
				sta p_anim_state
				lda #$03
				sta magic_switch
				jmp @done_control
:			lda #$ff
			sta tele1
			sta tele2
			sta tele3
			sta tele4
			jmp @done_control
@no_b:
	lda quick_turn
	beq :+
		dec quick_turn
		jmp @no_right
:
	lda control_pad
	and #left_punch
	beq @no_left
		lda p_dir
		cmp #$01
		bne @no_quick1
			dec p_dir
			lda #$08
			sta quick_turn
			lda p_pos
			clc
			adc #$10
			tax
			lda bg_ram, x
			cmp #$03
			beq :+
				ldx p_pos
				lda bg_ram, x
				cmp #$01
				bne :+
					jmp @done_control
:			lda p_anim_state
			cmp #$84
			beq :+
			cmp #$86
			beq :+
				lda #$00
				sta p_state
				sta p_anim_state
				jmp @done_control
:			lda #$06
			sta p_anim_state
			jmp @done_control
@no_quick1:
		ldx p_pos
		dex
		lda bg_ram, x
		cmp #$03
		beq @no_left
			lda levitate_switch
			beq :+
;				inc levitate_up
				lda levitate_counter
				sta move_counter
				lda #$08
				sta p_state
				lda #$06
				sta p_anim_state
				jmp @done_control
:			lda #$00
			sta p_dir
			lda #$10
			sta move_counter
			lda #$02
			sta p_state
			lda p_anim_state
			cmp #$82
			beq :+
				lda #$02
				sta p_anim_state
:			jmp @done_control
@no_left:
	lda control_pad
	and #right_punch
	beq @no_right
		lda p_dir
		bne @no_quick2
			lda #$01
			sta p_dir
			lda #$08
			sta quick_turn
			lda p_pos
			clc
			adc #$10
			tax
			lda bg_ram, x
			cmp #$03
			beq :+
				ldx p_pos
				lda bg_ram, x
				cmp #$01
				bne :+
					jmp @done_control
:			lda p_anim_state
			cmp #$84
			beq :+
			cmp #$86
			beq :+
				lda #$00
				sta p_state
				sta p_anim_state
				jmp @done_control
:			lda #$06
			sta p_anim_state
			jmp @done_control
@no_quick2:
		ldx p_pos
		inx
		lda bg_ram, x
		cmp #$03
		beq @no_right
			lda levitate_switch
			beq :+
				lda levitate_counter
				sta move_counter
				lda #$09
				sta p_state
				lda #$06
				sta p_anim_state
				jmp @done_control
:			lda #$01
			sta p_dir
			lda #$10
			sta move_counter
			lda #$03
			sta p_state
			lda p_anim_state
			cmp #$83
			beq :+
				lda #$03
				sta p_anim_state
:			jmp @done_control
@no_right:
	lda control_pad
	and #up_punch
	beq @no_up
		ldx p_pos
		lda bg_ram, x
		cmp #$01
		bne @not_climbing1
			lda #$10
			sta move_counter
			lda #$04
			sta p_state
			lda #$09
			sta p_anim_state
			jmp @done_control
@not_climbing1:
@no_up:
	lda control_pad
	and #down_punch
	beq @no_down
		lda p_pos
		clc
		adc #$10
		tax
		lda bg_ram, x
		bne :+
			lda #$01
			sta p_anim_state
			sta p_state
			lda #$08
			sta move_counter
			jmp @done_control
:
		cmp #$01
		bne @no_down
			lda #$10
			sta move_counter
			lda #$05
			sta p_state
			lda #$0b
			sta p_anim_state
			jmp @done_control
@cant_climb_down:
@no_down:

@done_control:

	lda player_stats1
	and #$01
	beq @no_select
	lda control_pad
	eor control_old
	and control_pad
	and #select_punch
	beq @no_select
		lda #$0e
		jsr music_loadsfx
		lda selector+3
		cmp #$44
		bne :+
			lda #$5c
			sta selector+3
			bne @no_select
:		lda #$44
		sta selector+3
@no_select:

	lda p_shot1+3
	cmp #$04
	bcs :+
		lda #$00
		sta shooting
:
	lda p_anim_state
	cmp #$88
	bne :++
:		jmp @done_shot
:	lda tele1
	cmp #$ff
	bne :--
	lda shooting
	beq @not_shooting
		cmp #$01
		beq @regular_shot
			lda p_shot2
			cmp p_top_left
			bcc :+
				lda #$00
				sta shooting
				lda p_shot_sprite
				sta p_shot1+1
				lda #$f0
				sta p_shot2
				jsr clear_shot
				jmp @done_shot
:			lda p_shot1
			clc
			adc #$02
			sta p_shot1
			lda p_shot2
			clc
			adc #$02
			sta p_shot2
			lda p_top_right+3
			sta p_shot1+3
			sta p_shot2+3
			jmp @done_shot
@regular_shot:
		lda p_shot_sprite
		sta p_shot1+1
		lda shot_max_ram
		bne :+
			sta shooting
			jsr clear_shot
			jmp @following
:		sec
		sbc #$04
		sta shot_max_ram
		lda shot_dir
		beq @shoot_right
			lda p_shot1+3
			clc
			adc #$04
			sta p_shot1+3
			jmp @done_shot
@shoot_right:
		lda p_shot1+3
		sec
		sbc #$04
		sta p_shot1+3
		jmp @done_shot
@not_shooting:
		lda control_pad
		eor control_old
		and control_pad
		and #b_punch
		beq @following
			lda selector+3
			cmp #$5c
			beq @the_bolt
				lda #$09
				jsr music_loadsfx
				lda shot_max
				sta shot_max_ram
				lda #$01
				sta shooting
				lda p_dir
				sta shot_dir
				bne :+
					lda p_top_right
					sta p_shot1
					lda p_top_right+3
					sta p_shot1+3
					jmp @done_shot
:				lda p_top_right
				sta p_shot1
				lda p_top_left+3
				sta p_shot1+3
				jmp @done_shot
@the_bolt:
	lda #$0f
	jsr music_loadsfx
			jsr load_bolt
			jmp @done_shot

@following:
	lda #$ff
	sta p_shot1
@done_shot:
	rts

clear_shot:
			lda #$f0
			sta p_shot1
			sta p_shot2
			sta p_shot1+3
			sta p_shot2+3
			rts
load_bolt:
	lda #$02
	sta shooting
	lda #$29
	sta p_shot1+1
	lda #$00
	sta p_shot1
	clc
	adc #$08
	sta p_shot2
	lda p_top_right+3
	sta p_shot1+3
	sta p_shot2+3
	rts

p_hitboxes:
	lda p_top_left
	sta p_top_right
	sta p_top
	clc
	adc #$08
	sta p_bot_left
	sta p_bot_right
	clc
	adc #$08
	sta p_bot
	lda p_top_left+3
	sta p_bot_left+3
	clc
	adc #$04
	sta p_left
	clc
	adc #$04
	sta p_top_right+3
	sta p_bot_right+3
	clc
	adc #$08
	sta p_right

;	lda shooting
;	beq @nothing
;		cmp #$01
;		bne :+
			lda p_shot1
			clc
			adc #$01
			sta s_top
			clc
			adc #$03
			sta s_bot
			lda p_shot1+3
			clc
			adc #$02
			sta s_left
			clc
			adc #$03
			sta s_right
;			jmp @nothing
;:		lda p_shot1
;		sta s_top
;		clc
;		adc #$10
;		sta s_bot
;		lda p_shot1+3
;		clc
;		adc #$02
;		sta s_left
;		clc
;		adc #$04
;		sta s_right
@nothing:
	rts

e_damage_by_hekl:
	ldx #$00
@begin_again:
	lda e1_left, x
	cmp s_right
		bcc	:+
			jmp @no_coll
:	lda e1_right, x
	cmp s_left
		bcs :+
			jmp @no_coll
:	lda e1_top, x
	cmp s_bot
		bcc :+
			jmp @no_coll
:	lda e1_bot, x
	cmp s_top
		bcs :+
			jmp @no_coll
:
			lda e_types, x
			cmp #$02
			bne :+
				lda p_shot1+1
				cmp #$29
				beq @ping
					jmp @hit
:
			lda map_pos
			cmp #126
			bne :+
				lda e_types, x
				cmp #$05
				bne :+
					lda e_types+1
					beq @hit
						jmp @ping

:			lda e_types, x				; test for lastboss movement start
			cmp #$0f
			bne @test_garg
				lda e1_catchall, x
				bne @ping
				lda e1_speed_lo, x
				bne @ping
					lda #$01
					sta e1_speed_lo, x
					jmp @hit
@test_garg:
			lda e_types, x				; test for gargoyle invincible
			cmp #$0e
			bne @test_liz
				lda e_types+1
				bne @ping
					lda e_types+2
					bne @ping
						lda e_types+3
						bne @ping
							jmp @hit
@test_liz:
			lda e_types, x				; test for lizard shield
			cmp #$0c
			bne @hit
				lda e1_catchall, x
				cmp #$05
				beq @hit
				cmp #$06
				beq @hit
					lda p_left
					cmp e1_left, x
					bcs :+
						lda #$0c
						sta e1_anim_state, x
						lda #$01
						sta e1_catchall, x
							jmp @ping
:					lda #$0c
					sta e1_anim_state, x
					lda #$02
					sta e1_catchall, x
@ping:
			txa
			pha
			lda #$05
			jsr music_loadsfx
			pla
			tax
			jmp @shot_off
@hit:
			txa
			pha
			lda #$04
			jsr music_loadsfx
			pla
			tax
			lda e1_hp, x
			bmi :+
			bne :++
:				lda #$07
				sta e_types, x
				sta e1_anim_state, x
				jmp @shot_off
:			sec
			sbc p_shot_damage
			sta e1_hp, x
@shot_off:
			jsr clear_shot
;			lda #$00
;			sta s_top
;			sta s_bot
;			sta s_left
;			sta s_right
			lda #$00
			sta shooting

@no_coll:
	inx
	cpx #$04
	beq :+
		jmp @begin_again
:	rts

e_hitboxes:
	lda e_types+0
	bne :+
		jmp @do_two
:	cmp #$07
	bne :+
		lda #$ff
		sta e1_top
		sta e1_bot
		sta e1_left
		sta e1_right
		jmp @do_two
:	lda e1_top_left
	sta e1_top_right
	sta e1_top
	clc
	adc #$08
	sta e1_bot_left
	sta e1_bot_right
	clc
	adc #$07
	sta e1_bot
	lda e1_top_left+3
	sta e1_bot_left+3
	clc
	adc #$03
	sta e1_left
	clc
	adc #$05
	sta e1_top_right+3
	sta e1_bot_right+3
	clc
	adc #$05
	sta e1_right
@do_two:
	lda e_types+1
	bne :+
		jmp @do_three
:	cmp #$07
	bne :+
		lda #$ff
		sta e2_top
		sta e2_bot
		sta e2_left
		sta e2_right
		jmp @do_three
:
	lda e2_top_left
	sta e2_top_right
	sta e2_top
	clc
	adc #$08
	sta e2_bot_left
	sta e2_bot_right
	clc
	adc #$07
	sta e2_bot
	lda e2_top_left+3
	sta e2_bot_left+3
	clc
	adc #$03
	sta e2_left
	clc
	adc #$05
	sta e2_top_right+3
	sta e2_bot_right+3
	clc
	adc #$05
	sta e2_right
@do_three:
	lda e_types+2
	bne :+
		jmp @do_four
:	cmp #$07
	bne :+
		lda #$ff
		sta e3_top
		sta e3_bot
		sta e3_left
		sta e3_right
		jmp @do_four
:
	lda e3_top_left
	sta e3_top_right
	sta e3_top
	clc
	adc #$08
	sta e3_bot_left
	sta e3_bot_right
	clc
	adc #$07
	sta e3_bot
	lda e3_top_left+3
	sta e3_bot_left+3
	clc
	adc #$03
	sta e3_left
	clc
	adc #$05
	sta e3_top_right+3
	sta e3_bot_right+3
	clc
	adc #$05
	sta e3_right
@do_four:
	lda e_types+3
	bne :+
		rts
:	cmp #$07
	bne :+
		lda #$ff
		sta e4_top
		sta e4_bot
		sta e4_left
		sta e4_right
		jmp @wrap_er_up
:
	lda e4_top_left
	sta e4_top_right
	sta e4_top
	clc
	adc #$08
	sta e4_bot_left
	sta e4_bot_right
	clc
	adc #$07
	sta e4_bot
	lda e4_top_left+3
	sta e4_bot_left+3
	clc
	adc #$03
	sta e4_left
	clc
	adc #$05
	sta e4_top_right+3
	sta e4_bot_right+3
	clc
	adc #$05
	sta e4_right
@wrap_er_up:
	rts

e_shot_block_check:
	ldx #$00
@begin_again:
	lda e1shot_left, x
	cmp cube_right
		bcs @no_coll
	lda e1shot_right, x
	cmp cube_left
		bcc @no_coll
	lda e1shot_top, x
	cmp cube_bot
		bcs @no_coll
	lda e1shot_bot, x
	cmp cube_top
		bcc @no_coll
			txa
			bne :+
				lda #$ff
				sta e1_shot1
				bne @finish_up
:			cmp #$01
			bne :+
				lda #$ff
				sta e2_shot1
				bne @finish_up
:			cmp #$02
			bne :+
				lda #$ff
				sta e3_shot1
				bne @finish_up
:			cmp #$03
			bne :+
				lda #$ff
				sta e4_shot1
				bne @finish_up
:			cmp #$04
			bne :+
				lda #$ff
				sta extra_shot1
				bne @finish_up
:			lda #$ff
			sta extra_shot2
@finish_up:
		sta e1shot_top, x
		sta e1shot_bot, x
		sta e1shot_left, x
		sta e1shot_right, x
		lda e_types, x
		cmp #$0f
		beq @no_coll
			lda #$00
			sta e1_shooting, x
@no_coll:
	inx
	cpx #$06
	bne @begin_again
	rts
