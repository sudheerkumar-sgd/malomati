import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/core/common/common_utils.dart';
import 'package:malomati/core/extensions/string_extension.dart';
import 'package:malomati/domain/entities/profile_entity.dart';
import 'package:malomati/presentation/ui/widgets/image_widget.dart';
import 'package:malomati/res/drawables/background_box_decoration.dart';
import 'package:malomati/res/drawables/drawable_assets.dart';

const _cardAspectRatio = 310 / 232;
const _photoWidth = 78.0;
const _photoHeight = 96.0;
const _headerDividerHeight = 0.6;
const _flipDuration = Duration(milliseconds: 400);
const _hireDateOutputFormat = 'dd.MM.yyyy';
const _hireDateInputFormats = [
  'dd/MM/yyyy',
  'dd-MMM-yyyy',
  'dd MMM yyyy',
  'yyyy-MM-dd',
  'dd.MM.yyyy',
];

String formatEmployeeCardHireDate(String? raw) {
  if (raw == null || raw.isEmpty) return '';
  for (final format in _hireDateInputFormats) {
    final date = getDateTimeByString(format, raw);
    if (date.year != 0) {
      return getDateByformat(_hireDateOutputFormat, date);
    }
  }
  return raw;
}

const _emiratiNationality = 'United Arab Emirates';

bool isEmiratiNationality(String? nationality) {
  return (nationality ?? '').trim() == _emiratiNationality;
}

bool isFemaleSex(String? sex) {
  return (sex ?? '').trim().toUpperCase() == 'F';
}

String employeeCardPlaceholderPath({
  String? nationality,
  String? sex,
}) {
  final emirati = isEmiratiNationality(nationality);
  final female = isFemaleSex(sex);
  if (emirati && female) return DrawableAssets.icPlaceholderEmiratiWoman;
  if (emirati) return DrawableAssets.icPlaceholderEmiratiMale;
  if (female) return DrawableAssets.icPlaceholderOtherWoman;
  return DrawableAssets.icPlaceholderOtherMale;
}

List<InlineSpan> employeeCardNumberSpans(
  String text,
  TextStyle textStyle,
  TextStyle numberStyle,
) {
  final matches = RegExp(r'[0-9][0-9+.\s:-]*').allMatches(text);
  if (matches.isEmpty) {
    return [TextSpan(text: text, style: textStyle)];
  }
  final spans = <InlineSpan>[];
  var start = 0;
  for (final match in matches) {
    if (match.start > start) {
      spans.add(TextSpan(
        text: text.substring(start, match.start),
        style: textStyle,
      ));
    }
    spans.add(TextSpan(text: match.group(0), style: numberStyle));
    start = match.end;
  }
  if (start < text.length) {
    spans.add(TextSpan(text: text.substring(start), style: textStyle));
  }
  return spans;
}

class EmployeeCardWidget extends StatefulWidget {
  final ProfileEntity profile;
  const EmployeeCardWidget({required this.profile, super.key});

  @override
  State<EmployeeCardWidget> createState() => _EmployeeCardWidgetState();
}

