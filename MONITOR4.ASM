TOS  EQU  4000H        
LF   EQU  0AH       
CR   EQU  0DH       
     ORG  0        
RST0 LXI  SP,TOS               
     JMP  INIT           
     NOP         
     NOP         
RST1 PUSH PSW            
     PUSH H        
     PUSH D        
     PUSH B        
     LHLD SLI1            
     PCHL         
RST2 PUSH PSW            
     PUSH H        
     PUSH D        
     PUSH B        
     LHLD SLI2            
     PCHL         
RST3 PUSH PSW            
     PUSH H        
     PUSH D        
     PUSH B        
     LHLD SLI3            
     PCHL         
RST4 JMP  FLI4               
     NOP         
IN45 JMP  TRAP               
     NOP         
RST5 JMP  FLI5               
     NOP         
IN55 JMP  FL55               
     NOP         
RST6 JMP  FLI6               
     NOP         
IN65 JMP  FL65               
     NOP         
RST7 JMP  FLI7               
     NOP         
IN75 JMP  FL75               
     NOP         
FLI4 PUSH PSW            
     PUSH H        
     PUSH D        
     PUSH B        
     LHLD SLI4            
     PCHL         
TRAP PUSH PSW            
     PUSH H        
     PUSH D        
     PUSH B        
     LHLD SL45            
     PCHL         
FLI5 PUSH PSW            
     PUSH H        
     PUSH D        
     PUSH B        
     LHLD SLI5            
     PCHL         
FL55 PUSH PSW            
     PUSH H        
     PUSH D        
     PUSH B        
     LHLD SL55            
     PCHL         
FLI6 PUSH PSW            
     PUSH H        
     PUSH D        
     PUSH B        
     LHLD SLI6            
     PCHL         
FL65 PUSH PSW            
     PUSH H        
     PUSH D        
     PUSH B        
     LHLD SL65            
     PCHL         
FLI7 PUSH PSW            
     PUSH H        
     PUSH D        
     PUSH B        
     JMP  MNTR           
     NOP         
FL75 PUSH PSW            
     PUSH H        
     PUSH D        
     PUSH B        
     LHLD SL75            
     PCHL         
RETI POP  B           
     POP  D       
     POP  H       
     POP  PSW       
     EI         
     RET         
     NOP         
     NOP         
;    INITIALIZATION           
INIT MVI  A,00C0H             
     SIM         
     CALL BRID            
     NOP         
     NOP
;    MONITOR MAIN LOOP         
MNTR MVI  A,LF             
     CALL OUTC            
     MVI  A,CR         
     CALL OUTC            
     MVI  A,'?'         
     CALL OUTC            
     CALL INPC            
     CPI  'L'         
     JZ   LD          
     CPI  'D'         
     JZ   DP          
     CPI  CR         
     JZ   R5          
     CPI  'G'         
     JZ   G          
     CPI  'R'         
     JZ   R          
     CPI  'Q'         
     JZ   RETI          
     CPI  'M'         
     JZ   MV          
     CPI  'F'         
     JZ   F          
     CPI  'I'         
     JZ   I          
     CPI  'S'         
     JZ   S          
     CPI  'U'         
     JZ   U          
     CPI  'A'         
     JZ   AS          
     JMP  MNTR           
;    INSERT ROUTINE          
I    CALL HLHX             
     MVI  A,' '        
     CALL OUTC            
INXX CALL GTHX               
     MOV  M,A       
     INX  H       
     CALL INPC            
     CPI  ' '        
     JZ   INXX          
     JMP  MNTR           
;    DISPLAY ROUTINE          
DP   CALL HLHX             
D3   MVI  A,' '          
     CALL OUTC            
     MVI  E,16         
DNX  MOV  A,M          
     CALL PTHX            
     INX  H       
     DCR  E       
     MOV  A,M       
     CALL PTHX            
     INX  H       
     MVI  A,' '        
     CALL OUTC            
     DCR  E       
     JNZ  DNX           
     JMP  MNTR           
;    REGISTERS           
R    XRA  A        
     MOV  H,A       
     MOV  L,A       
     DAD  SP       
R5   MOV  A,H         
     CALL PTHX            
     MOV  A,L       
     CALL PTHX            
     JMP  D3           
;    GOTO EXEC          
G    CALL HLHX             
     EI         
     PCHL         
;    MOVE MEMORY          
MV   CALL HLHX             
     PUSH H        
     MVI  A,' '        
     CALL OUTC            
     CALL HLHX            
     PUSH H        
     MVI  A,' '        
     CALL OUTC            
     CALL HLHX            
     POP  D       
     POP  B       
     CALL MOVE            
     JMP  MNTR           
MOVE LDAX B            
     MOV  M,A       
     INX  B       
     INX  H       
     DCX  D       
     MOV  A,E       
     ORA  D       
     JNZ  MOVE           
     RET         
;    FILL MEMORY          
F    CALL HLHX             
     PUSH H        
     MVI  A,' '        
     CALL OUTC            
     CALL HLHX            
     PUSH H        
     MVI  A,' '        
     CALL OUTC            
     CALL GTHX            
     MOV  C,A       
     POP  D       
     POP  H       
     CALL FILL            
     JMP  MNTR           
FILL MOV  M,C           
     INX  H       
     DCX  D       
     MOV  A,E       
     ORA  D       
     JNZ  FILL           
     RET         
