import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Database extends ChangeNotifier {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  FirebaseAuth auth = FirebaseAuth.instance;
  Future<void> addUser(String name, String id, String email,
      String specialization, String neededspecialization, String token) async {
    await users.add({
      'name': name,
      'suid': id,
      'email': email,
      'specialization': specialization,
      'neededspecialization': neededspecialization,
      'swaped': false,
      'token': token,
    });
  }

  Future<void> updateUser(Map<String, dynamic> updatedFields) async {
    if (updatedFields.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(auth.currentUser!.uid)
          .update(updatedFields);
    } else {
      return;
    }
  }

  Future<void> updateSuidInSwaps(String newSuid, String oldSuid) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('swaps')
        .where('senderId', isEqualTo: oldSuid)
        .get();

    for (DocumentSnapshot documentSnapshot in querySnapshot.docs) {
      await documentSnapshot.reference.update({'senderId': newSuid});
    }

    querySnapshot = await FirebaseFirestore.instance
        .collection('swaps')
        .where('receiverId', isEqualTo: oldSuid)
        .get();

    for (DocumentSnapshot documentSnapshot in querySnapshot.docs) {
      await documentSnapshot.reference.update({'receiverId': newSuid});
    }
  }

  Future<void> updateSpecialization(
      String otherUserId,
      String newSpecializationCurrentUser,
      String newSpecializationOtherUser) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(auth.currentUser!.uid)
        .update(
            {'specialization': newSpecializationCurrentUser, 'swaped': true});

    await FirebaseFirestore.instance
        .collection('users')
        .where('suid', isEqualTo: otherUserId)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.first.reference.update(
        {'specialization': newSpecializationOtherUser, 'swaped': true},
      );
    });
  }

  Stream<List<QueryDocumentSnapshot>> getMatchedSpecializations(
      String specialization, String targetSpecialization) {
    return users
        .where('specialization', isEqualTo: targetSpecialization)
        .where('neededspecialization', isEqualTo: specialization)
        .where('swaped', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs);
  }

  Future<DocumentSnapshot?> getUserData() async {
    if (auth.currentUser == null) return null;
    return await users.doc(auth.currentUser!.uid).get();
  }

  Stream<DocumentSnapshot?> getUserDataStream() {
    if (auth.currentUser == null) {
      return const Stream.empty();
    }
    String userId = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .snapshots();
  }

  Future<DocumentSnapshot?> getUserById(String id) async {
    var querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('suid', isEqualTo: id)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first;
    } else {
      return null;
    }
  }

  Future<void> addSwapRequest({
    required String senderId,
    required String receiverId,
  }) async {
    CollectionReference swapsRef =
        FirebaseFirestore.instance.collection('swaps');

    try {
      // بدء المعاملة لضمان عدم تعارض البيانات
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        // التحقق من وجود طلب قيد الانتظار من الطرفين
        QuerySnapshot querySnapshot = await swapsRef
            .where('senderId', isEqualTo: senderId)
            .where('receiverId', isEqualTo: receiverId)
            .where('status', isEqualTo: 'قيد الأنتظار')
            .get();

        QuerySnapshot reverseQuerySnapshot = await swapsRef
            .where('senderId', isEqualTo: receiverId)
            .where('receiverId', isEqualTo: senderId)
            .where('status', isEqualTo: 'قيد الأنتظار')
            .get();

        if (querySnapshot.docs.isNotEmpty ||
            reverseQuerySnapshot.docs.isNotEmpty) {
          throw Exception();
        }

        // العثور على آخر ID
        DocumentSnapshot? lastSwapSnapshot = await swapsRef
            .orderBy('id', descending: true)
            .limit(1)
            .get()
            .then((snapshot) {
          return snapshot.docs.isNotEmpty ? snapshot.docs.first : null;
        });

        int newId = (lastSwapSnapshot != null)
            ? (int.tryParse(lastSwapSnapshot['id'])!) + 1
            : 1;

        // إضافة طلب التبديل
        await swapsRef.add({
          'id': "$newId",
          'senderId': senderId,
          'receiverId': receiverId,
          'status': 'قيد الأنتظار',
          'createdAt': FieldValue.serverTimestamp(),
        });
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateSwapStatus({
    required String swapId,
    required String status,
  }) async {
    var querySnapshot = await FirebaseFirestore.instance
        .collection('swaps')
        .where('id', isEqualTo: swapId)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      await querySnapshot.docs.first.reference.update({'status': status});
    } else {
      return;
    }
  }

  Future<void> deletePendingSwapRequests(
      {required String senderId, required String receiverId}) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('swaps')
        .where('senderId',
            isEqualTo: senderId) // البحث عن الطلبات المرسلة من المستخدم
        .where('status',
            isEqualTo: 'قيد الأنتظار') // التأكد من أن الطلب قيد الانتظار
        .get();
    for (var doc in querySnapshot.docs) {
      await doc.reference.delete(); // حذف كل الطلبات المطابقة
    }

    final querySnapshot2 = await FirebaseFirestore.instance
        .collection('swaps')
        .where('senderId',
            isEqualTo: receiverId) // البحث عن الطلبات المرسلة من المستخدم
        .where('status',
            isEqualTo: 'قيد الأنتظار') // التأكد من أن الطلب قيد الانتظار
        .get();
    for (var doc in querySnapshot2.docs) {
      await doc.reference.delete(); // حذف كل الطلبات المطابقة
    }
  }

  Stream<List<QueryDocumentSnapshot>> getSenderSwaps({
    required String senderId,
  }) {
    return FirebaseFirestore.instance
        .collection('swaps')
        .where('senderId', isEqualTo: senderId)
        .snapshots()
        .map((snapshot) => snapshot.docs);
  }

  Stream<List<QueryDocumentSnapshot>> getReceiverSwaps({
    required String receiverId,
  }) {
    return FirebaseFirestore.instance
        .collection('swaps')
        .where('receiverId', isEqualTo: receiverId)
        .snapshots()
        .map((snapshot) => snapshot.docs);
  }

  Future<DocumentSnapshot?> getSwapById({required String swapId}) async {
    var querySnapshot = await FirebaseFirestore.instance
        .collection('swaps')
        .where('id', isEqualTo: swapId)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first;
    } else {
      return null;
    }
  }

  Future<bool> hasApprovedOrder() async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    String suid = userDoc.get('suid');

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('swaps')
        .where('status', isEqualTo: 'تم القبول')
        .where(Filter.or(
          Filter('senderId', isEqualTo: suid),
          Filter('receiverId', isEqualTo: suid),
        ))
        .limit(1)
        .get();
    return querySnapshot.docs.isNotEmpty;
  }

  Future<void> deleteSwap({required String swapId}) async {
    // Query the document(s) where the 'id' field matches the swapId
    final querySnapshot = await FirebaseFirestore.instance
        .collection('swaps')
        .where('id', isEqualTo: swapId)
        .limit(1)
        .get();

    // Check if any documents match the query
    if (querySnapshot.docs.isNotEmpty) {
      // Get the first document (since we used limit(1))
      final doc = querySnapshot.docs.first;

      // Delete the document
      await doc.reference.delete();
    } else {}
  }
}
