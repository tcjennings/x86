; TSOUND.NASM
;
; A program to flip bits 5,6 at port 0x61 
;
; Useful in an IBM PCjr where IO port 0x61 is Port B (PB) of the PPI 8255-I.
; PB5 and PB6 control SPKR Switch 0 and SPKR Switch 1, respectively.
; When both bits are ON, the sound input is steered to the SN76496 chip.
;
; Manually setting these bits grants the PCjr compatibility with Tandy 1000
; software that utilizes the SN76496 sound chip but doesn't know or care
; to turn it on in a PCjr.
;
; Running the program a second time flips the bits the other way, steering
; the sound back to the default 8253-5 Timer source.
;
; Other possible states for these bits:
;
;  00 8253-5 Timer
;  01 Cassette Audio Input
;  10 I/O Channel Audio In (Sidecar)
;  11 SN76496section .text
;
;  Output
;  ------
;  This program reports the current status of the SN76496 audio selection
;  as either "on" or "off" before it terminates.
;
;  This program does not set an exit code.
;
;  Assembling
;  ----------
;  Assemble this file with `nasm -fbin -o tsound.com tsound.nasm
;
;  References
;  ----------
;  IBM PCjr Technical Reference, pp 2-29 - 2-32

org 0x100
	mov AH, 0x9
	mov DX, preamble
	int 0x21         ;print output string preamble
	in AL, 0x61      ;read port to AL
	xor AL, 0x60 	 ;toggle bits 5,6
	out 0x61, AL	 ;write AL to port
	and AL, 0x60	 ;determine current state
	jne was_off	 ;NZ means bits are now on
	mov DX, off	 ;point to "Off"
	jmp done
was_off:
	mov DX, on	 ;point to "On"
done:
	mov AH, 0x9      ;print status string
	int 0x21
	int 0x20	 ;terminate

section .data align=1
preamble: db 'SN76496:', '$'
off: db 'off', 13, 10, '$'
on: db 'on', 13, 10, '$'

