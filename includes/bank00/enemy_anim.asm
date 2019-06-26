e_anim_table:
	.addr anim_e_no-1
	.addr anim_ghost-1, anim_trent-1, anim_bat_h-1, anim_bat_v-1, anim_bones-1
	.addr anim_spider-1, anim_e_death-1, anim_gargoyle-1, anim_golem-1, anim_raven-1
	.addr anim_goblin-1, anim_lizard-1, anim_bird-1, anim_gargboss-1, anim_lastboss-1
e1_anim_start:
	lda e_types+0
	bne :+
		rts
:	asl a
	tay
	lda e_anim_table+1, y
	pha
	lda e_anim_table, y
	pha
	rts
e2_anim_start:
	lda e_types+1
	bne :+
		rts
:	asl a
	tay
	lda e_anim_table+1, y
	pha
	lda e_anim_table, y
	pha
	rts
e3_anim_start:
	lda e_types+2
	bne :+
		rts
:	asl a
	tay
	lda e_anim_table+1, y
	pha
	lda e_anim_table, y
	pha
	rts
e4_anim_start:
	lda e_types+3
	bne :+
		rts
:	asl a
	tay
	lda e_anim_table+1, y
	pha
	lda e_anim_table, y
	pha
	rts
choose_e_load:
	txa
	bne :+
		jsr e1_anim_load
		rts
:	cmp #$01
	bne :+
		jsr e2_anim_load
		rts
:	cmp #$02
	bne :+
		jsr e3_anim_load
		rts
:	jsr e4_anim_load
	rts




anim_ghost:
	lda e1_anim_state, x
	cmp #$81
	beq @skip_init
		lda e1_left, x
		sec
		sbc #$03
		cmp p_left
		bcs :+
			lda #<anim_ghost_right
			sta temp_addy+0
			lda #>anim_ghost_right
			sta temp_addy+1
			jmp :++
:		lda #<anim_ghost_left
		sta temp_addy+0
		lda #>anim_ghost_left
		sta temp_addy+1
		jsr choose_e_load
		lda e1_anim_state, x
		clc
		adc #$80
		sta e1_anim_state, x
@skip_init:
	dec e1_anim_count, x
	beq :+
		rts
:	jsr choose_e_load
	rts
anim_ghost_left:
	.byte $49,$41
	.byte $48,$41
	.byte $4b,$41
	.byte $4a,$41
	.byte $01
	.byte <anim_ghost_left,>anim_ghost_left
	.byte $01
anim_ghost_right:
	.byte $48,$01
	.byte $49,$01
	.byte $4a,$01
	.byte $4b,$01
	.byte $01
	.byte <anim_ghost_right,>anim_ghost_right
	.byte $01

anim_trent:
	lda e1_anim_state, x
	cmp #$82
	beq @skip_init
		lda e1_shooting, x
		beq :+
			lda #$82
			sta e1_anim_state, x
			jmp @skip_init
:		lda e1_left, x
		cmp p_left
		bcs :+
			lda #$01
			sta e1_dir, x
			lda #<anim_trent_right
			sta temp_addy+0
			lda #>anim_trent_right
			sta temp_addy+1
			jmp :++
:		lda #$00
		sta e1_dir, x
		lda #<anim_trent_left
		sta temp_addy+0
		lda #>anim_trent_left
		sta temp_addy+1
		jsr choose_e_load
		lda e1_anim_state, x
		clc
		adc #$80
		sta e1_anim_state, x
@skip_init:
	dec e1_anim_count, x
	beq :+
		rts
:	jsr choose_e_load
	rts
anim_trent_left:
	.byte $41,$43
	.byte $40,$43
	.byte $43,$43
	.byte $42,$43
	.byte $01
	.byte <anim_trent_left,>anim_trent_left
	.byte $02
anim_trent_right:
	.byte $40,$03
	.byte $41,$03
	.byte $42,$03
	.byte $43,$03
	.byte $01
	.byte <anim_trent_right,>anim_trent_right
	.byte $02

anim_bat_h:
	lda e1_anim_state, x
	cmp #$83
	beq @skip_init
		lda #<anim_bat_open
		sta temp_addy+0
		lda #>anim_bat_open
		sta temp_addy+1
		jsr choose_e_load
		lda e1_anim_state, x
		clc
		adc #$80
		sta e1_anim_state, x
@skip_init:
	dec e1_anim_count, x
	beq :+
		rts
:	jsr choose_e_load
	rts
anim_bat_open:
	.byte $44,$02
	.byte $45,$02
	.byte $46,$02
	.byte $47,$02
	.byte $10
	.byte <anim_bat_closed,>anim_bat_closed
	.byte $03
