import 'package:stacked/stacked.dart';

import 'package:insoblok/models/models.dart';
import 'package:insoblok/services/services.dart';

abstract class InSoBlokViewModel extends ReactiveViewModel {
  final authService = AuthHelper.service;

  UserModel? get user => AuthHelper.user;

  final UserService _userService = UserService();
  UserService get userService => _userService;

  final _newsService = NewsService();
  NewsService get newsService => _newsService;

  final _storyService = StoryService();
  StoryService get storyService => _storyService;

  final _tastScoreService = TastescoreService();
  TastescoreService get tastScoreService => _tastScoreService;

  final _vtoService = VTOService();
  VTOService get vtoService => _vtoService;

  final _productService = ProductService();
  ProductService get productService => _productService;

  final _messageService = MessageService();
  MessageService get messageService => _messageService;

  final RoomService _roomService = RoomService();
  RoomService get roomService => _roomService;

  final TransferService _transferService = TransferService();
  TransferService get transferService => _transferService;

  final VimeoService _vimeoService = VimeoService();
  VimeoService get vimeoService => _vimeoService;

  final MethodChannelService _methodChannelService = MethodChannelService();
  MethodChannelService get methodChannelService => _methodChannelService;

  @override
  List<ListenableServiceMixin> get listenableServices => [authService];
}
