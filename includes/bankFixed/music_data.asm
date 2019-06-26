; This relies on the ability of the assembler to read labels and put data bytes
; and all that other good stuff. No actual assembly is used here, just data.

;;;;;;;;;;;;;;;;;
;;  envelopes  ;;
;;;;;;;;;;;;;;;;;
;; 10 - Jump to position XX
;; FF - Stop envelope

; Each byte is just simply written to register 0 of whatever channel is using the
; envelope, after one of the useless bits being masked out so commands (yep, all
; two of them) could exist. Triangle channel completely ignores envelopes.
; It's *highly* recommended that the first envelope is a silent one.

envelopes:
 .addr env_blank
 .addr env_lead1, env_nse_hat, env_nse_hat2, sq4sound, sq8sound
 .addr punch_env

env_blank:
 .byte	$00,$FF
env_lead1:
 .byte	$0F,$0D,$0B,$09,$07,$05,$04,$04,$ff
env_nse_hat:
 .byte	$0F,$0C,$00,$FF
env_nse_hat2:
 .byte	$0f,$0b,$07,$03,$FF
sq4sound:
	.byte $4a,$4a,$4d,$4d,$4d,$4a,$43,$43,$ff
sq8sound:
	.byte $8a,$8a,$8d,$8d,$8d,$8a,$8a,$8a,$8d,$8a,$89,$88,$83,$83,$83,$83,$83,$ff
punch_env:
	.byte $8a,$89,$88,$87,$ff


;;;;;;;;;;;;;;;;;;
;;  song table  ;;
;;;;;;;;;;;;;;;;;;
; This determines what song is assigned to what value when loading songs
songs:
	.addr silence
	.addr overworld_song, clear, boss_song, end_song, cont_song
	.addr underworld_song, fire_song, river_song, final_song

;;;;;;;;;;;;;
;;  songs  ;;
;;;;;;;;;;;;;
;; C8 XX - silent rest for XX cycles
;; C0 XX - do nothing (just extend the note for another XX cycles)
;; C1 XX - precut (cut the note XX cycles before it ends)
;; C2 XX - set envelope to XX
;; C3 YY XX ZZ - jump to YYXX, ZZ times
;; C4 YY XX - jump to YYXX
;; C5 XX - set detune to XX (01-7F up, 80-FF down, 00 none)
;; C6 XX - decrease envelope volume by XX
;; C7 XX - set pitch bend to XX (01-7F down, 80-FE up, 00 none)
;; C9 XX - set tempo-independent pitch bend (functions the same as C7)
;; FF - Track end (the track stops playing here)

; The first 4 words in the list are the pointer for square 1, square 2, tri, noise
; in that order, followed by a byte that defines the tempo. Lower values are
; slower, higher are faster, 00 is infinitely slow, making the song stop.
; If you don't use a particular channel for a song, just put $0000 as the pointer.
; All four channels can be used at once. It's *highly* recommended that you reserve
; one song in your playlist to be a silent song.

silence:
	.word $0000, $0000, $0000, $0000
	.byte $00
overworld_song:
	.addr overworld_sq1, overworld_sq2, overworld_tri, $0000
	.byte $90
clear:
	.addr clear_sq1, clear_sq2, clear_tri, $0000
	.byte $90
boss_song:
	.addr boss_sq1, boss_sq2, boss_tri, $0000
	.byte $90
end_song:
	.addr end_sq1, end_sq2, end_tri, $0000
	.byte $90
cont_song:
	.addr $0000,$0000,cont_song_tri,$0000
	.byte $d0
underworld_song:
	.addr $0000,overworld_sq1,overworld_tri,$0000
	.byte $90
fire_song:
	.addr fire_sq1, fire_sq2, fire_tri, $0000
	.byte $90
river_song:
	.addr river_sq1, river_sq2, river_tri, $0000
	.byte $90
