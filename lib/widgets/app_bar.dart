import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_users/assistantMethods/cart_Item_Counter.dart';
import 'package:food_users/mainScreens/cart_screen.dart';
import 'package:provider/provider.dart';

import '../global/global.dart';
import '../mainScreens/cart_screen_empty.dart';

class MyAppBar extends StatefulWidget implements PreferredSizeWidget {
  final PreferredSizeWidget? bottom;
  final String? sellerUID;

  const MyAppBar({super.key, this.bottom, this.sellerUID});

  @override
  State<MyAppBar> createState() => _MyAppBarState();

  @override
  Size get preferredSize => bottom == null
      ? Size(56, AppBar().preferredSize.height)
      : Size(56, 80 + AppBar().preferredSize.height);
}

class _MyAppBarState extends State<MyAppBar> {
  @override
  var totalEmpty;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          color: Colors.cyan,
        ),
      ),
      leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back)),
      title: const Text(
        "kittenGo",
        style: TextStyle(fontSize: 40, fontFamily: "Bea"),
      ),
      centerTitle: true,
      automaticallyImplyLeading: true,
      actions: [
        Stack(
          children: [
            IconButton(
              icon: const Icon(
                Icons.shopping_cart,
                color: Colors.black,
              ),
              onPressed: () {
                // send user to cart screen
                totalEmpty =
                    sharedPreferences!.getStringList("userCart")!.length;
                if (totalEmpty != 1) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (c) =>
                              CartScreen(sellerUID: widget.sellerUID)));
                } else {
                  Fluttertoast.showToast(msg: 'Giỏ hàng của bạn đang trống');
                }
              },
            ),
            Positioned(
              child: Stack(
                children: [
                  const Icon(
                    Icons.brightness_1,
                    size: 20,
                    color: Colors.green,
                  ),
                  Positioned(
                    top: 4,
                    right: 3,
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
            )
          ],
        )
      ],
    );
  }
}
