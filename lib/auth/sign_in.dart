import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swaptech2/auth/AuthService.dart';

class signIn extends StatefulWidget {
  final Function toggleBetween;
  const signIn({super.key, required this.toggleBetween});

  @override
  State<signIn> createState() => _signInState();
}

class _signInState extends State<signIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  bool isLoading = false;
  bool _showPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          elevation: 0.0,
          centerTitle: true,
          title: Text(
            "تـسـجيـل الـدخـول",
            style: GoogleFonts.tajawal(
                fontSize: 22, color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        body: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.swap_horiz_rounded,
                      size: 120,
                      color: Colors.blue[900],
                    ),
                    const SizedBox(height: 20),
                    Directionality(
                      textDirection: TextDirection.rtl,
                      child: TextFormField(
                        cursorColor: Colors.black,
                        style: GoogleFonts.tajawal(
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          errorStyle: GoogleFonts.tajawal(
                            color: Colors.red,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blue[900]!,
                              width: 3.0,
                            ),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(12),
                            ),
                          ),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(12),
                            ),
                          ),
                          labelText: "البريد الألكتروني",
                          labelStyle: GoogleFonts.tajawal(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'الرجاء أدخال بريدك الألكتروني';
                          } else if (!(value.trim().endsWith('.com'))) {
                            return 'الرجاء أدخال بريد الألكتروني صحيح';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          email = value!.trim();
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Directionality(
                      textDirection: TextDirection.rtl,
                      child: TextFormField(
                        cursorColor: Colors.black,
                        style: GoogleFonts.tajawal(
                          color: Colors.black,
                        ),
                        obscureText: _showPassword,
                        decoration: InputDecoration(
                          errorStyle: GoogleFonts.tajawal(
                            color: Colors.red,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blue[900]!,
                              width: 3.0,
                            ),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(12),
                            ),
                          ),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(12),
                            ),
                          ),
                          labelText: "كلمة السر",
                          labelStyle: GoogleFonts.tajawal(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                if (_showPassword) {
                                  _showPassword = false;
                                } else {
                                  _showPassword = true;
                                }
                              });
                            },
                            icon: Icon(
                              Icons.remove_red_eye_rounded,
                              size: 25,
                              color: _showPassword ? Colors.grey : Colors.black,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'الرجاء ادخال كلمة السر';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          password = value!;
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            widget.toggleBetween();
                          },
                          child: Text(
                            'تسجيل حساب جديد',
                            style: GoogleFonts.tajawal(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[900]),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    isLoading
                        ? CircularProgressIndicator(
                            color: Colors.blue[900],
                          )
                        : ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.blue[900]!,
                              ),
                              minimumSize: MaterialStateProperty.all<Size>(
                                Size(
                                  MediaQuery.of(context).size.width,
                                  50,
                                ),
                              ),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(9.0),
                              )),
                            ),
                            child: Text(
                              "تـسـجيـل الـدخـول",
                              style: GoogleFonts.tajawal(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                setState(() {
                                  isLoading = true;
                                });
                                dynamic result =
                                    await _auth.signIn(email, password);
                                if (result != null) {
                                  if (mounted) {
                                    setState(() {
                                      isLoading = false;
                                    });
                                  }
                                } else {
                                  setState(() {
                                    isLoading = false;
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      behavior: SnackBarBehavior.floating,
                                      padding: const EdgeInsets.all(15),
                                      content: Center(
                                        child: Text(
                                          "البريد الألكتروني او كلمة السر غير صحيحة",
                                          style: GoogleFonts.tajawal(
                                            fontSize: 14,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      backgroundColor: Colors.black,
                                    ),
                                  );
                                }
                              }
                            }),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
