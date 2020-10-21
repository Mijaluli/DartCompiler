//Abigail Fox 317801157 Tamar Grinblat 208098699

import 'dart:io';

import 'ourCheckType.dart';
import 'switchCommands.dart';
import 'writeToAsm.dart';

Future compileFile(writeToAsmFile codeWriter, File vmFileName) async {
  try {
    ourCheckType checkType = ourCheckType();
    String myFileName =
        vmFileName.path.split(new RegExp(r"[/\\]")).last.split(".").first;
    await checkType.init(vmFileName);
    codeWriter.setVmFile(myFileName);

    checkType.mycheckFile();

    await for (var result in checkType.mycheckFile()) {
      result = true;
      if (result) result = false;

      switch (checkType.commandType) {
        case Commands.ARITHMETIC_COMMAND:
          codeWriter.writeArithmetic(checkType.arg1);
          break;
        case Commands.PUSH_COMMAND:
        case Commands.POP_COMMAND:
          codeWriter.WritePushPop(
              checkType.commandType, checkType.arg1, checkType.arg2);
          break;
        case Commands.LABEL_COMMAND:
          codeWriter.writeLabel(checkType.arg1);
          break;
        case Commands.GOTO_COMMAND:
          codeWriter.writeGoto(checkType.arg1);
          break;
        case Commands.IF_COMMAND:
          codeWriter.writeIf(checkType.arg1);
          break;
        case Commands.CALL_COMMAND:
          codeWriter.writeCall(checkType.arg1, checkType.arg2);
          break;
        case Commands.RETURN_COMMAND:
          codeWriter.writeReturn();
          break;
        case Commands.FUNCTION_COMMAND:
          codeWriter.writeFunction(checkType.arg1, checkType.arg2);
          break;
        default:
      }
    }
  } catch (e) {
    print(e);
    return;
  }
}

Future main(List<String> args) async {
  writeToAsmFile codeWriter;
  String name;
  Directory directory;
  bool isDirectory = false;

  if (args.length < 1) {
    print("Error: You must enter a vm file or directory .");
    return;
  }

  directory = new Directory(args[0]);
  var vmFileName = args[0].split(".");

  if (await directory.exists()) {
    name = args[0].split(new RegExp(r"[/\\]")).last;
    isDirectory = true;
  } else if (vmFileName.length < 2) {
    // It isn't directory, we need to check if it's a vm file.
    print(
        "Error: You must enter a vm file or directory in command line argument.");
    return;
  } else if (vmFileName[1] != "vm") {
    print("Error: You must enter a vm file in command line argument.");
    return;
  } else {
    name = vmFileName[0];
  }

  codeWriter = writeToAsmFile(name);
  await codeWriter.IntialCode();

  try {
    if (isDirectory) {
      var filesList = directory.list();

      await for (FileSystemEntity file in filesList) {
        if (file is File) {
          var fullSplitedName =
              file.path.split(new RegExp(r"[/\\]")).last.split(".");

          if (fullSplitedName.last == "vm") {
            await compileFile(codeWriter, file);
          }
        }
      }
    } else {
      await compileFile(codeWriter, new File(name + ".vm"));
    }
  } catch (e) {
    print(e);
    return;
  } finally {
    codeWriter.Close();
  }
}
