import 'package:flutter/material.dart';

void main() {
  runApp(const ZsoltAiProApp());
}

class ZsoltAiProApp extends StatelessWidget {
  const ZsoltAiProApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ZSOLT AI PRO',
      home: const Scaffold(
        body: Center(
          child: Text(
            'ZSOLT AI PRO',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
