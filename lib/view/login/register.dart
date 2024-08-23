import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  // Future<void> _register(BuildContext context) async {
  //   try {
  //     UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
  //       email: _emailController.text,
  //       password: _passwordController.text,
  //     );

  //     User? user = userCredential.user;
  //     await _firestore.collection('users').doc(user?.uid).set({
  //       'email': _emailController.text,
  //       'name': _nameController.text,
  //       'phone': _phoneController.text,
  //       'balance': 1000000,
  //       'attendance': [], // Adding the attendance field as an empty array
  //     });

  //     Navigator.pushAndRemoveUntil(
  //       context,
  //       MaterialPageRoute(builder: (context) => const MainPage()),
  //           (Route<dynamic> route) => false,
  //     );
  //   } on FirebaseAuthException catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text(e.message ?? '회원가입 실패')),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('회원가입')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 50),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '이름을 입력하세요',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '전화번호를 입력하세요',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '이메일을 입력하세요',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '비밀번호를 입력하세요',
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('회원가입'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
