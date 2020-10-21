import 'dart:io';
import 'command_type.dart';
import 'symbol_table.dart';
import 'vm_writer.dart';

/* takes tokens' xml file and compile it according to the grammar rules.  */

/*swiches*/
enum SubroutineType { CONSTRUCTOR, FUNCTION, METHOD }
enum FlowControlType { IF, WHILE }

class CompilationEngine {
  List<String> lines;
  int lengthOfLine, nextPoint = 0;
  String className;
  SymbolTable symbolTable;
  VMWriter vmWriter;
  Map<FlowControlType, int> flowControlIndex;

  CompilationEngine();

  /* It open a jack file and read*/

  void init(List<String> tokens, IOSink destinationFile) {
    lines = tokens;
    lengthOfLine = lines.length;
    symbolTable = SymbolTable();
    vmWriter = VMWriter(destinationFile);
  }

  /**
   * Get next token.
   */
  String getNextToken() {
    if (nextPoint < lengthOfLine) {
      return lines[nextPoint++];
    } else {
      throw "Syntax error!";
    }
  }

  /* Move back */

  void moveTokenBack() {
    nextPoint--;
  }

  void compileClassParser() {
    String line;
    List<String> words;

    line = getNextToken();

    // 'class'
    if (line != "<keyword> class </keyword>") {
      throw "Syntax error!";
    }

    line = getNextToken();
    words = line.split(" ");

    // className
    if (words[0] == "<identifier>" && words[2] == "</identifier>") {
      className = words[1];
    } else {
      throw "Syntax error!";
    }

    line = getNextToken();

    // '{'
    if (line != "<symbol> { </symbol>") {
      throw "Syntax error!";
    }

    line = getNextToken();

    // classVarDec*
    while (line == "<keyword> static </keyword>" ||
        line == "<keyword> field </keyword>") {
      moveTokenBack();
      compileClassVarDecleration();

      line = getNextToken();
    }

    // subroutineDec*
    while (line == "<keyword> constructor </keyword>" ||
        line == "<keyword> function </keyword>" ||
        line == "<keyword> method </keyword>") {
      moveTokenBack();
      compileSubroutineDecleration();

      line = getNextToken();
    }

    // '}'
    if (line != "<symbol> } </symbol>") {
      throw "Syntax error!";
    }
  }

/*subroutinrDecleration*/
  void compileSubroutineDecleration() {
    String line, name;
    List<String> words;
    SubroutineType type;

    symbolTable.startSubroutine();
    flowControlIndex = {FlowControlType.IF: 0, FlowControlType.WHILE: 0};

    line = getNextToken();

    // ('constructor'|'function'|'method')
    if (line == "<keyword> method </keyword>") {
      symbolTable.define("this", className, KindType.ARG);
      type = SubroutineType.METHOD;
    } else if (line == "<keyword> constructor </keyword>") {
      type = SubroutineType.CONSTRUCTOR;
    } else if (line == "<keyword> function </keyword>") {
      type = SubroutineType.FUNCTION;
    } else {
      throw "Syntax error!";
    }

    line = getNextToken();
    words = line.split(" ");

    // 'void'|type = ('void'|'int'|'char'|'boolean'|className)
    if (line == "<keyword> void </keyword>" ||
        line == "<keyword> int </keyword>" ||
        line == "<keyword> char </keyword>" ||
        line == "<keyword> boolean </keyword>" ||
        words[0] == "<identifier>" && words[2] == "</identifier>") {
      // _printLine(line);
    } else {
      throw "Syntax error!";
    }

    line = getNextToken();
    words = line.split(" ");

    // subroutineName
    if (words[0] == "<identifier>" && words[2] == "</identifier>") {
      name = words[1];
    } else {
      throw "Syntax error!";
    }

    line = getNextToken();

    // '('
    if (line != "<symbol> ( </symbol>") {
      throw "Syntax error!";
    }

    // parameterList
    compileParameterList();

    line = getNextToken();

    // ')'
    if (line != "<symbol> ) </symbol>") {
      throw "Syntax error!";
    }

    compileSubroutineBody(type, name);
  }

