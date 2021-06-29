/******************************************************************************
*
* Copyright (C) 2009 - 2014 Xilinx, Inc.  All rights reserved.
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* Use of the Software is limited solely to applications:
* (a) running on a Xilinx device, or
* (b) that interact with a Xilinx device through a bus or interconnect.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
* XILINX  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF
* OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
*
* Except as contained in this notice, the name of the Xilinx shall not be used
* in advertising or otherwise to promote the sale, use or other dealings in
* this Software without prior written authorization from Xilinx.
*
******************************************************************************/

/*
 * helloworld.c: simple test application
 *
 * This application configures UART 16550 to baud rate 9600.
 * PS7 UART (Zynq) is not initialized by this application, since
 * bootrom/bsp configures it to baud rate 115200
 *
 * ------------------------------------------------
 * | UART TYPE   BAUD RATE                        |
 * ------------------------------------------------
 *   uartns550   9600
 *   uartlite    Configurable only in HW design
 *   ps7_uart    115200 (configured by bootrom/bsp)
 */

#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"
#include "xgpio.h"
#include "xparameters.h"


int main()
{
	init_platform();


	XGpio input, output;

	XGpio_Initialize(&input,XPAR_AXI_GPIO_0_DEVICE_ID);
	XGpio_Initialize(&output,XPAR_AXI_GPIO_1_DEVICE_ID);

	XGpio_SetDataDirection(&input,1,0xFFFFFFFF);
	XGpio_SetDataDirection(&output,1,0x00);
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	u32 comando, dato_A, dato_B;
	int i;
	while(1){
		comando = getchar();
		if (comando == 's'){
			printf("Starting read sequence...\n\r");
			XGpio_DiscreteWrite(&output,1,comando);
			dato_A = XGpio_DiscreteRead(&input,1);
			if (dato_A == 'e'){
				printf("No more data to read, ending sequence.\n\r");
				XGpio_DiscreteWrite(&output,1,'k');
			}
			else{
				XGpio_DiscreteWrite(&output,1,'b');
				dato_B = XGpio_DiscreteRead(&input,1);
				printf("Ch0: (0x%x%x)\n",(int)dato_A,(int)dato_B);
				for (i = 1; i <16; i++){
					XGpio_DiscreteWrite(&output,1,'a');
					dato_A = XGpio_DiscreteRead(&input,1);
					XGpio_DiscreteWrite(&output,1,'b');
					dato_B = XGpio_DiscreteRead(&input,1);
					printf("Ch%d: (0x%x%x)\n",i,(int)dato_A,(int)dato_B);
				}
				XGpio_DiscreteWrite(&output,1,'d');
				printf("\rDone.\n\r");
			}
		}
	}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//		u32 comando, dato;
//
//		while(1){
//			comando = getchar();
//
//			printf("Recibi: 0x%x\n\r",(int)comando);
//			XGpio_DiscreteWrite(&output,1,comando);
//
//			dato = XGpio_DiscreteRead(&input,1);
//
//			printf("El resultado es: 0x%x\n\r",(int)dato);
//		}


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    cleanup_platform();
    return 0;
}
