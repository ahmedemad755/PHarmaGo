import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';

class PayPalDebugger {
  static void checkout({
    required BuildContext context,
    required String clientId,
    required String secretKey,
    required List<Map<String, dynamic>> transactions,
    Function(dynamic)? onSuccess, // ← هنا التعديل
    Function(dynamic)? onError,
    Function()? onCancel,
  }) {
    log("========== 🟦 PayPal Checkout Started 🟦 ==========");
    log("Client ID: $clientId");
    log("Secret Key (first 6 chars): ${secretKey.substring(0, 6)}******");
    log("Transaction JSON:");
    for (var t in transactions) {
      log(t.toString());
    }
    log("===================================================");

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PaypalCheckoutView(
          sandboxMode: true,
          clientId: clientId,
          secretKey: secretKey,
          transactions: transactions,
          note: "Contact us for any questions on your order.",

          onSuccess: (params) {
            log("========== 🟩 PayPal SUCCESS 🟩 ==========");
            log("Response: $params");
            log("=========================================");
            if (onSuccess != null) onSuccess(params);
          },

          onError: (error) {
            log("========== 🟥 PayPal ERROR 🟥 ===========");
            log("Error Details: $error");
            log("==========================================");
            if (onError != null) onError(error);
            Navigator.pop(context);
          },

          onCancel: () {
            log("========== 🟨 PayPal CANCELLED 🟨 =========");
            if (onCancel != null) onCancel();
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
