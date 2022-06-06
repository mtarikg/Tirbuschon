import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tirbuschon_feng497/Core/User/BottomNavigationBarPages/mainPage.dart';
import '../../../services/firestoreService.dart';

class Payment extends StatefulWidget {
  final String venueID;
  final DateTime selectedDate;

  const Payment({Key? key, required this.venueID, required this.selectedDate})
      : super(key: key);

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  final _formKey = GlobalKey<FormState>();
  late String cardHolder = "", cardNumber = "", expiredDate = "", cvv = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          iconSize: 20,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: _cardHolderTextField(),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: _cardNumberTextField(),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: _cardExpiredDateTextField(),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: _cardCVVTextField(),
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                const SizedBox(width: 10),
                const Text("Total Price: 250₺"),
                const SizedBox(width: 10),
                CompleteButton(
                    context: context,
                    formKey: _formKey,
                    id: widget.venueID,
                    capacity: 1,
                    selectedDate: widget.selectedDate,
                    price: 250,
                    cardHolder: cardHolder,
                    cardNumber: cardNumber,
                    expiredDate: expiredDate,
                    cvv: cvv),
              ],
            ),
          ],
        ),
      ),
    );
  }

  TextFormField _cardHolderTextField() {
    return TextFormField(
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.person_outline),
        labelText: "Card Holder",
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return "Card holder can not be empty!";
        }

        return null;
      },
      onChanged: (value) {
        setState(() {
          cardHolder = value.toString();
        });
      },
    );
  }

  TextFormField _cardNumberTextField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      inputFormatters: [LengthLimitingTextInputFormatter(16)],
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.numbers),
        labelText: "Card number",
        hintText: "XXXX XXXX XXXX XXXX",
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return "Card number field can not be empty!";
        } else if (value.trim().length != 16) {
          return "Card number should consist of 16 digits.";
        } else if (value.contains(RegExp(r'[,. ]'))) {
          return "Only numbers";
        }
        return null;
      },
      onChanged: (value) {
        setState(() {
          cardNumber = value.toString();
        });
      },
    );
  }

  TextFormField _cardExpiredDateTextField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      inputFormatters: [LengthLimitingTextInputFormatter(5)],
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.numbers),
        labelText: "Expired Date",
        hintText: "XX/XX ",
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return "Expired date can not be empty!";
        } else if (value.trim().length != 5) {
          return "Expired date should consist of a month and a year value.";
        } else if (value.contains(RegExp(r'[,. ]'))) {
          return "Only numbers";
        }
        return null;
      },
      onChanged: (value) {
        setState(() {
          expiredDate = value.toString();
        });
      },
    );
  }

  TextFormField _cardCVVTextField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      inputFormatters: [LengthLimitingTextInputFormatter(16)],
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.numbers),
        labelText: "CVV",
        hintText: "XXX",
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return "CVV can not be empty!";
        } else if (value.trim().length != 3) {
          return "Card number should consist of 3 digits.";
        } else if (value.contains(RegExp(r'[,. ]'))) {
          return "Only numbers";
        }
        return null;
      },
      onChanged: (value) {
        setState(() {
          cvv = value.toString();
        });
      },
    );
  }
}

class CompleteButton extends StatelessWidget {
  const CompleteButton(
      {Key? key,
      required this.context,
      required this.formKey,
      required this.id,
      required this.capacity,
      required this.selectedDate,
      required this.price,
      required this.cardHolder,
      required this.cardNumber,
      required this.expiredDate,
      required this.cvv})
      : super(key: key);

  final BuildContext context;
  final GlobalKey<FormState> formKey;
  final String id, cardHolder, cardNumber, expiredDate, cvv;
  final int capacity;
  final DateTime selectedDate;
  final double price;

  @override
  Widget build(BuildContext context) {
    var isCardHolderNull = cardHolder.isEmpty;
    var isCardNumberNull = cardNumber.isEmpty;
    var isExpiredDateNull = expiredDate.isEmpty;
    var isCVVNull = cvv.isEmpty;
    var result =
        isCardHolderNull || isCardNumberNull || isExpiredDateNull || isCVVNull;
    var isDisabled = result;

    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(width: 1),
          color: isDisabled ? Colors.grey : Colors.blue,
        ),
        child: TextButton(
            onPressed: isDisabled
                ? null
                : () {
                    _completeReservation(id, selectedDate, price);
                  },
            child: const Text(
              "Complete",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            )),
      ),
    );
  }

  void _completeReservation(
      String venueID, DateTime selectedDate, double price) async {
    var _formState = formKey.currentState;

    if (_formState!.validate()) {
      _formState.save();

      var userID = FirebaseAuth.instance.currentUser!.uid.toString();
      var result = await FirestoreService()
          .makeReservation(userID, venueID, capacity, selectedDate, price);

      if (result) {
        var duration = const Duration(seconds: 2);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text("You've made a reservation successfully."),
          duration: duration,
        ));

        Future.delayed(duration, () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const MainPage()));
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Something went wrong while making a reservation."),
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("The venue has not been found."),
      ));
    }
  }
}
