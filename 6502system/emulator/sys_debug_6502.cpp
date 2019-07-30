// *******************************************************************************************************************************
// *******************************************************************************************************************************
//
//		Name:		sys_debug_superboard.c
//		Purpose:	Debugger Code (System Dependent)
//		Created:	12th July 2019
//		Author:		Paul Robson (paul@robsons->org.uk)
//
// *******************************************************************************************************************************
// *******************************************************************************************************************************

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "gfx.h"
#include "sys_processor.h"
#include "debugger.h"

#include "6502/__6502mnemonics.h"

#include "character_rom.inc"

#define DBGC_ADDRESS 	(0x0F0)														// Colour scheme.
#define DBGC_DATA 		(0x0FF)														// (Background is in main.c)
#define DBGC_HIGHLIGHT 	(0xFF0)

static int renderCount = 0;

// *******************************************************************************************************************************
//											This renders the debug screen
// *******************************************************************************************************************************

static const char *labels[] = { "A","X","Y","PC","SP","SR","CY","N","V","B","D","I","Z","C", NULL };

void DBGXRender(int *address,int showDisplay) {

	int n = 0;
	char buffer[32];
	CPUSTATUS *s = CPUGetStatus();
	GFXSetCharacterSize(28,24);
	DBGVerticalLabel(21,0,labels,DBGC_ADDRESS,-1);									// Draw the labels for the register


	#define DN(v,w) GFXNumber(GRID(24,n++),v,16,w,GRIDSIZE,DBGC_DATA,-1)			// Helper macro

	DN(s->a,2);DN(s->x,2);DN(s->y,2);DN(s->pc,4);DN(s->sp+0x100,4);DN(s->status,2);DN(s->cycles,4);
	DN(s->sign,1);DN(s->overflow,1);DN(s->brk,1);DN(s->decimal,1);DN(s->interruptDisable,1);DN(s->zero,1);DN(s->carry,1);

	n = 0;
	int a = address[1];																// Dump Memory.
	for (int row = 15;row < 23;row++) {
		GFXNumber(GRID(0,row),a,16,4,GRIDSIZE,DBGC_ADDRESS,-1);
		for (int col = 0;col < 8;col++) {
			GFXNumber(GRID(5+col*3,row),CPUReadMemory(a),16,2,GRIDSIZE,DBGC_DATA,-1);
			a = (a + 1) & 0xFFFF;
		}		
	}

	int p = address[0];																// Dump program code. 
	int opc;

	for (int row = 0;row < 14;row++) {
		int isPC = (p == ((s->pc) & 0xFFFF));										// Tests.
		int isBrk = (p == address[3]);
		GFXNumber(GRID(0,row),p,16,4,GRIDSIZE,isPC ? DBGC_HIGHLIGHT:DBGC_ADDRESS,	// Display address / highlight / breakpoint
																	isBrk ? 0xF00 : -1);
		opc = CPUReadMemory(p);p = (p + 1) & 0xFFFF;								// Read opcode.
		strcpy(buffer,_mnemonics[opc]);												// Work out the opcode.
		char *at = strchr(buffer,'@');												// Look for '@'
		if (at != NULL) {															// Operand ?
			char hex[6],temp[32];	
			if (at[1] == '1') {
				sprintf(hex,"%02x",CPUReadMemory(p));
				p = (p+1) & 0xFFFF;
			}
			if (at[1] == '2') {
				sprintf(hex,"%02x%02x",CPUReadMemory(p+1),CPUReadMemory(p));
				p = (p+2) & 0xFFFF;
			}
			if (at[1] == 'r') {
				int addr = CPUReadMemory(p);
				p = (p+1) & 0xFFFF;
				if ((addr & 0x80) != 0) addr = addr-256;
				sprintf(hex,"%04x",addr+p);
			}
			strcpy(temp,buffer);
			strcpy(temp+(at-buffer),hex);
			strcat(temp,at+2);
			strcpy(buffer,temp);
		}
		GFXString(GRID(5,row),buffer,GRIDSIZE,isPC ? DBGC_HIGHLIGHT:DBGC_DATA,-1);	// Print the mnemonic
	}

	int xs = 80;
	int ys = 25;
	if (showDisplay) {
		renderCount++;
		int size = 2;
		int x1 = WIN_WIDTH/2-xs*size*8/2;
		int y1 = WIN_HEIGHT/2-ys*size*16/2;
		int cursorPos = 0;
		SDL_Rect r;
		int b = 8;
		r.x = x1-b;r.y = y1-b;r.w = xs*size*8+b*2;r.h=ys*size*16+b*2;
		GFXRectangle(&r,0xFFFF);
		b = b - 4;
		r.x = x1-b;r.y = y1-b;r.w = xs*size*8+b*2;r.h=ys*size*16+b*2;
		GFXRectangle(&r,0);
		for (int x = 0;x < xs;x++) 
		{
			for (int y = 0;y < ys;y++)
		 	{
		 		#define CP(c) ((c) >> 4)
		 		int colour = 0x0FF;
		 		int ch = CPUReadMemory(x+y*80+0xB000) ;
		 		ch = ch & 0x7F;
		 		int xc = x1 + x * 8 * size;
		 		int yc = y1 + y * 16 * size;
		 		SDL_Rect rc;
		 		int cp = ch * 8;
		 		rc.w = size;rc.h = size*2;														// Width and Height of pixel.
		 		for (int x = 0;x < 8;x++) {														// 5 Across
		 			rc.x = xc + x * size;
		 			for (int y = 0;y < 8;y++) {													// 7 Down
		 				int f = character_rom[cp+y+0x800];
		 				rc.y = yc + y * 2 * size;
		 				if (f & (0x80 >> x)) {		
		 					GFXRectangle(&rc,colour);			
		 				}
		 			}
		 		}
		 	}
		}
	}
}	
