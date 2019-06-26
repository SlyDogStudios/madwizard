e_move_table:
	.addr anim_enemy_no-1
	.addr move_ghost-1, move_trent-1, move_bat_h-1, move_bat_v-1, move_bones-1
	.addr move_spider-1, anim_enemy_no-1, move_gargoyle-1, move_golem-1, move_raven-1
	.addr move_goblin-1, move_lizard-1, move_bird-1, move_gargboss-1, move_lastboss-1

anim_enemy_no:
	rts

e1_movement_jumper:
	lda #<e1_top_left
	sta temp_16bit_1+0
	lda #>e1_top_left
	sta temp_16bit_1+1
	lda #<(e1_top_left+3)
	sta temp_16bit_2+0
	lda #>(e1_top_left+3)
	sta temp_16bit_2+1
	lda #<e1_shot1
	sta temp_16bit_3+0
	lda #>e1_shot1
	sta temp_16bit_3+1
	lda #<(e1_shot1+3)
	sta temp_16bit_4+0
	lda #>(e1_shot1+3)
	sta temp_16bit_4+1
	lda e_types+0
	bne :+
		rts
:	asl a
	tay
	lda e_move_table+1, y
	pha
	lda e_move_table, y
	pha
	rts
e2_movement_jumper:
	lda #<e2_top_left
	sta temp_16bit_1+0
	lda #>e2_top_left
	sta temp_16bit_1+1
	lda #<(e2_top_left+3)
	sta temp_16bit_2+0
	lda #>(e2_top_left+3)
	sta temp_16bit_2+1
	lda #<e2_shot1
	sta temp_16bit_3+0
	lda #>e2_shot1
	sta temp_16bit_3+1
	lda #<(e2_shot1+3)
	sta temp_16bit_4+0
	lda #>(e2_shot1+3)
	sta temp_16bit_4+1
	lda e_types+1
	bne :+
		rts
:	asl a
	tay
	lda e_move_table+1, y
	pha
	lda e_move_table, y
	pha
	rts
e3_movement_jumper:
	lda #<e3_top_left
	sta temp_16bit_1+0
	lda #>e3_top_left
	sta temp_16bit_1+1
	lda #<(e3_top_left+3)
	sta temp_16bit_2+0
	lda #>(e3_top_left+3)
	sta temp_16bit_2+1
	lda #<e3_shot1
	sta temp_16bit_3+0
	lda #>e3_shot1
	sta temp_16bit_3+1
	lda #<(e3_shot1+3)
	sta temp_16bit_4+0
	lda #>(e3_shot1+3)
	sta temp_16bit_4+1
	lda e_types+2
	bne :+
		rts
:	asl a
	tay
	lda e_move_table+1, y
	pha
	lda e_move_table, y
	pha
	rts
e4_movement_jumper:
	lda #<e4_top_left
	sta temp_16bit_1+0
	lda #>e4_top_left
	sta temp_16bit_1+1
	lda #<(e4_top_left+3)
	sta temp_16bit_2+0
	lda #>(e4_top_left+3)
	sta temp_16bit_2+1
	lda #<e4_shot1
	sta temp_16bit_3+0
	lda #>e4_shot1
	sta temp_16bit_3+1
	lda #<(e4_shot1+3)
	sta temp_16bit_4+0
	lda #>(e4_shot1+3)
	sta temp_16bit_4+1
	lda e_types+3
	bne :+
		rts
:	asl a
	tay
	lda e_move_table+1, y
	pha
	lda e_move_table, y
	pha
	rts


e_inc_x:
	lda e_pos, x
	clc
	adc #$01
	sta e_pos, x
	rts
e_dec_x:
	lda e_pos, x
	sec
	sbc #$01
	sta e_pos, x
	rts
e_inc_y:
	lda e_pos, x
	clc
	adc #$10
	sta e_pos, x
	rts
e_dec_y:
	lda e_pos, x
	sec
	sbc #$10
	sta e_pos, x
	rts

move_ghost:
	lda e1_left, x
	cmp p_left
	bcs :+
		ldy #$00
		lda e1_speed_lo, x
		clc
		adc #<ghost_speed
		sta e1_speed_lo, x
		lda (temp_16bit_2), y
		adc #>ghost_speed
		sta (temp_16bit_2), y
		jmp :++
:	ldy #$00
	lda e1_speed_lo, x
	sec
	sbc #<ghost_speed
	sta e1_speed_lo, x
	lda (temp_16bit_2), y
	sbc #>ghost_speed
	sta (temp_16bit_2), y
:	lda e1_top, x
	cmp p_top
	bne :+
		rts
:	bcs :+
		lda e1_speed_lo2, x
		clc
		adc #<ghost_speed
		sta e1_speed_lo2, x
		lda (temp_16bit_1), y
		adc #>ghost_speed
		sta (temp_16bit_1), y
		rts
:	ldy #$00
	lda e1_speed_lo2, x
	sec
	sbc #<ghost_speed
	sta e1_speed_lo2, x
	lda (temp_16bit_1), y
	sbc #>ghost_speed
	sta (temp_16bit_1), y
	rts

move_trent:
	lda e1_catchall, x
	beq :++
		sec
		sbc #$01
		sta e1_catchall, x
		cmp #$01
		bne :+
			txa
			pha
			lda #$0d
			jsr music_loadsfx
			pla
			tax
:		rts
:	jsr trent_bullet
	lda e1_dir, x
	beq @other_dir
		lda #$01
		sta e1_shooting, x
		ldy #$00
		lda (temp_16bit_3), y
		cmp #$ff
		bne :+
			lda (temp_16bit_1), y
			clc
			adc #$05
			sta (temp_16bit_3), y
			lda (temp_16bit_2), y
			clc
			adc #$05
			sta (temp_16bit_4), y
:		lda (temp_16bit_4), y
		cmp #$08
		bcs :+
			lda #$f0
			sta e1_catchall, x
			lda #$00
			sta e1_shooting, x
			lda #$ff
			sta (temp_16bit_3), y
			rts
:		clc
		adc #$02
		sta (temp_16bit_4), y
		rts
@other_dir:
		lda #$01
		sta e1_shooting, x
		ldy #$00
		lda (temp_16bit_3), y
		cmp #$ff
		bne :+
			lda (temp_16bit_1), y
			clc
			adc #$05
			sta (temp_16bit_3), y
			lda (temp_16bit_2), y
			sta (temp_16bit_4), y
:		lda (temp_16bit_4), y
		cmp #$08
		bcs :+
			lda #$f0
			sta e1_catchall, x
			lda #$00
			sta e1_shooting, x
			lda #$ff
			sta (temp_16bit_3), y
			rts
