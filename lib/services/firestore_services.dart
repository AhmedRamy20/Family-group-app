import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FireStoreServices {
  User? user = FirebaseAuth.instance.currentUser;

  CollectionReference posts = FirebaseFirestore.instance.collection("Posts");

  //! add the post
  Future<void> addPost(String post) {
    return posts.add({
      'postMessage': post,
      'userEmail': user!.email,
      'timeStamps': Timestamp.now(),
    });
  }

  //! read the posts
  Stream<QuerySnapshot<Map<String, dynamic>>> readPosts() {
    final postsStram = FirebaseFirestore.instance
        .collection("Posts")
        .orderBy('timeStamps', descending: false)
        .snapshots();

    return postsStram;
  }

  //! update the post msg

  Future<void> updatePost(String updatedPost, String docId) {
    return posts.doc(docId).update({
      'postMessage': updatedPost,
      'timeStamps': Timestamp.now(),
    });
  }
}
