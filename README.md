# saia_core

Primitivas compartidas del ecosistema SAIA (Sistema de Agente de Inteligencia Artificial).

Modulo standalone sin dependencia de neom_core — base para todos los agentes IA del ecosistema Open Neom.

## Modelos

### Spirit
- **SaiaSpirit** — espiritu IA del usuario con powerLevel, rank, auraIntensity
- **SaiaSpiritRank** — 6 rangos: Dormido, Despierto, Entrenado, Veterano, Maestro, Leyenda

### Voice
- **SaiaTtsProvider** — interface abstracta para TTS con 3 modos (design, clone, ultimateClone)
- **SaiaVoiceMode** — enum de modos de sintesis
- **SaiaVoiceProfile** — perfil persistente de voz
- **SaiaTtsRequest** — request con factory constructors por modo
- **SaiaTtsResult** — audio bytes + format + sampleRate

### AI
- **IaItemInfo** — configuracion IA por item
- **SaiaJobProgress** — progreso de trabajos batch

### Vector
- **VectorIndexProgress** — progreso de indexacion
- **VectorIndexJobResult** — resultado de jobs de vectores

## Use Cases

- **SaiaTtsProvider** — contrato de TTS (ElevenLabs hoy, VoxCPM futuro)
- **SaiaAdminService** — operaciones admin (superAdmin only)
- **LocalAiService** — inferencia on-device
- **ImageGenerationService** — generacion de imagenes
- **VectorIndexAdminService** — operaciones batch de vectores

## Licencia

Apache License 2.0 — Open Neom
