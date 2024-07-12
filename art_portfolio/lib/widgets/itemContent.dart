import 'package:flutter/material.dart';

class ItemImage extends StatelessWidget {
  const ItemImage ({super.key,
  required this.imageSrc});

  final String imageSrc;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Image.network(imageSrc),
    );
  }
}

class DescriptionBox extends StatelessWidget {
  const DescriptionBox({super.key,
  required this.imageDescription});

  final String imageDescription;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text('Description: $imageDescription'),
      )
    );
  }
}