import 'package:flutter/material.dart';
import 'package:tiktok_clone/constants.dart';
import 'package:tiktok_clone/views/screens/auth/login_screen.dart';
import 'package:tiktok_clone/views/widgets/text_input_field.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({Key? key}) : super(key: key);

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('UriTok',
                style: TextStyle(
                    fontSize: 35,
                    color: buttonColor,
                    fontWeight: FontWeight.w900)),
            const Text('Register',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700)),
            const SizedBox(height: 15),
            Stack(
              children: [
                const CircleAvatar(
                  radius: 64,
                  backgroundImage: NetworkImage(
                      'https://cdn-icons-png.flaticon.com/512/149/149071.png'),
                  backgroundColor: Colors.black,
                ),
                Positioned(
                    bottom: -10,
                    right: 0,
                    child: IconButton(
                      icon: const Icon(Icons.camera_alt),
                      onPressed: authController.pickImage,
                    ))
              ],
            ),
            const SizedBox(height: 15),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: TextInputField(
                controller: _usernameController,
                icon: Icons.person,
                label: 'Username',
              ),
            ),
            const SizedBox(height: 25),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: TextInputField(
                controller: _emailController,
                icon: Icons.email,
                label: 'Email',
              ),
            ),
            const SizedBox(height: 25),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: TextInputField(
                controller: _passwordController,
                icon: Icons.lock,
                isObscure: true,
                label: 'Password',
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: MediaQuery.of(context).size.width * .9,
              height: 50,
              child: Material(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                color: buttonColor,
                child: InkWell(
                  onTap: () {
                    final username = _usernameController.text;
                    final email = _emailController.text;
                    final password = _passwordController.text;

                    authController.registerUser(
                        username, email, password, authController.pickedImage);
                  },
                  child: const Center(
                    child: Text('Register',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LoginScreen(),
                  )),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already have an account? ',
                      style: TextStyle(
                        fontSize: 18,
                      )),
                  Text('Login',
                      style: TextStyle(fontSize: 18, color: buttonColor)),
                ],
              ),
            )
          ],
        ),
      )),
    );
  }
}
