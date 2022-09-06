
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Release
;Chip type              : ATmega32
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : float, width, precision
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: No
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega32
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2048
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x085F
	.EQU __DSTACK_SIZE=0x0100
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _row=R5
	.DEF _col=R4
	.DEF _Temp=R7
	.DEF __lcd_x=R6
	.DEF __lcd_y=R9
	.DEF __lcd_maxx=R8

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  _ext_int2_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0

_0x0:
	.DB  0x23,0x20,0x45,0x4E,0x54,0x45,0x52,0x20
	.DB  0x50,0x41,0x53,0x53,0x0,0x20,0x2A,0x20
	.DB  0x43,0x48,0x41,0x4E,0x47,0x45,0x20,0x50
	.DB  0x41,0x53,0x53,0x0,0x4F,0x50,0x45,0x4E
	.DB  0x0,0x43,0x4C,0x4F,0x53,0x45,0x0,0x53
	.DB  0x4F,0x52,0x52,0x59,0x0,0x52,0x45,0x53
	.DB  0x45,0x54,0x0,0x45,0x4E,0x54,0x45,0x52
	.DB  0x20,0x4F,0x4C,0x44,0x20,0x50,0x41,0x53
	.DB  0x53,0x0,0x45,0x4E,0x54,0x45,0x52,0x20
	.DB  0x4E,0x45,0x57,0x20,0x50,0x41,0x53,0x53
	.DB  0x0,0x4F,0x4B,0x0,0x25,0x75,0x0,0x50
	.DB  0x72,0x65,0x65,0x73,0x20,0x49,0x6E,0x74
	.DB  0x65,0x72,0x75,0x70,0x74,0x20,0x54,0x6F
	.DB  0x20,0x74,0x79,0x70,0x65,0x20,0x70,0x61
	.DB  0x73,0x73,0x0
_0x2000003:
	.DB  0x80,0xC0
_0x2020000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0
_0x20A0060:
	.DB  0x1
_0x20A0000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x02
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x0D
	.DW  _0x5
	.DW  _0x0*2

	.DW  0x0F
	.DW  _0x5+13
	.DW  _0x0*2+13

	.DW  0x05
	.DW  _0x5+28
	.DW  _0x0*2+28

	.DW  0x06
	.DW  _0x5+33
	.DW  _0x0*2+33

	.DW  0x06
	.DW  _0x5+39
	.DW  _0x0*2+39

	.DW  0x06
	.DW  _0x5+45
	.DW  _0x0*2+45

	.DW  0x0F
	.DW  _0x16
	.DW  _0x0*2+51

	.DW  0x0F
	.DW  _0x16+15
	.DW  _0x0*2+66

	.DW  0x03
	.DW  _0x16+30
	.DW  _0x0*2+81

	.DW  0x02
	.DW  __base_y_G100
	.DW  _0x2000003*2

	.DW  0x01
	.DW  __seed_G105
	.DW  _0x20A0060*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;#include <mega32.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;#include <lcd.h>
;#include <stdio.h>
;
;#asm
   .equ __lcd_port=0x1B ;PORTA
