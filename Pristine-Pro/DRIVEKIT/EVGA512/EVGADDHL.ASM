;**********************************************************************
;
; EVGADDHL.ASM -- Draw a horizontal line 2 bytes at a time (color is
;                 2 bytes). Assumes that X and Width are even. Also
;                 assumes that ES is set the PHAR_SEG. Original VRAM
;                 code required a check to see if a bank split in the
;                 middle of a line. Using the 512x480 mode on the EVGA,
;                 that's not a problem. The Split code has been commented
;                 out, instead of deleted, in case someone wants to
;                 add EVGA support for modes that might have a bank
;                 switch occur mid-line.
;
;
; Modified by Panacea Inc.
;
; Panacea Inc.
; 50 Nashua Road, Suite 305
; Londonderry, New Hampshire, 03053-3444
; (603) 437-5022
;
;
;Revision History:
;
;When     Who   What
;======== ===   =======================================================
;09/13/90 JBR   Start of development.
;
;**********************************************************************
	include evga.i

_text	segment	para public use32 'code'
	assume cs:CGROUP,ds:DGROUP


	public _evga_double_hline
_evga_double_hline proc near
vddp struc
	vdd_ebp	dd ?
	vdd_ret dd ?
	vdd_v	dd ?
	vdd_color	dd ?
	vdd_x	dd ?
	vdd_y	dd ?
	vdd_width dd ?
vddp ends
	push ebp
	mov ebp,esp
	push esi
	push edi

	;get ytable pointer for this line
	mov esi,[ebp].vdd_v
	mov esi,[esi].vs_ytable
	mov eax,[ebp].vdd_y
	shl eax,3
	add esi,eax
;
; COMMENTED OUT - SEE NOTE IN HEADER
;
;	mov ax,[esi].yta_split	;get split...
;	test ax,ax
;	jnz  splitit

nosplit_left:
	mov edi,[esi].yta_address
	add edi,[ebp].vdd_x
	mov cx,[esi].yta_bank	;get bank
	setbank
	mov eax,[ebp].vdd_color
	mov ecx,[ebp].vdd_width
	shr ecx,1
	rep stosw

dhli_done:
	pop edi
	pop esi
	pop ebp
	ret

;
; COMMENTED OUT - SEE NOTE IN HEADER
;
;nosplit_right:
;	mov edi,[esi].yta_address
;	add edi,[ebp].vdd_x
;	sub edi,010000h
;	mov cx,[esi].yta_bank	;get bank
;	inc cx			;but we're the next one...
;	setbank
;	mov eax,[ebp].vdd_color
;	mov ecx,[ebp].vdd_width
;	shr ecx,1
;	rep stosw
;	jmp dhli_done
;
;splitit:	;here the line is split, but maybe this part of it isn't
;	movzx edx,ax	;sign extend split_at
;	mov eax,[ebp].vdd_x
;	cmp eax,edx		;if (x >= split_at) goto nosplit_right
;	jae nosplit_right	
;	add eax,[ebp].vdd_width
;	cmp eax,edx		;if (x+width < split_at) goto nosplit_left
;	jb nosplit_left
;
;;if made it here the segment is split.
;
;
;	;debugging...
;	;mov eax,120	;DEBUG
;	;mov [ebp].vdd_color,eax	;DEBUG
;
;	;do 1st half of segment
;	mov cx,[esi].yta_bank	;get bank
;	setbank
;	mov edi,[esi].yta_address
;	mov edx,[ebp].vdd_x
;	add edi,edx
;	movzx ecx,[esi].yta_split		;get split_at
;	sub ecx,edx
;	mov eax,[ebp].vdd_color
;	shr ecx,1
;	rep stosw
;	;do 2nd half of segment
;
;
;	mov cx,[esi].yta_bank	;get bank
;	inc cx
;	setbank
;	mov edi,[esi].yta_address
;	movzx edx,[esi].yta_split
;	add edi,edx
;	sub edi,010000h
;	mov ecx,[ebp].vdd_width
;	add ecx,[ebp].vdd_x
;	sub ecx,edx
;	mov eax,[ebp].vdd_color
;	shr ecx,1
;	rep stosw
;
;
;
;	jmp dhli_done

_evga_double_hline endp
_text	ends
	end