  /*var decleration*/
  void compileClassVarDecleration() {
    String line, name, type;
    List<String> words;
    KindType kind;

    line = getNextToken();

    // ('static'|'field')
    if (line == "<keyword> static </keyword>") {
      kind = KindType.STATIC;
    } else if (line == "<keyword> field </keyword>") {
      kind = KindType.FIELD;
    } else {
      throw "Syntax error!";
    }

    line = getNextToken();
    words = line.split(" ");

    // type = ('int'|'char'|'boolean'|className)
    if (line == "<keyword> int </keyword>" ||
        line == "<keyword> char </keyword>" ||
        line == "<keyword> boolean </keyword>" ||
        words[0] == "<identifier>" && words[2] == "</identifier>") {
      type = words[1];
    } else {
      throw "Syntax error!";
    }

    line = getNextToken();
    words = line.split(" ");

    // varName
    if (words[0] == "<identifier>" && words[2] == "</identifier>") {
      name = words[1];
    } else {
      throw "Syntax error!";
    }

    symbolTable.define(name, type, kind);

    line = getNextToken();

    // (',' varName)*
    while (line == "<symbol> , </symbol>") {
      line = getNextToken();
      words = line.split(" ");

      // varName
      if (words[0] == "<identifier>" && words[2] == "</identifier>") {
        name = words[1];
      } else {
        throw "Syntax error!";
      }

      symbolTable.define(name, type, kind);

      line = getNextToken();
    }

    // ';'
    if (line != "<symbol> ; </symbol>") {
      throw "Syntax error!";
    }
  }

  void compileParameterList() {
    String line, name, type;
    List<String> words;

    line = getNextToken();
    words = line.split(" ");

    // type = ('int'|'char'|'boolean'|className)
    if (line == "<keyword> int </keyword>" ||
        line == "<keyword> char </keyword>" ||
        line == "<keyword> boolean </keyword>" ||
        words[0] == "<identifier>" && words[2] == "</identifier>") {
      type = words[1];
    } else {
      moveTokenBack();
      return;
    }

    line = getNextToken();
    words = line.split(" ");

    // varName
    if (words[0] == "<identifier>" && words[2] == "</identifier>") {
      name = words[1];
    } else {
      throw "Syntax error!";
    }

    symbolTable.define(name, type, KindType.ARG);

    line = getNextToken();

    // (',' type varName)*
    while (line == "<symbol> , </symbol>") {
      line = getNextToken();

      // type = ('int'|'char'|'boolean'|className)
      if (line == "<keyword> int </keyword>" ||
          line == "<keyword> char </keyword>" ||
          line == "<keyword> boolean </keyword>" ||
          words[0] == "<identifier>" && words[2] == "</identifier>") {
        type = words[1];
      } else {
        throw "Syntax error!";
      }

      line = getNextToken();
      words = line.split(" ");

      // varName
      if (words[0] == "<identifier>" && words[2] == "</identifier>") {
        name = words[1];
      } else {
        throw "Syntax error!";
      }

      symbolTable.define(name, type, KindType.ARG);

      line = getNextToken();
    }

    moveTokenBack();
  }

  void compileSubroutineBody(SubroutineType type, String name) {
    String line;
    int nLocals;

    line = getNextToken();

    // '{'
    if (line != "<symbol> { </symbol>") {
      throw "Syntax error!";
    }

    line = getNextToken();

    // varDec*
    while (line == "<keyword> var </keyword>") {
      moveTokenBack();
      compileVarDec();

      line = getNextToken();
    }

    name = className + "." + name;
    nLocals = symbolTable.varCount(KindType.VAR);

    vmWriter.writeFunction(name, nLocals);

    if (type == SubroutineType.CONSTRUCTOR) {
      vmWriter.writePush(
          SegmentType.CONST, symbolTable.varCount(KindType.FIELD));
      vmWriter.writeCall("Memory.alloc", 1);
      vmWriter.writePop(SegmentType.POINTER, 0);
    } else if (type == SubroutineType.METHOD) {
      vmWriter.writePush(SegmentType.ARG, 0);
      vmWriter.writePop(SegmentType.POINTER, 0);
    }

    moveTokenBack();
    compileStatements();

    line = getNextToken();

    // '}'
    if (line != "<symbol> } </symbol>") {
      throw "Syntax error!";
    }
  }