; 0000 0008 #endasm
;
;#define KEYPAD_PORT PORTC
;#define KEYPAD_PIN PINC
;#define KEYPAD_DDR DDRC
;#define OUTPUT_PORT PORTD
;#define OUTPUT_DDR DDRD
;#define RESET_PIN PINB.0
;
;
;
;eeprom  int pass ,j;
;unsigned char key[10];
;signed char row=0 ,col=0;
;unsigned char keypad();
;void change_pass();
;int enter_pass();
;char Temp;
;
;interrupt [EXT_INT2] void ext_int2_isr(void)
; 0000 001C {

	.CSEG
_ext_int2_isr:
; .FSTART _ext_int2_isr
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 001D // Place your code here
; 0000 001E         PORTD.6 = 0;
	CBI  0x12,6
; 0000 001F         #asm("cli");
	cli
; 0000 0020         delay_ms(400);
	LDI  R26,LOW(400)
	LDI  R27,HIGH(400)
	CALL SUBOPT_0x0
; 0000 0021         lcd_clear();
; 0000 0022 
; 0000 0023        lcd_puts("# ENTER PASS");
	__POINTW2MN _0x5,0
	CALL _lcd_puts
; 0000 0024        lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL _lcd_gotoxy
; 0000 0025        lcd_puts(" * CHANGE PASS");
	__POINTW2MN _0x5,13
	CALL _lcd_puts
; 0000 0026        lcd_putchar(j);
	LDI  R26,LOW(_j)
	LDI  R27,HIGH(_j)
	CALL __EEPROMRDB
	MOV  R26,R30
	CALL _lcd_putchar
; 0000 0027        delay_ms(200);
	LDI  R26,LOW(200)
	LDI  R27,0
	CALL _delay_ms
; 0000 0028        Temp=keypad();
	RCALL _keypad
	MOV  R7,R30
; 0000 0029 
; 0000 002A 
; 0000 002B        if(Temp=='#' && j>0)
	LDI  R30,LOW(35)
	CP   R30,R7
	BRNE _0x7
	CALL SUBOPT_0x1
	CALL __CPW01
	BRLT _0x8
_0x7:
	RJMP _0x6
_0x8:
; 0000 002C        {
; 0000 002D        if(enter_pass()== pass)
	CALL SUBOPT_0x2
	BRNE _0x9
; 0000 002E         {
; 0000 002F         lcd_clear();
	CALL _lcd_clear
; 0000 0030          lcd_puts("OPEN");
	__POINTW2MN _0x5,28
	CALL _lcd_puts
; 0000 0031          OUTPUT_PORT =128;
	LDI  R30,LOW(128)
	OUT  0x12,R30
; 0000 0032          delay_ms(2000);
	LDI  R26,LOW(2000)
	LDI  R27,HIGH(2000)
	CALL SUBOPT_0x0
; 0000 0033          lcd_clear();
; 0000 0034          OUTPUT_PORT =0;
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 0035          j=3;
	LDI  R26,LOW(_j)
	LDI  R27,HIGH(_j)
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	RJMP _0x48
; 0000 0036           }
; 0000 0037        else
_0x9:
; 0000 0038         {
; 0000 0039         lcd_clear();
	CALL _lcd_clear
; 0000 003A          lcd_puts("CLOSE");
	__POINTW2MN _0x5,33
	CALL SUBOPT_0x3
; 0000 003B           delay_ms(500);
	CALL SUBOPT_0x0
; 0000 003C            lcd_clear();
; 0000 003D            j--;
	CALL SUBOPT_0x1
	SBIW R30,1
_0x48:
	CALL __EEPROMWRW
; 0000 003E          }
; 0000 003F        }
; 0000 0040 
; 0000 0041        else if(Temp=='*' && j>0)
	RJMP _0xB
_0x6:
	LDI  R30,LOW(42)
	CP   R30,R7
	BRNE _0xD
	CALL SUBOPT_0x1
	CALL __CPW01
	BRLT _0xE
_0xD:
	RJMP _0xC
_0xE:
; 0000 0042        change_pass();
	RCALL _change_pass
; 0000 0043 
; 0000 0044        if(j<=0)
_0xC:
_0xB:
	CALL SUBOPT_0x1
	CALL __CPW01
	BRLT _0xF
; 0000 0045        {
; 0000 0046        lcd_clear();
	CALL _lcd_clear
; 0000 0047        lcd_puts("SORRY");
	__POINTW2MN _0x5,39
	CALL _lcd_puts
; 0000 0048        while(1)
_0x10:
; 0000 0049         {
; 0000 004A         if(RESET_PIN==0)
	SBIC 0x16,0
	RJMP _0x13
; 0000 004B          {
; 0000 004C           lcd_clear();
	CALL _lcd_clear
; 0000 004D           lcd_puts("RESET");
	__POINTW2MN _0x5,45
	CALL _lcd_puts
; 0000 004E           pass=1234;
	LDI  R26,LOW(_pass)
	LDI  R27,HIGH(_pass)
	LDI  R30,LOW(1234)
	LDI  R31,HIGH(1234)
	CALL __EEPROMWRW
; 0000 004F           j=3;
	LDI  R26,LOW(_j)
	LDI  R27,HIGH(_j)
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL __EEPROMWRW
; 0000 0050           delay_ms(1000);
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	CALL SUBOPT_0x0
; 0000 0051           lcd_clear();
; 0000 0052           break;
	RJMP _0x12
; 0000 0053            }
; 0000 0054           }
_0x13:
	RJMP _0x10
_0x12:
; 0000 0055          }
; 0000 0056        lcd_clear();
_0xF:
	CALL _lcd_clear
; 0000 0057        KEYPAD_PORT = 0xf0;
	LDI  R30,LOW(240)
	OUT  0x15,R30
; 0000 0058        PORTD.6 = 1;
	SBI  0x12,6
; 0000 0059        #asm("sei");
	sei
; 0000 005A }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND

	.DSEG
_0x5:
	.BYTE 0x33
;void change_pass()
; 0000 005C {

	.CSEG
_change_pass:
; .FSTART _change_pass
; 0000 005D  lcd_clear();
	CALL _lcd_clear
; 0000 005E  lcd_puts("ENTER OLD PASS");
	__POINTW2MN _0x16,0
	CALL SUBOPT_0x3
; 0000 005F  delay_ms(500);
	CALL _delay_ms
; 0000 0060 
; 0000 0061  while(j!=0)
_0x17:
	CALL SUBOPT_0x1
	SBIW R30,0
	BREQ _0x19
; 0000 0062   {
; 0000 0063    if(enter_pass()==pass)
	CALL SUBOPT_0x2
	BRNE _0x1A
; 0000 0064     {
; 0000 0065      lcd_clear();
	CALL _lcd_clear
; 0000 0066       lcd_puts("ENTER NEW PASS");
	__POINTW2MN _0x16,15
	CALL SUBOPT_0x3
; 0000 0067        delay_ms(500);
	CALL _delay_ms
; 0000 0068      pass = enter_pass();
	RCALL _enter_pass
	LDI  R26,LOW(_pass)
	LDI  R27,HIGH(_pass)
	CALL __EEPROMWRW
; 0000 0069      lcd_clear();
	CALL _lcd_clear
; 0000 006A       lcd_puts("OK");
	__POINTW2MN _0x16,30
	CALL SUBOPT_0x3
; 0000 006B        delay_ms(500);
	CALL _delay_ms
; 0000 006C         return;
	RET
; 0000 006D        }
; 0000 006E    else j--;
_0x1A:
	CALL SUBOPT_0x1
	SBIW R30,1
	CALL __EEPROMWRW
; 0000 006F     }
	RJMP _0x17
_0x19:
; 0000 0070 }
	RET
; .FEND

	.DSEG
_0x16:
	.BYTE 0x21
