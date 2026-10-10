import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String name;
  final double pricePerKg;
  final bool isAvailable;
  final String category; // "fish" or "chicken"
  final String imageUrl;
  final DateTime? updatedAt;

  Product({
    required this.id,
    required this.name,
    required this.pricePerKg,
    required this.isAvailable,
    required this.category,
    required this.imageUrl,
    this.updatedAt,
  });

  // Copy with method - IMPORTANT for admin screen
  Product copyWith({
    String? id,
    String? name,
    double? pricePerKg,
    bool? isAvailable,
    String? category,
    String? imageUrl,
    DateTime? updatedAt,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      pricePerKg: pricePerKg ?? this.pricePerKg,
      isAvailable: isAvailable ?? this.isAvailable,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Create Product from Firestore document
  factory Product.fromFirestore(Map<String, dynamic> data, String docId) {
    return Product(
      id: docId,
      name: data['name'] ?? '',
      pricePerKg: (data['pricePerKg'] ?? 0).toDouble(),
      isAvailable: data['isAvailable'] ?? true,
      category: data['category'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      updatedAt: data['updatedAt'] != null 
          ? (data['updatedAt'] as Timestamp).toDate()
          : null,
    );
  }

  // Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'pricePerKg': pricePerKg,
      'isAvailable': isAvailable,
      'category': category,
      'imageUrl': imageUrl,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}