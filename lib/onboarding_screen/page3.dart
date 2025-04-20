import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Page3 extends StatelessWidget {
  const Page3({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Image.asset("assets/mm.png"),
        ),
        const SizedBox(
          height: 15,
        ),
        Text(
          "مستعد للبدء؟",
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
          padding: const EdgeInsets.all(20.0),
          child: Text(
            "أنشئ حسابك الآن، وابدأ في تقديم طلبات التبديل بكل سهولة!",
            textAlign: TextAlign.center,
            style: GoogleFonts.tajawal(
              fontSize: 22,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