;
;
;char keypad()
; 0000 0074 {

	.CSEG
_keypad:
; .FSTART _keypad
; 0000 0075     while(1){
_0x1C:
; 0000 0076         PORTC = 0b00010000;
	LDI  R30,LOW(16)
	OUT  0x15,R30
; 0000 0077         if (PINC.0)return '*';
	SBIS 0x13,0
	RJMP _0x1F
	LDI  R30,LOW(42)
	RET
; 0000 0078         if (PINC.1)return '2';
_0x1F:
	SBIS 0x13,1
	RJMP _0x20
	LDI  R30,LOW(50)
	RET
; 0000 0079         if (PINC.2)return '3';
_0x20:
	SBIS 0x13,2
	RJMP _0x21
	LDI  R30,LOW(51)
	RET
; 0000 007A 
; 0000 007B         PORTC = 0b00100000;
_0x21:
	LDI  R30,LOW(32)
	OUT  0x15,R30
; 0000 007C         if (PINC.0)return '1';
	SBIS 0x13,0
	RJMP _0x22
	LDI  R30,LOW(49)
	RET
; 0000 007D         if (PINC.1)return '5';
_0x22:
	SBIS 0x13,1
	RJMP _0x23
	LDI  R30,LOW(53)
	RET
; 0000 007E         if (PINC.2)return '6';
_0x23:
	SBIS 0x13,2
	RJMP _0x24
	LDI  R30,LOW(54)
	RET
; 0000 007F 
; 0000 0080         PORTC = 0b01000000;
_0x24:
	LDI  R30,LOW(64)
	OUT  0x15,R30
; 0000 0081         if (PINC.0)return '4';
	SBIS 0x13,0
	RJMP _0x25
	LDI  R30,LOW(52)
	RET
; 0000 0082         if (PINC.1)return '8';
_0x25:
	SBIS 0x13,1
	RJMP _0x26
	LDI  R30,LOW(56)
	RET
; 0000 0083         if (PINC.2)return '9';
_0x26:
	SBIS 0x13,2
	RJMP _0x27
	LDI  R30,LOW(57)
	RET
; 0000 0084 
; 0000 0085         PORTC = 0b10000000;
_0x27:
	LDI  R30,LOW(128)
	OUT  0x15,R30
; 0000 0086         if (PINC.0)return '7';
	SBIS 0x13,0
	RJMP _0x28
	LDI  R30,LOW(55)
	RET
; 0000 0087         if (PINC.1)return '0';
_0x28:
	SBIS 0x13,1
	RJMP _0x29
	LDI  R30,LOW(48)
	RET
; 0000 0088         if (PINC.2)return '#';
_0x29:
	SBIS 0x13,2
	RJMP _0x2A
	LDI  R30,LOW(35)
	RET
; 0000 0089        }
_0x2A:
	RJMP _0x1C
; 0000 008A }
; .FEND
;
;int enter_pass()
; 0000 008D {
_enter_pass:
; .FSTART _enter_pass
; 0000 008E  int n=0 ,i=0 ,num;
; 0000 008F  lcd_clear();
	CALL __SAVELOCR6
;	n -> R16,R17
;	i -> R18,R19
;	num -> R20,R21
	__GETWRN 16,17,0
	__GETWRN 18,19,0
	CALL _lcd_clear
; 0000 0090 
; 0000 0091  while(i<=8) {
_0x2B:
	__CPWRN 18,19,9
	BRLT PC+2
	RJMP _0x2D
; 0000 0092 
; 0000 0093    key[i]=keypad();
	MOVW R30,R18
	SUBI R30,LOW(-_key)
	SBCI R31,HIGH(-_key)
	PUSH R31
	PUSH R30
	RCALL _keypad
	POP  R26
	POP  R27
	ST   X,R30
; 0000 0094 
; 0000 0095     if(key[i]=='#' && i>3)
	CALL SUBOPT_0x4
	CPI  R26,LOW(0x23)
	BRNE _0x2F
	__CPWRN 18,19,4
	BRGE _0x30
_0x2F:
	RJMP _0x2E
_0x30:
; 0000 0096       {
; 0000 0097        sscanf(key,"%u",&num);
	LDI  R30,LOW(_key)
	LDI  R31,HIGH(_key)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,84
	ST   -Y,R31
	ST   -Y,R30
	IN   R30,SPL
	IN   R31,SPH
	SBIW R30,1
	CALL __PUTPARD1L
	PUSH R21
	PUSH R20
	LDI  R24,4
	CALL _sscanf
	ADIW R28,8
	POP  R20
	POP  R21
; 0000 0098        return num;
	MOVW R30,R20
	RJMP _0x20C0006
; 0000 0099         }
; 0000 009A       else if (key[i] =='*')
_0x2E:
	CALL SUBOPT_0x4
	CPI  R26,LOW(0x2A)
	BRNE _0x32
; 0000 009B         {
; 0000 009C            i--;
	__SUBWRN 18,19,1
; 0000 009D            lcd_clear();
	CALL _lcd_clear
; 0000 009E            for(n=0;n<i;n++)lcd_putchar(key[n]);
	__GETWRN 16,17,0
_0x34:
	__CPWRR 16,17,18,19
	BRGE _0x35
	LDI  R26,LOW(_key)
	LDI  R27,HIGH(_key)
	ADD  R26,R16
	ADC  R27,R17
	LD   R26,X
	CALL _lcd_putchar
	__ADDWRN 16,17,1
	RJMP _0x34
_0x35:
; 0000 009F }
; 0000 00A0         else if (i<8 && key[i]!='#')
	RJMP _0x36
_0x32:
	__CPWRN 18,19,8
	BRGE _0x38
	CALL SUBOPT_0x4
	CPI  R26,LOW(0x23)
	BRNE _0x39
_0x38:
	RJMP _0x37
_0x39:
; 0000 00A1           {
; 0000 00A2            lcd_putchar(key[i]);
	CALL SUBOPT_0x4
	CALL _lcd_putchar
; 0000 00A3            i++;
	__ADDWRN 18,19,1
; 0000 00A4             }
; 0000 00A5     delay_ms(250);
_0x37:
_0x36:
	LDI  R26,LOW(250)
	LDI  R27,0
	CALL _delay_ms
; 0000 00A6    }
	RJMP _0x2B
_0x2D:
; 0000 00A7 }
_0x20C0006:
	CALL __LOADLOCR6
	ADIW R28,6
	RET
