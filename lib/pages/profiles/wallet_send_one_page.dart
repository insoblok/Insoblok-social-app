import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';
import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/widgets/widgets.dart';

class WalletSendOnePage extends StatefulWidget {
  const WalletSendOnePage({super.key});

  @override
  State<WalletSendOnePage> createState() => WalletSendOnePageState(); 
}

class WalletSendOnePageState extends State<WalletSendOnePage> {

  String amount = "0";

  void _onKeyTap(String value) {
    setState(() {
      if (value == "⌫") {
        if (amount.isNotEmpty && amount != "0") {
          amount = amount.substring(0, amount.length - 1);
          if (amount.isEmpty) amount = "0";
        }
      } else {
        if (amount == "0") {
          amount = value;
        } else {
          amount += value;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return ViewModelBuilder<WalletSendProvider>.reactive(
      viewModelBuilder: () => WalletSendProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context, "", "", "", 0),
      builder: (context, viewModel, _) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            title: Text('My Wallet'),
            centerTitle: true,
          ),
          body: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    "Transfer from",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF5A2EFF), Color(0xFF7D2DFF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          "\$4,480.06",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        CircleAvatar(
                          radius: 12,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.check, size: 16, color: Colors.black),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "****5436    04/26",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),

              // --- Transfer To Card ---
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6A1B9A), Color(0xFF8E24AA)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      backgroundImage: NetworkImage(
                          "https://i.pravatar.cc/150?img=3"), // placeholder
                      radius: 20,
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Robert Collins",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Wellby Bank ....8132",
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // --- Amount Display ---
              Text(
                "\$.00",
                style: const TextStyle(
                  fontSize: 32,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              // --- Number Pad ---
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  itemCount: 12,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                  ),
                  itemBuilder: (context, index) {
                    final keys = [
                      "1", "2", "3",
                      "4", "5", "6",
                      "7", "8", "9",
                      ".", "0", "⌫"
                    ];
                    String key = keys[index];
                    return GestureDetector(
                      onTap: () => _onKeyTap(key),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[900],
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Center(
                          child: Text(
                            key,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // --- Transfer Button ---
              Container(
                margin: const EdgeInsets.all(16),
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.arrow_forward, color: Colors.white),
                  label: const Text(
                    "Transfer",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}