;    PUT OUT HEX         
PTHX MOV  D,A           
     RAR         
     RAR         
     RAR         
     RAR         
     CALL OTHX            
     MOV  A,D       
     CALL OTHX            
     RET         
OTHX ANI  0FH             
     CPI  10         
     JM   HXNM          
     ADI  7         
HXNM ADI  30H             
     CALL OUTC            
     RET         
;    GET HEX IN         
GTHX CALL CNHX                
     ANI  0FH         
     ADD  A       
     ADD  A       
     ADD  A       
     ADD  A       
     MOV  E,A       
     CALL CNHX            
     ANI  0FH         
     ORA  E       
     RET         
CNHX CALL INPC                
     CPI  40H         
     RM         
     ADI  9         
     RET         
HLHX CALL GTHX                
     MOV  H,A       
     CALL GTHX            
     MOV  L,A       
     RET         
;    LOAD S-RECORD INPUT        
LD   CALL INPC             
     CPI  'S'         
     JNZ  L           
     CALL INPC            
     CPI  '9'         
     JZ   S9          
     CALL GTHX            
     MOV  C,A       
     CALL HLHX            
     DCR  C       
     DCR  C       
SX   DCR  C         
     JZ   SY          
     CALL GTHX            
     MOV  M,A       
     INX  H       
     JMP  SX           
SY   CALL GTHX              
     JMP  L           
S9   CALL GTHX              
     MOV  C,A       
     DCR  C       
SO   CALL GTHX              
     DCR  C       
     JNZ  SO           
     JMP  MNTR           
;    SEND S-RECORD OUTPUT        
S    CALL HLHX             
     PUSH H        
     MVI  A,20H         
     CALL OUTC            
     CALL HLHX            
     SHLD TBC            
     POP  H       
XNEW MVI  A,CR             
     CALL OUTC            
     MVI  A,LF         
     CALL OUTC            
     MOV  A,H       
     STA  SADE           
     MOV  A,L       
     STA  SADF           
     MVI  A,0         
     MVI  E,3         
     ADD  H       
     ADD  L       
     MOV  D,A       
     LXI  B,CD           
XLOP MOV  A,M           
     STAX B        
     ADD  D       
     MOV  D,A       
     INX  H       
     INX  B       
     PUSH H        
     LHLD TBC            
     DCX  H       
     SHLD TBC            
     MOV  A,H       
     ORA  L       
     JZ   XFNS          
     POP  H       
     INR  E       
     MOV  A,E       
     CPI  13H         
     JNZ  XLOP           
     CALL XREC            
     JMP  XNEW           
XFNS CALL XREC                
     MVI  A,LF         
     CALL OUTC            
     MVI  A,CR         
     CALL OUTC            
     MVI  D,10         
     LXI  B,XLST           
XFNX LDAX B            
     CALL OUTC            
     INX  B       
     DCR  D       
     JNZ  XFNX           
     POP  H       
     JMP  MNTR           
XREC PUSH H            
     MOV  A,D       
     ADD  E       
     STA  CRC           
     MOV  A,E       
     STA  SBC           
     MVI  A,'S'         
     CALL OUTC            
     MVI  A,'1'         
     CALL OUTC            
     LXI  H,SBC           
XNXT MOV  A,M           
     CALL PTHX            
     INX  H       
     DCR  E       
     JNZ  XNXT           
     LDA  CRC           
     CALL PTHX            
     POP  H       
     RET         
XLST DB   'S'          
     DB   '9'      
     DB   '0'      
     DB   '3'      
     DB   '0'      
     DB   '0'      
     DB   '0'      
     DB   '0'      
     DB   'F'      
     DB   'C'      
;    OUTPUT CALL         
OUTC PUSH B           
     MOV  C,A       
     CALL COUT            
     MOV  A,C       
     POP  B       
     RET         
;    INPUT CALL        
INPC PUSH B           
     CALL CINP            
     MOV  A,C       
     ANI  7FH         
     POP  B       
     RET         
     NOP         
;    CONSOLE INPUT ROUTINE        
CINP DI             
     PUSH H        
     MVI  B,9         
CI1  RIM            
     ORA  A       
     JM   CI1          
     LHLD HALF            
CI2  DCR  L          
     JNZ  CI2           
     DCR  H       
     JNZ  CI2           
CI3  LHLD FULL               
CI4  DCR  L          
     JNZ  CI4           
     DCR  H       
     JNZ  CI4           
     RIM         
     RAL         
     DCR  B       
     JZ   CI5          
     MOV  A,C       
     RAR         
     MOV  C,A       
     NOP         
     JMP  CI3           
CI5  POP  H          
     EI         
     RET         
     NOP         
     NOP         
;    CONSOLE OUTPUT ROUTINE        
COUT DI             
     PUSH B        
     PUSH H        
     MVI  B,11         
     XRA  A       
CO1  MVI  A,80H            
     RAR         
     SIM         
     LHLD FULL            
CO2  DCR  L          
     JNZ  CO2           
     DCR  H       
     JNZ  CO2           
     STC         
     MOV  A,C       
     RAR         
     MOV  C,A       
     DCR  B       
     JNZ  CO1           
     POP  H       
     POP  B       
     EI         
     RET         
     NOP         
     NOP         
;    AUTO BPS RATE DETECT       
BRID RIM             
     ORA  A       
     JP   BRID          
BR1  RIM            
     ORA  A       
     JM   BR1          
     LXI  H,0FFFAH           
