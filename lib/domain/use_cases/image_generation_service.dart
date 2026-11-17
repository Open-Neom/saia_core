import 'dart:typed_data';

/// Abstract interface for AI image generation.
///
/// Implemented by Firebase AI (`gemini-2.5-flash-image` via `firebase_ai ^5.2.0`).
/// Consumed by `neom_ia` (SAIA) via SINT DI.
abstract class ImageGenerationService {
  /// Generates a single image from a text prompt.
  ///
  /// Optional [aspectRatio] supports `'1:1'`, `'16:9'`, `'9:16'`, `'4:3'`, `'3:4'`.
  /// Returns the image bytes (PNG), or `null` on failure.
  Future<Uint8List?> generateImage(
    String prompt, {
    String? aspectRatio,
  });

  /// Generates multiple images from a text prompt concurrently.
  ///
  /// Returns a list of image bytes. [count] specifies how many variations to generate.
  Future<List<Uint8List>> generateImages(
    String prompt, {
    int count = 1,
    String? aspectRatio,
  });
}