:		sec
		sbc #$02
		sta (temp_16bit_4), y
	rts
trent_bullet:
	txa
	bne :+
		lda #$50
		sta e1_shot1+1
		lda #$03
		sta e1_shot1+2
		rts
:	cmp #$01
	bne :+
		lda #$50
		sta e2_shot1+1
		lda #$03
		sta e2_shot1+2
		rts
:	cmp #$02
	bne :+
		lda #$50
		sta e3_shot1+1
		lda #$03
		sta e3_shot1+2
		rts
:	lda #$50
	sta e4_shot1+1
	lda #$03
	sta e4_shot1+2
	rts





move_bat_h:
	lda e1_dir, x
	beq @other_dir
@this_dir:
		ldy #$00
		lda (temp_16bit_2), y
		clc
		adc #$01
		sta (temp_16bit_2), y
		lda e1_move_count, x
		cmp #$10
		bne :++
			jsr e_inc_x
			lda #$00
			sta e1_move_count, x
			lda e_pos, x
			clc
			adc #$01
			tay
			lda bg_ram, y
			beq :+
				dec e1_dir, x
				jmp @back_and_forth
:
:		inc e1_move_count, x
		jmp @back_and_forth
@other_dir:
		ldy #$00
		lda (temp_16bit_2), y
		sec
		sbc #$01
		sta (temp_16bit_2), y
		lda e1_move_count, x
		cmp #$10
		bne :++
			jsr e_dec_x
			lda #$00
			sta e1_move_count, x
			lda e_pos, x
			sec
			sbc #$01
			tay
			lda bg_ram, y
			beq :+
				inc e1_dir, x
				jmp @back_and_forth
:
:		inc e1_move_count, x
@back_and_forth:
	lda e1_offset_gen, x
	tay
	lda bat_h_bakforf, y
	sta temp_8bit_3
	bne :+
;		lda #$00
		sta e1_offset_gen, x
		rts
:	ldy #$00
	lda (temp_16bit_1), y
	clc
	adc temp_8bit_3
	sta (temp_16bit_1), y
	inc e1_offset_gen, x
	rts
bat_h_bakforf:
	.byte $01,$01,$02,$01,$01,$ff,$ff,$fe,$ff,$ff,$00


move_bat_v:
	lda e1_dir, x
	beq @other_dir
@this_dir:
		ldy #$00
		lda (temp_16bit_1), y
		clc
		adc #$01
		sta (temp_16bit_1), y
		lda e1_move_count, x
		cmp #$10
		bne :++
			jsr e_inc_y
			lda #$00
			sta e1_move_count, x
			lda e_pos, x
			clc
			adc #$10
			tay
			lda bg_ram, y
			beq :+
				dec e1_dir, x
				jmp @back_and_forth
:
:		inc e1_move_count, x
		jmp @back_and_forth
@other_dir:
		ldy #$00
		lda (temp_16bit_1), y
		sec
		sbc #$01
		sta (temp_16bit_1), y
		lda e1_move_count, x
		cmp #$10
		bne :++
			jsr e_dec_y
			lda #$00
			sta e1_move_count, x
			lda e_pos, x
			sec
			sbc #$10
			tay
			lda bg_ram, y
			beq :+
				inc e1_dir, x
				jmp @back_and_forth
:
:		inc e1_move_count, x
@back_and_forth:
	lda e1_offset_gen, x
	tay
	lda bat_v_bakforf, y
	sta temp_8bit_3
	bne :+
;		lda #$00
		sta e1_offset_gen, x
		rts
:	ldy #$00
	lda (temp_16bit_2), y
	clc
	adc temp_8bit_3
	sta (temp_16bit_2), y
	inc e1_offset_gen, x
	rts
bat_v_bakforf:
	.byte $01,$01,$02,$01,$01,$ff,$ff,$fe,$ff,$ff,$00


move_bones:
	lda e1_dir, x
	beq @other_dir
@this_dir:
	lda e1_move_count, x
	bne @keep_right
		lda e_pos, x
		and #$0f
		cmp #$0e
		bne :+
			jmp :+++
:
		lda e_pos, x
		clc
		adc #$11
		tay
		lda bg_ram, y
		bne :+
			jmp :++
:		lda e_pos, x
		clc
		adc #$01
		tay
		lda bg_ram, y
		cmp #$03
		bne @keep_right
:			dec e1_dir, x
			lda #$00
			sta e1_move_count, x
			lda #$05
			sta e1_anim_state, x
			rts
@keep_right:
		ldy #$00
		lda e1_speed_lo, x
		clc
		adc #<bones_speed
		sta e1_speed_lo, x
		lda (temp_16bit_2), y;e1_speed_hi, x
		adc #>bones_speed
		sta (temp_16bit_2), y;e1_speed_hi, x
		lda e1_move_count, x
		cmp #$20
		bne :+
			jsr e_inc_x
			lda #$00
			sta e1_move_count, x
			rts
:		inc e1_move_count, x
		rts
@other_dir:
	lda e1_move_count, x
	bne @keep_left
		lda e_pos, x
		and #$0f
		cmp #$01
		bne :+
			jmp :+++
:
		lda e_pos, x
		clc
		adc #$0f
		tay
		lda bg_ram, y
		bne :+
			jmp :++
:		lda e_pos, x
		sec
		sbc #$01
		tay
		lda bg_ram, y
		cmp #$03
		bne @keep_left
:			inc e1_dir, x
			lda #$00
			sta e1_move_count, x
			lda #$05
			sta e1_anim_state, x
			rts
@keep_left:
		ldy #$00
		lda e1_speed_lo, x
		sec
		sbc #<bones_speed
		sta e1_speed_lo, x
		lda (temp_16bit_2), y;e1_speed_hi, x
		sbc #>bones_speed
		sta (temp_16bit_2), y;e1_speed_hi, x
		lda e1_move_count, x
		cmp #$20
		bne :+
			jsr e_dec_x
			lda #$00
			sta e1_move_count, x
			rts
:		inc e1_move_count, x
		rts


move_spider:
	lda e1_dir, x
	beq @other_dir
@this_dir:
	lda e1_move_count, x
	bne @keep_right
		lda e_pos, x
		and #$0f
		cmp #$0e
		bne :+
			jmp :+++
:
		lda e_pos, x
		clc
		adc #$11
		tay
		lda bg_ram, y
		bne :+
			jmp :++
:		lda e_pos, x
		clc
		adc #$01
		tay
		lda bg_ram, y
		cmp #$03
		bne @keep_right
