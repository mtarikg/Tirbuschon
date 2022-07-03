import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VenueMenu extends StatefulWidget {
  const VenueMenu({Key? key, required this.products, required this.title})
      : super(key: key);

  final String title;
  final List<Map<String, dynamic>> products;

  @override
  State<VenueMenu> createState() => _VenueMenuState();
}

class _VenueMenuState extends State<VenueMenu> {
  final _nameNode = FocusNode();
  final _priceNode = FocusNode();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _fs = FirebaseFirestore.instance;
  final id = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.orange,
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: widget.products.length,
                itemBuilder: (context, int index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.products[index]["Name"],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              widget.products[index]["Price"].toString() + "₺",
                            ),
                            const SizedBox(width: 20),
                            IconButton(
                              onPressed: () {
                                _deleteProduct(widget.products[index]["Name"]);
                              },
                              icon: const Icon(
                                Icons.delete_forever_outlined,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: _showAddDialog,
              style: ElevatedButton.styleFrom(
                primary: Colors.orange,
              ),
              child: const Text(
                '+',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
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
                            node: _nameNode,
                            keyboardType: TextInputType.text,
                            placeholder: 'Name',
                            validator: (val) {
                              if (val == null) return null;

                              return val.isNotEmpty
                                  ? null
                                  : 'Name field required!';
                            },
                            controller: _nameController,
                          ),
                          const SizedBox(height: 10),
                          _createTextField(
                            node: _priceNode,
                            keyboardType: TextInputType.number,
                            placeholder: 'Price',
                            controller: _priceController,
                            validator: (val) {
                              if (val == null) return null;

                              return int.parse(val) < 0
                                  ? 'Price should be more then 0!'
                                  : null;
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
                          final name = _nameController.text;
                          final price = int.parse(_priceController.text);
                          await _addProduct(name, price);

                          setState(() {
                            widget.products.add({'Name': name, 'Price': price});
                          });

                          WidgetsBinding.instance!.addPostFrameCallback((_) {
                            _nameNode.unfocus();
                            _priceNode.unfocus();

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

  Future<void> _addProduct(String name, int price) async {
    final _snapshot =
        await _fs.collection('Venues').doc(id).collection('Menu').get();
    final menu = _snapshot.docs.first.data()['Menu'];

    late final List<Map<String, dynamic>> data;
    if (menu[widget.title] == null) {
      data = [];
    } else {
      data = List<Map<String, dynamic>>.from(menu[widget.title]);
    }

    data.add({
      'Name': name,
      'Price': price,
    });
    menu[widget.title] = data;

    _fs
        .collection('Venues')
        .doc(id)
        .collection('Menu')
        .doc(_snapshot.docs.first.id)
        .update({
      'Menu': menu,
    });
  }

  Future<void> _deleteProduct(String name) async {
    final _snapshot =
        await _fs.collection('Venues').doc(id).collection('Menu').get();
    final menu = _snapshot.docs.first.data()['Menu'];
    final data = List<Map<String, dynamic>>.from(menu[widget.title]);

    data.removeWhere((element) => element['Name'] == name);
    widget.products.removeWhere((element) => element['Name'] == name);
    setState(() {});

    menu[widget.title] = data;

    _fs
        .collection('Venues')
        .doc(id)
        .collection('Menu')
        .doc(_snapshot.docs.first.id)
        .update({
      'Menu': menu,
    });
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
            color: Colors.deepOrangeAccent,
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
