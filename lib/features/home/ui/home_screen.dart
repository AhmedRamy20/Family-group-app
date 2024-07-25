import 'dart:ffi';

import 'package:cart_bloc/components/my_text_field.dart';
import 'package:cart_bloc/features/home/widgets/my_drawer.dart';
import 'package:cart_bloc/services/firestore_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FamHome extends StatefulWidget {
  const FamHome({super.key});

  @override
  State<FamHome> createState() => _FamHomeState();
}

class _FamHomeState extends State<FamHome> {
  final TextEditingController postController = TextEditingController();

  final FireStoreServices myDatabase = FireStoreServices();

  final User? currentUser = FirebaseAuth.instance.currentUser;

  void firePost() {
    if (postController.text.isNotEmpty) {
      myDatabase.addPost(postController.text);
    }

    postController.clear();
  }

  void updateThePost(String docId) {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController updatedPostController = TextEditingController();
        return AlertDialog(
          title: const Text("Update Post"),
          content: MyTextField(
            hint: "update with new message..",
            obSecure: false,
            controller: updatedPostController,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () {
                if (updatedPostController.text.isNotEmpty) {
                  myDatabase.updatePost(updatedPostController.text, docId);
                }
                Navigator.pop(context);
              },
              child: const Text(
                "Update",
                style: TextStyle(color: Colors.blueAccent),
              ),
            ),
          ],
        );
      },
    );
  }

  // Future<String> getUserName(String userEmail) async {
  //   final userDoc = await FirebaseFirestore.instance
  //       .collection("Users")
  //       .doc(userEmail)
  //       .get();
  //   return userDoc.data()?['userName'] ?? 'Unknown User';
  // }

  Future<Map<String, String>> getUserDetails(String userEmail) async {
    final userDoc = await FirebaseFirestore.instance
        .collection("Users")
        .doc(userEmail)
        .get();
    return {
      'userName': userDoc.data()?['userName'] ?? 'Unknown User',
      'imageUrl': userDoc.data()?['imageUrl'] ?? ''
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Family Messages",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
        // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        backgroundColor: const Color(0xff974E19),
        centerTitle: true,
        elevation: 0,
      ),
      drawer: const MyDrawer(),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 15,
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: MyTextField(
                    hint: "Post shit here..",
                    obSecure: false,
                    controller: postController,
                  ),
                ),
                Container(
                  // height: 50,
                  // width: 50,

                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 4,
                  ),
                  margin: const EdgeInsets.only(
                    left: 10,
                  ),
                  decoration: BoxDecoration(
                    // color: Theme.of(context).colorScheme.background,
                    color: const Color(0xff974E19),

                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: GestureDetector(
                    onTap: firePost,
                    child: const Icon(
                      Icons.done,
                      size: 25,
                      // color: Theme.of(context).colorScheme.inversePrimary,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            StreamBuilder(
              stream: myDatabase.readPosts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  );
                }
                final posts = snapshot.data!.docs;
                if (snapshot.data == null || posts.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 100),
                    child: Text("There is no posts ,post one.."),
                  );
                }

                return Expanded(
                  child: ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      final msg = posts[index]["postMessage"];
                      final userEmail = posts[index]["userEmail"];

                      final docId = posts[index].id;
                      // return MyListTile(
                      //   titleText: msg,
                      //   subText: userEmail,
                      // );

                      return FutureBuilder(
                        future: getUserDetails(userEmail),
                        builder: (context, userDetailsSnapshot) {
                          if (userDetailsSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.only(top: 45),
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                          // final userName =
                          //     userNameSnapshot.data ?? 'Unknown User';

                          final userDetails = userDetailsSnapshot.data ??
                              {'userName': 'Unknown User', 'imageUrl': ''};

                          return Padding(
                            padding: const EdgeInsets.only(
                              top: 15,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.brown.shade200,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                //   Text(user!['email'],),
                                // Text(user!['userName']),
                                isThreeLine: true,
                                leading: Container(
                                  height: 70,
                                  width: 50,
                                  child: CircleAvatar(
                                    backgroundImage: userDetails['imageUrl']
                                                ?.isNotEmpty ??
                                            false
                                        ? NetworkImage(userDetails['imageUrl']!)
                                        : null,
                                    child:
                                        userDetails['imageUrl']?.isEmpty ?? true
                                            ? const Icon(Icons.person)
                                            : null,
                                  ),
                                ),

                                // title: Text(
                                //   msg,
                                //   style: const TextStyle(
                                //     fontSize: 20,
                                //   ),
                                // ),
                                title: Text(
                                  userDetails['userName']!,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),

                                subtitle: Column(
                                  // mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Text(
                                    //   userDetails['userName']!,
                                    //   style: const TextStyle(
                                    //     fontSize: 15,
                                    //   ),
                                    // ),
                                    Text(
                                      msg,
                                      maxLines: null,
                                      style: const TextStyle(
                                        fontSize: 18,
                                      ),
                                      overflow: TextOverflow.visible,
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: IconButton(
                                          onPressed: () {
                                            updateThePost(docId);
                                          },
                                          icon: const Icon(
                                            Icons.edit,
                                            color: Colors.white,
                                          )),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
