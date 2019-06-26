; To load a song, put the song number in A, and JSR to "music_loadsong"

; To play a sound effect, put the sfx number in A and JSR to "music_loadsfx"

; You can also play a sound effect as "priority", if you add $80 to the sound
; effect number. Priority sound effects will not be interrupted by loading other
; sound effects, even if they are other priority sound effects.

; To stop all sound effects (including priority sound effects), JSR to "music_stopsfx".
; You can load a new sound effect immediately after JSRing to this if you want.

; Every frame, JSR to "music_play" if you want the sound engine to do anything.

; To move the engine's variables to a different location in ram, modify "base", which
; covers every non-zeropage variable.
; Then, modify "mus_ptr", which determines where the zero-page variables go.

;;;;;;;;;;;;;;;;;;
;;  note table  ;;
;;;;;;;;;;;;;;;;;;
; This is a table of periods for each note, beginning with A, and ending with G#

music_notetable:
;           A       A#      B       C       C#      D
;           D#      E       F       F#      G       G#
 .byte $F1,$07,$80,$07,$13,$07,$AD,$06,$4D,$06,$F3,$05
 .byte $9D,$05,$4D,$05,$00,$05,$B8,$04,$75,$04,$35,$04

; hex 00 08 8D 07 20 07 BA 06 59 06 FE 05
; hex A8 05 56 05 0A 05 C1 04 7D 04 3C 04

;;;;;;;;;;;;;;;;;
;;  load song  ;;
;;;;;;;;;;;;;;;;;

; Have the track number loaded into A when you call this
music_loadsong:
	ASL
	TAY
	LDA songs,Y			; get LSB of selected song
	STA mus_ptr			; put it in the zeropage pointer
	LDA songs+1,Y			; get MSB of selected song
	STA mus_ptrH			; complete the zeropage pointer

; Silence all channels
	LDA #$00
	STA $4015	; Mute all channels momentarily
	LDA #$40
	STA $4017	; This sets the frame cycle I want to use (4) and disables APU IRQ
	LDA #$08	; This allows the squares to hit the lowest notes
	STA sq1_r1
	STA sq2_r1
	LDA #$0F	; This enables all channels, except the DMC, which I don't use
	STA $4015	; I don't need to initialize any other registers, muting the channels slienced them

; Clear all channel flags
	LDA #$00
	LDY #chn_proplen-3
music_loadsong_initloop:
	DEY
	STA sq1+3,Y
	STA sq2+3,Y
	STA tri+3,Y
	STA nse+3,Y
	BNE music_loadsong_initloop
	STA mus_tempo
	LDA #$FF
	STA mus_tempocnt
 
	LDA sq1_flags
	AND #$80
	STA sq1_flags
	LDA sq1_flags+sq2base
	AND #$80
	STA sq1_flags+sq2base
	LDA sq1_flags+tribase
	AND #$80
	STA sq1_flags+tribase
	LDA sq1_flags+nsebase
	AND #$80
	STA sq1_flags+nsebase

	LDY #$00

	LDA (mus_ptr),Y
	STA sq1_ptr
	INY
	LDA (mus_ptr),Y
	STA sq1_ptrH
	INY
	LDA (mus_ptr),Y
	STA sq2_ptr
	INY
	LDA (mus_ptr),Y
	STA sq2_ptrH
	INY
	LDA (mus_ptr),Y
	STA tri_ptr
	INY
	LDA (mus_ptr),Y
	STA tri_ptrH
	INY
	LDA (mus_ptr),Y
	STA nse_ptr
	INY
	LDA (mus_ptr),Y
	STA nse_ptrH
	INY
	LDA (mus_ptr),Y
	STA mus_tempo
;	lda region
;	bne :+
;		iny
;		lda (mus_ptr), y
;		sta mus_tempo
;:
	RTS

;;;;;;;;;;;;;;;;
;;  load sfx  ;;
;;;;;;;;;;;;;;;;

