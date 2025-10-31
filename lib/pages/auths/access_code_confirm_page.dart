import 'package:flutter/material.dart';

import 'package:insoblok/widgets/widgets.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/routers/routers.dart';

class AccessCodeConfirmPage extends StatefulWidget {

  final Map<String, dynamic> props;
  const AccessCodeConfirmPage({super.key, required this.props});
  @override
  State<AccessCodeConfirmPage> createState() => AccessCodeConfirmPageState();
}

class AccessCodeConfirmPageState extends State<AccessCodeConfirmPage> {

  final AccessCodeService accessCodeService = AccessCodeService();
  TextEditingController accessCodeController = TextEditingController();
  AccessCodeModel? created;


  @override
  void initState() {
    super.initState();
    loadAccessCode();
  }

  Future<void> loadAccessCode() async {
    AccessCodeModel accessCodeModel = AccessCodeModel(
      email: widget.props["email"].toString(),
      birthday: widget.props["birthday"],
      createdAt: DateTime.now(),
      expiry: false,
    );
    final result = await accessCodeService.createAccessCode(accessCodeModel);
    setState(() {
      created = result;
      logger.d("created code is $created");
    });
    
  } 

  Future<void> handleClickFinish(BuildContext ctx) async {
    final String enteredCode = accessCodeController.text.trim();
    final String email = widget.props["email"].toString();
    AccessCodeModel? accessCode = await accessCodeService.getAccessCodeByEmail(email);
    logger.d(accessCode);
    if (accessCode == null) {
      AIHelpers.showToast(msg: "Something went wrong. Please try again later.");
      return;
    }
    if(accessCode.accessCode == enteredCode) {
      // AIHelpers.showToast(msg: "Access Code verified. Redirecting to signin page...");
      await accessCodeService.updateChecked(email);
      Routers.goToLoginPage(ctx);
    }
    else {
      AIHelpers.showToast(msg: "Invalid Access Code.");
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop()
        )
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.08),
            Center(
              child: AIImage(
                AIImages.icCheck,
                width: 50.0,
                height: 50.0
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.08),
            Text(
              "You're on the waitlist",
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontSize: 28
              )
            ), 
            SizedBox(height: 12.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Your Own username ",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w700
                      ), 
                    ),
                    TextSpan(
                      text: ' @${widget.props["userId"] ?? ""} ',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Colors.blue,
              
                      )
                    ),
                    TextSpan(
                      text: " has been reserved. ",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w700
                      ), 
                    ),
                    TextSpan(
                      text: " The app is launching in just a few weeks. We'll notify you when you can enter!",
                      style: Theme.of(context).textTheme.bodyMedium,
                    )
                  ]
                )
              ),
            ),
            SizedBox(height: 16.0),
            if ((created?.accessCode ?? "").isNotEmpty) ... {
              Text(
                "Your access code is ${created?.accessCode}",
                style: Theme.of(context).textTheme.bodyMedium
              ),
              SizedBox(height: 12.0),
            },
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
              child: AITextField(
                controller: accessCodeController,
                fillColor: Colors.grey.shade900,
                borderColor: Theme.of(context).secondaryHeaderColor,
                focusedColor: Theme.of(context).primaryColor,
                hintText: "Enter InSoBlok access code",
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
              child: Text(
                "Did you receive an access code through email?"
              )
            ),
            SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: GradientPillButton(
                text: "OK",
                onPressed: () => handleClickFinish(context),
              ),
            )
          ]
        )
      )
    );
  }
}
