import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:stripe_payment/stripe_payment.dart';

class StripeTransactionResponse {
  String? message;
  bool? success;
  StripeTransactionResponse({this.message, this.success});
}

class StripeService {
  static String apiBase = 'https://api.stripe.com/v1';
  static String paymentApiUrl = '${StripeService.apiBase}/payment_intents';
  //live key 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
  //test key sk_test_51IBfRbE9NEzcI9oqWBIhu6mngqpIXmnbKTi8jsBJDARXFGBru3D16LvkUd6TPIyxe9Q71wWIa5wx95eaWgR2ehUm00q7hSspCJ
  //= 'sk_test_51IBfRbE9NEzcI9oqWBIhu6mngqpIXmnbKTi8jsBJDARXFGBru3D16LvkUd6TPIyxe9Q71wWIa5wx95eaWgR2ehUm00q7hSspCJ'
  static String? secret;
  static Map<String, String> headers = {
    'Authorization': 'Bearer ${StripeService.secret}',
    'Content-Type': 'application/x-www-form-urlencoded'
  };
  static init(String pubKey,mode,id) {
    StripePayment.setOptions(
        StripeOptions(
            publishableKey: pubKey,
            merchantId: id,
            androidPayMode: mode
        )
    );
  }

  static Future<StripeTransactionResponse> payWithNewCard({String? amount, String? currency}) async {
    try {
      var paymentMethod = await StripePayment.paymentRequestWithCardForm(
          CardFormPaymentRequest()
      );
      var paymentIntent = await StripeService.createPaymentIntent(
          amount!,
          currency!
      );
      var response = await StripePayment.confirmPaymentIntent(
          PaymentIntent(
              clientSecret: paymentIntent['client_secret'],
              paymentMethodId: paymentMethod.id
          )
      );
      if (response.status == 'succeeded') {
        return new StripeTransactionResponse(
            message: 'Transaction successful',
            success: true
        );
      } else {
        return new StripeTransactionResponse(
            message: 'Transaction failed',
            success: false
        );
      }
    } on PlatformException catch(err) {
      return StripeService.getPlatformExceptionErrorResult(err);
    } catch (err) {
      return new StripeTransactionResponse(
          message: 'Transaction failed: ${err.toString()}',
          success: false
      );
    }
  }

  static getPlatformExceptionErrorResult(err) {
    String message = 'Something went wrong';
    if (err.code == 'cancelled') {
      message = 'Transaction cancelled';
    }

    return new StripeTransactionResponse(
        message: message,
        success: false
    );
  }

  static Future<Map<String, dynamic>> createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
        'payment_method_types[]': 'card'
      };
      var response = await http.post(
          Uri.parse(StripeService.paymentApiUrl),
          body: body,
          headers: StripeService.headers
      );
      return jsonDecode(response.body);
    } catch (err) {
      print('err charging user: ${err.toString()}');
    }
    return null!;
  }
}