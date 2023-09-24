import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddEmployeeController extends GetxController {
  TextEditingController nomorPegawaiController = TextEditingController();
  TextEditingController namaController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  //TODO: Implement AddEmployeeController
  void addEmployee() async {
    if (nomorPegawaiController.text.isNotEmpty &&
        namaController.text.isNotEmpty &&
        emailController.text.isNotEmpty) {
      try {
        UserCredential userCredential =
            await auth.createUserWithEmailAndPassword(
          email: emailController.text,
          password: '2ndChance',
        );
        if (userCredential.user != null) {
          String uid = userCredential.user!.uid;
          await firestore.collection('employees').doc(uid).set({
            'nomorPegawai': nomorPegawaiController.text,
            'nama': namaController.text,
            'email': emailController.text,
            'uid': uid,
            'createdAt': DateTime.now().toIso8601String(),
          });
        }
        print(userCredential);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          Get.snackbar('Perhatian', 'Password terlalu lemah');
        } else if (e.code == 'email-already-in-use') {
          Get.snackbar('Perhatian', 'Email sudah terdaftar');
        }
      } catch (e) {
        print(e);
      }
    } else {
      Get.snackbar('Pemberitahuan', 'Data tidak boleh kosong');
    }
  }
}
