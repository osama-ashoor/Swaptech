import 'package:flutter/material.dart';

class control extends StatefulWidget {
  const control({super.key});

  @override
  State<control> createState() => _controlState();
}

class _controlState extends State<control> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("تحكم"),
      ),
    );
  }
}
