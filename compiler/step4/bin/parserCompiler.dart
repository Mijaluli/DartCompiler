import 'dart:io';

/*It represent a compilation engine: it read from tokens' xml file and*/

class parserCompiler {
  List<String> line;
  IOSink finalOutput;
  int length, nextToken = 0, indentToken = 0;

  parserCompiler();

  /*  פתיחת דובץ גק לקריאה, על ידי העברת כל השורות בו לשורה אחת  מופרדת*/

  void init(List<String> tokens, IOSink destinationFile) {
    line = tokens;
    finalOutput = destinationFile;
    length = line.length;
  }

  void printLine(String line) {
    finalOutput.writeln("  " * indentToken + line);
  }

  String myNextToken() {
    if (nextToken < length) {
      return line[nextToken++];
    } else {
      throw "Syntax error!";
    }
  }

  void tokenBack() {
    nextToken--;
  }

  void createXmlFile() {
    String line;
    List<String> words;
    printLine("<class>");
    indentToken++;

    line = myNextToken();

    // 'class'
    if (line == "<keyword> class </keyword>") {
      printLine(line);
    } else {
      throw "Syntax error!";
    }

    line = myNextToken();
    words = line.split(" ");

    // className
    if (words[0] == "<identifier>" && words[2] == "</identifier>") {
      printLine(line);
    } else {
      throw "Syntax error!";
    }

    line = myNextToken();

    // '{'
    if (line == "<symbol> { </symbol>") {
      printLine(line);
    } else {
      throw "Syntax error!";
    }

    line = myNextToken();

    // classVarDec*
    while (line == "<keyword> static </keyword>" ||
        line == "<keyword> field </keyword>") {
      tokenBack();
      ClassVarDecleration();

      line = myNextToken();
    }

    // subroutineDec*
    while (line == "<keyword> constructor </keyword>" ||
        line == "<keyword> function </keyword>" ||
        line == "<keyword> method </keyword>") {
      tokenBack();
      subroutineDecleration();

      line = myNextToken();
    }

    // '}'
    if (line == "<symbol> } </symbol>") {
      printLine(line);
    } else {
      throw "Syntax error!";
    }

    indentToken--;
    printLine("</class>");
  }

  void ClassVarDecleration() {
    String line;
    List<String> words;

    printLine("<classVarDec>");
    indentToken++;

    line = myNextToken();

    // ('static'|'field')
    if (line == "<keyword> static </keyword>" ||
        line == "<keyword> field </keyword>") {
      printLine(line);
    } else {
      throw "Syntax error!";
    }

    line = myNextToken();
    words = line.split(" ");

    // type = ('int'|'char'|'boolean'|className)
    if (line == "<keyword> int </keyword>" ||
        line == "<keyword> char </keyword>" ||
        line == "<keyword> boolean </keyword>" ||
        words[0] == "<identifier>" && words[2] == "</identifier>") {
      printLine(line);
    } else {
      throw "Syntax error!";
    }

    line = myNextToken();
    words = line.split(" ");

    // varName
    if (words[0] == "<identifier>" && words[2] == "</identifier>") {
      printLine(line);
    } else {
      throw "Syntax error!";
    }

    line = myNextToken();

    // (',' varName)*
    while (line == "<symbol> , </symbol>") {
      printLine(line);

      line = myNextToken();
      words = line.split(" ");

      // varName
      if (words[0] == "<identifier>" && words[2] == "</identifier>") {
        printLine(line);
      } else {
        throw "Syntax error!";
      }

      line = myNextToken();
    }

    // ';'
    if (line == "<symbol> ; </symbol>") {
      printLine(line);
    } else {
      throw "Syntax error!";
    }

    indentToken--;
    printLine("</classVarDec>");
  }

