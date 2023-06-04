import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/resources/auth_methods.dart';
import 'package:instagram_clone/screeen/login_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:instagram_clone/widgets/text_field_input.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController emailControler = TextEditingController();
  final TextEditingController passwordControler = TextEditingController();
  final TextEditingController bioControler = TextEditingController();
  final TextEditingController userControler = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailControler.dispose();
    passwordControler.dispose();
    bioControler.dispose();
    userControler.dispose();
  }

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
      //  _isLoading=true;
    });
  }

  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().signUp(
      username: userControler.text,
      password: passwordControler.text,
      email: emailControler.text,
      bio: bioControler.text,
      file: _image!,
    );
    if (res != "success") {
      showSnackBar(res, context);
    } else {
      navigateToLogin();
    }
  }
  void navigateToLogin() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const LoginScreen()));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            // child :SingleChildScrollView(
            child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                width: double.infinity,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(flex: 2, child: Container()),
                      SvgPicture.asset(
                        "assets/images/ic_instagram.svg",
                        color: primaryColor,
                        height: 64,
                      ),
                      //svg image
                      const SizedBox(
                        height: 10,
                      ),
                      Stack(
                        children: [
                          const SizedBox(height: 20),
                          const SizedBox(height: 30),
                          _image != null
                              ? CircleAvatar(
                                  radius: 64,
                                  backgroundImage: MemoryImage(_image!),
                                )
                              : const CircleAvatar(
                                  radius: 64,
                                  backgroundImage: NetworkImage(
                                      'https://i.stack.imgur.com/l60Hf.png'),
                                ),
                          Positioned(
                            bottom: -10,
                            left: 80,
                            child: IconButton(
                              onPressed: selectImage,
                              icon: const Icon(
                                Icons.add_a_photo,
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 20),
                      TextFieldInput(
                        hintText: "Enter your username",
                        textInputType: TextInputType.text,
                        textEditingController: userControler,
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      TextFieldInput(
                        hintText: "Enter your email address",
                        textInputType: TextInputType.emailAddress,
                        textEditingController: emailControler,
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      TextFieldInput(
                        hintText: "Enter your password ",
                        isPass: true,
                        textInputType: TextInputType.text,
                        textEditingController: passwordControler,
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      TextFieldInput(
                        hintText: "Enter your bio for profile",
                        textInputType: TextInputType.text,
                        textEditingController: bioControler,
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      InkWell(
                        onTap: signUpUser ,
                        onDoubleTap: navigateToLogin,
                        child: Container(
                          width: double.infinity,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: const ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                            ),
                            color: blueColor,
                          ),
                          child: _isLoading
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: primaryColor,
                                  ),
                                )
                              : const Text('Sign Up'),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                     Flexible(flex: 1, child: Container()),
                       /*Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: navigateToLogin  ,
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: const Text(
                                    "DoubleClick the above button or click here to login",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),*/
                    ])))
        // )
        );
  }
}
