import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/utills/helper/firebase_auth_helper.dart';
import 'package:chat_app/utills/helper/firestore_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuthHelper.firebaseAuthHelper.firebaseAuth.currentUser;

    return SafeArea(
      child: Scaffold(
        drawer: Drawer(
          child: Column(
            children: [
              UserAccountsDrawerHeader(
                currentAccountPicture: CircleAvatar(
                  backgroundImage: NetworkImage(user!.photoURL ??
                      "https://static.vecteezy.com/system/resources/previews/005/544/718/non_2x/profile-icon-design-free-vector.jpg"),
                ),
                accountName: Text(user.displayName ?? 'DEMO'),
                accountEmail: Text("${user.email}"),
              ),
            ],
          ),
        ),
        appBar: AppBar(
          title: const Text("Home Page"),
          actions: [
            CupertinoButton(
              child: const Icon(Icons.logout_outlined),
              onPressed: () {
                FirebaseAuthHelper.firebaseAuthHelper.logOutUser();
                Navigator.of(context).pushReplacementNamed('/');
              },
            ),
          ],
        ),
        body: StreamBuilder(
          stream: FireStoreHelper.fireStoreHelper.getContactList(uid: user.uid),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text("ERROR: ${snapshot.error}"),
              );
            } else if (snapshot.hasData) {
              DocumentSnapshot<Map<String, dynamic>>? snaps = snapshot.data;

              Map data = snaps?.data() as Map;

              List contacts = data['contact'] ?? [];

              return contacts.isNotEmpty
                  ? ListView.builder(
                      itemCount: contacts.length,
                      itemBuilder: (ctx, index) {
                        return StreamBuilder(
                            stream: FireStoreHelper.fireStoreHelper.getUserById(uid: contacts[index]),
                            builder: (context, userSnap) {
                              if (userSnap.hasData) {
                                DocumentSnapshot? docs = userSnap.data;

                                UserModel userModel = UserModel.formMap(data: docs!.data() as Map);

                                return ListTile(
                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                      'chat_page',
                                      arguments: userModel,
                                    );
                                  },
                                  leading: CircleAvatar(
                                    foregroundImage: NetworkImage(
                                      userModel.profilepic,
                                    ),
                                  ),
                                  title: Text(userModel.userName),
                                );
                              } else {
                                return const ListTile(
                                  leading: CircleAvatar(
                                    foregroundImage: NetworkImage(
                                      "https://static.vecteezy.com/system/resources/previews/005/544/718/non_2x/profile-icon-design-free-vector.jpg",
                                    ),
                                  ),
                                  title: Text("Loading..."),
                                );
                              }
                            });
                      },
                    )
                  : Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text("No contacts yet..."),
                          ElevatedButton.icon(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text("Add friend"),
                                  content: SizedBox(
                                    height: 300,
                                    child: StreamBuilder(
                                      stream: FireStoreHelper.fireStoreHelper.getUserData(),
                                      builder: (context, snapshot2) {
                                        if (snapshot2.hasData) {
                                          QuerySnapshot? snap = snapshot2.data;

                                          List<QueryDocumentSnapshot> allData = snap!.docs;

                                          List<UserModel> allUsers = allData
                                              .map(
                                                (e) => UserModel.formMap(data: e.data() as Map),
                                              )
                                              .toList();

                                          allUsers.removeWhere((element) => element.uid == user.uid);
                                          return ListView.separated(
                                            itemCount: allUsers.length,
                                            itemBuilder: (cyx, index) {
                                              UserModel member = allUsers[index];
                                              return ListTile(
                                                onTap: () {
                                                  FireStoreHelper.fireStoreHelper
                                                      .addContact(sender: user.uid, receiver: member.uid)
                                                      .then(
                                                        (value) => Navigator.of(context).pop(),
                                                      );
                                                },
                                                title: Text(member.userName),
                                                leading: CircleAvatar(
                                                  foregroundImage: NetworkImage(member.profilepic),
                                                ),
                                              );
                                            },
                                            separatorBuilder: (ctx, index) => const Divider(),
                                          );
                                        } else {
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.add),
                            label: const Text("Add friend"),
                          )
                        ],
                      ),
                    );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
