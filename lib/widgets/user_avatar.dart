import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      return Padding(
        padding: const EdgeInsets.only(right: 10.0),
        child: GestureDetector(
          onTap: () async {
            // Show a dialog or menu for logout
            final shouldLogout = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Logout'),
                content: const Text('Do you want to log out?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('Logout'),
                  ),
                ],
              ),
            );

            if (shouldLogout ?? false) {
              await FirebaseAuth.instance.signOut();
              await GoogleSignIn().signOut();
              Navigator.of(context).pushReplacementNamed('/login');
            }
          },
          child: CircleAvatar(
            radius: 25,
            backgroundImage: user.photoURL != null
                ? NetworkImage(user.photoURL!)
                : const AssetImage('assets/default_avatar.png')
                    as ImageProvider,
            backgroundColor: Colors.grey[300],
          ),
        ),
      );
    } else {
      return const SizedBox();
    }
  }
}
