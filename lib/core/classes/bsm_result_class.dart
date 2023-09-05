class BsmResult {
  final int messageId;
  final String messageBody;
  final String bsmResultText;
  final String tagListStr;

  BsmResult({
    required this.messageId,
    required this.messageBody,
    required this.bsmResultText,
    required this.tagListStr,
  });

  BsmResult copyWith({
    int? messageId,
    String? messageBody,
    String? bsmResultText,
    String? tagListStr,
  }) =>
      BsmResult(
        messageId: messageId ?? this.messageId,
        messageBody: messageBody ?? this.messageBody,
        bsmResultText: bsmResultText ?? this.bsmResultText,
        tagListStr: tagListStr ?? this.tagListStr,
      );

  factory BsmResult.fromJson(Map<String, dynamic> json) => BsmResult(
    messageId: json["MessageID"],
    messageBody: json["MessageBody"],
    bsmResultText: json["BSMResultText"],
    tagListStr: json["TagList"]??"",
  );

  Map<String, dynamic> toJson() => {
    "MessageID": messageId,
    "MessageBody": messageBody,
    "BSMResultText": bsmResultText,
    "TagList": tagListStr,
  };

  List<String> get getTags => tagListStr.split(",");
}

class BsmTag {
  final String tagNumber;

  BsmTag({
    required this.tagNumber,
  });

  BsmTag copyWith({
    String? tagNumber,
  }) =>
      BsmTag(
        tagNumber: tagNumber ?? this.tagNumber,
      );

  factory BsmTag.fromJson(Map<String, dynamic> json) => BsmTag(
    tagNumber: json["TagNumber"],
  );

  Map<String, dynamic> toJson() => {
    "TagNumber": tagNumber,
  };
}