:			dec e1_dir, x
			lda #$00
			sta e1_move_count, x
			lda #$06
			sta e1_anim_state, x
			rts
@keep_right:
		ldy #$00
		lda (temp_16bit_2), y
		clc
		adc #$01
		sta (temp_16bit_2), y
		lda e1_move_count, x
		cmp #$10
		bne :+
			jsr e_inc_x
			lda #$00
			sta e1_move_count, x
			rts
:		inc e1_move_count, x
		rts
@other_dir:
	lda e1_move_count, x
	bne @keep_left
		lda e_pos, x
		and #$0f
		cmp #$01
		bne :+
			jmp :+++
:
		lda e_pos, x
		clc
		adc #$0f
		tay
		lda bg_ram, y
		bne :+
			jmp :++
:		lda e_pos, x
		sec
		sbc #$01
		tay
		lda bg_ram, y
		cmp #$03
		bne @keep_left
:			inc e1_dir, x
			lda #$00
			sta e1_move_count, x
			lda #$06
			sta e1_anim_state, x
			rts
@keep_left:
		ldy #$00
		lda (temp_16bit_2), y
		sec
		sbc #$01
		sta (temp_16bit_2), y
		lda e1_move_count, x
		cmp #$10
		bne :+
			jsr e_dec_x
			lda #$00
			sta e1_move_count, x
			rts
:		inc e1_move_count, x
		rts
;hop_right_y:
;	.byte $ff,$ff,$fe,$fe,$fe,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00
;	.byte $01,$00,$01,$00,$01,$00,$01,$00,$01,$00,$01,$00,$02,$02,$02,$01,$06
;hop_right_x:
;	.byte $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
;	.byte $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
;hop_left_x:
;	.byte $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
;	.byte $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff



move_gargoyle:
	lda map_pos
	cmp #$41
	beq :+
		cmp #$51
		beq :+
			cmp #$61
			beq :+
				cmp #$62
				bne :++
:					jmp @back_and_forth
:	lda e1_dir, x
	beq @other_dir
@this_dir:
		ldy #$00
		lda (temp_16bit_2), y
		clc
		adc #$02
		sta (temp_16bit_2), y
		lda e1_move_count, x
		cmp #$08
		bne :++
			jsr e_inc_x
			lda #$00
			sta e1_move_count, x
			lda e_pos, x
			clc
			adc #$01
			tay
			lda bg_ram, y
			beq :+
				dec e1_dir, x
				jmp @back_and_forth
:
:		inc e1_move_count, x
		jmp @back_and_forth
@other_dir:
		ldy #$00
		lda (temp_16bit_2), y
		sec
		sbc #$02
		sta (temp_16bit_2), y
		lda e1_move_count, x
		cmp #$08
		bne :+
			jsr e_dec_x
			lda #$00
			sta e1_move_count, x
			lda e_pos, x
			sec
			sbc #$01
			tay
			lda bg_ram, y
			beq :+
				inc e1_dir, x
				jmp @back_and_forth
:		inc e1_move_count, x

@back_and_forth:
	lda e1_shooting, x
	beq :++
		ldy #$00
		lda (temp_16bit_3), y
		cmp #$b8
		beq :+
			clc
			adc #$01
			sta (temp_16bit_3), y
			rts
:		lda #$3c
		sta e1_catchall, x
		lda #$00
		sta e1_shooting, x
		jsr disappear_skull
		rts
:	lda e1_catchall, x
	beq :+
		sec
		sbc #$01
		sta e1_catchall, x
		rts
:	lda #$01
	sta e1_shooting, x
	jsr gargoyle_bullet
	ldy #$00
	lda (temp_16bit_1), y
	clc
	adc #$05
	sta (temp_16bit_3), y
	lda (temp_16bit_2), y
	clc
	adc #$05
	sta (temp_16bit_4), y
	rts
gargoyle_bullet:
	txa
	bne :+
		lda #$5d
		sta e1_shot1+1
		lda #$01
		sta e1_shot1+2
		rts
:	cmp #$01
	bne :+
		lda #$5d
		sta e2_shot1+1
		lda #$01
		sta e2_shot1+2
		rts
:	cmp #$02
	bne :+
		lda #$5d
		sta e3_shot1+1
		lda #$01
		sta e3_shot1+2
		rts
:	lda #$5d
	sta e4_shot1+1
	lda #$01
	sta e4_shot1+2
	rts
disappear_skull:
	txa
	bne :+
		lda #$ff
		sta e1_shot1
		sta e1_shot1+3
;		lda #$00
;		sta e1_shot1+1
;		lda #$01
;		sta e1_shot1+2
		rts
:	cmp #$01
	bne :+
		lda #$ff
		sta e2_shot1
		sta e2_shot1+3
;		lda #$00
;		sta e2_shot1+1
;		lda #$01
;		sta e2_shot1+2
		rts
:	cmp #$02
	bne :+
		lda #$ff
		sta e3_shot1
		sta e3_shot1+3
;		lda #$00
;		sta e3_shot1+1
;		lda #$01
;		sta e3_shot1+2
		rts
:	lda #$ff
	sta e4_shot1
	sta e4_shot1+3
;	lda #$00
;	sta e4_shot1+1
;	lda #$01
;	sta e4_shot1+2
	rts


move_golem:
	lda p_left
	cmp e1_left, x
	bcc :+
		lda #$01
		sta e1_dir, x
		jmp :++
:	lda #$00
	sta e1_dir, x
:	lda e1_catchall, x
	beq :+
		sec
		sbc #$01
		sta e1_catchall, x
		rts
:	ldy e1_offset_gen, x
	lda golem_y, y
	sta e1_speed_lo, x
	cmp #$fe
	beq @do_shot
		ldy #$00
		lda (temp_16bit_1), y
		clc
		adc e1_speed_lo, x
		sta (temp_16bit_1), y
		inc e1_offset_gen, x
		rts
@do_shot:
	lda e1_shooting, x
	bne :+
		txa
		pha
		lda #$07
		jsr music_loadsfx
		pla
		tax
		lda #<loop_shake
		sta loop_pointer+0
		lda #>loop_shake
		sta loop_pointer+1
		jsr golem_attacker
:	ldy #$00
	lda (temp_16bit_3), y
	cmp #$b9
	beq :+
		clc
		adc #$02
		sta (temp_16bit_3), y
		rts
:	lda #$00
	sta (temp_16bit_3), y
	sta e1_offset_gen, x
	sta e1_shooting, x
	lda #$01;#$78
	sta e1_catchall, x
	jsr disappear_skull
	rts
golem_y:
	.byte $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	.byte $01,$02,$02,$02,$04,$04,$fe
