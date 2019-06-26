lay_bridge:
	lda #$0a
	jsr music_loadsfx
	lda p_dir
	beq :+
		jmp @do_right
:		lda p_pos
		clc
		adc #$0f
		tax
		lda bg_ram, x
		beq :+
			rts
:		lda #$03
		sta bg_ram, x
		stx bridge_offset1
		lda p_bot_left
		clc
		adc #$08
		sta bridge1
		sta bridge2
		lda p_bot_left+3
		sec
		sbc #$08
		sta bridge1+3
		sec
		sbc #$08
		sta bridge2+3
		dex
		lda bg_ram, x
		beq :+
			lda #$ff
			sta bridge_offset2
			sta bridge_offset3
			rts
:		lda p_pos
		and #$0f
		cmp #$01
		bne :+
			lda #$ff
			sta bridge_offset2
			sta bridge_offset3
			rts
:		lda #$03
		sta bg_ram, x
		stx bridge_offset2
		lda bridge1
		sta bridge3
		sta bridge4
		lda bridge2+3
		sec
		sbc #$08
		sta bridge3+3
		sec
		sbc #$08
		sta bridge4+3
		dex
		lda bg_ram, x
		beq :+
			lda #$ff
			sta bridge_offset3
			jmp @done
:		lda p_pos
		and #$0f
		cmp #$02
		bne :+
			lda #$ff
			sta bridge_offset3
			rts
:
		lda #$03
		sta bg_ram, x
		stx bridge_offset3
		lda bridge1
		sta bridge5
		sta bridge6
		lda bridge4+3
		sec
		sbc #$08
		sta bridge5+3
		sec
		sbc #$08
		sta bridge6+3
		rts
@do_right:
		lda p_pos
		clc
		adc #$11
		tax
		lda bg_ram, x
		beq :+
			jmp @done
:		lda #$03
		sta bg_ram, x
		stx bridge_offset1
		lda p_bot_right
		clc
		adc #$08
		sta bridge1
		sta bridge2
		lda p_bot_right+3
		clc
		adc #$08
		sta bridge1+3
		clc
		adc #$08
		sta bridge2+3
		inx
		lda bg_ram, x
		beq :+
			lda #$ff
			sta bridge_offset2
			sta bridge_offset3
			jmp @done
:		lda p_pos
		and #$0f
		cmp #$0e
		bne :+
			lda #$ff
			sta bridge_offset2
			sta bridge_offset3
			rts
:
		lda #$03
		sta bg_ram, x
		stx bridge_offset2
		lda bridge1
		sta bridge3
		sta bridge4
		lda bridge2+3
		clc
		adc #$08
		sta bridge3+3
		clc
		adc #$08
		sta bridge4+3
		inx
		lda bg_ram, x
		beq :+
			lda #$ff
			sta bridge_offset3
			jmp @done
:		lda p_pos
		and #$0f
		cmp #$0d
		bne :+
			lda #$ff
			sta bridge_offset3
			rts
:
		lda #$03
		sta bg_ram, x
		stx bridge_offset3
		lda bridge1
		sta bridge5
		sta bridge6
		lda bridge4+3
		clc
		adc #$08
		sta bridge5+3
		clc
		adc #$08
		sta bridge6+3
@done:
	rts

lay_cloud:
	lda #$0a
	jsr music_loadsfx
	lda p_dir
	bne @do_right
		ldx p_pos
		dex
		lda bg_ram, x
		beq :+
			rts
:		lda #$03
		sta bg_ram, x
		stx cloud_offset
		lda p_top_left
		sta cloud1
		sta cloud2
		sta cube_top
		clc
		adc #$10
		sta cube_bot
		lda p_top_left+3
		sec
		sbc #$08
		sta cloud2+3
		sta cloud4+3
		sec
		sbc #$08
		sta cloud1+3
		sta cloud3+3
		sta cube_left
		clc
		adc #$10
		sta cube_right
		lda p_bot_left
		sta cloud3
		sta cloud4
		rts
@do_right:
		ldx p_pos
		inx
		lda bg_ram, x
		beq :+
			rts
:		lda #$03
		sta bg_ram, x
		stx cloud_offset
		lda p_top_right
		sta cloud1
		sta cloud2
		sta cube_top
		clc
		adc #$10
		sta cube_bot
		lda p_top_right+3
		clc
		adc #$08
		sta cloud1+3
		sta cloud3+3
		sta cube_left
		clc
		adc #$08
		sta cloud2+3
		sta cloud4+3
		clc
		adc #$08
		sta cube_right
		lda p_bot_right
		sta cloud3
		sta cloud4
		rts

lay_tele:
	jsr tele_direction
	lda p_dir
	sta tele_dir
	bne @do_right
		ldx p_pos
		dex
		lda bg_ram, x
		cmp #$02
		bcs @done
		stx tele_pos
		lda p_top_left
		sta tele1
		sta tele2
		lda p_bot_left
		sta tele3
		sta tele4
		lda p_top_left+3
		sec
		sbc #$08
		sta tele2+3
		sta tele4+3
		sec
		sbc #$08
		sta tele1+3
		sta tele3+3
		rts
