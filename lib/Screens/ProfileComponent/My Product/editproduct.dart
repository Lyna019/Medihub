import 'package:flutter/material.dart';
import 'package:medihub_1/color/colors.dart';
import '/commons/styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProductDetail extends StatefulWidget {
  final String itemId;

  EditProductDetail({required this.itemId, Key? key}) : super(key: key);

  @override
  State<EditProductDetail> createState() => _EditProductDetailState();
}

class _EditProductDetailState extends State<EditProductDetail>
    with SingleTickerProviderStateMixin {
  List<String>? img;
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController rentalRulesController = TextEditingController();
  List<DateTime> _selectedDates = [];

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    final productDoc =
        await FirebaseFirestore.instance.collection('rent').doc(widget.itemId).get();

    if (productDoc.exists) {
      final Map<String, dynamic> fetchedData =
          productDoc.data() as Map<String, dynamic>;

      setState(() {
        img = [fetchedData['imageUrl']];
        nameController.text = fetchedData['name'];
        priceController.text = fetchedData['price'];
        descriptionController.text = fetchedData['description'];
        rentalRulesController.text = fetchedData['rentalRules'];
      });
    } else {
      print('Error: Document not found');
      Navigator.of(context).pop();
    }
  }

  void _saveChanges() async {
    final updatedProduct = {
      'image': img![0],
      'name': nameController.text,
      'price': priceController.text,
      'description': descriptionController.text,
      'rentalRules': rentalRulesController.text,
      'unavailableDates': FieldValue.arrayUnion(_selectedDates),
    };

    try {
      await FirebaseFirestore.instance
          .collection('rent')
          .doc(widget.itemId)
          .update(updatedProduct);

      Navigator.pop(context, updatedProduct);
    } catch (e) {
      print('Error: Failed to save changes - $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MediHub'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.blue, size: 30),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      actions: [
  TextButton(
    onPressed: _saveChanges,
    child: Row(
      children: [
        Icon(Icons.save, color: Colors.blue), // Add an icon
        SizedBox(width: 8), // Add some space between the icon and text
        Text(
          'Save Changes',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 6, 16, 24),
          ),
        ),
      ],
    ),
  ),
],

      ),
      body: Container(
        padding: EdgeInsets.all(10),
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 300,
                child: showImages(),
              ),
              SizedBox(height: 10),
              nameField(),
              SizedBox(height: 10),
              priceField(),
              SizedBox(height: 10),
              Divider(),
              SizedBox(height: 10),
              Divider(),
              descriptionField(),
              SizedBox(height: 10),
              Divider(),
              SizedBox(height: 10),
              Divider(),
              rentalRulesField(),
              SizedBox(height: 10),
              Divider(),
              SizedBox(height: 10),
              buildCalendar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget showImages() {
    return PageView.builder(
      itemCount: img != null ? img!.length : 0,
      itemBuilder: (context, index) {
        return Image.network(
          img![index],
          width: double.infinity,
          fit: BoxFit.contain,
        );
      },
    );
  }

  Widget nameField() {
    return Container(
      padding: EdgeInsets.only(left: 10.0),
      child: TextFormField(
        controller: nameController,
        decoration: InputDecoration(
          labelText: 'Name',
        ),
      ),
    );
  }

  Widget priceField() {
    return Container(
      padding: EdgeInsets.only(left: 10.0),
      child: TextFormField(
        controller: priceController,
        decoration: InputDecoration(
          labelText: 'Price',
        ),
      ),
    );
  }

  Widget descriptionField() {
    return Container(
      padding: EdgeInsets.only(left: 10.0),
      child: TextFormField(
        controller: descriptionController,
        maxLines: 3,
        decoration: InputDecoration(
          labelText: 'Description',
        ),
      ),
    );
  }

  Widget rentalRulesField() {
    return Container(
      padding: EdgeInsets.only(left: 10.0),
      child: TextFormField(
        controller: rentalRulesController,
        maxLines: 3,
        decoration:
          InputDecoration(
            labelText: 'Rental Rules',
          ),
        ),
      );
    }
  Widget buildCalendar() {
  return TableCalendar(
    calendarFormat: _calendarFormat,
    focusedDay: DateTime.now(),
    firstDay: DateTime.utc(DateTime.now().year - 1),
    lastDay: DateTime.utc(DateTime.now().year + 1),
    eventLoader: (day) {
      // This function returns events for a given day
      return _selectedDates.contains(day) ? [true] : [];
    },
    onDaySelected: (selectedDay, focusedDay) {
      setState(() {
        if (_selectedDates.contains(selectedDay)) {
          _selectedDates.remove(selectedDay);
        } else {
          _selectedDates.add(selectedDay);
        }
      });
    },
    calendarStyle: CalendarStyle(
      selectedDecoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.red,
      ),
      todayDecoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.blue),
      ),
      selectedTextStyle: TextStyle(color: Colors.white),
      todayTextStyle: TextStyle(color: Colors.blue),
    ),
    headerStyle: HeaderStyle(
      formatButtonVisible: false,
    ),
  );
}

}