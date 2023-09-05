class BsmResult {
  final int messageId;
  final String messageBody;
  final String bsmResultText;

  BsmResult({
    required this.messageId,
    required this.messageBody,
    required this.bsmResultText,
  });

  BsmResult copyWith({
    int? messageId,
    String? messageBody,
    String? bsmResultText,
  }) =>
      BsmResult(
        messageId: messageId ?? this.messageId,
        messageBody: messageBody ?? this.messageBody,
        bsmResultText: bsmResultText ?? this.bsmResultText,
      );

  factory BsmResult.fromJson(Map<String, dynamic> json) => BsmResult(
    messageId: json["MessageID"],
    messageBody: json["MessageBody"],
    bsmResultText: json["BSMResultText"],
  );

  Map<String, dynamic> toJson() => {
    "MessageID": messageId,
    "MessageBody": messageBody,
    "BSMResultText": bsmResultText,
  };
}