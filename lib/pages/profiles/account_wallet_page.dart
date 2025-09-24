import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/utils/utils.dart';


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
            // flexibleSpace: AppBackgroundView(),
          ),
          body:  Container(
            color: Colors.black,
            child: viewModel.pages[viewModel.currentIndex]
          ),
          bottomNavigationBar: Container(
            child: BottomNavigationBar(
              currentIndex: viewModel.currentIndex,
              backgroundColor: Colors.transparent,
              selectedItemColor: Colors.white, // active color
              unselectedItemColor: Colors.grey, // inactive color
              onTap: viewModel.setIndex,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),      // inactive icon
                  activeIcon: Icon(Icons.home),         // active icon
                  label: "Home",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.area_chart_outlined), // inactive icon
                  activeIcon: Icon(Icons.area_chart),    // active icon
                  label: "Favorites",
                ),
              ],
            ),
          )

        );
      },
    );
  }
}
