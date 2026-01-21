;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler
; Version 4.5.0 #15242 (MINGW64)
;--------------------------------------------------------
	.module preemptive
	
	.optsdcc -mmcs51 --model-small
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _myTimer0Handler
	.globl _Bootstrap
	.globl _main
	.globl _CY
	.globl _AC
	.globl _F0
	.globl _RS1
	.globl _RS0
	.globl _OV
	.globl _F1
	.globl _P
	.globl _PS
	.globl _PT1
	.globl _PX1
	.globl _PT0
	.globl _PX0
	.globl _RD
	.globl _WR
	.globl _T1
	.globl _T0
	.globl _INT1
	.globl _INT0
	.globl _TXD
	.globl _RXD
	.globl _P3_7
	.globl _P3_6
	.globl _P3_5
	.globl _P3_4
	.globl _P3_3
	.globl _P3_2
	.globl _P3_1
	.globl _P3_0
	.globl _EA
	.globl _ES
	.globl _ET1
	.globl _EX1
	.globl _ET0
	.globl _EX0
	.globl _P2_7
	.globl _P2_6
	.globl _P2_5
	.globl _P2_4
	.globl _P2_3
	.globl _P2_2
	.globl _P2_1
	.globl _P2_0
	.globl _SM0
	.globl _SM1
	.globl _SM2
	.globl _REN
	.globl _TB8
	.globl _RB8
	.globl _TI
	.globl _RI
	.globl _P1_7
	.globl _P1_6
	.globl _P1_5
	.globl _P1_4
	.globl _P1_3
	.globl _P1_2
	.globl _P1_1
	.globl _P1_0
	.globl _TF1
	.globl _TR1
	.globl _TF0
	.globl _TR0
	.globl _IE1
	.globl _IT1
	.globl _IE0
	.globl _IT0
	.globl _P0_7
	.globl _P0_6
	.globl _P0_5
	.globl _P0_4
	.globl _P0_3
	.globl _P0_2
	.globl _P0_1
	.globl _P0_0
	.globl _B
	.globl _ACC
	.globl _PSW
	.globl _IP
	.globl _P3
	.globl _IE
	.globl _P2
	.globl _SBUF
	.globl _SCON
	.globl _P1
	.globl _TH1
	.globl _TH0
	.globl _TL1
	.globl _TL0
	.globl _TMOD
	.globl _TCON
	.globl _PCON
	.globl _DPH
	.globl _DPL
	.globl _SP
	.globl _P0
	.globl _next_prod
	.globl _new_thread
	.globl _curr_thread
	.globl _thread_mask
	.globl _SPthread_4
	.globl _SPthread_3
	.globl _SPthread_2
	.globl _SPthread_1
	.globl _ThreadCreate
	.globl _ThreadExit
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
	.area RSEG    (ABS,DATA)
	.org 0x0000
_P0	=	0x0080
_SP	=	0x0081
_DPL	=	0x0082
_DPH	=	0x0083
_PCON	=	0x0087
_TCON	=	0x0088
_TMOD	=	0x0089
_TL0	=	0x008a
_TL1	=	0x008b
_TH0	=	0x008c
_TH1	=	0x008d
_P1	=	0x0090
_SCON	=	0x0098
_SBUF	=	0x0099
_P2	=	0x00a0
_IE	=	0x00a8
_P3	=	0x00b0
_IP	=	0x00b8
_PSW	=	0x00d0
_ACC	=	0x00e0
_B	=	0x00f0
;--------------------------------------------------------
; special function bits
;--------------------------------------------------------
	.area RSEG    (ABS,DATA)
	.org 0x0000
