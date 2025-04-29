import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swaptech2/componets/specializationItem.dart';
import 'package:swaptech2/pages/roadmap%20screen/controlScreen.dart';
import 'package:swaptech2/pages/roadmap%20screen/netowkrs.dart';
import 'package:swaptech2/pages/roadmap%20screen/programming.dart';

class roadmap extends StatefulWidget {
  const roadmap({super.key});

  @override
  State<roadmap> createState() => _roadmapState();
}

class _roadmapState extends State<roadmap> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "الخطة الدراسية",
          textAlign: TextAlign.center,
          style: GoogleFonts.tajawal(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        children: [
          specialization(
            icon: FontAwesomeIcons.screwdriverWrench,
            name: "تحكم",
            onTap: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 250),
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      const control(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(-1.0, 0.0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    );
                  },
                ),
              );
            },
          ),
          specialization(
            icon: FontAwesomeIcons.code,
            name: "برمجة",
            onTap: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 250),
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      const Programming(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(-1.0, 0.0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    );
                  },
                ),
              );
            },
          ),
          specialization(
            icon: FontAwesomeIcons.server,
            name: "شبكات",
            onTap: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 250),
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      const Netowkrs(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(-1.0, 0.0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
