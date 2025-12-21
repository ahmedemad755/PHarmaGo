# Prescription Upload UI - Complete Documentation

## Overview
This is a fully customizable, production-ready prescription upload interface for Flutter. It includes high-quality image capture, flexible configuration, and a beautiful UI matching your design specifications.

## Features
✅ **High-Quality Image Upload** - Supports 100% quality image capture from camera or gallery  
✅ **Fully Configurable** - All colors, text, fonts, and spacing can be customized  
✅ **Reusable Components** - Modular widgets for easy reuse  
✅ **Professional UI** - Matches modern mobile app standards  
✅ **Responsive Design** - Works across different screen sizes  
✅ **Error Handling** - Graceful error management  

## File Structure

```
uploadPrescription.dart          # Main implementation
prescription_config.dart         # Centralized configuration
PRESCRIPTION_UPLOAD_GUIDE.md     # This file
```

## Color Scheme

### Primary Colors
- **Primary Color**: `#1BA598` (Teal/Green) - Used for text, icons, borders
- **Light Background**: `#F0FFFE` (Very Light Cyan)
- **Camera Button**: `#87CEEB` (Sky Blue)
- **Gallery Button**: `#9DB4BE` (Gray-Blue)

### How to Change Colors

Edit `prescription_config.dart`:

```dart
class PrescriptionConfig {
  static const Color primaryColor = Color(0xFF1BA598);
  static const Color cameraButtonColor = Color(0xFF87CEEB);
  static const Color galleryButtonColor = Color(0xFF9DB4BE);
  // ... more colors
}
```

## Components Breakdown

### 1. **Uploadprescription (Main Widget)**
The stateful widget that manages image selection and UI state.

**Usage:**
```dart
const Uploadprescription()
```

**Customization:**
- Configure image quality: Edit `imageQuality: 100` in `_pickImage()` method
- Add validation before upload
- Integrate with your backend

### 2. **PrescriptionGuideCard**
Displays the prescription requirements in a beautiful card.

**Customizable Parameters:**
```dart
PrescriptionGuideCard(
  backgroundColor: Color(0xFF1BA598),
  textColor: Colors.white,
  iconColor: Colors.white,
  title: 'Prescription Guide',
  guidelines: [
    'Upload Clear Image',
    'Doctor Details Required',
    'Date Of Prescription',
    'Patient Details',
    'Dosage Details',
  ],
  howItWorkTitle: 'How It Works',
  howItWorkItems: [ /* ... */ ],
)
```

### 3. **UploadAreaWidget**
The main upload drop zone with camera/gallery buttons.

**Customizable Parameters:**
```dart
UploadAreaWidget(
  selectedImage: File?,
  onCameraTap: VoidCallback,
  onGalleryTap: VoidCallback,
  borderColor: Color(0xFF1BA598),
  backgroundColor: Color(0xFFF0FFFE),
  textColor: Color(0xFF1BA598),
  iconColor: Color(0xFF1BA598),
  buttonBackgroundColor: Color(0xFF87CEEB),
  buttonTextColor: Colors.white,
  uploadText: 'Upload file here',
  cameraLabel: 'Camera',
  galleryLabel: 'Gallery',
)
```

### 4. **UploadButtonWidget**
Reusable button component for camera and gallery actions.

**Customizable Parameters:**
```dart
UploadButtonWidget(
  icon: Icons.camera_alt,
  label: 'Camera',
  backgroundColor: Color(0xFF87CEEB),
  textColor: Colors.white,
  onTap: () { /* callback */ },
  borderRadius: 12,
)
```

### 5. **BottomNavigationIconsWidget**
Navigation icons at the bottom of the screen.

**Customizable Parameters:**
```dart
BottomNavigationIconsWidget(
  iconColor: Color(0xFF1BA598),
  icons: [
    Icons.home,
    Icons.build,
    Icons.description,
    Icons.refresh,
    Icons.person,
  ],
)
```

## Customization Examples

### Example 1: Change Primary Color Theme

Edit `prescription_config.dart`:

```dart
class PrescriptionConfig {
  static const Color primaryColor = Color(0xFF2196F3); // Blue instead of Teal
  static const Color cameraButtonColor = Color(0xFF42A5F5);
  static const Color galleryButtonColor = Color(0xFF1E88E5);
}
```