; .FEND
;
;
;
;
;void main(void)
; 0000 00AD {
_main:
; .FSTART _main
; 0000 00AE // Declare your local variables here
; 0000 00AF 
; 0000 00B0 // Input/Output Ports initialization
; 0000 00B1 // Port A initialization
; 0000 00B2 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 00B3 DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
	LDI  R30,LOW(0)
	OUT  0x1A,R30
; 0000 00B4 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 00B5 PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
	OUT  0x1B,R30
; 0000 00B6 
; 0000 00B7 // Port B initialization
; 0000 00B8 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 00B9 DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
	OUT  0x17,R30
; 0000 00BA // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 00BB PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	OUT  0x18,R30
; 0000 00BC 
; 0000 00BD // Port C initialization
; 0000 00BE // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 00BF DDRC=(1<<DDC7) | (1<<DDC6) | (1<<DDC5) | (1<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
	LDI  R30,LOW(240)
	OUT  0x14,R30
; 0000 00C0 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 00C1 PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 00C2 
; 0000 00C3 // Port D initialization
; 0000 00C4 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 00C5 DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
	OUT  0x11,R30
; 0000 00C6 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 00C7 PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	OUT  0x12,R30
; 0000 00C8 
; 0000 00C9 // Timer/Counter 0 initialization
; 0000 00CA // Clock source: System Clock
; 0000 00CB // Clock value: Timer 0 Stopped
; 0000 00CC // Mode: Normal top=0xFF
; 0000 00CD // OC0 output: Disconnected
; 0000 00CE TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (0<<CS01) | (0<<CS00);
	OUT  0x33,R30
; 0000 00CF TCNT0=0x00;
	OUT  0x32,R30
; 0000 00D0 OCR0=0x00;
	OUT  0x3C,R30
; 0000 00D1 
; 0000 00D2 // Timer/Counter 1 initialization
; 0000 00D3 // Clock source: System Clock
; 0000 00D4 // Clock value: Timer1 Stopped
; 0000 00D5 // Mode: Normal top=0xFFFF
; 0000 00D6 // OC1A output: Disconnected
; 0000 00D7 // OC1B output: Disconnected
; 0000 00D8 // Noise Canceler: Off
; 0000 00D9 // Input Capture on Falling Edge
; 0000 00DA // Timer1 Overflow Interrupt: Off
; 0000 00DB // Input Capture Interrupt: Off
; 0000 00DC // Compare A Match Interrupt: Off
; 0000 00DD // Compare B Match Interrupt: Off
; 0000 00DE TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	OUT  0x2F,R30
; 0000 00DF TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
	OUT  0x2E,R30
; 0000 00E0 TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 00E1 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 00E2 ICR1H=0x00;
	OUT  0x27,R30
; 0000 00E3 ICR1L=0x00;
	OUT  0x26,R30
; 0000 00E4 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 00E5 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 00E6 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 00E7 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 00E8 
; 0000 00E9 // Timer/Counter 2 initialization
; 0000 00EA // Clock source: System Clock
; 0000 00EB // Clock value: Timer2 Stopped
; 0000 00EC // Mode: Normal top=0xFF
; 0000 00ED // OC2 output: Disconnected
; 0000 00EE ASSR=0<<AS2;
	OUT  0x22,R30
; 0000 00EF TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	OUT  0x25,R30
; 0000 00F0 TCNT2=0x00;
	OUT  0x24,R30
; 0000 00F1 OCR2=0x00;
	OUT  0x23,R30
; 0000 00F2 
; 0000 00F3 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 00F4 TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);
	OUT  0x39,R30
; 0000 00F5 
; 0000 00F6 // External Interrupt(s) initialization
; 0000 00F7 // INT0: Off
; 0000 00F8 // INT1: Off
; 0000 00F9 // INT2: On
; 0000 00FA // INT2 Mode: Rising Edge
; 0000 00FB GICR|=(0<<INT1) | (0<<INT0) | (1<<INT2);
	IN   R30,0x3B
	ORI  R30,0x20
	OUT  0x3B,R30
; 0000 00FC MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	LDI  R30,LOW(0)
	OUT  0x35,R30
; 0000 00FD MCUCSR=(1<<ISC2);
	LDI  R30,LOW(64)
	OUT  0x34,R30
; 0000 00FE GIFR=(0<<INTF1) | (0<<INTF0) | (1<<INTF2);
	LDI  R30,LOW(32)
	OUT  0x3A,R30
; 0000 00FF 
; 0000 0100 // USART initialization
; 0000 0101 // USART disabled
; 0000 0102 UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	LDI  R30,LOW(0)
	OUT  0xA,R30
; 0000 0103 
; 0000 0104 // Analog Comparator initialization
; 0000 0105 // Analog Comparator: Off
; 0000 0106 // The Analog Comparator's positive input is
; 0000 0107 // connected to the AIN0 pin
; 0000 0108 // The Analog Comparator's negative input is
; 0000 0109 // connected to the AIN1 pin
; 0000 010A ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 010B SFIOR=(0<<ACME);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 010C 
; 0000 010D // ADC initialization
; 0000 010E // ADC disabled
; 0000 010F ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
	OUT  0x6,R30
; 0000 0110 
; 0000 0111 // SPI initialization
; 0000 0112 // SPI disabled
; 0000 0113 SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0xD,R30
; 0000 0114 
; 0000 0115 // TWI initialization
; 0000 0116 // TWI disabled
; 0000 0117 TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	OUT  0x36,R30
; 0000 0118 
; 0000 0119 // Global enable interrupts
; 0000 011A #asm("sei")  ;
	sei
