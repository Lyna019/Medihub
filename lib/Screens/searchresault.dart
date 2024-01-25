import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medihub_1/color/colors.dart';
import 'productDetail.dart';

class SearchResult {
  final String imageUrl;
  final double price;
  final String providerName;
  final String id; // Add this line

  SearchResult({
    required this.imageUrl,
    required this.price,
    required this.providerName,
    required this.id, // Add this line
  });
}

class SearchPageres extends StatefulWidget {
  final String selectedEquipment;
  final String selectedLocation;
  final String selectedCondition;
  final double maxPrice;

  SearchPageres({
    required this.selectedEquipment,
    required this.selectedLocation,
    required this.selectedCondition,
    required this.maxPrice,
  });

  @override
  _SearchPageresState createState() => _SearchPageresState();
}

class _SearchPageresState extends State<SearchPageres> {
  List<SearchResult> searchResults = [];

  @override
  void initState() {
    super.initState();
    fetchResults();
  }

  Future<void> fetchResults() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('rent').get();

      List<SearchResult> results = [];
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

        if (data != null) {
          String name = data['name'];
          String wilaya = data['wilaya'];
          String condition = data['condition'];
          double price =
              double.parse(data['price'] ?? '0'); // Parse string to double
          String imageUrl = data['imageUrl'] ?? '';
          String providerName = data['providerName'] ?? '';

          if (name == widget.selectedEquipment &&
              wilaya == widget.selectedLocation &&
              condition == widget.selectedCondition &&
              price <= widget.maxPrice) {
            results.add(SearchResult(
              imageUrl: imageUrl,
              price: price,
              providerName: providerName,
              id: doc.id, // Include the document ID
            ));
          }
        }
      });

      setState(() {
        searchResults = results;
      });
    } catch (e) {
      print('Error fetching results: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CenteredTextWidget(
                dynamicText:
                    'Explore The wide range of equipment under Your Interest'),
            _buildResultSection(context, 'Paid', searchResults),
            _buildResultSectionloc(context, 'Donation ', searchResults),
          ],
        ),
      ),
    );
  }
Widget _buildResultSectionloc(
  BuildContext context, String title, List<SearchResult> results) {
  return Container(
    margin: EdgeInsets.only(top: 40, bottom: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 190,
          height: 30,
          decoration: BoxDecoration(
            color: midnightcolor,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(10.0),
              bottomRight: Radius.circular(10.0),
            ),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 233, 238, 242),
            ),
          ),
        ),
        SizedBox(height: 18.0),
        Container(
          height: 200.0,
          width: MediaQuery.of(context).size.width,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: results.length,
            itemBuilder: (context, index) {
              final result = results[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetail(id: result.id),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color.fromARGB(255, 145, 198, 255),
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  width: 150.0,
                  margin: EdgeInsets.only(right: 8.0),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12.0),
                        child: Image.network(
                          result.imageUrl,
                          width: 150.0, // Set width to match container width
                          height: 135.0,
                          fit: BoxFit.cover, // Make the image fill the container
                        ),
                      ),
                      SizedBox(height: 18.0),
                      Text(
                        'FREE',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: midnightcolor,
                        ),
                      ),
                      SizedBox(height: 4.0),
                      Text(
                        result.providerName,
                        style: TextStyle(
                          color: midnightcolor,
                          fontSize: 14.0,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    ),
  );
}

Widget _buildResultSection(
  BuildContext context, String title, List<SearchResult> results) {
  return Container(
    margin: EdgeInsets.only(
      top: 20,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 190,
          height: 30,
          decoration: BoxDecoration(
            color: midnightcolor,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(10.0),
              bottomRight: Radius.circular(10.0),
            ),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 233, 238, 242),
            ),
          ),
        ),
        SizedBox(height: 18.0),
        Container(
          height: 200.0,
          width: MediaQuery.of(context)
              .size
              .width, // Ensure proper width constraints
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: results.length,
            itemBuilder: (context, index) {
              final result = results[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetail(id: result.id),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.blue,
                        width: 2.0), // Set the border color and width
                    borderRadius:
                        BorderRadius.circular(12.0), // Set the border radius
                  ),
                  width: 150.0,
                  margin: EdgeInsets.only(right: 8.0),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12.0),
                        child: Image.network(
                          result.imageUrl,
                          width: 150.0, // Set width to match container width
                          height: 135.0,
                          fit: BoxFit.cover, // Make the image fill the container
                        ),
                      ),
                      SizedBox(height: 18.0),
                      Text(
                        '\$${result.price.toStringAsFixed(2)}',
                        style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: midnightcolor),
                      ),
                      SizedBox(height: 4.0),
                      Text(
                        result.providerName,
                        style: TextStyle(
                          color: midnightcolor,
                          fontSize: 14.0,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    ),
  );
}


}

class CenteredTextWidget extends StatelessWidget {
  final String dynamicText;

  CenteredTextWidget({required this.dynamicText});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.only(
          top: 30,
        ),
        child: Text(
          dynamicText,
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 29, 147, 243),
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

PreferredSizeWidget _buildAppBar(BuildContext context) {
  return AppBar(
    backgroundColor: Colors.white,
    leading: Image.asset(
      'assets/images/lg.png',
      width: 15,
      height: 20,
    ),
    title: Center(
      child: Text(
        'MediHub        ',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 25, 25, 112), // Midnight Blue
        ),
      ),
    ),
  );
}
