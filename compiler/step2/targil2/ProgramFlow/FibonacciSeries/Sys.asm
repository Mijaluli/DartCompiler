// Start init:
@256
D=A
@SP
M=D
// Start call: Sys.init 0
// Push return address:
@Sys.init.returnAddress0
D=A
@SP
A=M
M=D
@SP
M=M+1
// Push LCL:
@LCL
D=M
@SP
A=M
M=D
@SP
M=M+1
// Push ARG:
@ARG
D=M
@SP
A=M
M=D
@SP
M=M+1
// Push THIS:
@THIS
D=M
@SP
A=M
M=D
@SP
M=M+1
// Push THAT:
@THAT
D=M
@SP
A=M
M=D
@SP
M=M+1
// ARG = SP - n - 5 [ARG = SP - (n + 5)]:
@SP
D=M
@5
D=D-A
@ARG
M=D
// LCL = SP:
@SP
D=M
@LCL
M=D
// Goto function:
@Sys.init
0;JMP
// Label return address:
(Sys.init.returnAddress0)
// End call: Sys.init 0

// End init:

//////////////////////////////

