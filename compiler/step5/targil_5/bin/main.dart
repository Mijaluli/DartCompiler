/*Abigail Fox-317801157,Tamar Grinblat-208098699*/

import 'dart:io';

import 'compilation_engine.dart';
import 'jack_tokenizer.dart';

Future main(List<String> args) async {
  String name;
  Directory directory;
  bool isDirectory = false;
  List<String> tokens;

  if (args.length < 1) {
    print(
        "Error: You must enter a vm file or directory in command line argument.");
    return;
  }

  directory = new Directory(args[0]);
  var jackFileName = args[0].split(".");

  if (await directory.exists()) {
    // Check if it's a directory or a vm file only.
    name = args[0].split(new RegExp(r"[/\\]")).last;
    isDirectory = true;
  } else if (jackFileName.length < 2) {
    // It isn't directory, we need to check if it's a vm file.
    print(
        "Error: You must enter a jack file or directory in command line argument.");
    return;
  } else if (jackFileName[1] != "jack") {
    print("Error: You must enter a jack file in command line argument.");
    return;
  } else {
    // It's a jack file.
    // Its name will be used for a destination asm file:
    name = jackFileName[0];
  }

  try {
    if (isDirectory) {
      var filesList = directory.list();
      var path = directory.path;

      await for (FileSystemEntity file in filesList) {
        if (file is File) {
          var fullSplitedName =
              file.path.split(new RegExp(r"[/\\]")).last.split(".");

          if (fullSplitedName.last == "jack") {
            tokens = await tokenizerFile(file);
            String sourceName =
                file.path.split(new RegExp(r"[/\\]")).last.split(".").first;
            await compileFile(tokens, sourceName, path);
          }
        }
      }
    } else {
      tokens = await tokenizerFile(new File(name + ".jack"));
      await compileFile(tokens, name);
    }
  } catch (e) {
    print(e);
    return;
  }

  print("The compilation have completed successful!");
}

Future<List<String>> tokenizerFile(File jackFile) async {
  List<String> tokens = [];

  try {
    JackTokenizer jackTokenizer = JackTokenizer();
    await jackTokenizer.init(jackFile);

    jackTokenizer.advance();

    await for (var result in jackTokenizer.advance()) {
      result = true;
      if (result) result = false;

      switch (jackTokenizer.tokenType) {
        case TokenType.SYMBOL:
          tokens.add("<symbol> ${jackTokenizer.symbol} </symbol>");
          break;
        case TokenType.KEYWORD:
          tokens.add("<keyword> ${jackTokenizer.keyword} </keyword>");
          break;
        case TokenType.IDENTIFIER:
          tokens.add("<identifier> ${jackTokenizer.identifier} </identifier>");
          break;
        case TokenType.INT_CONST:
          tokens.add(
              "<integerConstant> ${jackTokenizer.intVal} </integerConstant>");
          break;
        case TokenType.STRING_CONST:
          tokens.add(
              "<stringConstant> ${jackTokenizer.stringVal} </stringConstant>");
          break;
      }
    }
  } catch (e) {
    print(e);
  }

  return tokens;
}

Future compileFile(List<String> tokens, String name, [String path = ""]) async {
  CompilationEngine compilationEngine = CompilationEngine();
  File destination = File(path + "/" + name + ".vm");
  IOSink output = destination.openWrite();

  try {
    compilationEngine.init(tokens, output);

    compilationEngine.compileClassParser();
  } catch (e) {
    print(e);
    return;
  } finally {
    await output.flush();
    await output.close();
  }
}
