class Item {
  Item({String? id, String? name, String? image, double? price, String? desc}) {
    this.id = id!;
    this.name = name!;
    this.image = image!;
    this.price = price!;
  }

  String? id;
  String? name;
  double? price;
  String? desc;
  String? image;
}
