import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_users/global/global.dart';
import 'package:food_users/widgets/simple_app_bar.dart';

import '../assistantMethods/assistant_methods.dart';
import '../widgets/order_card.dart';
import '../widgets/progress_bar.dart';

class MyOrderScreen extends StatefulWidget {
  const MyOrderScreen({super.key});

  @override
  State<MyOrderScreen> createState() => _MyOrderScreenState();
}

class _MyOrderScreenState extends State<MyOrderScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: SimpleAppBar(
          title: " Orders của tôi",
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("users")
              .doc(sharedPreferences!.getString("uid"))
              .collection("orders")
              .where("status", isEqualTo: "normal")
              .orderBy("orderTime", descending: true)
              .snapshots(),
          builder: (c, snapshot) {
            return snapshot.hasData
                ? ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (c, index) {
                      return FutureBuilder<QuerySnapshot>(
                        future: FirebaseFirestore.instance
                            .collection("items")
                            .where("itemID",
                                whereIn: separateOrderItemIDs(
                                    (snapshot.data!.docs[index].data()!
                                        as Map<String, dynamic>)["productIDs"]))
                            .where("orderBy",
                                whereIn: (snapshot.data!.docs[index].data()!
                                    as Map<String, dynamic>)["uid"])
                            .orderBy("publishedDate", descending: true)
                            .get(),
                        builder: (c, snap) {
                          return snap.hasData
                              ? Container(
                                  margin: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black)),
                                  child: Column(
                                    children: [
                                      Text(
                                        ' OrderID:  ${snapshot.data!.docs[index].id}',
                                      ),
                                      OrderCard(
                                        itemCount: snap.data!.docs.length,
                                        data: snap.data!.docs,
                                        orderID: snapshot.data!.docs[index].id,
                                        seperateQuantitiesList:
                                            separateOrderItemQuantities(
                                                (snapshot.data!.docs[index]
                                                            .data()!
                                                        as Map<
                                                            String, dynamic>)[
                                                    "productIDs"]),
                                      ),
                                    ],
                                  ),
                                )
                              : Center(child: circularProgress());
                        },
                      );
                    },
                  )
                : Center(
                    child: circularProgress(),
                  );
          },
        ),
      ),
    );
  }
}
