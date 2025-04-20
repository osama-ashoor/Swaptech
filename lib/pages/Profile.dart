import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:swaptech2/auth/AuthService.dart';
import 'package:swaptech2/componets/ProfileMenuWidget.dart';
import 'package:swaptech2/database/database.dart';
import 'package:swaptech2/pages/editStudentInfo.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool isLogingOut = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "الملف الشخصي",
          style: GoogleFonts.tajawal(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
      body: StreamBuilder<DocumentSnapshot?>(
        stream: Database().getUserDataStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: Skeletonizer(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          SizedBox(
                            width: 120,
                            height: 120,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: const CircleAvatar(
                                backgroundColor: Colors.black,
                                child: Icon(
                                  Icons.person,
                                  size: 75,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 35,
                              height: 35,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Colors.white,
                              ),
                              child: const Icon(
                                LineAwesomeIcons.check_circle,
                                color: Colors.green,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "اسم المستخدم",
                        style: GoogleFonts.tajawal(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "رقم الطالب",
                        style: GoogleFonts.tajawal(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.only(left: 80, right: 80),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            10,
                          ),
                          color: Colors.grey[200],
                        ),
                        child: Text(
                          "التخصص",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.tajawal(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const Divider(),
                      ProfileMenuWidget(
                        title: "تعديل معلومات الطالب",
                        icon: LineAwesomeIcons.edit_solid,
                        onPress: () {},
                      ),
                      ProfileMenuWidget(
                        title: "تسجيل الخروج",
                        textColor: Colors.red,
                        icon: Icons.logout,
                        onPress: () {},
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          if (snapshot.data == null) {
            return Container();
          }

          var userData = snapshot.data!;
          return SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Stack(
                    children: [
                      SizedBox(
                        width: 120,
                        height: 120,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: const CircleAvatar(
                            backgroundColor: Colors.black,
                            child: Icon(
                              Icons.person,
                              size: 75,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Colors.white,
                          ),
                          child: const Icon(
                            LineAwesomeIcons.check_circle,
                            color: Colors.green,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    userData['name'],
                    style: GoogleFonts.tajawal(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    userData['suid'],
                    style: GoogleFonts.tajawal(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.only(left: 80, right: 80),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        10,
                      ),
                      color: Colors.grey[200],
                    ),
                    child: Text(
                      userData['specialization'],
                      textAlign: TextAlign.center,
                      style: GoogleFonts.tajawal(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const Divider(),
                  ProfileMenuWidget(
                    title: "تعديل معلومات الطالب",
                    icon: LineAwesomeIcons.edit_solid,
                    onPress: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          transitionDuration:
                              Duration(milliseconds: 250), // مدة الانتقال
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  EditStudentProfile(
                            name: userData['name'],
                            suid: userData['suid'],
                            specialization: userData['specialization'],
                            targetSpecialization:
                                userData['neededspecialization'],
                          ),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            return SlideTransition(
                              position: Tween<Offset>(
                                begin: Offset(
                                    -1.0, 0.0), // بداية خارج الشاشة من اليسار
                                end: Offset.zero, // النهاية عند المكان الطبيعي
                              ).animate(animation),
                              child: child,
                            );
                          },
                        ),
                      );
                    },
                  ),
                  ProfileMenuWidget(
                    title: "تسجيل الخروج",
                    textColor: Colors.red,
                    icon: Icons.logout,
                    onPress: () async {
                      return showDialog(
                        context: context,
                        builder: (context) => Directionality(
                          textDirection: TextDirection.rtl,
                          child: AlertDialog(
                            title: Icon(
                              size: 30,
                              Icons.logout,
                              color: Colors.blue[900],
                            ),
                            content: Text(
                              "هل متأكد من رغبتك بتسجيل الخروج؟",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.cairo(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            actions: [
                              TextButton(
                                child: Text(
                                  "إلغاء",
                                  style: GoogleFonts.cairo(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              isLogingOut
                                  ? CircularProgressIndicator(
                                      strokeWidth: 3,
                                      color: Colors.blue[900],
                                    )
                                  : TextButton(
                                      child: Text(
                                        "نعم",
                                        style: GoogleFonts.cairo(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red,
                                        ),
                                      ),
                                      onPressed: () async {
                                        if (mounted) {
                                          setState(() {
                                            isLogingOut = true;
                                          });
                                        }
                                        await AuthService().signOut();
                                        if (mounted) {
                                          setState(() {
                                            isLogingOut = false;
                                            Navigator.pop(context);
                                          });
                                        }
                                      },
                                    ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
