import 'package:firebase_manager/firebase_manager.dart';
import 'package:flutter/material.dart';

class FmDataMatcher<T extends FmMatcherDataset> extends StatelessWidget {
  final AbsDataBinder<T> binder;

  final Widget Function(BuildContext context, T dataset) builder;
  const FmDataMatcher({required this.binder, required this.builder, super.key});
  @override
  Widget build(BuildContext context) {
    Log.debug(() => 'data_matcher.dart build');
    return StreamBuilder(
      stream: binder.getDataset(),
      builder: (context, snapshot) {
        Log.debug(() => 'data_matcher.dart data: ${snapshot.data}');
        if (snapshot.hasError) {
          final error = snapshot.error;
          print("DataSingleMatcherError: $error");
          return Center(child: Text(error.toString()));
        }
        if (snapshot.connectionState != ConnectionState.waiting) {
          final dataset = snapshot.data as T;
          return builder(context, dataset);
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
