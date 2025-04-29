import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class specialization extends StatelessWidget {
  final GestureTapCallback onTap;
  final String name;
  final IconData icon;
  const specialization(
      {Key? key, required this.icon, required this.name, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(15),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: const BorderRadius.all(
            Radius.circular(12),
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: FaIcon(
                icon,
                size: 40,
                color: Colors.blue[900],
              ),
            ),
            Text(
              name,
              style: GoogleFonts.tajawal(
                fontSize: 22,
                color: Colors.blue[900],
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
