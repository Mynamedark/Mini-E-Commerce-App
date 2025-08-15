import 'dart:convert';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class StripeService {
  // Replace with your Cloud Functions endpoint or your own server
  static const String _endpoint = 'https://YOUR_REGION-YOUR_PROJECT.cloudfunctions.net/createPaymentIntent';

  static Future<void> init() async {
    // For demo only: set publishable key at runtime.
    Stripe.publishableKey = 'pk_test_YOUR_PUBLISHABLE_KEY';
    await Stripe.instance.applySettings();
  }

  static Future<void> checkout({required int amountInCents, required String currency}) async {
    final resp = await http.post(Uri.parse(_endpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'amount': amountInCents, 'currency': currency}));
    if (resp.statusCode != 200) {
      throw Exception('Failed to create PaymentIntent: ${resp.body}');
    }
    final data = jsonDecode(resp.body);
    final clientSecret = data['clientSecret'];
    await Stripe.instance.initPaymentSheet(paymentSheetParameters: SetupPaymentSheetParameters(
      paymentIntentClientSecret: clientSecret,
      merchantDisplayName: 'Mini Shop',
    ));
    await Stripe.instance.presentPaymentSheet();
  }
}
