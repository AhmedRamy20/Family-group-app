import 'package:flutter/material.dart';

class MyListTile extends StatelessWidget {
  final String titleText;
  final String subText;
  // bool edit = false;
  // void Function()? onPressed;

  MyListTile({
    super.key,
    required this.titleText,
    required this.subText,
    // required this.edit,
    // this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 15,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.brown.shade300,
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          //   Text(user!['email'],),
          // Text(user!['userName']),

          title: Text(
            titleText,
            style: TextStyle(
              fontSize: 20,
            ),
          ),

          subtitle: Text(
            subText,
            style: TextStyle(
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}
