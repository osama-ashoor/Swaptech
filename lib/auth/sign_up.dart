import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swaptech2/auth/AuthService.dart';
import 'package:swaptech2/database/database.dart';
import 'package:swaptech2/handling%20notifications/notification.dart';

class signUp extends StatefulWidget {
  final Function toggleBetween;
  const signUp({super.key, required this.toggleBetween});

  @override
  State<signUp> createState() => _signUpState();
}

class _signUpState extends State<signUp> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();
  String name = "";
  String id = "";
  String email = "";
  String password = "";
  String confirmpassword = "";
  String? currentSpecialization;
  String? targetSpecialization;
  bool isLoading = false;
  bool _showPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          "تـسـجيـل حـسـاب جـديـد",
          style: GoogleFonts.tajawal(
              fontSize: 22, color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50.0),
          child: Form(
            key: _formKey,
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
                    style: GoogleFonts.tajawal(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
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
                      labelText: "الأسم",
                      labelStyle: GoogleFonts.tajawal(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "ادخل الاسم";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      name = value!;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: TextFormField(
                    style: GoogleFonts.tajawal(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
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
                      labelText: "رقم القيد",
                      labelStyle: GoogleFonts.tajawal(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "ادخل رقم القيد";
                      }

                      return null;
                    },
                    onSaved: (value) {
                      id = value!;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: TextFormField(
                    style: GoogleFonts.tajawal(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
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
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء ادخال البريد الإلكتروني';
                      } else if (!(value.endsWith('.com'))) {
                        return 'الرجاء ادخال بريد الكتروني صحيح';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      email = value!;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: TextFormField(
                    style: GoogleFonts.tajawal(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
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
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
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
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: TextFormField(
                    style: GoogleFonts.tajawal(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
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
                      labelText: "تأكيد كلمة السر",
                      labelStyle: GoogleFonts.tajawal(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
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
                        return 'الرجاء قم بأعادة كلمة السر';
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value) {
                      confirmpassword = value!;
                    },
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: DropdownButtonFormField(
                    items: [
                      DropdownMenuItem(
                        alignment: Alignment.centerRight,
                        value: "برمجة",
                        child: Text(
                          "برمجة",
                          textDirection: TextDirection.rtl,
                          style: GoogleFonts.tajawal(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      DropdownMenuItem(
                        alignment: Alignment.centerRight,
                        value: "شبكات",
                        child: Text(
                          "شبكات",
                          textDirection: TextDirection.rtl,
                          style: GoogleFonts.tajawal(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      DropdownMenuItem(
                        alignment: Alignment.centerRight,
                        value: "تحكم",
                        child: Text(
                          "تحكم",
                          textDirection: TextDirection.rtl,
                          style: GoogleFonts.tajawal(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                    onChanged: (newValue) {
                      setState(() {
                        currentSpecialization = newValue.toString();
                      });
                    },
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blue[900]!,
                          width: 3.0,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(12),
                        ),
                      ),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(12),
                        ),
                      ),
                      label: Text(
                        "تخصصك الحالي",
                        style: GoogleFonts.tajawal(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      labelStyle: GoogleFonts.tajawal(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: DropdownButtonFormField(
                    items: [
                      DropdownMenuItem(
                        alignment: Alignment.centerRight,
                        value: "برمجة",
                        child: Text(
                          "برمجة",
                          textDirection: TextDirection.rtl,
                          style: GoogleFonts.tajawal(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      DropdownMenuItem(
                        alignment: Alignment.centerRight,
                        value: "شبكات",
                        child: Text(
                          "شبكات",
                          textDirection: TextDirection.rtl,
                          style: GoogleFonts.tajawal(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      DropdownMenuItem(
                        alignment: Alignment.centerRight,
                        value: "تحكم",
                        child: Text(
                          "تحكم",
                          textDirection: TextDirection.rtl,
                          style: GoogleFonts.tajawal(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                    onChanged: (newValue) {
                      setState(() {
                        targetSpecialization = newValue.toString();
                      });
                    },
                    decoration: InputDecoration(
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
                      label: Text(
                        "التخصص المطلوب",
                        style: GoogleFonts.tajawal(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      labelStyle: GoogleFonts.tajawal(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
                        'لديك حساب ؟',
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
                    : Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ElevatedButton(
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
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            )),
                          ),
                          child: Text(
                            "إنشاء حساب",
                            style: GoogleFonts.tajawal(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();

                              if (currentSpecialization != null &&
                                  targetSpecialization != null) {
                                if (currentSpecialization ==
                                    targetSpecialization) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      behavior: SnackBarBehavior.floating,
                                      padding: const EdgeInsets.all(15),
                                      content: Center(
                                        child: Text(
                                          "لا يمكن أن يكون التخصصين متطابقين",
                                          style: GoogleFonts.tajawal(
                                            fontSize: 14,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                  return;
                                }
                              }

                              if (confirmpassword == password) {
                                if (mounted) {
                                  setState(() {
                                    isLoading = true;
                                  });
                                }

                                String token =
                                    await HandlingNotification().getToken();
                                dynamic result = await _auth.signUp(
                                    email,
                                    password,
                                    name,
                                    id,
                                    currentSpecialization!,
                                    targetSpecialization!,
                                    token);

                                if (result is String) {
                                  if (mounted) {
                                    setState(() {
                                      isLoading = false;
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          behavior: SnackBarBehavior.floating,
                                          padding: const EdgeInsets.all(15),
                                          content: Center(
                                            child: Text(
                                              "رقم القيد مستخدم بالفعل",
                                              style: GoogleFonts.tajawal(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    });
                                  }
                                } else {
                                  if (mounted) {
                                    setState(() {
                                      isLoading = false;
                                    });
                                  }
                                }
                              } else {
                                if (mounted) {
                                  setState(() {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return Directionality(
                                          textDirection: TextDirection.rtl,
                                          child: AlertDialog(
                                            title: Text("خطأ في كلمة السر",
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.tajawal(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            content:
                                                Text("كلمة السر غير متطابقة",
                                                    textAlign: TextAlign.center,
                                                    style: GoogleFonts.tajawal(
                                                      fontSize: 16,
                                                    )),
                                            actions: <Widget>[
                                              TextButton(
                                                child: Text(
                                                  'حسنا',
                                                  style: GoogleFonts.tajawal(
                                                      fontSize: 16,
                                                      color: Colors.blue[900],
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                  _formKey.currentState!
                                                      .reset();
                                                },
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  });
                                }
                              }
                            }
                          },
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