  void compileVarDec() {
    String line, name, type;
    List<String> words;

    line = getNextToken();

    // 'var'
    if (line != "<keyword> var </keyword>") {
      throw "Syntax error!";
    }

    line = getNextToken();
    words = line.split(" ");

    // type = ('int'|'char'|'boolean'|className)
    if (line == "<keyword> int </keyword>" ||
        line == "<keyword> char </keyword>" ||
        line == "<keyword> boolean </keyword>" ||
        words[0] == "<identifier>" && words[2] == "</identifier>") {
      type = words[1];
    } else {
      throw "Syntax error!";
    }

    line = getNextToken();
    words = line.split(" ");

    // varName
    if (words[0] == "<identifier>" && words[2] == "</identifier>") {
      name = words[1];
    } else {
      throw "Syntax error!";
    }

    symbolTable.define(name, type, KindType.VAR);

    line = getNextToken();

    // (',' varName)*
    while (line == "<symbol> , </symbol>") {
      line = getNextToken();
      words = line.split(" ");

      // varName
      if (words[0] == "<identifier>" && words[2] == "</identifier>") {
        name = words[1];
      } else {
        throw "Syntax error!";
      }

      symbolTable.define(name, type, KindType.VAR);

      line = getNextToken();
    }

    // ';'
    if (line != "<symbol> ; </symbol>") {
      throw "Syntax error!";
    }
  }

  void compileStatements() {
    String line;

    line = getNextToken();
    moveTokenBack();

    // statement*
    while (line == "<keyword> let </keyword>" ||
        line == "<keyword> if </keyword>" ||
        line == "<keyword> while </keyword>" ||
        line == "<keyword> do </keyword>" ||
        line == "<keyword> return </keyword>") {
      switch (line) {
        case "<keyword> let </keyword>":
          compileLet();
          break;
        case "<keyword> if </keyword>":
          compileIf();
          break;
        case "<keyword> while </keyword>":
          compileWhile();
          break;
        case "<keyword> do </keyword>":
          compileDo();
          vmWriter.writePop(SegmentType.TEMP, 0);
          break;
        case "<keyword> return </keyword>":
          compileReturn();
          break;
      }

      line = getNextToken();
      moveTokenBack();
    }
  }

  void compileLet() {
    String line, varName;
    List<String> words;
    bool isArray = false;

    line = getNextToken();

    // 'let'
    if (line != "<keyword> let </keyword>") {
      throw "Syntax error!";
    }

    line = getNextToken();
    words = line.split(" ");

    // varName
    if (words[0] == "<identifier>" && words[2] == "</identifier>") {
      varName = words[1];
    } else {
      throw "Syntax error!";
    }

    line = getNextToken();

    // ('[' expression ']')?
    if (line == "<symbol> [ </symbol>") {
      isArray = true;

      // expression
      compileExpression();

      vmWriter.writePush(_kindToSegment(symbolTable.kindOfVarName(varName)),
          symbolTable.indexOfVarName(varName));
      vmWriter.writeArithmetic(CommandType.ADD);

      line = getNextToken();

      // ']'
      if (line != "<symbol> ] </symbol>") {
        throw "Syntax error!";
      }

      line = getNextToken();
    }

    // '='
    if (line != "<symbol> = </symbol>") {
      throw "Syntax error!";
    }

    compileExpression();

    if (isArray) {
      vmWriter.writePop(SegmentType.TEMP, 0);
      vmWriter.writePop(SegmentType.POINTER, 1);
      vmWriter.writePush(SegmentType.TEMP, 0);
      vmWriter.writePop(SegmentType.THAT, 0);
    } else {
      vmWriter.writePop(_kindToSegment(symbolTable.kindOfVarName(varName)),
          symbolTable.indexOfVarName(varName));
    }

    line = getNextToken();

    // ';'
    if (line != "<symbol> ; </symbol>") {
      throw "Syntax error!";
    }
  }

