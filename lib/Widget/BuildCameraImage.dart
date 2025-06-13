import 'package:flutter/material.dart';

Widget buildCameraImage(String url) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      //Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
      const SizedBox(height: 6),
      ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          url.trim().replaceAll('"', ''),
          height: 100,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => const Text('Image failed to load'),
        ),
      ),
    ],
  );
}