class _EmployeeCardWidgetState extends State<EmployeeCardWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _flipController;

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      vsync: this,
      duration: _flipDuration,
    );
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  void _flip() {
    if (_flipController.isAnimating) return;
    if (_flipController.value < 0.5) {
      _flipController.forward();
    } else {
      _flipController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final resources = context.resources;
    return Container(
      width: double.infinity,
      decoration: BackgroundBoxDecoration(
        boxColor: resources.color.colorWhite,
        radious: resources.dimen.dp30,
      ).topCornersBox,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            resources.dimen.dp20,
            resources.dimen.dp20,
            resources.dimen.dp20,
            resources.dimen.dp20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      context.string.employeeCard,
                      style: context.textFontWeight600
                          .onFontSize(resources.fontSize.dp16)
                          .onColor(resources.color.textColor212B4B),
                    ),
                  ),
                  Semantics(
                    button: true,
                    label: context.string.close,
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
                      child: ImageWidget(
                        path: DrawableAssets.icCross,
                        width: resources.dimen.dp14,
                        height: resources.dimen.dp14,
                        padding: EdgeInsets.all(resources.dimen.dp5),
                      ).loadImageWithMoreTapArea,
                    ),
                  ),
                ],
              ),
              SizedBox(height: resources.dimen.dp15),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  GestureDetector(
                    onTap: _flip,
                    child: AnimatedBuilder(
                      animation: _flipController,
                      builder: (context, _) {
                        final angle = _flipController.value * math.pi;
                        final isFront = angle <= math.pi / 2;
                        return Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()
                            ..setEntry(3, 2, 0.001)
                            ..rotateY(angle),
                          child: isFront
                              ? _cardFace(context, isFront: true)
                              : Transform(
                                  alignment: Alignment.center,
                                  transform: Matrix4.identity()
                                    ..rotateY(math.pi),
                                  child: _cardFace(context, isFront: false),
                                ),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    top: -resources.dimen.dp10,
                    right: -resources.dimen.dp8,
                    child: Semantics(
                      button: true,
                      label: context.string.flipEmployeeCard,
                      child: Material(
                        color: resources.color.colorWhite,
                        shape: const CircleBorder(),
                        elevation: 3,
                        shadowColor: resources.color.colorBlack.withAlpha(40),
                        child: InkWell(
                          onTap: _flip,
                          customBorder: const CircleBorder(),
                          child: SizedBox(
                            width: resources.dimen.dp30,
                            height: resources.dimen.dp30,
                            child: Icon(
                              Icons.autorenew,
                              size: resources.dimen.dp17,
                              color: resources.color.textColorLight,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cardFace(BuildContext context, {required bool isFront}) {
    final resources = context.resources;
    final radius = resources.dimen.dp15;
    return Directionality(
      textDirection: TextDirection.ltr,
      child: AspectRatio(
        aspectRatio: _cardAspectRatio,
        child: Container(
          width: double.infinity,
          decoration: BackgroundBoxDecoration(
            boxColor: resources.color.colorWhite,
            radious: radius,
            boarderColor: resources.color.colorD6D6D6,
            boarderWidth: 0.5,
            shadowColor: resources.color.colorBlack.withAlpha(20),
            shadowBlurRadius: 12,
            shadowOffset: const Offset(0, 2),
          ).roundedCornerBoxWithShadow,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(radius),
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      resources.dimen.dp20,
                      resources.dimen.dp20,
                      resources.dimen.dp20,
                      resources.dimen.dp25,
                    ),
                    child: Column(
                      children: [
                        _cardHeader(context),
                        SizedBox(height: resources.dimen.dp12),
                        Expanded(
                          child: isFront
                              ? _frontBody(context)
                              : SingleChildScrollView(
                                  physics: const ClampingScrollPhysics(),
                                  padding: EdgeInsets.only(
                                    bottom: resources.dimen.dp10,
                                  ),
                                  child: _backBody(context),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: resources.dimen.dp15,
                  width: double.infinity,
                  color: resources.color.viewBgColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _cardHeader(BuildContext context) {
    final resources = context.resources;
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ImageWidget(
              path: DrawableAssets.icGovUAQ,
              width: resources.dimen.dp75,
              height: resources.dimen.dp30,
            ).loadImage,
            const Spacer(),
            ImageWidget(
              path: DrawableAssets.icSmartUAQ,
              width: resources.dimen.dp75,
              height: resources.dimen.dp30,
            ).loadImage,
          ],
        ),
        SizedBox(height: resources.dimen.dp8),
        Container(
          height: _headerDividerHeight,
          width: double.infinity,
          color: resources.color.colorD6D6D6,
        ),
      ],
    );
  }

  Widget _frontBody(BuildContext context) {
    final resources = context.resources;
    final arabicName = widget.profile.FULL_NAME_AR ?? '';
    final englishName = widget.profile.FULL_NAME_US ?? '';
    final jobNameAr = widget.profile.JOB_NAME_AR ?? '';
    final jobNameEn = widget.profile.JOB_NAME ?? '';
    return Column(
      children: [
        Text.rich(
          TextSpan(
            style: context.textFontWeight600
                .onFontSize(resources.fontSize.dp12)
                .onColor(resources.color.viewBgColor),
            children: [
              TextSpan(
                text: context.string.employeeCardPrintedEn,
                style: const TextStyle(fontFamily: fontFamilyEN),
              ),
              const TextSpan(text: '  •  '),
              TextSpan(
                text: context.string.employeeCardPrintedAr,
                style: const TextStyle(fontFamily: fontFamilyAR),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: resources.dimen.dp15),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _photoPlaceholder(context),
              SizedBox(width: resources.dimen.dp12),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (arabicName.isNotEmpty)
                      Text(
                        arabicName,
                        textDirection: TextDirection.rtl,
                        style: context.textFontWeight600
                            .onFontSize(resources.fontSize.dp14)
                            .onFontFamily(fontFamily: fontFamilyAR)
                            .onColor(resources.color.viewBgColor),
                      ),
                    if (jobNameAr.isNotEmpty) ...[
                      SizedBox(height: resources.dimen.dp2),
                      Text(
                        jobNameAr,
                        textDirection: TextDirection.rtl,
                        style: context.textFontWeight400
                            .onFontSize(resources.fontSize.dp10)
                            .onFontFamily(fontFamily: fontFamilyAR)
                            .onColor(resources.color.textColorLight),
                      ),
                    ],
                    SizedBox(height: resources.dimen.dp8),
                    if (englishName.isNotEmpty) ...[
                      SizedBox(height: resources.dimen.dp4),
                      Text(
                        englishName.capitalize(),
                        textAlign: TextAlign.end,
                        style: context.textFontWeight600
                            .onFontSize(resources.fontSize.dp13)
                            .onFontFamily(fontFamily: fontFamilyEN)
                            .onColor(resources.color.textColor212B4B),
                      ),
                    ],
                    if (jobNameEn.isNotEmpty) ...[
                      SizedBox(height: resources.dimen.dp2),
                      Text(
                        jobNameEn,
                        textAlign: TextAlign.end,
                        style: context.textFontWeight400
                            .onFontSize(resources.fontSize.dp10)
                            .onFontFamily(fontFamily: fontFamilyEN)
                            .onColor(resources.color.textColorLight),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _photoPlaceholder(BuildContext context) {
    final resources = context.resources;
    // ponytail: photo is a placeholder until the profile image API is wired
    return ClipRRect(
      borderRadius: BorderRadius.circular(resources.dimen.dp4),
      child: ImageWidget(
        path: employeeCardPlaceholderPath(
          nationality: widget.profile.NATIONALITY,
          sex: widget.profile.SEX,
        ),
        width: _photoWidth,
        height: _photoHeight,
        boxType: BoxFit.cover,
      ).loadImage,
    );
  }

  Widget _backBody(BuildContext context) {
    final resources = context.resources;
    final employeeNumber = widget.profile.EMPLOYEE_NUMBER ?? '';
    final hireDate = formatEmployeeCardHireDate(widget.profile.HIRE_DATE);
    final labelStyle = context.textFontWeight400
        .onFontSize(resources.fontSize.dp11)
        .onFontFamily(fontFamily: fontFamilyAR)
        .onColor(resources.color.textColor212B4B);
    final valueStyle = context.textFontWeight400
        .onFontSize(resources.fontSize.dp11)
        .onFontFamily(fontFamily: fontFamilyEN)
        .onColor(resources.color.textColor212B4B);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: resources.dimen.dp8),
          Text.rich(
            TextSpan(
              text: '${context.string.employeeCardJobNumber} : ',
              style: labelStyle,
              children: [
                TextSpan(text: employeeNumber, style: valueStyle),
              ],
            ),
            textAlign: TextAlign.start,
          ),
          SizedBox(height: resources.dimen.dp2),
          Text.rich(
            TextSpan(
              text: '${context.string.employeeCardHireDate} : ',
              style: labelStyle,
              children: [
                TextSpan(text: hireDate, style: valueStyle),
              ],
            ),
            textAlign: TextAlign.start,
          ),
          SizedBox(height: resources.dimen.dp12),
          Text(
            context.string.employeeCardInstructions,
            textAlign: TextAlign.start,
            style: context.textFontWeight600
                .onFontSize(resources.fontSize.dp12)
                .onFontFamily(fontFamily: fontFamilyAR)
                .onColor(resources.color.textColor212B4B),
          ),
          SizedBox(height: resources.dimen.dp4),
          _instruction(
            context,
            context.string.employeeCardInstructionWear,
          ),
          _instruction(
            context,
            context.string.employeeCardInstructionProperty,
          ),
          _instruction(
            context,
            context.string.employeeCardInstructionFound,
          ),
        ],
      ),
    );
  }

  Widget _instruction(BuildContext context, String text) {
    final resources = context.resources;
    final style = context.textFontWeight400
        .onFontSize(resources.fontSize.dp9)
        .onFontFamily(fontFamily: fontFamilyAR)
        .onColor(resources.color.textColor212B4B)
        .copyWith(height: 1.4);
    final numberStyle = style.onFontFamily(fontFamily: fontFamilyEN);
    return Padding(
      padding: EdgeInsets.only(bottom: resources.dimen.dp2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('•  ', style: style),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: employeeCardNumberSpans(text, style, numberStyle),
              ),
              textAlign: TextAlign.start,
            ),
          ),
        ],
      ),
    );
  }
}