anim_bat_closed:
	.byte $54,$02
	.byte $55,$02
	.byte $56,$02
	.byte $57,$02
	.byte $10
	.byte <anim_bat_open,>anim_bat_open
	.byte $ff
anim_bat_v:
	lda e1_anim_state, x
	cmp #$84
	beq @skip_init
		lda #<anim_batv_open
		sta temp_addy+0
		lda #>anim_batv_open
		sta temp_addy+1
		jsr choose_e_load
		lda e1_anim_state, x
		clc
		adc #$80
		sta e1_anim_state, x
@skip_init:
	dec e1_anim_count, x
	beq :+
		rts
:	jsr choose_e_load
	rts
anim_batv_open:
	.byte $44,$02
	.byte $45,$02
	.byte $46,$02
	.byte $47,$02
	.byte $10
	.byte <anim_batv_closed,>anim_batv_closed
	.byte $04
anim_batv_closed:
	.byte $54,$02
	.byte $55,$02
	.byte $56,$02
	.byte $57,$02
	.byte $10
	.byte <anim_batv_open,>anim_batv_open
	.byte $ff

anim_bones:
	lda e1_anim_state, x
	cmp #$85
	beq @skip_init
		lda e1_move_count, x
		bne @skip_init
		lda e1_dir, x
		beq :+
			lda #<anim_bones_right1
			sta temp_addy+0
			lda #>anim_bones_right1
			sta temp_addy+1
			jmp :++
:		lda #<anim_bones_left1
		sta temp_addy+0
		lda #>anim_bones_left1
		sta temp_addy+1
:		jsr choose_e_load
		lda e1_anim_state, x
		clc
		adc #$80
		sta e1_anim_state, x
@skip_init:
	dec e1_anim_count, x
	beq :+
		rts
:	jsr choose_e_load
	rts
anim_bones_left1:
	.byte $4d,$41
	.byte $4c,$41
	.byte $00,$41
	.byte $4e,$41
	.byte $08
	.byte <anim_bones_left2,>anim_bones_left2
	.byte $05
anim_bones_left2:
	.byte $4d,$41
	.byte $4c,$41
	.byte $00,$41
	.byte $4f,$41
	.byte $08
	.byte <anim_bones_left3,>anim_bones_left3
	.byte $ff
anim_bones_left3:
	.byte $4d,$41
	.byte $4c,$41
	.byte $5f,$41
	.byte $5e,$41
	.byte $08
	.byte <anim_bones_left4,>anim_bones_left4
	.byte $ff
anim_bones_left4:
	.byte $4d,$41
	.byte $4c,$41
	.byte $00,$41
	.byte $4f,$41
	.byte $08
	.byte <anim_bones_left1,>anim_bones_left1
	.byte $ff

anim_bones_right1:
	.byte $4c,$01
	.byte $4d,$01
	.byte $4e,$01
	.byte $00,$01
	.byte $08
	.byte <anim_bones_right2,>anim_bones_right2
	.byte $05
anim_bones_right2:
	.byte $4c,$01
	.byte $4d,$01
	.byte $4f,$01
	.byte $00,$01
	.byte $08
	.byte <anim_bones_right3,>anim_bones_right3
	.byte $ff
anim_bones_right3:
	.byte $4c,$01
	.byte $4d,$01
	.byte $5e,$01
	.byte $5f,$01
	.byte $08
	.byte <anim_bones_right4,>anim_bones_right4
	.byte $ff
anim_bones_right4:
	.byte $4c,$01
	.byte $4d,$01
	.byte $4f,$01
	.byte $00,$01
	.byte $08
	.byte <anim_bones_right1,>anim_bones_right1
	.byte $ff


anim_spider:
	lda e1_anim_state, x
	cmp #$86
	beq @skip_init
		lda e1_dir, x
		bne :+
			lda #<anim_spider1
			sta temp_addy+0
			lda #>anim_spider1
			sta temp_addy+1
			jmp :++
:		lda #<anim_spider3
		sta temp_addy+0
		lda #>anim_spider3
		sta temp_addy+1
:		jsr choose_e_load
		lda e1_anim_state, x
		clc
		adc #$80
		sta e1_anim_state, x
@skip_init:
	dec e1_anim_count, x
	beq :+
		rts
:	jsr choose_e_load
	rts
anim_spider1:
	.byte $58,$03
	.byte $59,$03
	.byte $5a,$03
	.byte $5b,$03
	.byte $08
	.byte <anim_spider2,>anim_spider2
	.byte $06
anim_spider2:
	.byte $8c,$03
	.byte $00,$03
	.byte $8d,$03
	.byte $8e,$03
	.byte $08
	.byte <anim_spider1,>anim_spider1
	.byte $ff
