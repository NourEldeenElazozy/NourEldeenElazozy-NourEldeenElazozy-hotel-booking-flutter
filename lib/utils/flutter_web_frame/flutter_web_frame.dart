library flutter_web_frame;

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hotel_booking/core/constants/my_strings.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/constants/my_colors.dart';
import '../../core/themes/themes_controller.dart';
import 'src/frame_content.dart';
import 'src/media_query_observer.dart';

class FlutterWebFrame extends StatefulWidget {
  /// If not [enabled], the [child] is used directly.
  final bool enabled;

  /// The previewed widget.
  ///
  /// It is common to give the root application widget.
  final WidgetBuilder builder;

  /// Background color in white space
  final Color? backgroundColor;

  /// Maximum size
  final Size maximumSize;

  /// Clip behavior
  final Clip clipBehavior;

  const FlutterWebFrame({
    super.key,
    required this.builder,
    this.enabled = true,
    this.backgroundColor,
    required this.maximumSize,
    this.clipBehavior = Clip.none,
  });

  /// A global builder that should be inserted into [WidgetApp]'s builder
  /// to simulated the simulated device screen and platform properties.
  static Widget appBuilder(
    BuildContext context,
    Widget? widget,
  ) {
    if (!_isEnabled(context)) {
      return widget ?? const SizedBox();
    }

    if (!_isEnabled(context)) return widget ?? const SizedBox();

    return MediaQuery(
      data: _mediaQuery(context),
      child: Theme(
        data: Theme.of(context).copyWith(
          visualDensity: _isEnabled(context) ? VisualDensity.standard : null,
        ),
        child: widget ?? const SizedBox(),
      ),
    );
  }

  static MediaQueryData _mediaQuery(BuildContext context) {
    return FrameContent.mediaQuery(
      context,
      context
              .findAncestorStateOfType<FlutterWebFrameState>()
              ?.widget
              .maximumSize ??
          const Size(375.0, 812.0),
    );
  }

  static bool _isEnabled(BuildContext context) {
    final state = context.findAncestorStateOfType<FlutterWebFrameState>();
    return state != null && state.widget.enabled;
  }

  @override
  FlutterWebFrameState createState() => FlutterWebFrameState();
}

class FlutterWebFrameState extends State<FlutterWebFrame> {
  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) {
      return Builder(
        builder: widget.builder,
      );
    }

    return Container(
      color: widget.backgroundColor ?? Theme.of(context).dividerColor,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        child: MediaQueryObserver(
          child: widget.enabled
              ? Builder(builder: _buildPreview)
              : Builder(builder: widget.builder),
        ),
      ),
    );
  }

  Widget _buildPreview(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return FittedBox(
      fit: BoxFit.contain,
      child: RepaintBoundary(
        child: FrameContent(
          size: widget.maximumSize,
          clipBehavior: widget.clipBehavior,
          headerSection: Observer(builder: (context) {
            return GetBuilder<ThemeController>(
                init: ThemeController(),
                builder: (themeController) {
                  return Obx(
                    () => Container(
                      width: 475.0,
                      padding: const EdgeInsets.all(8),
                      color: themeController.isDarkMode.value
                          ? MyColors.scaffoldDarkColor
                          : MyColors.scaffoldLightColor,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            textDirection: TextDirection.ltr,
                            children: [
                              Container(
                                width: 35,
                                // margin: const EdgeInsets.only(left: 15),
                                height: 35,
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: themeController.isDarkMode.value
                                          ? Colors.transparent
                                          : Colors.grey,
                                      blurRadius: 5,
                                      offset: const Offset(0, 0),
                                    ),
                                  ],
                                ),
                                child: SvgPicture.asset(
                                  'assets/icon/app_logo.svg',
                                  width: 10,
                                  height: 10,
                                ),
                              ),
                              Directionality(
                                textDirection: TextDirection.ltr,
                                child: TextButton(
                                  onPressed: () {
                                    Get.offNamedUntil(
                                        '/welcome', (route) => false);
                                    // finish(context);
                                    // commonLaunchUrl(MainSiteUrl);
                                  },
                                  child: Text(MyString.bookNest,
                                      style: TextStyle(
                                          fontFamily: 'Tajawal',
                                          letterSpacing: 0.8,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                          color:
                                              themeController.isDarkMode.value
                                                  ? Colors.white
                                                  : Colors.black),
                                      textDirection: TextDirection.ltr),
                                ),
                              ),
                              const Spacer(),
                              Directionality(
                                textDirection: TextDirection.ltr,
                                child: GestureDetector(
                                  onTap: () {
                                    commonLaunchUrl("https://codecanyon.net/item/booknest-flutter-hotel-booking-app-ui-template-figma-free/52139646");
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    // height: 10,
                                    // height: 44,
                                    // width: 100,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 8),
                                    decoration: BoxDecoration(
                                        color: themeController.isDarkMode.value
                                            ? Colors.white
                                            : Colors.black,
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    child: Text('Buy Now',
                                        textAlign: TextAlign.center,
                                        style: theme.textTheme.bodyLarge
                                            ?.copyWith(
                                                fontWeight: FontWeight.w500,
                                                color: themeController
                                                        .isDarkMode.value
                                                    ? Colors.black
                                                    : Colors.white),
                                        textDirection: TextDirection.ltr),
                                  ),
                                ),
                              ),
                            ],
                          ).paddingOnly(left: 8, right: 8),
                          Divider(
                              height: 1, color: themeController.isDarkMode.value ? MyColors.textPaymentInfo:MyColors.profileListTileColor),
                        ],
                      ),
                    ),
                  );
                });
          }),
          footerSection: Observer(builder: (context) {
            return GetBuilder<ThemeController>(
                init: ThemeController(),
                builder: (themeController) {
                  return Obx(
                    () => Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(0),
                        color: themeController.isDarkMode.value
                            ? MyColors.scaffoldDarkColor
                            : MyColors.scaffoldLightColor,
                      ),
                      width: 475.0,
                      child: Column(
                        children: [
                          Divider(
                              height: 0,
                              color: themeController.isDarkMode.value
                                  ? MyColors.dividerDarkTheme
                                  : MyColors.dividerLightTheme),
                          Text('Copyright © 2024. Crafted with passion by Imperia Themes.',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: themeController.isDarkMode.value
                                          ? Colors.white.withOpacity(0.50)
                                          : Colors.black.withOpacity(0.50)),
                                  textDirection: TextDirection.ltr)
                              .paddingAll(12),
                        ],
                      ),
                    ),
                  );
                });
          }),
          child: Builder(builder: widget.builder),
        ),
      ),
    );
  }
}

Future<bool> commonLaunchUrl(
  String address, {
  LaunchMode launchMode = LaunchMode.inAppWebView,
}) async {
  try {
    await launchUrl(
      Uri.parse(address),
      mode: launchMode,
    );
    return true; // Success
  } catch (e) {
    Get.snackbar(
      'Error',
      'Failed to launch URL: $address',
    );
    return false; // Error
  }
}
