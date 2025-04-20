import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:swaptech2/database/chatscreen_logic.dart';
import 'package:swaptech2/database/database.dart';
import 'dart:ui' as ui;

import 'package:swaptech2/handling%20notifications/notification.dart';
import 'package:swaptech2/pages/chatScreen.dart';

class ReceivedRequestPage extends StatefulWidget {
  final String id;

  const ReceivedRequestPage({super.key, required this.id});

  @override
  State<ReceivedRequestPage> createState() => _ReceivedRequestPageState();
}

class _ReceivedRequestPageState extends State<ReceivedRequestPage> {
  late Future<Map<String, dynamic>> _requestData;
  bool isDeleting = false;
  bool isApproving = false;
  bool _declineSwap = true;

  @override
  void initState() {
    super.initState();
    _requestData = _fetchData();
  }

  Future<Map<String, dynamic>> _fetchData() async {
    final swapData = await Database().getSwapById(swapId: widget.id);

    if (swapData == null) {
      throw Exception("لا يوجد بيانات للطلب");
    }
    final otherUserData = await Database().getUserById(swapData['senderId']);
    final currentUserData = await Database().getUserData();
    _declineSwap = (swapData['status'] == "تم القبول");

    setState(() {
      _declineSwap = !_declineSwap;
    });

    return {
      'swap': swapData,
      'otherUser': otherUserData,
      'currentUser': currentUserData,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_forward_ios_rounded,
                color: Colors.black),
          ),
        ],
      ),
      body: SafeArea(
        child: FutureBuilder<Map<String, dynamic>>(
          future: _requestData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: CircularProgressIndicator(color: Colors.blue[900]));
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  "حدث خطأ في جلب البيانات",
                  style: GoogleFonts.tajawal(fontSize: 25),
                ),
              );
            }
            final swapData = snapshot.data!['swap'];
            final otherUserData = snapshot.data!['otherUser'];
            final currentUserData = snapshot.data!['currentUser'];
            return SingleChildScrollView(
              child: Column(
                children: [
                  Directionality(
                    textDirection: ui.TextDirection.rtl,
                    child: ListTile(
                      title: Text(
                        "الطلب رقم ${widget.id}",
                        textDirection: ui.TextDirection.rtl,
                        style: GoogleFonts.cairo(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        "تاريخ الطلب : ${DateFormat('yyyy-MM-dd | hh:mm a').format(DateTime.parse(swapData['createdAt'].toDate().toString()))}",
                        textDirection: ui.TextDirection.rtl,
                        style: GoogleFonts.cairo(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const Divider(thickness: 2, color: Colors.grey),
                  Text(
                    "بيانات المرسل",
                    textDirection: ui.TextDirection.rtl,
                    style: GoogleFonts.cairo(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Directionality(
                    textDirection: ui.TextDirection.rtl,
                    child: ListTile(
                      leading: const Icon(Icons.person),
                      title: Text(
                        "الأسم : ${otherUserData['name']}",
                        textDirection: ui.TextDirection.rtl,
                        style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        "رقم القيد : ${otherUserData['suid']}",
                        textDirection: ui.TextDirection.rtl,
                        style: GoogleFonts.cairo(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      trailing: IconButton(
                        onPressed: () async {
                          try {
                            await ChatscreenLogic().addChat(
                              currentUserData['suid'],
                              otherUserData['suid'],
                              currentUserData['name'],
                              otherUserData['name'],
                              currentUserData['specialization'],
                              otherUserData['specialization'],
                            );

                            if (mounted) {
                              String chatroomId = ChatscreenLogic()
                                  .getChatroomId(swapData['senderId'],
                                      swapData['receiverId']);
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  transitionDuration: const Duration(
                                      milliseconds: 250), // مدة الانتقال
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                      ChatScreen(
                                    currentUserId: swapData['receiverId'],
                                    otherUserId: swapData['senderId'],
                                    chatroomId: chatroomId,
                                    name: otherUserData['name'],
                                    specialization:
                                        otherUserData['specialization'],
                                  ),
                                  transitionsBuilder: (context, animation,
                                      secondaryAnimation, child) {
                                    return SlideTransition(
                                      position: Tween<Offset>(
                                        begin: const Offset(-1.0,
                                            0.0), // بداية خارج الشاشة من اليسار
                                        end: Offset
                                            .zero, // النهاية عند المكان الطبيعي
                                      ).animate(animation),
                                      child: child,
                                    );
                                  },
                                ),
                              );
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                behavior: SnackBarBehavior.floating,
                                padding: const EdgeInsets.all(15),
                                content: Center(
                                  child: Text(
                                    "تحقق من اتصالك بالانترنت",
                                    style: GoogleFonts.tajawal(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        icon: Icon(Icons.message_rounded,
                            color: Colors.blue[900]),
                      ),
                    ),
                  ),
                  Directionality(
                    textDirection: ui.TextDirection.rtl,
                    child: ListTile(
                      leading: Icon(
                        Icons.info_outline_rounded,
                        color: Colors.blue[900],
                      ),
                      title: Text(
                        "التخصص الحالــــي : ${otherUserData['specialization']}",
                        textDirection: ui.TextDirection.rtl,
                        style: GoogleFonts.cairo(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Directionality(
                    textDirection: ui.TextDirection.rtl,
                    child: ListTile(
                      leading: Icon(
                        Icons.info_outline_rounded,
                        color: Colors.blue[900],
                      ),
                      title: Text(
                        "التخصص المطلوب : ${otherUserData['neededspecialization']}",
                        textDirection: ui.TextDirection.rtl,
                        style: GoogleFonts.cairo(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const Divider(thickness: 2, color: Colors.grey),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize:
                            Size(MediaQuery.of(context).size.width, 50),
                        backgroundColor: Colors.blue[900],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        if (swapData['status'] == "تم القبول") {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              behavior: SnackBarBehavior.floating,
                              padding: const EdgeInsets.all(15),
                              content: Center(
                                child: Text(
                                  "هذا الطلب تم قبوله مسبقاّ",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.tajawal(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        showDialog(
                          context: context,
                          builder: (context) => StatefulBuilder(
                            builder: (context, setAlertState) => Directionality(
                              textDirection: ui.TextDirection.rtl,
                              child: AlertDialog(
                                title: Text(
                                  "هل أنت متاكد من قبول الطلب؟",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.cairo(
                                    color: Colors.blue[900],
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                content: Text(
                                  "سيتم قبول الطلب و أشعار المرسل بذلك",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.cairo(
                                    fontSize: 16,
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
                                  isApproving
                                      ? CircularProgressIndicator(
                                          color: Colors.blue[900],
                                          strokeWidth: 3,
                                        )
                                      : TextButton(
                                          child: Text(
                                            "نعم",
                                            style: GoogleFonts.cairo(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blue[900],
                                            ),
                                          ),
                                          onPressed: () async {
                                            if (mounted) {
                                              setAlertState(() {
                                                isApproving = true;
                                              });
                                            }

                                            await Database().updateSwapStatus(
                                                swapId: swapData['id'],
                                                status: "تم القبول");
                                            await Database()
                                                .deletePendingSwapRequests(
                                                    senderId:
                                                        swapData['receiverId'],
                                                    receiverId:
                                                        swapData['senderId']);
                                            await Database()
                                                .updateSpecialization(
                                              swapData['senderId'],
                                              otherUserData['specialization'],
                                              otherUserData[
                                                  'neededspecialization'],
                                            );

                                            if (mounted) {
                                              setAlertState(() {
                                                Navigator.pop(context);
                                              });

                                              setState(() {
                                                _declineSwap = false;
                                                _requestData = _fetchData();
                                                isApproving = false;
                                              });

                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                  padding:
                                                      const EdgeInsets.all(15),
                                                  content: Center(
                                                    child: Text(
                                                      "تم قبول طلب التبديل يمكنك الأن التواصل مع زميلك",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style:
                                                          GoogleFonts.tajawal(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  backgroundColor: Colors.green,
                                                ),
                                              );
                                              await HandlingNotification()
                                                  .sendPushMessageWithData(
                                                      recipientToken:
                                                          otherUserData[
                                                              'token'],
                                                      title:
                                                          "تم قبول طلبك للتبديل",
                                                      body: "يمكنك الأن التواصل مع زميلك",
                                                      data: {
                                                    'type':
                                                        'request accepted notification',
                                                    'swapId': swapData['id']
                                                  });
                                            }
                                          },
                                        ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      child: Text(
                        "قبول الطلب",
                        style: GoogleFonts.cairo(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize:
                            Size(MediaQuery.of(context).size.width, 50),
                        backgroundColor: Colors.red[900],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: !_declineSwap
                          ? null
                          : () {
                              showDialog(
                                context: context,
                                builder: (context) => StatefulBuilder(
                                  builder: (context, setState) =>
                                      Directionality(
                                    textDirection: ui.TextDirection.rtl,
                                    child: AlertDialog(
                                      title: Text(
                                        "هل تريد رفض الطلب؟",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.cairo(
                                          color: Colors.red,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      content: Text(
                                        "سيتم رفض الطلب ولن تستطيع قبوله في المستقبل",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.cairo(
                                          fontSize: 16,
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
                                        isDeleting
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
                                                      isDeleting = true;
                                                    });
                                                  }
                                                  await Database()
                                                      .updateSwapStatus(
                                                          swapId:
                                                              swapData['id'],
                                                          status: "مرفوض");

                                                  DocumentSnapshot?
                                                      currentUserData =
                                                      await Database()
                                                          .getUserData();
                                                  await Database()
                                                      .updateSpecialization(
                                                    swapData['senderId'],
                                                    otherUserData[
                                                        'specialization'],
                                                    currentUserData![
                                                        'specialization'],
                                                  );
                                                  if (mounted) {
                                                    setState(() {
                                                      isDeleting = false;
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                          behavior:
                                                              SnackBarBehavior
                                                                  .floating,
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(15),
                                                          content: Center(
                                                            child: Text(
                                                              "تم رفضّ طلب التبديل",
                                                              style: GoogleFonts
                                                                  .tajawal(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ),
                                                          backgroundColor:
                                                              Colors.red[900],
                                                        ),
                                                      );
                                                      Navigator.pop(context);
                                                    });
                                                    await HandlingNotification()
                                                        .sendPushMessageWithData(
                                                      recipientToken:
                                                          otherUserData[
                                                              'token'],
                                                      title:
                                                          "تم رفض طلبك للتبديل",
                                                      body:
                                                          "يمكنك إعادة أرسال طلبك",
                                                      data: {
                                                        'type':
                                                            'request declined notification',
                                                        'swapId': swapData['id']
                                                      },
                                                    );
                                                  }
                                                },
                                              ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                      child: Text(
                        "رفض الطلب",
                        style: GoogleFonts.cairo(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class ReceivedRequestPageRoute extends PageRouteBuilder {
  final String id;

  ReceivedRequestPageRoute(this.id)
      : super(
          pageBuilder: (context, animation, secondaryAnimation) =>
              ReceivedRequestPage(id: id),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(-1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;
            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);
            return SlideTransition(position: offsetAnimation, child: child);
          },
        );
}
