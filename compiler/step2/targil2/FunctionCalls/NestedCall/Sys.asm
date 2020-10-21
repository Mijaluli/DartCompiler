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

// Start push or pop: Commands.PUSH_COMMAND constant 4000
@4000
D=A
@SP
A=M
M=D
@SP
M=M+1
// End push or pop: Commands.PUSH_COMMAND constant 4000

// Start push or pop: Commands.POP_COMMAND pointer 0
@SP
M=M-1
A=M
D=M
@THIS
M=D
// End push or pop: Commands.POP_COMMAND pointer 0

// Start push or pop: Commands.PUSH_COMMAND constant 5000
@5000
D=A
@SP
A=M
M=D
@SP
M=M+1
// End push or pop: Commands.PUSH_COMMAND constant 5000

// Start push or pop: Commands.POP_COMMAND pointer 1
@SP
M=M-1
A=M
D=M
@THAT
M=D
// End push or pop: Commands.POP_COMMAND pointer 1

// Start call: Sys.main 0
// Push return address:
@Sys.main.returnAddress1
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
@Sys.main
0;JMP
// Label return address:
(Sys.main.returnAddress1)
// End call: Sys.main 0

// Start push or pop: Commands.POP_COMMAND temp 1
@SP
A=M-1
D=M
@6
M=D
@SP
M=M-1
// End push or pop: Commands.POP_COMMAND temp 1

// Label: LOOP
(Sys.LOOP)

// Goto: LOOP
@Sys.LOOP
0;JMP

// Start function: Sys.main 5
// Label function:
(Sys.main)
// Initial local variables to zero:
@5
D=A
@Sys.main.initEnd
D;JEQ
(Sys.main.initLoop)
@SP
A=M
M=0
@SP
M=M+1
@Sys.main.initLoop
D=D-1;JNE
(Sys.main.initEnd)
// End function: Sys.main 5

// Start push or pop: Commands.PUSH_COMMAND constant 4001
@4001
D=A
@SP
A=M
M=D
@SP
M=M+1
// End push or pop: Commands.PUSH_COMMAND constant 4001

// Start push or pop: Commands.POP_COMMAND pointer 0
@SP
M=M-1
A=M
D=M
@THIS
M=D
// End push or pop: Commands.POP_COMMAND pointer 0

// Start push or pop: Commands.PUSH_COMMAND constant 5001
@5001
D=A
@SP
A=M
M=D
@SP
M=M+1
// End push or pop: Commands.PUSH_COMMAND constant 5001

// Start push or pop: Commands.POP_COMMAND pointer 1
@SP
M=M-1
A=M
D=M
@THAT
M=D
// End push or pop: Commands.POP_COMMAND pointer 1

// Start push or pop: Commands.PUSH_COMMAND constant 200
@200
D=A
@SP
A=M
M=D
@SP
M=M+1
// End push or pop: Commands.PUSH_COMMAND constant 200

// Start push or pop: Commands.POP_COMMAND local 1
@1
D=A
@LCL
D=D+M
@R5
M=D
@SP
M=M-1
A=M
D=M
@R5
A=M
M=D
// End push or pop: Commands.POP_COMMAND local 1

// Start push or pop: Commands.PUSH_COMMAND constant 40
@40
D=A
@SP
A=M
M=D
@SP
M=M+1
// End push or pop: Commands.PUSH_COMMAND constant 40

// Start push or pop: Commands.POP_COMMAND local 2
@2
D=A
@LCL
D=D+M
@R5
M=D
@SP
M=M-1
A=M
D=M
@R5
A=M
M=D
// End push or pop: Commands.POP_COMMAND local 2

// Start push or pop: Commands.PUSH_COMMAND constant 6
@6
D=A
@SP
A=M
M=D
@SP
M=M+1
// End push or pop: Commands.PUSH_COMMAND constant 6

// Start push or pop: Commands.POP_COMMAND local 3
@3
D=A
@LCL
D=D+M
@R5
M=D
@SP
M=M-1
A=M
D=M
@R5
A=M
M=D
// End push or pop: Commands.POP_COMMAND local 3

// Start push or pop: Commands.PUSH_COMMAND constant 123
@123
D=A
@SP
A=M
M=D
@SP
M=M+1
// End push or pop: Commands.PUSH_COMMAND constant 123

// Start call: Sys.add12 1
// Push return address:
@Sys.add12.returnAddress2
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
@Sys.add12
0;JMP
// Label return address:
(Sys.add12.returnAddress2)
// End call: Sys.add12 1

// Start push or pop: Commands.POP_COMMAND temp 0
@SP
A=M-1
D=M
@5
M=D
@SP
M=M-1
// End push or pop: Commands.POP_COMMAND temp 0

// Start push or pop: Commands.PUSH_COMMAND local 0
@0
D=A
@LCL
A=D+M
D=M
@SP
A=M
M=D
@SP
M=M+1
// End push or pop: Commands.PUSH_COMMAND local 0

