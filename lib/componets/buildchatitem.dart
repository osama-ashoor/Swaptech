import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:swaptech2/pages/chatScreen.dart';

Widget buildChatItem(DocumentSnapshot doc, String suid, BuildContext context) {
  List<dynamic> users = doc['users'];
  String displayName = doc['displayNames'][suid];
  String displaySpecialization = doc['specializations'][suid];

  String otherUserId =
      users.firstWhere((id) => id != suid, orElse: () => 'غير معروف');
  DateTime lastMessageTime = doc['lastMessageTime']?.toDate() ?? DateTime.now();
  DateTime currentDate = DateTime.now();

  bool isSameDay = lastMessageTime.year == currentDate.year &&
      lastMessageTime.month == currentDate.month &&
      lastMessageTime.day == currentDate.day;

  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 250),
          pageBuilder: (context, animation, secondaryAnimation) => ChatScreen(
            currentUserId: suid,
            otherUserId: otherUserId,
            name: displayName,
            specialization: displaySpecialization,
            chatroomId: doc['chatroomId'],
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
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
    child: Directionality(
      textDirection: ui.TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(
              backgroundColor: Colors.black,
              radius: 30,
              child: Icon(
                Icons.person,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Expanded(
                        child: Text(
                          "$otherUserId | ${displayName}",
                          style: GoogleFonts.tajawal(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        isSameDay
                            ? DateFormat('hh:mm a').format(lastMessageTime)
                            : DateFormat('yyyy-MM-dd').format(lastMessageTime),
                        style: GoogleFonts.tajawal(
                          fontSize: 15,
                          color: Colors.black,
                        ),
                        textDirection: ui.TextDirection.ltr,
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      doc['lastMessageSender'] == suid
                          ? Text(
                              "أنت: ",
                              style: GoogleFonts.tajawal(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : Container(),
                      Text(
                        doc['lastMessage'],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.tajawal(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