BR3  MVI  E,4            
BR4  DCR  E          
     JNZ  BR4           
     INX  H       
     RIM         
     ORA  A       
     JP   BR3          
     PUSH H        
     INR  H       
     INR  L       
     SHLD FULL            
     POP  H       
     ORA  A       
     MOV  A,H       
     RAR         
     MOV  H,A       
     MOV  A,L       
     RAR         
     MOV  L,A       
     INR  H       
     INR  L       
     SHLD HALF            
     RET   
;    LINE ASSEMBLER CODE  
     ORG  0400H     
AS   LXI  H,0FFECH            
     DAD  SP       
     SPHL         
     PUSH H        
     MOV  B,H       
     MOV  C,L       
     CALL HLHX            
     PUSH H        
     MVI  A,10         
     CALL OUTC            
     MVI  A,13         
     CALL OUTC            
     MOV  H,B       
     MOV  L,C       
A001 CALL ALIN                
     MOV  C,A       
     MOV  D,B       
     MOV  A,M       
     CPI  '@'         
     JZ   A099          
     MOV  A,C       
     CALL ASCH            
     CPI  0         
     JZ   A002          
     CALL ANXT            
     JMP  A022           
A002 MOV  A,D           
     CALL ASCH            
     CPI  0         
     JZ   A003          
     CALL ANXT            
     JMP  A022           
A003 MVI  A,1             
     CALL ASCH            
     CPI  0         
     JZ   A004          
     INX  H       
     JMP  A022           
A004 MVI  A,'?'             
     CALL OUTC            
     JMP  A001           
A022 POP  D           
     CALL ASSM            
     POP  H       
     PUSH H        
     PUSH D        
     JMP  A001           
A099 LXI  H,24               
     DAD  SP       
     SPHL         
     JMP  MNTR           
ASCH PUSH D            
     PUSH H        
     LXI  B,INST           
     MOV  E,A       
AS01 INX  B           
     LDAX B        
     DCX  B       
     CMP  E       
     JNZ  AS22           
     PUSH D        
     PUSH H        
     PUSH B        
     INX  B       
     INX  B       
AS02 MVI  A,0             
     CMP   E       
     JZ   AS33          
     LDAX B        
     CMP  M       
     JNZ  AS33           
     DCR  E       
     INX  B       
     INX  H       
     JMP  AS02           
AS33 MOV  A,E           
     POP  B       
     POP  H       
     POP  D       
     CPI  0         
     JZ   AS03          
AS22 PUSH H            
     MOV  H,B       
     MOV  L,C       
     INX  B       
     LDAX B        
     ADI  3         
     MVI  B,0         
     MOV  C,A       
     DAD  B       
     MOV  B,H       
     MOV  C,L       
     LXI  H,TEND           
     MOV  A,H       
     CMP  B       
     JNZ  AS05           
     MOV  A,L       
     CMP  C       
     JNZ  AS05           
     POP  H       
     MVI  A,0         
     JMP  AS04           
AS05 POP  H           
     JMP  AS01           
AS03 MVI  A,1             
AS04 POP  H           
     POP  D       
     RET         
ALIN PUSH H            
     PUSH D        
     MVI  B,0         
     MVI  E,0         
     MVI  D,0         
AL01 CALL INPC                
     CPI  13         
     JZ   AL99          
     MOV  M,A       
     INR  E       
     INX  H       
     CPI  ','         
     JNZ  AL02           
     MVI  D,1         
     JMP  AL01           
AL02 CPI  ' '            
     JNZ  AL03           
     MVI  D,1         
     JMP  AL01           
AL03 MOV  A,D           
     CPI  0         
     JNZ  AL01           
     INR  B       
     JMP  AL01           
AL99 MVI  A,10             
     CALL OUTC            
     MOV  A,E       
     POP  D       
     POP  H       
     RET         
ANXT PUSH PSW            
     PUSH B        
     MVI  B,20         
AX01 MOV  A,M           
     CPI  ','         
     JZ   AX99          
     CPI  ' '        
     JZ   AX99          
     INX  H       
     DCR  B       
     JNZ  AX01           
AX99 INX  H           
     POP  B       
     POP  PSW       
     RET         
ANUM PUSH H            
     PUSH B        
     MOV  A,M       
     CPI  41H         
     JM   AN01          
     SUI  37H         
     JMP  AN02           
AN01 SUI  30H             
AN02 RLC             
     RLC         
     RLC         
     RLC         
     MOV  B,A       
     INX  H       
     MOV  A,M       
     CPI  41H         
     JM   AN03          
     SUI  37H         
     JMP  AN04           
AN03 SUI  30H             
AN04 ORA  B           
     POP  B       
     POP  H       
     RET         
ATBL PUSH H            
     PUSH B        
     MOV  H,A       
     MVI  L,0         
AT01 MOV  A,L           
     CMP  H       
     JZ   AT33          
     MOV  A,E       
     CPI  0         
     MOV  A,L       
     JZ   AT02          
     RLC         
AT02 POP  B           
     PUSH B        
     PUSH H        
     MOV  H,B       
     MOV  L,C       
     MOV  C,A       
     MVI  B,0         
     DAD  B       
     MOV  B,H       
     MOV  C,L       
     POP  H       
     LDAX B        
     CMP  D       
     JNZ  AT22           
     MVI  A,0         
     CMP  E       
     JZ   AT44          
     INX  B       
     LDAX B        
     CMP  E       
     JZ   AT44          
