import 'package:flutter/material.dart';

class ListTitles extends StatelessWidget {
  final String title;

  const ListTitles({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 40,top: 20,bottom: 20),
      child: Text(
              title,
              style: const TextStyle(fontSize: 20, color: Colors.white),
            ),
    );
  }
}
