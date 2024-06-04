import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_users/assistantMethods/total_amount.dart';
import 'package:food_users/mainScreens/address_screen.dart';
import 'package:food_users/widgets/progress_bar.dart';
import 'package:provider/provider.dart';
import '../assistantMethods/assistant_methods.dart';
import 'package:food_users/assistantMethods/cart_Item_Counter.dart';
import '../models/items.dart';
import '../splashScreen/splash_screen.dart';
import '../widgets/cart_item_design.dart';
import '../widgets/text_widget_header.dart';

class CartScreen extends StatefulWidget {
  final String? sellerUID;

  const CartScreen({super.key, this.sellerUID});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<int>? separateItemQuantityList;
  num totalAmount = 0;

  @override
  void initState() {
    super.initState();

    totalAmount = 0;
    Provider.of<TotalAmount>(context, listen: false).displayTotalAmount(0);

    separateItemQuantityList = separateItemQuantities();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(color: Colors.cyan),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "kittenGo",
          style: TextStyle(fontSize: 45, fontFamily: "Bea"),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.shopping_cart,
                  color: Colors.cyan,
                ),
                onPressed: () {
                  print("clicked");
                },
              ),
              Positioned(
                child: Stack(
                  children: [
                    const Icon(
                      Icons.brightness_1,
                      size: 20.0,
                      color: Colors.green,
                    ),
                    Positioned(
                      top: 3,
                      right: 4,
                      child: Center(
                        child: Consumer<CartItemCounter>(
                          builder: (context, counter, c) {
                            return Text(
                              counter.count.toString(),
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 12),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const SizedBox(
            width: 10,
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: FloatingActionButton.extended(
              heroTag: "clear",
              label: const Text(
                "Xóa giỏ hàng",
                style: TextStyle(fontSize: 16),
              ),
              backgroundColor: Colors.cyan,
              icon: const Icon(Icons.clear_all),
              onPressed: () {
                clearCartNow(context);

                Navigator.push(context,
                    MaterialPageRoute(builder: (c) => const MySplashScreen()));

                Fluttertoast.showToast(msg: "Xóa giỏ hàng thành công.");
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: FloatingActionButton.extended(
              heroTag: "check out",
              label: const Text(
                "Thanh toán",
                style: TextStyle(fontSize: 16),
              ),
              backgroundColor: Colors.cyan,
              icon: const Icon(Icons.navigate_next),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (c) => AddressScreen(
                      totalAmount: totalAmount.toDouble(),
                      sellerUID: widget.sellerUID,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          //overall total amount
          SliverPersistentHeader(
              pinned: true, delegate: TextWidgetHeader(title: "Giỏ hàng")),

          SliverToBoxAdapter(
            child: Consumer2<TotalAmount, CartItemCounter>(
                builder: (context, amountProvider, cartProvider, c) {
              return Padding(
                padding: const EdgeInsets.all(8),
                child: Center(
                  child: cartProvider.count == 0
                      ? Container()
                      : Text(
                          "Tổng: ${amountProvider.tAmount}",
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                ),
              );
            }),
          ),

          //display cart items with quantity number
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("items")
                .where("itemID", whereIn: separateItemIDs())
                .orderBy("publishedDate", descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              return !snapshot.hasData
                  ? SliverToBoxAdapter(
                      child: Center(
                        child: circularProgress(),
                      ),
                    )
                  : snapshot.data!.docs.isEmpty
                      ? Container()
                      : SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              Items model = Items.fromJson(
                                snapshot.data!.docs[index].data()!
                                    as Map<String, dynamic>,
                              );

                              if (index == 0) {
                                totalAmount = 0;
                                totalAmount = totalAmount +
                                    (model.price! *
                                        separateItemQuantityList![index]);
                              } else {
                                totalAmount = totalAmount +
                                    (model.price! *
                                        separateItemQuantityList![index]);
                              }

                              if (snapshot.data!.docs.length - 1 == index) {
                                WidgetsBinding.instance
                                    .addPostFrameCallback((timeStamp) {
                                  Provider.of<TotalAmount>(context,
                                          listen: false)
                                      .displayTotalAmount(
                                          totalAmount.toDouble());
                                });
                              }

                              return CartItemDesign(
                                model: model,
                                context: context,
                                quanNumber: separateItemQuantityList![index],
                              );
                            },
                            childCount: snapshot.hasData
                                ? snapshot.data!.docs.length
                                : 0,
                          ),
                        );
            },
          ),
        ],
      ),
    );
  }
}
