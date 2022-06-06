import 'package:flutter/material.dart';

import 'paymentPage.dart';

class SelectDate extends StatefulWidget {
  final String venueID;

  const SelectDate({Key? key, required this.venueID}) : super(key: key);

  @override
  State<SelectDate> createState() => _SelectDateState();
}

class _SelectDateState extends State<SelectDate> {
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final day = selectedDate.day.toString().padLeft(2, "0");
    final month = selectedDate.month.toString().padLeft(2, "0");
    final year = selectedDate.year.toString();
    final hour = selectedDate.hour.toString().padLeft(2, "0");
    final minute = selectedDate.minute.toString().padLeft(2, "0");

    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Date&Time"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          iconSize: 20,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Selected Date"),
            const SizedBox(height: 15),
            ElevatedButton(
              child: Text("$day / $month / $year"),
              onPressed: () async {
                final date = await pickDate();

                if (date == null) {
                  return;
                }

                final updatedDateTime = DateTime(date.year, date.month,
                    date.day, selectedDate.hour, selectedDate.minute);

                setState(() {
                  selectedDate = updatedDateTime;
                });
              },
            ),
            const SizedBox(height: 30),
            const Text("Selected Time"),
            const SizedBox(height: 15),
            ElevatedButton(
              child: Text("$hour:$minute"),
              onPressed: () async {
                final time = await pickTime();

                if (time == null) {
                  return;
                }

                final updatedDateTime = DateTime(
                    selectedDate.year,
                    selectedDate.month,
                    selectedDate.day,
                    time.hour,
                    time.minute);

                setState(() {
                  selectedDate = updatedDateTime;
                });
              },
            ),
            const SizedBox(height: 75),
            ElevatedButton(
              child: const Text("Go to payment page."),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Payment(
                              venueID: widget.venueID,
                              selectedDate: selectedDate,
                            )));
              },
            )
          ],
        ),
      ),
    );
  }

  Future<DateTime?> pickDate() => showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate:
          DateTime(selectedDate.year, selectedDate.month, selectedDate.day),
      lastDate: DateTime(
          selectedDate.year, selectedDate.month, selectedDate.day + 7));

  Future<TimeOfDay?> pickTime() => showTimePicker(
      context: context,
      initialTime:
          TimeOfDay(hour: selectedDate.hour, minute: selectedDate.minute));
}