anim_spider3:
	.byte $59,$43
	.byte $58,$43
	.byte $5b,$43
	.byte $5a,$43
	.byte $08
	.byte <anim_spider4,>anim_spider4
	.byte $06
anim_spider4:
	.byte $00,$43
	.byte $8c,$43
	.byte $8e,$43
	.byte $8d,$43
	.byte $08
	.byte <anim_spider3,>anim_spider3
	.byte $ff



anim_e_death:
	lda e1_anim_state, x
	beq :+
	cmp #$87
	beq @skip_init
		lda #<e_death1
		sta temp_addy+0
		lda #>e_death1
		sta temp_addy+1
		jsr choose_e_load
		lda e1_anim_state, x
		clc
		adc #$80
		sta e1_anim_state, x
		jmp @skip_init
:		lda #<e_death4
		sta temp_addy+0
		lda #>e_death4
		sta temp_addy+1
		jsr choose_e_load
@skip_init:
	lda e1_anim_state, x
	bne :+
	jsr choose_who_died
	rts
:	dec e1_anim_count, x
	beq :+
		rts
	

:
	jsr choose_e_load
	rts
e_death1:
	.byte $51,$01
	.byte $51,$41
	.byte $51,$81
	.byte $51,$c1
	.byte $04
	.byte <e_death2, >e_death2
	.byte $07
e_death2:
	.byte $51,$01
	.byte $52,$41
	.byte $52,$81
	.byte $52,$c1
	.byte $04
	.byte <e_death3, >e_death3
	.byte $ff
e_death3:
	.byte $53,$01
	.byte $53,$41
	.byte $53,$81
	.byte $53,$c1
	.byte $04
	.byte <e_death4, >e_death4
	.byte $ff
e_death4:
	.byte $00,$00
	.byte $00,$00
	.byte $00,$00
	.byte $00,$00
	.byte $08
	.byte <anim_e_no,>anim_e_no
	.byte $00


anim_e_no:
	rts
choose_who_died:
	ldy #$00
	lda #$ff
	sta e_pos, x
	lda #$00
	sta e1_anim_state, x
	sta e_types, x
	sta e1_left, x
	sta e1_right, x
	sta e1_top, x
	sta e1_bot, x
	sta e1_dir, x
	sta e1_speed_lo, x
	sta e1_speed_lo2, x
	sta e1_offset_gen, x
	sta e1_move_count, x
	sta e1_shooting, x
	sta e1_catchall, x
	sta e1shot_left, x
	sta e1shot_right, x
	sta e1shot_top, x
	sta e1shot_bot, x
	txa
	bne :+
		lda #$ff
		sta e1_shot1
		sta e1_top_left
		sta e1_top_right
		sta e1_bot_left
		sta e1_bot_right
		rts
:	cmp #$01
	bne :+
		lda #$ff
		sta e2_shot1
		sta e2_top_left
		sta e2_top_right
		sta e2_bot_left
		sta e2_bot_right
		rts
:	cmp #$02
	bne :+
		lda #$ff
		sta e3_shot1
		sta e3_top_left
		sta e3_top_right
		sta e3_bot_left
		sta e3_bot_right
		rts
:	lda #$ff
	sta e4_shot1
		sta e4_top_left
		sta e4_top_right
		sta e4_bot_left
		sta e4_bot_right
	rts

anim_gargoyle:
	lda map_pos
	cmp #$41
	beq :+
		cmp #$51
		beq :+
			cmp #$61
			beq :+
				cmp #$62
				bne :++
:		rts
:	lda e1_anim_state, x
	cmp #$88
	beq @skip_init
		lda #<anim_garg1
		sta temp_addy+0
		lda #>anim_garg1
		sta temp_addy+1
		jsr choose_e_load
		lda e1_anim_state, x
		clc
		adc #$80
		sta e1_anim_state, x
@skip_init:
	dec e1_anim_count, x
	beq :+
		rts
:	jsr choose_e_load
	rts
anim_garg1:
	.byte $60,$01
	.byte $61,$01
	.byte $62,$01
	.byte $63,$01
	.byte $10
	.byte <anim_garg2,>anim_garg2
	.byte $08
anim_garg2:
	.byte $64,$01
	.byte $65,$01
	.byte $66,$01
	.byte $67,$01
	.byte $10
	.byte <anim_garg1,>anim_garg1
	.byte $ff


anim_golem:
	lda e1_anim_state, x
	cmp #$89
	beq @skip_init
		lda e1_offset_gen, x
		cmp #$0f
		bcs :++
			lda e1_dir, x
			bne :+
				lda #<anim_golem_left1
				sta temp_addy+0
				lda #>anim_golem_left1
				sta temp_addy+1
				jmp :++++
:			lda #<anim_golem_right1
			sta temp_addy+0
			lda #>anim_golem_right1
			sta temp_addy+1
			jmp :+++