; Have the track number loaded into A when you call this

;This code needs to do a bunch of things:
; - Determine if the sfx is "priority"
; - Put the pointer to the sfx header into zeropage
; - Determine which channels need to be initted
;	- Skip channels where the pointer's msb is 00
;	- Skip channels that are already playing a priority sfx

music_loadsfx:
	PHA
	AND #$80
	LSR
	LSR
	STA mus_scratch1		; detect and store priority flag

	PLA
	ASL
	TAY
	LDA sounds,Y			; get LSB of selected sfx
	STA mus_ptr			; put it in the zeropage pointer
	LDA sounds+1,Y			; get MSB of selected sfx
	STA mus_ptrH			; complete the zeropage pointer

	LDY #$07
	LDX #nsebase
	JSR music_loadsfx_loadchn
	LDY #$05
	LDX #tribase
	JSR music_loadsfx_loadchn
	LDY #$03
	LDX #sq2base
	JSR music_loadsfx_loadchn
	LDY #$01
	LDX #$00
	JSR music_loadsfx_loadchn
	RTS

music_loadsfx_loadchn:
	LDA sq1_flags+mus_sfxbase,X	; check the priority flag
	AND #$20
	BNE music_loadsfx_skipchn	; if it's set, don't init the channel
	LDA (mus_ptr),Y
	CMP #$00
	BEQ music_loadsfx_skipchn

	STA sq1_ptrH+mus_sfxbase,X
	DEY
	LDA (mus_ptr),Y
	DEY
	STA sq1_ptr+mus_sfxbase,X
	LDA sq1_flags,X
	ORA #$80
	STA sq1_flags,X

	LDA mus_scratch1		; this will either contain 00 or 20, depending on bit 7 of the track
	STA sq1_flags+mus_sfxbase,X
	LDY #chn_proplen-3
	LDA #$00
music_loadsfx_initchn:
	INX
	DEY
	STA sq1+mus_sfxbase+2,X
	BNE music_loadsfx_initchn
music_loadsfx_skipchn:
	RTS

;;;;;;;;;;;;;;;
;;  stopsfx  ;;
;;;;;;;;;;;;;;;
;; This will set the "ended" flag for all of the sfx channels.
;; The next run of the sfx code will clean up as necessary, and
;; this will free up priority sfx so normal sfx can play. You can
;; load a sound effect immediately after calling this, if you want.
music_stopsfx:
	LDA #$40
	STA sq1_flags+mus_sfxbase
	STA sq1_flags+sq2base+mus_sfxbase
	STA sq1_flags+tribase+mus_sfxbase
	STA sq1_flags+nsebase+mus_sfxbase
	RTS

;;;;;;;;;;;;
;;  play  ;;
;;;;;;;;;;;;
music_play:
	CLC
	LDA mus_tempocnt
	ADC mus_tempo
	STA mus_tempocnt
	BCS music_runsong_dontexit
	LDA mus_songflags
	AND #$7F
	STA mus_songflags
	JSR music_update_envelopes
	JSR music_dosfx
	RTS
music_runsong_dontexit:
	LDA mus_songflags
	ORA #$80
	STA mus_songflags
	LDA #$00
	STA mus_curchn
	TAX
	JSR music_runchannel
	LDA #$04
	STA mus_curchn
	LDX #sq2base
	JSR music_runchannel
	LDA #$08
	STA mus_curchn
	LDX #tribase
	JSR music_runchannel
	LDA #$0C
	STA mus_curchn
	LDX #nsebase
	JSR music_runchannel
	JSR music_update_envelopes
	JSR music_dosfx
	RTS

;;;;;;;;;;;;;;
;;  do sfx  ;;
;;;;;;;;;;;;;;
music_dosfx:
	LDA #$00
	STA mus_curchn
	LDX #mus_sfxbase
	JSR music_dosfx_runchannel
 LDA #$04
 STA mus_curchn
 LDX #sq2base+mus_sfxbase
 JSR music_dosfx_runchannel
 LDA #$08
 STA mus_curchn
 LDX #tribase+mus_sfxbase
 JSR music_dosfx_runchannel
 LDA #$0C
 STA mus_curchn
 LDX #nsebase+mus_sfxbase
 JSR music_dosfx_runchannel
 JSR music_sfx_envelopes
 RTS

