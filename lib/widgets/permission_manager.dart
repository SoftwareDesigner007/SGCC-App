import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

class PermissionManager {
  static Future<void> requestAllPermissions(BuildContext context) async {
    // Determine which permissions to request based on platform and version
    List<Permission> permissionsToRequest = [
      Permission.camera,
      Permission.phone,
    ];

    if (Platform.isAndroid) {
      // In a real app, you'd check SDK version. 
      // For simplicity and broad compatibility:
      permissionsToRequest.addAll([
        Permission.storage,
        Permission.photos,
        Permission.videos,
        Permission.notification,
      ]);
    } else {
      permissionsToRequest.addAll([
        Permission.storage,
        Permission.notification,
      ]);
    }

    // Request permissions one by one to ensure we don't get blocked by a single failure
    for (var permission in permissionsToRequest) {
      final status = await permission.status;
      if (status.isDenied) {
        await permission.request();
      }
    }

    // Final check to see if we should warn the user
    final cameraStatus = await Permission.camera.status;
    final phoneStatus = await Permission.phone.status;
    
    // For storage, we are happy if either legacy storage OR new media permissions are granted
    bool storageOk = await Permission.storage.isGranted || 
                     await Permission.photos.isGranted || 
                     await Permission.videos.isGranted;

    if (cameraStatus.isDenied || phoneStatus.isDenied || !storageOk) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Permissions are needed for full app functionality.'),
            action: SnackBarAction(
              label: 'Settings',
              onPressed: () => openAppSettings(),
            ),
            duration: const Duration(seconds: 5),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
}