AT22 INR  L           
     JMP  AT01           
AT33 DCR  L           
AT44 MOV  A,L           
     POP  B       
     POP  H       
     RET         
ASSM PUSH D            
     LDAX B        
     STAX D        
     MOV  D,A       
     MVI  E,1         
AM01 PUSH H            
     PUSH B        
     MOV  H,B       
     MOV  L,C       
     INX  H       
     MOV  A,M       
     MOV  C,A       
     MVI  B,0         
     DAD  B       
     INX  H       
     MOV  B,M       
     MVI  A,1         
     CMP  E       
     JNZ  AM02           
     MOV  A,B       
     ANI  0F0H         
     RRC         
     RRC         
     RRC         
     RRC         
     JMP  AM03           
AM02 MOV  A,B           
     ANI  0FH         
AM03 POP  B           
     POP  H       
     CPI  0         
     JNZ  AM04           
     CALL ANXT            
     JMP  AM44           
AM04 CPI  1             
     JNZ  AM05           
     PUSH B        
     PUSH D        
     LXI  B,PAIR           
     MVI  A,4         
     MOV  D,M       
     MVI  E,0         
     CALL ATBL            
     POP  D       
     POP  B       
     RLC         
     RLC         
     RLC         
     RLC         
     ORA  D       
     MOV  D,A       
     CALL ANXT            
     XTHL         
     MOV  M,A       
     XTHL         
     JMP  AM44           
AM05 CPI  2             
     JNZ  AM06           
     PUSH B        
     PUSH D        
     LXI  B,CCOD           
     MVI  A,8         
     MOV  D,M       
     INX  H       
     MOV  E,M       
     CALL ATBL            
     POP  D       
     POP  B       
     RLC         
     RLC         
     RLC         
     ORA  D       
     MOV  D,A       
     CALL ANXT            
     XTHL         
     MOV  M,A       
     XTHL         
     JMP  AM44           
AM06 CPI  3             
     JNZ  AM07           
     CALL ANUM            
     RLC         
     RLC         
     RLC         
     ORA  D       
     MOV  D,A       
     CALL ANXT            
     XTHL         
     MOV  M,A       
     XTHL         
     JMP  AM44           
AM07 CPI  4             
     JNZ  AM08           
     XTHL         
     MOV  M,D       
     INX  H       
     XTHL         
     CALL ANUM            
     XTHL         
     MOV  M,A       
     XTHL         
     JMP  AM44           
AM08 CPI  5             
     JNZ  AM09           
     XTHL         
     MOV  M,D       
     INX  H       
     XTHL         
     CALL ANUM            
     XTHL         
     INX  H       
     MOV  M,A       
     XTHL         
     INX  H       
     INX  H       
     CALL ANUM            
     XTHL         
     DCX  H       
     MOV  M,A       
     INX  H       
     XTHL         
     JMP  AM44           
AM09 CPI  6             
     JNZ  AM10           
     PUSH B        
     PUSH D        
     LXI  B,REGS           
     MVI  A,8         
     MOV  D,M       
     MVI  E,0         
     CALL ATBL            
     POP  D       
     POP  B       
     ORA  D       
     MOV  D,A       
     CALL ANXT            
     XTHL         
     MOV  M,A       
     XTHL         
     JMP  AM44           
AM10 PUSH B            
     PUSH D        
     LXI  B,REGS           
     MVI  A,8         
     MOV  D,M       
     MVI  E,0         
     CALL ATBL            
     RLC         
     RLC         
     RLC         
     POP  D       
     POP  B       
     ORA  D       
     MOV  D,A       
     CALL ANXT            
     XTHL         
     MOV  M,A       
     XTHL         
AM44 MVI  A,2             
     CMP  E       
     JZ   AM45          
     INR  E       
     JMP  AM01           
AM45 POP  D           
     INX  D       
     RET         
;    DISASSEMBLER ROUTINE - U    
     ORG  0700H     
U    CALL HLHX             
     PUSH H        
     MVI  A,' '        
     CALL OUTC            
     CALL HLHX            
     MVI  A,LF         
     CALL OUTC            
     MVI  A,CR         
     CALL OUTC            
     POP  D       
U001 PUSH H            
     PUSH D        
     MOV  A,D       
     CALL PTHX            
     MOV  A,E       
     CALL PTHX            
     POP  D       
     MVI  A,' '        
     CALL OUTC            
     MVI  C,0FFH         
     LDAX D        
     MOV  B,A       
     CALL USCH            
     CPI  1         
     JNZ  U002           
     CALL UDI            
     JMP  U003           
U002 MOV  A,B           
     RLC         
     RLC         
     ANI  3         
     CPI  1         
     JNZ  U004           
     MVI  C,0C0H         
     JMP  U007           
U004 CPI  2             
     JNZ  U005           
     MVI  C,0F8H         
     JMP  U007           
U005 CPI  3             
     JNZ  U006           
     MVI  C,0C7H         
     JMP  U007           
U006 MOV  A,B           
     ANI  4         
     JNZ  U009           
     MVI  C,0CFH         
     JMP  U007           
U009 MVI  C,0C7H             
U007 CALL USCH                
     CPI  1         
     JNZ  U008           
     CALL UDI            
     JMP  U003           
U008 MVI  A,'?'             
     CALL OUTC            
     INX  D       
