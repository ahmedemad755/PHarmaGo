/// EXAMPLE IMPLEMENTATIONS
/// Copy these examples and adapt them to your needs

// ============================================================================
// EXAMPLE 1: DARK MODE IMPLEMENTATION
// ============================================================================
// import 'package:flutter/material.dart';
// import 'uploadPrescription.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Medical Prescription',
//       theme: ThemeData(
//         useMaterial3: true,
//         brightness: Brightness.dark,
//         primaryColor: Color(0xFF00D4AA),
//         scaffoldBackgroundColor: Color(0xFF121212),
//       ),
//       home: const Uploadprescription(),
//     );
//   }
// }

// ============================================================================
// EXAMPLE 2: WITH UPLOAD PROGRESS
// ============================================================================
// import 'dart:io';
// import 'package:flutter/material.dart';
//
// class UploadPrescriptionWithProgress extends StatefulWidget {
//   const UploadPrescriptionWithProgress({super.key});
//
//   @override
//   State<UploadPrescriptionWithProgress> createState() =>
//       _UploadPrescriptionWithProgressState();
// }
//
// class _UploadPrescriptionWithProgressState
//     extends State<UploadPrescriptionWithProgress> {
//   File? _selectedImage;
//   double _uploadProgress = 0;
//   bool _isUploading = false;
//
//   Future<void> _uploadToServer(File imageFile) async {
//     setState(() {
//       _isUploading = true;
//       _uploadProgress = 0;
//     });
//
//     try {
//       // Simulate upload with progress
//       for (int i = 0; i <= 100; i += 10) {
//         await Future.delayed(Duration(milliseconds: 300));
//         setState(() {
//           _uploadProgress = i / 100;
//         });
//       }
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Prescription uploaded successfully!'),
//           backgroundColor: Colors.green,
//         ),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Upload failed: $e'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     } finally {
//       setState(() {
//         _isUploading = false;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Upload Prescription')),
//       body: _isUploading
//           ? Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   CircularProgressIndicator(value: _uploadProgress),
//                   const SizedBox(height: 20),
//                   Text('${(_uploadProgress * 100).toStringAsFixed(0)}%'),
//                 ],
//               ),
//             )
//           : const Uploadprescription(),
//     );
//   }
// }

// ============================================================================
// EXAMPLE 3: WITH VALIDATION
// ============================================================================
// class PrescriptionValidator {
//   // Allowed image formats
//   static const List<String> allowedFormats = ['jpg', 'jpeg', 'png', 'pdf'];
//
//   // Maximum file size (5 MB)
//   static const int maxFileSize = 5 * 1024 * 1024;
//
//   static bool isValidImage(File imageFile) {
//     // Check file size
//     if (imageFile.lengthSync() > maxFileSize) {
//       return false;
//     }
//
//     // Check file format
//     String filename = imageFile.path.toLowerCase();
//     bool isValidFormat =
//         allowedFormats.any((format) => filename.endsWith(format));
//
//     return isValidFormat;
//   }
//
//   static String getErrorMessage(File imageFile) {
//     if (imageFile.lengthSync() > maxFileSize) {
//       return 'File size must be less than 5 MB';
//     }
//
//     String filename = imageFile.path.toLowerCase();
//     bool isValidFormat =
//         allowedFormats.any((format) => filename.endsWith(format));
//
//     if (!isValidFormat) {
//       return 'Allowed formats: ${allowedFormats.join(", ")}';
//     }
//
//     return 'Unknown error';
//   }
// }