  void subroutineDecleration() {
    String line;
    List<String> words;

    printLine("<subroutineDec>");
    indentToken++;

    line = myNextToken();

    // ('constructor'|'function'|'method')
    if (line == "<keyword> constructor </keyword>" ||
        line == "<keyword> function </keyword>" ||
        line == "<keyword> method </keyword>") {
      printLine(line);
    } else {
      throw "Syntax error!";
    }

    line = myNextToken();
    words = line.split(" ");

    // 'void'|type = ('void'|'int'|'char'|'boolean'|className)
    if (line == "<keyword> void </keyword>" ||
        line == "<keyword> int </keyword>" ||
        line == "<keyword> char </keyword>" ||
        line == "<keyword> boolean </keyword>" ||
        words[0] == "<identifier>" && words[2] == "</identifier>") {
      printLine(line);
    } else {
      throw "Syntax error!";
    }

    line = myNextToken();
    words = line.split(" ");

    // subroutineName
    if (words[0] == "<identifier>" && words[2] == "</identifier>") {
      printLine(line);
    } else {
      throw "Syntax error!";
    }

    line = myNextToken();

    // '('
    if (line == "<symbol> ( </symbol>") {
      printLine(line);
    } else {
      throw "Syntax error!";
    }

    // parameterList
    compileParameterList();

    line = myNextToken();

    // ')'
    if (line == "<symbol> ) </symbol>") {
      printLine(line);
    } else {
      throw "Syntax error!";
    }

    compileSubroutineBody();

    indentToken--;
    printLine("</subroutineDec>");
  }

  void compileParameterList() {
    String line;
    List<String> words;

    printLine("<parameterList>");
    indentToken++;

    line = myNextToken();
    words = line.split(" ");

    // type = ('int'|'char'|'boolean'|className)
    if (line == "<keyword> int </keyword>" ||
        line == "<keyword> char </keyword>" ||
        line == "<keyword> boolean </keyword>" ||
        words[0] == "<identifier>" && words[2] == "</identifier>") {
      printLine(line);
    } else {
      tokenBack();
      indentToken--;
      printLine("</parameterList>");
      return;
    }

    line = myNextToken();
    words = line.split(" ");

    // varName
    if (words[0] == "<identifier>" && words[2] == "</identifier>") {
      printLine(line);
    } else {
      throw "Syntax error!";
    }

    line = myNextToken();

    // (',' type varName)*
    while (line == "<symbol> , </symbol>") {
      printLine(line);

      line = myNextToken();

      // type = ('int'|'char'|'boolean'|className)
      if (line == "<keyword> int </keyword>" ||
          line == "<keyword> char </keyword>" ||
          line == "<keyword> boolean </keyword>" ||
          words[0] == "<identifier>" && words[2] == "</identifier>") {
        printLine(line);
      } else {
        throw "Syntax error!";
      }

      line = myNextToken();
      words = line.split(" ");

      // varName
      if (words[0] == "<identifier>" && words[2] == "</identifier>") {
        printLine(line);
      } else {
        throw "Syntax error!";
      }

      line = myNextToken();
    }

    tokenBack();

    indentToken--;
    printLine("</parameterList>");
  }

  void compileSubroutineBody() {
    String line;

    printLine("<subroutineBody>");
    indentToken++;

    line = myNextToken();

    // '{'
    if (line == "<symbol> { </symbol>") {
      printLine(line);
    } else {
      throw "Syntax error!";
    }

    line = myNextToken();

    // varDec*
    while (line == "<keyword> var </keyword>") {
      tokenBack();
      compileVarDec();

      line = myNextToken();
    }

    tokenBack();
    statements();

    line = myNextToken();

    // '}'
    if (line == "<symbol> } </symbol>") {
      printLine(line);
    } else {
      throw "Syntax error!";
    }

    indentToken--;
    printLine("</subroutineBody>");
  }

