import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tirbuschon_feng497/Controllers/admin/admin_item_controller.dart';
import 'package:tirbuschon_feng497/Restaurant/Screens/restaurant_menu_changing/item.dart';

class AdminItemTile extends StatelessWidget {
  Item item;
  AdminItemTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 2,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              // Photo
              Container(
                width: 75,
                height: 75,
                child: AspectRatio(
                  aspectRatio: .1,
                  child: FittedBox(
                    child: Image.network(item.image.toString()),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(item.name.toString(),
                      style: Theme.of(context).textTheme.bodyText1),
                  Text('\$' + item.price.toString(),
                      style: Theme.of(context).textTheme.bodyText2),
                ],
              ),
            ],
          ),

          // RIGHT SIDE OF THE TILE
          Row(
            children: <Widget>[
              // DELETE ITEM BUTTON
              IconButton(
                icon: Icon(Icons.delete_outline),
                onPressed: () async {
                  String message =
                      Provider.of<AdminItemController>(context, listen: false)
                          .deleteItem(item);
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text(message),
                    backgroundColor: Colors.red[900],
                  ));
                },
              ),

              // EDIT ITEM BUTTON
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  //Provider.of<AdminController>(context, listen: false).switchTabBody('AddEditItem');
                  Provider.of<AdminItemController>(context, listen: false)
                      .setItem(item);
                  Provider.of<AdminItemController>(context, listen: false)
                      .setImageFile(null);
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
