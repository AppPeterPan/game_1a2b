import 'package:flutter/material.dart';
import 'package:game_1a2b/l10n.dart';
import 'package:http/http.dart' as http;
import 'package:rating_dialog/rating_dialog.dart';

class WebInAppReview extends StatelessWidget {
  const WebInAppReview({super.key});

  @override
  Widget build(BuildContext context) {
    return RatingDialog(
      starSize: 35,
      initialRating: 0,
      title: Text(
        AppLocalizations.of(context)!.rateTitle,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
      message: Text(
        AppLocalizations.of(context)!.rateContent,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 15),
      ),
      image: const Icon(
        Icons.rate_review,
        color: Colors.blueGrey,
        size: 120,
      ),
      submitButtonText: AppLocalizations.of(context)!.submitBtn,
      commentHint: AppLocalizations.of(context)!.commentHint,
      onSubmitted: (response) {
        http.get(
          Uri.https('corsproxy.io', '/', {
            Uri.encodeFull(Uri.https(
                'docs.google.com',
                '/forms/d/e/1FAIpQLScHznDs6xzF-1yM1T2kY-oNCfUOrMaU63xfzfFLVOxHiehJ5w/formResponse',
                {
                  'usp': 'pp_url',
                  'entry.2074980730': 'com.gmail.app97204.numbergame',
                  'entry.905102409': '${response.rating}',
                  'entry.1257025373': response.comment,
                }).toString()): ''
          }),
        );
      },
    );
  }
}