  void compileVarDec() {
    String line;
    List<String> words;

    printLine("<varDec>");
    indentToken++;

    line = myNextToken();

    // 'var'
    if (line == "<keyword> var </keyword>") {
      printLine(line);
    } else {
      throw "Syntax error!";
    }

    line = myNextToken();
    words = line.split(" ");

    // type = ('int'|'char'|'boolean'|className)
    if (line == "<keyword> int </keyword>" ||
        line == "<keyword> char </keyword>" ||
        line == "<keyword> boolean </keyword>" ||
        words[0] == "<identifier>" && words[2] == "</identifier>") {
      printLine(line);
    } else {
      throw "Syntax error!";
    }

    line = myNextToken();
    words = line.split(" ");

    // varName
    if (words[0] == "<identifier>" && words[2] == "</identifier>") {
      printLine(line);
    } else {
      throw "Syntax error!";
    }

    line = myNextToken();

    // (',' varName)*
    while (line == "<symbol> , </symbol>") {
      printLine(line);

      line = myNextToken();
      words = line.split(" ");

      // varName
      if (words[0] == "<identifier>" && words[2] == "</identifier>") {
        printLine(line);
      } else {
        throw "Syntax error!";
      }

      line = myNextToken();
    }

    // ';'
    if (line == "<symbol> ; </symbol>") {
      printLine(line);
    } else {
      throw "Syntax error!";
    }

    indentToken--;
    printLine("</varDec>");
  }

  void statements() {
    String line;

    printLine("<statements>");
    indentToken++;

    line = myNextToken();
    tokenBack();

    // statement*
    while (line == "<keyword> let </keyword>" ||
        line == "<keyword> if </keyword>" ||
        line == "<keyword> while </keyword>" ||
        line == "<keyword> do </keyword>" ||
        line == "<keyword> return </keyword>") {
      switch (line) {
        case "<keyword> let </keyword>":
          letDecleration();
          break;
        case "<keyword> if </keyword>":
          compileIf();
          break;
        case "<keyword> while </keyword>":
          compileWhile();
          break;
        case "<keyword> do </keyword>":
          compileDo();
          break;
        case "<keyword> return </keyword>":
          compileReturn();
          break;
      }

      line = myNextToken();
      tokenBack();
    }

    indentToken--;
    printLine("</statements>");
  }

  void letDecleration() {
    String line;
    List<String> words;

    printLine("<letStatement>");
    indentToken++;

    line = myNextToken();

    // 'let'
    if (line == "<keyword> let </keyword>") {
      printLine(line);
    } else {
      throw "Syntax error!";
    }

    line = myNextToken();
    words = line.split(" ");

    // varName
    if (words[0] == "<identifier>" && words[2] == "</identifier>") {
      printLine(line);
    } else {
      throw "Syntax error!";
    }

    line = myNextToken();

    // ('[' expression ']')?
    if (line == "<symbol> [ </symbol>") {
      printLine(line);

      // expression
      compileExpression();

      line = myNextToken();

      // ']'
      if (line == "<symbol> ] </symbol>") {
        printLine(line);
      } else {
        throw "Syntax error!";
      }

      line = myNextToken();
    }

    // '='
    if (line == "<symbol> = </symbol>") {
      printLine(line);
    } else {
      throw "Syntax error!";
    }

    compileExpression();

    line = myNextToken();

    // ';'
    if (line == "<symbol> ; </symbol>") {
      printLine(line);
    } else {
      throw "Syntax error!";
    }

    indentToken--;
    printLine("</letStatement>");
  }

