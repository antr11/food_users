import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:food_users/widgets/menu_design.dart';

import '../assistantMethods/assistant_methods.dart';
import '../models/menus.dart';
import '../models/seller.dart';
import '../splashScreen/splash_screen.dart';
import '../widgets/progress_bar.dart';
import '../widgets/text_widget_header.dart';

class MenusScreen extends StatefulWidget {
  final Sellers? model;
  const MenusScreen({super.key, this.model});

  @override
  _MenusScreenState createState() => _MenusScreenState();
}

class _MenusScreenState extends State<MenusScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            color: Colors.cyan,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            clearCartNow(context);

            Navigator.push(context,
                MaterialPageRoute(builder: (c) => const MySplashScreen()));
          },
        ),
        title: const Text(
          "kittenGo",
          style: TextStyle(fontSize: 45, fontFamily: "Bea"),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
              pinned: true,
              delegate:
                  TextWidgetHeader(title: "${widget.model!.sellerName} Menus")),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("sellers")
                .doc(widget.model!.sellerUID)
                .collection("menus")
                .orderBy("publishedDate", descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              return !snapshot.hasData
                  ? SliverToBoxAdapter(
                      child: Center(
                        child: circularProgress(),
                      ),
                    )
                  : SliverStaggeredGrid.countBuilder(
                      crossAxisCount: 1,
                      staggeredTileBuilder: (c) => const StaggeredTile.fit(1),
                      itemBuilder: (context, index) {
                        Menus model = Menus.fromJson(
                          snapshot.data!.docs[index].data()!
                              as Map<String, dynamic>,
                        );
                        return MenuDesign(
                          model: model,
                          context: context,
                        );
                      },
                      itemCount: snapshot.data!.docs.length,
                    );
            },
          ),
        ],
      ),
    );
  }
}
