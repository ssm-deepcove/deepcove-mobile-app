import 'dart:io' show File, Directory;

import 'package:archive/archive.dart' show ZipDecoder, Archive, ArchiveFile;
import 'package:discover_deep_cove/data/models/media_file.dart';
import 'package:discover_deep_cove/widgets/misc/text/body_text.dart';
import 'package:discover_deep_cove/widgets/misc/text/heading.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' show Response;
import 'package:meta/meta.dart' show required;
import 'package:path/path.dart' show join;
import 'package:toast/toast.dart';
import 'package:flushbar/flushbar.dart';

/// Container class for general helper functions.
class Util {
  /// Stores the body of the [http.Response] as a file, using the specified
  /// [absPath] and [fileName].
  ///
  /// Will create directories that do not exist.
  static Future<File> httpResponseToFile(
      {@required Response response,
      @required String absPath,
      @required String fileName}) async {
    // TODO: Check for write permission here?

    File file = File(join(absPath, fileName));
    await file.create(recursive: true);
    await file.writeAsBytes(response.bodyBytes);

    return file;
  }

  /// Extract the supplied file [zip] to the supplied directory [dir]
  ///
  /// Returns true if successful.
  static Future<bool> extractZip(
      {@required File zip, @required Directory dir}) async {
    try {
      Archive archive = ZipDecoder().decodeBytes(await zip.readAsBytes());
      // note that [file] may be file OR directory
      // TODO: Look into whether this should be async
      for (ArchiveFile file in archive) {
        if (file.isFile) {
          File(join(dir.path, file.name))
            ..createSync(recursive: true)
            ..writeAsBytesSync(file.content);
        } else {
          // is a directory
          Directory(join(dir.path, file.name))..create(recursive: true);
        }
      }
      return true;
    } catch (ex) {
      print('Could not extract file:');
      print(ex.toString());
      return false;
    }
  }

  static void showToast(BuildContext context, String text) {
    Toast.show(
      text,
      context,
      duration: Toast.LENGTH_LONG,
      gravity: Toast.BOTTOM,
      backgroundColor: Theme.of(context).primaryColor,
      textColor: Colors.black,
    );
  }

  // static void showNotification(BuildContext context, String title, String message) {
  //   Flushbar(
  //     dismissDirection: FlushbarDismissDirection.HORIZONTAL,
  //     flushbarPosition: FlushbarPosition.TOP,
  //     forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
  //     leftBarIndicatorColor: Theme.of(context).accentColor,
  //     backgroundColor: Theme.of(context).primaryColorDark,
  //     titleText: Heading(title),
  //     messageText: BodyText(message),
  //     borderRadius: 8,
  //     icon: Padding(
  //       padding: const EdgeInsets.only(left: 40.0),
  //       child: Icon(
  //         FontAwesomeIcons.infoCircle,
  //         size: 40,
  //         color: Theme.of(context).accentColor,
  //       ),
  //     ),
  //   )..show(context);
  // }

  /// Generates a file name by adding a time-based string to the end,
  /// and adding the correct file extension based on supplied type.
  static String getAntiCollisionName(String name, MediaFileType type) {
    String suffix = DateTime.now().millisecondsSinceEpoch.toString();
    return name.replaceAll(' ', '_') + '_' + suffix + '.' + type.toString();
  }
}
