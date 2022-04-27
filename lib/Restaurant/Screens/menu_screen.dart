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
          'Menu',
          style: TextStyle(color: Colors.black87, fontFamily: 'Montserrat'),
        ),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              right: MediaQuery.of(context).size.width * 0.04,
            ),
            child: const Icon(
              Icons.edit,
              color: Colors.black87,
            ),
          )
        ],
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _createExercisesList(),
            SizedBox(
              height: 15,
            ),
            _createExercisesList(),
            SizedBox(
              height: 15,
            ),
            _createExercisesList(),
            SizedBox(
              height: 15,
            ),
            _createExercisesList(),
            SizedBox(
              height: 15,
            ),
            _createExercisesList(),
          ],
        ),
      ),
    );
  }
}

Widget makeProduct({
  image,
  title,
}) {
  return InkWell(
    onTap: () {},
    child: Container(
        height: 400,
        width: 200,
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
              Align(
                alignment: Alignment.bottomRight,
                child: Icon(
                  Icons.delete,
                  color: Colors.white.withOpacity(0.2),
                  size: 30,
                ),
              ),
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

Widget _createExercisesList() {
  List categories = [
    'Soups ',
    'Salads ',
    'Wraps',
    'Pasta',
    'Meat ',
    'Fish',
  ];
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          categories[0],
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
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
              title: 'Soup',
            ),
            const SizedBox(width: 20),
            makeProduct(
              image: 'assets/images/exapmleFood.jpg',
              title: 'Soup',
            ),
            const SizedBox(width: 20),
            makeProduct(
              image: 'assets/images/exapmleFood.jpg',
              title: 'Soup',
            ),
            const SizedBox(width: 20),
            makeProduct(
              image: 'assets/images/exapmleFood.jpg',
              title: 'Soup',
            ),
            const SizedBox(width: 20),
            makeProduct(
              image: 'assets/images/exapmleFood.jpg',
              title: 'Soup',
            ),
            const SizedBox(width: 20),
          ],
        ),
      ),
    ],
  );
}
