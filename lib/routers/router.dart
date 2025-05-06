import 'package:flutter/material.dart';

import 'package:insoblok/models/models.dart';
import 'package:insoblok/pages/pages.dart';
import 'package:insoblok/routers/routers.dart';

class Routers {
  static _pushToRoute(BuildContext context, String route, props) {
    return Navigator.pushNamed(context, route, arguments: props);
  }

  static _pushReplacement(BuildContext context, String route, props) {
    return Navigator.pushReplacementNamed(context, route, arguments: props);
  }

  static void goToLoginPage(BuildContext context) {
    _pushReplacement(context, kRouterLogin, null);
  }

  static void goToRegisterPage(BuildContext context) {
    _pushReplacement(context, kRouterRegister, null);
  }

  static void goToMainPage(BuildContext context) {
    _pushReplacement(context, kRouterMain, null);
  }

  static goToAccountPage(BuildContext context, {UserModel? user}) {
    return _pushToRoute(context, kRouterAccount, user);
  }

  static goToAccountUpdatePage(BuildContext context) {
    return _pushToRoute(context, kRouterAccountUpdate, null);
  }

  static goToAccountAvatarPage(BuildContext context) {
    return _pushToRoute(context, kRouterAccountAvatar, null);
  }

  static goToAccountPublicPage(BuildContext context) {
    return _pushToRoute(context, kRouterAccountPublic, null);
  }

  static goToAccountPrivatePage(BuildContext context) {
    return _pushToRoute(context, kRouterAccountPrivate, null);
  }

  static goToAccountListPage(BuildContext context) {
    return _pushToRoute(context, kRouterAccountPost, null);
  }

  static goToAccountTopicPage(BuildContext context) {
    return _pushToRoute(context, kRouterAccountTopic, null);
  }

  static goToAccountBookmarkPage(BuildContext context) {
    return _pushToRoute(context, kRouterAccountBookmark, null);
  }

  static goToAccountMomentPage(BuildContext context) {
    return _pushToRoute(context, kRouterAccountMoment, null);
  }

  static goToCreateRoomPage(BuildContext context) {
    return _pushToRoute(context, kRouterCreateRoom, null);
  }

  static goToMessagePage(BuildContext context, MessagePageData data) {
    return _pushToRoute(context, kRouterMessage, data);
  }

  static goToMessageSettingPage(BuildContext context) {
    return _pushToRoute(context, kRouterMessageSetting, null);
  }

  static goToAddStoryPage(BuildContext context) {
    return _pushToRoute(context, kRouterAddStory, null);
  }

  static goToVTOClothingPage(BuildContext context) {
    return _pushToRoute(context, kRouterMarketVTOClothing, null);
  }

  static goToVTOAddProduct(BuildContext context) {
    return _pushToRoute(context, kRouterVTOAddProduct, null);
  }

  static goToStoryDetailPage(BuildContext context, StoryModel data) {
    return _pushToRoute(context, kRouterStoryDetail, data);
  }

  static goToNewsDetailPage(BuildContext context, NewsModel data) {
    return _pushToRoute(context, kRouterNewsDetail, data);
  }

  static goToQuillDescriptionPage(BuildContext context, {String? origin}) {
    return _pushToRoute(context, kRouterQuillDescription, origin);
  }

  static goToSettingPage(BuildContext context) {
    return _pushToRoute(context, kRouterSetting, null);
  }

  static goToPrivacyPage(BuildContext context) {
    return _pushToRoute(context, kRouterPrivacy, null);
  }

  static goToHelpCenterPage(BuildContext context) {
    return _pushToRoute(context, kRouterHelpCenter, null);
  }

  static goToMediaDetailPage(
    BuildContext context, {
    required List<String> medias,
  }) {
    return _pushToRoute(context, kRouterMediaDetail, medias);
  }
}
