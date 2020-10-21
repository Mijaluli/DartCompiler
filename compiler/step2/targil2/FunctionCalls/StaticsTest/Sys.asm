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

// Start push or pop: Commands.PUSH_COMMAND constant 6
@6
D=A
@SP
A=M
M=D
@SP
M=M+1
// End push or pop: Commands.PUSH_COMMAND constant 6

// Start push or pop: Commands.PUSH_COMMAND constant 8
@8
D=A
@SP
A=M
M=D
@SP
M=M+1
// End push or pop: Commands.PUSH_COMMAND constant 8

// Start call: Class1.set 2
// Push return address:
@Class1.set.returnAddress1
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
@7
D=D-A
@ARG
M=D
// LCL = SP:
@SP
D=M
@LCL
M=D
// Goto function:
@Class1.set
0;JMP
// Label return address:
(Class1.set.returnAddress1)
// End call: Class1.set 2

// Start push or pop: Commands.POP_COMMAND temp 0
@SP
A=M-1
D=M
@5
M=D
@SP
M=M-1
// End push or pop: Commands.POP_COMMAND temp 0

// Start push or pop: Commands.PUSH_COMMAND constant 23
@23
D=A
@SP
A=M
M=D
@SP
M=M+1
// End push or pop: Commands.PUSH_COMMAND constant 23

// Start push or pop: Commands.PUSH_COMMAND constant 15
@15
D=A
@SP
A=M
M=D
@SP
M=M+1
// End push or pop: Commands.PUSH_COMMAND constant 15

// Start call: Class2.set 2
// Push return address:
@Class2.set.returnAddress2
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
@7
D=D-A
@ARG
M=D
// LCL = SP:
@SP
D=M
@LCL
M=D
// Goto function:
@Class2.set
0;JMP
// Label return address:
(Class2.set.returnAddress2)
// End call: Class2.set 2

// Start push or pop: Commands.POP_COMMAND temp 0
@SP
A=M-1
D=M
@5
M=D
@SP
M=M-1
// End push or pop: Commands.POP_COMMAND temp 0

// Start call: Class1.get 0
// Push return address:
@Class1.get.returnAddress3
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
@Class1.get
0;JMP
// Label return address:
(Class1.get.returnAddress3)
// End call: Class1.get 0

// Start call: Class2.get 0
// Push return address:
@Class2.get.returnAddress4
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
@Class2.get
0;JMP
// Label return address:
(Class2.get.returnAddress4)
// End call: Class2.get 0

// Label: WHILE
(Sys.WHILE)

// Goto: WHILE
@Sys.WHILE
0;JMP

