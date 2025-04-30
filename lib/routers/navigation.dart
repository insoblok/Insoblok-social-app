import 'package:flutter/material.dart';

import 'package:fluro/fluro.dart' as fluro;

import 'package:insoblok/models/models.dart';
import 'package:insoblok/pages/pages.dart';

const kRouterBase = '/';
const kRouterLogin = '/login';
const kRouterRegister = '/register';
const kRouterMain = '/main';

const kRouterAccount = '/account';
const kRouterAccountAvatar = '/account-avatar';
const kRouterAccountPost = '/account-post';
const kRouterAccountTopic = '/account-topic';
const kRouterAccountBookmark = '/account-bookmark';
const kRouterAccountMoment = '/account-moment';

const kRouterCreateRoom = '/create-room';
const kRouterMessage = '/message';
const kRouterMessageSetting = '/message-setting';

const kRouterAddStory = '/add-story';
const kRouterStoryDetail = '/story-detail';

const kRouterQuillDescription = '/quill-description';
const kRouterPrivacy = '/privacy-police';
const kRouterHelpCenter = '/help-center';
const kRouterSetting = '/setting';

class Navigation {
  final router = fluro.FluroRouter();

  Navigation() {
    defineRoutes();
  }

  defineRoutes() {
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
    initRoute(kRouterRegister, (props) => RegisterPage());

    // * MainPage
    initRoute(kRouterMain, (props) => InSoBlokPage());

    // * AccountPage
    initRoute<UserModel>(kRouterAccount, (props) => AccountPage(user: props));

    // * AccountAvatarPage
    initRoute(kRouterAccountAvatar, (props) => AvatarPage());

    // * AccountListPage
    initRoute(kRouterAccountPost, (props) => PostsPage());

    // * AccountTopicPage
    initRoute(kRouterAccountTopic, (props) => TopicPage());

    // * AccountBookmarkPage
    initRoute(kRouterAccountBookmark, (props) => BookmarkPage());

    // * AccountMomentPage
    initRoute(kRouterAccountMoment, (props) => MomentPage());

    // * CreateRoomPage
    initRoute(kRouterCreateRoom, (props) => CreateRoomPage());

    // * MessagePage
    initRoute<MessagePageData>(
      kRouterMessage,
      (props) => MessagePage(data: props!),
    );

    // * MessageSettingPage
    initRoute(kRouterMessageSetting, (props) => MessageSettingPage());

    // * AddStoryPage
    initRoute(kRouterAddStory, (props) => AddStoryPage());

    // * StoryDetailPage
    initRoute<StoryModel>(
      kRouterStoryDetail,
      (props) => StoryDetailPage(story: props!),
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
  }
}
