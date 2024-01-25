import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../productDetail.dart';

class SearchResult {
  final String id;
  final String imageUrl;
  final String name;
  final dynamic price;

  SearchResult({
    required this.id,
    required this.imageUrl,
    required this.name,
    required this.price,
  });
}

class med extends StatelessWidget {
  final rentCollection = FirebaseFirestore.instance.collection('rent');
  final donateCollection = FirebaseFirestore.instance.collection('donate');

  Widget _buildResultSection(
      BuildContext context,
      String title,
      String category,
      Stream<QuerySnapshot<Map<String, dynamic>>> resultStream) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: resultStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final results = snapshot.data!.docs
              .where((doc) =>
                  doc.data().containsKey('category') &&
                  doc.data()['category'] == category)
              .map((doc) {
            final data = doc.data();
            final id = doc.id;
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
              id: id,
              imageUrl: imageUrl,
              price: parsedPrice,
              name: name,
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
                    color: Colors.blue, // Replace with your desired color
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
                        priceText = '${result.price.toStringAsFixed(2)}dzd/day';
                      }

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProductDetail(id: result.id),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors
                                  .blue, // Replace with your desired color
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          width: 150.0,
                          margin: EdgeInsets.only(right: 8.0),
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(30.0),
                                child: Image.network(
                                  result.imageUrl,
                                  width: 130.0,
                                  height: 120.0,
                                ),
                              ),
                              SizedBox(height: 18.0),
                              Text(
                                priceText,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors
                                      .blue, // Replace with your desired color
                                ),
                              ),
                              SizedBox(height: 4.0),
                              Text(
                                result.name,
                                style: TextStyle(
                                  color: Colors
                                      .blue, // Replace with your desired color
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
            _buildResultSection(context, 'Paid', 'Medical Equipments',
                rentCollection.snapshots()),
            _buildResultSection(context, 'Donation', 'Medical Equipments',
                donateCollection.snapshots()),
          ],
        ),
      ),
    );
  }
}