:		lda e1_dir, x
		bne :+
			lda #<anim_golem_left2
			sta temp_addy+0
			lda #>anim_golem_left2
			sta temp_addy+1
			jmp :++
:		lda #<anim_golem_right2
		sta temp_addy+0
		lda #>anim_golem_right2
		sta temp_addy+1
:		jsr choose_e_load
		lda e1_anim_state, x
		clc
		adc #$80
		sta e1_anim_state, x
@skip_init:
	dec e1_anim_count, x
	beq :+
		rts
:	jsr choose_e_load
	rts
anim_golem_right1:
	.byte $70,$01
	.byte $71,$01
	.byte $72,$01
	.byte $73,$01
	.byte $01
	.byte <anim_golem_right1,>anim_golem_right1
	.byte $08
anim_golem_right2:
	.byte $74,$01
	.byte $75,$01
	.byte $76,$01
	.byte $77,$01
	.byte $01
	.byte <anim_golem_right2,>anim_golem_right2
	.byte $08
anim_golem_left1:
	.byte $71,$41
	.byte $70,$41
	.byte $73,$41
	.byte $72,$41
	.byte $01
	.byte <anim_golem_left1,>anim_golem_left1
	.byte $08
anim_golem_left2:
	.byte $75,$41
	.byte $74,$41
	.byte $77,$41
	.byte $76,$41
	.byte $01
	.byte <anim_golem_left2,>anim_golem_left2
	.byte $08



anim_raven:
	lda e1_anim_state, x
	cmp #$8a
	beq @skip_init
		lda e1_dir, x
		beq :+
			lda #<anim_raven_right1
			sta temp_addy+0
			lda #>anim_raven_right1
			sta temp_addy+1
			jmp :++
:		lda #<anim_raven_left1
		sta temp_addy+0
		lda #>anim_raven_left1
		sta temp_addy+1
:		jsr choose_e_load
		lda e1_anim_state, x
		clc
		adc #$80
		sta e1_anim_state, x
@skip_init:
	dec e1_anim_count, x
	beq :+
		rts
:	jsr choose_e_load
	rts
anim_raven_left1:
	.byte $6c,$02
	.byte $6d,$02
	.byte $6e,$02
	.byte $6f,$02
	.byte $08
	.byte <anim_raven_left2,>anim_raven_left2
	.byte $0a
anim_raven_left2:
	.byte $7c,$02
	.byte $7d,$02
	.byte $7e,$02
	.byte $7f,$02
	.byte $08
	.byte <anim_raven_left1,>anim_raven_left1
	.byte $ff
anim_raven_right1:
	.byte $6d,$42
	.byte $6c,$42
	.byte $6f,$42
	.byte $6e,$42
	.byte $08
	.byte <anim_raven_right2,>anim_raven_right2
	.byte $0a
anim_raven_right2:
	.byte $7d,$42
	.byte $7c,$42
	.byte $7f,$42
	.byte $7e,$42
	.byte $08
	.byte <anim_raven_right1,>anim_raven_right1
	.byte $ff


anim_goblin:
	lda e1_anim_state, x
	cmp #$8b
	beq @skip_init
		lda e1_dir, x
		beq @left
			lda e1_speed_lo, x
			cmp #$01
			bne :+
				lda #<anim_goblin_rwalk1
				sta temp_addy+0
				lda #>anim_goblin_rwalk1
				sta temp_addy+1
				jmp @start_load
:			lda #<anim_goblin_rfall1
			sta temp_addy+0
			lda #>anim_goblin_rfall1
			sta temp_addy+1
			jmp @start_load
@left:
	lda e1_speed_lo, x
	bne :+
		lda #<anim_goblin_lwalk1
		sta temp_addy+0
		lda #>anim_goblin_lwalk1
		sta temp_addy+1
		jmp @start_load
:	lda #<anim_goblin_lfall1
	sta temp_addy+0
	lda #>anim_goblin_lfall1
	sta temp_addy+1
@start_load:
		jsr choose_e_load
		lda e1_anim_state, x
		clc
		adc #$80
		sta e1_anim_state, x
@skip_init:
	dec e1_anim_count, x
	beq :+
		rts
:	jsr choose_e_load
	rts
anim_goblin_rwalk1:
	.byte $80,$03
	.byte $81,$03
	.byte $84,$03
	.byte $85,$03
	.byte $08
	.byte <anim_goblin_rwalk2,>anim_goblin_rwalk2
	.byte $ff
anim_goblin_rwalk2:
	.byte $80,$03
	.byte $81,$03
	.byte $86,$03
	.byte $87,$03
	.byte $08
	.byte <anim_goblin_rwalk1,>anim_goblin_rwalk1
	.byte $ff
