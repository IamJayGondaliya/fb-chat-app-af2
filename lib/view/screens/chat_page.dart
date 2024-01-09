import 'package:chat_app/models/chat_modal.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/utills/helper/firebase_auth_helper.dart';
import 'package:chat_app/utills/helper/firestore_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    UserModel userModel = ModalRoute.of(context)!.settings.arguments as UserModel;
    String senderId = FirebaseAuthHelper.firebaseAuthHelper.firebaseAuth.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        leading: CircleAvatar(
          radius: 30,
          foregroundImage: NetworkImage(userModel.profilepic),
        ),
        title: Text(userModel.userName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: FireStoreHelper.fireStoreHelper.getChats(senderId: senderId, receiverId: userModel.uid),
                builder: (ctx, snapShot) {
                  if (snapShot.hasData) {
                    QuerySnapshot? snaps = snapShot.data;

                    List<QueryDocumentSnapshot> allData = snaps!.docs;

                    List<ChatModal> allChats = allData.map((e) => ChatModal.fromMap(data: e.data() as Map)).toList();

                    return ListView.builder(
                      itemCount: allChats.length,
                      itemBuilder: (ctx, index) {
                        ChatModal chat = allChats[index];

                        return Row(
                          mainAxisAlignment: chat.type == 'sent' ? MainAxisAlignment.start : MainAxisAlignment.end,
                          children: [
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(chat.msg),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
            TextField(
              onSubmitted: (val) {
                ChatModal chatModal = ChatModal(
                  val,
                  DateTime.now(),
                  'sent',
                );

                FireStoreHelper.fireStoreHelper.sendMessage(
                  chatModal: chatModal,
                  senderId: FirebaseAuthHelper.firebaseAuthHelper.firebaseAuth.currentUser!.uid,
                  receiverId: userModel.uid,
                );
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
