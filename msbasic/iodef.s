; IO Memory mapping 

IOSTART     = $0300                 ; Start Address for IO Ports 0300 - 03FF

; ACIA Addresses

ACIA0_BASE   = IOSTART + $00
ACIA0_STATUS = ACIA0_BASE           ; ACIA1 Control and Status Reg
ACIA0_CTRL   = ACIA0_BASE           ;
ACIA0_DATA   = ACIA0_BASE+1         ; ACIA1 Data 

ACIA1_BASE   = IOSTART + $02
ACIA1_STATUS = ACIA1_BASE           ; ACIA2 Control and Status Reg
ACIA1_CTRL   = ACIA1_BASE           ;
ACIA1_DATA   = ACIA1_BASE+1         ; ACIA2 Data 


; PIA Addresses
PIA0_BASE    = IOSTART + $04        ; PIA Base Address
PIA0_INTA    = PIA0_BASE            ; Peripheral InterFace A / Data Direction Register A
PIA0_CTRLA   = PIA0_BASE + $01      ; Control Register A
PIA0_INTB    = PIA0_BASE + $02      ; Peripheral Interface B / Data Direction Register B
PIA0_CTRLB   = PIA0_BASE + $03      ; Control Register B

PIA1_BASE    = IOSTART + $08        ; PIA Base Address
PIA1_INTA    = PIA1_BASE            ; Peripheral InterFace A / Data Direction Register A
PIA1_CTRLA   = PIA1_BASE + $01      ; Control Register A
PIA1_INTB    = PIA1_BASE + $02      ; Peripheral Interface B / Data Direction Register B
PIA1_CTRLB   = PIA1_BASE + $03      ; Control Register B

; Ouput Card 1 Addresses
OUT_1       = IOSTART + $0C         ; Output Card 1 Base Address - Address line A0 ignored

; Output Card 2 Addresses
OUT_2       = IOSTART + $0E         ; Output Card 2 Base Address - Address line A0 ignored

; VIA Addresses
VIA_BASE    = IOSTART + $10         ; VIA Base Address
VIA_PORTB   = VIA_BASE + $0         ; ORB/IRB
VIA_PORTA   = VIA_BASE + $01        ; ORA/IRA
VIA_DDRB    = VIA_BASE + $02        ; Data Direction Register B
VIA_DDRA    = VIA_BASE + $03        ; Data Direction Register A
VIA_T1CL    = VIA_BASE + $04        ; Write T1 Low-Order Latches, Read T1 Low-Order Counter
VIA_T1CH    = VIA_BASE + $05        ; T1 High-Order Counter
VIA_T1LL    = VIA_BASE + $06        ; T1 Low-Order Latches
VIA_T1LH    = VIA_BASE + $07        ; T1 High-order Latches
VIA_T2CL    = VIA_BASE + $08        ; Write T2 Low-Order Latches, Read T2 Low-Order Counter
VIA_T2CH    = VIA_BASE + $09        ; T2 High-Order Counter
VIA_SR      = VIA_BASE + $0A        ; Shift Register
VIA_ACR     = VIA_BASE + $0B        ; Auxiliary Control Register
VIA_PCR     = VIA_BASE + $0C        ; Peripheral Control Register
VIA_IFR     = VIA_BASE + $0D        ; Interupt Flag Register
VIA_IER     = VIA_BASE + $0E        ; Interupt Enable Register
VIA_REGA2   = VIA_BASE + $0F        ; ORA/IRA except not "Handshake"



; LCD Control Bits
RS          = $01    ; Register Select bit (PA0)
RW          = $02    ; Read/Write bit (PA1)
ENB         = $04    ; Enable bit (PA2)

; LCD Commands
LCD_CLEAR      = $01
LCD_FUNCTION   = $38  ; 8-bit, 2-line, 5x8 font
LCD_DISPLAY    = $0C  ; Display ON, Cursor OFF
LCD_ENTRY_MODE = $06  ; Increment cursor, no shift