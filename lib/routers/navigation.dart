import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart' as fluro;

import 'package:insoblok/models/models.dart';
import 'package:insoblok/pages/pages.dart';
import 'package:insoblok/pages/homes/rrc_avatar_generation_view.dart' as homes;
import 'package:insoblok/providers/providers.dart';

const kRouterBase = '/';
const kRouterLogin = '/login';
const kRouterPincodeRegister = '/register-pincode';
const kRouterRegister = '/register';
const kRouterRegisterFirst = '/register-first';
const kRouterRegisterSecond = '/register-second';
const kRouterLoginPincode = "/login-pincode";
const kRouterEmail = '/email';
const kRouterAccessCodeUserId = '/access-code-user-id';
const kRouterAccessCodeConfirm = '/access-code-confirm';

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
const kRouterWalletSend = '/wallet-send';
const kRouterWalletSearch = '/wallet-search';
const kRouterWalletSendOne = 'wallet-send-one';
const kRouterWalletReceive = '/wallet-receive';
const kRouterWalletReceiveConfirm = '/wallet-receive-confirm';

const kRouterCreateRoom = '/create-room';
const kRouterMessage = '/message';
const kRouterMessageSetting = '/message-setting';
const kRouterChatView = '/chat-view';
const kRouterArchivedChatView = '/archived-chat-view';

const kRouterChatPayment = '/message-payment';
const kRouterPaymentAmount = '/payment-amount';
const kRouterPaymentConfirm = '/payment-confirm';
const kRouterPaymentResult = '/payment-result';

const kRouterNews = '/news';
const kRouterLookbook = '/lookbook';
const kRouterFollowing = '/following';
const kRouterFriend = '/friend';

const kRouterMarketVTOImage = '/vto-image';
const kRouterMarketVTODetail = '/vto-detail';
const kRouterVTOAddProduct = '/vto-add-product';

const kRouterAddStory = '/add-story';
const kRouterStoryDetail = '/story-detail';
const kRouterLookbookDetail = '/lookbook-detail';
const kRouterNewsDetail = '/news-detail';
const kRouterPostDetail = '/post-detail';
const kRouterReaction = '/reaction';
const kRouterVideoEditor = '/video-editor';
const kRouterImageEditor = '/image-editor';

const kRouterQuillDescription = '/quill-description';
const kRouterPrivacy = '/privacy-police';
const kRouterHelpCenter = '/help-center';
const kRouterMediaDetail = '/media-detail';
const kRouterSetting = '/setting';
const kRouterSearch = '/search';

const kRouterLeaderboard = '/leaderboard';
const kRouterTastescore = '/tastescore';
const kRouterMarketPlace = '/market-place';
const kRouterFaceDetail = '/face-detail';
const kRouterReactionVideoDetail = '/reaction-video-detail';
const kRouterUserList = '/user-list';
const kRouterFavorites = '/wallet-favorites';
const kRouterTokenDetail = '/token-detail';
// Live streaming
const kRouterLiveStream = '/live-stream';
const kRouterLive = '/live';
const kRouterCreatePost = '/create-post';

