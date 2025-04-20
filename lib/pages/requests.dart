import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:swaptech2/database/database.dart';
import 'package:swaptech2/main.dart';
import 'package:intl/intl.dart';
import 'package:swaptech2/pages/receivedRequestPage.dart';
import 'dart:ui' as ui;

import 'package:swaptech2/pages/senderRequestPage.dart';

class Requests extends StatefulWidget {
  const Requests({super.key});

  @override
  State<Requests> createState() => _RequestsState();
}

class _RequestsState extends State<Requests> {
  bool isLoading = true;
  bool isOnline = false;

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
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
              labelColor: Colors.blue[900],
              indicatorColor: Colors.blue[900],
              tabs: [
                Tab(
                  child: Text(
                    "الطلبات المستملة",
                    style: GoogleFonts.tajawal(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    "الطلبات المرسلة",
                    style: GoogleFonts.tajawal(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ]),
          centerTitle: true,
          title: Text("طلبات التبديل ",
              textAlign: TextAlign.center,
              style: GoogleFonts.tajawal(
                  fontSize: 25, fontWeight: FontWeight.bold)),
        ),
        body: TabBarView(
          children: [
            isLoading
                ? ListView.builder(
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return Directionality(
                        textDirection: ui.TextDirection.rtl,
                        child: Skeletonizer(
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                            ),
                            child: ListTile(
                              onTap: () {
                                // هنا يمكنك إضافة التنقل لاحقًا
                              },
                              title: Text(
                                "رقم الطلب : #12345",
                                style: GoogleFonts.cairo(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              trailing: Text(
                                "قيد الأنتظار",
                                style: GoogleFonts.cairo(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.yellow[800],
                                ),
                              ),
                              subtitle: Row(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(
                                        top: 5.0, left: 5.0),
                                    width: 6,
                                    height: 6,
                                    decoration: const BoxDecoration(
                                      color: Colors.black,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  Text(
                                    "تاريخ الطلب : 2025-03-24",
                                    style: GoogleFonts.cairo(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : isOnline
                    ? FutureBuilder<DocumentSnapshot?>(
                        future: Database().getUserData(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return ListView.builder(
                              itemCount: 10,
                              itemBuilder: (context, index) {
                                return Directionality(
                                  textDirection: ui.TextDirection.rtl,
                                  child: Skeletonizer(
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[50],
                                      ),
                                      child: ListTile(
                                        onTap: () {
                                          // هنا يمكنك إضافة التنقل لاحقًا
                                        },
                                        title: Text(
                                          "رقم الطلب : #12345",
                                          style: GoogleFonts.cairo(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        trailing: Text(
                                          "قيد الأنتظار",
                                          style: GoogleFonts.cairo(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.yellow[800],
                                          ),
                                        ),
                                        subtitle: Row(
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  top: 5.0, left: 5.0),
                                              width: 6,
                                              height: 6,
                                              decoration: const BoxDecoration(
                                                color: Colors.black,
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                            Text(
                                              "تاريخ الطلب : 2025-03-24",
                                              style: GoogleFonts.cairo(),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
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

                          var userData = snapshot.data!;
                          return StreamBuilder(
                            stream: Database().getReceiverSwaps(
                              receiverId: userData['suid'],
                            ),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return ListView.builder(
                                  itemCount: 10,
                                  itemBuilder: (context, index) {
                                    return Directionality(
                                      textDirection: ui.TextDirection.rtl,
                                      child: Skeletonizer(
                                        child: Container(
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 10),
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: Colors.grey[50],
                                          ),
                                          child: ListTile(
                                            onTap: () {
                                              // هنا يمكنك إضافة التنقل لاحقًا
                                            },
                                            title: Text(
                                              "رقم الطلب : #12345",
                                              style: GoogleFonts.cairo(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            trailing: Text(
                                              "قيد الأنتظار",
                                              style: GoogleFonts.cairo(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                color: Colors.yellow[800],
                                              ),
                                            ),
                                            subtitle: Row(
                                              children: [
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      top: 5.0, left: 5.0),
                                                  width: 6,
                                                  height: 6,
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: Colors.black,
                                                    shape: BoxShape.circle,
                                                  ),
                                                ),
                                                Text(
                                                  "تاريخ الطلب : 2025-03-24",
                                                  style: GoogleFonts.cairo(),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }

                              if (snapshot.hasError) {
                                return Center(
                                  child: Text(
                                    "حدث خطأ في جلب البيانات",
                                    style: GoogleFonts.tajawal(
                                      fontSize: 18,
                                    ),
                                  ),
                                );
                              }

                              if (snapshot.data!.isEmpty) {
                                return Center(
                                  child: Text(
                                    "لا يوجد طلبات مستملة",
                                    style: GoogleFonts.tajawal(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                );
                              }

                              return ListView.builder(
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index) {
                                    return Directionality(
                                      textDirection: ui.TextDirection.rtl,
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(
                                          vertical: 10,
                                        ),
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[50],
                                        ),
                                        child: ListTile(
                                          onTap: () {
                                            Navigator.of(context)
                                                .push(ReceivedRequestPageRoute(
                                              snapshot.data![index]['id'],
                                            ));
                                          },
                                          title: Text(
                                            "رقم الطلب : #${snapshot.data![index]['id']}",
                                            style: GoogleFonts.cairo(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          trailing: Text(
                                            snapshot.data![index]['status'],
                                            style: GoogleFonts.cairo(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: snapshot.data![index]
                                                              ['status']
                                                          .toString() ==
                                                      "مرفوض"
                                                  ? Colors.red[800]
                                                  : snapshot.data![index]
                                                                  ['status']
                                                              .toString() ==
                                                          "قيد الأنتظار"
                                                      ? Colors.yellow[800]
                                                      : Colors.green[800],
                                            ),
                                          ),
                                          subtitle: Row(
                                            children: [
                                              Container(
                                                margin: const EdgeInsets.only(
                                                  top: 5.0,
                                                  left: 5.0,
                                                ),
                                                width: 6,
                                                height: 6,
                                                decoration: const BoxDecoration(
                                                  color: Colors.black,
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                              Text(
                                                textDirection:
                                                    ui.TextDirection.rtl,
                                                "تاريخ الطلب : ${DateFormat('yyyy-MM-dd').format(DateTime.parse(snapshot.data![index]['createdAt'].toDate().toString()))}",
                                                style: GoogleFonts.cairo(),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  });
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
            isLoading
                ? Directionality(
                    textDirection: ui.TextDirection.rtl,
                    child: Skeletonizer(
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                        ),
                        child: ListTile(
                          onTap: () {
                            // هنا يمكنك إضافة التنقل لاحقًا
                          },
                          title: Text(
                            "رقم الطلب : #12345",
                            style: GoogleFonts.cairo(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          trailing: Text(
                            "قيد الأنتظار",
                            style: GoogleFonts.cairo(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.yellow[800],
                            ),
                          ),
                          subtitle: Row(
                            children: [
                              Container(
                                margin:
                                    const EdgeInsets.only(top: 5.0, left: 5.0),
                                width: 6,
                                height: 6,
                                decoration: const BoxDecoration(
                                  color: Colors.black,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              Text(
                                "تاريخ الطلب : 2025-03-24",
                                style: GoogleFonts.cairo(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                : isOnline
                    ? FutureBuilder<DocumentSnapshot?>(
                        future: Database().getUserData(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Directionality(
                              textDirection: ui.TextDirection.rtl,
                              child: Skeletonizer(
                                child: Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[50],
                                  ),
                                  child: ListTile(
                                    onTap: () {
                                      // هنا يمكنك إضافة التنقل لاحقًا
                                    },
                                    title: Text(
                                      "رقم الطلب : #12345",
                                      style: GoogleFonts.cairo(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    trailing: Text(
                                      "قيد الأنتظار",
                                      style: GoogleFonts.cairo(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.yellow[800],
                                      ),
                                    ),
                                    subtitle: Row(
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.only(
                                              top: 5.0, left: 5.0),
                                          width: 6,
                                          height: 6,
                                          decoration: const BoxDecoration(
                                            color: Colors.black,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        Text(
                                          "تاريخ الطلب : 2025-03-24",
                                          style: GoogleFonts.cairo(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }

                          if (snapshot.hasError) {
                            return Center(
                              child: Text(
                                "حدث خطأ في جلب البيانات",
                                style: GoogleFonts.tajawal(
                                  fontSize: 18,
                                ),
                              ),
                            );
                          }

                          var userData = snapshot.data!;
                          return StreamBuilder(
                            stream: Database().getSenderSwaps(
                              senderId: userData['suid'],
                            ),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Directionality(
                                  textDirection: ui.TextDirection.rtl,
                                  child: Skeletonizer(
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[50],
                                      ),
                                      child: ListTile(
                                        onTap: () {
                                          // هنا يمكنك إضافة التنقل لاحقًا
                                        },
                                        title: Text(
                                          "رقم الطلب : #12345",
                                          style: GoogleFonts.cairo(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        trailing: Text(
                                          "قيد الأنتظار",
                                          style: GoogleFonts.cairo(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.yellow[800],
                                          ),
                                        ),
                                        subtitle: Row(
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  top: 5.0, left: 5.0),
                                              width: 6,
                                              height: 6,
                                              decoration: const BoxDecoration(
                                                color: Colors.black,
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                            Text(
                                              "تاريخ الطلب : 2025-03-24",
                                              style: GoogleFonts.cairo(),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }

                              if (snapshot.hasError) {
                                return Center(
                                  child: Text(
                                    "حدث خطأ في جلب البيانات",
                                    style: GoogleFonts.tajawal(
                                      fontSize: 18,
                                    ),
                                  ),
                                );
                              }

                              if (snapshot.data!.isEmpty) {
                                return Center(
                                  child: Text(
                                    "لا يوجد طلبات مرسلة",
                                    style: GoogleFonts.tajawal(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                );
                              }

                              return ListView.builder(
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index) {
                                    return Directionality(
                                      textDirection: ui.TextDirection.rtl,
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(
                                          vertical: 10,
                                        ),
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[50],
                                        ),
                                        child: ListTile(
                                          onTap: () {
                                            Navigator.of(context)
                                                .push(RequestPageRoute(
                                              snapshot.data![index]['id'],
                                            ));
                                          },
                                          title: Text(
                                            "رقم الطلب : #${snapshot.data![index]['id']}",
                                            style: GoogleFonts.cairo(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          trailing: Text(
                                            snapshot.data![index]['status'],
                                            style: GoogleFonts.cairo(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: snapshot.data![index]
                                                              ['status']
                                                          .toString() ==
                                                      "مرفوض"
                                                  ? Colors.red[800]
                                                  : snapshot.data![index]
                                                                  ['status']
                                                              .toString() ==
                                                          "قيد الأنتظار"
                                                      ? Colors.yellow[800]
                                                      : Colors.green[800],
                                            ),
                                          ),
                                          subtitle: Row(
                                            children: [
                                              Container(
                                                margin: const EdgeInsets.only(
                                                  top: 5.0,
                                                  left: 5.0,
                                                ),
                                                width: 6,
                                                height: 6,
                                                decoration: const BoxDecoration(
                                                  color: Colors.black,
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                              Text(
                                                textDirection:
                                                    ui.TextDirection.rtl,
                                                "تاريخ الطلب : ${DateFormat('yyyy-MM-dd').format(DateTime.parse(snapshot.data![index]['createdAt'].toDate().toString()))}",
                                                style: GoogleFonts.cairo(),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  });
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
          ],
        ),
      ),
    );
  }
}