U003 MVI  A,CR             
     CALL OUTC            
     MVI  A,LF         
     CALL OUTC            
     POP  H       
     PUSH H        
     MOV  A,D       
     CMA         
     MOV  B,A       
     MOV  A,E       
     CMA         
     MOV  C,A       
     INX  B       
     DAD  B       
     MOV  A,H       
     POP  H       
     ANA  C     ; ?????      
     JP   U001          
     JMP  MNTR           
;    SUBROUTINE USCH SEARCHES TABLE FOR MATCHING OPCODE     
USCH PUSH B            
     PUSH D        
     LXI  H,INST           
     MOV  A,B       
     ANA  C       
     MOV  B,A       
     MVI  C,0         
US01 MOV  A,M           
     INX  H       
     CMP  B       
     JNZ  US02           
     MVI  C,1         
     JMP  US99           
US02 MOV  E,M           
     MVI  D,0         
     DAD  D       
     MVI  E,2         
     DAD  D       
     LXI  D,TEND           
     MOV  A,D       
     CMP  H       
     JNZ  US01           
     MOV  A,E       
     CMP  L       
     JNZ  US01           
US99 MOV  A,C           
     POP  D       
     POP  B       
     RET         
;    SUBROUTINE UDI DISPLAYS A SINGLE INSTRUCTION AND                      
UDI  PUSH B           
     PUSH H        
     MOV  C,M       
     INX  H       
     CALL UDW            
     MVI  A,' '        
     CALL OUTC            
     MVI  B,0         
     DAD  B       
     MVI  B,1         
UD01 MOV  A,B           
     PUSH B        
     CPI  1         
     JNZ  UD02           
     MOV  A,M       
     RRC         
     RRC         
     RRC         
     RRC         
     JMP  UD03           
UD02 MOV  A,M           
UD03 ANI  0FH             
     CPI  0         
     JZ   UD22          
     CPI  1         
     JNZ  UD04           
     LDAX D        
     ANI  30H         
     RRC         
     RRC         
     RRC         
     RRC         
     PUSH H        
     LXI  H,PAIR           
     MOV  C,A       
     MVI  B,0         
     DAD  B       
     MOV  A,M       
     POP  H       
     CALL OUTC            
     JMP  UD22           
UD04 CPI  2             
     JNZ  UD05           
     LDAX D        
     ANI  38H         
     RRC         
     RRC         
     PUSH H        
     LXI  H,CCOD           
     MOV  C,A       
     MVI  B,0         
     DAD  B       
     MVI  A,8         
     CALL OUTC            
     MOV  A,M       
     CALL OUTC            
     INX  H       
     MOV  A,M       
     CALL OUTC            
     POP  H       
     JMP  UD22           
UD05 CPI  3             
     JNZ  UD06           
     LDAX D        
     ANI  38H         
     RRC         
     RRC         
     RRC         
     ADI  30H         
     CALL OUTC            
     JMP  UD22           
UD06 CPI  4             
     JNZ  UD07           
     INX  D       
     LDAX D        
     PUSH D        
     CALL PTHX            
     POP  D       
     JMP  UD22           
UD07 CPI  5             
     JNZ  UD08           
     INX  D       
     INX  D       
     LDAX D        
     PUSH D        
     CALL PTHX            
     POP  D       
     DCX  D       
     LDAX D        
     PUSH D        
     CALL PTHX            
     POP  D       
     INX  D       
     JMP  UD22           
UD08 CPI  6             
     JNZ  UD09           
     LDAX D        
     ANI  07H         
     PUSH H        
     LXI  H,REGS           
     MOV  C,A       
     MVI  B,0         
     DAD  B       
     MOV  A,M       
     POP  H       
     CALL OUTC            
     JMP  UD22           
UD09 LDAX D            
     ANI  38H         
     RRC         
     RRC         
     RRC         
     PUSH H        
     LXI  H,REGS           
     MOV  C,A       
     MVI  B,0         
     DAD  B       
     MOV  A,M       
     POP  H       
     CALL OUTC            
UD22 MVI  A,' '            
     CALL OUTC            
     POP  B       
     INR  B       
     MVI  A,3         
     CMP  B       
     JNZ  UD01           
     POP  H       
     POP  B       
     INX  D       
     RET         
;    SUBROUTINE UDW OUTPUTS A SPECIFIED STRING OF ASCII                     
UDW  PUSH B           
     PUSH H        
UW01 MOV  A,M           
     CALL OUTC            
     INX  H       
     DCR  C       
     JNZ  UW01           
     POP  H       
     POP  B       
     RET         
;    TABLES FOR ASSEMBLER DISASSEMBLER   
     ORG  0900H 
PAIR DB   'B'          
     DB   'D'      
     DB   'H'      
     DB   'S'      
CCOD DB   'N'          
     DB   'Z'      
     DB   'Z'      
     DB   ' '     
     DB   'N'      
     DB   'C'      
     DB   'C'      
     DB   ' '     
     DB   'P'      
     DB   'O'      
     DB   'P'      
     DB   'E'      
     DB   'P'      
     DB   ' '     
     DB   'M'      
     DB   ' '     
REGS DB   'B'          
     DB   'C'      
     DB   'D'      
     DB   'E'      
     DB   'H'      
     DB   'L'      
     DB   'M'      
     DB   'A'      
