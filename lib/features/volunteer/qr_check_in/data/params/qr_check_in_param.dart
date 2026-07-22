class QrCheckInParam {
  final String qr;
  final int event;

  QrCheckInParam({
    required this.qr,
    required this.event,
  });

  Map<String, dynamic> toJson() {
    return {
      "qr": qr,
      "event": event,
    };
  }
}