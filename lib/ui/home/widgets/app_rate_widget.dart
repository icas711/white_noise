/*import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rate_my_app/rate_my_app.dart';

Future<void> showRateApp(RateMyApp rateMyApp, BuildContext context) {

    return
      rateMyApp.showRateDialog(
        context,
        title: AppLocalizations.of(context)!.titleRate,
        // The dialog title.
        message: AppLocalizations.of(context)!.contextRate,
        rateButton: AppLocalizations.of(context)!.rateButton,
        // The dialog "rate" button text.
        noButton: AppLocalizations.of(context)!.noButton,
        // The dialog "no" button text.
        laterButton: AppLocalizations.of(context)!.laterButton,
        // The dialog "later" button text.
        listener: (button) {
          // The button click listener (useful if you want to cancel the click event).
          switch (button) {
            case RateMyAppDialogButton.rate:
              print('Clicked on "Rate".');
              break;
            case RateMyAppDialogButton.later:
              print('Clicked on "Later".');
              break;
            case RateMyAppDialogButton.no:
              print('Clicked on "No".');
              break;
          }

          return true; // Return false if you want to cancel the click event.
        },
        ignoreNativeDialog: Platform.isAndroid,
        // Set to false if you want to show the Apple's native app rating dialog on iOS or Google's native app rating dialog (depends on the current Platform).
        dialogStyle: const DialogStyle(
          messageStyle: TextStyle(fontFamily: 'Roboto'),
          titleStyle: TextStyle(fontFamily: 'Roboto'),
        ),
        // Custom dialog styles.
        onDismissed: () => rateMyApp.callEvent(RateMyAppEventType
            .laterButtonPressed), // Called when the user dismissed the dialog (either by taping outside or by pressing the "back" button).
        //contentBuilder: (context, defaultContent) => content, // This one allows you to change the default dialog content.
        // actionsBuilder: (context) => [], // This one allows you to use your own buttons.
      );

  }*/

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rate_my_app/rate_my_app.dart';

Future<void> showRateApp(RateMyApp rateMyApp, BuildContext context) {
  return rateMyApp.showStarRateDialog(
    context,
    title: AppLocalizations.of(context)!.titleRate,
    // The dialog title.
    message: AppLocalizations.of(context)!.contextRate,
    actionsBuilder: (context, stars) {
      // Triggered when the user updates the star rating.
      return [
        Center(
          child: CupertinoButton(
            color: CupertinoColors.white.withOpacity(0.7),
            onPressed: () async {
              print('Thanks for the ' +
                  (stars == null ? '0' : stars.round().toString()) +
                  ' star(s) !');
              await rateMyApp.callEvent(RateMyAppEventType.rateButtonPressed);
              Navigator.pop<RateMyAppDialogButton>(
                  context, RateMyAppDialogButton.rate);
            },
            child: Text('OK'),
          ),
        ),
      ];
    },

    ignoreNativeDialog: Platform.isAndroid,
    // Set to false if you want to show the Apple's native app rating dialog on iOS or Google's native app rating dialog (depends on the current Platform).
    dialogStyle: const DialogStyle(
      messageStyle: TextStyle(fontFamily: 'Roboto'),
      titleStyle: TextStyle(fontFamily: 'Roboto'),
    ),
    starRatingOptions: const StarRatingOptions(),
    // Custom star bar rating options.
    onDismissed: () =>
        rateMyApp.callEvent(RateMyAppEventType.laterButtonPressed),
  );
}


