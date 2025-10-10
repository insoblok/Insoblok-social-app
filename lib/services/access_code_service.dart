import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:insoblok/extensions/extensions.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/services/services.dart';

class AccessCodeService {
  final CollectionReference<Map<String, dynamic>> _accessCodeCollection =
      FirebaseFirestore.instance.collection('accessCodes');

  Future<String> generateAccessCode() async {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#\$%^&*()_-+=[]{}|;:,.<>?';
    final random = Random();
    String code = '';
    for (int i = 0; i < 6; i ++) {
      code += chars[random.nextInt(chars.length)];
    }
    return code;
  }

  Future<AccessCodeModel?> createAccessCode(AccessCodeModel code) async {
    var snapShot = await _accessCodeCollection.where('email', isEqualTo: code.email).get();
    if(snapShot.docs.isNotEmpty) return null;
    try {
      if (code.accessCode == null) { 
        code = code.copyWith(
          accessCode: await generateAccessCode()
        );
      }
      var doc = await _accessCodeCollection.add(code.toMap());
      return code.copyWith(id: doc.id);
    } on FirebaseException catch (e) {
      logger.e(e.message);
    } catch (e) {
      logger.e(e);
    }
    return null;
  }

  Future<bool> checkAccessCodeByEmail(String email) async {
    var snapShot = await _accessCodeCollection.where('email', isEqualTo: email).get();
    if (snapShot.docs.isNotEmpty) {
      Map<String, dynamic> data = snapShot.docs.first.data();
      return data['checked'] ?? false;
    }
    else {
      return false;
    }
  }

  Future<AccessCodeModel?> getAccessCodeByEmail(String email) async {
    var snapShot = await _accessCodeCollection.where('email', isEqualTo: email).get();
    if(snapShot.docs.isEmpty) return null;
    return AccessCodeModel.fromJson(snapShot.docs.first.data()); 
  }

  Future<void> updateChecked(String email) async {
    final snapShot = await _accessCodeCollection.where('email', isEqualTo: email).get();
    if (snapShot.docs.isNotEmpty) {
      final doc = snapShot.docs.first;
      await doc.reference.update({
        "checked": true
      });
    }


  }

}