const kRouterRRCAvatarGeneration = '/rrc-avatar-generation';

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

    // * SplashPage
    initRoute(kRouterBase, (props) => SplashPage());

    // * LoginPage
    initRoute(kRouterLogin, (props) => LoginPage());

    // * PincodeRegisterPage
    initRoute<String>(
      kRouterPincodeRegister,
      (props) => PinCodeRegistrationPage(mnemonic: props!),
    );

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

    // * Pincode Signin Page
    initRoute(kRouterLoginPincode, (props) => PinCodePage());

    // * Email page for access code
    initRoute(kRouterEmail, (props) => EmailPage());

    // * Access code user id input page
    initRoute<String>(
      kRouterAccessCodeUserId,
      (props) => AccessCodeUserIdPage(email: props.toString()),
    );

    initRoute<Map<String, dynamic>>(
      kRouterAccessCodeConfirm,
      (props) => AccessCodeConfirmPage(props: props!),
    );

    // * MainPage
    initRoute(kRouterMain, (props) => InSoBlokPage());

    // * AccountPage
    initRoute<UserModel>(kRouterAccount, (props) => AccountPage(user: props));

    // * UpdateAccountPage
    initRoute(kRouterAccountUpdate, (props) => UpdateProfilePage());

    // * AccountAvatarPage
    initRoute<Map<String, String?>>(
      kRouterAccountAvatar,
      (props) => AccountAvatarPage(src: props?["src"], dst: props?["dst"]),
    );

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

    // * WalletSendPage
    initRoute(kRouterWalletSend, (props) => WalletSendPage());

    initRoute(kRouterWalletSendOne, (props) => WalletSendOnePage());

    initRoute(kRouterWalletSearch, (props) => WalletSearchPage());

    // * WalletReceivePage
    initRoute(kRouterWalletReceive, (props) => WalletReceivePage());

    initRoute(
      kRouterWalletReceiveConfirm,
      (props) => WalletReceiveConfirmPage(),
    );

    // * CreateRoomPage
    initRoute(kRouterCreateRoom, (props) => CreateRoomPage());

    // * MessagePage
    initRoute<MessagePageData>(
      kRouterMessage,
      (props) => MessagePage(data: props!),
    );

    // * MessageSettingPage
    initRoute(kRouterMessageSetting, (props) => MessageSettingPage());

    // * ChatViewPage
    initRoute(kRouterChatView, (props) => ChatView());

    // * ArchivedChatViewPage
    initRoute(kRouterArchivedChatView, (props) => ArchivedChatViewPage());

    // * MessagePaymentFirstPage
    initRoute<Map<String, String>>(
      kRouterChatPayment,
      (props) => ChatPaymentPage(args: props!),
    );

    // * PaymentAmountPage
    initRoute<Map<String, dynamic>>(
      kRouterPaymentAmount,
      (props) => PaymentAmountPage(args: props!),
    );

    // * PaymentConfirmPage
    initRoute<Map<String, dynamic>>(
      kRouterPaymentConfirm,
      (props) => PaymentConfirmPage(args: props!),
    );

    // * PaymentResultPage
    initRoute(kRouterPaymentResult, (props) => PaymentResultPage());

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
    initRoute<String?>(
      kRouterAddStory,
      (props) => AddStoryPage(videoPath: props),
    );

    // * StoryDetailPage
    initRoute<StoryModel>(
      kRouterStoryDetail,
      (props) => StoryDetailPage(story: props!),
    );

    initRoute<StoryModel>(
      kRouterLookbookDetail,
      (props) => LookbookDetailPage(story: props!),
    );

    initRoute<StoryModel>(
      kRouterReaction,
      (props) => ReactionsPage(story: props!),
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

    // * SearchPage
    initRoute(kRouterSearch, (props) => SearchView());

    // * Create Post (DeepAR capture)
    initRoute(kRouterCreatePost, (props) => const CreatePostPage());

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

    // * FaceDetailPage
    // initRoute<Map<String, dynamic>>(
    //   kRouterFaceDetail,
    //   (props) => FaceDetailPage(
    //     storyID: props!['storyID'],
    //     url: props['url'],
    //     face: props['face'],
    //   ),
    // );

    initRoute<Map<String, dynamic>>(kRouterFaceDetail, (props) {
      if (props == null) {
        throw ArgumentError('Route parameters are null');
      }
      if (!props.containsKey('storyID') ||
          !props.containsKey('url') ||
          !props.containsKey('face') ||
          !props.containsKey('annotations') ||
          !props.containsKey('editable')) {
        throw ArgumentError('Missing required route parameters');
      }
      return FaceDetailPage(
        storyID: props['storyID'],
        url: props['url'],
        face: props['face'],
        annotations: props['annotations'],
        editable: props['editable'],
      );
    });

    initRoute<Map<String, dynamic>>(kRouterReactionVideoDetail, (props) {
      if (props == null) {
        throw ArgumentError('Route parameters are null');
      }
      if (!props.containsKey('storyID') ||
          !props.containsKey('url') ||
          !props.containsKey('videoPath')) {
        throw ArgumentError('Missing required route parameters');
      }
      return ReactionVideoDetailPage(
        storyID: props['storyID'],
        url: props['url'],
        videoPath: props['videoPath'],
        editable: props['editable'],
      );
    });

    // * UserListPage
    initRoute<List<UserModel>>(
      kRouterUserList,
      (props) => UserListPage(users: props ?? []),
    );

    initRoute(
      kRouterVideoEditor,
      (props) => VideoEditorPage(path: props.toString()),
    );

    initRoute(
      kRouterImageEditor,
      (props) => ImageEditorPage(path: props.toString()),
    );

    initRoute(kRouterFavorites, (props) => WalletFavoritesPage());

    initRoute<Map<String, dynamic>>(
      kRouterTokenDetail,
      (props) => TokenDetailPage(network: props!),
    );

    // * Live pages
    initRoute(kRouterLiveStream, (props) => LiveStreamPage());
    initRoute(kRouterLive, (props) => LivePage());

    initRoute<Map<String, dynamic>>(kRouterRRCAvatarGeneration, (props) {
      if (props == null) {
        throw ArgumentError('Route parameters are null');
      }
      if (!props.containsKey('face') ||
          !props.containsKey('url') ||
          !props.containsKey('origin') ||
          !props.containsKey('storyID')) {
        throw ArgumentError('Missing required route parameters');
      }
      return homes.RRCAvatarGenerationView(
        face: props['face'],
        url: props['url'],
        origin: props['origin'],
        storyID: props['storyID'],
      );
    });
  }
}