INST DB   40H          
     DB   3      
     DB   'M'      
     DB   'O'      
     DB   'V'      
     DB   76H      
     DB   0EBH      
     DB   4      
     DB   'X'      
     DB   'C'      
     DB   'H'      
     DB   'G'      
     DB   0      
     DB   06H      
     DB   3      
     DB   'M'      
     DB   'V'      
     DB   'I'      
     DB   74H      
     DB   01H      
     DB   3      
     DB   'L'      
     DB   'X'      
     DB   'I'      
     DB   15H      
     DB   3AH      
     DB   3      
     DB   'L'      
     DB   'D'      
     DB   'A'      
     DB   50H      
     DB   2AH      
     DB   4      
     DB   'L'      
     DB   'H'      
     DB   'L'      
     DB   'D'      
     DB   50H      
     DB   1AH      
     DB   6      
     DB   'L'      
     DB   'D'      
     DB   'A'      
     DB   'X'      
     DB   ' '     
     DB   'D'      
     DB   0      
     DB   0AH      
     DB   6      
     DB   'L'      
     DB   'D'      
     DB   'A'      
     DB   'X'      
     DB   ' '     
     DB   'B'      
     DB   0      
     DB   32H      
     DB   3      
     DB   'S'      
     DB   'T'      
     DB   'A'      
     DB   50H      
     DB   22H      
     DB   4      
     DB   'S'      
     DB   'H'      
     DB   'L'      
     DB   'D'      
     DB   50H      
     DB   12H      
     DB   6      
     DB   'S'      
     DB   'T'      
     DB   'A'      
     DB   'X'      
     DB   ' '     
     DB   'D'      
     DB   0      
     DB   02H      
     DB   6      
     DB   'S'      
     DB   'T'      
     DB   'A'      
     DB   'X'      
     DB   ' '     
     DB   'B'      
     DB   0      
     DB   80H      
     DB   3      
     DB   'A'      
     DB   'D'      
     DB   'D'      
     DB   60H      
     DB   0C6H      
     DB   3      
     DB   'A'      
     DB   'D'      
     DB   'I'      
     DB   40H      
     DB   88H      
     DB   3      
     DB   'A'      
     DB   'D'      
     DB   'C'      
     DB   60H      
     DB   0CEH      
     DB   3      
     DB   'A'      
     DB   'C'      
     DB   'I'      
     DB   40H      
     DB   90H      
     DB   3      
     DB   'S'      
     DB   'U'      
     DB   'B'      
     DB   60H      
     DB   0D6H      
     DB   3      
     DB   'S'      
     DB   'U'      
     DB   'I'      
     DB   40H      
     DB   98H      
     DB   3      
     DB   'S'      
     DB   'B'      
     DB   'B'      
     DB   60H      
     DB   0DEH      
     DB   3      
     DB   'S'      
     DB   'B'      
     DB   'I'      
     DB   40H      
     DB   04H      
     DB   3      
     DB   'I'      
     DB   'N'      
     DB   'R'      
     DB   70H      
     DB   03H      
     DB   3      
     DB   'I'      
     DB   'N'      
     DB   'X'      
     DB   10H      
     DB   05H      
     DB   3      
     DB   'D'      
     DB   'C'      
     DB   'R'      
     DB   70H      
     DB   0BH      
     DB   3      
     DB   'D'      
     DB   'C'      
     DB   'X'      
     DB   10H      
     DB   09H      
     DB   3      
     DB   'D'      
     DB   'A'      
     DB   'D'      
     DB   10H      
     DB   27H      
     DB   3      
     DB   'D'      
     DB   'A'      
     DB   'A'      
     DB   0      
     DB   0A0H      
     DB   3      
     DB   'A'      
     DB   'N'      
     DB   'A'      
     DB   60H      
     DB   0E6H      
     DB   3      
     DB   'A'      
     DB   'N'      
     DB   'I'      
     DB   40H      
     DB   0A8H      
     DB   3      
     DB   'X'      
     DB   'R'      
     DB   'A'      
     DB   60H      
     DB   0EEH      
     DB   3      
     DB   'X'      
     DB   'R'      
     DB   'I'      
     DB   40H      
     DB   0B0H      
     DB   3      
     DB   'O'      
     DB   'R'      
     DB   'A'      
     DB   60H      
     DB   0F6H      
     DB   3      
     DB   'O'      
     DB   'R'      
     DB   'I'      
     DB   40H      
     DB   0B8H      
     DB   3      
     DB   'C'      
     DB   'M'      
     DB   'P'      
     DB   60H      
     DB   0FEH      
     DB   3      
     DB   'C'      
     DB   'P'      
     DB   'I'      
     DB   40H      
     DB   07H      
     DB   3      
     DB   'R'      
     DB   'L'      
     DB   'C'      
     DB   0      
     DB   0FH      
     DB   3      
     DB   'R'      
     DB   'R'      
     DB   'C'      
     DB   0      
     DB   17H      
     DB   3      
     DB   'R'      
     DB   'A'      
     DB   'L'      
     DB   0      
     DB   1FH      
     DB   3      
     DB   'R'      
     DB   'A'      
     DB   'R'      
     DB   0      
     DB   2FH      
     DB   3      
     DB   'C'      
     DB   'M'      
     DB   'A'      
     DB   0      
     DB   3FH      
     DB   3      
     DB   'C'      
     DB   'M'      
     DB   'C'      
     DB   0      
     DB   37H      
     DB   3      
     DB   'S'      
     DB   'T'      
     DB   'C'      
     DB   0      
     DB   0C3H      
     DB   3      
     DB   'J'      
     DB   'M'      
     DB   'P'      
     DB   50H      
     DB   0C2H      
     DB   1      
     DB   'J'      
     DB   25H      
     DB   0CDH      
     DB   4      
     DB   'C'      
     DB   'A'      
     DB   'L'      
     DB   'L'      
     DB   50H      
     DB   0C4H      
     DB   1      
     DB   'C'      
     DB   25H      
     DB   0C9H      
     DB   3      
     DB   'R'      
     DB   'E'      
     DB   'T'      
     DB   0      
     DB   0C0H      
     DB   1      
     DB   'R'      
     DB   20H      
     DB   0C7H     
     DB   3      
     DB   'R'      
     DB   'S'      
     DB   'T'      
     DB   30H      
     DB   0E9H      
     DB   4      
     DB   'P'      
     DB   'C'      
     DB   'H'      
     DB   'L'      
     DB   0      
     DB   0C5H      
     DB   4      
     DB   'P'      
     DB   'U'      
     DB   'S'      
     DB   'H'      
     DB   10H      
     DB   0F5H      
     DB   8      
     DB   'P'      
     DB   'U'      
     DB   'S'      
     DB   'H'      
     DB   ' '     
     DB   'P'      
     DB   'S'      
     DB   'W'      
     DB   0      
     DB   0C1H      
     DB   3      
     DB   'P'      
     DB   'O'      
     DB   'P'      
     DB   10H      
     DB   0F1H      
     DB   7      
     DB   'P'      
     DB   'O'      
     DB   'P'      
     DB   ' '     
     DB   'P'      
     DB   'S'      
     DB   'W'      
     DB   0      
     DB   0E3H      
     DB   4      
     DB   'X'      
     DB   'T'      
     DB   'H'      
     DB   'L'      
     DB   0      
     DB   0F9H      
     DB   4      
     DB   'S'      
     DB   'P'      
     DB   'H'      
     DB   'L'      
     DB   0      
     DB   0DBH      
     DB   2      
     DB   'I'      
     DB   'N'      
     DB   40H      
     DB   0D3H      
     DB   3      
     DB   'O'      
     DB   'U'      
     DB   'T'      
     DB   40H      
     DB   0FBH      
     DB   2      
     DB   'E'      
     DB   'I'      
     DB   0      
     DB   0F3H      
     DB   2      
     DB   'D'      
     DB   'I'      
     DB   0      
     DB   76H      
     DB   3      
     DB   'H'      
     DB   'L'      
     DB   'T'      
     DB   0      
     DB   0      
     DB   3      
     DB   'N'      
     DB   'O'      
     DB   'P'      
     DB   0      
     DB   20H      
     DB   3      
     DB   'R'      
     DB   'I'      
     DB   'M'      
     DB   0      
     DB   30H      
     DB   3      
     DB   'S'      
     DB   'I'      
     DB   'M'      
     DB   0      