golem_attacker:
	lda #$01
	sta e1_shooting, x
	txa
	bne :+
		lda #$5c
		sta e1_shot1+1
		lda #$01
		sta e1_shot1+2
		lda p_top_left+3
		sta e1_shot1+3
		rts
:	cmp #$01
	bne :+
		lda #$5c
		sta e2_shot1+1
		lda #$01
		sta e2_shot1+2
		lda p_top_left+3
		sta e2_shot1+3
		rts
:	cmp #$02
	bne :+
		lda #$5c
		sta e3_shot1+1
		lda #$01
		sta e3_shot1+2
		lda p_top_left+3
		sta e3_shot1+3
		rts
:	lda #$5c
	sta e4_shot1+1
	lda #$01
	sta e4_shot1+2
	lda p_top_left+3
	sta e4_shot1+3
	rts


move_raven:
	lda p_left
	cmp e1_left, x
	bcc :+
		lda #$01
		sta e1_dir, x
		jmp :++
:	lda #$00
	sta e1_dir, x
:
	lda e1_catchall, x
	beq :+
		dec e1_catchall, x
		rts
:	lda e1_offset_gen, x
	beq @move_down
		cmp #$01
		beq @dart_left
			cmp #$02
			beq @dart_right
				cmp #$03
				beq @move_up
@move_down:
	lda e1_top, x
	cmp p_top
	bcs :+
		ldy #$00
		sty e1_offset_gen, x
		lda (temp_16bit_1), y
		clc
		adc #$01
		sta (temp_16bit_1), y
		rts
:	lda e1_left, x
	cmp p_left
	bcs :+
		lda #$02
		sta e1_offset_gen, x
		rts
:	lda #$01
	sta e1_offset_gen, x
	rts
@dart_left:
	lda e1_left, x
	cmp p_left
	bcc :+
		ldy #$00
		lda (temp_16bit_2), y
		sec
		sbc #$02
		sta (temp_16bit_2), y
		rts
:	lda #$03
	sta e1_offset_gen, x
	rts
@dart_right:
	lda e1_left, x
	cmp p_left
	bcs :-
		ldy #$00
		lda (temp_16bit_2), y
		clc
		adc #$02
		sta (temp_16bit_2), y
		rts
@move_up:
	lda e1_top, x
	cmp #$10
	bcc :+
		ldy #$00
		lda (temp_16bit_1), y
		sec
		sbc #$03
		sta (temp_16bit_1), y
		rts
:	lda #$3c
	sta e1_catchall, x
	lda #$00
	sta e1_offset_gen, x
	rts


move_goblin:
	lda e1_move_count, x
	cmp #$10
	beq :+
		jmp @moving_count
:		lda e_pos, x
		and #$0f
		cmp #$00
		bne :+
			lda #$01
			sta e1_speed_lo, x
			sta e1_dir, x
			lda #$00
			sta e1_move_count, x
			lda #$0b
			sta e1_anim_state, x
			jmp @right_tests
:		cmp #$0f
		bne :+
			lda #$00
			sta e1_speed_lo, x
			sta e1_dir, x
			sta e1_move_count, x
			lda #$0b
			sta e1_anim_state, x
			jmp @left_tests
			rts
:		lda e_pos, x
		and #$f0
		cmp #$b0
		bne :+
			lda #$07
			sta e1_anim_state, x
			sta e_types, x
			rts
:
		lda #$00
		sta e1_move_count, x
		lda e1_speed_lo, x
		cmp #$02
		beq :+
		lda e_pos, x
		clc
		adc #$10
		tay
		lda bg_ram, y
		cmp #$03
		beq	:+
			lda #$03					; go downwards
			sta e1_speed_lo, x
			lda #$0b
			sta e1_anim_state, x
			rts				
:		lda e1_dir, x
		beq @left_tests
@right_tests:
		lda e_pos, x				; test immediate right
		clc
		adc #$01
		tay
		lda bg_ram, y
		cmp #$03
		beq :+
			lda #$01				; go right
			sta e1_speed_lo, x
			lda #$0b
			sta e1_anim_state, x
			jmp @moving_right
:		lda e_pos, x				; test up and to the right
		sec
		sbc #$0f
		tay
		lda bg_ram, y
		cmp #$03
		beq @up_right_not_open
			lda e_pos, x
			sec
			sbc #$10
			tay
			lda bg_ram, y
			cmp #$03
			beq @up_right_not_open
				lda #$02			; go up
				sta e1_speed_lo, x
			lda #$0b
			sta e1_anim_state, x
				rts
@up_right_not_open:
	lda #$00
	sta e1_dir, x
@left_tests:
		lda e_pos, x				; test immediate left
		sec
		sbc #$01
		tay
		lda bg_ram, y
		cmp #$03
		beq :+
			lda #$00				; go left
			sta e1_speed_lo, x
			lda #$0b
			sta e1_anim_state, x
			jmp @moving_left
:		lda e_pos, x				; test up and to the left
		sec
		sbc #$11
		tay
		lda bg_ram, y
		cmp #$03
		beq @up_left_not_open
			lda e_pos, x
			sec
			sbc #$10
			tay
			lda bg_ram, y
			cmp #$03
			beq @up_left_not_open
				lda #$02			; go up
				sta e1_speed_lo, x
			lda #$0b
			sta e1_anim_state, x
				rts
@up_left_not_open:
	lda #$01
	sta e1_dir, x
			lda #$0b
			sta e1_anim_state, x
	jmp @right_tests

@moving_count:
	lda e1_speed_lo, x
	beq @moving_left
		cmp #$01
		beq @moving_right
			cmp #$02
			beq @moving_up
				jmp @moving_down
@moving_up:
	ldy #$00
	lda (temp_16bit_1), y
	sec
	sbc #$01
	sta (temp_16bit_1), y
	inc e1_move_count, x
	lda e1_move_count, x
	cmp #$10
	bne :+
		jsr e_dec_y
:	rts
@moving_left:
	ldy #$00
	lda (temp_16bit_2), y
	sec
	sbc #$01
	sta (temp_16bit_2), y
	inc e1_move_count, x
	lda e1_move_count, x
	cmp #$10
	bne :+
		jsr e_dec_x
:	rts
@moving_right:
	ldy #$00
	lda (temp_16bit_2), y
	clc
	adc #$01
	sta (temp_16bit_2), y
	inc e1_move_count, x
	lda e1_move_count, x
	cmp #$10
	bne :+
		jsr e_inc_x
:	rts
@moving_down:
	ldy #$00
	lda (temp_16bit_1), y
	clc
	adc #$01
	sta (temp_16bit_1), y
	inc e1_move_count, x
	lda e1_move_count, x
	cmp #$10
	bne :+
		jsr e_inc_y
