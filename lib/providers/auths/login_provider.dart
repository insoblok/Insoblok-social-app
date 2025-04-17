import 'package:flutter/material.dart';

import 'package:chewie/chewie.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:video_player/video_player.dart';

import 'package:insoblok/routers/routers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

class LoginProvider extends InSoBlokViewModel {
  late BuildContext _context;
  BuildContext get context => _context;
  set context(BuildContext context) {
    _context = context;
    notifyListeners();
  }

  late VideoPlayerController _videoPlayerController;
  VideoPlayerController get videoPlayerController => _videoPlayerController;

  late ChewieController _chewieController;
  ChewieController get chewieController => _chewieController;

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  Future<void> init(BuildContext context) async {
    this.context = context;

    FlutterNativeSplash.remove();

    _videoPlayerController =
        VideoPlayerController.asset('assets/videos/insoblock.mp4');
    await _videoPlayerController.initialize();

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: true,
      aspectRatio: _videoPlayerController.value.aspectRatio,
      showControls: false,
      materialProgressColors: ChewieProgressColors(
        playedColor: Colors.red,
        handleColor: Colors.red,
        backgroundColor: Colors.grey,
        bufferedColor: Colors.lightGreen,
      ),
    );

    notifyListeners();
  }

  Future<void> login() async {
    if (isBusy) return;
    clearErrors();

    await runBusyFuture(() async {
      try {
        // var isValid = await MetaMaskService.isAvailable();
        // if (isValid) {
        //   await MetaMaskService.connect();

        //   var address = await MetaMaskService.getWalletAddress();
        //   logger.d(address);
        // }
        // var service = WalletService();
        // await service.connectWithMetaMask();
        // // await service.connectWithWalletConnect();

        var service = EthereumHelper.service;
        await service.connectWithPrivateKey(kMetamaskApiKey);

        await AuthHelper.service.signIn();
      } catch (e) {
        setError(e);
        logger.e(e);
      } finally {
        notifyListeners();
      }
    }());

    if (hasError) {
      Fluttertoast.showToast(msg: modelError.toString());
    } else {
      if (AuthHelper.user?.firstName != null) {
        Routers.goToMainPage(context);
      } else {
        Routers.goToRegisterPage(context);
      }
    }
  }

  // Future<void> _connectWalletConnect() async {
  //   await _walletConnect.connect();
  //   setState(() {
  //     _address = _walletConnect.connector.session.accounts[0];
  //   });
  //   _updateBalance();
  // }

  // Future<void> _createNewWallet() async {
  //   final mnemonic = await _walletService.generateMnemonic();
  //   final privateKey = await _walletService.getPrivateKeyFromMnemonic(mnemonic);
  //   final address = await _walletService.getPublicKey(privateKey);

  //   setState(() {
  //     _address = address.hex;
  //   });
  //   _updateBalance();
  // }

  // Future<void> _updateBalance() async {
  //   if (_address == null) return;

  //   final client =
  //       EthereumClient('https://mainnet.infura.io/v3/YOUR_PROJECT_ID');
  //   final balance = await client.getBalance(EthereumAddress.fromHex(_address!));
  //   setState(() {
  //     _balance = balance.getValueInUnit(EtherUnit.ether).toStringAsFixed(4);
  //   });
  //   client.dispose();
  // }

  // Future<void> _disconnect() async {
  //   await _walletConnect.disconnect();
  //   setState(() {
  //     _address = null;
  //     _balance = null;
  //   });
  // }
}
