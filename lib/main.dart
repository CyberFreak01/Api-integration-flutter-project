import 'package:flutter/material.dart';

void main() {
  runApp(const StockImagesApp());
}

class StockImagesApp extends StatefulWidget {
  const StockImagesApp({super.key});

  @override
  State<StockImagesApp> createState() => _StockImagesAppState();
}

class _StockImagesAppState extends State<StockImagesApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Hello World!'),
        ),
      ),
    );
  }
}