; 0000 011B 
; 0000 011C 
; 0000 011D     lcd_init(16);
	LDI  R26,LOW(16)
	CALL _lcd_init
; 0000 011E     OUTPUT_DDR=0b11000000;
	LDI  R30,LOW(192)
	OUT  0x11,R30
; 0000 011F     DDRB.0 =0;
	CBI  0x17,0
; 0000 0120     PORTB.0 =1;
	SBI  0x18,0
; 0000 0121     KEYPAD_PORT = 0xf0;
	LDI  R30,LOW(240)
	OUT  0x15,R30
; 0000 0122     PORTD.6 = 1;
	SBI  0x12,6
; 0000 0123     while (1)
_0x40:
; 0000 0124     {
; 0000 0125 
; 0000 0126 
; 0000 0127     // Place your code here
; 0000 0128       if (col==16) {
	LDI  R30,LOW(16)
	CP   R30,R4
	BRNE _0x43
; 0000 0129         col =0;
	CLR  R4
; 0000 012A         row = row == 0 ? 1 : 0 ;
	TST  R5
	BRNE _0x44
	LDI  R30,LOW(1)
	RJMP _0x45
_0x44:
	LDI  R30,LOW(0)
_0x45:
	MOV  R5,R30
; 0000 012B       }
; 0000 012C       lcd_gotoxy(col,row);
_0x43:
	ST   -Y,R4
	MOV  R26,R5
	CALL _lcd_gotoxy
; 0000 012D 
; 0000 012E 
; 0000 012F       lcd_putsf("Prees Interupt To type pass");
	__POINTW2FN _0x0,87
	CALL _lcd_putsf
; 0000 0130       delay_ms(100);
	LDI  R26,LOW(100)
	LDI  R27,0
	CALL SUBOPT_0x0
; 0000 0131       lcd_clear();
; 0000 0132       col ++;
	INC  R4
; 0000 0133 
; 0000 0134     }
	RJMP _0x40
; 0000 0135  }
_0x47:
	RJMP _0x47
; .FEND
;
;
    .equ __lcd_direction=__lcd_port-1
    .equ __lcd_pin=__lcd_port-2
    .equ __lcd_rs=0
    .equ __lcd_rd=1
    .equ __lcd_enable=2
    .equ __lcd_busy_flag=7

	.DSEG

	.CSEG
__lcd_delay_G100:
; .FSTART __lcd_delay_G100
    ldi   r31,15
__lcd_delay0:
    dec   r31
    brne  __lcd_delay0
	RET
; .FEND
__lcd_ready:
; .FSTART __lcd_ready
    in    r26,__lcd_direction
    andi  r26,0xf                 ;set as input
    out   __lcd_direction,r26
    sbi   __lcd_port,__lcd_rd     ;RD=1
    cbi   __lcd_port,__lcd_rs     ;RS=0
__lcd_busy:
	RCALL __lcd_delay_G100
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G100
    in    r26,__lcd_pin
    cbi   __lcd_port,__lcd_enable ;EN=0
	RCALL __lcd_delay_G100
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G100
    cbi   __lcd_port,__lcd_enable ;EN=0
    sbrc  r26,__lcd_busy_flag
    rjmp  __lcd_busy
	RET
; .FEND
__lcd_write_nibble_G100:
; .FSTART __lcd_write_nibble_G100
    andi  r26,0xf0
    or    r26,r27
    out   __lcd_port,r26          ;write
    sbi   __lcd_port,__lcd_enable ;EN=1
	CALL __lcd_delay_G100
    cbi   __lcd_port,__lcd_enable ;EN=0
	CALL __lcd_delay_G100
	RET
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
    cbi  __lcd_port,__lcd_rd 	  ;RD=0
    in    r26,__lcd_direction
    ori   r26,0xf0 | (1<<__lcd_rs) | (1<<__lcd_rd) | (1<<__lcd_enable) ;set as output
    out   __lcd_direction,r26
    in    r27,__lcd_port
    andi  r27,0xf
    ld    r26,y
	RCALL __lcd_write_nibble_G100
    ld    r26,y
    swap  r26
	RCALL __lcd_write_nibble_G100
    sbi   __lcd_port,__lcd_rd     ;RD=1
	JMP  _0x20C0004
; .FEND
__lcd_read_nibble_G100:
; .FSTART __lcd_read_nibble_G100
    sbi   __lcd_port,__lcd_enable ;EN=1
	CALL __lcd_delay_G100
    in    r30,__lcd_pin           ;read
    cbi   __lcd_port,__lcd_enable ;EN=0
	CALL __lcd_delay_G100
    andi  r30,0xf0
	RET
; .FEND
_lcd_read_byte0_G100:
; .FSTART _lcd_read_byte0_G100
	CALL __lcd_delay_G100
	RCALL __lcd_read_nibble_G100
    mov   r26,r30
	RCALL __lcd_read_nibble_G100
    cbi   __lcd_port,__lcd_rd     ;RD=0
    swap  r30
    or    r30,r26
	RET
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R26
	CALL __lcd_ready
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G100)
	SBCI R31,HIGH(-__base_y_G100)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	CALL __lcd_write_data
	LDD  R6,Y+1
	LDD  R9,Y+0
	ADIW R28,2
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	CALL __lcd_ready
	LDI  R26,LOW(2)
	CALL __lcd_write_data
	CALL __lcd_ready
	LDI  R26,LOW(12)
	CALL __lcd_write_data
	CALL __lcd_ready
	LDI  R26,LOW(1)
	CALL __lcd_write_data
	LDI  R30,LOW(0)
	MOV  R9,R30
	MOV  R6,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R26
    push r30
    push r31
    ld   r26,y
    set
    cpi  r26,10
    breq __lcd_putchar1
    clt
	CP   R6,R8
	BRLO _0x2000004
	__lcd_putchar1:
	INC  R9
	LDI  R30,LOW(0)
	ST   -Y,R30
	MOV  R26,R9
	RCALL _lcd_gotoxy
	brts __lcd_putchar0
