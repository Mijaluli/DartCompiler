@17
D=A
@SP
A=M
M=D
@SP
M=M+1
@17
D=A
@SP
A=M
M=D
@SP
M=M+1
@SP
A=M-1
D=M
A=A-1
D=D-M
@IFT0
D;JEQ
D=0
@SP
A=M-1
A=A-1
M=D
@IFF0
0;JMP
(IFT0)
D=-1
@SP
A=M-1
A=A-1
M=D
(IFF0)
@SP
M=M-1
@17
D=A
@SP
A=M
M=D
@SP
M=M+1
@16
D=A
@SP
A=M
M=D
@SP
M=M+1
@SP
A=M-1
D=M
A=A-1
D=D-M
@IFT1
D;JEQ
D=0
@SP
A=M-1
A=A-1
M=D
@IFF1
0;JMP
(IFT1)
D=-1
@SP
A=M-1
A=A-1
M=D
(IFF1)
@SP
M=M-1
@16
D=A
@SP
A=M
M=D
@SP
M=M+1
@17
D=A
@SP
A=M
M=D
@SP
M=M+1
@SP
A=M-1
D=M
A=A-1
D=D-M
@IFT2
D;JEQ
D=0
@SP
A=M-1
A=A-1
M=D
@IFF2
0;JMP
(IFT2)
D=-1
@SP
A=M-1
A=A-1
M=D
(IFF2)
@SP
M=M-1
@892
D=A
@SP
A=M
M=D
@SP
M=M+1
@891
D=A
@SP
A=M
M=D
@SP
M=M+1
@SP
A=M-1
D=M
A=A-1
D=M-D
@IFT3
D;JLT
D=0
@SP
A=M-1
A=A-1
M=D
@IFF3
0;JMP
(IFT3)
D=-1
@SP
A=M-1
A=A-1
M=D
(IFF3)
@SP
M=M-1
@891
D=A
@SP
A=M
M=D
@SP
M=M+1
@892
D=A
@SP
A=M
M=D
@SP
M=M+1
@SP
A=M-1
D=M
A=A-1
D=M-D
@IFT4
D;JLT
D=0
@SP
A=M-1
A=A-1
M=D
@IFF4
0;JMP
(IFT4)
D=-1
@SP
A=M-1
A=A-1
M=D
(IFF4)
@SP
M=M-1
@891
D=A
@SP
A=M
M=D
@SP
M=M+1
@891
D=A
@SP
A=M
M=D
@SP
M=M+1
@SP
A=M-1
D=M
A=A-1
D=M-D
@IFT5
D;JLT
D=0
@SP
A=M-1
A=A-1
M=D
@IFF5
0;JMP
(IFT5)
D=-1
@SP
A=M-1
A=A-1
M=D
(IFF5)
@SP
M=M-1
@32767
D=A
@SP
A=M
M=D
@SP
M=M+1
@32766
D=A
@SP
A=M
M=D
@SP
M=M+1
@SP
A=M-1
D=M
A=A-1
D=M-D
@IFT6
D;JGT
D=0
@SP
A=M-1
A=A-1
M=D
@IFF6
0;JMP
(IFT6)
D=-1
@SP
A=M-1
A=A-1
M=D
(IFF6)
@SP
M=M-1
@32766
D=A
@SP
A=M
M=D
@SP
M=M+1
@32767
D=A
@SP
A=M
M=D
@SP
M=M+1
@SP
A=M-1
D=M
A=A-1
D=M-D
@IFT7
D;JGT
D=0
@SP
A=M-1
A=A-1
M=D
@IFF7
0;JMP
(IFT7)
D=-1
@SP
A=M-1
A=A-1
M=D
(IFF7)
@SP
M=M-1
@32766
D=A
@SP
A=M
M=D
@SP
M=M+1
@32766
D=A
@SP
A=M
M=D
@SP
M=M+1
@SP
A=M-1
D=M
A=A-1
D=M-D
@IFT8
D;JGT
D=0
@SP
A=M-1
A=A-1
M=D
@IFF8
0;JMP
(IFT8)
D=-1
@SP
A=M-1
A=A-1
M=D
(IFF8)
@SP
M=M-1
@57
D=A
@SP
A=M
M=D
@SP
M=M+1
@31
D=A
@SP
A=M
M=D
@SP
M=M+1
@53
D=A
@SP
A=M
M=D
@SP
M=M+1
@SP
A=M-1
D=M
A=A-1
M=D+M
@SP
M=M-1
@112
D=A
@SP
A=M
M=D
@SP
M=M+1
@SP
A=M-1
D=M
A=A-1
M=M-D
@SP
M=M-1
@SP
A=M-1
M=-M
@SP
A=M-1
D=M
A=A-1
M=D&M
@SP
M=M-1
@82
D=A
@SP
A=M
M=D
@SP
M=M+1
@SP
A=M-1
D=M
A=A-1
M=D|M
@SP
M=M-1
@SP
A=M-1
M=!M
