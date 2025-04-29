import 'package:flutter/material.dart';

class Programming extends StatefulWidget {
  const Programming({super.key});

  @override
  State<Programming> createState() => _ProgrammingState();
}

class _ProgrammingState extends State<Programming> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("برمجة"),
      ),
    );
  }
}
