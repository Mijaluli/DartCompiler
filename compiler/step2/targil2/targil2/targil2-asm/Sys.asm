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

// Start function: Sys.init 0
// Label function:
(Sys.init)
// Initial local variables to zero:
@0
D=A
@Sys.init.initEnd
D;JEQ
(Sys.init.initLoop)
@SP
A=M
M=0
@SP
M=M+1
@Sys.init.initLoop
D=D-1;JNE
(Sys.init.initEnd)
// End function: Sys.init 0

// Start push or pop: Commands.PUSH_COMMAND constant 4
@4
D=A
@SP
A=M
M=D
@SP
M=M+1
// End push or pop: Commands.PUSH_COMMAND constant 4

// Start call: Main.fibonacci 1
// Push return address:
@Main.fibonacci.returnAddress1
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
@6
D=D-A
@ARG
M=D
// LCL = SP:
@SP
D=M
@LCL
M=D
// Goto function:
@Main.fibonacci
0;JMP
// Label return address:
(Main.fibonacci.returnAddress1)
// End call: Main.fibonacci 1

// Label: WHILE
(Sys.WHILE)

// Goto: WHILE
@Sys.WHILE
0;JMP