:	rts




















move_lizard:
	lda e1_move_count, x
	cmp #$10
	beq :+
		lda #$00
		sta e1_catchall, x
		jmp @moving_count
:
	lda e1_catchall, x
	beq :+
		jmp @lizard_shot
:	lda p_pos
	and #$f0
	clc
	adc #$10
	sta e1_speed_lo2, x
	lda e_pos, x
	and #$f0
	cmp e1_speed_lo2, x
	bne @test_same
		lda e1_left, x
		cmp p_left
		bcc :+
			lda #$01
			sta e1_catchall, x
			rts
:		lda #$02
		sta e1_catchall, x
		rts
@test_same:
	lda p_pos
	and #$f0
	sta e1_speed_lo2, x
	lda e_pos, x
	and #$f0
	cmp e1_speed_lo2, x
	bne @failed
		lda e1_left, x
		cmp p_left
		bcs :+
			lda #$04
			sta e1_catchall, x
			rts
:		lda #$03
		sta e1_catchall, x
		rts
@failed:
	lda #$00
	sta e1_move_count, x
	lda e1_dir, x
	beq @left_tests
		jmp @right_tests
@left_tests:
	lda e_pos, x
	and #$0f
;	cmp #$01
	bne :+
		jmp @change_to_right
:	lda e_pos, x
	sec
	sbc #$01
	tay
	lda bg_ram, y
	cmp #$03
	bne :+
		jmp @change_to_right
:	lda e_pos, x
	clc
	adc #$0f
	tay
	lda bg_ram, y
	beq @change_to_right
		jmp @moving_left
@change_to_right:
	lda #$01
	sta e1_dir, x
	sta e1_speed_lo, x
	rts
@right_tests:
	lda e_pos, x
	and #$0f
	cmp #$0f
	bne :+
		jmp @change_to_left
:	lda e_pos, x
	clc
	adc #$01
	tay
	lda bg_ram, y
	cmp #$03
	bne :+
		jmp @change_to_left
:	lda e_pos, x
	clc
	adc #$11
	tay
	lda bg_ram, y
	beq @change_to_left
		jmp @moving_right
@change_to_left:
	lda #$00
	sta e1_dir, x
	sta e1_speed_lo, x
	rts
@moving_count:
	lda e1_speed_lo, x
	beq @moving_left
		cmp #$01
		beq @moving_right

@moving_left:
	ldy #$00
	lda (temp_16bit_2), y
	sec
	sbc #$01
	sta (temp_16bit_2), y
	inc e1_move_count, x
	lda e1_move_count, x
	cmp #$10
	bne :+
		jsr e_dec_x
:	rts
@moving_right:
	ldy #$00
	lda (temp_16bit_2), y
	clc
	adc #$01
	sta (temp_16bit_2), y
	inc e1_move_count, x
	lda e1_move_count, x
	cmp #$10
	bne :+
		jsr e_inc_x
:	rts


@lizard_shot:
	lda e1_catchall, x
	cmp #$01
	beq @jumping_left
		cmp #$02
		beq @jumping_right
			cmp #$03
			bne :+
				jmp @standing_left
:			cmp #$04
			bne :+
				jmp @standing_right
:			cmp #$05
			beq @shooting_left
@shooting_right:
	ldy #$00
	lda (temp_16bit_4), y
	cmp #$03
	bcc :+
		clc
		adc #$02
		sta (temp_16bit_4), y
		rts
:	lda #$00
	sta e1_catchall, x
	sta e1_offset_gen, x
	jsr disappear_skull
	rts
@shooting_left:
	ldy #$00
	lda (temp_16bit_4), y
	cmp #$03
	bcc :-
		sec
		sbc #$02
		sta (temp_16bit_4), y
		rts
;:	lda #$00
;	sta e1_catchall, x
;	sta e1_offset_gen, x
;	jsr disappear_skull
	rts


@jumping_left:
	lda e1_offset_gen, x
	tay
	cmp #$0f
	bne :+
		jsr lizard_attacker
:	lda golem_y, y
	cmp #$fe
	bne :+
		lda #$05
		sta e1_catchall, x
		rts
:	sta e1_liz_off, x
	ldy #$00
	lda (temp_16bit_1), y
	clc
	adc e1_liz_off, x
	sta (temp_16bit_1), y
	inc e1_offset_gen, x
	rts
@jumping_right:
	lda e1_offset_gen, x
	tay
	cmp #$0f
	bne :+
		jsr lizard_attacker
:
	lda golem_y, y
	cmp #$fe
	bne :+
		lda #$06
		sta e1_catchall, x
		rts
:	sta e1_liz_off, x
	ldy #$00
	lda (temp_16bit_1), y
	clc
	adc e1_liz_off, x
	sta (temp_16bit_1), y
	inc e1_offset_gen, x
	rts
@standing_left:
	jsr lizard_attacker
	lda #$05
	sta e1_catchall, x
	rts
@standing_right:
	jsr lizard_attacker
	lda #$06
	sta e1_catchall, x
	rts

lizard_bird_shot:
			tya
			pha
			txa
			pha
			lda #$0d
			jsr music_loadsfx
			pla
			tax
			pla
			tay
			rts
lizard_attacker:
	jsr lizard_bird_shot
	lda #$01
	sta e1_shooting, x
	txa
	bne :+
		lda #$9d
		sta e1_shot1+1
		lda #$03
		sta e1_shot1+2
		lda e1_top_left
		sta e1_shot1+0
		lda e1_top_left+3
		sta e1_shot1+3
		rts
:	cmp #$01
	bne :+
		lda #$9d
		sta e2_shot1+1
		lda #$03
		sta e2_shot1+2
		lda e2_top_left
		sta e2_shot1+0
		lda e2_top_left+3
		sta e2_shot1+3
		rts
:	cmp #$02
	bne :+
		lda #$9d
		sta e3_shot1+1
		lda #$03
		sta e3_shot1+2
		lda e3_top_left
		sta e3_shot1+0
		lda e3_top_left+3
		sta e3_shot1+3
		rts
:	lda #$9d
	sta e4_shot1+1
	lda #$03
	sta e4_shot1+2
	lda e4_top_left
	sta e4_shot1+0
	lda e4_top_left+3
	sta e4_shot1+3
	rts







move_bird:
	lda e1_shooting, x
	beq @start
	lda e1_shot1
	cmp #$ff
	beq @shoot
	cmp #$b0
	bcs @no_shot
@shoot:
		lda e1_shot1
		clc
		adc #$05
		sta e1_shot1
		sta e2_shot1
		jmp @start
