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
