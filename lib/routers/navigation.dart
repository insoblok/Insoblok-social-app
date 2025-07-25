import 'package:flutter/material.dart';

import 'package:fluro/fluro.dart' as fluro;

import 'package:insoblok/models/models.dart';
import 'package:insoblok/pages/pages.dart';
import 'package:insoblok/pages/profiles/tastescore_page.dart';
import 'package:insoblok/pages/profiles/wallet_swap_page.dart';
import 'package:insoblok/providers/providers.dart';

const kRouterBase = '/';
const kRouterLogin = '/login';
const kRouterRegister = '/register';
const kRouterRegisterFirst = '/register-first';
const kRouterRegisterSecond = '/register-second';
const kRouterMain = '/main';

const kRouterAccount = '/account';
const kRouterAccountUpdate = '/account-update';
const kRouterAccountAvatar = '/account-avatar';
const kRouterAccountPublic = '/account-public';
const kRouterAccountPrivate = '/account-private';
const kRouterAccountPost = '/account-post';
const kRouterAccountTopic = '/account-topic';
const kRouterAccountBookmark = '/account-bookmark';
const kRouterAccountMoment = '/account-moment';
const kRouterAccountWallet = '/account-Wallet';
const kRouterAccountReward = '/account-reward';
const kRouterRewardDetail = '/reward-detail';
const kRouterWalletSwap = '/wallet-swap';

const kRouterCreateRoom = '/create-room';
const kRouterMessage = '/message';
const kRouterMessageSetting = '/message-setting';

const kRouterNews = '/news';
const kRouterLookbook = '/lookbook';
const kRouterFollowing = '/following';
const kRouterFriend = '/friend';

const kRouterMarketVTOImage = '/vto-image';
const kRouterMarketVTODetail = '/vto-detail';
const kRouterVTOAddProduct = '/vto-add-product';

const kRouterAddStory = '/add-story';
const kRouterStoryDetail = '/story-detail';
const kRouterNewsDetail = '/news-detail';
const kRouterPostDetail = '/post-detail';

const kRouterQuillDescription = '/quill-description';
const kRouterPrivacy = '/privacy-police';
const kRouterHelpCenter = '/help-center';
const kRouterMediaDetail = '/media-detail';
const kRouterSetting = '/setting';

const kRouterLeaderboard = '/leaderboard';
const kRouterTastescore = '/tastescore';
const kRouterMarketPlace = '/market-place';

class Navigation {
  final router = fluro.FluroRouter();

  Navigation() {
    defineRoutes();
  }

  dynamic defineRoutes() {
    initRoute<T>(
      String route,
      Function(T? props) init, {
      fluro.TransitionType? transitionType,
    }) {
      router.define(
        route,
        handler: fluro.Handler(
          handlerFunc: (BuildContext? context, _) {
            final T? props = ModalRoute.of(context!)?.settings.arguments as T?;
            return init(props);
          },
        ),
        transitionType: transitionType ?? fluro.TransitionType.native,
      );
    }

    // * LoginPage
    initRoute(kRouterLogin, (props) => LoginPage());

    // * RegisterPage
    initRoute<UserModel>(
      kRouterRegister,
      (props) => RegisterPage(user: props!),
    );

    // * RegisterFirstPage
    initRoute<UserModel>(
      kRouterRegisterFirst,
      (props) => RegisterFirstPage(user: props!),
    );

    // * RegisterSecondPage
    initRoute<UserModel>(
      kRouterRegisterSecond,
      (props) => RegisterSecondPage(user: props!),
    );

    // * MainPage
    initRoute(kRouterMain, (props) => InSoBlokPage());

    // * AccountPage
    initRoute<UserModel>(kRouterAccount, (props) => AccountPage(user: props));

    // * UpdateAccountPage
    initRoute(kRouterAccountUpdate, (props) => UpdateProfilePage());

    // * AccountAvatarPage
    initRoute(kRouterAccountAvatar, (props) => AccountAvatarPage());

    // * AccountPublicPage
    initRoute(kRouterAccountPublic, (props) => AccountPublicPage());

    // * AccountPrivatePage
    initRoute(kRouterAccountPrivate, (props) => AccountPrivatePage());

    // * AccountListPage
    initRoute(kRouterAccountPost, (props) => PostsPage());

    // * AccountTopicPage
    initRoute(kRouterAccountTopic, (props) => TopicPage());

    // * AccountBookmarkPage
    initRoute(kRouterAccountBookmark, (props) => BookmarkPage());

    // * AccountMomentPage
    initRoute(kRouterAccountMoment, (props) => MomentPage());

    // * AccountWalletPage
    initRoute(kRouterAccountWallet, (props) => AccountWalletPage());

    // * AccountRewardPage
    initRoute(kRouterAccountReward, (props) => AccountRewardPage());

    // * RewardDetailPage
    initRoute(kRouterRewardDetail, (props) => RewardDetailPage());

    // * WalletSwapPage
    initRoute(kRouterWalletSwap, (props) => WalletSwapPage());

    // * CreateRoomPage
    initRoute(kRouterCreateRoom, (props) => CreateRoomPage());

    // * MessagePage
    initRoute<MessagePageData>(
      kRouterMessage,
      (props) => MessagePage(data: props!),
    );

    // * MessageSettingPage
    initRoute(kRouterMessageSetting, (props) => MessageSettingPage());

    // * News
    initRoute(kRouterNews, (props) => NewsPage());

    // * Lookbook
    initRoute(kRouterLookbook, (props) => LookbookPage());

    // * Following
    initRoute(kRouterFollowing, (props) => FollowingPage());

    // * Friend
    initRoute(kRouterFriend, (props) => FriendPage());

    // * Marketlace VTO Clothing
    initRoute<ProductModel>(
      kRouterMarketVTOImage,
      (props) => VTOImagePage(product: props!),
    );

    // * Marketlace VTO Detail
    initRoute<VTODetailPageModel>(
      kRouterMarketVTODetail,
      (props) => VTODetailPage(model: props!),
    );

    // * Marketlace Add Product
    initRoute(kRouterVTOAddProduct, (props) => AddProductPage());

    // * AddStoryPage
    initRoute(kRouterAddStory, (props) => AddStoryPage());

    // * StoryDetailPage
    initRoute<StoryModel>(
      kRouterStoryDetail,
      (props) => StoryDetailPage(story: props!),
    );

    // * NewsDetailPage
    initRoute<NewsModel>(
      kRouterNewsDetail,
      (props) => NewsDetailPage(news: props!),
    );

    // * PostDetailPage
    initRoute<Map<String, dynamic>>(
      kRouterPostDetail,
      (props) => PostDetailPage(data: props!),
    );

    // * QuillDescriptionPage
    initRoute<String>(
      kRouterQuillDescription,
      (props) => QuillDescriptionPage(originQuill: props),
    );

    // * SettingPage
    initRoute(kRouterSetting, (props) => SettingPage());

    // * PrivacyPage
    initRoute(kRouterPrivacy, (props) => PrivacyPage());

    // * HelpCenterPage
    initRoute(kRouterHelpCenter, (props) => HelpPage());

    // * MediaDetailPage
    initRoute<MediaDetailModel>(
      kRouterMediaDetail,
      (props) => MediaDetailPage(model: props!),
    );

    // * LeaderboardPage
    initRoute(kRouterLeaderboard, (props) => LeaderboardPage());

    // * TastescorePage
    initRoute<UserModel>(
      kRouterTastescore,
      (props) => TastescorePage(user: props),
    );

    // * MarketPlacePage
    initRoute(kRouterMarketPlace, (props) => MarketPlacePage());
  }
}