@no_shot:
	lda #$00
	sta e1_shooting, x
	lda #$ff
	sta e1_shot1
	sta e2_shot1
@start:
	lda e1_offset_gen, x
	bne :++
		lda e1_move_count, x
		cmp #$10
		beq :+
			jmp @move_start
:			jmp :++
:	lda e1_move_count, x
	cmp #$08
	beq :+
		jmp @move_start
:		lda #$00
		sta e1_move_count, x
		lda e1_offset_gen, x
		beq @check_left
			cmp #$01
			beq @check_right
				cmp #$02
				beq @check_up
					cmp #$03
					bne :+
						jmp @check_down
:					cmp #$04
					beq @check_left
						jmp@shot1

@check_left:
	lda e1_offset_gen, x
	cmp #$04
	beq :+
		lda p_left
		cmp e1_right, x
			bcs :+
		lda p_right
		cmp e1_left, x
			bcc :+
				lda #$04
				sta e1_offset_gen, x
;				jmp @move_start
:	lda map_pos
	cmp #93
	bne :+
	lda e1_shooting, x
	bne :+
		lda p_left
		cmp e1_right, x
			bcs :+
		lda p_right
		cmp e1_left, x
			bcc :+
		jsr birdie_attacker
:
	lda e_pos, x
	sec
	sbc #$01
	tay
	lda bg_ram, y
	beq :+
		lda #$02
		sta e1_offset_gen, x
:		jmp @move_start
@check_right:
	lda e1_shooting, x
	bne :+
		lda p_left
		cmp e1_right, x
			bcs :+
		lda p_right
		cmp e1_left, x
			bcc :+
		jsr birdie_attacker
:
	lda e_pos, x
	clc
	adc #$01
	tay
	lda bg_ram, y
	beq :+
		lda #$03
		sta e1_offset_gen, x
:		jmp @move_start
@check_up:
	lda e1_shooting, x
	bne :+
		lda e_pos, x
		cmp #$22
		bne :+
		lda p_pos
		and #$0f
		sta e1_liz_off, x
		lda e_pos, x
		and #$0f
		cmp e1_liz_off, x
		bne :+
		jsr birdie_attacker
:
	lda e_pos, x
	sec
	sbc #$10
	tay
	lda bg_ram, y
	beq :+
		lda #$01
		sta e1_offset_gen, x
:		jmp @move_start
@check_down:
	lda e_pos, x
	clc
	adc #$10
	tay
	lda bg_ram, y
	beq @move_em
		lda map_pos
		cmp #93
		bne :+
			lda #$04
			sta e1_offset_gen, x
			bne @move_em
:		lda #$00
		sta e1_offset_gen, x
@move_em:
		jmp @move_start
@move_start:
	lda e1_offset_gen, x
	beq @move_left
		cmp #$01
		beq @move_right
			cmp #$02
			bne :+
				jmp @move_up
:			cmp #$03
			beq @move_down
				cmp #$04
				beq @fast_left
					jmp @shot1

@fast_left:
	ldy #$00
	lda (temp_16bit_2), y
	sec
	sbc #$02
	sta (temp_16bit_2), y
	inc e1_move_count, x
	lda e1_move_count, x
	cmp #$08
	bne :+
		jsr e_dec_x
:	rts
@move_left:
	ldy #$00
	lda (temp_16bit_2), y
	sec
	sbc #$01
	sta (temp_16bit_2), y
	inc e1_move_count, x
	lda e1_move_count, x
	cmp #$10
	bne :+
		jsr e_dec_x
:	rts
@move_right:
	ldy #$00
	lda (temp_16bit_2), y
	clc
	adc #$02
	sta (temp_16bit_2), y
	inc e1_move_count, x
	lda e1_move_count, x
	cmp #$08
	bne :+
		jsr e_inc_x
:	rts
@move_down:
	ldy #$00
	lda (temp_16bit_1), y
	clc
	adc #$02
	sta (temp_16bit_1), y
	inc e1_move_count, x
	lda e1_move_count, x
	cmp #$08
	bne :+
		jsr e_inc_y
		lda e_pos, x
		cmp #$8e
		bne :+
			lda #$05
			sta e1_offset_gen, x
			lda #$3c
			sta e1_speed_lo, x
:		rts
@move_up:
	ldy #$00
	lda (temp_16bit_1), y
	sec
	sbc #$02
	sta (temp_16bit_1), y
	inc e1_move_count, x
	lda e1_move_count, x
	cmp #$08
	bne :+
		jsr e_dec_y
:	rts
@shot1:
	lda e1_speed_lo, x
	bne @shooting1
		lda #$ff
		sta e3_shot1
		sta e4_shot1
		lda #$00
		sta e1_move_count, x
		lda #$03
		sta e1_offset_gen, x
		rts
@shooting1:
	lda e3_shot1
	cmp #$ff
	bne :+
		jsr birdie_attacker2
:	lda e3_shot1+3
	cmp #$07
	bcs :+
		lda #$fe
		sta e3_shot1
		sta e4_shot1
:	sec
	sbc #$05
	sta e3_shot1+3
	sta e4_shot1+3
	dec e1_speed_lo, x
	lda #$08
	sta e1_move_count, x
	rts
birdie_attacker:
	jsr lizard_bird_shot
	lda #$01
	sta e1_shooting, x
	lda #$a8
	sta e1_shot1+1
	sta e2_shot1+1
	lda #$03
	sta e1_shot1+2
	sta e2_shot1+2
	lda e1_top_left
	sta e1_shot1+0
	lda e1_top_left+3
	sta e1_shot1+3
	lda e1_top_right
	sta e2_shot1+0
	lda e1_top_right+3
	sta e2_shot1+3
	rts
birdie_attacker2:
	jsr lizard_bird_shot
	lda #$a8
	sta e3_shot1+1
	sta e4_shot1+1
	lda #$03
	sta e3_shot1+2
	sta e4_shot1+2
	lda e1_top_left
	sta e3_shot1+0
	lda e1_top_left+3
	sta e3_shot1+3
	lda e1_bot_left
	sta e4_shot1+0
	lda e1_bot_left+3
	sta e4_shot1+3
	rts



move_gargboss:
	lda e1_shooting, x
	bne :+
		lda e1_move_count, x
		cmp #$08
		bne :+
		lda e1_dir, x
		cmp #$02
		bcs :+
		lda p_pos
		and #$0f
		sta e1_liz_off, x
		lda e_pos, x
		and #$0f
		cmp e1_liz_off, x
		bne :+
			lda #$02
			sta e1_dir, x
			lda #$00
			sta e1_move_count, x
			jmp @check_down
