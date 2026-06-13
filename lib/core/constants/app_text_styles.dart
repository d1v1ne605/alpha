import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextStyles {
  static final heading1 = TextStyle(
    fontSize: AppSize.size34.sp,
    fontWeight: FontWeight.w700,
  );

  static final heading2 = TextStyle(
    fontSize: AppSize.size24.sp,
    fontWeight: FontWeight.w600,
  );

  static final title1 = TextStyle(
    fontSize: AppSize.size20.sp,
    fontWeight: FontWeight.w700,
  );

  static final title2 = TextStyle(
    fontSize: AppSize.size16.sp,
    fontWeight: FontWeight.w600,
  );

  static final subtitle = TextStyle(
    fontSize: AppSize.size16.sp,
    fontWeight: FontWeight.w400,
  );
  static TextStyle content5 = TextStyle(
    fontSize: AppSize.size18.sp,
    fontWeight: FontWeight.w400,
  );
  static TextStyle content4 = TextStyle(
    fontSize: AppSize.size16.sp,
    fontWeight: FontWeight.w500,
  );
  static TextStyle content3 = TextStyle(
    fontSize: AppSize.size14.sp,
    fontWeight: FontWeight.w700,
  );
  static TextStyle content2 = TextStyle(
    fontSize: AppSize.size12.sp,
    fontWeight: FontWeight.w400,
  );

  static TextStyle content1 = TextStyle(
    fontSize: AppSize.size10.sp,
    fontWeight: FontWeight.w400,
  );

  static final primaryLabel = TextStyle(
    fontSize: AppSize.size14.sp,
    fontWeight: FontWeight.w600,
  );

  static final body = TextStyle(
    fontSize: AppSize.size14.sp,
    fontWeight: FontWeight.w400,
  );

  static final subBody = TextStyle(
    fontSize: AppSize.size14.sp,
    fontWeight: FontWeight.w300,
  );

  static final caption = body.copyWith(fontSize: AppSize.size12.sp);

  static final smallTextButton = TextStyle(
    fontSize: AppSize.size14.sp,
    fontWeight: FontWeight.w500,
  );
  static final mediumTextButton = TextStyle(
    fontSize: AppSize.size14.sp,
    fontWeight: FontWeight.w700,
  );
  static final largeTextButton = mediumTextButton.copyWith();
  static final appbarTitle = content5.copyWith(fontWeight: FontWeight.w600);
  static final number1 = TextStyle(
    fontSize: AppSize.size36.sp,
    fontWeight: FontWeight.w700,
    fontFamily: "IBM Plex Sans",
    fontStyle: FontStyle.italic,
  );
  static final smallText = TextStyle(
    fontSize: AppSize.size8.sp,
    fontWeight: FontWeight.w400,
  );
}
