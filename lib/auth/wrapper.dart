import 'package:flutter/material.dart';
import 'package:swaptech2/auth/AuthService.dart';
import 'package:swaptech2/auth/auth.dart';
import 'package:swaptech2/pages/mainApp.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AuthService().user,
      builder: (context, snapshot) {
        Widget child;

        if (snapshot.connectionState == ConnectionState.waiting) {
          child = Center(
            child: Container(),
          );
        } else if (snapshot.hasError) {
          child = Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else if (snapshot.data == null) {
          child = const auth();
        } else {
          child = const MainApp();
        }

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 600),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          child: child,
        );
      },
    );
  }
}
