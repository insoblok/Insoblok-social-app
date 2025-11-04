import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:insoblok/widgets/widgets.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/routers/routers.dart';

class AccessCodeUserIdPage extends StatefulWidget {

  final String email;
  const AccessCodeUserIdPage({super.key, required this.email});

  @override
  State<AccessCodeUserIdPage> createState() => AccessCodeUserIdPageState();

}

class AccessCodeUserIdPageState extends State<AccessCodeUserIdPage> {

  TextEditingController birthdayController = TextEditingController();
  DateTime? birthday;
  bool confirmChecked = false;
  bool termsChecked = false;


  @override initState() {
    super.initState();
  }

  void handleClickNext(BuildContext ctx) {
    if(!confirmChecked || !termsChecked) {
      AIHelpers.showToast(msg: "You need to confirm and accept Terms of service");
      return;
    }
    if (birthday == null) {
      AIHelpers.showToast(msg: "Please enter valid inputs.");
      return;
    }
    Map<String, dynamic> props = {};
    props["email"] = widget.email;
    props["birthday"] = birthday;
    Routers.goToAccessCodeConfirmPage(ctx, props);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Sign Up",
          style: Theme.of(context).textTheme.bodyLarge
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          }
        ),
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black
          ),
          child: Column(
            children: [
              SizedBox(height: 32.0),
              Text(
                "Access Code Step 2 of 3",
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontSize: 24
                )
              ),
              SizedBox(height: 8.0),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                  child: Text(
                    "We need a little more info about you. You almost have VIP access!",
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                child: DatePickerWidget(
                  hintText: 'Date of Birth',
                  onChanged: (value) {
                    logger.d('Selected date: $value');
                    birthday = DateFormat("dd/MM/yyyy").parse(value);
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Please pick a date';
                    return null;
                  },
                  iconColor: Theme.of(context).primaryColor
                )

              ),
              SizedBox(height: 12.0),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 0.0),
                child: CheckboxListTile(
                  title: Text(
                    'I confirm that I am 16 years of age or older',
                    style: Theme.of(context).textTheme.bodyMedium
                  ),
                  value: confirmChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      confirmChecked = value ?? false;
                    });
                  },
                  side: const BorderSide(
                    color: Colors.white, // Color when unchecked
                    width: 1.5,
                  ),
                  activeColor: Theme.of(context).primaryColor, // color when checked
                  checkColor: Colors.white, // checkmark color
                  tileColor: Colors.white,
                  controlAffinity: ListTileControlAffinity.leading, 
                  visualDensity: VisualDensity(horizontal: -4, vertical: 0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 0.0),
                child: CheckboxListTile(
                  title: Text(
                    'I have read and accept the Terms of service and Privacy Policy',
                    style: Theme.of(context).textTheme.bodyMedium
                  ),
                  value: termsChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      termsChecked = value ?? false;
                    });
                  },
                  side: const BorderSide(
                    color: Colors.white, // Color when unchecked
                    width: 1.5,
                  ),
                  activeColor: Theme.of(context).primaryColor, // color when checked
                  checkColor: Colors.white, // checkmark color
                  tileColor: Colors.white,
                  controlAffinity: ListTileControlAffinity.leading, // checkbox before text
                  visualDensity: VisualDensity(horizontal: -4, vertical: 0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
              SizedBox(height: 32.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: GradientPillButton(
                    text: "NEXT",
                    onPressed: () => handleClickNext(context),
                  ),
                )
            ],
      ),
        )
      )
    );
  }

}