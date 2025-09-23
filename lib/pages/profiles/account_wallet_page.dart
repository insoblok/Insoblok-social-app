import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/widgets/widgets.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/services/services.dart';


class AccountWalletPage extends StatelessWidget {
  const AccountWalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AccountWalletProvider>.reactive(
      viewModelBuilder: () => AccountWalletProvider(),
      builder: (context, viewModel, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text('My Wallet'),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            centerTitle: true,
            flexibleSpace: AppBackgroundView(),
          ),
          body:  AppBackgroundView(
            child: viewModel.pages[viewModel.currentIndex]
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
              colors: [
                AIColors.lightPurple.withAlpha(32),
                AIColors.lightBlue.withAlpha(32),
                AIColors.lightPurple.withAlpha(32),
                AIColors.lightTeal.withAlpha(32),
              ],
              stops: [0.0, 0.4, 0.7, 1.0],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            ),
            child: BottomNavigationBar(
              currentIndex: viewModel.currentIndex,
              backgroundColor: Colors.transparent,
              onTap: viewModel.setIndex,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: "Home",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.area_chart),
                  label: "Favorites",
                ),
              ],
            ),
          ),
          );
      },
    );
  }
}
