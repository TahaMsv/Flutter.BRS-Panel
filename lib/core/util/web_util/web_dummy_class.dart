import 'dart:collection';
import 'dart:typed_data';

class HtmlDocument {
  var body;

  createElement(String s) {}
}

class Blob {
  Blob(List<Uint8List> list, String s);
}

class Url {
  static createObjectUrlFromBlob(Blob blob) {}
}

class AnchorElement {
  var href;

  var style;

  late String download;

  void click() {}
}

HtmlDocument get document => HtmlDocument();

class Storage with MapMixin<String, String> {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

Window get window => Window(Storage());

JS(String s, String t) {}

class Window {
  Storage sessionStorage;

  Window(this.sessionStorage);
}
