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
        await client.storage.createBucket(bucketName, const BucketOptions(public: true));
        print('✅ Bucket $bucketName created successfully');
      }
    } catch (e) {
      print('❌ Error checking/creating bucket: $e');
    }
  }

  @override
  Future<String?> uploadImage(XFile file, String bucketName) async {
    try {
      final String uniqueId = DateTime.now().millisecondsSinceEpoch.toString();
      final fileName = b.basename(file.path);
      final filePath = '${uniqueId}_$fileName'; 

      final bytes = await file.readAsBytes();
      
      await Supabase.instance.client.storage
          .from(bucketName)
          .uploadBinary(filePath, bytes, 
              fileOptions: const FileOptions(cacheControl: '3600', upsert: false));

      final publicUrl = Supabase.instance.client.storage
          .from(bucketName)
          .getPublicUrl(filePath);

      return publicUrl;
    } catch (e) {
      print('Upload Error: $e');
      return null;
    }
  }

  @override
  Future<void> deleteFile(String path) async {
    // منطق الحذف (يتم تمرير المسار كاملاً بما فيه اسم البوكيت)
  }
}