// Start push or pop: Commands.PUSH_COMMAND local 1
@1
D=A
@LCL
A=D+M
D=M
@SP
A=M
M=D
@SP
M=M+1
// End push or pop: Commands.PUSH_COMMAND local 1

// Start push or pop: Commands.PUSH_COMMAND local 2
@2
D=A
@LCL
A=D+M
D=M
@SP
A=M
M=D
@SP
M=M+1
// End push or pop: Commands.PUSH_COMMAND local 2

// Start push or pop: Commands.PUSH_COMMAND local 3
@3
D=A
@LCL
A=D+M
D=M
@SP
A=M
M=D
@SP
M=M+1
// End push or pop: Commands.PUSH_COMMAND local 3

// Start push or pop: Commands.PUSH_COMMAND local 4
@4
D=A
@LCL
A=D+M
D=M
@SP
A=M
M=D
@SP
M=M+1
// End push or pop: Commands.PUSH_COMMAND local 4

// Start arithmetic: add
@SP
A=M-1
D=M
A=A-1
M=D+M
@SP
M=M-1
// End arithmetic: add

// Start arithmetic: add
@SP
A=M-1
D=M
A=A-1
M=D+M
@SP
M=M-1
// End arithmetic: add

// Start arithmetic: add
@SP
A=M-1
D=M
A=A-1
M=D+M
@SP
M=M-1
// End arithmetic: add

// Start arithmetic: add
@SP
A=M-1
D=M
A=A-1
M=D+M
@SP
M=M-1
// End arithmetic: add

// Start return
// FRAME = LCL:
@LCL
D=M
// RET = *(FRAME - 5):
@5
A=D-A
D=M
@R13
M=D
// *ARG = pop():
@SP
M=M-1
A=M
D=M
@ARG
A=M
M=D
// SP = ARG + 1:
@ARG
D=M
@SP
M=D+1
// THAT = *(FRAME - 1):
@LCL
M=M-1
A=M
D=M
@THAT
M=D
// THIS = *(FRAME - 2):
@LCL
M=M-1
A=M
D=M
@THIS
M=D
// ARG = *(FRAME - 3):
@LCL
M=M-1
A=M
D=M
@ARG
M=D
// LCL = *(FRAME - 4):
@LCL
M=M-1
A=M
D=M
@LCL
M=D
// Goto RET:
@R13
A=M
0;JMP
// End return

//////////////////////////////

// Start function: Sys.add12 0
// Label function:
(Sys.add12)
// Initial local variables to zero:
@0
D=A
@Sys.add12.initEnd
D;JEQ
(Sys.add12.initLoop)
@SP
A=M
M=0
@SP
M=M+1
@Sys.add12.initLoop
D=D-1;JNE
(Sys.add12.initEnd)
// End function: Sys.add12 0

// Start push or pop: Commands.PUSH_COMMAND constant 4002
@4002
D=A
@SP
A=M
M=D
@SP
M=M+1
// End push or pop: Commands.PUSH_COMMAND constant 4002

// Start push or pop: Commands.POP_COMMAND pointer 0
@SP
M=M-1
A=M
D=M
@THIS
M=D
// End push or pop: Commands.POP_COMMAND pointer 0

// Start push or pop: Commands.PUSH_COMMAND constant 5002
@5002
D=A
@SP
A=M
M=D
@SP
M=M+1
// End push or pop: Commands.PUSH_COMMAND constant 5002

// Start push or pop: Commands.POP_COMMAND pointer 1
@SP
M=M-1
A=M
D=M
@THAT
M=D
// End push or pop: Commands.POP_COMMAND pointer 1

// Start push or pop: Commands.PUSH_COMMAND argument 0
@0
D=A
@ARG
A=D+M
D=M
@SP
A=M
M=D
@SP
M=M+1
// End push or pop: Commands.PUSH_COMMAND argument 0

// Start push or pop: Commands.PUSH_COMMAND constant 12
@12
D=A
@SP
A=M
M=D
@SP
M=M+1
// End push or pop: Commands.PUSH_COMMAND constant 12

// Start arithmetic: add
@SP
A=M-1
D=M
A=A-1
M=D+M
@SP
M=M-1
// End arithmetic: add

// Start return
// FRAME = LCL:
@LCL
D=M
// RET = *(FRAME - 5):
@5
A=D-A
D=M
@R13
M=D
// *ARG = pop():
@SP
M=M-1
A=M
D=M
@ARG
A=M
M=D
// SP = ARG + 1:
@ARG
D=M
@SP
M=D+1
// THAT = *(FRAME - 1):
@LCL
M=M-1
A=M
D=M
@THAT
M=D
// THIS = *(FRAME - 2):
@LCL
M=M-1
A=M
D=M
@THIS
M=D
// ARG = *(FRAME - 3):
@LCL
M=M-1
A=M
D=M
@ARG
M=D
// LCL = *(FRAME - 4):
@LCL
M=M-1
A=M
D=M
@LCL
M=D
// Goto RET:
@R13
A=M
0;JMP
// End return

//////////////////////////////