_0x2000004:
	INC  R6
    rcall __lcd_ready
    sbi  __lcd_port,__lcd_rs ;RS=1
	LD   R26,Y
	CALL __lcd_write_data
__lcd_putchar0:
    pop  r31
    pop  r30
	JMP  _0x20C0004
; .FEND
_lcd_puts:
; .FSTART _lcd_puts
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x2000005:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2000007
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2000005
_0x2000007:
	RJMP _0x20C0005
; .FEND
_lcd_putsf:
; .FSTART _lcd_putsf
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x2000008:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,1
	STD  Y+1,R30
	STD  Y+1+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x200000A
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2000008
_0x200000A:
_0x20C0005:
	LDD  R17,Y+0
	ADIW R28,3
	RET
; .FEND
__long_delay_G100:
; .FSTART __long_delay_G100
    clr   r26
    clr   r27
__long_delay0:
    sbiw  r26,1         ;2 cycles
    brne  __long_delay0 ;2 cycles
	RET
; .FEND
__lcd_init_write_G100:
; .FSTART __lcd_init_write_G100
	ST   -Y,R26
    cbi  __lcd_port,__lcd_rd 	  ;RD=0
    in    r26,__lcd_direction
    ori   r26,0xf7                ;set as output
    out   __lcd_direction,r26
    in    r27,__lcd_port
    andi  r27,0xf
    ld    r26,y
	CALL __lcd_write_nibble_G100
    sbi   __lcd_port,__lcd_rd     ;RD=1
	RJMP _0x20C0004
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R26
    cbi   __lcd_port,__lcd_enable ;EN=0
    cbi   __lcd_port,__lcd_rs     ;RS=0
	LDD  R8,Y+0
	LD   R30,Y
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G100,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G100,3
	CALL SUBOPT_0x5
	CALL SUBOPT_0x5
	CALL SUBOPT_0x5
	RCALL __long_delay_G100
	LDI  R26,LOW(32)
	RCALL __lcd_init_write_G100
	RCALL __long_delay_G100
	LDI  R26,LOW(40)
	CALL SUBOPT_0x6
	LDI  R26,LOW(4)
	CALL SUBOPT_0x6
	LDI  R26,LOW(133)
	CALL SUBOPT_0x6
    in    r26,__lcd_direction
    andi  r26,0xf                 ;set as input
    out   __lcd_direction,r26
    sbi   __lcd_port,__lcd_rd     ;RD=1
	CALL _lcd_read_byte0_G100
	CPI  R30,LOW(0x5)
	BREQ _0x200000B
	LDI  R30,LOW(0)
	RJMP _0x20C0004
_0x200000B:
	CALL __lcd_ready
	LDI  R26,LOW(6)
	CALL __lcd_write_data
	CALL _lcd_clear
	LDI  R30,LOW(1)
_0x20C0004:
	ADIW R28,1
	RET
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_get_buff_G101:
; .FSTART _get_buff_G101
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LDI  R30,LOW(0)
	ST   X,R30
	LDD  R26,Y+3
	LDD  R27,Y+3+1
	LD   R30,X
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x20200C1
	LDI  R30,LOW(0)
	ST   X,R30
	RJMP _0x20200C2
_0x20200C1:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	ADIW R26,1
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x20200C3
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	LDD  R26,Z+1
	LDD  R27,Z+2
	LD   R30,X
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x20200C4
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	ADIW R26,1
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
_0x20200C4:
	RJMP _0x20200C5
_0x20200C3:
	LDI  R17,LOW(0)
_0x20200C5:
_0x20200C2:
	MOV  R30,R17
	LDD  R17,Y+0
	ADIW R28,5
	RET
; .FEND
__scanf_G101:
; .FSTART __scanf_G101
	PUSH R15
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,4
	CALL __SAVELOCR6
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	STD  Y+8,R30
	STD  Y+8+1,R31
	MOV  R20,R30
_0x20200C6:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	ADIW R30,1
	STD  Y+16,R30
	STD  Y+16+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R19,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x20200C8
	CALL SUBOPT_0x7
	BREQ _0x20200C9
_0x20200CA:
	IN   R30,SPL
	IN   R31,SPH
	ST   -Y,R31
	ST   -Y,R30
	PUSH R20
	CALL SUBOPT_0x8
	POP  R20
	MOV  R19,R30
	CPI  R30,0
	BREQ _0x20200CD
	CALL SUBOPT_0x7
	BRNE _0x20200CE
_0x20200CD:
	RJMP _0x20200CC
_0x20200CE:
	CALL SUBOPT_0x9
	BRGE _0x20200CF
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20C0002
_0x20200CF:
	RJMP _0x20200CA
_0x20200CC:
	MOV  R20,R19
	RJMP _0x20200D0
_0x20200C9:
	CPI  R19,37
	BREQ PC+2
	RJMP _0x20200D1
	LDI  R21,LOW(0)
_0x20200D2:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LPM  R19,Z+
	STD  Y+16,R30
	STD  Y+16+1,R31
	CPI  R19,48
	BRLO _0x20200D6
	CPI  R19,58
	BRLO _0x20200D5
_0x20200D6:
	RJMP _0x20200D4
_0x20200D5:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R19
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x20200D2
_0x20200D4:
	CPI  R19,0
	BRNE _0x20200D8
	RJMP _0x20200C8
