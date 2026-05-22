import 'dart:typed_data';

/// Abstract interface for AI image generation.
///
/// Implemented by Firebase AI's Imagen model.
/// Consumed by neom_ia (SAIA) via Sint DI.
abstract class ImageGenerationService {
  /// Generates a single image from a text prompt.
  ///
  /// Returns the image bytes (PNG), or `null` on failure.
  Future<Uint8List?> generateImage(String prompt);

  /// Generates multiple images from a text prompt.
  ///
  /// Returns a list of image bytes. [count] specifies how many variations to generate.
  Future<List<Uint8List>> generateImages(String prompt, {int count = 1});
}
