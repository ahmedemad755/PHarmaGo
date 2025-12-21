/// Common Customization Snippets for Prescription Upload UI
/// Copy and paste these into prescription_config.dart or use them as reference

// ============================================================================
// SNIPPET 1: DARK MODE THEME
// ============================================================================
/*
class PrescriptionConfigDarkMode {
  static const Color primaryColor = Color(0xFF00D4AA);
  static const Color lightBackgroundColor = Color(0xFF1E1E1E);
  static const Color cameraButtonColor = Color(0xFF0288D1);
  static const Color galleryButtonColor = Color(0xFF01579B);
  static const Color white = Color(0xFFF5F5F5);
  static const Color textDark = Color(0xFF00D4AA);
  static const Color iconColor = Color(0xFF00D4AA);
  static const Color borderColor = Color(0xFF00D4AA);
}
*/

// ============================================================================
// SNIPPET 2: CORPORATE BLUE THEME
// ============================================================================
/*
class PrescriptionConfigBlue {
  static const Color primaryColor = Color(0xFF1976D2);
  static const Color lightBackgroundColor = Color(0xFFF5F5F5);
  static const Color cameraButtonColor = Color(0xFF2196F3);
  static const Color galleryButtonColor = Color(0xFF1565C0);
  static const Color white = Colors.white;
  static const Color textDark = Color(0xFF1976D2);
  static const Color iconColor = Color(0xFF1976D2);
  static const Color borderColor = Color(0xFF1976D2);
}
*/

// ============================================================================
// SNIPPET 3: MEDICAL GREEN THEME
// ============================================================================
/*
class PrescriptionConfigGreen {
  static const Color primaryColor = Color(0xFF00796B);
  static const Color lightBackgroundColor = Color(0xFFE0F2F1);
  static const Color cameraButtonColor = Color(0xFF26A69A);
  static const Color galleryButtonColor = Color(0xFF00897B);
  static const Color white = Colors.white;
  static const Color textDark = Color(0xFF00796B);
  static const Color iconColor = Color(0xFF00796B);
  static const Color borderColor = Color(0xFF00796B);
}
*/

// ============================================================================
// SNIPPET 4: CUSTOM GUIDELINES WITH DETAILED DESCRIPTIONS
// ============================================================================
/*
const List<String> customGuidelines = [
  '📸 Upload clear, high-resolution image',
  '👨‍⚕️ Doctor name and license number required',
  '📅 Prescription date must be within 6 months',
  '👤 Your full name and age visible on prescription',
  '💊 All medication names and dosages clearly visible',
];
*/

// ============================================================================
// SNIPPET 5: CUSTOM HOW IT WORKS STEPS
// ============================================================================
/*
const List<HowItWorkItemConfig> customHowItWorks = [
  HowItWorkItemConfig(
    icon: Icons.cloud_upload,
    label: 'Upload Your\nRx File',
  ),
  HowItWorkItemConfig(
    icon: Icons.verified_user,
    label: 'Verification\nProcess',
  ),
  HowItWorkItemConfig(
    icon: Icons.store,
    label: 'Shop from\nNetwork',
  ),
  HowItWorkItemConfig(
    icon: Icons.local_shipping,
    label: 'Get Delivery\nAt Home',
  ),
];
*/

// ============================================================================
// SNIPPET 6: ADJUSTED SPACING FOR COMPACT LAYOUT
// ============================================================================
/*
// Add these to PrescriptionConfig for a more compact design
static const double horizontalPadding = 12;
static const double verticalPadding = 16;
static const double cardPadding = 16;
static const double guidelineSpacing = 6;
static const double itemSpacing = 8;
static const double sectionSpacing = 24;
*/

// ============================================================================
// SNIPPET 7: ADJUSTED SPACING FOR SPACIOUS LAYOUT
// ============================================================================
/*
// Add these to PrescriptionConfig for a more spacious design
static const double horizontalPadding = 20;
static const double verticalPadding = 24;
static const double cardPadding = 32;
static const double guidelineSpacing = 12;
static const double itemSpacing = 16;
static const double sectionSpacing = 40;
*/

// ============================================================================
// SNIPPET 8: LARGE FONT SIZES
// ============================================================================
/*
static const double titleFontSize = 26;
static const double subtitleFontSize = 22;
static const double guideFontSize = 16;
static const double labelFontSize = 16;
static const double smallFontSize = 14;
*/

// ============================================================================
// SNIPPET 9: SMALL FONT SIZES
// ============================================================================
/*
static const double titleFontSize = 18;
static const double subtitleFontSize = 14;
static const double guideFontSize = 12;
static const double labelFontSize = 12;
static const double smallFontSize = 10;
*/

// ============================================================================
// SNIPPET 10: CUSTOM BOTTOM NAVIGATION ICONS
// ============================================================================
/*
static const List<IconData> bottomNavIcons = [
  Icons.home_filled,
  Icons.local_pharmacy,
  Icons.receipt_long,
  Icons.history,
  Icons.account_circle,
];
*/

