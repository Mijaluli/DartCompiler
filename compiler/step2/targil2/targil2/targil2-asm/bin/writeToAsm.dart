import 'dart:io';

import 'switchCommands.dart';

class writeToAsmFile {
  IOSink outputAsmFile;
  int label = 0;
  String asmFile;
  String srcFile;

  writeToAsmFile(String destinationFileName) {
    asmFile = destinationFileName;
    File destination = File(asmFile + ".asm");
    outputAsmFile = destination.openWrite();
  }
  /*bootstrap */

  Future IntialCode() async {
    outputAsmFile.writeln("// Start init:");
    // SP = 256:
    outputAsmFile.writeln("@256\nD=A\n@SP\nM=D");
    // Call Sys.init 0:
    writeCall("Sys.init", 0);
    outputAsmFile.writeln("// End init:");
  }

  void setVmFile(String fileName) {
    srcFile = fileName;
  }
//*if-goto 

  Future writeIf(String label) async {
    outputAsmFile.writeln("// If goto: $label");
    outputAsmFile.writeln("@SP\nM=M-1\nA=M\nD=M\n@$srcFile.$label\nD;JNE");
    outputAsmFile.writeln();
  }

  //label

  Future writeLabel(String label) async {
    outputAsmFile.writeln("// Label: $label");
    outputAsmFile.writeln("($srcFile.$label)");
    outputAsmFile.writeln();
  }

  //goto 

  Future writeGoto(String label) async {
    outputAsmFile.writeln("// Goto: $label");
    outputAsmFile.writeln("@$srcFile.$label\n0;JMP");
    outputAsmFile.writeln();
  }

  //call 

  Future writeCall(String functionName, int numArgs) async {
    outputAsmFile.writeln("// Start call: $functionName $numArgs");

    outputAsmFile.writeln("// Push return address:");
    outputAsmFile.writeln("@$functionName.returnAddress$label");
    outputAsmFile.writeln("D=A\n@SP\nA=M\nM=D\n@SP\nM=M+1");

    outputAsmFile.writeln("// Push LCL:");
    outputAsmFile.writeln("@LCL\nD=M\n@SP\nA=M\nM=D\n@SP\nM=M+1");

    outputAsmFile.writeln("// Push ARG:");
    outputAsmFile.writeln("@ARG\nD=M\n@SP\nA=M\nM=D\n@SP\nM=M+1");

    outputAsmFile.writeln("// Push THIS:");
    outputAsmFile.writeln("@THIS\nD=M\n@SP\nA=M\nM=D\n@SP\nM=M+1");

    outputAsmFile.writeln("// Push THAT:");
    outputAsmFile.writeln("@THAT\nD=M\n@SP\nA=M\nM=D\n@SP\nM=M+1");

    outputAsmFile.writeln("// ARG = SP - n - 5 :");
    outputAsmFile.writeln("@SP\nD=M");
    outputAsmFile.writeln("@${numArgs + 5}");
    outputAsmFile.writeln("D=D-A\n@ARG\nM=D");

    outputAsmFile.writeln("// LCL = SP:");
    outputAsmFile.writeln("@SP\nD=M\n@LCL\nM=D");

    outputAsmFile.writeln("// Goto function:");
    outputAsmFile.writeln("@$functionName\n0;JMP");

    outputAsmFile.writeln("// Label return address:");
    outputAsmFile.writeln("($functionName.returnAddress$label)");

    label++;

    outputAsmFile.writeln("// End call: $functionName $numArgs");
    outputAsmFile.writeln();
  }
//return 

  Future writeReturn() async {
    outputAsmFile.writeln("// Start return");

    outputAsmFile.writeln("// FRAME = LCL:");
    outputAsmFile.writeln("@LCL\nD=M");

    outputAsmFile.writeln("// RET = *(FRAME - 5):");
    outputAsmFile.writeln("@5\nA=D-A\nD=M\n@R13\nM=D");

    outputAsmFile.writeln("// *ARG = pop():");
    outputAsmFile.writeln("@SP\nM=M-1\nA=M\nD=M\n@ARG\nA=M\nM=D");

    outputAsmFile.writeln("// SP = ARG + 1:");
    outputAsmFile.writeln("@ARG\nD=M\n@SP\nM=D+1");

    outputAsmFile.writeln("// THAT = *(FRAME - 1):");
    outputAsmFile.writeln("@LCL\nM=M-1\nA=M\nD=M\n@THAT\nM=D");

    outputAsmFile.writeln("// THIS = *(FRAME - 2):");
    outputAsmFile.writeln("@LCL\nM=M-1\nA=M\nD=M\n@THIS\nM=D");

    outputAsmFile.writeln("// ARG = *(FRAME - 3):");
    outputAsmFile.writeln("@LCL\nM=M-1\nA=M\nD=M\n@ARG\nM=D");

    outputAsmFile.writeln("// LCL = *(FRAME - 4):");
    outputAsmFile.writeln("@LCL\nM=M-1\nA=M\nD=M\n@LCL\nM=D");

    outputAsmFile.writeln("// Goto RET:");
    outputAsmFile.writeln("@R13\nA=M\n0;JMP");
    outputAsmFile.writeln("// End return");

    outputAsmFile.writeln("\n//////////////////////////////\n");
  }

