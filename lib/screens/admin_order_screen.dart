import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Used for formatting the order date

class AdminOrderScreen extends StatefulWidget {
  const AdminOrderScreen({super.key});

  @override
  State<AdminOrderScreen> createState() => _AdminOrderScreenState();
}

class _AdminOrderScreenState extends State<AdminOrderScreen> {
  // 1. Get an instance of Firestore to interact with the database
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 2. This function updates the 'status' field of a specific order in Firestore
  Future<void> _updateOrderStatus(String orderId, String newStatus) async {
    try {
      // Find the document by its ID in the 'orders' collection and update the status
      await _firestore.collection('orders').doc(orderId).update({
        'status': newStatus,
      });
      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Order status updated!')),
      );
    } catch (e) {
      // Show an error message if the update fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update status: $e')),
      );
    }
  }

  // 3. This function shows a dialog to let the admin select a new order status
  void _showStatusDialog(String orderId, String currentStatus) {
    showDialog(
      context: context,
      builder: (context) {
        // A list of all valid status options for an order
        const statuses = [
          'Pending',
          'Processing',
          'Shipped',
          'Delivered',
          'Cancelled'
        ];

        return AlertDialog(
          title: const Text('Update Order Status'),
          content: Column(
            mainAxisSize: MainAxisSize.min, // Make the dialog size wrap the content
            children: statuses.map((status) {
              // Create a list tile button for each status option
              return ListTile(
                title: Text(status),
                // Show a checkmark if this is the order's current status
                trailing:
                currentStatus == status ? const Icon(Icons.check) : null,
                onTap: () {
                  // When a status is selected, update Firestore
                  _updateOrderStatus(orderId, status);
                  // Close the dialog immediately
                  Navigator.of(context).pop();
                },
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Orders'),
      ),
      // 4. Use a StreamBuilder to listen for real-time updates to the 'orders' collection
      body: StreamBuilder<QuerySnapshot>(
        // Query to fetch ALL documents in the 'orders' collection, sorted by creation date (newest first)
        stream: _firestore
            .collection('orders')
            .orderBy('createdAt', descending: true)
            .snapshots(),

        builder: (context, snapshot) {
          // 5. Handle loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // 6. Handle error state
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          // 7. Handle empty data state
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No orders found.'));
          }

          final orders = snapshot.data!.docs;

          // 8. Display the orders in a scrollable list
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              final orderData = order.data() as Map<String, dynamic>;

              // 9. Format the date from Firestore Timestamp
              final Timestamp timestamp = orderData['createdAt'];
              final String formattedDate =
              DateFormat('MM/dd/yyyy hh:mm a').format(timestamp.toDate());

              // 10. Get the current status
              final String status = orderData['status'];

              // 11. Build a Card for each order for better visibility
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(
                    'Order ID: ${order.id}', // Display the unique Firestore document ID
                    style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  subtitle: Text(
                    'User ID: ${orderData['userId']}\n' // Show which user placed the order
                        'Total: ₱${(orderData['totalPrice']).toStringAsFixed(2)} | Date: $formattedDate',
                  ),
                  isThreeLine: true,

                  // 12. Show the status using a Chip for visual feedback
                  trailing: Chip(
                    label: Text(
                      status,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold),
                    ),
                    // Change chip color based on the status
                    backgroundColor: status == 'Pending'
                        ? Colors.orange
                        : status == 'Processing'
                        ? Colors.blue
                        : status == 'Shipped'
                        ? Colors.deepPurple
                        : status == 'Delivered'
                        ? Colors.green
                        : Colors.red,
                  ),

                  // 13. When the admin taps the card, open the status update dialog
                  onTap: () {
                    _showStatusDialog(order.id, status);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}