import 'dart:developer';

import 'package:chat_app/models/chat_modal.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FireStoreHelper {
  FireStoreHelper._();

  static final FireStoreHelper fireStoreHelper = FireStoreHelper._();
  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  String userCollection = "User";

  sendMessage({required ChatModal chatModal, required String senderId, required String receiverId}) {
    Map<String, dynamic> data = chatModal.toMap;

    data.update('type', (value) => 'sent');

    fireStore
        .collection(userCollection)
        .doc(senderId)
        .collection(receiverId)
        .doc(chatModal.time.millisecondsSinceEpoch.toString())
        .set(data);

    fireStore
        .collection(userCollection)
        .doc(senderId)
        .collection(receiverId)
        .doc("Chats")
        .collection("AllChats")
        .doc(chatModal.time.millisecondsSinceEpoch.toString())
        .set(data);

    data.update('type', (value) => 'rec');

    fireStore
        .collection(userCollection)
        .doc(receiverId)
        .collection(senderId)
        .doc(chatModal.time.millisecondsSinceEpoch.toString())
        .set(data);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getChats({required String senderId, required String receiverId}) {
    return fireStore.collection(userCollection).doc(senderId).collection(receiverId).snapshots();
  }

  Future<void> setUserData({required User user}) async {
    UserModel userModel = UserModel(
      uid: user.uid,
      userName: user.displayName ?? "NULL",
      email: user.email as String,
      profilepic: user.photoURL ??
          "https://static.vecteezy.com/system/resources/previews/005/544/718/non_2x/profile-icon-design-free-vector.jpg",
    );

    await fireStore.collection(userCollection).doc(user.uid).update(userModel.toMap()).then((value) {
      log("Data insert Successfully");
    });
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getContactList({required String uid}) {
    return fireStore.collection(userCollection).doc(uid).snapshots();
  }

  Future<List> getContactData({required String uid}) async {
    DocumentSnapshot<Map<String, dynamic>>? snaps = await fireStore.collection(userCollection).doc(uid).get();

    Map data = snaps.data() as Map;

    return data['contact'] ?? [];
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getUserData() {
    return fireStore.collection(userCollection).snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getUserById({required String uid}) {
    return fireStore.collection(userCollection).doc(uid).snapshots();
  }

  Future<void> addContact({required String sender, required String receiver}) async {
    List contacts = await getContactData(uid: sender);

    if (!contacts.contains(receiver)) {
      contacts.add(receiver);
      fireStore.collection(userCollection).doc(sender).update({'contact': contacts});
    }
    contacts = await getContactData(uid: receiver);

    if (!contacts.contains(sender)) {
      contacts.add(sender);
      fireStore.collection(userCollection).doc(receiver).update({'contact': contacts});
    }
  }
}
