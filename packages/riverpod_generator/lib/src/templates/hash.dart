import 'dart:convert';

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:crypto/crypto.dart';

import '../models.dart';

class HashTemplate {
  HashTemplate(this.data, this.hash);

  final Data data;
  final ElementHash hash;

  @override
  String toString() {
    return "String ${data.hashFunctionName}() => r'${hash.hashElement(data.createElement, data.createAst)}';";
  }
}

class ElementHash {
  String hashElement(Element element, AstNode astNode) {
    // TODO improve hash function to inspect the body of the create fn
    // such that the hash changes if one of the element defined outside of the
    // fn changes.
    final bytes = utf8.encode(astNode.toSource());
    final digest = sha1.convert(bytes);
    return digest.toString();
  }
}
