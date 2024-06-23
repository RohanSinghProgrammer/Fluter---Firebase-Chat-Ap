import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  UserTile({super.key, required this.text, required this.onTap});

  final String? text;
  void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
        color: Colors.grey[100],
        child: Row(children: [
          const Icon(
            Icons.person,
            size: 28,
          ),
          const SizedBox(width: 16),
          Text(
            text ?? "User",
            style: const TextStyle(fontSize: 16),
          ),
        ]),
      ),
    );
  }
}
