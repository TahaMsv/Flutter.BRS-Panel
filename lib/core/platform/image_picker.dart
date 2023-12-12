import 'package:image_picker/image_picker.dart';

class ImageGetter {
  ImageGetter._();

  static Future<XFile?> pickImageFromGallery() async {
    try {
      final ImagePicker picker = ImagePicker();
      // print( picker.supportsImageSource(ImageSource.gallery));
      final XFile? image = await picker.pickImage(source: ImageSource.gallery, requestFullMetadata: false);
      return image;
    } catch (e) {
      print(e);
      return null;
    }
  }

// Camera is not supported for desktop apps!!!
/*
    // Capture a photo.
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);
    // Pick a video.
    final XFile? galleryVideo = await picker.pickVideo(source: ImageSource.gallery);
    // Capture a video.
    final XFile? cameraVideo = await picker.pickVideo(source: ImageSource.camera);
    // Pick multiple images.
    final List<XFile> images = await picker.pickMultiImage();
    // Pick singe image or video.
    final XFile? media = await picker.pickMedia();
    // Pick multiple images and videos.
    final List<XFile> medias = await picker.pickMultipleMedia();
*/
}
