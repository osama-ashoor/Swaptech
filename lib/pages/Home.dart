import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swaptech2/database/database.dart';
import 'package:swaptech2/handling%20notifications/notification.dart';
import 'package:swaptech2/main.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:swaptech2/pages/chatrooms.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isLoading = true;
  bool isOnline = false;
  bool sendRequest = false;
  bool hasApprovedSwap = false;
  DocumentSnapshot? userData;

  Future<Map<String, dynamic>> fetchData() async {
    hasApprovedSwap = await Database().hasApprovedOrder();
    userData = await Database().getUserData();
    return {
      'hasApprovedSwap': hasApprovedSwap,
      'userData': userData,
    };
  }

  void checkConnection() async {
    List<ConnectivityResult> result = await Connectivity().checkConnectivity();
    bool hasInternet = await _hasInternetAccess();
    if (result.first == ConnectivityResult.none || !hasInternet) {
      if (mounted) {
        setState(() {
          isOnline = false;
          isLoading = false;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          isOnline = true;
          sendRequest = true;
          isLoading = false;
        });
      }
    }
  }

  Future<bool> _hasInternetAccess() async {
    try {
      final result = await InternetAddress.lookup('google.com').timeout(
        const Duration(seconds: 10),
      );
      return result.isNotEmpty && result.first.rawAddress.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
    checkConnection();
    Connectivity().onConnectivityChanged.listen((event) {
      if (event.first == ConnectivityResult.none) {
        if (mounted) {
          scaffoldMessengerKey.currentState?.showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Center(
                child: Text(
                  "تحقق من أتصالك بالانترنت",
                  style: GoogleFonts.tajawal(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
          setState(() {
            sendRequest = false;
            isOnline = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            isOnline = true;
            sendRequest = true;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(bottom: 7.0),
          child: IconButton(
            onPressed: () {
              if (userData == null) return;
              Navigator.push(
                context,
                PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 250),
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      Chatrooms(
                    suid: userData!['suid'],
                  ),
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
            icon: Icon(
              Icons.message_rounded,
              color: Colors.blue[900],
            ),
          ),
        ),
        centerTitle: true,
        title: Text(
          "الصفحة الرئيسية",
          textAlign: TextAlign.center,
          style: GoogleFonts.tajawal(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
      body: isLoading
          ? Directionality(
              textDirection: TextDirection.rtl,
              child: Skeletonizer(
                child: ListView.builder(
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return Directionality(
                      textDirection: TextDirection.rtl,
                      child: ListTile(
                        trailing: IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.send,
                            color: Colors.blue[900],
                          ),
                        ),
                        leading: const CircleAvatar(
                          backgroundColor: Colors.black,
                          radius: 30,
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(
                          "اسم المستخدم", // بيانات وهمية
                          style: GoogleFonts.tajawal(fontSize: 25),
                        ),
                        subtitle: Text(
                          "التخصص",
                          style: GoogleFonts.tajawal(
                            fontSize: 25,
                            color: Colors.blue[900],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            )
          : isOnline
              ? FutureBuilder(
                  future: fetchData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Directionality(
                        textDirection: TextDirection.rtl,
                        child: Skeletonizer(
                          child: ListView.builder(
                            itemCount: 5,
                            itemBuilder: (context, index) {
                              return Directionality(
                                textDirection: TextDirection.rtl,
                                child: ListTile(
                                  trailing: IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.send,
                                      color: Colors.blue[900],
                                    ),
                                  ),
                                  leading: const CircleAvatar(
                                    backgroundColor: Colors.black,
                                    radius: 30,
                                    child: Icon(
                                      Icons.person,
                                      color: Colors.white,
                                    ),
                                  ),
                                  title: Text(
                                    "اسم المستخدم", // بيانات وهمية
                                    style: GoogleFonts.tajawal(fontSize: 25),
                                  ),
                                  subtitle: Text(
                                    "التخصص",
                                    style: GoogleFonts.tajawal(
                                      fontSize: 25,
                                      color: Colors.blue[900],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          "حدث خطأ في جلب البيانات",
                          style: GoogleFonts.tajawal(
                            fontSize: 20,
                          ),
                        ),
                      );
                    }

                    if (snapshot.data!['hasApprovedSwap']) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "لديك طلب تمت موافقة عليه",
                              style: GoogleFonts.tajawal(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text("يرجى التحقق من صفحة الطلبات",
                                style: GoogleFonts.tajawal(
                                  fontSize: 18,
                                  color: Colors.blue[900],
                                  fontWeight: FontWeight.bold,
                                ))
                          ],
                        ),
                      );
                    }

                    var userData = snapshot.data!['userData'];
                    return StreamBuilder(
                      stream: Database().getMatchedSpecializations(
                          userData["specialization"],
                          userData['neededspecialization']),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Directionality(
                            textDirection: TextDirection.rtl,
                            child: Skeletonizer(
                                child: ListView.builder(
                              itemCount: 5,
                              itemBuilder: (context, index) {
                                return Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: ListTile(
                                    trailing: IconButton(
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.send,
                                        color: Colors.blue[900],
                                      ),
                                    ),
                                    leading: const CircleAvatar(
                                      backgroundColor: Colors.black,
                                      radius: 30,
                                      child: Icon(
                                        Icons.person,
                                        color: Colors.white,
                                      ),
                                    ),
                                    title: Text(
                                      "اسم المستخدم", // بيانات وهمية
                                      style: GoogleFonts.tajawal(fontSize: 25),
                                    ),
                                    subtitle: Text(
                                      "التخصص",
                                      style: GoogleFonts.tajawal(
                                        fontSize: 25,
                                        color: Colors.blue[900],
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            )),
                          );
                        }

                        if (snapshot.hasError) {
                          return Center(
                            child: Text(
                              "حدث خطأ في جلب البيانات",
                              style: GoogleFonts.tajawal(
                                fontSize: 25,
                              ),
                            ),
                          );
                        }

                        if (snapshot.data!.isEmpty) {
                          return Center(
                            child: Text(
                              "لا يوجد بديل لك في الوقت الحالي",
                              style: GoogleFonts.tajawal(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        }

                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return Directionality(
                              textDirection: TextDirection.rtl,
                              child: ListTile(
                                trailing: IconButton(
                                  onPressed: () async {
                                    bool approved =
                                        await Database().hasApprovedOrder();
                                    if (approved != hasApprovedSwap &&
                                        mounted) {
                                      setState(() {
                                        hasApprovedSwap = approved;
                                      });
                                    }
                                    if (hasApprovedSwap) {
                                      return;
                                    }
                                    if (sendRequest) {
                                      try {
                                        await Database().addSwapRequest(
                                            senderId: userData["suid"],
                                            receiverId: snapshot.data![index]
                                                ["suid"]);

                                        HandlingNotification()
                                            .sendPushMessageWithData(
                                          recipientToken: snapshot.data![index]
                                              ["token"],
                                          title: "طلب جديد",
                                          body: "لديك طلب تبديل جديد",
                                          data: {"type": "swap"},
                                        );
                                        if (mounted) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              padding: const EdgeInsets.all(15),
                                              content: Center(
                                                child: Text(
                                                  "تم أرسال طلبك بنجاح",
                                                  style: GoogleFonts.tajawal(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              backgroundColor: Colors.green,
                                            ),
                                          );
                                        }
                                      } catch (e) {
                                        if (mounted) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              padding: const EdgeInsets.all(15),
                                              content: Center(
                                                child: Text(
                                                  "لديك طلب قيد الأنتظار مع هذا المستخدم",
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.tajawal(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              backgroundColor:
                                                  Colors.yellow[800],
                                            ),
                                          );
                                        }
                                      }
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Center(
                                            child: Text(
                                              "تحقق من أتصالك بالانترنت",
                                              style: GoogleFonts.tajawal(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          backgroundColor: Colors.red[700],
                                        ),
                                      );
                                    }
                                  },
                                  icon: Icon(
                                    Icons.send,
                                    color: Colors.blue[900],
                                    size: 20,
                                  ),
                                ),
                                leading: const CircleAvatar(
                                  backgroundColor: Colors.black,
                                  radius: 30,
                                  child: Icon(
                                    Icons.person,
                                    color: Colors.white,
                                  ),
                                ),
                                title: Text(
                                  snapshot.data![index]['name'],
                                  style: GoogleFonts.tajawal(fontSize: 20),
                                ),
                                subtitle: Text(
                                  snapshot.data![index]['specialization'],
                                  style: GoogleFonts.tajawal(
                                      fontSize: 20,
                                      color: Colors.blue[900],
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                )
              : Center(
                  child: Text(
                    "لا يوجد اتصال بالانترنت",
                    style: GoogleFonts.tajawal(fontSize: 22),
                  ),
                ),
    );
  }
}
