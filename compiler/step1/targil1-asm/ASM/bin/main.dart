//Abigail Fox 317801157 Tamar Grinblat 208098699

import 'dart:io';

enum Commands {
  ARITHMETIC_COMMAND,
  PUSH_COMMAND,
  POP_COMMAND,
}

/* open vm file for reading */
class ourCheckType {
  String temp;
  int temp2;
  int myLine = 0;
  List<String> resourcePointer;
  bool moreCommands = true;
  Commands commands;

  ourCheckType();

  /**open file for readimg */
  Future init(String srcFileName) async {
    File myFile = File(srcFileName + ".vm");
    resourcePointer = await myFile.readAsLines();
  }

  bool get hasMoreCommands => moreCommands;

  void myCheckFile() {
    do {
      if (myLine >= resourcePointer.length) {
        moreCommands = false;
        return;
      }

      List<String> splitLines = resourcePointer[myLine++].split(" ");

      if (splitLines[0] == "//" || splitLines[0] == "") {
        continue;
      }
      switch (splitLines[0]) {
        case "add":
        case "sub":
        case "neg":
        case "eq":
        case "gt":
        case "lt":
        case "and":
        case "or":
        case "not":
          commands = Commands.ARITHMETIC_COMMAND;
          temp = splitLines[0];
          break;
        case "push":
          commands = Commands.PUSH_COMMAND;
          temp = splitLines[1];
          temp2 = int.parse(splitLines[2]);
          break;
        case "pop":
          commands = Commands.POP_COMMAND;
          temp = splitLines[1];
          temp2 = int.parse(splitLines[2]);
          break;
        default:
          throw "Invalid command";
      }

      return;
    } while (hasMoreCommands);
  }

  Commands get commandType => commands;

  String get myTemp {
    return temp;
  }

  int get myTemp2 {
    if (commandType == Commands.PUSH_COMMAND ||
        commandType == Commands.POP_COMMAND) {
      return temp2;
    } else {
      throw "Invalid command";
    }
  }
}

/*output file */
class writeToAsmFile {
  IOSink outputAsmFile;
  int label = 0;
  String asmFile;
/*create asm file */
  writeToAsmFile(String destinationFileName) {
    asmFile = destinationFileName;
    File destination = File(asmFile + ".asm");
    outputAsmFile = destination.openWrite();
  }
  /*memory commands */
  Future WritePushPop(Commands command, String segment, int index) async {
    switch (segment) {
      case "local":
        if (command == Commands.PUSH_COMMAND) {
          outputAsmFile.writeln(
              "@$index\nD=A\n@LCL\nA=D+M\nD=M\n@SP\nA=M\nM=D\n@SP\nM=M+1");
        } else if (command == Commands.POP_COMMAND) {
          outputAsmFile.writeln(
              "@$index\nD=A\n@LCL\nD=D+M\n@R5\nM=D\n@SP\nM=M-1\nA=M\nD=M\n@R5\nA=M\nM=D");
        } else {
          throw "Invalid push or pop command\n";
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
          throw "Invalid push or pop command\n";
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
          throw "Invalid push or pop command\n";
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
          throw "Invalid push or pop command\n";
        }
        break;
      case "constant":
        if (command == Commands.POP_COMMAND) {
          throw "Error";
        }

        outputAsmFile.writeln("@$index\nD=A\n@SP\nA=M\nM=D\n@SP\nM=M+1");
        break;
      case "static":
        if (command == Commands.PUSH_COMMAND) {
          outputAsmFile
              .writeln("@$asmFile.$index\nD=M\n@SP\nA=M\nM=D\n@SP\nM=M+1");
        } else if (command == Commands.POP_COMMAND) {
          outputAsmFile.writeln("@SP\nM=M-1\nA=M\nD=M\n@$asmFile.$index\nM=D");
        } else {
          throw "Invalid push or pop command\n";
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
        if (index <= 0 || index > 8) {
          throw "Error: The index of temp segment out of range.";
        }

        if (command == Commands.PUSH_COMMAND) {
          outputAsmFile.writeln(
              "@$index\nD=A\n@5\nA=D+A\nD=M\n@SP\nA=M\nM=D\n@SP\nM=M+1");
        } else if (command == Commands.POP_COMMAND) {
          outputAsmFile.writeln(
              "@$index\nD=A\n@5\nD=D+A\n@R5\nM=D\n@SP\nM=M-1\nA=M\nD=M\n@R5\nA=M\nM=D");
        } else {
          throw "Invalid push or pop command\n";
        }
        break;
      default:
        throw "Invalid push or pop command\n";
    }
  }

/*arithmetic commands */
  Future writeArithmetic(String command) async {
    switch (command) {
      case "and":
        outputAsmFile.writeln("@SP\nA=M-1\nD=M\nA=A-1\nM=D&M\n@SP\nM=M-1");
        break;
      case "or":
        outputAsmFile.writeln("@SP\nA=M-1\nD=M\nA=A-1\nM=D|M\n@SP\nM=M-1");
        break;
      case "not":
        outputAsmFile.writeln("@SP\nA=M-1\nM=!M");
        break;
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

      default:
        throw "Invalid arithmetic command in file!\n";
    }
  }

  Future Close() async {
    await outputAsmFile.flush();
    await outputAsmFile.close();
  }
}

Future main(List<String> args) async {
  ourCheckType checkType;
  writeToAsmFile asmWriter;
  String name;

  var vmFileName = args[0].split(".");

  name = vmFileName[0];

  try {
    checkType = ourCheckType();
    await checkType.init(name);
    asmWriter = writeToAsmFile(name);

    checkType.myCheckFile();

    while (checkType.hasMoreCommands) {
      switch (checkType.commandType) {
        case Commands.ARITHMETIC_COMMAND:
          asmWriter.writeArithmetic(checkType.myTemp);
          break;
        case Commands.PUSH_COMMAND:
        case Commands.POP_COMMAND:
          asmWriter.WritePushPop(
              checkType.commandType, checkType.myTemp, checkType.myTemp2);
          break;
        default:
      }
      checkType.myCheckFile();
    }
  } catch (e) {
    print(e);
    return;
  } finally {
    asmWriter.Close();
  }
}