_0x20200D8:
_0x20200D9:
	IN   R30,SPL
	IN   R31,SPH
	ST   -Y,R31
	ST   -Y,R30
	PUSH R20
	CALL SUBOPT_0x8
	POP  R20
	MOV  R18,R30
	MOV  R26,R30
	CALL _isspace
	CPI  R30,0
	BREQ _0x20200DB
	CALL SUBOPT_0x9
	BRGE _0x20200DC
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20C0002
_0x20200DC:
	RJMP _0x20200D9
_0x20200DB:
	CPI  R18,0
	BRNE _0x20200DD
	RJMP _0x20200DE
_0x20200DD:
	MOV  R20,R18
	CPI  R21,0
	BRNE _0x20200DF
	LDI  R21,LOW(255)
_0x20200DF:
	MOV  R30,R19
	CPI  R30,LOW(0x63)
	BRNE _0x20200E3
	CALL SUBOPT_0xA
	IN   R30,SPL
	IN   R31,SPH
	ST   -Y,R31
	ST   -Y,R30
	PUSH R20
	CALL SUBOPT_0x8
	POP  R20
	MOVW R26,R16
	ST   X,R30
	CALL SUBOPT_0x9
	BRGE _0x20200E4
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20C0002
_0x20200E4:
	RJMP _0x20200E2
_0x20200E3:
	CPI  R30,LOW(0x73)
	BRNE _0x20200ED
	CALL SUBOPT_0xA
_0x20200E6:
	MOV  R30,R21
	SUBI R21,1
	CPI  R30,0
	BREQ _0x20200E8
	IN   R30,SPL
	IN   R31,SPH
	ST   -Y,R31
	ST   -Y,R30
	PUSH R20
	CALL SUBOPT_0x8
	POP  R20
	MOV  R19,R30
	CPI  R30,0
	BREQ _0x20200EA
	CALL SUBOPT_0x7
	BREQ _0x20200E9
_0x20200EA:
	CALL SUBOPT_0x9
	BRGE _0x20200EC
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20C0002
_0x20200EC:
	RJMP _0x20200E8
_0x20200E9:
	PUSH R17
	PUSH R16
	__ADDWRN 16,17,1
	MOV  R30,R19
	POP  R26
	POP  R27
	ST   X,R30
	RJMP _0x20200E6
_0x20200E8:
	MOVW R26,R16
	LDI  R30,LOW(0)
	ST   X,R30
	RJMP _0x20200E2
_0x20200ED:
	SET
	BLD  R15,1
	CLT
	BLD  R15,2
	MOV  R30,R19
	CPI  R30,LOW(0x64)
	BREQ _0x20200F2
	CPI  R30,LOW(0x69)
	BRNE _0x20200F3
_0x20200F2:
	CLT
	BLD  R15,1
	RJMP _0x20200F4
_0x20200F3:
	CPI  R30,LOW(0x75)
	BRNE _0x20200F5
_0x20200F4:
	LDI  R18,LOW(10)
	RJMP _0x20200F0
_0x20200F5:
	CPI  R30,LOW(0x78)
	BRNE _0x20200F6
	LDI  R18,LOW(16)
	RJMP _0x20200F0
_0x20200F6:
	CPI  R30,LOW(0x25)
	BRNE _0x20200F9
	RJMP _0x20200F8
_0x20200F9:
	RJMP _0x20C0003
_0x20200F0:
	LDI  R30,LOW(0)
	STD  Y+6,R30
	STD  Y+6+1,R30
	SET
	BLD  R15,0
_0x20200FA:
	MOV  R30,R21
	SUBI R21,1
	CPI  R30,0
	BRNE PC+2
	RJMP _0x20200FC
	IN   R30,SPL
	IN   R31,SPH
	ST   -Y,R31
	ST   -Y,R30
	PUSH R20
	CALL SUBOPT_0x8
	POP  R20
	MOV  R19,R30
	CPI  R30,LOW(0x21)
	BRSH _0x20200FD
	CALL SUBOPT_0x9
	BRGE _0x20200FE
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20C0002
_0x20200FE:
	RJMP _0x20200FF
_0x20200FD:
	SBRC R15,1
	RJMP _0x2020100
	SET
	BLD  R15,1
	CPI  R19,45
	BRNE _0x2020101
	BLD  R15,2
	RJMP _0x20200FA
_0x2020101:
	CPI  R19,43
	BREQ _0x20200FA
_0x2020100:
	CPI  R18,16
	BRNE _0x2020103
	MOV  R26,R19
	CALL _isxdigit
	CPI  R30,0
	BREQ _0x20200FF
	RJMP _0x2020105
_0x2020103:
	MOV  R26,R19
	CALL _isdigit
	CPI  R30,0
	BRNE _0x2020106
_0x20200FF:
	SBRC R15,0
	RJMP _0x2020108
	MOV  R20,R19
	RJMP _0x20200FC
_0x2020106:
_0x2020105:
	CPI  R19,97
	BRLO _0x2020109
	SUBI R19,LOW(87)
	RJMP _0x202010A
_0x2020109:
	CPI  R19,65
	BRLO _0x202010B
	SUBI R19,LOW(55)
	RJMP _0x202010C
_0x202010B:
	SUBI R19,LOW(48)
_0x202010C:
_0x202010A:
	MOV  R30,R18
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R31,0
	CALL __MULW12U
	MOVW R26,R30
	MOV  R30,R19
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+6,R30
	STD  Y+6+1,R31
	CLT
	BLD  R15,0
	RJMP _0x20200FA
_0x20200FC:
	CALL SUBOPT_0xA
	SBRS R15,2
	RJMP _0x202010D
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL __ANEGW1
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x202010D:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	MOVW R26,R16
	ST   X+,R30
	ST   X,R31
