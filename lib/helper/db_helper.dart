import 'dart:typed_data';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  static final DbHelper _instance = DbHelper._internal();
  factory DbHelper() => _instance;

  DbHelper._internal();

  Database? _database;

  Future<void> initializeDatabase() async {
    final path = await getDatabasesPath();
    final databasePath = join(path, 'my_database.db');

    _database = await openDatabase(
      databasePath,
      version: 1,
      onCreate: (db, version) {
        db.execute(
            '''
          CREATE TABLE products (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            wilaya TEXT,
            price REAL,
            category TEXT,
            condition TEXT,
            image TEXT
          )
        ''');
      },
    );
  }

  Future<int> insertProduct(Product product) async {
    if (_database == null) {
      throw Exception('Database not initialized');
    }

    return await _database!.insert('products', product.toMap());
  }

  Future<List<Product>> getProducts() async {
    if (_database == null) {
      throw Exception('Database not initialized');
    }

    final List<Map<String, dynamic>> maps = await _database!.query('products');

    return List.generate(maps.length, (index) {
      return Product.fromMap(maps[index]);
    });
  }

  Future<int> deleteProduct(int id) async {
    if (_database == null) {
      throw Exception('Database not initialized');
    }

    return await _database!
        .delete('products', where: 'id = ?', whereArgs: [id]);
  }
}

class Product {
  final int? id;
  final String name;
  final double price;
  final String category;
  final String condition;
  final String wilaya;
  final Uint8List imageBytes; // Change image type to Uint8List

  Product({
    this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.condition,
    required this.wilaya,
    required this.imageBytes,
  });

  Map<String, dynamic> toMap() {
    return {
      'wilaya':wilaya,
      'id': id,
      'name': name,
      'price': price,
      'category': category,
      'condition': condition,
      'image': imageBytes,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      price: map['price'],
      category: map['category'],
      wilaya: map['wilaya'],
      condition: map['condition'],
      imageBytes: map['image'],
    );
  }
}