_P0_0	=	0x0080
_P0_1	=	0x0081
_P0_2	=	0x0082
_P0_3	=	0x0083
_P0_4	=	0x0084
_P0_5	=	0x0085
_P0_6	=	0x0086
_P0_7	=	0x0087
_IT0	=	0x0088
_IE0	=	0x0089
_IT1	=	0x008a
_IE1	=	0x008b
_TR0	=	0x008c
_TF0	=	0x008d
_TR1	=	0x008e
_TF1	=	0x008f
_P1_0	=	0x0090
_P1_1	=	0x0091
_P1_2	=	0x0092
_P1_3	=	0x0093
_P1_4	=	0x0094
_P1_5	=	0x0095
_P1_6	=	0x0096
_P1_7	=	0x0097
_RI	=	0x0098
_TI	=	0x0099
_RB8	=	0x009a
_TB8	=	0x009b
_REN	=	0x009c
_SM2	=	0x009d
_SM1	=	0x009e
_SM0	=	0x009f
_P2_0	=	0x00a0
_P2_1	=	0x00a1
_P2_2	=	0x00a2
_P2_3	=	0x00a3
_P2_4	=	0x00a4
_P2_5	=	0x00a5
_P2_6	=	0x00a6
_P2_7	=	0x00a7
_EX0	=	0x00a8
_ET0	=	0x00a9
_EX1	=	0x00aa
_ET1	=	0x00ab
_ES	=	0x00ac
_EA	=	0x00af
_P3_0	=	0x00b0
_P3_1	=	0x00b1
_P3_2	=	0x00b2
_P3_3	=	0x00b3
_P3_4	=	0x00b4
_P3_5	=	0x00b5
_P3_6	=	0x00b6
_P3_7	=	0x00b7
_RXD	=	0x00b0
_TXD	=	0x00b1
_INT0	=	0x00b2
_INT1	=	0x00b3
_T0	=	0x00b4
_T1	=	0x00b5
_WR	=	0x00b6
_RD	=	0x00b7
_PX0	=	0x00b8
_PT0	=	0x00b9
_PX1	=	0x00ba
_PT1	=	0x00bb
_PS	=	0x00bc
_P	=	0x00d0
_F1	=	0x00d1
_OV	=	0x00d2
_RS0	=	0x00d3
_RS1	=	0x00d4
_F0	=	0x00d5
_AC	=	0x00d6
_CY	=	0x00d7
;--------------------------------------------------------
; overlayable register banks
;--------------------------------------------------------
	.area REG_BANK_0	(REL,OVR,DATA)
	.ds 8
;--------------------------------------------------------
; internal ram data
;--------------------------------------------------------
	.area DSEG    (DATA)
_SPthread_1	=	0x0030
_SPthread_2	=	0x0031
_SPthread_3	=	0x0032
_SPthread_4	=	0x0033
_thread_mask	=	0x002a
_curr_thread	=	0x0029
_new_thread	=	0x0020
_next_prod	=	0x0021
;--------------------------------------------------------
; overlayable items in internal ram
;--------------------------------------------------------
	.area	OSEG    (OVR,DATA)
_ThreadCreate_prevSP_10001_23	=	0x0024
;--------------------------------------------------------
; indirectly addressable internal ram data
;--------------------------------------------------------
	.area ISEG    (DATA)
;--------------------------------------------------------
; absolute internal ram data
;--------------------------------------------------------
	.area IABS    (ABS,DATA)
	.area IABS    (ABS,DATA)
;--------------------------------------------------------
; bit data
;--------------------------------------------------------
	.area BSEG    (BIT)
;--------------------------------------------------------
; paged external ram data
;--------------------------------------------------------
	.area PSEG    (PAG,XDATA)
;--------------------------------------------------------
; uninitialized external ram data
;--------------------------------------------------------
	.area XSEG    (XDATA)
;--------------------------------------------------------
; absolute external ram data
;--------------------------------------------------------
	.area XABS    (ABS,XDATA)
;--------------------------------------------------------
; initialized external ram data
;--------------------------------------------------------
	.area XISEG   (XDATA)
	.area HOME    (CODE)
	.area GSINIT0 (CODE)
	.area GSINIT1 (CODE)
	.area GSINIT2 (CODE)
	.area GSINIT3 (CODE)
	.area GSINIT4 (CODE)
	.area GSINIT5 (CODE)
	.area GSINIT  (CODE)
	.area GSFINAL (CODE)
	.area CSEG    (CODE)
