// *******************************************************************************************************************************
// *******************************************************************************************************************************
//
//		Name:		sys_processor.c
//		Purpose:	Processor Emulation.
//		Created:	15th July 2019
//		Author:		Paul Robson (paul@robsons.org.uk)
//
// *******************************************************************************************************************************
// *******************************************************************************************************************************

#include <stdio.h>
#include "sys_processor.h"
#include "sys_debug_system.h"

// *******************************************************************************************************************************
//														   Timing
// *******************************************************************************************************************************

#define CYCLE_RATE 		(8*1000*1000)												// Cycles per second (0.96Mhz)
#define FRAME_RATE		(60)														// Frames per second (50 arbitrary)
#define CYCLES_PER_FRAME (CYCLE_RATE / FRAME_RATE)									// Cycles per frame (20,000)

// *******************************************************************************************************************************
//														CPU / Memory
// *******************************************************************************************************************************

static BYTE8 a,x,y,s;																// 6502 A,X,Y and Stack registers
static BYTE8 carryFlag,interruptDisableFlag,breakFlag,								// Values representing status reg
			 decimalFlag,overflowFlag,sValue,zValue;
static WORD16 pc;																	// Program Counter.
static BYTE8 ramMemory[RAMSIZE];													// Memory at $0000 upwards
static LONG32 cycles;																// Cycle Count.

// *******************************************************************************************************************************
//											 Memory and I/O read and write macros.
// *******************************************************************************************************************************

#define Read(a) 	_Read(a)														// Basic Read
#define Write(a,d)	_Write(a,d)														// Basic Write

#define ReadWord(a) (Read(a) | ((Read((a)+1) << 8)))								// Read 16 bit, Basic

#define ReadWord01(a) (ramMemory[a]+(ramMemory[(a+1)] << 8))						// Read 16 bit, page 0/1 
#define Read01(a) 	(ramMemory[a])													// Read 8 bit, page 0/1
#define Write01(a,d) { ramMemory[a] = (d); }										// Write 8 bit, page 0/1

#define Cycles(n) 	cycles += (n)													// Bump Cycles

#define Fetch() 	_Read(pc++)														// Fetch byte
#define FetchWord()	{ temp16 = Fetch();temp16 |= (Fetch() << 8); }					// Fetch word

static inline BYTE8 _Read(WORD16 address);											// Need to be forward defined as 
static inline void _Write(WORD16 address,BYTE8 data);								// used in support functions.

#include "6502/__6502support.h"

// *******************************************************************************************************************************
//											   Read and Write Inline Functions
// *******************************************************************************************************************************

static inline BYTE8 _Read(WORD16 address) {
	return ramMemory[address];							
}

static inline void _Write(WORD16 address,BYTE8 data) {
	ramMemory[address] = data;
}

// *******************************************************************************************************************************
//														Reset the CPU
// *******************************************************************************************************************************

#ifdef INCLUDE_DEBUGGING_SUPPORT
static void CPULoadChunk(FILE *f,BYTE8* memory,int count);
#endif

#ifdef ESP32
void CPUExit(void) {}
#endif

void CPUReset(void) {
	FILE *f = fopen("rom.bin","rb");
	if (f != NULL) {
		CPULoadChunk(f,ramMemory,0x10000);
		fclose(f);
	}
	resetProcessor();																// Reset CPU
}

// *******************************************************************************************************************************
//												Execute a single instruction
// *******************************************************************************************************************************

BYTE8 CPUExecuteInstruction(void) {
	BYTE8 opcode = Fetch();															// Fetch opcode.
	switch(opcode) {																// Execute it.
		#include "6502/__6502opcodes.h"
	}
	if (cycles < CYCLES_PER_FRAME) return 0;										// Not completed a frame.
	cycles = cycles - CYCLES_PER_FRAME;												// Adjust this frame rate.
	return FRAME_RATE;																// Return frame rate.
}

// *******************************************************************************************************************************
//												Read/Write Memory
// *******************************************************************************************************************************

BYTE8 CPUReadMemory(WORD16 address) {
	return Read(address);
}

void CPUWriteMemory(WORD16 address,BYTE8 data) {
	Write(address,data);
}


#ifdef INCLUDE_DEBUGGING_SUPPORT

#include "gfx.h"

// *******************************************************************************************************************************
//												Process keyboard keys
// *******************************************************************************************************************************

int CPUKeyHandler(int key,int inRunMode) {
	if (inRunMode != 0) {
		int akey = GFXToASCII(key,-1);
		//printf("%d\n",akey);
		ramMemory[0xB800] = akey & 0xFF;
		return 0;
	}
	return key;
}

// *******************************************************************************************************************************
//		Execute chunk of code, to either of two break points or frame-out, return non-zero frame rate on frame, breakpoint 0
// *******************************************************************************************************************************

BYTE8 CPUExecute(WORD16 breakPoint1,WORD16 breakPoint2) { 
	BYTE8 next;
	do {
		BYTE8 r = CPUExecuteInstruction();											// Execute an instruction
		if (r != 0) return r; 														// Frame out.
		next = CPUReadMemory(pc);
	} while (pc != breakPoint1 && pc != breakPoint2 && next != 0xEA);				// Stop on breakpoint or $EA break
	return 0; 
}

// *******************************************************************************************************************************
//									Return address of breakpoint for step-over, or 0 if N/A
// *******************************************************************************************************************************

WORD16 CPUGetStepOverBreakpoint(void) {
	BYTE8 opcode = CPUReadMemory(pc);												// Current opcode.
	if (opcode == 0x20) return (pc+3) & 0xFFFF;										// Step over JSR.
	return 0;																		// Do a normal single step
}

void CPUEndRun(void) {
	FILE *f = fopen("memory.dump","wb");
	fwrite(ramMemory,1,RAMSIZE,f);
	fclose(f);
}

void CPUExit(void) {	
	GFXExit();
}

static void CPULoadChunk(FILE *f,BYTE8* memory,int count) {
	while (count != 0) {
		int qty = (count > 4096) ? 4096 : count;
		fread(memory,1,qty,f);
		count = count - qty;
		memory = memory + qty;
	}
}
void CPULoadBinary(char *fileName) {
	FILE *f = fopen(fileName,"rb");
	if (f != NULL) {
		CPULoadChunk(f,ramMemory,RAMSIZE);
		fclose(f);
		resetProcessor();
	}
}

// *******************************************************************************************************************************
//											Retrieve a snapshot of the processor
// *******************************************************************************************************************************

static CPUSTATUS st;																	// Status area

CPUSTATUS *CPUGetStatus(void) {
	st.a = a;st.x = x;st.y = y;st.sp = s;st.pc = pc;
	st.carry = carryFlag;st.interruptDisable = interruptDisableFlag;st.zero = (zValue == 0);
	st.decimal = decimalFlag;st.brk = breakFlag;st.overflow = overflowFlag;
	st.sign = (sValue & 0x80) != 0;st.status = constructFlagRegister();
	st.cycles = cycles;
	return &st;
}

#endif
