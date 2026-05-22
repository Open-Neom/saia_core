/// Abstract interface for on-device AI inference.
///
/// Provides offline fallback when cloud AI (Gemini/Claude) is unavailable.
/// Implementations can use llama.cpp, MediaPipe, Core ML, or any local model.
///
/// The embedded chat assistant (SAIA) falls back to this service when:
/// - No internet connection detected
/// - Cloud API quota exceeded
/// - User explicitly requests offline mode
///
/// Register in rootBinding only if on-device inference is available:
/// ```dart
/// Bind.lazyPut<LocalAiService>(() => LlamaCppService(), fenix: true);
/// ```
abstract class LocalAiService {

  /// Whether a local model is loaded and ready for inference.
  bool get isReady;

  /// Loads the local model.
  ///
  /// Call once at application startup. Returns `true` if the model loaded successfully.
  Future<bool> initialize({String? modelPath});

  /// Generates a response from a prompt (single turn, no conversation history).
  Future<String> generate(String prompt, {int maxTokens = 256});

  /// Generates a response with conversation history context.
  ///
  /// [messages] represents the sequence of conversational exchanges.
  Future<String> chat(List<Map<String, String>> messages, {int maxTokens = 256});

  /// Returns metadata about the model (name, size, quantization).
  Map<String, dynamic> get modelInfo;

  /// Releases the local model from memory to free up resources.
  Future<void> dispose();
}
