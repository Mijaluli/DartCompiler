import 'dart:io';
import 'dart:convert';

enum TokenType { KEYWORD, SYMBOL, IDENTIFIER, INT_CONST, STRING_CONST }

class tokenizerCompiler {
  Stream<String> _lines;
  bool _hasMoreTokens = true;
  TokenType _tokenType;
  String _keyword, _symbol, _identifier, _stringVal;
  int _intVal;

  tokenizerCompiler();

  /**
   * It open a jack file and read all line to list of seprate lines from it.
   */
  Future init(File sourceFile) async {
    Stream<List<int>> inputStream = sourceFile.openRead();
    _lines = inputStream.transform(utf8.decoder).transform(LineSplitter());
  }

  bool get hasMoreTokens => _hasMoreTokens;

  /**
   * Analyst next token.
   */
  Stream advance() async* {
    bool commentBlock = false;

    await for (var line in _lines) {
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
            _tokenType = TokenType.SYMBOL;
            _symbol = currentLine[i];
          }
        } else if (ifSymbol(currentLine[i])) {
          _tokenType = TokenType.SYMBOL;
          _symbol = currentLine[i];
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
            _tokenType = TokenType.KEYWORD;
            _keyword = word;
          } else {
            _tokenType = TokenType.IDENTIFIER;
            _identifier = word;
          }
        } else if (isDigit(currentLine[i])) {
          start = i;

          for (end = start + 1; end < currentLine.length; end++) {
            if (!isDigit(currentLine[end])) {
              break;
            }
          }

          i = end - 1;
          _tokenType = TokenType.INT_CONST;
          _intVal = int.parse(currentLine.substring(start, end));

          if (_intVal < 0 || _intVal > 32767) {
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
          _tokenType = TokenType.STRING_CONST;
          _stringVal = currentLine.substring(start + 1, end);
        } else if (currentLine[i] == " " || currentLine[i] == "\t") {
          continue;
        }

        yield _hasMoreTokens; // Return some because yield must return someone...
      }
    }
  }

  TokenType get tokenType => _tokenType;

  String get keyword {
    if (tokenType == TokenType.KEYWORD) {
      return _keyword;
    } else {
      throw "Invalid token in file in get a keyword!\n";
    }
  }

  String get symbol {
    if (tokenType == TokenType.SYMBOL) {
      if (_symbol == "<") {
        return "&lt;";
      } else if (_symbol == ">") {
        return "&gt;";
      } else if (_symbol == "&") {
        return "&amp;";
      } else {
        return _symbol;
      }
    } else {
      throw "Invalid token in file in get a symbol!\n";
    }
  }

  String get identifier {
    if (tokenType == TokenType.IDENTIFIER) {
      return _identifier;
    } else {
      throw "Invalid token in file in get a identifier!\n";
    }
  }

  int get intVal {
    if (tokenType == TokenType.INT_CONST) {
      return _intVal;
    } else {
      throw "Invalid token in file in get a integer value!\n";
    }
  }

  String get stringVal {
    if (tokenType == TokenType.STRING_CONST) {
      _stringVal.replaceAll("<", "&lt;");
      _stringVal.replaceAll(">", "&gt;");
      _stringVal.replaceAll("&", "&amp;");
      _stringVal.replaceAll("\"", "&quot;");
      return _stringVal;
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
