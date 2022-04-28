import 'package:flutter/material.dart';

import 'User/settingsPage.dart';
import 'User/homePage.dart';
import 'User/profilePage.dart';
import 'User/searchPage.dart';


class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _barIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTapped(int index) {
    setState(() {
      _barIndex = index;
      _pageController.jumpToPage(_barIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tirbuschon"),
        actions: [_settingsButton(context)],
      ),
      body: _body(),
      bottomNavigationBar: _bottomNavigationBar(),
    );
  }

  BottomNavigationBar _bottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _barIndex,
      onTap: _onTapped,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Search',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile')
      ],
    );
  }

  PageView _body() {
    return PageView(
      physics: const NeverScrollableScrollPhysics(),
      onPageChanged: (index) {
        setState(() {
          _barIndex = index;
        });
      },
      controller: _pageController,
      children: const [
        HomePage(),
        SearchPage(),
        ProfilePage(),
      ],
    );
  }

  IconButton _settingsButton(BuildContext context) {
    return IconButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const SettingsPage()));
        },
        icon: const Icon(Icons.settings));
      body: Center(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
           Text("Here is the main page.", style: TextStyle(fontSize: 20)),
           Text("Resizing images below",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
           Text("Original Image",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
          Container(
            width: MediaQuery.of(context).size.width - 50,
            height: MediaQuery.of(context).size.width / 2.25,
            padding: const EdgeInsets.all(15),
            child: Image.network(
                'https://internationalnewsagency.org/wp-content/uploads/2020/11/frozen-face-emoji.jpg'),
          ),
           Text("Image after resizing",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
          Container(
            width: MediaQuery.of(context).size.width - 20,
            height: MediaQuery.of(context).size.width / 2.25,
            padding: const EdgeInsets.all(15),
            child: resizeImage(
                'https://internationalnewsagency.org/wp-content/uploads/2020/11/frozen-face-emoji.jpg'),
          ),
          const Text("Name hiding below",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
               ],
      )
          //_pages.elementAt(_barIndex),
          );
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _barIndex,
        onTap: _onTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile')
        ],
      );
  }

  Image resizeImage(String urlLink) {
    var resizedImage = Image(
        image: ResizeImage(NetworkImage(urlLink), width: 250, height: 250));
    return resizedImage;
  }
}