:	lda e1_dir, x
	cmp #$02
	bcc :+
		lda e1_move_count, x
		cmp #$04
		bne :++
			lda #$00
			sta e1_move_count, x
			jmp :++
:	lda e1_move_count, x
	cmp #$08
	bne	:+
		lda #$00
		sta e1_move_count, x
:	lda e1_dir, x
	beq @check_left
		cmp #$01
		beq @check_right
			cmp #$02
			beq @check_down
				cmp #$03
				beq @stay_still
					cmp #$04
					beq @move_up
@check_left:
	lda e_pos, x
	sec
	sbc #$01
	tay
	lda bg_ram, y
	beq :+
		lda #$01
		sta e1_dir, x
:		jmp @move_start
@check_right:
	lda e_pos, x
	clc
	adc #$01
	tay
	lda bg_ram, y
	beq :+
		lda #$00
		sta e1_dir, x
:		jmp @move_start
@check_down:
	lda e_pos, x
	clc
	adc #$10
	tay
	lda bg_ram, y
	beq :+
		lda #$03
		sta e1_dir, x
		lda #$3c
		sta e1_liz_off, x
		txa
		pha
		lda #$07
		jsr music_loadsfx
		pla
		tax
		lda #<loop_shake
		sta loop_pointer+0
		lda #>loop_shake
		sta loop_pointer+1
		rts
:		jmp @move_start
@stay_still:
	lda e1_liz_off, x
	bne :+
		lda #$04
		sta e1_dir, x
:	dec e1_liz_off, x
	rts
@move_up:
	lda e_pos, x
	and #$f0
	cmp #$50
	bne :+
		lda #$01
		sta e1_dir, x
		lda #$00
		sta e1_move_count, x
		rts
:	ldy #$00
	lda (temp_16bit_1), y
	sec
	sbc #$04
	sta (temp_16bit_1), y
	inc e1_move_count, x
	lda e1_move_count, x
	cmp #$04
	bne :+
		jsr e_dec_y
:	rts
	


@move_start:
	lda e1_dir, x
	beq @move_left
		cmp #$01
		beq @move_right
			cmp #$02
			beq @move_down
				cmp #$03
				beq @still
					cmp #$04
					beq @moving_up
@move_left:
	ldy #$00
	lda (temp_16bit_2), y
	sec
	sbc #$02
	sta (temp_16bit_2), y
	inc e1_move_count, x
	lda e1_move_count, x
	cmp #$08
	bne :+
		jsr e_dec_x
:	jmp @back_and_forth
@move_right:
	ldy #$00
	lda (temp_16bit_2), y
	clc
	adc #$02
	sta (temp_16bit_2), y
	inc e1_move_count, x
	lda e1_move_count, x
	cmp #$08
	bne :+
		jsr e_inc_x
:	jmp @back_and_forth
@move_down:
	ldy #$00
	lda (temp_16bit_1), y
	clc
	adc #$04
	sta (temp_16bit_1), y
	inc e1_move_count, x
	lda e1_move_count, x
	cmp #$04
	bne :+
		jsr e_inc_y
:	rts
@still:
@moving_up:
	rts
@back_and_forth:
	lda e1_shooting, x
	beq :++
		ldy #$00
		lda (temp_16bit_3), y
		cmp #$b8
		beq :+
			clc
			adc #$01
			sta (temp_16bit_3), y
			rts
:		lda #$3c
		sta e1_catchall, x
		lda #$00
		sta e1_shooting, x
		jsr disappear_skull
		rts
:	lda e1_catchall, x
	beq :+
		sec
		sbc #$01
		sta e1_catchall, x
		rts
:	lda #$01
	sta e1_shooting, x
	jsr gargoyle_bullet
	lda (temp_16bit_1), y
	clc
	adc #$05
	sta (temp_16bit_3), y
	lda (temp_16bit_2), y
	clc
	adc #$05
	sta (temp_16bit_4), y
	rts
















move_lastboss:
	lda p_shot1+1	;selector+3
	cmp #$29		;#$44
	bne :+
		lda #$01
		sta e1_catchall, x
		jmp :++
:	lda #$00
	sta e1_catchall, x
:
	lda e_types+1
	bne :+
			lda #$10
			sta e1_liz_off, x
			txa
			pha
			lda #$08
			jsr music_loadsfx
			pla
			tax
			lda #<loop_summon
			sta loop_pointer+0
			lda #>loop_summon
			sta loop_pointer+1
			jmp loop_summon
:	lda e_types+2
	bne :+
			lda #$10
			sta e1_liz_off, x
			txa
			pha
			lda #$08
			jsr music_loadsfx
			pla
			tax
			lda #<loop_summon2
			sta loop_pointer+0
			lda #>loop_summon2
			sta loop_pointer+1
			jmp loop_summon
:
	lda e1_speed_lo, x				; test if he needs to move
	beq @not_moving
		lda e1_dir, x
		bne @move_up
			ldy #$00
			lda (temp_16bit_1), y
			cmp #$5f
			bne :+
				lda #$00
				sta e1_speed_lo, x
				lda #$01
				sta e1_dir, x
				jmp @not_moving
:			lda e1_speed_lo2, x
			clc
			adc #<bones_speed
			sta e1_speed_lo2, x
			lda (temp_16bit_1), y
			adc #>bones_speed
			sta (temp_16bit_1), y
			jmp @not_moving
@move_up:
			ldy #$00
			lda (temp_16bit_1), y
			cmp #$1f
			bne :+
				lda #$00
				sta e1_speed_lo, x
				sta e1_dir, x
				jmp @not_moving
:			lda e1_speed_lo2, x
			sec
			sbc #<bones_speed
			sta e1_speed_lo2, x
			lda (temp_16bit_1), y
			sbc #>bones_speed
			sta (temp_16bit_1), y
			jmp @not_moving
@not_moving:
	lda e1_shooting, x
	cmp #$01
	beq :++
	cmp #$02
	beq :+
		dec e1_shooting, x
		jmp @not_shooting
:	cmp #$02
	bne :+
		txa
		pha
		lda #$0d
		jsr music_loadsfx
		pla
		tax
		jsr load_boss_shot
		lda #$0f
		sta e1_anim_state, x
		dec e1_shooting, x
		jmp @not_shooting
:	lda e1_shot1
	cmp #$ff
	bne :+
		jmp @shot2
:	lda e1_shot1+3
	bne :+
		lda #$ff
		sta e1_shot1
		jmp @shot2
:	sec
	sbc #$02
	sta e1_shot1+3