;anim_goblin_rwalk3:
;	.byte $80,$03
;	.byte $81,$03
;	.byte $84,$03
;	.byte $85,$03
;	.byte $08
;	.byte <anim_goblin_rwalk4,>anim_goblin_rwalk4
;	.byte $ff
;anim_goblin_rwalk4:
;	.byte $80,$03
;	.byte $81,$03
;	.byte $82,$03
;	.byte $83,$03
;	.byte $08
;	.byte <anim_goblin_rwalk1,>anim_goblin_rwalk1
;	.byte $ff
anim_goblin_lwalk1:
	.byte $81,$43
	.byte $80,$43
	.byte $85,$43
	.byte $84,$43
	.byte $08
	.byte <anim_goblin_lwalk2,>anim_goblin_lwalk2
	.byte $ff
anim_goblin_lwalk2:
	.byte $81,$43
	.byte $80,$43
	.byte $87,$43
	.byte $86,$43
	.byte $08
	.byte <anim_goblin_lwalk1,>anim_goblin_lwalk1
	.byte $ff
;anim_goblin_lwalk3:
;	.byte $81,$43
;	.byte $80,$43
;	.byte $85,$43
;	.byte $84,$43
;	.byte $08
;	.byte <anim_goblin_lwalk4,>anim_goblin_lwalk4
;	.byte $ff
;anim_goblin_lwalk4:
;	.byte $81,$43
;	.byte $80,$43
;	.byte $83,$43
;	.byte $82,$43
;	.byte $08
;	.byte <anim_goblin_lwalk1,>anim_goblin_lwalk1
;	.byte $ff
;anim_goblin_rclimb1:
;	.byte $88,$03
;	.byte $89,$03
;	.byte $00,$03
;	.byte $8a,$03
;	.byte $08
;	.byte <anim_goblin_rclimb2,>anim_goblin_rclimb2
;	.byte $ff
;anim_goblin_rclimb2:
;	.byte $8b,$03
;	.byte $8c,$03
;	.byte $00,$03
;	.byte $8d,$03
;	.byte $08
;	.byte <anim_goblin_rclimb1,>anim_goblin_rclimb1
;	.byte $ff
;anim_goblin_lclimb1:
;	.byte $89,$43
;	.byte $88,$43
;	.byte $8a,$43
;	.byte $00,$43
;	.byte $08
;	.byte <anim_goblin_lclimb2,>anim_goblin_lclimb2
;	.byte $ff
;anim_goblin_lclimb2:
;	.byte $8c,$43
;	.byte $8b,$43
;	.byte $8d,$43
;	.byte $00,$43
;	.byte $08
;	.byte <anim_goblin_lclimb1,>anim_goblin_lclimb1
;	.byte $ff
anim_goblin_rfall1:
	.byte $80,$03
	.byte $81,$03
	.byte $82,$03
	.byte $83,$03
	.byte $01
	.byte <anim_goblin_rfall1,>anim_goblin_rfall1
	.byte $ff
anim_goblin_lfall1:
	.byte $81,$43
	.byte $80,$43
	.byte $83,$43
	.byte $82,$43
	.byte $01
	.byte <anim_goblin_lfall1,>anim_goblin_lfall1
	.byte $0b




anim_lizard:
		lda e1_catchall, x
		beq @check_dir
		cmp #$01
		beq @walk_left
		cmp #$02
		beq @walk_right
		cmp #$03
		beq @throw_left
		cmp #$04
		beq @throw_right
		cmp #$05
		beq @throw_left
		cmp #$06
		beq @throw_right
			jmp @check_dir
@throw_left:
		lda #<anim_lizard_lthrow1
		sta temp_addy+0
		lda #>anim_lizard_lthrow1
		sta temp_addy+1
		jmp @do_load
@throw_right:
		lda #<anim_lizard_rthrow1
		sta temp_addy+0
		lda #>anim_lizard_rthrow1
		sta temp_addy+1
		jmp @do_load
@check_dir:
	lda e1_anim_state, x
	cmp #$8c
	beq @skip_init
		lda e1_dir, x
		beq @walk_left
@walk_right:
			lda #<anim_lizard_rwalk1
			sta temp_addy+0
			lda #>anim_lizard_rwalk1
			sta temp_addy+1
			jmp @do_load
@walk_left:
		lda #<anim_lizard_lwalk1
		sta temp_addy+0
		lda #>anim_lizard_lwalk1
		sta temp_addy+1
@do_load:
		jsr choose_e_load
		lda e1_anim_state, x
		clc
		adc #$80
		sta e1_anim_state, x
@skip_init:
	dec e1_anim_count, x
	beq :+
		rts
:	jsr choose_e_load
	rts
