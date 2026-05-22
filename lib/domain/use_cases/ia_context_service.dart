import '../model/ia_item_info.dart';

/// Abstract service contract for generating and managing AI context for books/releases.
///
/// Implemented by downstream packages to compile rich background context
/// for release items (books, songs, etc.) using a large language model.
abstract class IaContextService {
  /// Generates book context from PDF text content.
  ///
  /// This should be called once when the author enables AI for their book.
  ///
  /// * [pdfTextContent]: The full text extracted from the PDF.
  /// * [bookTitle]: Title of the book.
  /// * [bookAuthor]: Author name.
  /// * [bookDescription]: Book description/synopsis.
  /// * [language]: Target language for the context (defaults to 'en').
  ///
  /// Returns the compiled context summary suitable for AI chat sessions.
  Future<String?> generateBookContext({
    required String pdfTextContent,
    required String bookTitle,
    required String bookAuthor,
    String bookDescription = '',
    String language = 'en',
  });

  /// Creates a new [IaItemInfo] with pre-compiled context.
  ///
  /// Main entrypoint when the author configures their Systemic Artificial Intelligence Agent.
  Future<IaItemInfo?> createIaInfo({
    required String pdfTextContent,
    required String bookTitle,
    required String bookAuthor,
    required String agentName,
    required String personality,
    String bookDescription = '',
    String authorInstructions = '',
    String language = 'en',
    String avatarUrl = '',
  });

  /// Regenerates context for an existing [IaItemInfo] to refresh its memory/summary.
  Future<IaItemInfo?> regenerateContext({
    required IaItemInfo existingIaInfo,
    required String pdfTextContent,
    required String bookTitle,
    required String bookAuthor,
    String bookDescription = '',
  });

  /// Validates that an [IaItemInfo] is properly configured for live chat.
  ///
  /// Returns `null` if valid, or a descriptive error string explaining the missing parameter.
  String? validateIaInfo(IaItemInfo? iaInfo);
}
