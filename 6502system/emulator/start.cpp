// *******************************************************************************************************************************
// *******************************************************************************************************************************
//
//		Name:		start.cpp
//		Purpose:	Setup/Loop for Arduino implementation
//		Created:	12th July 2019
//		Author:		Paul Robson (paul@robsons.org.uk)
//
// *******************************************************************************************************************************
// *******************************************************************************************************************************

#include <Arduino.h>

#include "sys_processor.h"

void setup()
{
  	CPUReset();
}

unsigned long nextFrameTime = 0;

void loop()
{
    unsigned long frameRate = CPUExecuteInstruction();
    if (frameRate != 0) {
		while (millis() < nextFrameTime) {}
		nextFrameTime = nextFrameTime + 1000 / frameRate;
	}
}

LONG32 SYSMilliseconds(void) {
	return millis();
}