TEND DB   0          
     ORG  0B00H
;
;    C code Run time routines
;    fetch char from (HL) and sign extend into HL
?gchar	mov	a,m
?sxt	mov	l,a
	rlc
	sbb	a
	mov	h,a
	ret
; fetch int from (HL)
?gint	mov	a,m
	inx	h
	mov	h,m
	mov	l,a
	ret
; store char from HL into (DE)
?pchar  mov	a,l
	stax	d
	ret
; store int from HL into (DE)
?pint	mov	a,l
	stax	d
	inx	d
	mov	a,h
	stax	d
	ret
; "or" HL and DE into HL
?or	mov	a,l
	ora	e
	mov	l,a
	mov	a,h
	ora	d
	mov	h,a
	ret
;   "xor" HL and DE into HL
?xor	mov	a,l
	xra	e
	mov	l,a
	mov	a,h
	xra	d
	mov	h,a
	ret
;   "and" HL and DE into HL
?and	mov	a,l
	ana	e
	mov	l,a
	mov	a,h
	ana	d
	mov	h,a
	ret
;
;......logical operations: HL set to 0 (false) or 1 (true)
; DE == HL
?eq	call	?cmpx
	rz
	dcx	h
	ret
; DE != HL
?ne	call	?cmpx
	rnz
	dcx	h
	ret
; DE > HL [signed]
?gt 	xchg
	call	?cmpx
	rc
	dcx	h
	ret
; DE <= HL [signed]
?le 	call	?cmpx
	rz
	rc
	dcx	h
	ret
; DE >= HL [signed]
?ge 	call	?cmpx
	rnc
	dcx	h
	ret
; DE < HL [signed]
?lt 	call	?cmpx
	rc
	dcx	h
	ret
; DE >= HL [unsigned]
?uge 	call	?ucmp
	rnc
	dcx	h
	ret
; DE < HL [unsigned]
?ult 	call	?ucmp
	rc
	dcx	h
	ret
; DE > HL [unsigned]
?ugt 	xchg
	call	?ucmp
	rc
	dcx	h
	ret
;   DE <= HL [unsigned]
?ule 	call	?ucmp
	rz
	rc
	dcx	h
	ret
;   signed compare of DE and HL
;   carry is sign of difference [set => DE < HL]
;   zero is zero/non-zero
?cmpx 	mov	a,e
	sub	l
	mov	e,a
	mov	a,d
	sbb	h
	lxi	h,1		;preset true
	jm	cmp1
	ora	e		;resets carry
	ret
cmp1 	ora	e
	stc
	ret
