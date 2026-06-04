import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MovieDetailPage extends StatelessWidget {
  const MovieDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final movieId = Get.parameters['movieId'];

    return Scaffold(
      appBar: AppBar(title: const Text('Detalle')),
      body: Center(child: Text('Movie ID: ${movieId ?? '-'}')),
    );
  }
}
