import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medihub_1/Screens/ProfileComponent/My%20Product/editproduct.dart';
import 'package:medihub_1/color/colors.dart';

class MyProducts extends StatefulWidget {
  MyProducts({Key? key}) : super(key: key);

  @override
  _MyProductsState createState() => _MyProductsState();
}

class _MyProductsState extends State<MyProducts> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _databaseItems = [];

  @override
  void initState() {
    super.initState();
    _retrieveDataFromDatabase();
  }

  Future<void> _retrieveDataFromDatabase() async {
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      String userId = currentUser.uid;
      QuerySnapshot rentSnapshot = await _firestore
          .collection('rent')
          .where('userId', isEqualTo: userId)
          .get();

      setState(() {
        _databaseItems = rentSnapshot.docs
            .map<Map<String, dynamic>>(
                (doc) => doc.data() as Map<String, dynamic>)
            .toList();
      });
    }
  }

 Future<void> _deleteItemFromDatabase(String itemId) async {
  // Get the notification document with the matching productId
  QuerySnapshot notificationSnapshot = await _firestore
      .collection('notification')
      .where('productId', isEqualTo: itemId)
      .get();

  // Delete the notification document(s)
  for (QueryDocumentSnapshot notificationDoc in notificationSnapshot.docs) {
    await notificationDoc.reference.delete();
  }

  // Delete the item from the 'rent' collection
  await _firestore.collection('rent').doc(itemId).delete();

  // Refresh the data after deletion
  _retrieveDataFromDatabase();
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("My Products",style: TextStyle(color:midnightcolor,fontSize: 23),),
        centerTitle: true,
      ),
      body: Material(
        child: Container(
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    mainAxisExtent: 160,
                  ),
                  itemCount: _databaseItems.length,
                  itemBuilder: (context, index) {
                    final item = _databaseItems[index];
                    final itemId = item['productId'];
                    return InkWell(
                      onTap: () {
                        // Handle item tap
                      },
                      child: Card(
                        margin: EdgeInsets.all(10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                               height: 140,
                                width: 140,
                              child: Image.network(
                                item['imageUrl'],
                                height: 150,
                                width: 150,
                                fit: BoxFit.fill,
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    item['name'] ?? '',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: green
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    'Price: ${item['price'] ?? ''}',
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    'Location: ${item['wilaya'] ?? ''}',
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.delete , color: Colors.red,),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text('Delete Item'),
                                        content: Text(
                                            'Are you sure you want to delete this item?'),
                                        actions: [
                                          TextButton(
                                            child: Text('Cancel'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          TextButton(
                                            child: Text('Delete'),
                                            onPressed: () {
                                              _deleteItemFromDatabase(itemId);
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.edit,color: Colors.blue,),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            EditProductDetail(itemId: itemId),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