// ============================================================================
// EXAMPLE 4: WITH IMAGE COMPRESSION
// ============================================================================
// import 'package:image/image.dart' as img;
//
// class ImageCompressor {
//   static Future<File> compressImage(File imageFile) async {
//     // Read image
//     final originalImage = img.decodeImage(imageFile.readAsBytesSync());
//
//     if (originalImage == null) throw Exception('Invalid image');
//
//     // Resize (e.g., max width 1200px)
//     final resizedImage = img.copyResize(
//       originalImage,
//       width: 1200,
//       height: (originalImage.height * 1200 / originalImage.width).toInt(),
//     );
//
//     // Compress
//     final compressedBytes = img.encodeJpg(resizedImage, quality: 85);
//
//     // Save
//     final tempDir = await getTemporaryDirectory();
//     final compressedFile = File(
//       '${tempDir.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg',
//     );
//     await compressedFile.writeAsBytes(compressedBytes);
//
//     return compressedFile;
//   }
// }

// ============================================================================
// EXAMPLE 5: WITH OCULAR CHARACTER RECOGNITION (OCR)
// ============================================================================
// import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
//
// class PrescriptionOCR {
//   final TextRecognizer _textRecognizer = TextRecognizer();
//
//   Future<String> extractTextFromImage(File imageFile) async {
//     final inputImage = InputImage.fromFile(imageFile);
//     final recognizedText = await _textRecognizer.processImage(inputImage);
//
//     String extractedText = '';
//     for (TextBlock block in recognizedText.blocks) {
//       for (TextLine line in block.lines) {
//         extractedText += '${line.text}\n';
//       }
//     }
//
//     return extractedText;
//   }
//
//   void dispose() {
//     _textRecognizer.close();
//   }
// }

// ============================================================================
// EXAMPLE 6: COMPLETE INTEGRATION WITH BACKEND
// ============================================================================
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// class PrescriptionService {
//   static const String baseUrl = 'https://api.example.com';
//
//   Future<bool> uploadPrescription({
//     required File imageFile,
//     required String patientName,
//     required String doctorName,
//     required DateTime prescriptionDate,
//   }) async {
//     try {
//       var request = http.MultipartRequest(
//         'POST',
//         Uri.parse('$baseUrl/prescriptions/upload'),
//       );
//
//       // Add file
//       request.files.add(
//         await http.MultipartFile.fromPath('image', imageFile.path),
//       );
//
//       // Add fields
//       request.fields['patientName'] = patientName;
//       request.fields['doctorName'] = doctorName;
//       request.fields['prescriptionDate'] = prescriptionDate.toIso8601String();
//
//       // Send request
//       var response = await request.send();
//
//       if (response.statusCode == 200) {
//         var responseData = await response.stream.bytesToString();
//         var jsonResponse = json.decode(responseData);
//         return jsonResponse['success'] ?? false;
//       }
//
//       return false;
//     } catch (e) {
//       print('Error uploading prescription: $e');
//       return false;
//     }
//   }
// }

// ============================================================================
// EXAMPLE 7: WITH FIRESTORE INTEGRATION
// ============================================================================
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
//
// class FirestorePrescriptionService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseStorage _storage = FirebaseStorage.instance;
//
//   Future<bool> uploadPrescriptionToFirebase({
//     required File imageFile,
//     required String userId,
//     required String patientName,
//     required String doctorName,
//   }) async {
//     try {
//       // Upload image to Storage
//       final ref = _storage.ref().child(
//           'prescriptions/$userId/${DateTime.now().millisecondsSinceEpoch}.jpg');
//       await ref.putFile(imageFile);
//       final imageUrl = await ref.getDownloadURL();
//
//       // Save metadata to Firestore
//       await _firestore.collection('prescriptions').add({
//         'userId': userId,
//         'patientName': patientName,
//         'doctorName': doctorName,
//         'imageUrl': imageUrl,
//         'uploadedAt': FieldValue.serverTimestamp(),
//         'status': 'pending',
//       });
//
//       return true;
//     } catch (e) {
//       print('Error uploading to Firebase: $e');
//       return false;
//     }
//   }
//
//   Stream<List<Map<String, dynamic>>> getPrescriptions(String userId) {
//     return _firestore
//         .collection('prescriptions')
//         .where('userId', isEqualTo: userId)
//         .orderBy('uploadedAt', descending: true)
//         .snapshots()
//         .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
//   }
// }

