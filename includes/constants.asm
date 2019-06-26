; remap some punctuation for ascii
.charmap $21,$3e	; !
.charmap $22,$5b	; "
.charmap $27,$5c	; '
.charmap $2b,$5d	; +
.charmap $2c,$3c	; ,
.charmap $2d,$5e	; -
.charmap $2e,$3d	; .
.charmap $20,$00	; (space)
.charmap $26,$3b	; &
.charmap $2f,$5f	; /

; Constants

a_punch				=	$01
b_punch				=	$02
select_punch		=	$04
start_punch			=	$08
up_punch			=	$10
down_punch			=	$20
left_punch			=	$40
right_punch			=	$80

pal_address			=	$100

OAM_ram				=	$200

; Sprite ram
p_top_left			=	$400
p_top_left_x		=	$403
p_top_right			=	$404
p_bot_left			=	$408
p_bot_right			=	$40c
lives_icon			=	$410
life1				=	$414
life2				=	$418
life3				=	$41c
life4				=	$420
life5				=	$424
selector			=	$428
p_shot1				=	$42c
p_shot2				=	$430
bridge1				=	$434
bridge2				=	$438
bridge3				=	$43c
bridge4				=	$440
bridge5				=	$444
bridge6				=	$448
cloud1				=	$44c
cloud2				=	$450
tele1				=	$454
tele2				=	$458
tele3				=	$45c
tele4				=	$460
cloud3				=	$464
cloud4				=	$468
item1				=	$46c
e1_top_left			=	$470
e1_top_right		=	$474
e1_bot_left			=	$478
e1_bot_right		=	$47c
e2_top_left			=	$480
e2_top_right		=	$484
e2_bot_left			=	$488
e2_bot_right		=	$48c
e3_top_left			=	$490
e3_top_right		=	$494
e3_bot_left			=	$498
e3_bot_right		=	$49c
e4_top_left			=	$4a0
e4_top_right		=	$4a4
e4_bot_left			=	$4a8
e4_bot_right		=	$4ac
e1_shot1			=	$4b0
e2_shot1			=	$4b4
e3_shot1			=	$4b8
e4_shot1			=	$4bc
blocker1			=	$4c0
blocker2			=	$4c4
continue_select		=	$4c8
extra_shot1			=	$4d0
extra_shot2			=	$4d4





bg_ram				=	$500

;e1_sprite_tiles		=	$600
;e1_sprite_attribs	=	$604
;e1_hit_points		=	$608
;e2_sprite_tiles		=	$610
;e2_sprite_attribs	=	$614
;e2_hit_points		=	$618
;e3_sprite_tiles		=	$620
;e3_sprite_attribs	=	$624
;e3_hit_points		=	$628
;e4_sprite_tiles		=	$630
;e4_sprite_attribs	=	$634
;e4_hit_points		=	$638
;shake_offset		=	$639	; used to shake the screen

;bridge_offset1		=	$700
;bridge_offset2		=	$701
;bridge_offset3		=	$702
;cloud_offset		=	$703
;tele_pos			=	$704
;tele_offset			=	$705
;tele_dir			=	$706
;tele_ticker			=	$707
;lifey_1				=	$708
;lifey_2				=	$709
;lifey_3				=	$70a
;lifey_4				=	$70b
;lifey_5				=	$70c
;flash				=	$70d
;lev_spd_offset		=	$70e
;lev_ver_offset		=	$70f
;lev_hor_offset		=	$710
;bridge_write_offset	=	$711
;tele_write_offset	=	$712
;cloud_write_offset	=	$713
;light_write_offset	=	$714
;mm_write_offset		=	$715
;life_meter_offset	=	$716
;magic_join_offset	=	$717

mm_tile1			=	$718
mm_tile2			=	$719
join_tile1			=	$71a
join_tile2			=	$71b
join_tile3			=	$71c
join_tile4			=	$71d
join_tile5			=	$71e
join_tile6			=	$71f
dummy_tile1			=	$720
dummy_tile2			=	$721
hor_tile1			=	$722
hor_tile2			=	$723
dummy_tile3			=	$724
ver_tile1			=	$725
ver_tile2			=	$726
dummy_tile4			=	$727
spd_tile1			=	$728
spd_tile2			=	$729

light_tile1			=	$72a
light_tile2			=	$72b
dummy_tile5			=	$72c
cloud_tile1			=	$72d
cloud_tile2			=	$72e
dummy_tile6			=	$72f
tele_tile1			=	$730
tele_tile2			=	$731
dummy_tile7			=	$732
bridge_tile1		=	$733
bridge_tile2		=	$734

light_tile3			=	$735
light_tile4			=	$736
dummy_tile8			=	$737
cloud_tile3			=	$738
cloud_tile4			=	$739
dummy_tile9			=	$73a
tele_tile3			=	$73b
tele_tile4			=	$73c
dummy_tile10		=	$73d
bridge_tile3		=	$73e
bridge_tile4		=	$73f

item_type			=	$740
item_pos			=	$741
item_tile			=	$742
item_attrib			=	$743
item_words			=	$744	; 16 bytes
room_words			=	$754	; 16 bytes
e_types				=	$764	; 4 bytes
e_pos				=	$768	; 4 bytes
bg_pal_lo			=	$76c
bg_pal_hi			=	$76d

item_collection		=	$76e
boss_dead			=	$77f

bg_collision_byte	=	$7bf
store_meta_16		=	$7c0
bg_attribs_ram		=	$7d0

none				=	$00
trent				=	$01
h_bat				=	$02
v_bat				=	$03

ghost_speed			=	$0060
bones_speed			=	$0080
