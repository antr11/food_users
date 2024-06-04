import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_users/models/items.dart';
import 'package:number_inc_dec/number_inc_dec.dart';

import '../assistantMethods/assistant_methods.dart';
import '../widgets/app_bar.dart';

class ItemDetailScreen extends StatefulWidget {
  const ItemDetailScreen({super.key, this.model});
  final Items? model;

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  TextEditingController counterTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: MyAppBar(sellerUID: widget.model!.sellerUID),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.network(
              alignment: Alignment.center,
              widget.model!.thumbnailUrl.toString(),
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: NumberInputPrefabbed.roundedButtons(
                controller: counterTextEditingController,
                incDecBgColor: Colors.amber,
                min: 1,
                max: 9,
                initialValue: 1,
                buttonArrangement: ButtonArrangement.incRightDecLeft,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.model!.title.toString(),
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.model!.longDescription.toString(),
                textAlign: TextAlign.justify,
                style: const TextStyle(
                    fontWeight: FontWeight.normal, fontSize: 14),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "${widget.model!.price} VND",
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Center(
              child: InkWell(
                onTap: () {
                  int itemCounter =
                      int.parse(counterTextEditingController.text);

                  List<String> separateItemIDsList = separateItemIDs();

                  //1.check if item exist already in cart
                  separateItemIDsList.contains(widget.model!.itemID)
                      ? Fluttertoast.showToast(msg: "Bạn đã thêm vào giỏ hàng.")
                      :
                      //2.add to cart
                      addItemToCart(widget.model!.itemID, context, itemCounter);
                },
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.cyan,
                  ),
                  width: MediaQuery.of(context).size.width - 13,
                  height: 50,
                  child: const Center(
                    child: Text(
                      "Thêm vào giỏ hàng",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
