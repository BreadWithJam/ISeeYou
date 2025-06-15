import 'package:flutter/material.dart';

Widget buildCameraImage(String url) {
  final cleanUrl = url.trim().replaceAll('"', '');
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(height: 6),
      ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          cleanUrl,
          height: 125,
          width: double.infinity,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const Center(child: CircularProgressIndicator());
          },
          errorBuilder: (context, error, stackTrace) {
            return const Text('No image to show');
          },
        ),
      ),
    ],
  );
}
