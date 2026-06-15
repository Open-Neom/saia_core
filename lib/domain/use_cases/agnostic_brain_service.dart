/// Abstract interface to query IaaS provider configurations agnostically.
///
/// This allows core modules (like `saia_core` or `neomage`) to resolve keys,
/// models, and endpoints for external AI brains without depending directly
/// on the concrete `neom_iaas` package.
///
/// Concrete implementations (e.g. `IaasAgnosticBrainService`) are registered
/// in the dependency injection container (Sint/GetIt) from the application
/// layer or host apps.
abstract class AgnosticBrainService {
  /// Whether the agnostic brain service backend is configured and initialized.
  bool get isAvailable;

  /// Returns true if a non-empty API key is saved for the specified provider.
  ///
  /// Examples of [providerName]: 'openRouter', 'groq', 'deepInfra', 'together', 'fal', 'openai'.
  bool hasKey(String providerName);

  /// Returns the API key for the specified provider, or null if not set.
  String? getApiKey(String providerName);

  /// Returns the base URL override for the specified provider, or null.
  String? getBaseUrl(String providerName);

  /// Returns the default or overridden model ID for the specified provider, or null.
  String? getModel(String providerName);

  /// Returns the preferred provider name for a specific capability (e.g., 'chat', 'image', 'video', 'tts').
  String? getPreferredProvider(String capabilityName);
}
