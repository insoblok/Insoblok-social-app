import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:insoblok/widgets/widgets.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/routers/routers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/services/access_code_service.dart';

class EmailPage extends StatefulWidget {
  const EmailPage({super.key});

  @override
  State<EmailPage> createState() => EmailPageState();
}

class EmailPageState extends State<EmailPage> {
  final AccessCodeService accessCodeService = AccessCodeService();
  final GlobalStore _globalStore = GlobalStore();

  Future<void> handleClickNext(BuildContext ctx) async {
    final email = emailController.text.trim();
    if (!AIHelpers.isValidEmail(email)) {
      AIHelpers.showToast(msg: "Please enter valid email address.");
      return;
    }

    // Always save email for future use (even if password doesn't exist yet)
    final savedPassword = await _globalStore.getSavedPassword();
    if (savedPassword != null && savedPassword.isNotEmpty) {
      // If password exists, save both email and password
      await _globalStore.saveCredentials(
        email: email,
        password: savedPassword,
        enableAutoLogin: true,
      );
    } else {
      // If password doesn't exist yet (during signup), just save email
      // Password will be saved later in pincode_register_page
      final sp = await SharedPreferences.getInstance();
      await sp.setString('saved_email', email);
    }

    if (await accessCodeService.checkAccessCodeByEmail(email)) {
      Routers.goToLoginPage(ctx);
    } else {
      Routers.goToAccessCodeUserIdPage(ctx, email);
    }
  }

  TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSavedEmail();
  }

  Future<void> _loadSavedEmail() async {
    final savedEmail = await _globalStore.getSavedEmail();
    if (savedEmail != null && savedEmail.isNotEmpty && mounted) {
      emailController.text = savedEmail;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Email"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed:
              () => {
                // Navigator.pushNamed(context, '/main', arguments: null);
              },
        ),
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(color: Colors.black),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 24.0),
                  Text(
                    "Access Code Step 1 of 3",
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge!.copyWith(fontSize: 24),
                  ),
                  SizedBox(height: 24.0),
                  Text(
                    "Please enter your email address",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  SizedBox(height: 18.0),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AITextField(
                      controller: emailController,
                      borderColor: Colors.grey,
                      focusedColor: Theme.of(context).primaryColor,
                      prefixIcon: SizedBox(
                        width: 18,
                        height: 18,
                        child: Icon(
                          Icons.email,
                          color: Theme.of(context).primaryColor,
                          // width: 12.0,
                          // height: 12.0,
                        ),
                      ),
                      fillColor: Colors.grey.shade900,
                      onChanged: (val) {},
                      hintText: "Enter email",
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GradientPillButton(
                      text: "NEXT",
                      onPressed: () => handleClickNext(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