  void compileIf() {
    String line;

    printLine("<ifStatement>");
    indentToken++;

    line = myNextToken();

    // 'if'
    if (line == "<keyword> if </keyword>") {
      printLine(line);
    } else {
      throw "Syntax error!";
    }

    line = myNextToken();

    // '('
    if (line == "<symbol> ( </symbol>") {
      printLine(line);
    } else {
      throw "Syntax error!";
    }

    // expression
    compileExpression();

    line = myNextToken();

    // ')'
    if (line == "<symbol> ) </symbol>") {
      printLine(line);
    } else {
      throw "Syntax error!";
    }

    line = myNextToken();

    // '{'
    if (line == "<symbol> { </symbol>") {
      printLine(line);
    } else {
      throw "Syntax error!";
    }

    // statements
    statements();

    line = myNextToken();

    // '}'
    if (line == "<symbol> } </symbol>") {
      printLine(line);
    } else {
      throw "Syntax error!";
    }

    line = myNextToken();

    // ('else' '{' statements '}')?
    if (line == "<keyword> else </keyword>") {
      printLine(line);

      line = myNextToken();

      // '{'
      if (line == "<symbol> { </symbol>") {
        printLine(line);
      } else {
        throw "Syntax error!";
      }

      // statements
      statements();

      line = myNextToken();

      // '}'
      if (line == "<symbol> } </symbol>") {
        printLine(line);
      } else {
        throw "Syntax error!";
      }
    } else {
      tokenBack();
    }

    indentToken--;
    printLine("</ifStatement>");
  }

  void compileWhile() {
    String line;

    printLine("<whileStatement>");
    indentToken++;

    line = myNextToken();

    // 'while'
    if (line == "<keyword> while </keyword>") {
      printLine(line);
    } else {
      throw "Syntax error!";
    }

    line = myNextToken();

    // '('
    if (line == "<symbol> ( </symbol>") {
      printLine(line);
    } else {
      throw "Syntax error!";
    }

    // expression
    compileExpression();

    line = myNextToken();

    // ')'
    if (line == "<symbol> ) </symbol>") {
      printLine(line);
    } else {
      throw "Syntax error!";
    }

    line = myNextToken();

    // '{'
    if (line == "<symbol> { </symbol>") {
      printLine(line);
    } else {
      throw "Syntax error!";
    }

    // statements
    statements();

    line = myNextToken();

    // '}'
    if (line == "<symbol> } </symbol>") {
      printLine(line);
    } else {
      throw "Syntax error!";
    }

    indentToken--;
    printLine("</whileStatement>");
  }

  void compileDo() {
    String line;
    List<String> words;

    printLine("<doStatement>");
    indentToken++;

    line = myNextToken();

    // 'do'
    if (line == "<keyword> do </keyword>") {
      printLine(line);
    } else {
      throw "Syntax error!";
    }

    do {
      line = myNextToken();
      words = line.split(" ");

      if (words[0] == "<identifier>" && words[2] == "</identifier>") {
        printLine(line);
      } else {
        throw "Syntax error!";
      }

      line = myNextToken();
      printLine(line);
    } while (line == "<symbol> . </symbol>");

    if (line != "<symbol> ( </symbol>") {
      throw "Syntax error!";
    }

    compileExpressionList();

    line = myNextToken();

    if (line == "<symbol> ) </symbol>") {
      printLine(line);
    } else {
      throw "Syntax error!";
    }

    line = myNextToken();

    // ';'
    if (line == "<symbol> ; </symbol>") {
      printLine(line);
    } else {
      throw "Syntax error!";
    }

    indentToken--;
    printLine("</doStatement>");
  }

  void compileReturn() {
    String line;

    printLine("<returnStatement>");
    indentToken++;

    line = myNextToken();

    // 'return'
    if (line == "<keyword> return </keyword>") {
      printLine(line);
    } else {
      throw "Syntax error!";
    }

    line = myNextToken();

    // expression?
    if (line != "<symbol> ; </symbol>") {
      tokenBack();
      compileExpression();
      line = myNextToken();
    }

    // ';'
    if (line == "<symbol> ; </symbol>") {
      printLine(line);
    } else {
      throw "Syntax error!";
    }

    indentToken--;
    printLine("</returnStatement>");
  }

  void compileExpression() {
    String line;
    List<String> words;

    printLine("<expression>");
    indentToken++;

    // tern
    compileTerm();

    line = myNextToken();
    words = line.split(" ");

    // (op tern)*
    while (
        words[0] == "<symbol>" && isOp(words[1]) && words[2] == "</symbol>") {
      printLine(line);

      compileTerm();

      line = myNextToken();
      words = line.split(" ");
    }

    tokenBack();

    indentToken--;
    printLine("</expression>");
  }

