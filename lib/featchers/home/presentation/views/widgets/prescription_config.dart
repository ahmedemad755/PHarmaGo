import 'package:flutter/material.dart';

/// Configuration class for Prescription Upload UI
/// All colors, text, and styles can be customized here
class PrescriptionConfig {
  // ==================== Colors ====================
  static const Color primaryColor = Color(0xFF1BA598); // Teal/Green
  static const Color lightBackgroundColor = Color(0xFFF0FFFE);
  static const Color cameraButtonColor = Color(0xFF87CEEB); // Sky Blue
  static const Color galleryButtonColor = Color(0xFF9DB4BE); // Gray-Blue
  static const Color white = Colors.white;
  static const Color textDark = Color(0xFF1BA598);
  static const Color iconColor = Color(0xFF1BA598);
  static const Color borderColor = Color(0xFF1BA598);

  // ==================== Text Content ====================
  static const String appBarTitle = "Upload Prescription";
  
  // Prescription Guide
  static const String prescriptionGuideTitle = 'Prescription Guide';
  static const List<String> prescriptionGuidelines = [
    'Upload Clear Image',
    'Doctor Details Required',
    'Date Of Prescription',
    'Patient Details',
    'Dosage Details',
  ];
  
  static const String howItWorksTitle = 'How It Works';
  
  // Upload Area
  static const String uploadText = 'Upload file here';
  static const String cameraLabel = 'Camera';
  static const String galleryLabel = 'Gallery';
  static const String errorPickingImage = 'Error picking image: ';

  // ==================== Font Sizes ====================
  static const double titleFontSize = 22;
  static const double subtitleFontSize = 18;
  static const double guideFontSize = 14;
  static const double labelFontSize = 14;
  static const double smallFontSize = 12;

  // ==================== Border Radius ====================
  static const double cardBorderRadius = 24;
  static const double uploadAreaBorderRadius = 16;
  static const double buttonBorderRadius = 12;

  // ==================== Padding & Spacing ====================
  static const double horizontalPadding = 16;
  static const double verticalPadding = 20;
  static const double cardPadding = 24;
  static const double guidelineSpacing = 8;
  static const double itemSpacing = 12;
  static const double sectionSpacing = 32;

  // ==================== Icon Sizes ====================
  static const double guidelineIconSize = 20;
  static const double uploadIconSize = 50;
  static const double howItWorkIconSize = 40;
  static const double buttonIconSize = 24;
  static const double bottomNavIconSize = 24;

  // ==================== Upload Area ====================
  static const double uploadAreaHeight = 200;
  static const double uploadAreaBorderWidth = 2;
  static const double imageQuality = 100; // 0-100, 100 is highest quality

  // ==================== Button Dimensions ====================
  static const double buttonVerticalPadding = 14;
  static const double uploadButtonSpacing = 16;

  // ==================== Customizable How It Works Items ====================
  static const List<HowItWorkItemConfig> howItWorkItems = [
    HowItWorkItemConfig(
      icon: Icons.upload_file,
      label: 'Upload\nPrescription',
    ),
    HowItWorkItemConfig(
      icon: Icons.notifications_active,
      label: 'Received\nNotification',
    ),
    HowItWorkItemConfig(
      icon: Icons.local_shipping,
      label: 'Medicine at\nyour doorstep',
    ),
  ];

  // ==================== Bottom Navigation Icons ====================
  static const List<IconData> bottomNavIcons = [
    Icons.home,
    Icons.build,
    Icons.description,
    Icons.refresh,
    Icons.person,
  ];

  // ==================== Theme Data ====================
  static ThemeData buildTheme() {
    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: Colors.white,
      useMaterial3: true,
    );
  }

  // ==================== Copy Method for Customization ====================
  /// Use this method to create a custom configuration
  /// Example:
  /// final customConfig = PrescriptionConfig.copyWith(
  ///   primaryColor: Colors.blue,
  ///   uploadText: 'Drag file here',
  /// );
  static Map<String, dynamic> copyWith({
    Color? primaryColor,
    Color? lightBackgroundColor,
    Color? cameraButtonColor,
    Color? galleryButtonColor,
    String? uploadText,
    String? cameraLabel,
    String? galleryLabel,
  }) {
    return {
      'primaryColor': primaryColor ?? PrescriptionConfig.primaryColor,
      'lightBackgroundColor': lightBackgroundColor ?? PrescriptionConfig.lightBackgroundColor,
      'cameraButtonColor': cameraButtonColor ?? PrescriptionConfig.cameraButtonColor,
      'galleryButtonColor': galleryButtonColor ?? PrescriptionConfig.galleryButtonColor,
      'uploadText': uploadText ?? PrescriptionConfig.uploadText,
      'cameraLabel': cameraLabel ?? PrescriptionConfig.cameraLabel,
      'galleryLabel': galleryLabel ?? PrescriptionConfig.galleryLabel,
    };
  }
}

/// Model for How It Works Item Configuration
class HowItWorkItemConfig {
  final IconData icon;
  final String label;

  const HowItWorkItemConfig({
    required this.icon,
    required this.label,
  });
}
