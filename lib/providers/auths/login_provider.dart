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

    _reownService = ReownService(context);
    await _reownService.init();

    FlutterNativeSplash.remove();

    _videoPlayerController = VideoPlayerController.asset(
      'assets/videos/insoblock.mp4',
    );
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

  bool _isClickWallet = false;
  bool get isClickWallet => _isClickWallet;
  set isClickWallet(bool f) {
    _isClickWallet = f;
    notifyListeners();
  }

  late ReownService _reownService;
  ReownService get reownService => _reownService;

  Future<void> login() async {
    if (isClickWallet) return;
    clearErrors();
    isClickWallet = true;
    try {
      await reownService.connect();
      if (reownService.isConnected) {
        logger.d(reownService.walletAddress);
        await AuthHelper.service.signIn(
          walletAddress: reownService.walletAddress,
        );
      } else {
        setError('Failed wallet connected!');
      }
    } catch (e) {
      setError(e);
      logger.e(e);
    } finally {
      notifyListeners();
    }

    if (hasError) {
      Fluttertoast.showToast(msg: modelError.toString());
    } else {
      if (AuthHelper.user?.firstName != null) {
        AuthHelper.updateStatus('Online');
        Routers.goToMainPage(context);
      } else {
        Routers.goToRegisterPage(context);
      }
    }
  }

  Future<void> googleSignin() async {
    if (isBusy) return;
    clearErrors();

    await runBusyFuture(() async {
      try {
        if (await reownService.showWallet(context) == true) {
          await reownService.connect();
          if (reownService.isConnected) {
            logger.d(reownService.walletAddress);
            await AuthHelper.service.signInWithGoogle(
              walletAddress: reownService.walletAddress,
            );
          } else {
            setError('Failed wallet connected!');
          }
        } else {
          await AuthHelper.service.signInWithGoogle();
        }
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
        AuthHelper.updateStatus('Online');
        Routers.goToMainPage(context);
      } else {
        Routers.goToRegisterPage(context);
      }
    }
  }
}