  void compileTerm() {
    String line;
    List<String> words;

    printLine("<term>");
    indentToken++;

    line = myNextToken();
    words = line.split(" ");

    // integerConstant || stringConstant || keywordConstant
    if (words[0] == "<integerConstant>" && words[2] == "</integerConstant>" ||
        words.first == "<stringConstant>" &&
            words.last == "</stringConstant>" ||
        line == "<keyword> true </keyword>" ||
        line == "<keyword> false </keyword>" ||
        line == "<keyword> null </keyword>" ||
        line == "<keyword> this </keyword>") {
      printLine(line);
    } else if (line == "<symbol> ( </symbol>") {
      // '(' expression ')'
      printLine(line);

      // expression
      compileExpression();

      line = myNextToken();

      // ')'
      if (line == "<symbol> ) </symbol>") {
        printLine(line);
      } else {
        throw "Syntax error!";
      }
    } else if (line == "<symbol> - </symbol>" ||
        line == "<symbol> ~ </symbol>") {
      // unaryOp term
      printLine(line);

      // term
      compileTerm();
    } else if (words[0] == "<identifier>" && words[2] == "</identifier>") {
      printLine(line);

      line = myNextToken();

      if (line == "<symbol> [ </symbol>") {
        // '[' expression ']'
        printLine(line);

        // expression
        compileExpression();

        line = myNextToken();

        // ')'
        if (line == "<symbol> ] </symbol>") {
          printLine(line);
        } else {
          throw "Syntax error!";
        }
      } else if (line == "<symbol> . </symbol>" ||
          line == "<symbol> ( </symbol>") {
        // subroutineCall
        while (line == "<symbol> . </symbol>") {
          printLine(line);

          line = myNextToken();
          words = line.split(" ");

          if (words[0] == "<identifier>" && words[2] == "</identifier>") {
            printLine(line);
          } else {
            throw "Syntax error!";
          }

          line = myNextToken();
        }

        if (line == "<symbol> ( </symbol>") {
          printLine(line);
        } else {
          throw "Syntax error!";
        }

        compileExpressionList();

        line = myNextToken();

        if (line == "<symbol> ) </symbol>") {
          printLine(line);
        } else {
          throw "Syntax error!";
        }
      } else {
        // varName
        tokenBack();
      }
    } else {
      throw "Syntax error!";
    }

    indentToken--;
    printLine("</term>");
  }

  void compileExpressionList() {
    String line;
    List<String> words;

    printLine("<expressionList>");
    indentToken++;

    line = myNextToken();
    words = line.split(" ");

    if (words[0] == "<integerConstant>" && words[2] == "</integerConstant>" ||
        words.first == "<stringConstant>" &&
            words.last == "</stringConstant>" ||
        words[0] == "<identifier>" && words[2] == "</identifier>" ||
        line == "<keyword> true </keyword>" ||
        line == "<keyword> false </keyword>" ||
        line == "<keyword> null </keyword>" ||
        line == "<keyword> this </keyword>" ||
        line == "<symbol> ( </symbol>" ||
        line == "<symbol> - </symbol>" ||
        line == "<symbol> ~ </symbol>") {
      tokenBack();

      // expression
      compileExpression();

      line = myNextToken();

      // (',' expression)*
      while (line == "<symbol> , </symbol>") {
        printLine(line);

        compileExpression();

        line = myNextToken();
      }
    }

    tokenBack();

    indentToken--;
    printLine("</expressionList>");
  }

  bool isOp(String op) {
    return op == "+" ||
        op == "-" ||
        op == "*" ||
        op == "/" ||
        op == "&amp;" ||
        op == "|" ||
        op == "&lt;" ||
        op == "&gt;" ||
        op == "=";
  }
}