final_song:
	.addr final_song_sq1, final_song_sq2, final_song_tri, $0000
	.byte $70
; Song data is just <note> <duration> for each note, or <command> <data>... for
; commands (see table above). For <note>, the higher nybble is the actual note
; (the scale begins with A, so 0x is A, 1x is A#, 2x is B, etc), and the lower
; nybble is the octave. The tracks are state machines, so whatever commands you
; apply (like envelope, detune, pitch bend, etc) will stick until you change them,
; or until a new song is loaded.

; cheat sheet:
; A=0 #=1 B=2 C=3 #=4 D=5 #=6 E=7 F=8 #=9 G=a #=b
overworld_sq1:
	.byte $c2,$04
	.byte $c8,$80
overworld_sq11:
	.byte $c1,$04
	.byte $00,$08, $01,$08
	.byte $c3,<overworld_sq11,>overworld_sq11,$0f
overworld_sq12:
	.byte $70,$08, $71,$08
	.byte $c3,<overworld_sq12,>overworld_sq12,$0f
overworld_sq13:
	.byte $70,$08, $92,$08, $52,$08, $32,$08
	.byte $c3,<overworld_sq13,>overworld_sq13,$07
	.byte $c1,$00, $03,$40, $72,$40
	.byte $c4,<overworld_sq11,>overworld_sq11

overworld_sq2:
	.byte $c2,$05
	.byte $02,$10, $72,$10, $c1,$04,$52,$08, $42,$08, $c1,$00,$22,$10 
	.byte $a1,$08, $52,$04, $32,$04, $22,$08, $a1,$08, $02,$08, $02,$08, $52,$10
	.byte $c3,<overworld_sq2,>overworld_sq2,$04
overworld_sq21:
	.byte $72,$40, $92,$40, $52,$40, $02,$20, $32,$20
	.byte $c4,<overworld_sq2,>overworld_sq2

overworld_tri:
	.byte $c1,$02
	.byte $02,$10
	.byte $c3,<overworld_tri,>overworld_tri,$07
overworld_tri1:
	.byte $52,$10, $72,$10, $02,$10, $52,$10
	.byte $c3,<overworld_tri1,>overworld_tri1,$07
overworld_tri2:
	.byte $72,$08
	.byte $c3,<overworld_tri2,>overworld_tri2,$07
overworld_tri3:
	.byte $92,$08
	.byte $c3,<overworld_tri3,>overworld_tri3,$07
overworld_tri4:
	.byte $52,$08
	.byte $c3,<overworld_tri4,>overworld_tri4,$07
overworld_tri5:
	.byte $32,$08
	.byte $c3,<overworld_tri5,>overworld_tri5,$07
	.byte $c4,<overworld_tri,>overworld_tri


clear_sq1:
	.byte $c2,$01
	.byte $00,$01,$10,$01,$20,$01,$30,$01,$40,$01,$50,$01,$60,$01,$70,$01
	.byte $80,$08, $50,$08, $80,$08, $b0,$18, $ff
clear_sq2:
	.byte $c2,$01
	.byte $71,$01,$81,$01,$91,$01,$a1,$01,$b1,$01,$02,$01,$12,$01,$22,$01
	.byte $32,$08, $02,$08, $32,$08, $62,$18, $ff
clear_tri:
	.byte $02,$01,$12,$01,$22,$01,$32,$01,$42,$01,$52,$01,$62,$01,$72,$01
	.byte $83,$08, $53,$08, $83,$08, $b3,$18, $ff



boss_sq1:
	.byte $c2,$05
	.byte $90,$20
boss_sq11:
	.byte $00,$10, $b0,$08, $00,$10, $b0,$08, $00,$08, $20,$08
	.byte $c3,<boss_sq11,>boss_sq11,$07
boss_sq12:
	.byte $00,$04
	.byte $c3,<boss_sq12,>boss_sq12,$3f
	.byte $c4,<boss_sq11,>boss_sq11

boss_sq2:
	.byte $c2,$04
	.byte $61,$20
boss_sq21:
	.byte $01,$40
	.byte $51,$40
	.byte $c3,<boss_sq21,>boss_sq21,$03
	.byte $01,$40,$31,$40,$81,$40,$51,$40
	.byte $c4,<boss_sq21,>boss_sq21

boss_tri:
	.byte $c1,$01
	.byte $22,$20
boss_tri1:
	.byte $03,$04
	.byte $c3,<boss_tri1,>boss_tri1,$03
boss_tri2:
	.byte $52,$04
	.byte $c3,<boss_tri2,>boss_tri2,$03
	.byte $c4,<boss_tri1,>boss_tri1


end_sq1:
	.byte $c2,$05
end_sq1_1:
	.byte $c8,$08, $03,$04,$72,$04,$03,$04,$33,$04,$23,$04,$03,$04,$53,$10,$23,$18
	.byte $03,$04,$72,$04,$03,$04,$33,$04,$03,$04,$72,$04, $23,$0a
	.byte $03,$02,$72,$02,$23,$02, $53,$08,$23,$10
	.byte $03,$04,$72,$04,$03,$04,$23,$04,$03,$04,$72,$04,$53,$10,$23,$0c, $23,04
	.byte $73,$18,$73,$08,$53,$10,$53,$08,$23,$08
	.byte $c4,<end_sq1_1,>end_sq1_1
end_sq2:
	.byte $c2,$04
	.byte $c4,<end_sq1_1,>end_sq1_1
end_tri:
	.byte $02,$20, $a1,$20, $02,$20, $81,$10, $a1,$10
	.byte $02,$20, $a1,$20, $32,$20, $22,$20
	.byte $c4,<end_tri,>end_tri

cont_song_tri:
	.byte $c1,$01
	.byte $02,$18,$c8,$10, $02,$0c,$c8,$04, $02,$08, $02,$18,$c8,$28
	.byte $c4,<cont_song_tri,>cont_song_tri



fire_sq1:
	.byte $c2,$05
	.byte $00,$20, $00,$20, $30,$20, $00,$20
	.byte $70,$20, $30,$20, $90,$20, $30,$20
	.byte $c3,<fire_sq1,>fire_sq1,$03
fire_sq11:
	.byte $00,$08, $00,$08, $30,$08, $00,$08
	.byte $70,$08, $30,$08, $90,$08, $30,$08
	.byte $c3,<fire_sq11,>fire_sq11,$03
	.byte $c4,<fire_sq1,>fire_sq1
fire_sq2:
	.byte $c2,$02
	.byte $00,$10,$10,$10
	.byte $c3,<fire_sq2,>fire_sq2,$1f
fire_sq21:
	.byte $00,$08,$10,$08,$20,$10
	.byte $c3,<fire_sq21,>fire_sq21,$07
	.byte $c4,<fire_sq2,>fire_sq2
fire_tri:
	.byte $c1,$01
	.byte $02,$40, $72,$40
	.byte $c3,<fire_tri,>fire_tri,$07
fire_tri1:
	.byte $32,$08
	.byte $c3,<fire_tri1,>fire_tri1,$1f
	.byte $c4,<fire_tri,>fire_tri

river_sq1:
	.byte $c2,$05
	.byte $31,$08,$01,$08,$01,$10, $81,$08,$51,$08,$51,$10
	.byte $01,$10, $41,$08, $71,$08, $91,$08, $71,$08, $31,$10
	.byte $c3,<river_sq1,>river_sq1,$05
river_sq11:
	.byte $51,$20, $01,$20, $31,$20, $a1,$20
	.byte $c3,<river_sq11,>river_sq11,$01
	.byte $c4,<river_sq1,>river_sq1
river_sq2:
	.byte $c2,$05
	.byte $00,$08
	.byte $c3,<river_sq2,>river_sq2,$5f
river_sq21:
	.byte $01,$20, $71,$20, $a1,$20, $71,$20
	.byte $c3,<river_sq21,>river_sq21,$01
	.byte $c4,<river_sq2,>river_sq2
river_tri:
	.byte $32,$20, $82,$20, $72,$20, $32,$20
	.byte $c3,<river_tri,>river_tri,$05
river_tri1:
	.byte $53,$20, $03,$20, $33,$20, $a2,$20
	.byte $c3,<river_tri1,>river_tri1,$01
	.byte $c4,<river_tri,>river_tri


final_song_sq1:
	.byte $c2,$03
final_song_tri:
final_song_sq11:
	.byte $00,$08, $10,$08, $20,$08, $30,$08, $40,$08, $30,$08, $20,$08, $10,$08
	.byte $c4,<final_song_sq11,>final_song_sq11
final_song_sq2:
	.byte $c2,$06
	.byte $00,$04, $c8,$0c,$c8,$08,$00,$04, $c8,$0c,$c8,$08, $c8,$08, $c8,$08
	.byte $00,$04, $c8,$0c,$c8,$08, $00,$04, $c8,$0c, $50,$18
	.byte $c4,<final_song_sq2,>final_song_sq2

; Sound effects - Absolutely everything that applies for the music and songs
; applies here too, except sound effects have their own playlist and their
; own envelope table. Also, all sound effects play at tempo $100, which is
; impossible for music, since music tempo only goes up to $FF. When a sound
; effect is playing, it'll interrupt the corresponding channels of the music,
; and then when the sound effect is finished, the music channels it hogged will
; be audible again.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  sound effect envelopes  ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

sfxenvelopes:
	.addr sfxenv1
	.addr win_env, zecrom_env, tele_env, e_hit_env
sfxenv1:
 .byte	$8F,$8D,$88,$8F,$8E,$8D,$8C,$8B,$8A,$89,$88,$87,$86,$85,$84,$83,$82,$81,$80,$FF
win_env:
	.byte $0f,$0f,$0f,$0f,$0e,$0e,$0d,$0d,$0c,$0c,$0d,$0d,$0c,$0c,$0b,$0a,$ff
zecrom_env:
	.byte $88,$89,$8a,$8b,$8c,$8d,$8d,$8f,$8e,$8d,$8c,$8b,$8a,$89,$88,$87,$10,$00;,$86
tele_env:
	.byte $4f,$43,$10,$00
e_hit_env:
	.byte $8f,$10,$00

;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  sound effect table  ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;
sounds:
	.addr sfx_silence
	.addr pause_jingle, warp_sound, win_item, hit_enemy, ping_enemy
	.addr boss_on, floor_shake, enemy_magic, shoot_sfx, magic_sfx
	.addr hurt_sfx, land_sfx, enemy_shot_sfx, selector_sfx, thunder_sfx
	.addr splash_sfx

;;;;;;;;;;;;;;;;;;;;;
;;  sound effects  ;;
;;;;;;;;;;;;;;;;;;;;;
sfx_silence:
 .word	$0000, $0000, $0000, $0000

pause_jingle:
	.addr pause_sq1, $0000, $0000, $0000
pause_sq1:
	.byte $33,$04, $03,$04, $33,$04, $63,$04, $ff

warp_sound:
	.addr warp_sound_sq1,$0000,warp_sound_tri,$0000
warp_sound_sq1:
	.byte $c2,$03,$04,$10, $c7,$10,$04,$08,$ff
warp_sound_tri:
	.byte $04,$10,$34,$02,$23,$02,$12,$02,$01,$02,$ff

win_item:
	.addr win_item_sq1,win_item_sq2,win_item_tri,$0000
win_item_sq1:
	.byte $c2,$01
	.byte $52,$10, $82,$08, $52,$08, $33,$20, $c8,$40, $ff
win_item_sq2:
	.byte $c2,$01
	.byte $02,$10, $32,$08, $02,$08, $a1,$20, $c8,$40, $ff
win_item_tri:
	.byte $53,$10, $83,$08, $53,$08, $34,$20, $c8,$40, $ff

hit_enemy:
	.addr $0000, $0000, $0000, hit_enemy_nse
hit_enemy_nse:
	.byte $c2,$04,$0a,$04, $ff

ping_enemy:
	.addr $0000, $0000, $0000, ping_enemy_nse
ping_enemy_nse:
	.byte $c2,$04,$a1,$04, $ff

boss_on:
	.addr $0000, $0000, $0000, boss_on_nse
boss_on_nse:
	.byte $c2,$04,$a4,$08,$a3,$08, $ff

floor_shake:
	.addr $0000, $0000, $0000, floor_shake_nse
floor_shake_nse:
	.byte $c2,$04,$00,$01,$0a,$01
	.byte $c4,<floor_shake_nse,>floor_shake_nse

enemy_magic:
	.addr e_magic_sq1, e_magic_sq2, e_magic_tri,$0000
e_magic_sq1:
	.byte $00,$02, $01,$02
	.byte $c3,<e_magic_sq1,>e_magic_sq1,$08
	.byte $ff
e_magic_sq2:
	.byte $70,$02, $71,$02
	.byte $c3,<e_magic_sq2,>e_magic_sq2,$08
	.byte $ff
e_magic_tri:
	.byte $72,$24
	.byte $ff

shoot_sfx:
	.addr shoot_sfx_sq1, $0000, $0000, shoot_sfx_nse
shoot_sfx_sq1:
	.byte $c2,$03,$c7,$f1,$43,$04,$51,$04,$c7,$00,$ff
shoot_sfx_nse:
	.byte $c2,$04,$c7,$fe,$00,$08,$c7,$00, $ff

magic_sfx:
	.addr magic_sfx_sq1, $0000, $0000, $0000
magic_sfx_sq1:
	.byte $c2,$03,$c7,$fe,$22,$08,$c7,$00
	.byte $c3,<magic_sfx_sq1,>magic_sfx_sq1, $03
	.byte $ff

hurt_sfx:
	.addr hurt_sfx_sq1, hurt_sfx_sq2, $0000, $0000
hurt_sfx_sq1:
	.byte $c2,$01,$c7,$1e,$02,$04,$12,$04,$c7,$00
	.byte $c3,<hurt_sfx_sq1,>hurt_sfx_sq1, $03
	.byte $ff
hurt_sfx_sq2:
	.byte $c2,$01,$c7,$1e,$72,$04,$82,$04,$c7,$00
	.byte $c3,<hurt_sfx_sq2,>hurt_sfx_sq2, $03
	.byte $ff

land_sfx:
	.addr $0000, $0000, $0000, land_sfx_nse
land_sfx_nse:
	.byte $c2,$01,$0c,$04, $ff

enemy_shot_sfx:
	.addr $0000, $0000, $0000, enemy_shot_sfx_nse
enemy_shot_sfx_nse:
	.byte $c2,$03,$00,$04,$01,$04,$00,$04, $ff

selector_sfx:
	.addr selector_sfx_sq1, $0000,$0000,$0000
selector_sfx_sq1:
	.byte $c2,$02,$54,$04, $ff

thunder_sfx:
	.addr $0000,$0000,$0000,thunder_sfx_nse
thunder_sfx_nse:
	.byte $c2,$04,$0a,$04,$0d,$10, $ff

splash_sfx:
	.addr $0000,$0000,$0000,splash_sfx_nse
splash_sfx_nse:
	.byte $c2,$04, $a0,$01,$00,$20, $ff
; cheat sheet:
; A=0 #=1 B=2 C=3 #=4 D=5 #=6 E=7 F=8 #=9 G=a #=b