anim_lizard_rwalk1:
	.byte $69,$43
	.byte $68,$43
	.byte $6b,$43
	.byte $6a,$43
	.byte $08
	.byte <anim_lizard_rwalk2,>anim_lizard_rwalk2
	.byte $0c
anim_lizard_rwalk2:
	.byte $79,$43
	.byte $78,$43
	.byte $7b,$43
	.byte $7a,$43
	.byte $08
	.byte <anim_lizard_rwalk3,>anim_lizard_rwalk3
	.byte $ff
anim_lizard_rwalk3:
	.byte $69,$43
	.byte $68,$43
	.byte $6b,$43
	.byte $6a,$43
	.byte $08
	.byte <anim_lizard_rwalk4,>anim_lizard_rwalk4
	.byte $ff
anim_lizard_rwalk4:
	.byte $79,$43
	.byte $78,$43
	.byte $9f,$43
	.byte $9e,$43
	.byte $08
	.byte <anim_lizard_rwalk1,>anim_lizard_rwalk1
	.byte $ff
anim_lizard_lwalk1:
	.byte $68,$03
	.byte $69,$03
	.byte $6a,$03
	.byte $6b,$03
	.byte $08
	.byte <anim_lizard_lwalk2,>anim_lizard_lwalk2
	.byte $0c
anim_lizard_lwalk2:
	.byte $78,$03
	.byte $79,$03
	.byte $7a,$03
	.byte $7b,$03
	.byte $08
	.byte <anim_lizard_lwalk3,>anim_lizard_lwalk3
	.byte $ff
anim_lizard_lwalk3:
	.byte $68,$03
	.byte $69,$03
	.byte $6a,$03
	.byte $6b,$03
	.byte $08
	.byte <anim_lizard_lwalk4,>anim_lizard_lwalk4
	.byte $ff
anim_lizard_lwalk4:
	.byte $78,$03
	.byte $79,$03
	.byte $9e,$03
	.byte $9f,$03
	.byte $08
	.byte <anim_lizard_lwalk1,>anim_lizard_lwalk1
	.byte $ff	
anim_lizard_rthrow1:
	.byte $89,$43
	.byte $88,$43
	.byte $8b,$43
	.byte $8a,$43
	.byte $01
	.byte <anim_lizard_rthrow1,>anim_lizard_rthrow1
	.byte $0c
anim_lizard_lthrow1:
	.byte $88,$03
	.byte $89,$03
	.byte $8a,$03
	.byte $8b,$03
	.byte $01
	.byte <anim_lizard_lthrow1,>anim_lizard_lthrow1
	.byte $0c




anim_bird:
	lda e_pos, x
	cmp #$8e
	bne :+
		jmp @shooter
:	lda e1_anim_state, x
	cmp #$8d
	beq @skip_init
		lda e1_offset_gen, x
		beq :++
			cmp #$01
			beq :+
			cmp #$02
			beq :+
			cmp #$03
			beq :++
			cmp #$04
			beq :++
:			lda #<anim_bird_right1
			sta temp_addy+0
			lda #>anim_bird_right1
			sta temp_addy+1
			jmp @loader
:		lda #<anim_bird_left1
		sta temp_addy+0
		lda #>anim_bird_left1
		sta temp_addy+1
		jmp @loader
@shooter:
		lda #<anim_bird_shoot
		sta temp_addy+0
		lda #>anim_bird_shoot
		sta temp_addy+1
@loader:
		jsr choose_e_load
		lda e1_anim_state, x
		clc
		adc #$80
		sta e1_anim_state, x
@skip_init:
	dec e1_anim_count, x
	beq :+
		rts
:	jsr choose_e_load
	rts
anim_bird_left1:
	.byte $a0,$03
	.byte $a1,$03
	.byte $a2,$03
	.byte $a3,$03
	.byte $08
	.byte <anim_bird_left2,>anim_bird_left2
	.byte $0d
anim_bird_left2:
	.byte $a4,$03
	.byte $a5,$03
	.byte $a6,$03
	.byte $a7,$03
	.byte $08
	.byte <anim_bird_left1,>anim_bird_left1
	.byte $ff
anim_bird_right1:
	.byte $a1,$43
	.byte $a0,$43
	.byte $a3,$43
	.byte $a2,$43
	.byte $08
	.byte <anim_bird_right2,>anim_bird_right2
	.byte $0d
anim_bird_right2:
	.byte $a5,$43
	.byte $a4,$43
	.byte $a7,$43
	.byte $a6,$43
	.byte $08
	.byte <anim_bird_right1,>anim_bird_right1
	.byte $ff
anim_bird_shoot:
	.byte $a0,$03
	.byte $a1,$03
	.byte $a2,$03
	.byte $a3,$03
	.byte $01
	.byte <anim_bird_shoot,>anim_bird_shoot
	.byte $0d





