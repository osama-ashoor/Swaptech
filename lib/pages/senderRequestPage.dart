import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:swaptech2/database/chatscreen_logic.dart';
import 'package:swaptech2/database/database.dart';
import 'dart:ui' as ui;

import 'package:swaptech2/pages/chatScreen.dart';

class Requestpage extends StatefulWidget {
  final String id;

  const Requestpage({super.key, required this.id});

  @override
  State<Requestpage> createState() => _RequestpageState();
}

class _RequestpageState extends State<Requestpage> {
  late Future<Map<String, dynamic>> _requestData;
  bool isDeleting = false;

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
    final otheruserData = await Database().getUserById(swapData['receiverId']);
    final userData = await Database().getUserData();
    return {
      'swap': swapData,
      'otherUser': otheruserData,
      'currentUser': userData,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => StatefulBuilder(
                builder: (context, setState) => Directionality(
                  textDirection: ui.TextDirection.rtl,
                  child: AlertDialog(
                    title: Text(
                      "هل تريد حذف الطلب؟",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.cairo(
                        color: Colors.red,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    content: Text(
                      "سيتم حذف الطلب بشكل نهائي و لا يمكنك أسترجاعه",
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
                            color: Colors.blue[900],
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      isDeleting
                          ? CircularProgressIndicator(
                              color: Colors.blue[900],
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
                                  setState(() {
                                    isDeleting = true;
                                  });
                                }
                                await Database().deleteSwap(swapId: widget.id);
                                if (mounted) {
                                  if (mounted) {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  }
                                }
                              },
                            ),
                    ],
                  ),
                ),
              ),
            );
          },
          icon: const Icon(Icons.delete_rounded, color: Colors.red),
        ),
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
                      title: Row(
                        children: [
                          Text(
                            "الطلب رقم ${widget.id} -",
                            textDirection: ui.TextDirection.rtl,
                            style: GoogleFonts.cairo(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            " ${swapData['status']}",
                            textDirection: ui.TextDirection.rtl,
                            style: GoogleFonts.cairo(
                              color: swapData['status'].toString() == "مرفوض"
                                  ? Colors.red[800]
                                  : swapData['status'].toString() ==
                                          "قيد الأنتظار"
                                      ? Colors.yellow[800]
                                      : Colors.green[800],
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
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
                    "بيانات المستلم",
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
                        "رقم القيد : ${swapData['receiverId']}",
                        textDirection: ui.TextDirection.rtl,
                        style: GoogleFonts.cairo(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      trailing: IconButton(
                        onPressed: () async {
                          print(currentUserData['name']);
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
                                    currentUserId: swapData['senderId'],
                                    otherUserId: swapData['receiverId'],
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
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class RequestPageRoute extends PageRouteBuilder {
  final String id;

  RequestPageRoute(this.id)
      : super(
          pageBuilder: (context, animation, secondaryAnimation) =>
              Requestpage(id: id),
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
