import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:swaptech2/componets/buildchatitem.dart';
import 'package:swaptech2/database/chatscreen_logic.dart';
import 'package:swaptech2/database/database.dart';

// ignore: must_be_immutable
class Chatrooms extends StatefulWidget {
  String suid;
  Chatrooms({super.key, required this.suid});

  @override
  State<Chatrooms> createState() => _ChatroomsState();
}

class _ChatroomsState extends State<Chatrooms> {
  DocumentSnapshot? userData;

  Future<Map<String, dynamic>> fetchData() async {
    userData = await Database().getUserData();
    return {
      'userData': userData,
    };
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
        centerTitle: true,
        title: Text(
          "المحادثات",
          style: GoogleFonts.tajawal(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: ChatscreenLogic().getChatrooms(widget.suid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Skeletonizer(
                child: GestureDetector(
                  onTap: () {},
                  child: const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.black,
                          radius: 30,
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.alphabetic, // مهم!
                                children: [
                                  Expanded(
                                    child: Text(
                                      "waiting for response",
                                      textDirection: TextDirection.ltr,
                                    ),
                                  ),
                                  Text(
                                    "waiting for response",
                                    textDirection: TextDirection.ltr,
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                              Text(
                                "Waiting for response",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
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
            if (snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text(
                  "لا يوجد محادثات",
                  style: GoogleFonts.tajawal(fontSize: 25),
                ),
              );
            }
            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            }
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final doc = snapshot.data!.docs[index];
                  return buildChatItem(doc, widget.suid, context);
                });
          }),
    );
  }
}
