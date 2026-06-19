import 'dart:io';

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:pay/pay.dart';

class PayVM extends BaseViewModel {
  String os = Platform.operatingSystem;

  static const defaultApplePay = '''{
  "provider": "apple_pay",
  "data": {
    "merchantIdentifier": "merchant.com.yourcompany.app",
    "displayName": "Your Business Name",
    "merchantCapabilities": ["3DS"],
    "supportedNetworks": ["visa", "masterCard"],
    "countryCode": "US",
    "currencyCode": "USD"
    }
  }
  ''';

  static const defaultGooglePay = '''{
  "provider": "google_pay",
  "data": {
    "environment": "TEST",
    "apiVersion": 2,
    "apiVersionMinor": 0,

    "allowedPaymentMethods": [
      {
        "type": "CARD",
        "parameters": {
          "allowedAuthMethods": ["PAN_ONLY", "CRYPTOGRAM_3DS"],
          "allowedCardNetworks": ["VISA", "MASTERCARD"]
        },
        "tokenizationSpecification": {
          "type": "PAYMENT_GATEWAY",
          "parameters": {
            "gateway": "example",
            "gatewayMerchantId": "exampleGatewayMerchantId"
          }
        }
      }
    ],

    "transactionInfo": {
      "totalPriceStatus": "FINAL",
      "totalPrice": "1.00",
      "currencyCode": "USD"
    },

    "merchantInfo": {
      "merchantName": "Test Merchant"
    }
  }
}
  ''';

  var applePayButton = ApplePayButton(
    paymentConfiguration: PaymentConfiguration.fromJsonString(defaultApplePay),
    paymentItems: const [
      PaymentItem(amount: '100', label: 'Item 1'),
      PaymentItem(amount: '50', label: 'Item 2'),
      PaymentItem(amount: '10', label: 'Item 3'),
    ],
    style: ApplePayButtonStyle.black,
    width: double.infinity,
    height: 50,
    type: ApplePayButtonType.buy,
    onPaymentResult: (result) => debugPrint('payment successful'),
    loadingIndicator: Center(child: CircularProgressIndicator()),
  );

  var googlePlayButton = GooglePayButton(
    paymentConfiguration: PaymentConfiguration.fromJsonString(defaultGooglePay),
    paymentItems: const [
      PaymentItem(
        amount: '100',
        label: 'Item 1',
        status: PaymentItemStatus.final_price,
      ),
      PaymentItem(
        amount: '100',
        label: 'Item 2',
        status: PaymentItemStatus.final_price,
      ),
      PaymentItem(
        amount: '100',
        label: 'Item 3',
        status: PaymentItemStatus.final_price,
      ),
    ],
    width: double.infinity,
    height: 50,
    type: GooglePayButtonType.buy,
    onPaymentResult: (result) {
      debugPrint('Google Pay Result: $result');
    },
    loadingIndicator: Center(child: CircularProgressIndicator()),
  );
}