@shot2:
	lda e4_shot1
	cmp #$ff
	bne :+
		jmp @shot3
:	cmp #$b8
	bne :+
		lda #$ff
		sta e4_shot1
		jmp @shot3
:	clc
	adc #$01
	sta e4_shot1
	lda e4_shot1+3
	sec
	sbc #$01
	sta e4_shot1+3
@shot3:
	lda extra_shot1+0
	cmp #$ff
	bne :+
		jmp @shot4
:	cmp #$b8
	bne :+
		lda #$ff
		sta extra_shot1
		jmp @shot4
:	clc
	adc #$01
	sta extra_shot1+0
	lda extra_shot1+3
	clc
	adc #$01
	sta extra_shot1+3
@shot4:
	lda extra_shot2+3
	cmp #$ff
	bne :+
		jmp @boxes
:	lda extra_shot2+3
	bne :+
		lda #$ff
		sta extra_shot2
		jmp @boxes
:	clc
	adc #$02
	sta extra_shot2+3
@boxes:

	lda e1_shot1
	cmp #$ff
	bne :+
		lda e4_shot1
		cmp #$ff
		bne :+
			lda extra_shot1
			cmp #$ff
			bne :+
				lda extra_shot2
				cmp #$ff
				bne :+
					dec e1_shooting, x
:
@not_shooting:

	rts
load_boss_shot:
	lda #$21
	sta e1_shot1+1
	sta e4_shot1+1
	sta extra_shot1+1
	sta extra_shot2+1
	lda #$01
	sta e1_shot1+2
	sta e4_shot1+2
	sta extra_shot1+2
	sta extra_shot2+2

	lda e1_top_left+0
	sta e1_shot1+0
	lda e1_top_left+3
	sta e1_shot1+3

	lda e1_bot_left+0
	sta e4_shot1+0
	lda e1_bot_left+3
	sta e4_shot1+3

	lda e1_bot_right+0
	sta extra_shot1+0
	lda e1_bot_right+3
	clc
	adc #$08
	sta extra_shot1+3

	lda e1_top_right+0
	sta extra_shot2+0
	lda e1_top_right+3
	clc
	adc #$08
	sta extra_shot2+3

	rts



summon_type1:
	.byte $00,$02,$09,$0a,$0c,$08
summon_pos1:
	.byte $00,$3b,$9c,$1e,$5d,$55
summon_hp1:
	.byte $00,$03,$05,$05,$05,$05

summon_type2:
	.byte $00,$08,$09,$01,$0c,$08
summon_pos2:
	.byte $00,$29,$9c,$b8,$35,$1d
summon_hp2:
	.byte $00,$05,$05,$05,$05,$05

figure_summon:
	lda nmi_num
	cmp #$cc	; v bat left
	bcc :+
		lda #$01
		sta e1_offset_gen, x
		jmp @load_em
:	cmp #$99	; golem
	bcc :+
		lda #$02
		sta e1_offset_gen, x
		jmp @load_em
:	cmp #$66	; raven
	bcc :+
		lda #$03
		sta e1_offset_gen, x
		jmp @load_em
:	cmp #$33	; lizard
	bcc :+
		lda #$04
		sta e1_offset_gen, x
		jmp @load_em
:	lda #$05	; gargoyle
	sta e1_offset_gen, x

@load_em:
	lda e1_offset_gen, x
	tay
	lda summon_type1, y
	sta e_types+1
	lda summon_pos1, y
	sta e_pos+1
	lda summon_hp1, y
	sta e1_hp+1
	lda e_pos+1
	and #$f0
	sec
	sbc #$01
	sta e2_top_left
	sta e2_top_right
	clc
	adc #$08
	sta e2_bot_left
	sta e2_bot_right
	lda e_pos+1
	and #$0f
	rol
	rol
	rol
	rol
	and #$f0
	sta e2_top_left+3
	sta e2_bot_left+3
	clc
	adc #$08
	sta e2_top_right+3
	sta e2_bot_right+3

	rts
figure_summon2:
	lda nmi_num
	cmp #$cc	; v bat left
	bcc :+
		lda #$01
		sta e1_offset_gen, x
		jmp @load_em
:	cmp #$99	; golem
	bcc :+
		lda #$02
		sta e1_offset_gen, x
		jmp @load_em
:	cmp #$66	; raven
	bcc :+
		lda #$03
		sta e1_offset_gen, x
		jmp @load_em
:	cmp #$33	; lizard
	bcc :+
		lda #$04
		sta e1_offset_gen, x
		jmp @load_em
:	lda #$05	; gargoyle
	sta e1_offset_gen, x

@load_em:
	lda e1_offset_gen, x
	tay

	lda summon_type2, y
	sta e_types+2
	lda summon_pos2, y
	sta e_pos+2
	lda summon_hp2, y
	sta e1_hp+2
	lda e_pos+2
	and #$f0
	sec
	sbc #$01
	sta e3_top_left
	sta e3_top_right
	clc
	adc #$08
	sta e3_bot_left
	sta e3_bot_right
	lda e_pos+2
	and #$0f
	rol
	rol
	rol
	rol
	and #$f0
	sta e3_top_left+3
	sta e3_bot_left+3
	clc
	adc #$08
	sta e3_top_right+3
	sta e3_bot_right+3
	rts

loop_summon:
	lda #$0f
	sta e1_anim_state, x
	jsr anim_lastboss
	jsr flicker_em
	lda e1_liz_off, x
	bne :+
		lda #$0f
		sta pal_address+0
		sta pal_address+16
		jsr figure_summon
		lda #<loop_gameplay
		sta loop_pointer+0
		lda #>loop_gameplay
		sta loop_pointer+1
		jmp end_loop
:	dec e1_liz_off, x
	lda pal_address+0
	cmp #$0f
	bne :+
		lda #$05
		sta pal_address+0
		sta pal_address+16
		bne :++
:	lda #$0f
	sta pal_address+0
	sta pal_address+16
:	jmp end_loop

loop_summon2:
	lda #$0f
	sta e1_anim_state, x
	jsr anim_lastboss
	jsr flicker_em
	lda e1_liz_off, x
	bne :+
		lda #$0f
		sta pal_address+0
		sta pal_address+16
		jsr figure_summon2
		lda #<loop_gameplay
		sta loop_pointer+0
		lda #>loop_gameplay
		sta loop_pointer+1
		jmp end_loop
:	dec e1_liz_off, x
	lda pal_address+0
	cmp #$0f
	bne :+
		lda #$05
		sta pal_address+0
		sta pal_address+16
		bne :++
:	lda #$0f
	sta pal_address+0
	sta pal_address+16
:	jmp end_loop

