import 'dart:ffi';

import 'package:discover_deep_cove/data/database_adapter.dart';
import 'package:discover_deep_cove/data/models/config.dart';
import 'package:discover_deep_cove/util/data_sync/sync_manager.dart';
import 'package:discover_deep_cove/util/screen.dart';
import 'package:discover_deep_cove/util/util.dart';
import 'package:discover_deep_cove/widgets/misc/progress_bar.dart';
import 'package:discover_deep_cove/widgets/misc/text/body_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';

class LoadingScreen extends StatefulWidget {
  final bool isManualUpdate;
  final VoidCallback onComplete;

  LoadingScreen({this.isManualUpdate = false, this.onComplete});

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

// Todo: This screen should replicate the splash screen.
class _LoadingScreenState extends State<LoadingScreen> {
  bool isFirstLoad = false;
  SyncState syncState;
  int filesToDownload;
  int filesDownloaded;
  int downloadSize;
  double percentComplete = 0;

  @override
  void initState() {
    super.initState();
    syncState = SyncState.None;
    widget.isManualUpdate ? checkContent() : manualUpdate();
  }

  Future<void> manualUpdate() async {
    print('Checking for new content');
    await SyncManager(onProgressChange: _onProgressUpdate).sync();
    await Future.delayed(Duration(seconds: 2));
    Navigator.of(context).pop();
  }

  // Check whether the database exists
  Future<void> checkContent() async {
    // Check whether the config table exists, a database exception thrown here
    // indicates that this is first time load
    try {
      var config = await ConfigBean(DatabaseAdapter.of(context)).getAll();
    } on DatabaseException catch (ex) {
      isFirstLoad = true;
      print('Checking for new content');
      await SyncManager(onProgressChange: _onProgressUpdate).sync();
      // Short delay so user can see the final success/error message
      await Future.delayed(Duration(seconds: 2));
    } finally {
      // Direct the user to the home screen
      Navigator.of(context).pushReplacementNamed('/');
    }
  }

  String _getMessage() {
    switch (syncState) {
      case SyncState.None:
        return '';
      case SyncState.DataDownload:
        return 'Checking for new data...';
      case SyncState.Error_ServerUnreachable:
        return 'Server could not be reached';
      case SyncState.ServerDiscovered:
        return '';
      case SyncState.MediaDiscovery:
        return 'Checking for new files...';
      case SyncState.MediaDownload:
        return 'Downloading new files...';
      case SyncState.Cleanup:
        return 'Cleaning up...';
      case SyncState.Done:
        return 'Application up to date!';
      case SyncState.Error_Other:
        return 'An error occurred. Please try again later.';
      case SyncState.Error_Permission:
        return 'You need to grant storage permission to the app.';
      case SyncState.Error_Storage:
        return 'You device has insufficient storage space. '
            'Please free some space and try again.';
      case SyncState.Initialization:
        return 'Preparing to update...';
    }
  }

  Icon _getIcon() {
    switch (syncState) {
      case SyncState.Error_Permission:
      case SyncState.Error_Storage:
      case SyncState.Error_Other:
      case SyncState.Error_ServerUnreachable:
        return Icon(Icons.error_outline, color: Colors.red, size: 50);
      case SyncState.Done:
        return Icon(Icons.check_circle_outline,
            color: Colors.lightGreen, size: 50);
      case SyncState.Cleanup:
      case SyncState.Initialization:
      case SyncState.MediaDiscovery:
      case SyncState.MediaDownload:
      case SyncState.ServerDiscovered:
      case SyncState.DataDownload:
      case SyncState.None:
        return null;
    }
  }

  void _onProgressUpdate(SyncState syncState, int percent, int upTo, int outOf,
      int totalSize) {
    setState(() {
      this.syncState = syncState;
      percentComplete = percent.toDouble();
      filesDownloaded = upTo;
      filesToDownload = outOf;
      downloadSize = totalSize;
    });

    if (syncState == SyncState.Error_ServerUnreachable ||
        syncState == SyncState.Error_Other ||
        syncState == SyncState.Error_Storage ||
        syncState == SyncState.Error_Permission && widget.isManualUpdate) {
      _onUpdateFail();
    }
  }

  void _onUpdateFail() async {
    await Future.delayed(Duration(seconds: 2));

    if (isFirstLoad) {
      SystemNavigator.pop(); // quit app if app doesn't yet have content
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future<bool>.value(false),
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 90,
                    child: _getIcon(),
                  ),
                  BodyText(
                    _getMessage(),
                    size: Screen.isTablet(context) ? 30 : null,
                  ),
                  SizedBox(height: 30),
                  ProgressBar(percent: percentComplete / 100),
                  SizedBox(height: 30),
                  BodyText(
                    filesToDownload != null
                        ? '$filesDownloaded out of $filesToDownload downloaded \n '
                        '(${Util.bytesToMBString(downloadSize)} total)'
                        : ' \n ',
                    size: Screen.isTablet(context) ? 30 : null,
                  )
                ],
              )
            ],
          ),
        ),
        backgroundColor: Theme
            .of(context)
            .primaryColorDark,
      ),
    );
  }
}