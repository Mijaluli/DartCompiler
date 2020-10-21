import 'dart:io';
import 'dart:convert';
import 'switchCommands.dart';

/**
 * It represent a parser: it read from vm file and analyst line after line. 
 */
class ourCheckType {
  Stream<String> resourcePointer;
  bool moreCommands = true;
  Commands commands;
  String temp;
  int temp2;
  ourCheckType();

  /**open file for readimg */
  Future init(File srcFileName) async {
    Stream<List<int>> inputStream = srcFileName.openRead();
    resourcePointer =
        inputStream.transform(utf8.decoder).transform(LineSplitter());
  }

  bool get hasMoreCommands => moreCommands;

  Stream mycheckFile() async* {
    await for (var line in resourcePointer) {
      List<String> words = line.split(" ");

      if (words[0] == "//" || words[0] == "") {
        continue;
      }

      switch (words[0]) {
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
          temp = words[0];
          break;
        case "push":
          commands = Commands.PUSH_COMMAND;
          temp = words[1];
          temp2 = int.parse(words[2].replaceAll(new RegExp(r"[\D]"), ""));
          break;
        case "pop":
          commands = Commands.POP_COMMAND;
          temp = words[1]; // Segment.
          temp2 = int.parse(words[2].replaceAll(new RegExp(r"[\D]"), ""));
          break;
        case "label":
          commands = Commands.LABEL_COMMAND;
          temp = words[1];
          break;
        case "goto":
          commands = Commands.GOTO_COMMAND;
          temp = words[1];
          break;
        case "if-goto":
          commands = Commands.IF_COMMAND;
          temp = words[1];
          break;
        case "call":
          commands = Commands.CALL_COMMAND;
          temp = words[1];
          temp2 = int.parse(words[2]);
          break;
        case "return":
          commands = Commands.RETURN_COMMAND;
          break;
        case "function":
          commands = Commands.FUNCTION_COMMAND;
          temp = words[1];
          temp2 = int.parse(words[2]);
          break;
        default:
          throw "Invalid command in file!\n";
      }

      yield moreCommands;
    }
  }

  Commands get commandType => commands;

  int get arg2 {
    if (commandType == Commands.PUSH_COMMAND ||
        commandType == Commands.POP_COMMAND ||
        commandType == Commands.FUNCTION_COMMAND ||
        commandType == Commands.CALL_COMMAND) {
      return temp2;
    } else {
      throw "Invalid command";
    }
  }

  String get arg1 {
    if (commandType == Commands.RETURN_COMMAND) {
      throw "Invalid command ";
    } else {
      return temp;
    }
  }
}