music_dosfx_runchannel:
 LDA sq1_flags,X
 AND #$40
 BEQ music_dosfx_runchannel_notended
 LDA #$00
 STA sq1_flags,X
 STA sq1_ptrH,X
 TXA
 SEC
 SBC #mus_sfxbase
 TAX
 LDA sq1_flags,X
 AND #$7F
 STA sq1_flags,X
 LDY sq1_periodH,X
 BMI music_dosfx_runchannel_dontrestart
 LDA sq1_periodL,X
 LDX mus_curchn
 STA sq1_r2,X
 TYA
 STA sq1_r3,X
 LDA #$F0
 STA sq1_r0,X
 RTS
music_dosfx_runchannel_dontrestart:
 LDX mus_curchn
 LDA #$00
 STA sq1_r2,X
 STA sq1_r3,X
 LDA #$F0
 STA sq1_r0,X
 RTS
music_dosfx_runchannel_notended:
 JSR music_runchannel
 RTS

music_sfx_envelopes:
 LDA #$00
 STA mus_curchn
 LDX #mus_sfxbase
 JSR music_run_sfx_envelope
 JSR music_dopitchbend
 LDA #$04
 STA mus_curchn
 LDX #mus_sfxbase + sq2base  ; EDITED
 JSR music_run_sfx_envelope
 JSR music_dopitchbend
 LDA #$08
 STA mus_curchn
 LDX #mus_sfxbase + tribase  ; EDITED
 JSR music_run_tri_envelope
 JSR music_dopitchbend
 LDA #$FF
 STA tri_r0
 LDA #$0C
 STA mus_curchn
 LDX #mus_sfxbase + nsebase  ; EDITED
 JSR music_run_sfx_envelope
 JSR music_dopitchbend
 RTS

