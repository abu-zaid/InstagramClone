import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_flutter/resources/auth_methods.dart';
import 'package:instagram_flutter/utils/utils.dart.dart';
import '../utils/colors.dart';
import '../widgets/text_field_input.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  Uint8List? _image;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  get primaryColor => null;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
  }

  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().signUpUser(
      email: _emailController.text,
      username: _usernameController.text,
      bio: _bioController.text,
      password: _passwordController.text,
      file: _image!,
    );
    setState(() {
      _isLoading = false;
    });
    if (res != 'success') {
      showSnackBar(res, context);
    }
  }

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Container(),
                flex: 2,
              ),
              //SVG Image
              SvgPicture.asset(
                'lib/assets/ic_instagram.svg',
                color: Colors.white,
                height: 64,
              ),
              const SizedBox(
                height: 32,
              ),

              Stack(
                children: [
                  _image != null
                      ? CircleAvatar(
                          radius: 64,
                          backgroundImage: MemoryImage(_image!),
                        )
                      : const CircleAvatar(
                          radius: 64,
                          backgroundImage: NetworkImage(
                              'https://i.pinimg.com/550x/2b/93/d8/2b93d8b64d3350b1151ac2ef05e89702.jpg'),
                        ),
                  Positioned(
                    bottom: -10,
                    left: 80,
                    child: IconButton(
                      onPressed: selectImage,
                      icon: const Icon(
                        Icons.add_a_photo_rounded,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 64,
              ),

              //Username Field
              TextFieldInput(
                hintText: "Enter Username",
                textEditingController: _usernameController,
                textInputType: TextInputType.text,
              ),

              const SizedBox(
                height: 32,
              ),

              //Bio Field

              TextFieldInput(
                hintText: "Enter Bio",
                textEditingController: _bioController,
                textInputType: TextInputType.text,
              ),

              const SizedBox(
                height: 32,
              ),

              //TrxtFieldEmail
              TextFieldInput(
                  hintText: "Enter Email",
                  textEditingController: _emailController,
                  textInputType: TextInputType.emailAddress),

              const SizedBox(
                height: 32,
              ),
              //TextFielPassword
              TextFieldInput(
                hintText: "Enter Password",
                textEditingController: _passwordController,
                textInputType: TextInputType.text,
                isPass: true,
              ),

              const SizedBox(
                height: 32,
              ),
              //LoginButton
              InkWell(
                onTap: signUpUser,
                child: Container(
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                      : const Text("Sign Up"),
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(4),
                      ),
                    ),
                    color: blueColor,
                  ),
                ),
              ),
              Flexible(
                child: Container(),
                flex: 2,
              ),
              //SignUp

              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Container(
              //       child: const Text("Don't have an account yet?"),
              //       padding: const EdgeInsets.symmetric(vertical: 8),
              //     ),
              //     GestureDetector(
              //       onTap: () {},
              //       child: Container(
              //         child: const Text(
              //           "Sign Up!",
              //           style: TextStyle(fontWeight: FontWeight.bold),
              //         ),
              //         padding: const EdgeInsets.symmetric(vertical: 8),
              //       ),
              //     ),
              //   ],
              // )
            ],
          ),
        ),
      ),
    );
  }
}
