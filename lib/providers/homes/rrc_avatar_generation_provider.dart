import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:insoblok/models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:insoblok/pages/pages.dart';
import 'package:insoblok/routers/router.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/locator.dart';


class RRCAvatarGenerationProvider extends InSoBlokViewModel {
  
  late BuildContext _context;
  BuildContext get context => _context;
  set context(BuildContext context) {
    _context = context;
    notifyListeners();
  }
  
  final TIMER_LENGTH = 3;

  final avatarTemplates = [
    AIImages.avatarAnimeEyes,
    AIImages.avatarLiquidChromeFace,
    AIImages.avatarPixelStorm,
    AIImages.avatarCyberPunk,
    AIImages.avatarNeonGlow,
    AIImages.avatarTasteScore,
    AIImages.avatarEGirlBoy,
    AIImages.avatarExtraAF,
    AIImages.avatarGlowUp,
    AIImages.avatarGrungeWave
  ];

  final prompts = [
    "Hyper Anime Eyes (exaggerated, glossy manga eyes with sparkle & emotion burst)",
    "Molten Liquid Chrome (reflective, morphing metallic skin, futuristic sheen)",
    "8-Bit Pixel Stormer (digital static, exploding pixel blocks, glitch storm)",
    "Neon Cyberpunk Rebel (glowing circuits, urban dystopia, holographic mask)",
    "Ultraviolet Neon Core (electric outlines, glowing edges, rave aesthetic)",
    "TasteScore Oracle (reputation mask, glowing meter, holographic score halo)",
    "Alt E-Core Icon (layered streetwear, dyed streak hair, glitch aura)",
    "Overloaded Drip Lord (bling, stickers, chaos, maximalist flex)",
    "Radiant Glow-Up Aura (ethereal lighting, soft gradients, sparkling",
    "Retro Grungewave Punk (90s grit + vaporwave neon overlays, cracked textures)",
  ];


  String? media;

  int tappedImage = -1;
  bool isSelected = false;

  int count = 0;
  Timer? _timer;
  bool isRunning = false;

  File? face;
  
  File? result;

  bool isPosting = false;

  void init(String image, File face) {

    logger.d("initial imageurl is $image");
    media = image;
    this.face = face;
  }

  void setTappedImage(int index) {
    tappedImage = index;
    notifyListeners();
  }

  void handleTapImage(int index) {
    if (index < 0) return;
    if (tappedImage == index) {
      isSelected = true;
      _startTimer();
      notifyListeners();
      return;
    }
    isSelected = false;
    result = null;
    _stopTimer();
    setTappedImage(index);
    notifyListeners();
  }


  void _startTimer() {
    if (isRunning) return; // avoid multiple timers
    isRunning = true;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      count ++;
      logger.d("count is $count");
      if (count > TIMER_LENGTH ) {
        _stopTimer();
        result = await requestSelfieImageToProcess();
      }
      notifyListeners();
    });
  } 

  void _stopTimer() {
    _timer?.cancel();
    isRunning = false;
    count = 0;
  }

  void _resetTimer() {
    _stopTimer();
    count = 0;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<File?> requestSelfieImageToProcess() async {
    File? result;
    try {
      logger.d("Started request. ${face?.path}");
      final base64Image = await AIHelpers.image2Base64(face?.path ?? "");

      final body = jsonEncode({
        "prompt": prompts[tappedImage],
        "image": base64Image,
      });
      logger.d("prompt is ${prompts[tappedImage]}");

      // 4️⃣ Send POST request
      final response = await http.post(
        Uri.parse("$AVATAR_SERVER_ENDPOINT/generate"),
        headers: {
          "Content-Type": "application/json",
        },
        body: body,
      );
      logger.d("response is ${response.body}");
      // 5️⃣ Handle response
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("✅ Success: $data");
        result = await AIHelpers.base642Image(data["output"], "result.jpg");
      } else {
        print("❌ Error: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      logger.e(e);
      throw Exception(e);
    }
    return result; 
  }

  void togglePost() {
    isPosting = !isPosting;
    notifyListeners();
  }
}