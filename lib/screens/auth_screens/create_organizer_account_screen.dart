import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shaghaf/constants/constants.dart';
import 'package:shaghaf/extensions/screen_nav.dart';
import 'package:shaghaf/extensions/screen_size.dart';
import 'package:shaghaf/screens/auth_screens/bloc/auth_bloc.dart';
import 'package:shaghaf/screens/auth_screens/login_screen.dart';
import 'package:shaghaf/screens/auth_screens/otp_screen.dart';
import 'package:shaghaf/widgets/buttons/auth_text_button.dart';
import 'package:shaghaf/widgets/buttons/main_button.dart';
import 'package:shaghaf/widgets/dialogs/error_dialog.dart';
import 'package:shaghaf/widgets/text_fields/auth_field.dart';

class CreateOrganizerAccountScreen extends StatelessWidget {
  const CreateOrganizerAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>(); // key to validate form
    TextEditingController nameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController contactNumberController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    File? image;
    return BlocProvider(
      create: (context) => AuthBloc(),
      child: Builder(builder: (context) {
        final bloc = context.read<AuthBloc>();
        return BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is ErrorState) {
              context.pop();
              showDialog(
                  context: context,
                  builder: (context) => ErrorDialog(msg: state.msg));
            }
            if (state is LoadingState) {
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) => const Center(
                      child: CircularProgressIndicator(
                          color: Constants.mainOrange)));
            }
            if (state is SuccessState) {
              context.pop();
              context.pushReplacement(
                  screen: OtpScreen(
                      email: emailController.text,
                      role: 'organizer',
                      name: nameController.text,
                      image: image,
                      contactNumber: contactNumberController.text,
                      description: descriptionController.text,
                      licenseNumber: 'asdf'));
            }
          },
          child: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: Scaffold(
                body: SingleChildScrollView(
              child: Container(
                width: context.getWidth(),
                height: context.getHeight(),
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/auth_bg.png'),
                        fit: BoxFit.cover)),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // logo
                      Container(
                          padding: const EdgeInsets.only(top: 61, left: 92),
                          child: Image.asset('assets/images/logo.png')),
                      // form
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 44),
                        child: Container(
                          width: context.getWidth(),
                          decoration: BoxDecoration(
                              color: const Color(0xC9D9D9D9),
                              borderRadius: BorderRadius.circular(20)),
                          child: Form(
                            key: formKey,
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  AuthField(
                                      type: 'Name', controller: nameController),
                                  const SizedBox(height: 10),
                                  AuthField(
                                      type: 'Email',
                                      controller: emailController),
                                  const SizedBox(height: 10),
                                  AuthField(
                                      type: 'Password',
                                      controller: passwordController),
                                  const SizedBox(height: 10),
                                  AuthField(
                                      type: 'Contact Number',
                                      controller: contactNumberController),
                                  const SizedBox(height: 10),
                                  AuthField(
                                      type: 'Photo (optional)',
                                      onUploadImg: () async {
                                        // Pick image from gallery
                                        final photoAsFile = await ImagePicker()
                                            .pickImage(
                                                source: ImageSource.gallery);
                                        if (photoAsFile != null) {
                                          image = File(photoAsFile.path);
                                          String fileName =
                                              image!.path.split('/').last;
                                          log("img name: $fileName");
                                        
                                        } else {
                                          log('No image selected');
                                        }
                                      }),
                                  const SizedBox(height: 20),
                                  AuthField(
                                    type: 'Description',
                                    controller: descriptionController,
                                  ),
                                  const SizedBox(height: 20),
                                  MainButton(
                                    text: "Sign Up",
                                    width: context.getWidth(),
                                    onPressed: () {
                                      if (formKey.currentState!.validate()) {
                                        log("valid");
                                        bloc.add(CreateAccountEvent(
                                            email: emailController.text,
                                            password: passwordController.text));
                                      } else {
                                        log("invalid");
                                      }
                                    },
                                  ),
                                  const SizedBox(height: 4),
                                  AuthTextButton(
                                      text: "I Already have an account",
                                      onPressed: () => context.pushReplacement(
                                          screen: const LoginScreen()))
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                    ],
                  ),
                ),
              ),
            )),
          ),
        );
      }),
    );
  }
}