  void compileIf() {
    String line;
    int ifIndex = flowControlIndex[FlowControlType.IF]++;

    line = getNextToken();

    // 'if'
    if (line != "<keyword> if </keyword>") {
      throw "Syntax error!";
    }

    line = getNextToken();

    // '('
    if (line != "<symbol> ( </symbol>") {
      throw "Syntax error!";
    }

    // expression
    compileExpression();

    vmWriter.writeIf("IF_TRUE$ifIndex");
    vmWriter.writeGoto("IF_FALSE$ifIndex");
    vmWriter.writeLabel("IF_TRUE$ifIndex");

    line = getNextToken();

    // ')'
    if (line != "<symbol> ) </symbol>") {
      throw "Syntax error!";
    }

    line = getNextToken();

    // '{'
    if (line != "<symbol> { </symbol>") {
      throw "Syntax error!";
    }

    // statements
    compileStatements();

    line = getNextToken();

    // '}'
    if (line != "<symbol> } </symbol>") {
      throw "Syntax error!";
    }

    line = getNextToken();

    if (line == "<keyword> else </keyword>") {
      vmWriter.writeGoto("IF_END$ifIndex");
    }

    vmWriter.writeLabel("IF_FALSE$ifIndex");

    // ('else' '{' statements '}')?
    if (line == "<keyword> else </keyword>") {
      line = getNextToken();

      // '{'
      if (line != "<symbol> { </symbol>") {
        throw "Syntax error!";
      }

      // statements
      compileStatements();

      vmWriter.writeLabel("IF_END$ifIndex");

      line = getNextToken();

      // '}'
      if (line != "<symbol> } </symbol>") {
        throw "Syntax error!";
      }
    } else {
      moveTokenBack();
    }
  }

  void compileWhile() {
    String line;
    int whileIndex = flowControlIndex[FlowControlType.WHILE]++;

    line = getNextToken();

    // 'while'
    if (line != "<keyword> while </keyword>") {
      throw "Syntax error!";
    }

    line = getNextToken();

    // '('
    if (line != "<symbol> ( </symbol>") {
      throw "Syntax error!";
    }

    vmWriter.writeLabel("WHILE_EXP$whileIndex");

    // expression
    compileExpression();

    line = getNextToken();

    // ')'
    if (line != "<symbol> ) </symbol>") {
      throw "Syntax error!";
    }

    line = getNextToken();

    // '{'
    if (line != "<symbol> { </symbol>") {
      throw "Syntax error!";
    }

    vmWriter.writeArithmetic(CommandType.NOT);
    vmWriter.writeIf("WHILE_END$whileIndex");

    // statements
    compileStatements();

    vmWriter.writeGoto("WHILE_EXP$whileIndex");
    vmWriter.writeLabel("WHILE_END$whileIndex");

    line = getNextToken();

    // '}'
    if (line != "<symbol> } </symbol>") {
      throw "Syntax error!";
    }
  }

