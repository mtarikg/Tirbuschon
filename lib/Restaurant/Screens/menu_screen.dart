import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tirbuschon_feng497/Restaurant/Screens/product_card.dart';
import 'package:tirbuschon_feng497/Restaurant/Screens/venue_menu.dart';
import 'package:tirbuschon_feng497/services/firestoreService.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final _fs = FirebaseFirestore.instance;
  final id = FirebaseAuth.instance.currentUser!.uid;

  final _drinks = <Map<String, dynamic>>[];
  final _meals = <Map<String, dynamic>>[];
  final _deserts = <Map<String, dynamic>>[];
  final _activities = <Map<String, dynamic>>[];
  final _titleNode = FocusNode();
  final _descNode = FocusNode();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isMenuFetched = false;
  bool _isActivitiesFetched = false;

  @override
  void initState() {
    _getMenu();
    _getActivities();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          'Welcome',
          style: TextStyle(color: Colors.black87, fontFamily: 'Montserrat'),
        ),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      body: Flex(
        direction: Axis.vertical,
        children: [
          _isMenuFetched
              ? _createMenuList(context)
              : const Center(child: CircularProgressIndicator()),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Planned Activities',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: _showAddDialog,
                  icon: const Icon(
                    Icons.add,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          if (_isActivitiesFetched)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 20,
                ),
                child: ListView.builder(
                  itemCount: _activities.length,
                  itemBuilder: (context, index) {
                    final ac = _activities[index];

                    return SizedBox(
                      height: 200,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          ProductCard(
                            image: 'assets/images/muzik.jpg',
                            title: ac['Title'],
                            width: 400,
                            onTap: () {
                              final snackBar = SnackBar(
                                backgroundColor: Colors.black,
                                content: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    ac['Description'],
                                  ),
                                ),
                              );

                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            },
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              onPressed: () {
                                _deleteActivity(ac["id"]);
                              },
                              icon: const Icon(
                                Icons.delete_forever_outlined,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _getMenu() async {
    var menuData = await FirestoreService().getMenu(id);
    var menuValue = menuData["Menu"] as Map<String, dynamic>;

    final drinks = menuValue['Drinks'];
    final deserts = menuValue['Deserts'];
    final meals = menuValue['Meals'];

    setState(() {
      if (drinks != null) {
        _drinks.addAll(List<Map<String, dynamic>>.from(drinks));
      }
      if (deserts != null) {
        _deserts.addAll(List<Map<String, dynamic>>.from(deserts));
      }
      if (meals != null) {
        _meals.addAll(List<Map<String, dynamic>>.from(meals));
      }

      _isMenuFetched = true;
    });
  }

  Future<void> _getActivities() async {
    var acData = await FirestoreService().getActivities(id);
    var activityList = List<Map<String, dynamic>>.from(acData["Activity"]);

    setState(() {
      _activities.addAll(activityList);
      _isActivitiesFetched = true;
    });
  }

  Future<void> _deleteActivity(int activityId) async {
    final _snapshot =
        await _fs.collection('Venues').doc(id).collection('Activity').get();
    final activityList = List<Map<String, dynamic>>.from(
      _snapshot.docs.first.data()['Activity'],
    );

    activityList.removeWhere((activity) => activity['id'] == activityId);

    setState(() {
      _activities.removeWhere((activity) => activity['id'] == activityId);
    });

    _fs
        .collection('Venues')
        .doc(id)
        .collection('Activity')
        .doc(_snapshot.docs.first.id)
        .update({
      'Activity': activityList,
    });
  }

  Future<void> _addActivity(String title, String desc) async {
    final _snapshot =
        await _fs.collection('Venues').doc(id).collection('Activity').get();
    final activityList = List<Map<String, dynamic>>.from(
      _snapshot.docs.first.data()['Activity'],
    );
    activityList.add({
      'Title': title,
      'Description': desc,
      'id': activityList.length,
    });

    _fs
        .collection('Venues')
        .doc(id)
        .collection('Activity')
        .doc(_snapshot.docs.first.id)
        .update({
      'Activity': activityList,
    });
  }

  Widget _createMenuList(BuildContext context) {
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
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: 200,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              const SizedBox(width: 20),
              ProductCard(
                image: 'assets/images/exapmleFood.jpg',
                title: 'Meals',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: ((context) {
                      return VenueMenu(
                        title: 'Meals',
                        products: _meals,
                      );
                    })),
                  );
                },
              ),
              const SizedBox(width: 20),
              ProductCard(
                image: 'assets/images/exapmleFood.jpg',
                title: 'Drinks',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: ((context) {
                      return VenueMenu(
                        title: 'Drinks',
                        products: _drinks,
                      );
                    })),
                  );
                },
              ),
              const SizedBox(width: 20),
              ProductCard(
                image: 'assets/images/exapmleFood.jpg',
                title: 'Deserts',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: ((context) {
                      return VenueMenu(
                        title: 'Deserts',
                        products: _deserts,
                      );
                    })),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showAddDialog() {
    showGeneralDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(.6),
      pageBuilder: (context, fa, sa) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Container(
              width: MediaQuery.of(context).size.width * .8,
              height: MediaQuery.of(context).size.height * .4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey.shade200,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 24,
                  horizontal: 16,
                ),
                child: Column(
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          _createTextField(
                            node: _titleNode,
                            keyboardType: TextInputType.text,
                            placeholder: 'Title',
                            validator: (val) {
                              if (val == null) return null;

                              return val.isNotEmpty
                                  ? null
                                  : 'Title field required!';
                            },
                            controller: _titleController,
                          ),
                          const SizedBox(height: 10),
                          _createTextField(
                            node: _descNode,
                            keyboardType: TextInputType.text,
                            placeholder: 'Description',
                            controller: _descController,
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return 'Title field required!';
                              }

                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.orange)),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final title = _titleController.text;
                          final description = _descController.text;

                          await _addActivity(title, description);

                          setState(() {
                            _activities.add(
                              {
                                'Title': title,
                                'Description': description,
                                'id': _activities.length,
                              },
                            );
                          });

                          WidgetsBinding.instance!.addPostFrameCallback((_) {
                            _titleNode.unfocus();
                            _titleController.clear();
                            _descNode.unfocus();
                            _descController.clear();

                            Navigator.of(context).pop();
                          });
                        }
                      },
                      child: const Text('Add'),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _createTextField({
    required FocusNode node,
    required TextInputType keyboardType,
    required String placeholder,
    required TextEditingController controller,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      focusNode: node,
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 16,
      ),
      validator: validator,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: Colors.orange,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: Colors.orange,
          ),
        ),
        hintText: placeholder,
        hintStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 16,
        ),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}