// ============================================================================
// EXAMPLE 8: WITH BLOC/CUBIT STATE MANAGEMENT
// ============================================================================
// import 'package:bloc/bloc.dart';
//
// part 'prescription_event.dart';
// part 'prescription_state.dart';
//
// class PrescriptionBloc extends Bloc<PrescriptionEvent, PrescriptionState> {
//   PrescriptionBloc() : super(PrescriptionInitial()) {
//     on<PickImageEvent>(_onPickImage);
//     on<UploadPrescriptionEvent>(_onUploadPrescription);
//   }
//
//   Future<void> _onPickImage(
//     PickImageEvent event,
//     Emitter<PrescriptionState> emit,
//   ) async {
//     emit(ImagePickingInProgress());
//     try {
//       emit(ImagePickedSuccess(event.imageFile));
//     } catch (e) {
//       emit(PrescriptionError('Failed to pick image: $e'));
//     }
//   }
//
//   Future<void> _onUploadPrescription(
//     UploadPrescriptionEvent event,
//     Emitter<PrescriptionState> emit,
//   ) async {
//     emit(PrescriptionUploadInProgress());
//     try {
//       emit(PrescriptionUploadSuccess());
//     } catch (e) {
//       emit(PrescriptionError('Failed to upload: $e'));
//     }
//   }
// }

// ============================================================================
// EXAMPLE 9: CUSTOM THEME IMPLEMENTATION
// ============================================================================
// class ThemeConfigs {
//   static ThemeData lightTheme = ThemeData(
//     useMaterial3: true,
//     brightness: Brightness.light,
//     primaryColor: Color(0xFF1BA598),
//     scaffoldBackgroundColor: Colors.white,
//     appBarTheme: AppBarTheme(
//       backgroundColor: Color(0xFF1BA598),
//       foregroundColor: Colors.white,
//       elevation: 0,
//     ),
//     elevatedButtonTheme: ElevatedButtonThemeData(
//       style: ElevatedButton.styleFrom(
//         backgroundColor: Color(0xFF1BA598),
//         foregroundColor: Colors.white,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//       ),
//     ),
//   );
//
//   static ThemeData darkTheme = ThemeData(
//     useMaterial3: true,
//     brightness: Brightness.dark,
//     primaryColor: Color(0xFF00D4AA),
//     scaffoldBackgroundColor: Color(0xFF121212),
//     appBarTheme: AppBarTheme(
//       backgroundColor: Color(0xFF1E1E1E),
//       foregroundColor: Color(0xFF00D4AA),
//       elevation: 0,
//     ),
//   );
// }

// ============================================================================
// EXAMPLE 10: TESTING
// ============================================================================
// import 'package:flutter_test/flutter_test.dart';
// import 'package:image_picker/image_picker.dart';
//
// void main() {
//   group('Prescription Upload Tests', () {
//     test('Validate image file', () {
//       final mockFile = File('test/fixtures/mock_prescription.jpg');
//       expect(mockFile.existsSync(), true);
//       expect(mockFile.lengthSync() > 0, true);
//     });
//
//     testWidgets('Upload button exists', (WidgetTester tester) async {
//       await tester.pumpWidget(const MyApp());
//       expect(find.text('Camera'), findsOneWidget);
//       expect(find.text('Gallery'), findsOneWidget);
//     });
//   });
// }

// ============================================================================
// USAGE INSTRUCTIONS
// ============================================================================
// To use any of these examples:
//
// 1. Copy the entire example (remove the // comments)
// 2. Create a new file or update an existing one
// 3. Update imports as needed
// 4. Test in your app
//
// Each example is independent and can be mixed and matched.
//
// Most commonly used:
// - Example 2: Upload with progress (shows user feedback)
// - Example 3: Validation (ensures quality)
// - Example 6: Backend integration (connects to server)
// - Example 7: Firebase (cloud storage)
// - Example 8: BLOC (state management)

