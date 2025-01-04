import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:ui';

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
            // Show a dialog with fade-in animation and blur effect
            final shouldLogout = await showGeneralDialog<bool>(
              context: context,
              barrierDismissible: true,
              barrierLabel: "Dismiss",
              transitionBuilder:
                  (context, animation, secondaryAnimation, child) {
                const begin = Offset(0.0, 0.2);
                const end = Offset.zero; // End at the center
                const curve = Curves.easeInOut;
                var tween = Tween(begin: begin, end: end)
                    .chain(CurveTween(curve: curve));
                var offsetAnimation = animation.drive(tween);

                // Fade-in effect for dialog
                var opacityTween = Tween(begin: 0.0, end: 1.0);
                var opacityAnimation = animation.drive(opacityTween);

                return FadeTransition(
                  opacity: opacityAnimation,
                  child:
                      SlideTransition(position: offsetAnimation, child: child),
                );
              },
              pageBuilder: (context, animation, secondaryAnimation) {
                return BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 5.0,
                    sigmaY: 10.0,
                  ), // Apply blur
                  child: AlertDialog(
                    backgroundColor: Colors.black,
                    shadowColor: Colors.white12,
                    elevation: 80,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(15), // Small border radius
                      side:
                          BorderSide(color: Colors.white12, width: 1), // Border
                    ),
                    title: Text('Logout',
                        style: GoogleFonts.poppins(color: Colors.white)),
                    content: Text('Do you want to log out?',
                        style: GoogleFonts.poppins(color: Colors.white)),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: Text('Cancel',
                            style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.w600)),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(12), // Border radius
                          ),
                        ),
                        onPressed: () => Navigator.of(context).pop(true),
                        child: Text('Logout',
                            style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                );
              },
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
