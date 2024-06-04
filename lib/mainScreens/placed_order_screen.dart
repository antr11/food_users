import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_users/assistantMethods/assistant_methods.dart';
import 'package:food_users/global/global.dart';
import 'package:food_users/mainScreens/home_screen.dart';
import 'package:pay/pay.dart';

import '../assistantMethods/payment_config.dart';

class PlacedOrderScreen extends StatefulWidget {
  String? addressID;
  double? totalAmount;
  String? sellerUID;

  PlacedOrderScreen(
      {super.key, this.addressID, this.totalAmount, this.sellerUID});

  @override
  State<PlacedOrderScreen> createState() => _PlacedOrderScreenState();
}

class _PlacedOrderScreenState extends State<PlacedOrderScreen> {
  String orderId = DateTime.now().millisecondsSinceEpoch.toString();
  List<PaymentItem> paymentItems = [];

  addOrderDetails() {
    writeOrderDetailsForUser({
      "addressID": widget.addressID,
      "totalAmount": widget.totalAmount,
      "orderBy": sharedPreferences!.getString("uid"),
      "productIDs": sharedPreferences!.getStringList("userCart"),
      "paymentDetails": "Cash on Delivery",
      "orderTime": orderId,
      "isSuccess": true,
      "sellerUID": widget.sellerUID,
      "riderUID": "",
      "status": "normal",
      "orderId": orderId,
    });
    writeOrderDetailsForSeller({
      "addressID": widget.addressID,
      "totalAmount": widget.totalAmount,
      "orderBy": sharedPreferences!.getString("uid"),
      "productIDs": sharedPreferences!.getStringList("userCart"),
      "paymentDetails": "Cash on Delivery",
      "orderTime": orderId,
      "isSuccess": true,
      "sellerUID": widget.sellerUID,
      "riderUID": "",
      "status": "normal",
      "orderId": orderId,
    }).whenComplete(() {
      clearCartNow(context);
      setState(() {
        orderId = "";
        Navigator.push(
            context, MaterialPageRoute(builder: (c) => const HomeScreen()));
        Fluttertoast.showToast(msg: " đơn hàng của bạn đã được đặt thành công");
      });
    });
  }

  void onGooglePayResult(res) {
    writeOrderDetailsForUser({
      "addressID": widget.addressID,
      "totalAmount": widget.totalAmount,
      "orderBy": sharedPreferences!.getString("uid"),
      "productIDs": sharedPreferences!.getStringList("userCart"),
      "paymentDetails": "Paid by card",
      "orderTime": orderId,
      "isSuccess": true,
      "sellerUID": widget.sellerUID,
      "riderUID": "",
      "status": "normal",
      "orderId": orderId,
    });
    writeOrderDetailsForSeller({
      "addressID": widget.addressID,
      "totalAmount": widget.totalAmount,
      "orderBy": sharedPreferences!.getString("uid"),
      "productIDs": sharedPreferences!.getStringList("userCart"),
      "paymentDetails": "Paid by card",
      "orderTime": orderId,
      "isSuccess": true,
      "sellerUID": widget.sellerUID,
      "riderUID": "",
      "status": "normal",
      "orderId": orderId,
    }).whenComplete(() {
      clearCartNow(context);
      setState(() {
        orderId = "";
        Navigator.push(
            context, MaterialPageRoute(builder: (c) => const HomeScreen()));
        Fluttertoast.showToast(msg: " đơn hàng của bạn đã được đặt thành công");
      });
    });
  }

  Future writeOrderDetailsForUser(
    Map<String, dynamic> data,
  ) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(sharedPreferences!.getString("uid"))
        .collection("orders")
        .doc(orderId)
        .set(data);
  }

  Future writeOrderDetailsForSeller(
    Map<String, dynamic> data,
  ) async {
    await FirebaseFirestore.instance
        .collection("orders")
        .doc(orderId)
        .set(data);
  }

  @override
  void initState() {
    super.initState();
    paymentItems.add(
      PaymentItem(
        amount: widget.totalAmount.toString(),
        label: 'Total Amount',
        status: PaymentItemStatus.final_price,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.cyan,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("images/delivery.jpg"),
            const SizedBox(
              height: 12,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: const EdgeInsets.all(14),
              ),
              onPressed: () {
                addOrderDetails();
              },
              child: const Text("Place Order"),
            ),
            const SizedBox(
              height: 5,
            ),
            const Text(
              "OR",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            GooglePayButton(
              // paymentConfigurationAsset: 'gpay.json',
              paymentConfiguration:
                  PaymentConfiguration.fromJsonString(defaultGooglePay),
              onPaymentResult: onGooglePayResult,
              paymentItems: paymentItems,
              height: 50,

              type: GooglePayButtonType.buy,
              margin: const EdgeInsets.only(top: 15),
              loadingIndicator: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
