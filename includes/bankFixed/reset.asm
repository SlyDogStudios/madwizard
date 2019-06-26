reset:

	sei
	ldx #$00
	stx $4015
	ldx #$40
	stx $4017
	ldx #$ff
	txs
	inx
	stx $2000
	stx $2001

:	lda #$00
	sta $000, x
	sta $100, x
	sta $300, x
	sta $400, x
	sta $500, x
	sta $600, x
	sta $700, x
	lda #$f7
	sta $200, x
	inx
	bne :-

:	bit $2002
	bpl :-

	ldy #$02
	jsr bankswitch

	lda #<the_chr
	sta temp_16bit_1
	lda #>the_chr
	sta temp_16bit_1+1
 	ldy #0
	sty $2006
	sty $2006
	ldx #32
chr_load_loop:
	lda (temp_16bit_1), y
	sta $2007
	iny
	bne chr_load_loop
	inc temp_16bit_1+1
	dex
	bne chr_load_loop

	ldy #$00
	ldx #$04
	lda #<title_nam
	sta temp_16bit_1+0
	lda #>title_nam
	sta temp_16bit_1+1
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

	ldy #$00
	jsr bank_save

	ldx #$00						; Pull in bytes for sprites and their
:	lda the_sprites, x				;  attributes which are stored in the
	sta OAM_ram, x
	sta p_top_left, x				;  'the_sprites' table. Use X as an index
	inx								;  to load and store each byte, which
	cpx #112						;  get stored starting in $200, where
	bne :-							;  'car1_1' is located at.

:	bit $2002
	bpl :-

	ldx #$00
	lda #$3f
	sta $2006
	lda #$00
	sta $2006
:	lda palette,x
	sta pal_address,x
	sta $2007
	inx
	cpx #32
	bne :-

	lda #$01
	sta dummy_tile1
	sta dummy_tile2
	sta dummy_tile3
	sta dummy_tile4
	lda #$11
	sta dummy_tile5
	sta dummy_tile8
	lda #%00000000;	#%11111101;	
	sta player_stats0
	lda #%00000000;	#%00110111;		
	sta player_stats1
	jsr get_player_stats_bytes

	lda #<loop_title
	sta loop_pointer+0
	lda #>loop_title
	sta loop_pointer+1
	lda #<nmi_empty
	sta nmi_pointer+0
	lda #>nmi_empty
	sta nmi_pointer+1

	lda #$00
	jsr music_loadsong

;:	bit $2002
;	bpl :-
;
;	lda #$00
;	sta $2006
;	sta $2006
	lda #%10001000
	sta $2000
	lda #%00011010
	sta $2001
	lda nmi_num						; Wait for an NMI to happen before running
:	cmp nmi_num						; the main loop again
	beq :-							;

	lda #$01
	sta p_shot_damage
	sta title_switch
	lda #$04
	sta e3_anim_count
	lda #$02
	sta hekl_life_meter
	sta p_lives
	lda #$27
	sta lifey_1
	sta lifey_2
	lda #$26;home;	#$0d;#$3f;dig dug;	#$0a;treehouse;	#$01;lastboss;	#$42;ruins;	#$50;water	;	
	sta map_pos
	lda #$65
	sta p_pos
	lda #$10
	sta move_left_right
	lda #$03
	sta bridge_switcher
	lda #$08
	sta anim_ticker



; 4096 x 1536