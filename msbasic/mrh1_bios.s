.setcpu "65c02"
.debuginfo
.segment "BIOS"

; Zero-page pointer defines
ZP_TMP_ADDR   = $22                 ; 2 x byte tempary address store in ZP
ZP_ACIA_PTR   = $20
ZP_SELECTED_ACIA = $1F

STR_PTR = ZP_TMP_ADDR               ; STR_PTR = $00xx / $00xx+1, set by caller - used for passing a value into the message routine
ACIA_PTR = ZP_ACIA_PTR
ACIA_SELECT = ZP_SELECTED_ACIA;
TMP_LO         = $FE
TMP_HI         = $FF
TMP_PTR        = $FE
TMP_PTR_H      = $FF

.include "iodef.s"

.zeropage
                .org ZP_START0
READ_PTR:       .res 1
WRITE_PTR:      .res 1

.segment "INPUT_BUFFER"
INPUT_BUFFER:   .res $0100

.segment "BIOS"

RESET:

; -------------------------------------------------
; Reset 
; -------------------------------------------------
; Does:
;   - SEI, CLD
;   - Initialise stack pointer to $FF
;   - Clear zero page ($0000–$00FF)
;   - Then jump via the reset vector at $FFFC/$FFFD
;
; Notes:
;   - Does NOT touch $0300–$03FF (your IO space)
;   - Does NOT actually reset hardware / peripherals
;   - RAM outside zero page is left as-is
; -------------------------------------------------

        SEI             ; disable IRQs while we tidy up
        CLD             ; clear decimal mode

        ; --- initialise stack pointer (page 1 @ $01FF) ---
        LDX #$FF
        TXS

; Initilise ACIA
        LDA #%00000011
        STA ACIA_CTRL       ; store to base

        LDA #%00010110         ; (you had %00010110, assuming this was meant to be %00010110)
        STA ACIA_CTRL      ; store to base


; ------------------------------------------------------------
; Show menu and wait for W or B
; ------------------------------------------------------------
ShowMenu:
        LDA #<BIOS_STARTUP_TXT   ; Load low byte of string address
        STA TMP_PTR
        LDA #>BIOS_STARTUP_TXT   ; Load high byte of string address
        STA TMP_PTR_H

        JSR BIOS_PrintString        ; Print the string
        ; Print: "Press W for WOZMon, B for BASIC"

; ------------------------------------------------------------
; Wait for key press and branch accordingly
; ------------------------------------------------------------
WaitKey:
        JSR BIOS_CHARIN_NE     ; returns ASCII in A

        CMP #'W'
        BEQ StartWOZ

        CMP #'w'            ; lower-case accepted
        BEQ StartWOZ

        CMP #'B'
        BEQ StartBASIC

        CMP #'b'
        BEQ StartBASIC

        BRA WaitKey         ; ignore anything else

; ------------------------------------------------------------
StartWOZ:
        JSR WOZMON
        RTS

StartBASIC:
        JSR BASIC
        RTS

MONCOUT:
BIOS_CHROUT:
        PHA                    ; keep copy of the byte
@txdelay:
        LDA ACIA0_STATUS
        AND #%00000010         ; mask TDRE (bit 1)
        BEQ @txdelay            ; 0 = not ready yet
        PLA                    ; restore byte
        STA ACIA0_DATA         ; write to TX data register
        RTS

BIOS_CHARIN_NE:
        LDA ACIA0_STATUS        ; Read ACIA status
        AND #$01               ; mask RDRF (bit 0)
        BEQ @no_keypressed     ; 0 = no byte yet
        LDA ACIA0_DATA          ; get received byte from ACIA Data
        SEC
        RTS
@no_keypressed:
        CLC
        RTS

MONRDKEY:
BIOS_CHRIN:
        LDA ACIA0_STATUS        ; Read ACIA status
        AND #$01               ; mask RDRF (bit 0)
        BEQ @no_keypressed     ; 0 = no byte yet
        LDA ACIA0_DATA          ; get received byte from ACIA Data
        JSR BIOS_CHROUT
        SEC
        RTS
@no_keypressed:
        CLC
        RTS

        ; Initialize the circular input buffer
; Modifies: flags, A
INIT_BUFFER:
                lda READ_PTR
                sta WRITE_PTR
;                lda #$01
;                sta DDRA
;                lda #$fe
;                and PORTA
;                sta PORTA
                rts

; Write a character (from the A register) to the circular input buffer
; Modifies: flags, X
WRITE_BUFFER:
                ldx WRITE_PTR
                sta INPUT_BUFFER,x
                inc WRITE_PTR
                rts

; Read a character from the circular input buffer and put it in the A register
; Modifies: flags, A, X
READ_BUFFER:
                ldx READ_PTR
                lda INPUT_BUFFER,x
                inc READ_PTR
                rts

; Return (in A) the number of unread bytes in the circular input buffer
; Modifies: flags, A
BUFFER_SIZE:
                lda WRITE_PTR
                sec
                sbc READ_PTR
                rts

BIOS_ConvertToUpper:
    CMP #'a'          ; less than 'a'? (A < $61)
    BMI BIOS_Done          ; yes → not lowercase
    CMP #'z'+1        ; A >= 'z'+1 ? (A > $7A)
    BPL BIOS_Done          ; yes → not lowercase
    AND #%11011111    ; clear bit 5 → convert to uppercase
BIOS_Done:
    RTS


BIOS_LOAD:   
        RTS

BIOS_SAVE:
        RTS

BIOS_ISCNTC:
        RTS


BIOS_PrintString:
        LDY #0

@Loop:
        LDA (TMP_PTR),Y      ; Get character from string
        BEQ @Done            ; If zero, end of string

        JSR BIOS_CHROUT      ; Output char in A

        INY                  ; Next character
        BNE @Loop            ; If Y didn't wrap, stay on same page

        INC TMP_PTR+1        ; Y wrapped: bump high byte of pointer
        BRA @Loop

@Done:
        RTS


; ------------------------------------------------------------
; Messages 
; ------------------------------------------------------------

BIOS_STARTUP_TXT:
    .BYTE $0D, $0A, "MRH1 -  HomeBrew 65C02 BIOS V1.6", $0D, $0A, "Matthew Reeves-Hairs - Dec 2025" ; null-terminated string

MenuText:
        .byte $0D, $0A, $0A, "Press W for WOZMon, B for BASIC", $0D, $0A,0

WOZMON_STR:
    .BYTE "WOZMON V1.1", $0D, $0A, $0A  ; null-terminated string   
WOZMON_HELP_STR:
    .BYTE $08,"xxxx - examine address xxxxx", $0D, $0A
    .BYTE $08,"xxxx.yyyy - examine block", $0D, $0A
    .BYTE $08,"xxxx:vv or xxxx:vv v1 v2 v3 - deposits vv into address xxxx and V1, v2 etc into next addresses", $0D, $0A
    .BYTE $08,"xxxx R - runs code at address xxxx", $0D, $0A,0

.segment "WOZMON"
.include "mrh1_wozmon.s"

.segment "RESETVEC"
                .word   $0F00          ; NMI vector
                .word   RESET          ; RESET vector
                .word   $0000          ; IRQ vector
