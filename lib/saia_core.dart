/// SAIA Core — standalone AI foundation.
/// Zero dependency on neom_core or any Neom module.
library saia_core;

// ── Models ──
export 'domain/model/ia_item_info.dart';
export 'domain/model/saia/saia_job_progress.dart';
export 'domain/model/spirit/saia_spirit.dart';
export 'domain/model/spirit/saia_spirit_rank.dart';
export 'domain/model/vector_index/vector_index_progress.dart';
export 'domain/model/vector_index/vector_index_job_result.dart';
export 'domain/model/voice/saia_tts_request.dart';
export 'domain/model/voice/saia_tts_result.dart';
export 'domain/model/voice/saia_voice_mode.dart';
export 'domain/model/voice/saia_voice_profile.dart';

// ── Use Cases (abstract contracts) ──
export 'domain/use_cases/ia_context_service.dart';
export 'domain/use_cases/local_ai_service.dart';
export 'domain/use_cases/image_generation_service.dart';
export 'domain/use_cases/saia_admin_service.dart';
export 'domain/use_cases/saia_tts_provider.dart';
export 'domain/use_cases/vector_index_admin_service.dart';

// ── Constants ──
export 'utils/constants/saia_route_constants.dart';
