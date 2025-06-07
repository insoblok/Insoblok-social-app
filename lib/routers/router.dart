import 'package:flutter/material.dart';

import 'package:insoblok/models/models.dart';
import 'package:insoblok/pages/pages.dart';
import 'package:insoblok/routers/routers.dart';

class Routers {
  static dynamic _pushToRoute(BuildContext context, String route, props) {
    return Navigator.pushNamed(context, route, arguments: props);
  }

  static dynamic _pushReplacement(BuildContext context, String route, props) {
    return Navigator.pushReplacementNamed(context, route, arguments: props);
  }

  static dynamic goToLoginPage(BuildContext context) {
    _pushReplacement(context, kRouterLogin, null);
  }

  static dynamic goToAuthPage(BuildContext context) {
    _pushToRoute(context, kRouterAuth, null);
  }

  static dynamic goToRegisterPage(BuildContext context) {
    _pushReplacement(context, kRouterRegister, null);
  }

  static dynamic goToMainPage(BuildContext context) {
    _pushReplacement(context, kRouterMain, null);
  }

  static dynamic goToAccountPage(BuildContext context, {UserModel? user}) {
    return _pushToRoute(context, kRouterAccount, user);
  }

  static dynamic goToAccountUpdatePage(BuildContext context) {
    return _pushToRoute(context, kRouterAccountUpdate, null);
  }

  static dynamic goToAccountAvatarPage(BuildContext context) {
    return _pushToRoute(context, kRouterAccountAvatar, null);
  }

  static dynamic goToAccountPublicPage(BuildContext context) {
    return _pushToRoute(context, kRouterAccountPublic, null);
  }

  static dynamic goToAccountPrivatePage(BuildContext context) {
    return _pushToRoute(context, kRouterAccountPrivate, null);
  }

  static dynamic goToAccountListPage(BuildContext context) {
    return _pushToRoute(context, kRouterAccountPost, null);
  }

  static dynamic goToAccountTopicPage(BuildContext context) {
    return _pushToRoute(context, kRouterAccountTopic, null);
  }

  static dynamic goToAccountBookmarkPage(BuildContext context) {
    return _pushToRoute(context, kRouterAccountBookmark, null);
  }

  static dynamic goToAccountMomentPage(BuildContext context) {
    return _pushToRoute(context, kRouterAccountMoment, null);
  }

  static dynamic goToAccountWalletPage(BuildContext context) {
    return _pushToRoute(context, kRouterAccountWallet, null);
  }

  static dynamic goToAccountRewardPage(BuildContext context) {
    return _pushToRoute(context, kRouterAccountReward, null);
  }

  static dynamic goToCreateRoomPage(BuildContext context) {
    return _pushToRoute(context, kRouterCreateRoom, null);
  }

  static dynamic goToMessagePage(BuildContext context, MessagePageData data) {
    return _pushToRoute(context, kRouterMessage, data);
  }

  static dynamic goToMessageSettingPage(BuildContext context) {
    return _pushToRoute(context, kRouterMessageSetting, null);
  }

  static dynamic goToAddStoryPage(BuildContext context) {
    return _pushToRoute(context, kRouterAddStory, null);
  }

  static dynamic goToVTOImagePage(BuildContext context, ProductModel product) {
    return _pushToRoute(context, kRouterMarketVTOImage, product);
  }

  static dynamic goToVTOAddProduct(BuildContext context) {
    return _pushToRoute(context, kRouterVTOAddProduct, null);
  }

  static dynamic goToStoryDetailPage(BuildContext context, StoryModel data) {
    return _pushToRoute(context, kRouterStoryDetail, data);
  }

  static dynamic goToNewsDetailPage(BuildContext context, NewsModel data) {
    return _pushToRoute(context, kRouterNewsDetail, data);
  }

  static dynamic goToPostDetailPage(BuildContext context) {
    return _pushToRoute(context, kRouterPostDetail, null);
  }

  static dynamic goToQuillDescriptionPage(
    BuildContext context, {
    String? origin,
  }) {
    return _pushToRoute(context, kRouterQuillDescription, origin);
  }

  static dynamic goToSettingPage(BuildContext context) {
    return _pushToRoute(context, kRouterSetting, null);
  }

  static dynamic goToPrivacyPage(BuildContext context) {
    return _pushToRoute(context, kRouterPrivacy, null);
  }

  static dynamic goToHelpCenterPage(BuildContext context) {
    return _pushToRoute(context, kRouterHelpCenter, null);
  }

  static dynamic goToMediaDetailPage(
    BuildContext context, {
    required List<String> medias,
  }) {
    return _pushToRoute(context, kRouterMediaDetail, medias);
  }

  static dynamic goToLeaderboardPage(BuildContext context) {
    return _pushToRoute(context, kRouterLeaderboard, null);
  }
}
