import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Page2 extends StatelessWidget {
  const Page2({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Image.asset("assets/secondPage.png"),
        ),
        const SizedBox(
          height: 15,
        ),
        Text(
          "كيف يعمل التطبيق؟",
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: const Icon(Icons.check_circle, color: Colors.blue),
                  title: Text(
                    "اختر تخصصك الحالي والتخصص الذي ترغب بالانتقال إليه.",
                    style: GoogleFonts.tajawal(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.check_circle, color: Colors.blue),
                  title: Text(
                    "سيتم عرض طلبك في قائمة التبديلات المتاحة.",
                    style: GoogleFonts.tajawal(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.check_circle, color: Colors.blue),
                  title: Text(
                    "بمجرد العثور على طالب آخر يرغب في التبديل معك ، ستتلقى إشعارًا للموافقة على الطلب واستكمال الإجراءات.",
                    style: GoogleFonts.tajawal(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            )),
      ],
    );
  }
}