anim_lastboss:
	lda e1_anim_state, x
	cmp #$8f
	beq @skip_init
		lda e1_liz_off, x
		beq :+
			lda #<anim_lastboss_summon
			sta temp_addy+0
			lda #>anim_lastboss_summon
			sta temp_addy+1
			jmp @load_it
:		lda e1_shooting, x
		cmp #$30
		bne :+
			lda #<anim_lastboss_laugh1
			sta temp_addy+0
			lda #>anim_lastboss_laugh1
			sta temp_addy+1
			jmp @load_it
:		lda #<anim_lastboss_nothing
		sta temp_addy+0
		lda #>anim_lastboss_nothing
		sta temp_addy+1
@load_it:
		jsr choose_e_load
		lda e1_anim_state, x
		clc
		adc #$80
		sta e1_anim_state, x
@skip_init:
	dec e1_anim_count, x
	beq :+
		rts
:	jsr choose_e_load
	rts
anim_lastboss_nothing:
	.byte $90,$03
	.byte $91,$03
	.byte $92,$03
	.byte $93,$03
	.byte $01
	.byte <anim_lastboss_nothing,>anim_lastboss_nothing
	.byte $0f
anim_lastboss_laugh1:
	.byte $94,$03
	.byte $95,$03
	.byte $92,$03
	.byte $93,$03
	.byte $08
	.byte <anim_lastboss_laugh2,>anim_lastboss_laugh2
	.byte $ff
anim_lastboss_laugh2:
	.byte $90,$03
	.byte $91,$03
	.byte $92,$03
	.byte $93,$03
	.byte $08
	.byte <anim_lastboss_laugh1,>anim_lastboss_laugh1
	.byte $ff
anim_lastboss_summon:
	.byte $96,$03
	.byte $97,$03
	.byte $98,$03
	.byte $99,$03
	.byte $01
	.byte <anim_lastboss_summon,>anim_lastboss_summon
	.byte $ff



anim_gargboss:
		lda e1_dir, x
		cmp #$02
		bne :+
			lda #<anim_gargboss_down
			sta temp_addy+0
			lda #>anim_gargboss_down
			sta temp_addy+1
			jmp @load_um
:	cmp #$04
	bne :+
		lda #<anim_gargboss_up1
		sta temp_addy+0
		lda #>anim_gargboss_up1
		sta temp_addy+1
		jmp @load_um
:	lda e1_anim_state, x
	cmp #$88
	beq @skip_init
		lda #<anim_gargboss1
		sta temp_addy+0
		lda #>anim_gargboss1
		sta temp_addy+1
@load_um:
		jsr choose_e_load
		lda e1_anim_state, x
		clc
		adc #$80
		sta e1_anim_state, x
@skip_init:
	dec e1_anim_count, x
	beq :+
		rts
:	jsr choose_e_load
	rts
anim_gargboss1:
	.byte $60,$03
	.byte $61,$03
	.byte $62,$03
	.byte $63,$03
	.byte $10
	.byte <anim_gargboss2,>anim_gargboss2
	.byte $08
anim_gargboss2:
	.byte $64,$03
	.byte $65,$03
	.byte $66,$03
	.byte $67,$03
	.byte $10
	.byte <anim_gargboss1,>anim_gargboss1
	.byte $ff
anim_gargboss_down:
	.byte $60,$03
	.byte $61,$03
	.byte $62,$03
	.byte $63,$03
	.byte $01
	.byte <anim_gargboss_down,>anim_gargboss_down
	.byte $08
anim_gargboss_up1:
	.byte $60,$03
	.byte $61,$03
	.byte $62,$03
	.byte $63,$03
	.byte $04
	.byte <anim_gargboss_up2,>anim_gargboss_up2
	.byte $08
anim_gargboss_up2:
	.byte $64,$03
	.byte $65,$03
	.byte $66,$03
	.byte $67,$03
	.byte $04
	.byte <anim_gargboss_up1,>anim_gargboss_up1
	.byte $ff

e1_anim_load:
	lda e1_anim_state
	and #$80
	cmp #$80
	beq :+
		lda temp_addy+0
		sta e1_anim_addy+0
		lda temp_addy+1
		sta e1_anim_addy+1
