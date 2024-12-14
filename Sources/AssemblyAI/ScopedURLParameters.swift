import Foundation

public struct AssemblyAIScopedURLParameters: Sendable, Codable {
    public var languageCode: AssemblyAI.TranscriptLanguageCode?
    public var languageDetection: Bool?

    public init(languageCode: AssemblyAI.TranscriptLanguageCode? = nil, languageDetection: Bool? = nil) {
        self.languageCode = languageCode
        self.languageDetection = languageDetection
    }

    public enum CodingKeys: String, CodingKey {
        case languageCode = "language_code"
        case languageDetection = "language_detection"
    }

    public func transcriptParams(audioURL: URL) -> TranscriptParams {
        .init(
            audioURL: audioURL,
            languageCode: languageCode,
            punctuate: true,
            formatText: true,
            languageDetection: languageDetection,
            disfluencies: false
        )
    }
}
