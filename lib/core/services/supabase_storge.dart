import 'dart:developer';
import 'package:e_commerce/core/const.dart';
import 'package:e_commerce/core/services/storge_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart' as b;

class SupabaseStorgeService implements StorgeService {
  // دالة التهيئة مع التأكد من وجود البوكيتات المطلوبة
  static Future<void> initSupabase() async {
    await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);

    // إنشاء بوكيت الروشتات إذا لم يكن موجوداً
    final storage = SupabaseStorgeService();
    await storage.ensureBucketExists('prescriptions');
  }

  Future<void> ensureBucketExists(String bucketName) async {
    final client = Supabase.instance.client;
    try {
      final buckets = await client.storage.listBuckets();
      final exists = buckets.any((bucket) => bucket.name == bucketName);

      if (!exists) {
        // إنشاء بوكيت عام (Public) لسهولة الوصول للروابط
        await client.storage.createBucket(
          bucketName,
          const BucketOptions(public: true),
        );
        log('Bucket $bucketName created successfully');
      }
    } catch (e, stackTrace) {
      log('Error checking/creating bucket: $e', stackTrace: stackTrace);
    }
  }

  @override
  Future<String?> uploadImage(XFile file, String bucketName) async {
    try {
      final client = Supabase.instance.client;
      final String uniqueId = DateTime.now().millisecondsSinceEpoch.toString();
      final fileName = b.basename(file.path);
      final filePath = '${uniqueId}_$fileName';

      final bytes = await file.readAsBytes();

      await client.storage
          .from(bucketName)
          .uploadBinary(
            filePath,
            bytes,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );

      final publicUrl = client.storage
          .from(bucketName)
          .getPublicUrl(filePath);

      return publicUrl;
    } catch (e, stackTrace) {
      log('Upload Error: $e', stackTrace: stackTrace);
      return null;
    }
  }

  @override
  Future<void> deleteFile(String path) async {
    if (path.isEmpty) return;
    
    try {
      final client = Supabase.instance.client;
      
      // تحليل مسار الـ URL بالكامل لاستخراج اسم البوكيت ومسار الملف الداخلي بشكل ديناميكي آمن
      final uri = Uri.tryParse(path);
      if (uri == null) return;
      
      final pathSegments = uri.pathSegments;
      // التحقق من صلاحية المسار واحتوائه على هيكل روابط تخزين سوبابيس القياسي
      if (pathSegments.contains('storage/v1/object/public')) {
        final indexOfPublic = pathSegments.indexOf('public');
        if (indexOfPublic != -1 && pathSegments.length > indexOfPublic + 2) {
          final bucketName = pathSegments[indexOfPublic + 1];
          final filePath = pathSegments.sublist(indexOfPublic + 2).join('/');
          
          await client.storage.from(bucketName).remove([filePath]);
          log('File deleted successfully from bucket: $bucketName, path: $filePath');
        }
      }
    } catch (e, stackTrace) {
      log('Error deleting file: $e', stackTrace: stackTrace);
    }
  }
}