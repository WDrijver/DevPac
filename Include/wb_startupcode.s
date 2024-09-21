;useage:
; include wb_startupcode.s
;_main

;CLI commandline args:
;a2 zero (wb) or ptr to cmd_line
;d2 msg  (wb) or cmd_line size




; Workbench startup code
;

_LVOForbid   EQU -$84
_LVOFindTask EQU -$126
_LVOGetMsg   EQU -$174
_LVOReplyMsg EQU -$17A
_LVOWaitPort EQU -$180

pr_MsgPort   EQU $5C
pr_CLI       EQU $AC


; WBStartUp code - entry point
;
startupcode:

	move.l  (4).w,a6

; Save original CLI commandline args.
;
	move.l  d0,d2
	move.l  a0,a2			; becomes 0 when run from wb

; Find process pointer of self.
;
	sub.l   a1,a1			; a1=name
	jsr     _LVOFindTask(a6)
	move.l  d0,a4			; d0=task

; If pr_CLI is non-NULL then the program was started from shell.
; In this case don't bother with further processing. Just
; jump to main routine (and exit in there).
;
	tst.l   pr_CLI(a4)
	bne.b   _main			;running from cli

; Wait for the Workbench startup message to arrive.
;
	lea     pr_MsgPort(a4),a0	;a0=port
	jsr     _LVOWaitPort(a6)
					;d0=msg

; Get the Workbench startup message pointer.
;
	lea     pr_MsgPort(a4),a0	;a0=port
	jsr     _LVOGetMsg(a6)
	move.l  d0,-(sp)		;d0=msg

; Call the actual program code. Argument pointer (a0) will
; be NULL. D0 contain pointer to WBStartup Message
; (see workbench/startup.i).
;
;struct Message {
;    struct  Node mn_Node;
;    struct  MsgPort *mn_ReplyPort;  /* message reply port */
;    UWORD   mn_Length;		    /* total message length, in bytes */
;				    /* (include the size of the Message */
;				    /* structure in the length) */

	move.l  d0,d2
	sub.l   a2,a2
	bsr.b   _main			;running from wb

; Save RC for final return.
;
	move.l  d0,d2

; Forbid to avoid Workbench from unloading our seglist while
; we execute it.
;
	move.l  (4).w,a6
	jsr     _LVOForbid(a6)

; Reply WBStartup message. This will instruct Workbench to
; unload the seglist of the program.
;
	move.l  (sp)+,a1		;a1=msg
	jsr     _LVOReplyMsg(a6)

; Set final RC and return with original stack pointer.
;
	move.l  d2,d0
	rts