// ============================================================================
// SNIPPET 11: ENHANCED PRESCRIPTION GUIDE WITH EMOJIS
// ============================================================================
/*
static const List<String> prescriptionGuidelinesWithEmoji = [
  '🖼️ Upload Clear Image',
  '⚕️ Doctor Details Required',
  '📅 Date Of Prescription',
  '👤 Patient Details',
  '💊 Dosage Details',
];
*/

// ============================================================================
// SNIPPET 12: VALIDATION AND ERROR MESSAGES
// ============================================================================
/*
class ValidationMessages {
  static const String imageTooLarge = 'Image size must be less than 5MB';
  static const String invalidImageFormat = 'Please select a valid image file';
  static const String imageNotClear = 'Please ensure the image is clear and readable';
  static const String uploadSuccess = 'Prescription uploaded successfully';
  static const String uploadError = 'Failed to upload prescription. Please try again.';
}
*/

// ============================================================================
// SNIPPET 13: BOX SHADOW FOR ELEVATED CARDS
// ============================================================================
/*
static const List<BoxShadow> cardShadow = [
  BoxShadow(
    color: Color(0xFF1BA598).withOpacity(0.15),
    blurRadius: 8,
    offset: Offset(0, 4),
  ),
];

// Usage:
BoxDecoration(
  color: backgroundColor,
  borderRadius: BorderRadius.circular(24),
  boxShadow: PrescriptionConfig.cardShadow,
)
*/

// ============================================================================
// SNIPPET 14: GRADIENT BACKGROUND
// ============================================================================
/*
static BoxDecoration gradientBackground() {
  return BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        primaryColor.withOpacity(0.05),
        Color(0xFF0F9B7A).withOpacity(0.05),
      ],
    ),
  );
}

// Usage:
Container(
  decoration: PrescriptionConfig.gradientBackground(),
  child: /* ... */,
)
*/

// ============================================================================
// SNIPPET 15: LOCALIZATION STRINGS
// ============================================================================
/*
class PrescriptionStrings {
  // English
  static const Map<String, String> en = {
    'appBarTitle': 'Upload Prescription',
    'prescriptionGuideTitle': 'Prescription Guide',
    'uploadText': 'Upload file here',
    'cameraLabel': 'Camera',
    'galleryLabel': 'Gallery',
    'howItWorksTitle': 'How It Works',
    'uploadError': 'Error picking image',
  };

  // Arabic (Example)
  static const Map<String, String> ar = {
    'appBarTitle': 'تحميل الوصفة الطبية',
    'prescriptionGuideTitle': 'دليل الوصفة',
    'uploadText': 'حمل الملف هنا',
    'cameraLabel': 'كاميرا',
    'galleryLabel': 'معرض',
    'howItWorksTitle': 'كيفية العمل',
    'uploadError': 'خطأ في اختيار الصورة',
  };
}
*/

// ============================================================================
// SNIPPET 16: ANIMATION DURATION CONSTANTS
// ============================================================================
/*
class AnimationDurations {
  static const Duration buttonPress = Duration(milliseconds: 200);
  static const Duration imageTransition = Duration(milliseconds: 300);
  static const Duration fadeIn = Duration(milliseconds: 500);
  static const Duration slideIn = Duration(milliseconds: 400);
}
*/

// ============================================================================
// SNIPPET 17: RESPONSIVE BREAKPOINTS
// ============================================================================
/*
class ResponsiveConfig {
  static bool isSmallScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < 400;
  }

  static bool isMediumScreen(BuildContext context) {
    return MediaQuery.of(context).size.width >= 400 &&
        MediaQuery.of(context).size.width < 600;
  }

  static bool isLargeScreen(BuildContext context) {
    return MediaQuery.of(context).size.width >= 600;
  }

  static double getResponsivePadding(BuildContext context) {
    if (isSmallScreen(context)) return 12;
    if (isMediumScreen(context)) return 16;
    return 24;
  }
}
*/

// ============================================================================
// SNIPPET 18: ACCESSIBILITY SETTINGS
// ============================================================================
/*
class AccessibilityConfig {
  // Minimum touch target size (48x48 as per Material Design)
  static const double minTouchSize = 48;

  // High contrast colors for better readability
  static const Color highContrastPrimary = Color(0xFF0D4D3D);
  static const Color highContrastText = Colors.black;

  // Larger font sizes for accessibility
  static const double accessibleTitleSize = 28;
  static const double accessibleBodySize = 18;
}
*/

// ============================================================================
// HOW TO USE THESE SNIPPETS:
// ============================================================================
/*
1. Copy the entire snippet from the section you want to use
2. Replace the corresponding code in prescription_config.dart
3. Update the import statements if needed
4. Run: flutter pub get
5. Restart your app

Example: To use the Dark Mode Theme
- Uncomment SNIPPET 1
- Replace static Color declarations in PrescriptionConfig with values from PrescriptionConfigDarkMode
- Save and reload
*/
