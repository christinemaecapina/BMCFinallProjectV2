import 'package:flutter/material.dart';

// 1. This is a simple StatelessWidget
class ProductCard extends StatelessWidget {

  // 2. We'll require the data we need to display
  final String productName;
  final double price;
  final String imageUrl;
  final VoidCallback onTap;

  // 3. The constructor takes this data
  const ProductCard({
    super.key,
    required this.productName,
    required this.price,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // 1. The Card now relies on our global theme for rounded corners and color.
    return InkWell(
      onTap: onTap,
      child: Card(
        // The theme's 'clipBehavior' handles clipping the image to the card's rounded shape
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 2. Image takes 3 parts of the vertical space (60%)
            Expanded(
              flex: 3, // Give the image 3 "parts" of the space
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover, // This makes the image fill its box

                // Show a loading spinner
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(child: CircularProgressIndicator());
                },

                // Show an error icon
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Icon(Icons.broken_image, size: 40, color: Colors.grey),
                  );
                },
              ),
            ),

            // 3. Text takes 2 parts of the vertical space (40%)
            Expanded(
              flex: 2, // Give the text 2 "parts" of the space
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Product Name
                    Text(
                      productName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 2, // Allow two lines for the name
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(), // 4. Pushes the price to the bottom

                    // Price
                    Text(
                      '₱${price.toStringAsFixed(2)}',
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey[800],
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}