### Example 2: Change Guidelines Text

Edit `prescription_config.dart`:

```dart
static const List<String> prescriptionGuidelines = [
  'Clear Image Required',
  'Valid Doctor Signature',
  'Recent Prescription',
  'Patient Name & ID',
  'Medication Names Clear',
];
```

### Example 3: Customize How It Works Steps

Edit `prescription_config.dart`:

```dart
static const List<HowItWorkItemConfig> howItWorkItems = [
  HowItWorkItemConfig(
    icon: Icons.check_circle,
    label: 'Submit\nPrescription',
  ),
  HowItWorkItemConfig(
    icon: Icons.hourglass_empty,
    label: 'Wait for\nApproval',
  ),
  HowItWorkItemConfig(
    icon: Icons.local_shipping,
    label: 'Delivery to\nyour Door',
  ),
];
```

### Example 4: Adjust Font Sizes

Edit `prescription_config.dart`:

```dart
static const double titleFontSize = 24; // was 22
static const double guideFontSize = 15; // was 14
static const double labelFontSize = 16; // was 14
```

## Integration with Backend

To integrate with your backend, modify the `_pickImage()` method:

```dart
Future<void> _pickImage(ImageSource source) async {
  try {
    final XFile? pickedFile = await _imagePicker.pickImage(
      source: source,
      imageQuality: 100,
    );

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });

      // TODO: Upload to backend
      // await uploadPrescriptionToBackend(_selectedImage!);
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error picking image: $e')),
    );
  }
}
```

## Validation Example

Add validation before uploading:

```dart
bool _validateImage(File image) {
  final maxSize = 5 * 1024 * 1024; // 5 MB
  if (image.lengthSync() > maxSize) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Image size exceeds 5MB')),
    );
    return false;
  }
  return true;
}
```

## Dependencies

Required packages (already added to `pubspec.yaml`):
```yaml
image_picker: ^1.1.2
flutter:
  sdk: flutter
```

## Screenshot Breakdown

The UI includes 3 main sections:

1. **Prescription Guide Card** (Top)
   - Title: "Prescription Guide"
   - 5 checkmarked guidelines
   - "How It Works" section with 3 icons

2. **Upload Area** (Middle)
   - Large dashed border drop zone
   - Camera and Gallery buttons
   - Shows selected image if picked

3. **Navigation Icons** (Bottom)
   - 5 circular icon buttons
   - Home, Settings, Documents, Refresh, Profile

## Styling Tips

### For Dark Theme
```dart
backgroundColor: Color(0xFF2C2C2C),
textColor: Colors.white,
```

### For Modern Gradient Background
```dart
decoration: BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1BA598), Color(0xFF0F9B7A)],
  ),
)
```

### For Elevated Effect
```dart
boxShadow: [
  BoxShadow(
    color: Colors.black.withOpacity(0.1),
    blurRadius: 10,
    offset: Offset(0, 5),
  ),
]
```

## Best Practices

1. **Keep Images High Quality**: `imageQuality: 100` for medical prescriptions
2. **Validate Before Upload**: Check file size and format
3. **Show Loading State**: Add progress indicator during upload
4. **Handle Errors Gracefully**: Show user-friendly error messages
5. **Cache Images**: Consider caching selected images temporarily
6. **Responsive Design**: Test on different screen sizes

## Troubleshooting

### Images Not Showing
- Ensure `image_picker` is properly installed: `flutter pub get`
- Check permissions in Android/iOS manifest files

### Colors Not Updating
- Make sure to use `Color(0xFFRRGGBB)` format
- The first two `FF` represent full opacity (alpha channel)

### Text Overflow
- Adjust font sizes in `PrescriptionConfig`
- Ensure padding isn't too large

## Future Enhancements

- [ ] Crop image functionality
- [ ] Multiple image selection
- [ ] Image compression optimization
- [ ] OCR for automatic data extraction
- [ ] Drag & drop support
- [ ] Image preview with zoom
- [ ] Undo/Redo functionality

## Support

For questions or issues, refer to the inline comments in the code or consult the Flutter documentation:
- [image_picker package](https://pub.dev/packages/image_picker)
- [Flutter Material Design](https://flutter.dev/docs/development/ui/widgets/material)
