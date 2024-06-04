import 'package:flutter/material.dart';
import 'package:food_users/mainScreens/item_sceen.dart';

import '../models/menus.dart';

class MenuDesign extends StatefulWidget {
  Menus? model;
  BuildContext? context;

  MenuDesign({super.key, this.model, this.context});

  @override
  _MenuDesignState createState() => _MenuDesignState();
}

class _MenuDesignState extends State<MenuDesign> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (c) => ItemsScreen(model: widget.model)));
      },
      splashColor: Colors.cyan,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: SizedBox(
          height: 280,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Divider(
                height: 2,
                thickness: 3,
                color: Colors.grey[300],
              ),
              Image.network(
                widget.model!.thumbnailUrl!,
                height: 220.0,
                fit: BoxFit.cover,
              ),
              const SizedBox(
                height: 1.0,
              ),
              Text(
                widget.model!.menuTitle!,
                style: const TextStyle(
                  color: Colors.cyan,
                  fontSize: 20,
                  fontFamily: "Bea",
                ),
              ),
              Text(
                widget.model!.menuInfo!,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
              Divider(
                height: 2,
                thickness: 3,
                color: Colors.grey[300],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
