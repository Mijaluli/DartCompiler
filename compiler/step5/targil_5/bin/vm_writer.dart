import 'dart:io';

import 'command_type.dart';

enum SegmentType { CONST, ARG, LOCAL, STATIC, THIS, THAT, POINTER, TEMP }

class VMWriter {
  IOSink outputVmFile;

  VMWriter(IOSink output) {
    this.outputVmFile = output;
  }

  String segments(SegmentType segment) {
    switch (segment) {
      case SegmentType.CONST:
        return "constant";
      case SegmentType.ARG:
        return "argument";
      case SegmentType.LOCAL:
        return "local";
      case SegmentType.STATIC:
        return "static";
      case SegmentType.THIS:
        return "this";
      case SegmentType.THAT:
        return "that";
      case SegmentType.POINTER:
        return "pointer";
      case SegmentType.TEMP:
        return "temp";
      default:
        throw "Segment Error!";
    }
  }

  void writeArithmetic(CommandType command) {
    switch (command) {
      case CommandType.ADD:
        outputVmFile.writeln("add");
        break;
      case CommandType.SUB:
        outputVmFile.writeln("sub");
        break;
      case CommandType.NEG:
        outputVmFile.writeln("neg");
        break;
      case CommandType.EQ:
        outputVmFile.writeln("eq");
        break;
      case CommandType.GT:
        outputVmFile.writeln("gt");
        break;
      case CommandType.LT:
        outputVmFile.writeln("lt");
        break;
      case CommandType.AND:
        outputVmFile.writeln("and");
        break;
      case CommandType.OR:
        outputVmFile.writeln("or");
        break;
      case CommandType.NOT:
        outputVmFile.writeln("not");
        break;
    }
  }

  void writeLabel(String label) {
    outputVmFile.writeln("label $label");
  }

  void writeGoto(String label) {
    outputVmFile.writeln("goto $label");
  }

  void writeIf(String label) {
    outputVmFile.writeln("if-goto $label");
  }

  void writeCall(String name, int nArgs) {
    outputVmFile.writeln("call $name $nArgs");
  }

  void writeFunction(String name, int nLocals) {
    outputVmFile.writeln("function $name $nLocals");
  }

  void writeReturn() {
    outputVmFile.writeln("return");
  }

  void writePush(SegmentType segment, int index) {
    outputVmFile.writeln("push ${segments(segment)} $index");
  }

  void writePop(SegmentType segment, int index) {
    outputVmFile.writeln("pop ${segments(segment)} $index");
  }
}
