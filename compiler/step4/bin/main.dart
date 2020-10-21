import 'dart:io';

import 'tokenizerCompiler.dart';
import 'parserCompiler.dart';

Future<List<String>> tokenizerFile(File jackFile) async {
  List<String> tokens = [];

  try {
    tokenizerCompiler jackTokenizer = tokenizerCompiler();
    await jackTokenizer.init(jackFile);

    jackTokenizer.advance();

    await for (var result in jackTokenizer.advance()) {
      result = true;
      if (result)
        result =
            false; // Not used, it's for use to result for prevent compiler warning...

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

Future analizerFile(List<String> tokens, String name,
    [String path = ""]) async {
  parserCompiler tokenAnalizer = parserCompiler();
  File destination = File(path + "/" + name + ".xml");
  IOSink output = destination.openWrite();

  try {
    tokenAnalizer.init(tokens, output);

    tokenAnalizer.createXmlFile();
  } catch (e) {
    print(e);
    return;
  } finally {
    await output.flush();
    await output.close();
  }
}

/**
 * Main method for run the compiler from Jack to vm.
 */
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
            await analizerFile(tokens, sourceName, path);
          }
        }
      }
    } else {
      tokens = await tokenizerFile(new File(name + ".jack"));
      await analizerFile(tokens, name);
    }
  } catch (e) {
    print(e);
    return;
  }

  print("The compilation have completed successful!");
}
