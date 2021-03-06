import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_chat_app/ui/index.dart';

import 'index.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_chat_app/statemangement/index.dart';

const _chars = 'AabCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random();

extension ExtendedTimeStamp on Timestamp {
  String convertToString([String format]) => dateFormat(
        this.toDate(),
        format: format,
      );
}

extension ExtendedString on String {
  ///String to date
  DateTime get toDate => stringToDate(this);

  ///format String date to Firebird Date
  String dateToStringWithFormat([String dateFormat]) =>
      formatDate(this.toDate, dateFormat);

  ///String to INT
  int get toInt => int.tryParse(
        this,
      );

  ///String to Double
  double get toDouble => double.tryParse(
        this,
      );

  ///Replace single Inverted comma to double inverted comma
  String get removeInvertedComma => this?.replaceAll('\'', '\'\'')?.trim();

  ///Convert CommaSeparatedList to List<int>
  List<int> get convertToCommaSepartedList {
    final _list = this?.split(',')?.map((e) => e.toInt)?.toList();
    print(_list);
    _list.sort();
    print(_list);
    return _list;
  }

  String replaceTwiceWithComma({
    String from,
    String to,
    String from2,
    String to2,
  }) =>
      this
          .replaceFirst(',', '')
          .replaceAll(from, to)
          .replaceAll(from2, to2)
          .trim();

  String replace({
    String from,
    String to,
  }) =>
      this.replaceAll(from, to);

  String replaceTwice({
    String from,
    String to,
    String from2,
    String to2,
  }) =>
      this.replaceAll(from, to).replaceAll(from2, to2).trim();

  String get boolToStr => this
      .toString()
      .replaceAll('false', 'No')
      .replaceAll('true', 'Yes')
      .replaceAll('null', 'No ')
      .trim();

  Future get toNamed => Get.toNamed(this);

  Future get offAllNamed => Get.offAllNamed(this);

  Future get offNamed => Get.offNamed(this);
  bool get active => this == Get.currentRoute;
  AuthState get convertToAuthState {
    switch (this) {
      case 'Login':
        return AuthState.Login;
        break;
      case 'ForgotPass':
        return AuthState.ForgotPass;
        break;
      case 'Registration':
        return AuthState.Registration;
        break;

      default:
        return null;
        break;
    }
  }
}

extension ExtendedType on Type {
  String get convertToString {
    switch (this) {
      case UserModel:
        return 'User';
        break;
      default:
        return this.toString();
        break;
    }
  }
}

extension ExtendedInt on int {
  String get getRandomString => String.fromCharCodes(
        Iterable.generate(
          this,
          (_) => _chars.codeUnitAt(
            _rnd.nextInt(_chars.length),
          ),
        ),
      );
}

extension ExtendedDouble on double {
  EdgeInsetsGeometry get padAll => EdgeInsets.all(this);

  EdgeInsetsGeometry get padSymHORT => EdgeInsets.symmetric(horizontal: this);
  EdgeInsetsGeometry get padSymVERT => EdgeInsets.symmetric(vertical: this);

  EdgeInsetsGeometry get padLEFT => EdgeInsets.only(left: this);
  EdgeInsetsGeometry get padRIGHT => EdgeInsets.only(right: this);
  EdgeInsetsGeometry get padTOP => EdgeInsets.only(top: this);
  EdgeInsetsGeometry get padBOTTOM => EdgeInsets.only(bottom: this);
  Widget get sizedHeight => SizedBox(height: this);
  Widget get sizedWidth => SizedBox(width: this);
}

extension ExtendedWidget on Widget {
  Future to([Bindings bindings]) => Get.to(this, binding: bindings);
  Future offAll([Bindings bindings]) => Get.offAll(this, binding: bindings);
  Future get off => Get.off(this);
  Future openDIALOG() => openDialog(
        child: this,
      );
}

extension SubmitStateExtened on SubmitState {
  bool get loading => this == SubmitState.Loading;
  bool get error => this == SubmitState.Error;
  bool get idle => this == SubmitState.Idle;
  bool get success => this == SubmitState.Success;
}

extension AuthStateExtened on AuthState {
  bool get forgotPass => this == AuthState.ForgotPass;
  bool get login => this == AuthState.Login;
  bool get register => this == AuthState.Registration;
}
