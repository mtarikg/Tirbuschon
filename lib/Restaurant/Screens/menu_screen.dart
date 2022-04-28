import 'package:flutter/material.dart';

class MenuScreen extends StatefulWidget {
  MenuScreen({Key? key}) : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Welcome',
          style: TextStyle(color: Colors.black87, fontFamily: 'Montserrat'),
        ),
        /* actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              right: MediaQuery.of(context).size.width * 0.04,
            ),
            child: const Icon(
              Icons.edit,
              color: Colors.black87,
            ),
          )
        ], */
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _createMenuList(),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Restaurant Activities',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Icon(
                    Icons.edit,
                    color: Colors.black54,
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  makeProduct(
                    image: 'assets/images/muzik.jpg',
                    title: 'Actity 1',
                    id: 1,
                  ),
                  makeProduct(
                    image: 'assets/images/muzik.jpg',
                    title: 'Actity 2',
                    id: 1,
                  ),
                  makeProduct(
                    image: 'assets/images/muzik.jpg',
                    title: 'Actity 3',
                    id: 1,
                  ),
                  makeProduct(
                    image: 'assets/images/muzik.jpg',
                    title: 'Actity 4',
                    id: 1,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget makeProduct({
  image,
  title,
  id,
}) {
  late double height1, weight1;
  if (id == 0) {
    height1 = 400;
    weight1 = 200;
  } else if(id == 1) {
      height1 = 200;
      weight1 = 400;
    };
  return InkWell(
    onTap: () {},
    child: Container(
        height: height1,
        width: weight1,
        margin: EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image:
                DecorationImage(image: AssetImage(image), fit: BoxFit.cover)),
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            //crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        title,
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        )),
  );
}

Widget _createMenuList() {
  List categories = [
    'Menu ',
  ];
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              categories[0],
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            InkWell(
              onTap: () {},
              child: Text(
                'See all',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 15),
      Container(
        height: 200,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            const SizedBox(width: 20),
            makeProduct(
              image: 'assets/images/exapmleFood.jpg',
              title: 'Fish',
              id: 0,
            ),
            const SizedBox(width: 20),
            makeProduct(
              image: 'assets/images/exapmleFood.jpg',
              title: 'Fish',
              id: 0,
            ),
            const SizedBox(width: 20),
            makeProduct(
              image: 'assets/images/exapmleFood.jpg',
              title: 'Fish',
              id: 0,
            ),
            const SizedBox(width: 20),
            makeProduct(
              image: 'assets/images/exapmleFood.jpg',
              title: 'Fish',
              id: 0,
            ),
            const SizedBox(width: 20),
            makeProduct(
              image: 'assets/images/exapmleFood.jpg',
              title: 'Fish',
              id: 0,
            ),
            const SizedBox(width: 20),
          ],
        ),
      ),
    ],
  );
}
