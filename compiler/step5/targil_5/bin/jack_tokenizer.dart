import 'dart:io';
import 'dart:convert';

enum TokenType { KEYWORD, SYMBOL, IDENTIFIER, INT_CONST, STRING_CONST }

class JackTokenizer {
  Stream<String> lines;
  bool hasMoreToken = true;
  TokenType tokenTypes;
  String keywords, symbols, identifiers, stringValues;
  int intValues;

  JackTokenizer();

  /**
   * It open a jack file and read 
   */
  Future init(File sourceFile) async {
    Stream<List<int>> inputStream = sourceFile.openRead();
    lines = inputStream.transform(utf8.decoder).transform(LineSplitter());
  }

  bool get hasMoreTokens => hasMoreToken;

  /**
   * Analyst next token.
   */
  Stream advance() async* {
    bool commentBlock = false;

    await for (var line in lines) {
      String currentLine = line.split("//")[0];
      int start = 0, end = 0;

      for (int i = 0; i < currentLine.length; i++) {
        // Check token type...
        if (commentBlock) {
          if (currentLine[i] == "*" && i < currentLine.length - 1) {
            if (currentLine[i + 1] == "/") {
              commentBlock = false;
              i++;
            }
          }
          continue;
        } else if (currentLine[i] == "/" && i < currentLine.length - 1) {
          if (currentLine[i + 1] == "*") {
            commentBlock = true;
            i++;
            continue;
          } else {
            // It's a symbol: '/'.
            tokenTypes = TokenType.SYMBOL;
            symbols = currentLine[i];
          }
        } else if (ifSymbol(currentLine[i])) {
          tokenTypes = TokenType.SYMBOL;
          symbols = currentLine[i];
        } else if (isLetter(currentLine[i])) {
          start = i;

          for (end = start + 1; end < currentLine.length; end++) {
            if (!isDigit(currentLine[end]) &&
                !isLetter(currentLine[end]) &&
                !isUnderscore(currentLine[end])) {
              break;
            }
          }

          i = end - 1;
          String word = currentLine.substring(start, end);

          if (ifKeyword(word)) {
            tokenTypes = TokenType.KEYWORD;
            keywords = word;
          } else {
            tokenTypes = TokenType.IDENTIFIER;
            identifiers = word;
          }
        } else if (isDigit(currentLine[i])) {
          start = i;

          for (end = start + 1; end < currentLine.length; end++) {
            if (!isDigit(currentLine[end])) {
              break;
            }
          }

          i = end - 1;
          tokenTypes = TokenType.INT_CONST;
          intValues = int.parse(currentLine.substring(start, end));

          if (intValues < 0 || intValues > 32767) {
            throw "Integer number must between zero and 32767 only!";
          }
        } else if (currentLine[i] == "\"") {
          start = i;

          for (end = start + 1; end < currentLine.length; end++) {
            if (currentLine[end] == "\"") {
              break;
            }
          }

          i = end;
          tokenTypes = TokenType.STRING_CONST;
          stringValues = currentLine.substring(start + 1, end);
        } else if (currentLine[i] == " " || currentLine[i] == "\t") {
          continue;
        } else {
          throw "Invalid syntax in the code.";
        }

        yield hasMoreToken;
      }
    }
  }

  TokenType get tokenType => tokenTypes;

  String get keyword {
    if (tokenType == TokenType.KEYWORD) {
      return keywords;
    } else {
      throw "Invalid token in file in get a keyword!\n";
    }
  }

  String get symbol {
    if (tokenType == TokenType.SYMBOL) {
      if (symbols == "<") {
        return "&lt;";
      } else if (symbols == ">") {
        return "&gt;";
      } else if (symbols == "&") {
        return "&amp;";
      } else {
        return symbols;
      }
    } else {
      throw "Invalid token in file in get a symbol!\n";
    }
  }

  String get identifier {
    if (tokenType == TokenType.IDENTIFIER) {
      return identifiers;
    } else {
      throw "Invalid token in file in get a identifier!\n";
    }
  }

  int get intVal {
    if (tokenType == TokenType.INT_CONST) {
      return intValues;
    } else {
      throw "Invalid token in file in get a integer value!\n";
    }
  }

  String get stringVal {
    if (tokenType == TokenType.STRING_CONST) {
      stringValues.replaceAll("<", "&lt;");
      stringValues.replaceAll(">", "&gt;");
      stringValues.replaceAll("&", "&amp;");
      stringValues.replaceAll("\"", "&quot;");
      return stringValues;
    } else {
      throw "Invalid token in file in get a string value!\n";
    }
  }

  bool ifSymbol(String ch) {
    return ch == "{" ||
        ch == "}" ||
        ch == "(" ||
        ch == ")" ||
        ch == "[" ||
        ch == "]" ||
        ch == "." ||
        ch == "," ||
        ch == ";" ||
        ch == "+" ||
        ch == "-" ||
        ch == "*" ||
        ch == "/" ||
        ch == "&" ||
        ch == "|" ||
        ch == "<" ||
        ch == ">" ||
        ch == "=" ||
        ch == "~";
  }

  bool ifKeyword(String word) {
    return word == "class" ||
        word == "constructor" ||
        word == "function" ||
        word == "method" ||
        word == "field" ||
        word == "static" ||
        word == "var" ||
        word == "int" ||
        word == "char" ||
        word == "boolean" ||
        word == "void" ||
        word == "true" ||
        word == "false" ||
        word == "null" ||
        word == "this" ||
        word == "let" ||
        word == "do" ||
        word == "if" ||
        word == "else" ||
        word == "while" ||
        word == "return";
  }

  bool isLetter(String ch) {
    return ch.codeUnitAt(0) >= 65 && ch.codeUnitAt(0) <= 90 ||
        ch.codeUnitAt(0) >= 97 && ch.codeUnitAt(0) <= 122;
  }

  bool isUnderscore(String ch) {
    return ch == "_";
  }

  bool isDigit(String ch) {
    return ch.codeUnitAt(0) >= 48 && ch.codeUnitAt(0) <= 57;
  }
}
