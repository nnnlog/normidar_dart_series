# FirebaseManager

⚠️ This README file may not be true, you should check the code and test it before you use it. (See the example is best for use it)

A way to manage Firebase easily in Flutter.

## setup your application by FirebaseManager

steps:

1. add the FirebaseManager library to your `pubspec.yaml` file of your project
2. run shell(after you add or remove login provider on firebase you should redo this):

```shell
firebase login
dart pub global activate flutterfire_cli
flutter pub add firebase_core
flutterfire configure
```

3. change your main method like:

```dart
import 'package:firebase_manager/firebase_manager.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

void main() async {
  fs.initApp(
      options: DefaultFirebaseOptions.currentPlatform,
      appName: 'your_app_name',
      isDebug: false,
      runApp: () async {
        runApp(const MyApp());
      });
}
```

4. Switch on your using services on Firebase site, like Database, Authentication, Storage...
   1. if you use Authentication for Android do `cd android`, `./gradlew signingReport` and copy your SHA1 and SHA-256 to your [Firebase > project settings]
5. Build and fix your project errors, see **Android Build Error**

## Android google auth

You should run `./gradlew signingReport` on your Android folder.

If needed you should run before that:

```
eval "$(jenv init -)"
jenv add /Library/Java/JavaVirtualMachines/jdk-11.0.15.1.jdk/Contents/Home
jenv versions
jenv local oracle64-11.0.15.1
```

After `./gradlew signingReport` finished you should copy the SHA1 and SHA-256 to your Firebase project settings.

After this, you should rerun `flutterfire configure`

## Android Build Error

if need do this:

in `android/app/build.gradle` `android{defaultConfig{...}}` modify to `minSdkVersion 19`, add `multiDexEnabled true`.
in same file in `dependencies{...}` add `implementation 'androidx.multidex:multidex:2.0.1'`

in `android/build.gradle` `buildscript{dependencies{...}}` modify to `classpath 'com.google.gms:google-services:4.3.14'`

## get all Firebase features by one instance

use `FirebaseManager.share` or `fs`, they are the same instance.

### How to access Firebase storage?

Use `fs.storage` you can get an instance to access all features in **Firebase storage**

For example:

```dart
final file = await fs.storage.getFileAuto('a/b/c/d.jpg');
```

This example will auto-check the file that exists in the local directory, if not exist it will download the file from Firebase storage.

#### The feature of FilePool

There is a feature named FilePool in FirebaseManager, it keeps files on Firebase using the md5 file name,

#### Get a widget to show the image on the server by file

you can use FmFilePoolImage

## [firestore] gets a random ID doc and gets the id

example:

```dart
final mainColl = fs.fireStore.getMainColl();
final doc = mainColl.getRandomNameDoc();
final id = doc.getID();
```

## If you want to get a map(data) that includes ID

you can use [FireDoc]getIncludeIDMap()

## MacOS

you should add this to your `DebugProfile.entitlements` and `ReleaseProfile.entitlements`

```
	<key>com.apple.security.network.client</key>
	<true/>
```

## If you use [json_serializable](https://pub.dev/packages/json_serializable) and Firestore

You can use `@FirestoreDateTimeConverter()` on your DateTime to convert a DateTime to a JSON serializable and save it to Firestore.

like this:

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:task_manager/dataset/firebase_util/firestore_date_time_converter.dart';
import 'package:cloud_firestore_platform_interface/cloud_firestore_platform_interface.dart';

part 'task_dataset.freezed.dart';
part 'task_dataset.g.dart';

@freezed
class TaskDataset with _$TaskDataset {

  const factory TaskDataset({
    required String task,
    required bool isDone,
    @FirestoreDateTimeConverter() required DateTime? createdAt,
    bool? stared,
  }) = _TaskDataset;

  factory TaskDataset.fromJson(Map<String, dynamic> json) =>
      _$TaskDatasetFromJson(json);
}
```


# TODO

- mssaging