:	ldy #$00
	lda (e1_anim_addy), y
	sta e1_top_left+1
	iny
	lda (e1_anim_addy), y
	sta e1_top_left+2
	iny
	lda (e1_anim_addy), y
	sta e1_top_right+1
	iny
	lda (e1_anim_addy), y
	sta e1_top_right+2
	iny
	lda (e1_anim_addy), y
	sta e1_bot_left+1
	iny
	lda (e1_anim_addy), y
	sta e1_bot_left+2
	iny
	lda (e1_anim_addy), y
	sta e1_bot_right+1
	iny
	lda (e1_anim_addy), y
	sta e1_bot_right+2
	iny
	lda (e1_anim_addy), y
	sta e1_anim_count
	iny
	lda (e1_anim_addy), y
	sta temp_addy+0
	iny
	lda (e1_anim_addy), y
	sta temp_addy+1
	iny
	lda (e1_anim_addy), y
	cmp #$ff
	beq :+
		sta e1_anim_state
:
	lda temp_addy+0
	sta e1_anim_addy+0
	lda temp_addy+1
	sta e1_anim_addy+1
	rts

e2_anim_load:
	lda e2_anim_state
	and #$80
	cmp #$80
	beq :+
		lda temp_addy+0
		sta e2_anim_addy+0
		lda temp_addy+1
		sta e2_anim_addy+1
:	ldy #$00
	lda (e2_anim_addy), y
	sta e2_top_left+1
	iny
	lda (e2_anim_addy), y
	sta e2_top_left+2
	iny
	lda (e2_anim_addy), y
	sta e2_top_right+1
	iny
	lda (e2_anim_addy), y
	sta e2_top_right+2
	iny
	lda (e2_anim_addy), y
	sta e2_bot_left+1
	iny
	lda (e2_anim_addy), y
	sta e2_bot_left+2
	iny
	lda (e2_anim_addy), y
	sta e2_bot_right+1
	iny
	lda (e2_anim_addy), y
	sta e2_bot_right+2
	iny
	lda (e2_anim_addy), y
	sta e2_anim_count
	iny
	lda (e2_anim_addy), y
	sta temp_addy+0
	iny
	lda (e2_anim_addy), y
	sta temp_addy+1
	iny
	lda (e2_anim_addy), y
	cmp #$ff
	beq :+
		sta e2_anim_state
:
	lda temp_addy+0
	sta e2_anim_addy+0
	lda temp_addy+1
	sta e2_anim_addy+1
	rts

e3_anim_load:
	lda e3_anim_state
	and #$80
	cmp #$80
	beq :+
		lda temp_addy+0
		sta e3_anim_addy+0
		lda temp_addy+1
		sta e3_anim_addy+1
:	ldy #$00
	lda (e3_anim_addy), y
	sta e3_top_left+1
	iny
	lda (e3_anim_addy), y
	sta e3_top_left+2
	iny
	lda (e3_anim_addy), y
	sta e3_top_right+1
	iny
	lda (e3_anim_addy), y
	sta e3_top_right+2
	iny
	lda (e3_anim_addy), y
	sta e3_bot_left+1
	iny
	lda (e3_anim_addy), y
	sta e3_bot_left+2
	iny
	lda (e3_anim_addy), y
	sta e3_bot_right+1
	iny
	lda (e3_anim_addy), y
	sta e3_bot_right+2
	iny
	lda (e3_anim_addy), y
	sta e3_anim_count
	iny
	lda (e3_anim_addy), y
	sta temp_addy+0
	iny
	lda (e3_anim_addy), y
	sta temp_addy+1
	iny
	lda (e3_anim_addy), y
	cmp #$ff
	beq :+
		sta e3_anim_state
:
	lda temp_addy+0
	sta e3_anim_addy+0
	lda temp_addy+1
	sta e3_anim_addy+1
	rts

e4_anim_load:
	lda e4_anim_state
	and #$80
	cmp #$80
	beq :+
		lda temp_addy+0
		sta e4_anim_addy+0
		lda temp_addy+1
		sta e4_anim_addy+1
:	ldy #$00
	lda (e4_anim_addy), y
	sta e4_top_left+1
	iny
	lda (e4_anim_addy), y
	sta e4_top_left+2
	iny
	lda (e4_anim_addy), y
	sta e4_top_right+1
	iny
	lda (e4_anim_addy), y
	sta e4_top_right+2
	iny
	lda (e4_anim_addy), y
	sta e4_bot_left+1
	iny
	lda (e4_anim_addy), y
	sta e4_bot_left+2
	iny
	lda (e4_anim_addy), y
	sta e4_bot_right+1
	iny
	lda (e4_anim_addy), y
	sta e4_bot_right+2
	iny
	lda (e4_anim_addy), y
	sta e4_anim_count
	iny
	lda (e4_anim_addy), y
	sta temp_addy+0
	iny
	lda (e4_anim_addy), y
	sta temp_addy+1
	iny
	lda (e4_anim_addy), y
	cmp #$ff
	beq :+
		sta e4_anim_state
:
	lda temp_addy+0
	sta e4_anim_addy+0
	lda temp_addy+1
	sta e4_anim_addy+1
	rts
