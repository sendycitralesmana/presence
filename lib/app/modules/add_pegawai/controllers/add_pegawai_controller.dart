import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class AddPegawaiController extends GetxController {
  late TextEditingController nipC;
  late TextEditingController namaC;
  late TextEditingController emailC;

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void addPegawai() async{
    if (nipC.text.isNotEmpty && namaC.text.isNotEmpty && emailC.text.isNotEmpty) {
      try {
        UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: emailC.text,
          password: "password",
        );

        if (userCredential.user != null) {
          String uid = userCredential.user!.uid;
          
          await firestore.collection("pegawai").doc(uid).set(
            {
              "nip" : nipC.text,
              "nama" : namaC.text,
              "email" : emailC.text,
              "uid" : uid,
              "createdAt" : DateTime.now(),
            }
          );
        } else {
          
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          Get.snackbar("Terjadi kesalahan", "Kata sandi yang diberikan terlalu lemah");
        } else if (e.code == 'email-already-in-use') {
          Get.snackbar("Terjadi kesalahan", "Akun sudah ada untuk email itu");
        }
      } catch (e) {
        Get.snackbar("Terjadi kesalahan", "Tidak dapat menambahkan pegawai");
      }
    } else {
      Get.snackbar("Terjadi kesalahan", "NIP, Nama, dan Email harus diisi");
    }
  }

  @override
  void onInit() {
    super.onInit();
    nipC = TextEditingController();
    namaC = TextEditingController();
    emailC = TextEditingController();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    nipC.dispose();
    namaC.dispose();
    emailC.dispose();
  }
}
