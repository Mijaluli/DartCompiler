enum KindType { STATIC, FIELD, ARG, VAR, NONE }

class Symbol {
  KindType kind;
  String type;
  int index;

  Symbol(KindType kind, String type, int index) {
    this.kind = kind;
    this.type = type;
    this.index = index;
  }
}

class SymbolTable {
  Map<String, Symbol> classScope, subroutineScope;
  Map<KindType, int> varCounts;

  SymbolTable() {
    classScope = {};
    subroutineScope = {};
    varCounts = {
      KindType.STATIC: 0,
      KindType.FIELD: 0,
      KindType.ARG: 0,
      KindType.VAR: 0
    };
  }

  /**
   * It will reset the subroutine’s symbol table.
   */
  void startSubroutine() {
    subroutineScope = {};
    varCounts[KindType.ARG] = 0;
    varCounts[KindType.VAR] = 0;
  }

  /**
   * It add new variable to the symbol table.
   */
  void define(String name, String type, KindType kind) {
    switch (kind) {
      case KindType.STATIC:
      case KindType.FIELD:
        classScope[name] = Symbol(kind, type, varCounts[kind]++);
        break;
      case KindType.ARG:
      case KindType.VAR:
        subroutineScope[name] = Symbol(kind, type, varCounts[kind]++);
        break;
      default:
        throw "Error in adding to the symbol table!";
    }
  }

  /* how many from some kind in the symbol table.*/

  int varCount(KindType kind) {
    return varCounts[kind];
  }

  /**
   kind of the variable with the name or none if it isn't exist*/

  KindType kindOfVarName(String name) {
    if (subroutineScope[name] != null) {
      return subroutineScope[name].kind;
    } else if (classScope[name] != null) {
      return classScope[name].kind;
    } else {
      return KindType.NONE;
    }
  }

  /**
   type of the variable with the name.
   */
  String typeOfVarName(String name) {
    if (subroutineScope[name] != null) {
      return subroutineScope[name].type;
    } else if (classScope[name] != null) {
      return classScope[name].type;
    } else {
      return null;
    }
  }

  /*ndex of the variable with the name.*/

  int indexOfVarName(String name) {
    if (subroutineScope[name] != null) {
      return subroutineScope[name].index;
    } else if (classScope[name] != null) {
      return classScope[name].index;
    } else {
      return -1;
    }
  }
}
