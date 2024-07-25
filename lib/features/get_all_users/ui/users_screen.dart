import 'package:cart_bloc/components/my_list_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text(
          "Family Members",
          style: TextStyle(color: Colors.white),
        ),
        // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        backgroundColor: const Color(0xff974E19),
        centerTitle: true,
        elevation: 0,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("Users").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text("There is no users"),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 20,
                ),

                // child: MyListTile(

                //   titleText: snapshot.data!.docs[index]['userName'],
                //   subText: snapshot.data!.docs[index]['email'],
                // ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.brown.shade300,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: snapshot
                                  .data!.docs[index]['imageUrl']?.isNotEmpty ??
                              false
                          ? NetworkImage(snapshot.data!.docs[index]['imageUrl'])
                          : null,
                      child: snapshot.data!.docs[index]['imageUrl']?.isEmpty ??
                              true
                          ? const Icon(Icons.person)
                          : null,
                    ),
                    title: Text(
                      snapshot.data!.docs[index]['userName'],
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      snapshot.data!.docs[index]['email'],
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