_0x20200E2:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ADIW R30,1
	STD  Y+8,R30
	STD  Y+8+1,R31
	RJMP _0x202010E
_0x20200D1:
_0x20200F8:
	IN   R30,SPL
	IN   R31,SPH
	ST   -Y,R31
	ST   -Y,R30
	PUSH R20
	CALL SUBOPT_0x8
	POP  R20
	CP   R30,R19
	BREQ _0x202010F
	CALL SUBOPT_0x9
	BRGE _0x2020110
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20C0002
_0x2020110:
_0x20200DE:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	SBIW R30,0
	BRNE _0x2020111
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20C0002
_0x2020111:
	RJMP _0x20200C8
_0x202010F:
_0x202010E:
_0x20200D0:
	RJMP _0x20200C6
_0x20200C8:
_0x2020108:
_0x20C0003:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
_0x20C0002:
	CALL __LOADLOCR6
	ADIW R28,18
	POP  R15
	RET
; .FEND
_sscanf:
; .FSTART _sscanf
	PUSH R15
	MOV  R15,R24
	SBIW R28,3
	ST   -Y,R17
	ST   -Y,R16
	CALL SUBOPT_0xB
	SBIW R30,0
	BRNE _0x2020112
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20C0001
_0x2020112:
	MOVW R26,R28
	ADIW R26,1
	CALL __ADDW2R15
	MOVW R16,R26
	CALL SUBOPT_0xB
	STD  Y+3,R30
	STD  Y+3+1,R31
	MOVW R26,R28
	ADIW R26,5
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_get_buff_G101)
	LDI  R31,HIGH(_get_buff_G101)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,8
	RCALL __scanf_G101
_0x20C0001:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,5
	POP  R15
	RET
; .FEND

	.CSEG
_isdigit:
; .FSTART _isdigit
	ST   -Y,R26
    ldi  r30,1
    ld   r31,y+
    cpi  r31,'0'
    brlo isdigit0
    cpi  r31,'9'+1
    brlo isdigit1
isdigit0:
    clr  r30
isdigit1:
    ret
; .FEND
_isspace:
; .FSTART _isspace
	ST   -Y,R26
    ldi  r30,1
    ld   r31,y+
    cpi  r31,' '
    breq isspace1
    cpi  r31,9
    brlo isspace0
    cpi  r31,13+1
    brlo isspace1
isspace0:
    clr  r30
isspace1:
    ret
; .FEND
_isxdigit:
; .FSTART _isxdigit
	ST   -Y,R26
    ldi  r30,1
    ld   r31,y+
    subi r31,0x30
    brcs isxdigit0
    cpi  r31,10
    brcs isxdigit1
    andi r31,0x5f
    subi r31,7
    cpi  r31,10
    brcs isxdigit0
    cpi  r31,16
    brcs isxdigit1
isxdigit0:
    clr  r30
isxdigit1:
    ret
; .FEND

	.CSEG

	.CSEG

	.CSEG

	.DSEG

	.CSEG

	.ESEG
_pass:
	.BYTE 0x2
_j:
	.BYTE 0x2

	.DSEG
_key:
	.BYTE 0xA
__base_y_G100:
	.BYTE 0x4
__seed_G105:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x0:
	CALL _delay_ms
	JMP  _lcd_clear

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1:
	LDI  R26,LOW(_j)
	LDI  R27,HIGH(_j)
	CALL __EEPROMRDW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x2:
	CALL _enter_pass
	MOVW R0,R30
	LDI  R26,LOW(_pass)
	LDI  R27,HIGH(_pass)
	CALL __EEPROMRDW
	CP   R30,R0
	CPC  R31,R1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3:
	CALL _lcd_puts
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x4:
	LDI  R26,LOW(_key)
	LDI  R27,HIGH(_key)
	ADD  R26,R18
	ADC  R27,R19
	LD   R26,X
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5:
	CALL __long_delay_G100
	LDI  R26,LOW(48)
	JMP  __lcd_init_write_G100

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	CALL __lcd_write_data
	JMP  __long_delay_G100

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	MOV  R26,R19
	CALL _isspace
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x8:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x9:
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	LD   R26,X
	CPI  R26,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0xA:
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	SBIW R30,4
	STD  Y+14,R30
	STD  Y+14+1,R31
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	ADIW R26,4
	LD   R16,X+
	LD   R17,X
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB:
	MOVW R26,R28
	ADIW R26,7
	CALL __ADDW2R15
	CALL __GETW1P
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__PUTPARD1L:
	LDI  R22,0
	LDI  R23,0
__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__EEPROMRDW:
	ADIW R26,1
	RCALL __EEPROMRDB
	MOV  R31,R30
	SBIW R26,1

__EEPROMRDB:
	SBIC EECR,EEWE
	RJMP __EEPROMRDB
	PUSH R31
	IN   R31,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R30,EEDR
	OUT  SREG,R31
	POP  R31
	RET

__EEPROMWRW:
	RCALL __EEPROMWRB
	ADIW R26,1
	PUSH R30
	MOV  R30,R31
	RCALL __EEPROMWRB
	POP  R30
	SBIW R26,1
	RET

__EEPROMWRB:
	SBIS EECR,EEWE
	RJMP __EEPROMWRB1
	WDR
	RJMP __EEPROMWRB
__EEPROMWRB1:
	IN   R25,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R24,EEDR
	CP   R30,R24
	BREQ __EEPROMWRB0
	OUT  EEDR,R30
	SBI  EECR,EEMWE
	SBI  EECR,EEWE
__EEPROMWRB0:
	OUT  SREG,R25
	RET

__CPW01:
	CLR  R0
	CP   R0,R30
	CPC  R0,R31
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
