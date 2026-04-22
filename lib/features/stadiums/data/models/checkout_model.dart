class CheckoutRequest {
  final int fieldId;
  final int userId;
  final String date;
  final String startTime;
  final String endTime;

  CheckoutRequest({
    required this.fieldId,
    required this.userId,
    required this.date,
    required this.startTime,
    required this.endTime,
  });

  Map<String, dynamic> toJson() => {
        'field_id': fieldId,
        'user_id': userId,
        'date': date,
        'start_time': startTime,
        'end_time': endTime,
      };
}

class CheckoutResponse {
  /// The Stripe payment URL returned by the server.
  final String paymentUrl;

  CheckoutResponse({required this.paymentUrl});

  factory CheckoutResponse.fromJson(Map<String, dynamic> json) {
    final url = json['url']?.toString() ?? '';
    if (url.isEmpty) {
      throw Exception('Checkout response missing payment URL');
    }
    return CheckoutResponse(paymentUrl: url);
  }
}
