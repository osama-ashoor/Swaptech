import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Page1 extends StatelessWidget {
  const Page1({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Image.asset("assets/firstPage.png"),
        ),
        const SizedBox(
          height: 15,
        ),
        Text(
          "مرحبًا بك في تطبيق تبديل التخصصات",
          textAlign: TextAlign.center,
          style: GoogleFonts.tajawal(
            fontSize: 25,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            "سهلنا عليك عملية تبديل التخصصات بين طلاب الكلية ، الآن يمكنك طلب تبديل تخصصك مع طالب آخر بسهولة وفي أي وقت",
            textAlign: TextAlign.center,
            style: GoogleFonts.tajawal(
              fontSize: 18,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
