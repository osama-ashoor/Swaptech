import 'package:flutter/material.dart';
import 'package:swaptech2/handling%20notifications/notification.dart';
import 'package:swaptech2/pages/Home.dart';
import 'package:swaptech2/pages/Profile.dart';
import 'package:swaptech2/pages/requests.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swaptech2/pages/roadmap%20screen/roadmap.dart';

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  List Pages = [Home(), roadmap(), Requests(), Profile()];
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    HandlingNotification.init(context, _updateIndex);
  }

  void _updateIndex(int index) {
    if (mounted) {
      setState(() {
        currentIndex = index;
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    HandlingNotification.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'الصفحة الرئيسية',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.map_rounded,
            ),
            label: "الخطة الدراسية",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.description_rounded,
            ),
            label: "طلبات التبديل",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "الملف الشخصي",
          ),
        ],
        selectedLabelStyle: GoogleFonts.tajawal(
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: GoogleFonts.tajawal(
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
        showSelectedLabels: true,
        showUnselectedLabels: false,
        currentIndex: currentIndex,
        selectedItemColor: Colors.blue[900],
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        onTap: (index) => {
          if (mounted)
            {
              setState(() {
                currentIndex = index;
              })
            }
        },
      ),
      body: Pages[currentIndex],
    );
  }
}
