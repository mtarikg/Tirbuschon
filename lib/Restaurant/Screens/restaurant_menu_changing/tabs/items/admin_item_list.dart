import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tirbuschon_feng497/Controllers/admin/admin_item_controller.dart';
import 'package:tirbuschon_feng497/Restaurant/Screens/restaurant_menu_changing/item.dart';
import 'package:tirbuschon_feng497/Restaurant/Screens/restaurant_menu_changing/tabs/items/widgets/admin_item_tile.dart';


class AdminItemList extends StatelessWidget {
  AsyncSnapshot snapshot;
  AdminItemList({required this.snapshot});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(horizontal:10, vertical: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("Items", style: Theme.of(context).textTheme.subtitle1),
              IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                   
                    Provider.of<AdminItemController>(context, listen: false).setItem(Item());
                    Provider.of<AdminItemController>(context, listen: false).setImageFile(null);
                  }),
            ],
          ),
        ),
        (snapshot == null || snapshot.data == null || snapshot.data.length == 0)
            ? Center(
                child: Text('Nothing to display.'),
              )
            : Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (_, int index) {
                    return AdminItemTile(item: snapshot.data[index]);
                  },
                ),
              ),
      ],
    );
  }
}