;--------------------------------------------------------
; global & static initialisations
;--------------------------------------------------------
	.area HOME    (CODE)
	.area GSINIT  (CODE)
	.area GSFINAL (CODE)
	.area GSINIT  (CODE)
;--------------------------------------------------------
; Home
;--------------------------------------------------------
	.area HOME    (CODE)
	.area HOME    (CODE)
;--------------------------------------------------------
; code
;--------------------------------------------------------
	.area CSEG    (CODE)
;------------------------------------------------------------
;Allocation info for local variables in function 'Bootstrap'
;------------------------------------------------------------
;	preemptive.c:59: void Bootstrap(void) {
;	-----------------------------------------
;	 function Bootstrap
;	-----------------------------------------
_Bootstrap:
	ar7 = 0x07
	ar6 = 0x06
	ar5 = 0x05
	ar4 = 0x04
	ar3 = 0x03
	ar2 = 0x02
	ar1 = 0x01
	ar0 = 0x00
;	preemptive.c:60: thread_mask = 0;
	clr	a
	mov	_thread_mask,a
	mov	(_thread_mask + 1),a
;	preemptive.c:61: SPthread_1 = 0x3F;
	mov	_SPthread_1,#0x3f
	mov	(_SPthread_1 + 1),a
;	preemptive.c:62: SPthread_2 = 0x4F;
	mov	_SPthread_2,#0x4f
	mov	(_SPthread_2 + 1),a
;	preemptive.c:63: SPthread_3 = 0x5F;
	mov	_SPthread_3,#0x5f
	mov	(_SPthread_3 + 1),a
;	preemptive.c:64: SPthread_4 = 0x6F;
	mov	_SPthread_4,#0x6f
	mov	(_SPthread_4 + 1),a
;	preemptive.c:66: TMOD = 0;
	mov	_TMOD,a
;	preemptive.c:67: IE = 0x82;
	mov	_IE,#0x82
;	preemptive.c:68: TR0 = 1;
;	assignBit
	setb	_TR0
;	preemptive.c:70: next_prod = '1';
	mov	_next_prod,#0x31
;	preemptive.c:71: curr_thread = ThreadCreate(main);
	mov	dptr,#_main
	lcall	_ThreadCreate
	mov	_curr_thread,dpl
;	preemptive.c:72: RESTORESTATE;
	mov	r7,_curr_thread
	cjne	r7,#0x30,00132$
	sjmp	00101$
00132$:
	cjne	r7,#0x31,00133$
	sjmp	00102$
00133$:
	cjne	r7,#0x32,00134$
	sjmp	00103$
00134$:
	cjne	r7,#0x33,00105$
	sjmp	00104$
00101$:
	MOV	SP, 0x30 
	sjmp	00105$
00102$:
	MOV	SP, 0x31 
	sjmp	00105$
00103$:
	MOV	SP, 0x32 
	sjmp	00105$
00104$:
	MOV	SP, 0x33 
00105$:
	POP	PSW 
	POP	DPH 
	POP	DPL 
	POP	B 
	POP	ACC 
;	preemptive.c:73: }
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'myTimer0Handler'
;------------------------------------------------------------
;	preemptive.c:77: void myTimer0Handler(void) {
;	-----------------------------------------
;	 function myTimer0Handler
;	-----------------------------------------
_myTimer0Handler:
;	preemptive.c:78: EA = 0;
;	assignBit
	clr	_EA
;	preemptive.c:79: SAVESTATE;
	PUSH	ACC 
	PUSH	B 
	PUSH	DPL 
	PUSH	DPH 
	PUSH	PSW 
	mov	r7,_curr_thread
	cjne	r7,#0x30,00179$
	sjmp	00101$
00179$:
	cjne	r7,#0x31,00180$
	sjmp	00102$
00180$:
	cjne	r7,#0x32,00181$
	sjmp	00103$
00181$:
	cjne	r7,#0x33,00105$
	sjmp	00104$
00101$:
	MOV	0x30, SP 
	sjmp	00105$
00102$:
	MOV	0x31, SP 
	sjmp	00105$
00103$:
	MOV	0x32, SP 
	sjmp	00105$
00104$:
	MOV	0x33, SP 
00105$:
;	preemptive.c:80: if (curr_thread != '0') {
	mov	a,#0x30
	cjne	a,_curr_thread,00183$
	sjmp	00110$
00183$:
;	preemptive.c:81: curr_thread = '0';
	mov	_curr_thread,#0x30
	sjmp	00111$
00110$:
;	preemptive.c:91: curr_thread = next_prod;
	mov	_curr_thread,_next_prod
;	preemptive.c:92: if(curr_thread == '1') {
	mov	a,#0x31
	cjne	a,_curr_thread,00107$
;	preemptive.c:93: next_prod = '2';
	mov	_next_prod,#0x32
	sjmp	00111$
00107$:
;	preemptive.c:95: else next_prod = '1';
	mov	_next_prod,#0x31
00111$:
;	preemptive.c:97: RESTORESTATE;
	mov	r7,_curr_thread
	cjne	r7,#0x30,00186$
	sjmp	00112$
00186$:
	cjne	r7,#0x31,00187$
	sjmp	00113$
00187$:
	cjne	r7,#0x32,00188$
	sjmp	00114$
00188$:
	cjne	r7,#0x33,00116$
	sjmp	00115$
00112$:
	MOV	SP, 0x30 
	sjmp	00116$
00113$:
	MOV	SP, 0x31 
	sjmp	00116$
00114$:
	MOV	SP, 0x32 
	sjmp	00116$
00115$:
	MOV	SP, 0x33 
00116$:
	POP	PSW 
	POP	DPH 
	POP	DPL 
	POP	B 
	POP	ACC 
;	preemptive.c:98: EA = 1;
;	assignBit
	setb	_EA
;	preemptive.c:99: __asm RETI __endasm;
	RETI	
;	preemptive.c:100: }
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'ThreadCreate'
;------------------------------------------------------------
;fp            Allocated to registers 
;prevSP        Allocated with name '_ThreadCreate_prevSP_10001_23'
;------------------------------------------------------------
;	preemptive.c:106: ThreadID ThreadCreate(FunctionPtr fp) {
;	-----------------------------------------
;	 function ThreadCreate
;	-----------------------------------------
_ThreadCreate:
;	preemptive.c:148: EA = 0;
;	assignBit
	clr	_EA
;	preemptive.c:149: if (thread_mask == 0x0F) {
	mov	a,#0x0f
	cjne	a,_thread_mask,00227$
	clr	a
	cjne	a,(_thread_mask + 1),00227$
	sjmp	00228$
00227$:
	sjmp	00102$
00228$:
;	preemptive.c:150: return -1;
	mov	dpl, #0xff
	ret
00102$:
;	preemptive.c:153: if (!(thread_mask & 0x01)) new_thread = '0';
	mov	a,_thread_mask
	jb	acc.0,00110$
	mov	_new_thread,#0x30
	sjmp	00111$
00110$:
;	preemptive.c:154: else if (!(thread_mask & 0x02)) new_thread = '1';
	mov	a,_thread_mask
	jb	acc.1,00107$
	mov	_new_thread,#0x31
	sjmp	00111$
00107$:
;	preemptive.c:155: else if (!(thread_mask & 0x04)) new_thread = '2';
	mov	a,_thread_mask
	jb	acc.2,00104$
	mov	_new_thread,#0x32
	sjmp	00111$
00104$:
;	preemptive.c:156: else new_thread = '3';
	mov	_new_thread,#0x33
00111$:
;	preemptive.c:158: thread_mask |= (1 << (new_thread - '0'));
	mov	a,_new_thread
	add	a,#0xd0
	mov	b, a
	inc	b
	mov	r7,#0x01
	mov	r6,#0x00
	sjmp	00233$
00232$:
	mov	a,r7
	add	a,r7
	mov	r7,a
	mov	a,r6
	rlc	a
	mov	r6,a
00233$:
	djnz	b,00232$
	mov	a,r7
	orl	_thread_mask,a
	mov	a,r6
	orl	(_thread_mask + 1),a
;	preemptive.c:161: prevSP = SP;
	mov	_ThreadCreate_prevSP_10001_23,_SP
	mov	(_ThreadCreate_prevSP_10001_23 + 1),#0x00
;	preemptive.c:163: if (new_thread == '0') SP = 0x3F;
	mov	a,#0x30
	cjne	a,_new_thread,00121$
	mov	_SP,#0x3f
	sjmp	00122$
00121$:
;	preemptive.c:164: else if (new_thread == '1') SP = 0x4F;
	mov	a,#0x31
	cjne	a,_new_thread,00118$
	mov	_SP,#0x4f
	sjmp	00122$
00118$:
;	preemptive.c:165: else if (new_thread == '2') SP = 0x5F;
	mov	a,#0x32
	cjne	a,_new_thread,00115$
	mov	_SP,#0x5f
	sjmp	00122$
00115$:
;	preemptive.c:166: else if (new_thread == '3') SP = 0x6F;
	mov	a,#0x33
	cjne	a,_new_thread,00122$
	mov	_SP,#0x6f
00122$:
;	preemptive.c:168: __asm MOV A, DPL __endasm;
	MOV	A, DPL 
;	preemptive.c:169: __asm PUSH ACC __endasm;
	PUSH	ACC 
;	preemptive.c:170: __asm MOV A, DPH __endasm;
	MOV	A, DPH 
;	preemptive.c:171: __asm PUSH ACC __endasm;
	PUSH	ACC 
;	preemptive.c:173: __asm MOV A, #0x00 __endasm;
	MOV	A, #0x00 
;	preemptive.c:174: __asm PUSH ACC __endasm;
	PUSH	ACC 
;	preemptive.c:175: __asm PUSH ACC __endasm;
	PUSH	ACC 
;	preemptive.c:176: __asm PUSH ACC __endasm;
	PUSH	ACC 
;	preemptive.c:177: __asm PUSH ACC __endasm;
	PUSH	ACC 
;	preemptive.c:179: if (new_thread == '0') __asm MOV A, #0x00 __endasm;
	mov	a,#0x30
	cjne	a,_new_thread,00130$
	MOV	A, #0x00 
	sjmp	00131$
00130$:
;	preemptive.c:180: else if (new_thread == '1') __asm MOV A, #0x08 __endasm;
	mov	a,#0x31
	cjne	a,_new_thread,00127$
	MOV	A, #0x08 
	sjmp	00131$
00127$:
;	preemptive.c:181: else if (new_thread == '2') __asm MOV A, #0x10 __endasm;
	mov	a,#0x32
	cjne	a,_new_thread,00124$
	MOV	A, #0x10 
	sjmp	00131$
00124$:
;	preemptive.c:182: else __asm MOV A, #0x18 __endasm;
	MOV	A, #0x18 
00131$:
;	preemptive.c:184: __asm PUSH ACC __endasm;
	PUSH	ACC 
;	preemptive.c:186: if (new_thread == '0') SPthread_1 = SP;
	mov	a,#0x30
	cjne	a,_new_thread,00139$
	mov	_SPthread_1,_SP
	mov	(_SPthread_1 + 1),#0x00
	sjmp	00140$
00139$:
;	preemptive.c:187: else if (new_thread == '1') SPthread_2 = SP;
	mov	a,#0x31
	cjne	a,_new_thread,00136$
	mov	_SPthread_2,_SP
	mov	(_SPthread_2 + 1),#0x00
	sjmp	00140$
00136$:
;	preemptive.c:188: else if (new_thread == '2') SPthread_3 = SP;
	mov	a,#0x32
	cjne	a,_new_thread,00133$
	mov	_SPthread_3,_SP
	mov	(_SPthread_3 + 1),#0x00
	sjmp	00140$
00133$:
;	preemptive.c:189: else SPthread_4 = SP;
	mov	_SPthread_4,_SP
	mov	(_SPthread_4 + 1),#0x00
00140$:
;	preemptive.c:191: SP = prevSP;
	mov	_SP,_ThreadCreate_prevSP_10001_23
;	preemptive.c:192: EA = 1;
;	assignBit
	setb	_EA
;	preemptive.c:193: return new_thread;
	mov	dpl, _new_thread
;	preemptive.c:194: }
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'ThreadExit'
;------------------------------------------------------------
;	preemptive.c:197: void ThreadExit(void) {
;	-----------------------------------------
;	 function ThreadExit
;	-----------------------------------------
_ThreadExit:
;	preemptive.c:200: thread_mask &= ~(1 << (curr_thread - '0'));
	mov	a,_curr_thread
	add	a,#0xd0
	mov	b, a
	inc	b
	mov	r7,#0x01
	mov	r6,#0x00
	sjmp	00150$
00149$:
	mov	a,r7
	add	a,r7
	mov	r7,a
	mov	a,r6
	rlc	a
	mov	r6,a
00150$:
	djnz	b,00149$
	mov	a,r7
	cpl	a
	mov	r7,a
	mov	a,r6
	cpl	a
	mov	r6,a
	mov	a,r7
	anl	_thread_mask,a
	mov	a,r6
	anl	(_thread_mask + 1),a
;	preemptive.c:203: while (1) {
00104$:
;	preemptive.c:204: curr_thread = (curr_thread - '0' + 1) % 4 + '0';
	mov	r6,_curr_thread
	mov	r7,#0x00
	mov	a,#0xd1
	add	a, r6
	mov	dpl,a
	mov	a,#0xff
	addc	a, r7
	mov	dph,a
	mov	__modsint_PARM_2,#0x04
	mov	(__modsint_PARM_2 + 1),r7
	lcall	__modsint
	mov	r6, dpl
	mov	a,#0x30
	add	a, r6
	mov	_curr_thread,a
;	preemptive.c:206: if (thread_mask & (1 << (curr_thread - '0'))) {
	mov	a,_curr_thread
	add	a,#0xd0
	mov	b, a
	inc	b
	mov	r7,#0x01
	mov	r6,#0x00
	sjmp	00152$
00151$:
	mov	a,r7
	add	a,r7
	mov	r7,a
	mov	a,r6
	rlc	a
	mov	r6,a
00152$:
	djnz	b,00151$
	mov	a,_thread_mask
	anl	ar7,a
	mov	a,(_thread_mask + 1)
	anl	ar6,a
	mov	a,r7
	orl	a,r6
	jz	00104$
;	preemptive.c:211: RESTORESTATE;
	mov	r7,_curr_thread
	cjne	r7,#0x30,00154$
	sjmp	00106$
00154$:
	cjne	r7,#0x31,00155$
	sjmp	00107$
00155$:
	cjne	r7,#0x32,00156$
	sjmp	00108$
00156$:
	cjne	r7,#0x33,00110$
	sjmp	00109$
00106$:
	MOV	SP, 0x30 
	sjmp	00110$
00107$:
	MOV	SP, 0x31 
	sjmp	00110$
00108$:
	MOV	SP, 0x32 
	sjmp	00110$
00109$:
	MOV	SP, 0x33 
00110$:
	POP	PSW 
	POP	DPH 
	POP	DPL 
	POP	B 
	POP	ACC 
;	preemptive.c:212: }
	ret
	.area CSEG    (CODE)
	.area CONST   (CODE)
	.area XINIT   (CODE)
	.area CABS    (ABS,CODE)
