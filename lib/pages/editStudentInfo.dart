import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:swaptech2/database/database.dart';

class EditStudentProfile extends StatefulWidget {
  String name = '';
  String suid = '';
  String? specialization;
  String? targetSpecialization;
  EditStudentProfile(
      {super.key,
      required this.name,
      required this.suid,
      required this.specialization,
      required this.targetSpecialization});

  @override
  State<EditStudentProfile> createState() => _EditStudentProfileState();
}

class _EditStudentProfileState extends State<EditStudentProfile> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool matchedSpecializations = false;
  String? updatedSpecialization;
  String? updatedTargetSpecialization;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _suidController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.name;
    _suidController.text = widget.suid;
    if (widget.specialization == widget.targetSpecialization) {
      matchedSpecializations = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Database>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.black,
              ),
            ),
          ],
          centerTitle: true,
          title: Text(
            "تعديل الملف الشخصي",
            textAlign: TextAlign.center,
            style: GoogleFonts.tajawal(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    matchedSpecializations
                        ? Column(
                            children: [
                              Text(
                                "👋  بالتوفيق فالتخصص الجديد",
                                style: GoogleFonts.tajawal(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[900],
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                            ],
                          )
                        : Container(),
                    Directionality(
                      textDirection: TextDirection.rtl,
                      child: TextFormField(
                        style: GoogleFonts.tajawal(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        controller: _nameController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "ادخل اسم الطالب";
                          }
                          if (double.parse(value).isNaN) {
                            return "ادخل اسم الطالب";
                          }

                          return null;
                        },
                        textDirection: TextDirection.rtl,
                        decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.blue[900]!,
                                width: 3.0,
                              ),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(8),
                              ),
                            ),
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                            ),
                            label: Text("أسم الطالب",
                                style: GoogleFonts.tajawal()),
                            labelStyle: GoogleFonts.tajawal(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Directionality(
                      textDirection: TextDirection.rtl,
                      child: TextFormField(
                        style: GoogleFonts.tajawal(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        controller: _suidController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "أدخل رقم القيد";
                          }
                          return null;
                        },
                        textDirection: TextDirection.rtl,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blue[900]!,
                              width: 3.0,
                            ),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(8),
                            ),
                          ),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                          ),
                          label: Text("رقم القيد"),
                          labelStyle: GoogleFonts.tajawal(
                            fontSize: 16,
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
                        value: widget.specialization,
                        items: [
                          DropdownMenuItem(
                            alignment: Alignment.centerRight,
                            value: "برمجة",
                            child: Text(
                              "برمجة",
                              textDirection: TextDirection.rtl,
                              style: GoogleFonts.tajawal(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                          DropdownMenuItem(
                            alignment: Alignment.centerRight,
                            value: "شبكات",
                            child: Text(
                              "شبكات",
                              textDirection: TextDirection.rtl,
                              style: GoogleFonts.tajawal(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                          DropdownMenuItem(
                            alignment: Alignment.centerRight,
                            value: "تحكم",
                            child: Text(
                              "تحكم",
                              textDirection: TextDirection.rtl,
                              style: GoogleFonts.tajawal(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                        onChanged: matchedSpecializations
                            ? null
                            : (newValue) {
                                if (updatedTargetSpecialization != null) {
                                  if (newValue == updatedTargetSpecialization) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        behavior: SnackBarBehavior.floating,
                                        padding: const EdgeInsets.all(15),
                                        content: Center(
                                          child: Text(
                                            "لا يمكن تحديد نفس التخصص المطلوب",
                                            style: GoogleFonts.tajawal(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        backgroundColor: Colors.red[900],
                                      ),
                                    );
                                    _formKey.currentState!.reset();
                                  } else if (newValue !=
                                      widget.specialization) {
                                    setState(() {
                                      updatedSpecialization =
                                          newValue.toString();
                                    });
                                  }
                                } else {
                                  if (newValue == widget.targetSpecialization) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        behavior: SnackBarBehavior.floating,
                                        padding: const EdgeInsets.all(15),
                                        content: Center(
                                          child: Text(
                                            "لا يمكن تحديد نفس التخصص المطلوب",
                                            style: GoogleFonts.tajawal(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        backgroundColor: Colors.red[900],
                                      ),
                                    );
                                    _formKey.currentState!.reset();
                                  } else if (newValue !=
                                      widget.specialization) {
                                    setState(() {
                                      updatedSpecialization =
                                          newValue.toString();
                                    });
                                  }
                                }
                              },
                        validator: (value) {
                          if (updatedSpecialization ==
                              widget.targetSpecialization) {
                            return '';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blue[900]!,
                              width: 3.0,
                            ),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(8),
                            ),
                          ),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                          ),
                          label: Text("التخصص الحالي",
                              style: GoogleFonts.tajawal()),
                          labelStyle: GoogleFonts.tajawal(
                            fontSize: 16,
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
                        isDense: true,
                        autovalidateMode: AutovalidateMode.onUnfocus,
                        value: widget.targetSpecialization,
                        items: [
                          DropdownMenuItem(
                            alignment: Alignment.centerRight,
                            value: "برمجة",
                            child: Text(
                              "برمجة",
                              textDirection: TextDirection.rtl,
                              style: GoogleFonts.tajawal(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                          DropdownMenuItem(
                            alignment: Alignment.centerRight,
                            value: "شبكات",
                            child: Text(
                              "شبكات",
                              textDirection: TextDirection.rtl,
                              style: GoogleFonts.tajawal(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                          DropdownMenuItem(
                            alignment: Alignment.centerRight,
                            value: "تحكم",
                            child: Text(
                              "تحكم",
                              textDirection: TextDirection.rtl,
                              style: GoogleFonts.tajawal(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                        onChanged: matchedSpecializations
                            ? null
                            : (newValue) {
                                if (updatedSpecialization != null) {
                                  if (newValue == updatedSpecialization) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        behavior: SnackBarBehavior.floating,
                                        padding: const EdgeInsets.all(15),
                                        content: Center(
                                          child: Text(
                                            "لا يمكن تحديد نفس التخصص الحالي",
                                            style: GoogleFonts.tajawal(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        backgroundColor: Colors.red[900],
                                      ),
                                    );
                                    _formKey.currentState!.reset();
                                  } else if (newValue !=
                                      widget.targetSpecialization) {
                                    setState(() {
                                      updatedTargetSpecialization =
                                          newValue.toString();
                                    });
                                  }
                                } else {
                                  if (newValue == widget.specialization) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        behavior: SnackBarBehavior.floating,
                                        padding: const EdgeInsets.all(15),
                                        content: Center(
                                          child: Text(
                                            "لا يمكن تحديد نفس التخصص الحالي",
                                            style: GoogleFonts.tajawal(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        backgroundColor: Colors.red[900],
                                      ),
                                    );
                                    _formKey.currentState!.reset();
                                  } else if (newValue !=
                                      widget.targetSpecialization) {
                                    setState(() {
                                      updatedTargetSpecialization =
                                          newValue.toString();
                                    });
                                  }
                                }
                              },
                        validator: (value) {
                          if (value == widget.specialization) {
                            return '';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blue[900]!,
                              width: 3.0,
                            ),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(8),
                            ),
                          ),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                          ),
                          label: Text("التخصص المطلوب",
                              style: GoogleFonts.tajawal()),
                          labelStyle: GoogleFonts.tajawal(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[900],
                        fixedSize: Size(
                          MediaQuery.of(context).size.width,
                          50,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () async {
                        try {
                          Connectivity connectivity = Connectivity();
                          var result = await connectivity.checkConnectivity();
                          if (result.first == ConnectivityResult.none) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                behavior: SnackBarBehavior.floating,
                                padding: const EdgeInsets.all(15),
                                content: Center(
                                  child: Text(
                                    "تحقق من اتصالك بالانترنت",
                                    style: GoogleFonts.tajawal(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                          bool hasChanges =
                              _nameController.text != widget.name ||
                                  _suidController.text != widget.suid ||
                                  (updatedSpecialization != null &&
                                      updatedSpecialization !=
                                          widget.specialization) ||
                                  (updatedTargetSpecialization != null &&
                                      updatedTargetSpecialization !=
                                          widget.targetSpecialization);

                          if (hasChanges) {
                            if (mounted) {
                              setState(() {
                                isLoading = true;
                              });
                            }
                            await Database().updateUser(
                              {
                                "name": _nameController.text,
                                "suid": _suidController.text,
                                "specialization": updatedSpecialization ??
                                    widget.specialization,
                                "neededspecialization":
                                    updatedTargetSpecialization ??
                                        widget.targetSpecialization,
                              },
                            ).timeout(const Duration(seconds: 10),
                                onTimeout: () {
                              throw TimeoutException("");
                            });
                            if (_suidController.text != widget.suid) {
                              Database().updateSuidInSwaps(
                                  _suidController.text, widget.suid);
                            }
                            if (mounted) {
                              setState(() {
                                isLoading = false;
                              });
                            }
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                behavior: SnackBarBehavior.floating,
                                padding: const EdgeInsets.all(15),
                                content: Center(
                                  child: Text(
                                    "تم تعديل المعلومات بنجاح",
                                    style: GoogleFonts.tajawal(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                backgroundColor: Colors.green,
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                behavior: SnackBarBehavior.floating,
                                padding: const EdgeInsets.all(15),
                                content: Center(
                                  child: Text(
                                    "الباين انك ماتحبش التغير   :)",
                                    textDirection: TextDirection.rtl,
                                    style: GoogleFonts.tajawal(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                backgroundColor: Colors.blue[900],
                              ),
                            );
                          }
                        } catch (e) {
                          setState(() {
                            isLoading = false;
                          });
                          _formKey.currentState!.reset();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              behavior: SnackBarBehavior.floating,
                              padding: const EdgeInsets.all(15),
                              content: Center(
                                child: Text(
                                  "حدث خطأ ما يرجى المحاولة لاحقاً",
                                  style: GoogleFonts.tajawal(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      child: isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3,
                            )
                          : Text(
                              "حفظ التعديلات",
                              style: GoogleFonts.tajawal(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
