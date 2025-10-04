import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:stacked/stacked.dart';
import 'package:provider/provider.dart';

import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/widgets/widgets.dart';
import 'package:insoblok/locator.dart';

class WalletReceiveConfirmPage extends StatelessWidget {
  const WalletReceiveConfirmPage({super.key});
  
  @override
  Widget build(BuildContext context) {

    final CryptoService cryptoService = locator<CryptoService>();
    return ViewModelBuilder<WalletReceiveProvider>.reactive(
      viewModelBuilder: () => WalletReceiveProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context),
      builder: (context, viewModel, _) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            title: Text('Receive'),
            centerTitle: true,
            flexibleSpace: AppBackgroundView(),
          ),
          body: AppBackgroundView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 24.0,
              ),
              child: Column(
                children: [
                  SizedBox(height: 12.0),
                  WalletQrDisplay(
                    data: cryptoService.privateKey!.address.hex,
                    title: "",
                    subtitle: "",
                    size: 200,
                    backgroundColor: Colors.white,
                  ),
                  SizedBox(height: 12.0),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: Text(
                        "${cryptoService.privateKey!.address.hex}",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(height: 24.0),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(Icons.copy),
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: cryptoService.privateKey!.address.hex));
                            AIHelpers.showToast(msg: "Copied address to Clipboard");
                          }
                        ),
                        SizedBox(width: 24.0),
                        Text(
                          "Copy Address",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.blueAccent
                          ),
                        ),
                      ]
                    ),
                  ),
                  SizedBox(height: 48.0),
                  Column(
                    children: [
                      GradientPillButton(
                        text: "Close", 
                        onPressed: () {
                          Navigator.pop(context, null);
                        }
                      )
                    ],
                  )
                ],

              ) 
            ),
          ),
        );
      },
    );
  }
}