  void compileDo() {
    String line, name;
    List<String> words;
    bool isMethod = false;

    line = getNextToken();

    // 'do'
    if (line != "<keyword> do </keyword>") {
      throw "Syntax error!";
    }

    line = getNextToken();
    words = line.split(" ");

    if (words[0] == "<identifier>" && words[2] == "</identifier>") {
      name = words[1];

      // Handle with if it's a method:
      if (symbolTable.kindOfVarName(name) != KindType.NONE) {
        String varName = name;
        name = symbolTable.typeOfVarName(name);
        isMethod = true;
        vmWriter.writePush(_kindToSegment(symbolTable.kindOfVarName(varName)),
            symbolTable.indexOfVarName(varName));
      }
    } else {
      throw "Syntax error!";
    }

    line = getNextToken();

    if (line != "<symbol> . </symbol>") {
      vmWriter.writePush(SegmentType.POINTER, 0);
      name = className + "." + name;
      isMethod = true;
    }

    while (line == "<symbol> . </symbol>") {
      line = getNextToken();
      words = line.split(" ");

      if (words[0] == "<identifier>" && words[2] == "</identifier>") {
        name += "." + words[1];
      } else {
        throw "Syntax error!";
      }

      line = getNextToken();
    }

    if (line != "<symbol> ( </symbol>") {
      throw "Syntax error!";
    }

    int nArgs = compileExpressionList();

    if (isMethod) {
      nArgs++;
    }

    vmWriter.writeCall(name, nArgs);

    line = getNextToken();

    if (line != "<symbol> ) </symbol>") {
      throw "Syntax error!";
    }

    line = getNextToken();

    // ';'
    if (line != "<symbol> ; </symbol>") {
      throw "Syntax error!";
    }
  }

  void compileReturn() {
    String line;

    line = getNextToken();

    // 'return'
    if (line != "<keyword> return </keyword>") {
      throw "Syntax error!";
    }

    line = getNextToken();

    // expression?
    if (line == "<symbol> ; </symbol>") {
      vmWriter.writePush(SegmentType.CONST, 0);
    } else {
      moveTokenBack();
      compileExpression();
      line = getNextToken();
    }

    vmWriter.writeReturn();

    // ';'
    if (line != "<symbol> ; </symbol>") {
      throw "Syntax error!";
    }
  }

  void compileExpression() {
    String line;
    List<String> words;

    // tern
    compileTerm();

    line = getNextToken();
    words = line.split(" ");

    // (op tern)*
    while (
        words[0] == "<symbol>" && _isOp(words[1]) && words[2] == "</symbol>") {
      compileTerm();

      switch (words[1]) {
        case "+":
          vmWriter.writeArithmetic(CommandType.ADD);
          break;
        case "-":
          vmWriter.writeArithmetic(CommandType.SUB);
          break;
        case "*":
          vmWriter.writeCall("Math.multiply", 2);
          break;
        case "/":
          vmWriter.writeCall("Math.divide", 2);
          break;
        case "&amp;":
          vmWriter.writeArithmetic(CommandType.AND);
          break;
        case "|":
          vmWriter.writeArithmetic(CommandType.OR);
          break;
        case "&lt;":
          vmWriter.writeArithmetic(CommandType.LT);
          break;
        case "&gt;":
          vmWriter.writeArithmetic(CommandType.GT);
          break;
        case "=":
          vmWriter.writeArithmetic(CommandType.EQ);
          break;
      }

      line = getNextToken();
      words = line.split(" ");
    }

    moveTokenBack();
  }

