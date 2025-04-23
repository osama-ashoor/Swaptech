import 'dart:async';

import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:swaptech2/chat/chat_service.dart';
import 'package:swaptech2/database/chatscreen_logic.dart';
import 'package:swaptech2/database/database.dart';
import 'package:swaptech2/handling%20notifications/notification.dart';
import 'package:flutter_typing_indicator/flutter_typing_indicator.dart';

class ChatScreen extends StatefulWidget {
  final String currentUserId;
  final String otherUserId;
  final String chatroomId;
  final String name;
  final String specialization;

  const ChatScreen({
    super.key,
    required this.currentUserId,
    required this.otherUserId,
    required this.chatroomId,
    required this.name,
    required this.specialization,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  DocumentSnapshot? userData;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _messageController = TextEditingController();
  final ValueNotifier<bool> _isTyping = ValueNotifier<bool>(false);
  Timer? _typingTimer;

  @override
  void initState() {
    super.initState();
    fetchData();
    _messageController.addListener(_handleTyping);
    _isTyping.addListener(_updateTypingStatus);
  }

  void _handleTyping() {
    _typingTimer?.cancel();

    if (_messageController.text.isNotEmpty) {
      if (!_isTyping.value) {
        _isTyping.value = true;
      }
      _typingTimer = Timer(const Duration(seconds: 5), () {
        _isTyping.value = false;
      });
    } else {
      _isTyping.value = false;
    }
  }

  void _updateTypingStatus() {
    ChatscreenLogic().updateTypingStatus(
      widget.chatroomId,
      widget.currentUserId,
      _isTyping.value,
    );
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<Map<String, dynamic>> fetchData() async {
    userData = await Database().getUserById(widget.otherUserId);
    return {
      'userData': userData,
    };
  }

  @override
  void dispose() {
    ChatscreenLogic().updateTypingStatus(
      widget.chatroomId,
      widget.currentUserId,
      false,
    );
    _messageController.removeListener(_handleTyping);
    _messageController.dispose();
    _isTyping.removeListener(_updateTypingStatus);
    _typingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      bottomSheet: BottomAppBar(
        height: 80,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    style: GoogleFonts.tajawal(color: Colors.black),
                    cursorColor: Colors.blue[900],
                    controller: _messageController,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                      hintText: "اكتب رسالة...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.blue[900]),
                  onPressed: () async {
                    String message = _messageController.text.trim();
                    _messageController.clear();
                    await ChatscreenLogic().addMessage(
                      widget.currentUserId,
                      widget.chatroomId,
                      message,
                    );
                    await HandlingNotification().sendPushMessageWithData(
                      recipientToken: userData!['token'],
                      title: "محادثة جديدة",
                      body: message,
                      data: {
                        'type': 'message',
                        'currentUserId': widget.currentUserId,
                        'otherUserId': widget.otherUserId,
                        'chatroomId': widget.chatroomId,
                        'name': widget.name,
                        'specialization': widget.specialization
                      },
                    );
                    Future.delayed(
                        const Duration(milliseconds: 300), _scrollToBottom);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.more_vert, color: Colors.black),
        ),
        actions: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                widget.name,
                textDirection: TextDirection.rtl,
                style: GoogleFonts.tajawal(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text(
                widget.specialization,
                textDirection: TextDirection.rtl,
                style: GoogleFonts.tajawal(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue[900],
                ),
              ),
            ],
          ),
          const SizedBox(width: 15),
          const CircleAvatar(
            backgroundColor: Colors.black,
            radius: 20,
            child: Icon(Icons.person, color: Colors.white),
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_forward_ios_rounded,
                color: Colors.black),
          ),
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
          stream: ChatscreenLogic().getTypingStatus(widget.chatroomId),
          builder: (context, typingSnapshot) {
            if (typingSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return StreamBuilder<QuerySnapshot>(
              stream: ChatscreenLogic()
                  .getMessages(widget.chatroomId, widget.currentUserId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting &&
                    (snapshot.data == null)) {
                  return Skeletonizer(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        bottom: 80,
                      ),
                      child: ListView.builder(
                        itemCount: 10,
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return BubbleSpecialThree(
                              text: 'asdasdadasdasd',
                              isSender: true,
                              color: Colors.grey.shade300,
                              tail: true,
                              seen: false,
                              sent: false,
                              textStyle: GoogleFonts.tajawal(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            );
                          } else if (index % 2 == 0) {
                            return BubbleSpecialThree(
                              text: 'asdasdadasdasd',
                              isSender: false,
                              color: Colors.grey.shade300,
                              tail: true,
                              seen: false,
                              sent: false,
                              textStyle: GoogleFonts.tajawal(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            );
                          }
                          return BubbleSpecialThree(
                            text: 'asdasdadasdasd',
                            isSender: true,
                            color: Colors.grey.shade300,
                            tail: true,
                            seen: false,
                            sent: false,
                            textStyle: GoogleFonts.tajawal(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          );
                        },
                      ),
                    ),
                  );
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center();
                }

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _scrollToBottom();
                });

                return Padding(
                  padding: const EdgeInsets.only(
                    bottom: 80,
                  ),
                  child: Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: snapshot.data!.docs.length + 1,
                      itemBuilder: (context, index) {
                        if (index == snapshot.data!.docs.length) {
                          return typingSnapshot.data!['typingStatus']
                                      [widget.otherUserId] ==
                                  true
                              ? const Padding(
                                  padding: EdgeInsets.only(left: 15.0),
                                  child: TypingIndicator(
                                    dotColor: Colors.blue,
                                    dotSize: 7.0,
                                    dotCount: 3,
                                  ),
                                )
                              : const SizedBox();
                        }
                        final message = snapshot.data!.docs[index];
                        final isSender =
                            message['senderId'] == widget.currentUserId;
                        final read = message['read'];
                        if (message['senderId'] == widget.currentUserId) {
                          return BubbleSpecialThree(
                            text: message['message'],
                            isSender: isSender,
                            color: isSender
                                ? Colors.blue[900]!
                                : Colors.grey.shade300,
                            tail: true,
                            seen: read,
                            sent: true,
                            textStyle: GoogleFonts.tajawal(
                              fontSize: 16,
                              color: isSender ? Colors.white : Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          );
                        } else {
                          return BubbleSpecialThree(
                            text: message['message'],
                            isSender: isSender,
                            color: isSender
                                ? Colors.blue[900]!
                                : Colors.grey.shade300,
                            tail: true,
                            textStyle: GoogleFonts.tajawal(
                              fontSize: 16,
                              color: isSender ? Colors.white : Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          );
                        }
                      },
                    ),
                  ),
                );
              },
            );
          }),
    );
  }
}