  // function

  Future writeFunction(String functionName, int numLocals) async {
    outputAsmFile.writeln("// Start function: $functionName $numLocals");

    outputAsmFile.writeln("// Label function:");
    outputAsmFile.writeln("($functionName)");

    outputAsmFile.writeln("// Initial local variables to zero:");
    outputAsmFile.writeln("@$numLocals\nD=A\n@$functionName.initEnd\nD;JEQ");
    outputAsmFile
        .writeln("($functionName.initLoop)\n@SP\nA=M\nM=0\n@SP\nM=M+1");
    outputAsmFile
        .writeln("@$functionName.initLoop\nD=D-1;JNE\n($functionName.initEnd)");

    outputAsmFile.writeln("// End function: $functionName $numLocals");
    outputAsmFile.writeln();
  }

  Future Close() async {
    await outputAsmFile.flush();
    await outputAsmFile.close();
  }

//memory 
  Future WritePushPop(Commands command, String segment, int index) async {
    outputAsmFile.writeln("// Start push or pop: $command $segment $index");
    switch (segment) {
      case "local":
        if (command == Commands.PUSH_COMMAND) {
          outputAsmFile.writeln(
              "@$index\nD=A\n@LCL\nA=D+M\nD=M\n@SP\nA=M\nM=D\n@SP\nM=M+1");
        } else if (command == Commands.POP_COMMAND) {
          outputAsmFile.writeln(
              "@$index\nD=A\n@LCL\nD=D+M\n@R5\nM=D\n@SP\nM=M-1\nA=M\nD=M\n@R5\nA=M\nM=D");
        } else {
          throw "Invalid push or pop command in file!\n";
        }
        break;
      case "argument":
        if (command == Commands.PUSH_COMMAND) {
          outputAsmFile.writeln(
              "@$index\nD=A\n@ARG\nA=D+M\nD=M\n@SP\nA=M\nM=D\n@SP\nM=M+1");
        } else if (command == Commands.POP_COMMAND) {
          outputAsmFile.writeln(
              "@$index\nD=A\n@ARG\nD=D+M\n@R5\nM=D\n@SP\nM=M-1\nA=M\nD=M\n@R5\nA=M\nM=D");
        } else {
          throw "Invalid push or pop command in file!\n";
        }
        break;
      case "this":
        if (command == Commands.PUSH_COMMAND) {
          outputAsmFile.writeln(
              "@$index\nD=A\n@THIS\nA=D+M\nD=M\n@SP\nA=M\nM=D\n@SP\nM=M+1");
        } else if (command == Commands.POP_COMMAND) {
          outputAsmFile.writeln(
              "@$index\nD=A\n@THIS\nD=D+M\n@R5\nM=D\n@SP\nM=M-1\nA=M\nD=M\n@R5\nA=M\nM=D");
        } else {
          throw "Invalid push or pop command in file!\n";
        }
        break;
      case "that":
        if (command == Commands.PUSH_COMMAND) {
          outputAsmFile.writeln(
              "@$index\nD=A\n@THAT\nA=D+M\nD=M\n@SP\nA=M\nM=D\n@SP\nM=M+1");
        } else if (command == Commands.POP_COMMAND) {
          outputAsmFile.writeln(
              "@$index\nD=A\n@THAT\nD=D+M\n@R5\nM=D\n@SP\nM=M-1\nA=M\nD=M\n@R5\nA=M\nM=D");
        } else {
          throw "Invalid push or pop command in file!\n";
        }
        break;
      case "constant":
        if (command == Commands.POP_COMMAND) {
          throw "Error: Can't pop from a constant segment.";
        }

        outputAsmFile.writeln("@$index\nD=A\n@SP\nA=M\nM=D\n@SP\nM=M+1");
        break;
      case "static":
        if (command == Commands.PUSH_COMMAND) {
          outputAsmFile
              .writeln("@$srcFile.$index\nD=M\n@SP\nA=M\nM=D\n@SP\nM=M+1");
        } else if (command == Commands.POP_COMMAND) {
          outputAsmFile.writeln("@SP\nM=M-1\nA=M\nD=M\n@$srcFile.$index\nM=D");
        } else {
          throw "Invalid push or pop command in file!\n";
        }
        break;
      case "pointer":
        if (command == Commands.PUSH_COMMAND && index == 0) {
          outputAsmFile.writeln("@THIS\nD=M\n@SP\nA=M\nM=D\n@SP\nM=M+1");
        } else if (command == Commands.PUSH_COMMAND && index == 1) {
          outputAsmFile.writeln("@THAT\nD=M\n@SP\nA=M\nM=D\n@SP\nM=M+1");
        } else if (command == Commands.POP_COMMAND && index == 0) {
          outputAsmFile.writeln("@SP\nM=M-1\nA=M\nD=M\n@THIS\nM=D");
        } else if (command == Commands.POP_COMMAND && index == 1) {
          outputAsmFile.writeln("@SP\nM=M-1\nA=M\nD=M\n@THAT\nM=D");
        } else {
          throw "Invalid push or pop command in file!\n";
        }
        break;
      case "temp":
        if (index < 0 || index > 8) {
          throw "Error: The index of temp segment out of range.";
        }

        if (command == Commands.PUSH_COMMAND) {
          outputAsmFile.writeln(
              "@$index\nD=A\n@5\nA=D+A\nD=M\n@SP\nA=M\nM=D\n@SP\nM=M+1");
        } else if (command == Commands.POP_COMMAND) {
          outputAsmFile
              .writeln("@SP\nA=M-1\nD=M\n@${index + 5}\nM=D\n@SP\nM=M-1");
        } else {
          throw "Invalid push or pop command in file!\n";
        }
        break;
      default:
        throw "Invalid push or pop command in file!\n";
    }
    outputAsmFile.writeln("// End push or pop: $command $segment $index");
    outputAsmFile.writeln();
  }

//arithmetic 
  Future writeArithmetic(String command) async {
    outputAsmFile.writeln("// Start arithmetic: $command");
    switch (command) {
      case "add":
        outputAsmFile.writeln("@SP\nA=M-1\nD=M\nA=A-1\nM=D+M\n@SP\nM=M-1");
        break;
      case "sub":
        outputAsmFile.writeln("@SP\nA=M-1\nD=M\nA=A-1\nM=M-D\n@SP\nM=M-1");
        break;
      case "neg":
        outputAsmFile.writeln("@SP\nA=M-1\nM=-M");
        label++;
        break;
      case "eq":
        outputAsmFile.writeln(
            "@SP\nA=M-1\nD=M\nA=A-1\nD=D-M\n@IFT$label\nD;JEQ\nD=0\n@SP\n" +
                "A=M-1\nA=A-1\nM=D\n@IFF$label\n0;JMP\n(IFT$label)\nD=-1\n" +
                "@SP\nA=M-1\nA=A-1\nM=D\n(IFF$label)\n@SP\nM=M-1");
        label++;
        break;
      case "gt":
        outputAsmFile.writeln(
            "@SP\nA=M-1\nD=M\nA=A-1\nD=M-D\n@IFT$label\nD;JGT\nD=0\n@SP\n" +
                "A=M-1\nA=A-1\nM=D\n@IFF$label\n0;JMP\n(IFT$label)\nD=-1\n" +
                "@SP\nA=M-1\nA=A-1\nM=D\n(IFF$label)\n@SP\nM=M-1");
        label++;
        break;
      case "lt":
        outputAsmFile.writeln(
            "@SP\nA=M-1\nD=M\nA=A-1\nD=M-D\n@IFT$label\nD;JLT\nD=0\n@SP\n" +
                "A=M-1\nA=A-1\nM=D\n@IFF$label\n0;JMP\n(IFT$label)\nD=-1\n" +
                "@SP\nA=M-1\nA=A-1\nM=D\n(IFF$label)\n@SP\nM=M-1");
        label++;
        break;
      case "and":
        outputAsmFile.writeln("@SP\nA=M-1\nD=M\nA=A-1\nM=D&M\n@SP\nM=M-1");
        break;
      case "or":
        outputAsmFile.writeln("@SP\nA=M-1\nD=M\nA=A-1\nM=D|M\n@SP\nM=M-1");
        break;
      case "not":
        outputAsmFile.writeln("@SP\nA=M-1\nM=!M");
        break;
      default:
        throw "Invalid arithmetic command in file!\n";
    }
    outputAsmFile.writeln("// End arithmetic: $command");
    outputAsmFile.writeln();
  }
}
