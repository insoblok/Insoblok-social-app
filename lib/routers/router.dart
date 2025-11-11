import 'dart:io' as io;
import 'package:flutter/material.dart';

import 'package:insoblok/models/models.dart';
import 'package:insoblok/pages/pages.dart';
import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/routers/routers.dart';
import 'package:insoblok/services/services.dart';

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

  static dynamic goToPincodeRegisterPage(
    BuildContext context,
    String mnemonic,
  ) {
    _pushReplacement(context, kRouterPincodeRegister, mnemonic);
  }

  static dynamic goToRegisterFirstPage(
    BuildContext context, {
    UserModel? user,
  }) {
    _pushReplacement(context, kRouterRegisterFirst, user);
  }

  static dynamic goToRegisterSecondPage(
    BuildContext context, {
    UserModel? user,
  }) {
    _pushToRoute(context, kRouterRegisterSecond, user);
  }

  static dynamic goToRegisterPage(BuildContext context, {UserModel? user}) {
    _pushToRoute(context, kRouterRegister, user);
  }

  static dynamic goToPincodePage(BuildContext context) {
    _pushToRoute(context, kRouterLoginPincode, null);
  }

  static dynamic goToEmailPage(BuildContext context) {
    _pushToRoute(context, kRouterEmail, null);
  }

  static dynamic goToMainPage(BuildContext context) {
    _pushReplacement(context, kRouterMain, null);
  }

  static dynamic goToAccessCodeUserIdPage(BuildContext context, String email) {
    _pushToRoute(context, kRouterAccessCodeUserId, email);
  }

  static dynamic goToAccessCodeConfirmPage(
    BuildContext context,
    Map<String, dynamic> props,
  ) {
    _pushToRoute(context, kRouterAccessCodeConfirm, props);
  }

  static dynamic goToAccountPage(BuildContext context, {UserModel? user}) {
    return _pushToRoute(context, kRouterAccount, user);
  }

  static dynamic goToReactionPage(BuildContext context, StoryModel data) {
    return _pushToRoute(context, kRouterReaction, data);
  }

  static dynamic goToStoryDetailPage(BuildContext context, StoryModel data) {
    return _pushToRoute(context, kRouterStoryDetail, data);
  }

  static dynamic goToLookbookDetailPage(BuildContext context, StoryModel data) {
    return _pushToRoute(context, kRouterLookbookDetail, data);
  }

  static dynamic goToAccountUpdatePage(BuildContext context) {
    return _pushToRoute(context, kRouterAccountUpdate, null);
  }

  static dynamic goToAccountAvatarPage(
    BuildContext context,
    String? src,
    String? dst,
  ) {
    Map<String, String?> args = {};
    args["src"] = src;
    args["dst"] = dst;
    return _pushToRoute(context, kRouterAccountAvatar, args);
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

  static dynamic goToRewardDetailPage(BuildContext context) {
    return _pushToRoute(context, kRouterRewardDetail, null);
  }

  static dynamic goToWalletSwapPage(BuildContext context) {
    return _pushToRoute(context, kRouterWalletSwap, null);
  }

  static dynamic goToWalletSendPage(BuildContext context) {
    return _pushToRoute(context, kRouterWalletSend, null);
  }

  static dynamic goToWalletSearchPage(BuildContext context) {
    return _pushToRoute(context, kRouterWalletSearch, null);
  }

  static dynamic goToWalletSendOnePage(BuildContext context) {
    return _pushToRoute(context, kRouterWalletSendOne, null);
  }

  static dynamic goToWalletReceivePage(BuildContext context) {
    return _pushToRoute(context, kRouterWalletReceive, null);
  }

  static dynamic goToWalletReceiveConfirmPage(BuildContext context) {
    return _pushToRoute(context, kRouterWalletReceiveConfirm, null);
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

  static dynamic goToChatViewPage(BuildContext context) {
    return _pushToRoute(context, kRouterChatView, null);
  }

  static dynamic goToArchivedChatViewPage(BuildContext context) {
    return _pushToRoute(context, kRouterArchivedChatView, null);
  }

  static dynamic goToChatPaymentPage(BuildContext context, String s, String r) {
    Map<String, String> args = {};
    args["sender"] = s;
    args["receiver"] = r;
    return _pushToRoute(context, kRouterChatPayment, args);
  }

  static dynamic goToPaymentAmountPage(
    BuildContext context,
    String s,
    String r,
    String n,
    double amount,
  ) {
    Map<String, dynamic> args = {};
    args["sender"] = s;
    args["receiver"] = r;
    args["network"] = n;
    args["amount"] = amount;
    return _pushToRoute(context, kRouterPaymentAmount, args);
  }

  static dynamic goToPaymentConfirmPage(
    BuildContext context,
    String s,
    String r,
    String n,
    double amt,
  ) {
    Map<String, dynamic> args = {};
    args["sender"] = s;
    args["receiver"] = r;
    args["network"] = n;
    args["amount"] = amt;
    return _pushToRoute(context, kRouterPaymentConfirm, args);
  }

  static dynamic goToPaymentResultPage(BuildContext context) {
    return _pushToRoute(context, kRouterPaymentResult, null);
  }

  static dynamic goToLookbookPage(BuildContext context) {
    return _pushToRoute(context, kRouterLookbook, null);
  }

  static dynamic goToNewsPage(BuildContext context) {
    return _pushToRoute(context, kRouterNews, null);
  }

  static dynamic goToFollowingPage(BuildContext context) {
    return _pushToRoute(context, kRouterFollowing, null);
  }

  static dynamic goToFriendPage(BuildContext context) {
    return _pushToRoute(context, kRouterFriend, null);
  }

  static dynamic goToAddStoryPage(BuildContext context) {
    return _pushToRoute(context, kRouterAddStory, null);
  }

  static dynamic goToVideoEditorPage(BuildContext context, String path) {
    return _pushToRoute(context, kRouterVideoEditor, path);
  }

  static dynamic goToImageEditorPage(BuildContext context, String path) {
    return _pushToRoute(context, kRouterImageEditor, path);
  }

  static dynamic goToVTOImagePage(BuildContext context, ProductModel product) {
    return _pushToRoute(context, kRouterMarketVTOImage, product);
  }

  static dynamic goToVTODetailPage(
    BuildContext context,
    VTODetailPageModel model,
  ) {
    return _pushReplacement(context, kRouterMarketVTODetail, model);
  }

  static dynamic goToVTOAddProduct(BuildContext context) {
    return _pushToRoute(context, kRouterVTOAddProduct, null);
  }

  static dynamic goToNewsDetailPage(BuildContext context, NewsModel data) {
    return _pushToRoute(context, kRouterNewsDetail, data);
  }

  static dynamic goToPostDetailPage(
    BuildContext context,
    Map<String, dynamic> data,
  ) {
    return _pushToRoute(context, kRouterPostDetail, data);
  }

  static dynamic goToQuillDescriptionPage(
    BuildContext context, {
    String? origin,
  }) {
    return _pushToRoute(context, kRouterQuillDescription, origin);
  }

  static dynamic goToSearchPage(BuildContext context) {
    return _pushToRoute(context, kRouterSearch, null);
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
    required MediaDetailModel model,
  }) {
    return _pushToRoute(context, kRouterMediaDetail, model);
  }

  static dynamic goToLeaderboardPage(BuildContext context) {
    return _pushToRoute(context, kRouterLeaderboard, null);
  }

  static dynamic goToTastescorePage(BuildContext context, {UserModel? user}) {
    return _pushToRoute(context, kRouterTastescore, user);
  }

  static dynamic goToMarketPlacePage(BuildContext context) {
    return _pushToRoute(context, kRouterMarketPlace, null);
  }

  static dynamic goToFaceDetailPage(
    BuildContext context,
    String storyID,
    String url,
    io.File face,
    List<AIFaceAnnotation> annotations,
    bool editable,
  ) {
    return _pushToRoute(context, kRouterFaceDetail, {
      'storyID': storyID,
      'url': url,
      'face': face,
      'annotations': annotations,
      'editable': editable,
    });
  }

  static dynamic goToReactionVideoDetailPage(
    BuildContext context,
    String storyID,
    String url,
    String videoPath,
    bool editable,
  ) {
    return _pushToRoute(context, kRouterReactionVideoDetail, {
      'storyID': storyID,
      'url': url,
      'videoPath': videoPath,
      'editable': editable,
    });
  }

  static dynamic goToUserListPage(
    BuildContext context, {
    List<UserModel>? users,
  }) {
    return _pushToRoute(context, kRouterUserList, users);
  }

  static dynamic goToFavoritesPage(BuildContext context) {
    return _pushToRoute(context, kRouterFavorites, null);
  }

  static dynamic goToTokenDetailPage(
    BuildContext context,
    Map<String, dynamic> args,
  ) {
    return _pushToRoute(context, kRouterTokenDetail, args);
  }

  static dynamic goToRRCAvatarGenerationPage(
    BuildContext context,
    io.File? face,
    String url,
    String origin,
    String storyID,
  ) {
    Map<String, dynamic> args = {};
    args["face"] = face!;
    args["url"] = url;
    args["origin"] = origin;
    args["storyID"] = storyID;
    logger.d("This is inside gotorrcavatar $args");
    return _pushToRoute(context, kRouterRRCAvatarGeneration, args);
  }
}
