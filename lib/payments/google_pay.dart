import 'package:pay/pay.dart';

const _paymentItems = [
  PaymentItem(
    label: 'Total',
    amount: '99.99',
    status: PaymentItemStatus.final_price,
  )
];

ApplePayButton(
  paymentConfigurationAsset: 'default_payment_profile_apple_pay.json',
  paymentItems: _paymentItems,
  style: ApplePayButtonStyle.black,
  type: ApplePayButtonType.buy,
  margin: const EdgeInsets.only(top: 15.0),
  onPaymentResult: onApplePayResult,
  loadingIndicator: const Center(
    child: CircularProgressIndicator(),
  ),
),

GooglePayButton(
  paymentConfigurationAsset: 'default_payment_profile_google_pay.json',
  paymentItems: _paymentItems,
  type: GooglePayButtonType.pay,
  margin: const EdgeInsets.only(top: 15.0),
  onPaymentResult: onGooglePayResult,
  loadingIndicator: const Center(
    child: CircularProgressIndicator(),
  ),
),

void onApplePayResult(paymentResult) {
  // Send the resulting Apple Pay token to your server / PSP
}

void onGooglePayResult(paymentResult) {
  // Send the resulting Google Pay token to your server / PSP
}