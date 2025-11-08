import 'dart:async'; // 1. ADDED (for StreamSubscription)
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart'; // 2. ADDED
import 'package:cloud_firestore/cloud_firestore.dart'; // 3. ADDED

// (This is at the top of lib/providers/cart_provider.dart)

class CartItem {
  final String id;
  final String name;
  final double price;
  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    this.quantity = 1,
  });

  // 1. ADDED: A method to convert our CartItem object into a Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'quantity': quantity,
    };
  }

  // 2. ADDED: A factory constructor to create a CartItem from a Map
  factory CartItem.fromJson(Map<String, dynamic> json) {
    // Correctly cast the numerical types from Firestore's dynamic Map
    return CartItem(
      id: json['id'] as String,
      name: json['name'] as String,
      // Firestore typically stores numbers as num, we cast to double/int
      price: (json['price'] as num).toDouble(),
      quantity: (json['quantity'] as num).toInt(),
    );
  }
}