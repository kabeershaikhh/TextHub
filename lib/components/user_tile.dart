import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  final  String text;
  final void Function()? onTap;
  const UserTile({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
         children: [
           // icon
          Icon(Icons.person),

           const SizedBox(width: 20,),

           // user name
           Text(text),
         ],
        ),
      ),
    );
  }
}
