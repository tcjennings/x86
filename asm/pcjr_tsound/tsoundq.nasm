; TSOUNDQ.NASM
; 
; A minimal program to flip bits 5,6 at port 0x61
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
;  This program does not set an exit code.
;
;  Assembling
;  ----------
;  Assemble this file with `nasm -fbin -o tsoundq.com tsoundq.nasm
;
;  References
;  ----------
;  IBM PCjr Technical Reference, pp 2-29 - 2-32

section .text
org 0x100
	in AL, 0x61	;read port to AL
	xor AL, 0x60 	;toggle bits 5,6
	out 0x61, AL	;write AL to port
	int 0x20	;terminate

