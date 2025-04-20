import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swaptech2/auth/sign_in.dart';
import 'package:swaptech2/auth/sign_up.dart';

class auth extends StatefulWidget {
  const auth({super.key});

  @override
  State<auth> createState() => _authState();
}

class _authState extends State<auth> {
  String _connectionStatus = 'Unknown';
  bool _signInScreen = true;

  toogleBetween() {
    setState(() {
      _signInScreen = !_signInScreen;
    });
  }

  void initState() {
    super.initState();
    _checkConnection();
  }

  Future<void> _checkConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    _updateConnectionStatus(connectivityResult.first);
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    if (mounted) {
      setState(() {
        if (result == ConnectivityResult.mobile) {
          _connectionStatus = 'Mobile';
        } else if (result == ConnectivityResult.wifi) {
          _connectionStatus = 'WiFi';
        } else {
          _connectionStatus = 'No Connection';
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_connectionStatus == 'Unknown') {
      return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          body: const Center(
            child: CircularProgressIndicator(),
          ));
    } else if (_connectionStatus == "No Connection") {
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "No Network Connection",
                style: GoogleFonts.bebasNeue(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.04),
                child: ElevatedButton(
                    style: ButtonStyle(
                      minimumSize:
                          MaterialStateProperty.all<Size>(Size(200, 50)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    onPressed: _checkConnection,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.refresh,
                          color: Colors.black,
                          size: 35,
                        ),
                        Text(
                          "Retry",
                          style: GoogleFonts.bebasNeue(
                              fontSize: 35, color: Colors.black),
                        ),
                      ],
                    )),
              ),
            ],
          ),
        ),
      );
    } else {
      if (_signInScreen) {
        return signIn(toggleBetween: toogleBetween);
      } else {
        return signUp(
          toggleBetween: toogleBetween,
        );
      }
    }
  }
}