@do_right:
		ldx p_pos
		inx
		lda bg_ram, x
		cmp #$02
		bcs @done
		stx tele_pos
		lda p_top_left
		sta tele1
		sta tele2
		lda p_bot_left
		sta tele3
		sta tele4
		lda p_top_right+3
		clc
		adc #$08
		sta tele1+3
		sta tele3+3
		clc
		adc #$08
		sta tele2+3
		sta tele4+3
@done:
	rts

tele_move:
	lda tele1
	cmp #$ff
	bne :+
		rts
:		lda tele_ticker
		beq :+
			lda tele_ticker
			sec
			sbc #$01
			sta tele_ticker
			rts
:
		lda tele_dir
		bne @tele_right
			ldx tele_pos
			dex
			lda bg_ram, x
			cmp #$02
			bcs @teleport1
				stx tele_pos
				txa
				and #$0f
				bne :+
					lda #$ff
					sta tele1
					sta tele2
					sta tele3
					sta tele4
					rts
:				lda #$02
				sta tele_ticker
				lda tele1+3
				sec
				sbc #$10
				sta tele1+3
				sta tele3+3
				lda tele2+3
				sec
				sbc #$10
				sta tele2+3
				sta tele4+3
				rts
@teleport1:
			jsr teleport_hekl
			rts
@tele_right:
			ldx tele_pos
			inx
			lda bg_ram, x
			cmp #$02
			bcc :+
				jmp @teleport2
:
				stx tele_pos
				txa
				and #$0f
				cmp #$0f
				bne :+
					lda #$ff
					sta tele1
					sta tele2
					sta tele3
					sta tele4
					rts
:				lda #$02
				sta tele_ticker
				lda tele1+3
				clc
				adc #$10
				sta tele1+3
				sta tele3+3
				lda tele2+3
				clc
				adc #$10
				sta tele2+3
				sta tele4+3
				rts
@teleport2:
			jsr teleport_hekl
			rts
@done:
	rts

tele_direction:
	lda p_dir
	beq :+
		lda #$3d
		sta tele1+1
		lda #$3e
		sta tele2+1
		lda #$3f
		sta tele3+1
		lda #$36
		sta tele4+1
		lda #$01
		sta tele1+2
		sta tele2+2
		sta tele3+2
		sta tele4+2
		rts
:	lda #$3e
	sta tele1+1
	lda #$3d
	sta tele2+1
	lda #$36
	sta tele3+1
	lda #$3f
	sta tele4+1
	lda #$41
	sta tele1+2
	sta tele2+2
	sta tele3+2
	sta tele4+2
	rts

teleport_hekl:
	lda #$02
	jsr music_loadsfx
	lda tele_pos
	sta tele_offset
	sta p_pos
	lda tele1+3
	sta p_top_left+3
	lda tele2+3
	sta p_top_right+3
	lda tele3+3
	sta p_bot_left+3
	lda tele4+3
	sta p_bot_right+3
	lda #$ff
	sta tele1
	sta tele2
	sta tele3
	sta tele4
	rts



bridge_anim:
	lda bridge_switcher
	sec
	sbc #$01
	sta bridge_switcher
	cmp #$03
	bne :+
		lda #$23
		sta bridge1+1
		sta bridge2+1
		sta bridge3+1
		sta bridge4+1
		sta bridge5+1
		sta bridge6+1
		lda #$2b
		sta cloud1+1
		sta cloud2+1
		sta cloud3+1
		sta cloud4+1
		rts
:	cmp #$02
	bne :+
		lda #$24
		sta bridge1+1
		sta bridge2+1
		sta bridge3+1
		sta bridge4+1
		sta bridge5+1
		sta bridge6+1
		lda #$2c
		sta cloud1+1
		sta cloud2+1
		sta cloud3+1
		sta cloud4+1
		rts
:	cmp #$01
	bne :+
		lda #$25
		sta bridge1+1
		sta bridge2+1
		sta bridge3+1
		sta bridge4+1
		sta bridge5+1
		sta bridge6+1
		lda #$2d
		sta cloud1+1
		sta cloud2+1
		sta cloud3+1
		sta cloud4+1
		lda #$04
		sta bridge_switcher
:
	rts

cloud_offscreen:
	lda cloud1
	cmp #$ff
	beq :+
	lda #$00
	ldx cloud_offset
	sta bg_ram, x
:	lda #$ff
	sta cloud_offset
	sta cloud1
	sta cloud2
	sta cloud3
	sta cloud4
	sta cube_top
	sta cube_left
	sta cube_right
	sta cube_bot
	rts

bridge_offscreen:
;			lda #$00
;			sta p_anim_state
;			sta p_state
			lda bridge1
			cmp #$ff
			beq :+
			lda #$00
			ldx bridge_offset1
			sta bg_ram, x
			ldx bridge_offset2
			sta bg_ram, x
			ldx bridge_offset3
			sta bg_ram, x
:			lda #$ff
			sta bridge_offset1
			sta bridge_offset2
			sta bridge_offset3
			sta bridge1
			sta bridge2
			sta bridge3
			sta bridge4
			sta bridge5
			sta bridge6
	rts
