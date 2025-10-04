import 'package:flutter/material.dart';
import 'package:insoblok/widgets/widgets.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';




class SocialMediaIndividualInput extends StatefulWidget {

  final String icon;
  final UpdateAccount updateAccount;
  final String field;
  final String placeholder;
  final bool added;
  final int? maxItems;
  final String? initialAccount;
  const SocialMediaIndividualInput({ super.key, required this.icon, required this.updateAccount, required this.field, required this.placeholder, required this.added, this.maxItems = 6, this.initialAccount });

  SocialMediaIndividualInputState createState() => SocialMediaIndividualInputState();

}

class SocialMediaIndividualInputState extends State<SocialMediaIndividualInput> {
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.text = widget.initialAccount ?? "";
  }

  @override
  Widget build(BuildContext context) {
    
    return Container(
      padding: EdgeInsets.all(6.0),
      child: Row(
        children: [
          AIImage(
            widget.icon,
            width: 36,
            height: 36,
            // color: Colors.transparent
          ),
          SizedBox(width: 12.0),
          Expanded(
            child: AITextField(
              controller: controller,
              hintText: widget.placeholder,
              borderColor: Colors.transparent,
              fillColor: Colors.grey.withOpacity(0.2),
            ),
          ),
          SizedBox(width: 12.0),
          GestureDetector(
            onTap: () {
              String account = controller.text.trim();
              if (account.isEmpty || !account.contains(widget.placeholder)) {
                AIHelpers.showToast(msg: "Please enter valid account.");
                return;
              }              
              widget.updateAccount(widget.field, account);
            },
            child: SizedBox(
              width: 36,
              child: widget.added ? Align(alignment: Alignment.centerLeft, child: Icon(Icons.cancel)) :Text(
                 "Add",
                style: Theme.of(context).textTheme.bodyMedium
              )
            ),
          )
        ]
      ),
    );
            
  }
}