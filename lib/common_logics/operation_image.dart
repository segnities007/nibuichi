import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../providers/user_information_provider.dart';

////////////////////////////////////////////////////////////////////////////////

Future<void> selectImage({required WidgetRef ref}) async {
  try {
    final XFile? imageFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (imageFile == null) return;

    final savedImagePath = await saveImageToLocalDirectory(File(imageFile.path));
    final user = ref.watch(userInformationProvider);
      user?.imagePath = savedImagePath;
    ref.read(userInformationProvider.notifier).state = user;

  } catch (e) {
    Logger().e;
  }
}

////////////////////////////////////////////////////////////////////////////////

Future<String> saveImageToLocalDirectory(File image) async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final imagePath = join(directory.path, 'saved_image_${DateTime.now().millisecondsSinceEpoch}.png');

    final savedImage = await image.copy(imagePath);
    return savedImage.path;
  } catch (e) {
    Logger().e;
    rethrow;
  }
}

////////////////////////////////////////////////////////////////////////////////

Future<void> deleteImage(WidgetRef ref) async {
  try {
    final String? imagePath = ref.watch(userInformationProvider)?.imagePath;
    if (imagePath == null) return;

    final file = File(imagePath);
    if (await file.exists()) {
      await file.delete();
      // Logger().i("Image deleted");
    }

    final user = ref.watch(userInformationProvider);
    user?.imagePath = null;
    ref.read(userInformationProvider.notifier).state = user;

  } catch (e) {
    Logger().e;
  }
}

////////////////////////////////////////////////////////////////////////////////