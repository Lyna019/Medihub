import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medihub_1/color/colors.dart';

import '../productDetail.dart';

class SearchResult {
  final String imageUrl;
  final String name;
  final dynamic price;
  final dynamic id;

  SearchResult({
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.id,
  });
}

class All extends StatelessWidget {
  final rentCollection = FirebaseFirestore.instance.collection('rent');
  final donateCollection = FirebaseFirestore.instance.collection('donate');

  Widget _buildResultSection(BuildContext context, String title,
      Stream<QuerySnapshot<Map<String, dynamic>>> resultStream) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: resultStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final results = snapshot.data!.docs.map((doc) {
            final data = doc.data();
            final iditem = doc.id; // Get the document ID
            final category =
                data.containsKey('category') ? data['category'] as String : '';
            final imageUrl =
                data.containsKey('imageUrl') ? data['imageUrl'] as String : '';
            final price = data.containsKey('price') ? data['price'] : 0.0;
            final name = data.containsKey('name') ? data['name'] as String : '';

            double parsedPrice;
            if (price is double) {
              parsedPrice = price;
            } else if (price is String) {
              parsedPrice = double.tryParse(price) ?? 0.0;
            } else {
              parsedPrice = 0.0;
            }

            return SearchResult(
              imageUrl: imageUrl,
              price: parsedPrice,
              name: name,
              id: iditem, // Include the id in the SearchResult object
            );
          }).toList();

          return Container(
            margin: EdgeInsets.only(top: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 190,
                  height: 30,
                  decoration: BoxDecoration(
                    color: midnightcolor, // Replace with your desired color
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
                      color: Colors.white, // Replace with your desired color
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
                      String priceText;
                      if (result.price == 0.0) {
                        priceText = 'FREE';
                      } else {
                        priceText =
                            '${result.price.toStringAsFixed(2)} Dzd/day';
                      }

                      return GestureDetector(
                        onTap: () {
                          // Navigate to the detailed product page and pass the id
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ProductDetail(id: result.id)),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Color.fromARGB(255, 27, 78,
                                  207), // Replace with your desired color
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          width: 150.0,
                          margin: EdgeInsets.only(right: 18.0),
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(12.0),
                                  topRight: Radius.circular(12.0),
                                ),
                                child: Image.network(
                                  result.imageUrl,
                                  width: 150.0,
                                  height: 135.0,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(height: 7.0),
                              SizedBox(height: 4.0),
                              Text(
                                result.name,
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 18.0,
                                ),
                                maxLines: 1, // Set maxLines to 1
                                overflow: TextOverflow
                                    .ellipsis, // Use ellipsis for overflow
                              ),
                              Text(
                                priceText,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      green, // Replace with your desired color
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
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildResultSection(context, 'Paid', rentCollection.snapshots()),
            SizedBox(
              height: 20,
            ),
            _buildResultSection(
                context, 'Donation', donateCollection.snapshots()),
          ],
        ),
      ),
    );
  }
}