  void compileTerm() {
    String line, name;
    List<String> words;

    line = getNextToken();
    words = line.split(" ");

    // integerConstant
    if (words[0] == "<integerConstant>" && words[2] == "</integerConstant>") {
      vmWriter.writePush(SegmentType.CONST, int.parse(words[1]));
    } else if (line == "<keyword> true </keyword>") {
      // keywordConstant (ture)
      vmWriter.writePush(SegmentType.CONST, 0);
      vmWriter.writeArithmetic(CommandType.NOT);
    } else if (line == "<keyword> false </keyword>" ||
        line == "<keyword> null </keyword>") {
      // keywordConstant (false|null)
      vmWriter.writePush(SegmentType.CONST, 0);
    } else if (line == "<keyword> this </keyword>") {
      // keywordConstant (this)
      vmWriter.writePush(SegmentType.POINTER, 0);
    } else if (words.first == "<stringConstant>" &&
        words.last == "</stringConstant>") {
      // stringConstant
      String str = line.substring(17, line.length - 18);
      vmWriter.writePush(SegmentType.CONST, str.length);
      vmWriter.writeCall("String.new", 1);

      for (int i = 0; i < str.length; i++) {
        vmWriter.writePush(SegmentType.CONST, str.codeUnitAt(i));
        vmWriter.writeCall("String.appendChar", 2);
      }
    } else if (line == "<symbol> ( </symbol>") {
      // '(' expression ')'
      // expression
      compileExpression();

      line = getNextToken();

      // ')'
      if (line != "<symbol> ) </symbol>") {
        throw "Syntax error!";
      }
    } else if (line == "<symbol> - </symbol>") {
      // unaryOp term (neg)
      // term
      compileTerm();

      vmWriter.writeArithmetic(CommandType.NEG);
    } else if (line == "<symbol> ~ </symbol>") {
      // unaryOp term (not)

      // term
      compileTerm();

      vmWriter.writeArithmetic(CommandType.NOT);
    } else if (words[0] == "<identifier>" && words[2] == "</identifier>") {
      name = words[1];

      line = getNextToken();

      if (line == "<symbol> [ </symbol>") {
        // '[' expression ']'
        // expression
        compileExpression();

        vmWriter.writePush(_kindToSegment(symbolTable.kindOfVarName(name)),
            symbolTable.indexOfVarName(name));
        vmWriter.writeArithmetic(CommandType.ADD);

        vmWriter.writePop(SegmentType.POINTER, 1);
        vmWriter.writePush(SegmentType.THAT, 0);

        line = getNextToken();

        // ')'
        if (line != "<symbol> ] </symbol>") {
          throw "Syntax error!";
        }
      } else if (line == "<symbol> . </symbol>" ||
          line == "<symbol> ( </symbol>") {
        // subroutineCall
        bool isMethod = false;

        if (symbolTable.kindOfVarName(name) != KindType.NONE) {
          String varName = name;
          name = symbolTable.typeOfVarName(name);
          isMethod = true;
          vmWriter.writePush(_kindToSegment(symbolTable.kindOfVarName(varName)),
              symbolTable.indexOfVarName(varName));
        }

        if (line != "<symbol> . </symbol>") {
          vmWriter.writePush(SegmentType.POINTER, 0);
          name = className + "." + name;
          isMethod = true;
        }

        while (line == "<symbol> . </symbol>") {
          line = getNextToken();
          words = line.split(" ");

          if (words[0] == "<identifier>" && words[2] == "</identifier>") {
            name += "." + words[1];
          } else {
            throw "Syntax error!";
          }

          line = getNextToken();
        }

        if (line != "<symbol> ( </symbol>") {
          throw "Syntax error!";
        }

        int nArgs = compileExpressionList();

        if (isMethod) {
          nArgs++;
        }

        vmWriter.writeCall(name, nArgs);

        line = getNextToken();

        if (line != "<symbol> ) </symbol>") {
          throw "Syntax error!";
        }
      } else {
        // varName
        vmWriter.writePush(_kindToSegment(symbolTable.kindOfVarName(name)),
            symbolTable.indexOfVarName(name));
        moveTokenBack();
      }
    } else {
      throw "Syntax error!";
    }
  }

  int compileExpressionList() {
    String line;
    List<String> words;
    int nExpr = 0;

    line = getNextToken();
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
      moveTokenBack();

      nExpr++;

      // expression
      compileExpression();

      line = getNextToken();

      // (',' expression)*
      while (line == "<symbol> , </symbol>") {
        compileExpression();

        nExpr++;

        line = getNextToken();
      }
    }

    moveTokenBack();

    return nExpr;
  }

  bool _isOp(String op) {
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

  SegmentType _kindToSegment(KindType kind) {
    switch (kind) {
      case KindType.STATIC:
        return SegmentType.STATIC;
        break;
      case KindType.FIELD:
        return SegmentType.THIS;
        break;
      case KindType.ARG:
        return SegmentType.ARG;
        break;
      case KindType.VAR:
        return SegmentType.LOCAL;
        break;
      default:
        throw "Syntax error!";
    }
  }
}