; unsigned compare of DE and HL
;   carry is sign of difference [set => DE < HL]
;   zero is zero/non-zero
?ucmp 	mov	a,d
	cmp	h
	jnz	ucmp1
	mov	a,e
	cmp	l
ucmp1 	lxi	h,1		;preset true
	ret
; shift DE right arithmetically by HL, move to HL
?asr 	xchg
asr1 	dcr	e
	rm
	mov	a,h
	ral
	mov	a,h
	rar
	mov	h,a
	mov	a,l
	rar
	mov	l,a
	jmp	asr1
; shift DE left arithmetically by HL, move to HL
?asl 	xchg
asl1 	dcr	e
	rm
	dad	h
	jmp	asl1
; HL = DE - HL
?sub 	mov	a,e
	sub	l
	mov	l,a
	mov	a,d
	sbb	h
	mov	h,a
	ret
; HL = -HL
?neg 	call	?com
	inx	h
	ret
; HL = ~HL
?com 	mov	a,h
	cma
	mov	h,a
	mov	a,l
	cma
	mov	l,a
	ret
; HL = !HL
?lneg 	mov	a,h
	ora	l
	jz	lneg1
	lxi	h,0
	ret
lneg1 	inx	h
	ret
;
;    HL = !!HL
?bool 	call	?lneg
	jmp	?lneg
;
;    HL = DE * HL [signed]
?mul 	mov	b,h
	mov	c,l
	lxi	h,0
mul1 	mov	a,c
	rrc
	jnc	mul2
	dad	d
mul2 	xra	a
	mov	a,b
	rar
	mov 	b,a
	mov	a,c
	rar
	mov	c,a
	ora	b
	rz
	xra	a
	mov	a,e
	ral
	mov	e,a
	mov	a,d
	ral
	mov	d,a
	ora	e
	rz
	jmp	mul1
;
;    HL = DE / HL, DE = DE % HL
?div 	mov	b,h
	mov	c,l
	mov	a,d
	xra	b
	push	psw
	mov	a,d
	ora	a
	cm	?deneg
	mov	a,b
	ora	a
	cm	?bcneg
	mvi	a,16
	push	psw
	xchg
	lxi	d,0
div1 	dad	h
	call	?rdel
	jz	div2
	call	?cmpbd
	jm	div2
	mov	a,l
	ori	1
	mov	l,a
	mov	a,e
	sub	c
	mov	e,a
	mov	a,d
	sbb	b
	mov	d,a
div2 	pop	psw
	dcr	a
	jz	div3
	push	psw
	jmp	div1
div3 	pop	psw
	rp
	call	?deneg
	xchg
	call	?deneg
	xchg
	ret
;
;    {DE = -DE}
?deneg  mov	a,d
	cma
	mov	d,a
	mov	a,e
	cma
	mov	e,a
	inx	d
	ret
;
;    {BC = -BC}
?bcneg  mov	a,b
	cma
	mov	b,a
	mov	a,c
	cma
	mov	c,a
	inx	b
	ret
;
;    {DE <r<r 1}
?rdel 	mov	a,e
	ral
	mov	e,a
	mov	a,d
	ral
	mov	d,a
	ora	e
	ret
;
;   {BC : DE}
?cmpbd  mov	a,e
	sub	c
	mov	a,d
	sbb	b
	ret
;
;   case jump
?case 	xchg			;switch value to DE
	pop	h		;get table address
case1 	call	case4		;get case value
	mov	a,e
	cmp	c		;equal to switch value 
	jnz	case2		;no
	mov	a,d
	cmp	b		;equal to switch value 
	jnz	case2		;no
	call	case4		;get case label
	jz	case3		;end of table, go to default
	push	b
	ret			;case jump
case2 	call	case4		;get case label
	jnz	case1		;next case
case3 	dcx	h
	dcx	h
	dcx	h
	mov	d,m
	dcx	h
	mov	e,m
	xchg
	pchl			;default jump
case4 	mov	c,m
	inx	h
	mov	b,m
	inx	h
	mov	a,c
	ora	b
	ret
;
Xstktop lxi	h,0	;return current stack pointer (for sbrk)
	dad	sp
	ret
;
;	Run time start off for Small C.
	ORG  0F00H
	sphl		; save the stack pointer
	shld	stksav
	lhld	6	; pick up core top
	lxi	d,-10	; decrease by 10 for safety
	dad	d
	sphl		; set stack pointer
	call	stdioinit	; initialize stdio
	call	Xarglist
	lhld	Xargc
	push	h
	lxi	h,Xargv
	push	h
	call	main	; call main program
	pop	d
	pop	d
	lhld	stksav	; restore stack pointer
	ret		; go back to CCP
;
;    HIGH MEMORY VARIABLES      
     ORG  3700H     
SLI1 DS   2            
SLI2 DS   2            
SLI3 DS   2            
SLI4 DS   2            
SL45 DS   2            
SLI5 DS   2            
SL55 DS   2            
SLI6 DS   2            
SL65 DS   2            
SLI7 DS   2            
SL75 DS   2            
FULL DS   2            
HALF DS   2            
TBC  DS   2           
CRC  DS   1         
SBC  DS   1         
SADE DS   1          
SADF DS   1          
CD   DS   16
etext  EQU  *
brkend DW  edata		;current "break"
edata  EQU  *
;  
stksav DS	2
stdioinit DS   2           
Xarglist  DS   2           
Xargc DS   2           
Xargv DS   2           
main  DS   2           
     END
