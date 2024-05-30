import 'package:firebase_manager/firebase_manager.dart';
import 'package:flutter/material.dart';

class FmDataSingleMatcher<T> extends StatelessWidget {
  final AbsSingleBinder<T> binder;

  final Widget Function(BuildContext context, T dataset) builder;
  const FmDataSingleMatcher(
      {required this.binder, required this.builder, super.key});
  @override
  Widget build(BuildContext context) {
    Log.debug(() =>
        'data_single_matcher.dart path:${binder.getLogInfo()} path: build');
    return StreamBuilder(
      stream: binder.getData(),
      builder: (context, snapshot) {
        Log.debug(() =>
            'data_single_matcher.dart path:${binder.getLogInfo()} data: ${snapshot.data}');
        if (snapshot.hasError) {
          final error = snapshot.error;
          print("DataSingleMatcherError:$error");
          return Center(child: Text(error.toString()));
        }

        if (snapshot.connectionState != ConnectionState.waiting) {
          if (snapshot.data == null) {
            Log.debug(() =>
                'data_single_matcher.dart path:${binder.getLogInfo()} has data but data is null');
          }
          final dataset = snapshot.data as T;
          return builder(context, dataset);
        } else {
          Log.debug(() =>
              'data_single_matcher.dart path:${binder.getLogInfo()} no data');
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
