	IFND	DEVICES_INPUT_I
DEVICES_INPUT_I SET	1
**
**	$VER: input.i 36.0 (01.05.90)
**	Includes Release 39.108
**
**	input device command definitions
**
**	(C) Copyright 1985-1992 Commodore-Amiga, Inc.
**	    All Rights Reserved
**

   IFND	    EXEC_IO_I
   INCLUDE     "exec/io.i"
   ENDC

   DEVINIT

   DEVCMD	IND_ADDHANDLER
   DEVCMD	IND_REMHANDLER
   DEVCMD	IND_WRITEEVENT
   DEVCMD	IND_SETTHRESH
   DEVCMD	IND_SETPERIOD
   DEVCMD	IND_SETMPORT
   DEVCMD	IND_SETMTYPE
   DEVCMD	IND_SETMTRIG

	ENDC	; DEVICES_INPUT_I