music_run_sfx_envelope:
 LDA sq1_ptrH,X			; if the MSB of the channel pointer is 00, then
 BEQ music_run_sfx_envelope_exit	; skip this channel (music data should never
 LDA sq1_flags,X
 AND #$10
 BEQ music_run_sfx_envelope_notmute
 LDA #$00
 JMP music_run_envelope_write
music_run_sfx_envelope_notmute:
 LDA sq1_env,X
 ASL
 TAY
 LDA sfxenvelopes,Y
 STA mus_ptr
 LDA sfxenvelopes+1,Y
 STA mus_ptrH
 JMP music_run_envelope_pointerloaded
music_run_sfx_envelope_exit:
 RTS

;;;;;;;;;;;;;;;;;
;;  envelopes  ;;
;;;;;;;;;;;;;;;;;
music_update_envelopes:
 LDA #$00
 STA mus_curchn
 TAX
 JSR music_run_envelope
 JSR music_dopitchbend
 LDA #$04
 STA mus_curchn
 LDX #sq2base
 JSR music_run_envelope
 JSR music_dopitchbend
 LDA #$08
 STA mus_curchn
 LDX #tribase
 JSR music_run_tri_envelope
 JSR music_dopitchbend
 LDA #$FF
 STA tri_r0
 LDA #$0C
 STA mus_curchn
 LDX #nsebase
 JSR music_run_envelope
 JSR music_dopitchbend
 RTS

music_run_tri_envelope:
 LDA sq1_flags,X		; If the channel is muted, still update the envelope
 BMI music_run_tri_envelope_dontwrite	; but there's no need to calculate and write
 AND #$10
 BEQ music_run_tri_envelope_notmute
 LDA #$0B
 STA $4015
 LDA #$0F
 STA $4015
 LDA sq1_flags,X
 AND #$EF
 STA sq1_flags,X
 RTS
music_run_tri_envelope_notmute:
; LDA #$FF
; STA tri_r0
music_run_tri_envelope_dontwrite:
 RTS

music_run_envelope:
; TXA
; ASL
; ASL
; ASL
; ASL
; TAX
 LDA sq1_ptrH,X			; if the MSB of the channel pointer is 00, then
 BEQ music_run_envelope_exit	; skip this channel (music data should never
 LDA sq1_flags,X
 AND #$10
 BEQ music_run_envelope_notmute
 LDA #$00
 JMP music_run_envelope_write
music_run_envelope_notmute:
 LDA sq1_env,X
 ASL
 TAY
 LDA envelopes,Y
 STA mus_ptr
 LDA envelopes+1,Y
 STA mus_ptrH
music_run_envelope_pointerloaded:
music_run_envelope_reread:
 LDY sq1_envpos,X
 LDA (mus_ptr),Y
 CMP #$FF
 BEQ music_run_envelope_exit
music_run_envelope_write:
 PHA
 AND #$30
 BNE music_run_envelope_command
 LDA sq1_flags,X		; If the channel is muted, still update the envelope
 BMI music_run_envelope_dontwrite	; but there's no need to calculate and write

 PLA

;; Volume shift
 PHA
 AND #$F0
 ORA #$30
 STA mus_scratch1
 PLA
 AND #$0F
 SEC
 SBC sq1_volume,X
 BPL music_run_envelope_volume_noclip
 LDA #$00
music_run_envelope_volume_noclip:
 ORA mus_scratch1

 INC sq1_envpos,X
 LDY mus_curchn
 STA sq1_r0,Y
music_run_envelope_exit:
 RTS
music_run_envelope_dontwrite:
 PLA
 INC sq1_envpos,X
 RTS
music_run_envelope_command:
 PLA
 CMP #$10				; Jump to position XX
 BNE music_run_envelope_command_not10
 INY
 LDA (mus_ptr),Y
 STA sq1_envpos,X
 JMP music_run_envelope_reread 
music_run_envelope_command_not10:
 RTS

;;;;;;;;;;;;;;;;;;
;;  runchannel  ;;
;;;;;;;;;;;;;;;;;;
;; X should be loaded with the offset (in music ram) at which the track we're
;; working with is stored
music_runchannel:
; TXA
; ASL
; ASL
; ASL
; ASL
; TAX
 LDA sq1_notelen,X
 BNE music_runchannel_decnotelen
 LDA sq1_ptr,X
 STA mus_ptr
 LDA sq1_ptrH,X			; if the MSB of the channel pointer is 00, then
 BEQ music_runchannel_skipchannel	; skip this channel (music data should never
 STA mus_ptrH			; be in zeropage, so this is how you disable a channel)
 JSR music_readnote
; A new note would be played here. Reset all of the envelopes and such, the period
; to be used is stored in mus_scratch1 (r2) and mus_scratch2 (r3)
 BIT mus_scratch2
 BMI music_runchannel_dontwrite
 LDA #$00
 STA sq1_envpos,X

 LDA sq1_flags,X		; If the channel is muted, don't write to the registers
 BMI music_runchannel_dontwrite	; but the track still needs to be updated.
; TXA
; LSR
; LSR
; TAX
 LDX mus_curchn
 LDA mus_scratch1
 STA sq1_r2,X
 LDA mus_scratch2
 STA sq1_r3,X
music_runchannel_dontwrite:
 RTS
music_runchannel_decnotelen:
 LDA sq1_notelen,X
 DEC sq1_notelen,X
 CMP sq1_precut,X
 BEQ music_do_precut
; JSR music_dopitchbend
music_runchannel_skipchannel:
 RTS
music_do_precut:
 LDA sq1_flags,X
 BMI music_do_precut_end
; TXA
; LSR
; LSR
; TAX
 LDA sq1_flags,X
 ORA #$10
 STA sq1_flags,X
 LDA #$80
 STA sq1_periodH,X
 LDX mus_curchn
; LDA #$00
; STA sq1_r2,X
; STA sq1_r3,X
music_do_precut_end:
 RTS

;;;;;;;;;;;;;;;;;;;
;;  dopitchbend  ;;
;;;;;;;;;;;;;;;;;;;
music_dopitchbend:
 LDA sq1_flags,X
 AND #$08			; if this is true, we want tempo-based bends
 BEQ music_dopitchbend_proceed
 BIT mus_songflags
 BMI music_dopitchbend_proceed
 RTS				; If we want tempo-based, and this isn't on tempo, exit
music_dopitchbend_proceed:
 LDA sq1_bend,X
 BNE music_dopitchbend_proceed2
 RTS				; If no pitch bend, exit
music_dopitchbend_proceed2:
 LDA sq1_periodH,X
 AND #%11111000
 BEQ music_dopitchbend_proceed3
 RTS				; if pitch is out of range, exit
music_dopitchbend_proceed3:
 LDA sq1_bend,X
 BMI music_dopitchbend_down
 CLC
 ADC sq1_periodL,X
 STA sq1_periodL,X
; LDA sq1_periodH,X
; PHP
; ADC #$00
; PLP
; STA sq1_periodH,X
 BCC music_dopitchbend_up_carrycleared
 INC sq1_periodH,X
music_dopitchbend_up_carrycleared:
 JMP music_dopitchbend_doregs
music_dopitchbend_down:
 CLC
 ADC sq1_periodL,X
 STA sq1_periodL,X
; LDA sq1_periodH,X
; PHP
; SBC #$00
; PLP
; STA sq1_periodH,X
 BCS music_dopitchbend_down_carrycleared
 DEC sq1_periodH,X
music_dopitchbend_down_carrycleared:
 BCC music_dopitchbend_setcarry
 CLC
 JMP music_dopitchbend_doregs
music_dopitchbend_setcarry:
 SEC
music_dopitchbend_doregs:
 BCC music_dopitchbend_skipR3
 LDA sq1_periodH,X
 STA mus_scratch2
 JMP music_dopitchbend_doR2
music_dopitchbend_skipR3:
 LDA #$80
 STA mus_scratch2
music_dopitchbend_doR2:
 LDA sq1_periodL,X
 STA mus_scratch1
 LDA sq1_flags,X
 BMI music_dopitchbend_skip
 LDX mus_curchn
 LDA mus_scratch1
 STA sq1_r2,X
 LDA mus_scratch2
 AND #%01111000
 BNE music_dopitchbend_mute
 LDA mus_scratch2
 BMI music_dopitchbend_skip
 STA sq1_r3,X
music_dopitchbend_skip:
 RTS
music_dopitchbend_mute:
 LDA #$00
 STA sq1_r2,X
 STA sq1_r3,X
 RTS

;;;;;;;;;;;;;;;;
;;  readnote  ;;
;;;;;;;;;;;;;;;;
music_readnote:
 LDA sq1_flags,X
 AND #$EF
 STA sq1_flags,X
 LDA mus_curchn
 CMP #$0C			; Is this the noise channel?
 BNE music_notnoise
 JMP music_donoise		; Go to noise handling routine
music_notnoise:
 LDY #$00
 LDA (mus_ptr),Y		; Read a note
; BNE music_readnote_notrest
; JMP music_readnote_isrest
music_readnote_notrest:
 TAY				; Save a copy in Y
 LSR				; Extract the note number
 LSR
 LSR
 LSR
 CMP #$0C			; If the note is $C or above, it's a command
 BCS music_parse_command
 PHA				; Otherwise, store it on the stack
 TYA				; Get the copy of the note byte back
 AND #$0F			; Extract octave
 STA mus_scratch3		; Store it in scratch3
 PLA				; Get the note back
 ASL				; Double it
 TAY				; Put it in Y
 LDA music_notetable+1,Y	; Get the note's period MSB
 STA mus_scratch2		; Store it in scratch2
 LDA music_notetable,Y		; Get the note's period LSB
 STA mus_scratch1		; Store it in scratch1

; Add detune here
 LDA sq1_detune,X
 BMI music_readnote_detune_isnegative
 SEC
 LDA mus_scratch1
 SBC sq1_detune,X
 STA mus_scratch1
 LDA mus_scratch2
 SBC #$00
 STA mus_scratch2
 JMP music_readnote_detune_end
music_readnote_detune_isnegative:
; LDA sq1_detune,X
; EOR #$FF
; STA sq1_detune,X
 SEC
 LDA mus_scratch1
 SBC sq1_detune,X
 STA mus_scratch1
 LDA mus_scratch2
 SBC #$FF
 STA mus_scratch2
; LDA sq1_detune,X
; EOR #$FF
; STA sq1_detune,X
music_readnote_detune_end:
 LDY mus_scratch3		; Get octave back and put it in Y
; TAY				; put it in Y
; INY				; increment Y
 JMP music_octave_shift
music_donoise:
 LDA #$80
 STA mus_scratch2
 LDY #$00
 LDA (mus_ptr),Y		; Read a note
 TAY
 CMP #$C0			; If the note is $C or above, it's a command
 BCS music_parse_command
 STA mus_scratch1
 STA sq1_periodL,X
 LDA #$00
 STA mus_scratch2
 STA sq1_periodH,X
 LDA #$10
 BIT mus_scratch1
 BEQ music_donoise_notlooped
 LDA mus_scratch1
 AND #$0F
 ORA #$80
 STA mus_scratch1
 STA sq1_periodL,X
music_donoise_notlooped:
 JMP music_readduration

;;;;;;;;;;;;;;;;;;;;;
;;  parse command  ;;
;;;;;;;;;;;;;;;;;;;;;
music_parse_command:
 TYA				; get the copy back from Y
 CMP #$C8			; Rest, plays a silent note
 BNE music_parse_notC8
 LDA #$80
 STA mus_scratch2
 STA sq1_periodH,X
 LDA sq1_flags,X
 ORA #$10
 STA sq1_flags,X
 JMP music_readduration
music_parse_notC8:
 CMP #$C0			; "do nothing" command, just extends the note
 BNE music_parse_notC0
 LDA #$80
 STA mus_scratch2
 JMP music_readduration
music_parse_notC0:
 CMP #$C1			; Precut, cuts the note xx cycles before the next note
 BNE music_parse_notC1
 LDY #$01
 LDA (mus_ptr),Y
 STA sq1_precut,X
 LDA #$02
 STA mus_scratch3
 JMP music_increment_ptr_and_reread
music_parse_notC1:
 CMP #$C2			; Set envelope
 BNE music_parse_notC2
 LDY #$01
 LDA (mus_ptr),Y
 STA sq1_env,X
 LDA #$02
 STA mus_scratch3
 JMP music_increment_ptr_and_reread
music_parse_notC2:
 CMP #$C3			; Loop to yyxx, zz times
 BNE music_parse_notC3
 LDY #$01
 LDA (mus_ptr),Y
 PHA
 INY
 LDA (mus_ptr),Y
 PHA
 LDA sq1_loopcount,X
 BNE music_parse_C3_dontreset
 INY
 LDA (mus_ptr),Y
 STA sq1_loopcount,X
 JMP music_parse_C3_repeat
music_parse_C3_dontreset:
 DEC sq1_loopcount,X
 CMP #$01
 BNE music_parse_C3_repeat
 PLA
 PLA
 LDA #$04
 STA mus_scratch3
 JMP music_increment_ptr_and_reread
music_parse_C3_repeat:
 PLA
 STA mus_ptrH
 PLA
 STA mus_ptr
 JMP music_readnote
music_parse_notC3:
 CMP #$C4			; Jump to yyxx
 BNE music_parse_notC4
 LDY #$01
 LDA (mus_ptr),Y
 PHA
 INY
 LDA (mus_ptr),Y
 STA mus_ptrH
 PLA
 STA mus_ptr
 JMP music_readnote
music_parse_notC4:
 CMP #$C5			; Set detune
 BNE music_parse_notC5
 LDY #$01
 LDA (mus_ptr),Y
 STA sq1_detune,X
 LDA #$02
 STA mus_scratch3
 JMP music_increment_ptr_and_reread
music_parse_notC5:
 CMP #$C6			; Set volume shift
 BNE music_parse_notC6
 LDY #$01
 LDA (mus_ptr),Y
 STA sq1_volume,X
 LDA #$02
 STA mus_scratch3
 JMP music_increment_ptr_and_reread
music_parse_notC6:
 CMP #$C7			; Set pitch bend
 BNE music_parse_notC7
 LDY #$01
 LDA (mus_ptr),Y
 STA sq1_bend,X
 LDA sq1_flags,X
 ORA #$08
 STA sq1_flags,X
 LDA #$02
 STA mus_scratch3
 JMP music_increment_ptr_and_reread
music_parse_notC7:
 CMP #$C9			; Set pitch bend (tempo independent)
 BNE music_parse_notC9
 LDY #$01
 LDA (mus_ptr),Y
 STA sq1_bend,X
 LDA sq1_flags,X
 AND #$F7
 STA sq1_flags,X
 LDA #$02
 STA mus_scratch3
 JMP music_increment_ptr_and_reread
music_parse_notC9:
 LDA #$00			; Anything else just halts the track.
 STA sq1_ptr,X
 STA sq1_ptrH,X
 STA mus_ptr
 STA mus_ptrH
 STA mus_scratch1
; LDA #$80
 STA mus_scratch2
 LDA sq1_flags,X
 ORA #$40
 STA sq1_flags,X		; Set the "track ended" flag (used for sfx)
 LDA #$80
 STA sq1_periodH,X
 LDY mus_curchn
 LDA #$F0
 STA sq1_r0,Y
 RTS
; LDA #$00
; STA mus_scratch3
; JMP music_increment_ptr

;;;;;;;;;;;;;;;;;;;;
;;  note is rest  ;;
;;;;;;;;;;;;;;;;;;;;
;music_readnote_isrest:
; LDA #$00
; STA mus_scratch1
; STA mus_scratch2
; LDA #$80
; STA sq1_periodH,X
; JMP music_readduration

;;;;;;;;;;;;;;;;;;;;
;;  shift octave  ;;
;;;;;;;;;;;;;;;;;;;;
music_octave_shift:
 BEQ music_octave_shift_end	; if it's zero, exit this loop
music_octave_shift_loop:
 CLC

 ROR mus_scratch2
 ROR mus_scratch1

 DEY				; decrement Y
 BNE music_octave_shift_loop		; loop
music_octave_shift_end:

 LDA mus_scratch1
 SBC #$00
 STA mus_scratch1
 STA sq1_periodL,X
 LDA mus_scratch2
 SBC #$00
 STA mus_scratch2
 STA sq1_periodH,X

; At this point, we have the pitch, now we need to read the duration.
music_readduration:
 LDY #$01
 LDA (mus_ptr),Y		; Read the duration
 SEC
 SBC #$01
 STA sq1_notelen,X		; Store it in the proper place for the channel
 LDA #$02
 STA mus_scratch3
; Now increment the channel's track pointer, and update it in the note properties.
music_increment_ptr:
 CLC
 LDA mus_ptr
 ADC mus_scratch3
 STA sq1_ptr,X
 LDA mus_ptrH
 ADC #$00
 STA sq1_ptrH,X
 RTS

music_increment_ptr_and_reread:
 CLC
 LDA mus_ptr
 ADC mus_scratch3
 STA mus_ptr
 LDA mus_ptrH
 ADC #$00
 STA mus_ptrH
 JMP music_readnote
