import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_users/models/seller.dart';
import 'package:food_users/widgets/seller_design.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _ScearchScreenState();
}

class _ScearchScreenState extends State<SearchScreen> {
  Future<QuerySnapshot>? restaurantDocumentList;
  String sellerNameText = "";
  initSearchingRestaurant(String textEntered) async {
    restaurantDocumentList = FirebaseFirestore.instance
        .collection("sellers")
        .where("sellerName", isGreaterThanOrEqualTo: textEntered)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(color: Colors.cyan),
        ),
        title: TextField(
          onChanged: (textEntered) {
            setState(() {
              sellerNameText = textEntered;
            });
            //init search
            initSearchingRestaurant(textEntered);
          },
          decoration: InputDecoration(
            hintText: "Tìm kiếm nhà hàng..",
            helperStyle: const TextStyle(color: Colors.white),
            border: InputBorder.none,
            suffixIcon: IconButton(
              onPressed: () {
                initSearchingRestaurant(sellerNameText);
              },
              icon: const Icon(
                Icons.search,
                color: Colors.white,
              ),
            ),
          ),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
      body: FutureBuilder(
          future: restaurantDocumentList,
          builder: (context, snapshot) {
            return snapshot.hasData
                ? ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      Sellers model = Sellers.fromJson(
                          snapshot.data!.docs[index].data()!
                              as Map<String, dynamic>);
                      return SellersDesignWidget(
                        model: model,
                        context: context,
                      );
                    },
                  )
                : Center(
                    child: Container(),
                  );
          }),
    );
  }
}
