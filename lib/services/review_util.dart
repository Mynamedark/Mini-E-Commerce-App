import 'package:in_app_review/in_app_review.dart';

class ReviewUtil {
  static Future<void> requestReview() async {
    final i = InAppReview.instance;
    if (await i.isAvailable()) {
      await i.requestReview();
    }
  }
}
