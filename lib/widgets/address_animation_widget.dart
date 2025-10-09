import 'package:flutter/material.dart';
import 'package:googleapis/adsenseplatform/v1.dart';

import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';


class AddressAnimationWidget extends StatefulWidget {
  final double? duration;
  final String address;

  const AddressAnimationWidget({super.key, this.duration = 10.0, required this.address});

  @override
  State<AddressAnimationWidget> createState() => AddressAnimationWidgetState();
}

class AddressAnimationWidgetState extends State<AddressAnimationWidget> with SingleTickerProviderStateMixin {
  
  late AnimationController animationController;
  late Animation<double> addressAnimation;
  
  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      duration: Duration(seconds: widget.duration!.toInt()),
      vsync: this
    )..repeat();
    addressAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(animationController);

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.topLeft,
        child: Container(
          margin: EdgeInsets.only(left: 8, top: 54),
          padding: EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(10.0)
          ),
          child: SizedBox(
            width: 120.0,
            child: Row(
              children: [
                Icon(Icons.place),
                Text(
                  '${widget.address}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          )
        )
      ),
    );

  }


}
