import Foundation

// MARK: - /v2/upload

public struct UploadedFile: Codable {
    public let uploadURL: URL

    public enum CodingKeys: String, CodingKey {
        case uploadURL = "upload_url"
    }
}

// MARK: - /v2/transcript

public enum RedactedAudioStatus: String, Codable, CaseIterable {
    case redactedAudioReady = "redacted_audio_ready"
}

public struct RedactedAudioResponse: Codable {
    let status: RedactedAudioStatus
    let redactedAudioURL: URL

    public enum CodingKeys: String, CodingKey {
        case status
        case redactedAudioURL = "redacted_audio_url"
    }
}

public enum SubtitleFormat: String, Codable, CaseIterable {
    case srt = "srt"
    case vtt = "vtt"
}

public struct WordSearchResponse: Codable {
    let id: UUID
    let totalCount: Int
    let matches: [WordSearchMatch]

    public enum CodingKeys: String, CodingKey {
        case id
        case totalCount = "total_count"
        case matches
    }
}

public struct WordSearchMatch: Codable {
    let text: String
    let count: Int
    let timestamps: [[Int]]
    let indexes: [Int]
}

public struct WordSearchTimestamp: Codable {
    let timestamp: Int
}

public struct Timestamp: Codable {
    let start: Int
    let end: Int
}

public enum TranscriptBoostParam: String, Codable, CaseIterable {
    case low = "low"
    case `default` = "default"
    case high = "high"
}

public struct TranscriptCustomSpelling: Codable {
    let from: [String]
    let to: String
}

public struct TranscriptUtterance: Codable {
    let confidence: Double
    let start: Int
    let end: Int
    let text: String
    let words: [TranscriptWord]
    let speaker: String
}

public enum SubstitutionPolicy: String, Codable, CaseIterable {
    case entityName = "entity_name"
    case hash = "hash"
}

public enum RedactPiiAudioQuality: String, Codable, CaseIterable {
    case mp3 = "mp3"
    case wav = "wav"
}

public enum PiiPolicy: String, Codable, CaseIterable {
    case medicalProcess = "medical_process"
    case medicalCondition = "medical_condition"
    case bloodType = "blood_type"
    case drug = "drug"
    case injury = "injury"
    case numberSequence = "number_sequence"
    case emailAddress = "email_address"
    case dateOfBirth = "date_of_birth"
    case phoneNumber = "phone_number"
    case usSocialSecurityNumber = "us_social_security_number"
    case creditCardNumber = "credit_card_number"
    case creditCardExpiration = "credit_card_expiration"
    case creditCardCvv = "credit_card_cvv"
    case date = "date"
    case nationality = "nationality"
    case event = "event"
    case language = "language"
    case location = "location"
    case moneyAmount = "money_amount"
    case personName = "person_name"
    case personAge = "person_age"
    case organization = "organization"
    case politicalAffiliation = "political_affiliation"
    case occupation = "occupation"
    case religion = "religion"
    case driversLicense = "drivers_license"
    case bankingInformation = "banking_information"
}

public enum SpeechModel: String, Codable, CaseIterable {
    case best = "best"
    case nano = "nano"
    case conformer2 = "conformer-2"
}

public enum TranscriptLanguageCode: String, Codable, CaseIterable {
    case en = "en"
    case enAu = "en_au"
    case enUk = "en_uk"
    case enUs = "en_us"
    case es = "es"
    case fr = "fr"
    case de = "de"
    case it = "it"
    case pt = "pt"
    case nl = "nl"
    case af = "af"
    case sq = "sq"
    case am = "am"
    case ar = "ar"
    case hy = "hy"
    case `as` = "as"
    case az = "az"
    case ba = "ba"
    case eu = "eu"
    case be = "be"
    case bn = "bn"
    case bs = "bs"
    case br = "br"
    case bg = "bg"
    case my = "my"
    case ca = "ca"
    case zh = "zh"
    case hr = "hr"
    case cs = "cs"
    case da = "da"
    case et = "et"
    case fo = "fo"
    case fi = "fi"
    case gl = "gl"
    case ka = "ka"
    case el = "el"
    case gu = "gu"
    case ht = "ht"
    case ha = "ha"
    case haw = "haw"
    case he = "he"
    case hi = "hi"
    case hu = "hu"
    case `is` = "is"
    case id = "id"
    case ja = "ja"
    case jw = "jw"
    case kn = "kn"
    case kk = "kk"
    case km = "km"
    case ko = "ko"
    case lo = "lo"
    case la = "la"
    case lv = "lv"
    case ln = "ln"
    case lt = "lt"
    case lb = "lb"
    case mk = "mk"
    case mg = "mg"
    case ms = "ms"
    case ml = "ml"
    case mt = "mt"
    case mi = "mi"
    case mr = "mr"
    case mn = "mn"
    case ne = "ne"
    case no = "no"
    case nn = "nn"
    case oc = "oc"
    case pa = "pa"
    case ps = "ps"
    case fa = "fa"
    case pl = "pl"
    case ro = "ro"
    case ru = "ru"
    case sa = "sa"
    case sr = "sr"
    case sn = "sn"
    case sd = "sd"
    case si = "si"
    case sk = "sk"
    case sl = "sl"
    case so = "so"
    case su = "su"
    case sw = "sw"
    case sv = "sv"
    case tl = "tl"
    case tg = "tg"
    case ta = "ta"
    case tt = "tt"
    case te = "te"
    case th = "th"
    case bo = "bo"
    case tr = "tr"
    case tk = "tk"
    case uk = "uk"
    case ur = "ur"
    case uz = "uz"
    case vi = "vi"
    case cy = "cy"
    case yi = "yi"
    case yo = "yo"
}

public enum TranscriptStatus: String, Codable, CaseIterable {
    case queued = "queued"
    case processing = "processing"
    case completed = "completed"
    case error = "error"
}

public enum TranscriptReadyStatus: String, Codable, CaseIterable {
    case completed = "completed"
    case error = "error"
}

public struct TranscriptReadyNotification: Codable {
    let transcriptID: UUID
    let status: TranscriptReadyStatus

    public enum CodingKeys: String, CodingKey {
        case transcriptID = "transcript_id"
        case status
    }
}

public struct Transcript: Codable {
    public let id: UUID
    let languageModel: String
    let acousticModel: String
    public let status: TranscriptStatus
    let languageCode: TranscriptLanguageCode?
    let audioURL: URL
    public let text: String?
    let words: [TranscriptWord]?
    let utterances: [TranscriptUtterance]?
    let confidence: Double?
    public let audioDuration: Double?
    let punctuate: Bool?
    let formatText: Bool?
    let dualChannel: Bool?
    let speechModel: SpeechModel?
    let webhookURL: URL?
    let webhookStatusCode: Int?
    let webhookAuth: Bool
    let webhookAuthHeaderName: String?
    let speedBoost: Bool?
    let autoHighlights: Bool
    let autoHighlightsResult: AutoHighlightsResult?
    let audioStartFrom: Int?
    let audioEndAt: Int?
    let wordBoost: [String]?
    let boostParam: String?
    let filterProfanity: Bool?
    let redactPii: Bool
    let redactPiiAudio: Bool?
    let redactPiiAudioQuality: RedactPiiAudioQuality?
    let redactPiiPolicies: [PiiPolicy]?
    let redactPiiSub: SubstitutionPolicy?
    let speakerLabels: Bool?
    let speakersExpected: Int?
    let contentSafety: Bool?
    let contentSafetyLabels: ContentSafetyLabelsResult?
    let iabCategories: Bool?
    let iabCategoriesResult: TopicDetectionModelResult?
    let languageDetection: Bool?
    let customSpelling: [TranscriptCustomSpelling]?
    let autoChapters: Bool?
    let chapters: [Chapter]?
    let summarization: Bool
    let summaryType: String?
    let summaryModel: String?
    let summary: String?
    let customTopics: Bool?
    let topics: [String]?
    let disfluencies: Bool?
    let sentimentAnalysis: Bool?
    let sentimentAnalysisResults: [SentimentAnalysisResult]?
    let entityDetection: Bool?
    let entities: [Entity]?
    let speechThreshold: Double?
    let throttled: Bool?
    let error: String?

    public enum CodingKeys: String, CodingKey {
        case id
        case languageModel = "language_model"
        case acousticModel = "acoustic_model"
        case status
        case languageCode = "language_code"
        case audioURL = "audio_url"
        case text
        case words
        case utterances
        case confidence
        case audioDuration = "audio_duration"
        case punctuate
        case formatText = "format_text"
        case dualChannel = "dual_channel"
        case speechModel = "speech_model"
        case webhookURL = "webhook_url"
        case webhookStatusCode = "webhook_status_code"
        case webhookAuth = "webhook_auth"
        case webhookAuthHeaderName = "webhook_auth_header_name"
        case speedBoost = "speed_boost"
        case autoHighlights = "auto_highlights"
        case autoHighlightsResult = "auto_highlights_result"
        case audioStartFrom = "audio_start_from"
        case audioEndAt = "audio_end_at"
        case wordBoost = "word_boost"
        case boostParam = "boost_param"
        case filterProfanity = "filter_profanity"
        case redactPii = "redact_pii"
        case redactPiiAudio = "redact_pii_audio"
        case redactPiiAudioQuality = "redact_pii_audio_quality"
        case redactPiiPolicies = "redact_pii_policies"
        case redactPiiSub = "redact_pii_sub"
        case speakerLabels = "speaker_labels"
        case speakersExpected = "speakers_expected"
        case contentSafety = "content_safety"
        case contentSafetyLabels = "content_safety_labels"
        case iabCategories = "iab_categories"
        case iabCategoriesResult = "iab_categories_result"
        case languageDetection = "language_detection"
        case customSpelling = "custom_spelling"
        case autoChapters = "auto_chapters"
        case chapters
        case summarization
        case summaryType = "summary_type"
        case summaryModel = "summary_model"
        case summary
        case customTopics = "custom_topics"
        case topics
        case disfluencies
        case sentimentAnalysis = "sentiment_analysis"
        case sentimentAnalysisResults = "sentiment_analysis_results"
        case entityDetection = "entity_detection"
        case entities
        case speechThreshold = "speech_threshold"
        case throttled
        case error
    }
}

public struct TranscriptOptionalParams: Codable {
    let languageCode: TranscriptLanguageCode?
    let punctuate: Bool?
    let formatText: Bool?
    let dualChannel: Bool?
    let speechModel: SpeechModel?
    let webhookURL: URL?
    let webhookAuthHeaderName: String?
    let webhookAuthHeaderValue: String?
    let autoHighlights: Bool?
    let audioStartFrom: Int?
    let audioEndAt: Int?
    let wordBoost: [String]?
    let boostParam: TranscriptBoostParam?
    let filterProfanity: Bool?
    let redactPii: Bool?
    let redactPiiAudio: Bool?
    let redactPiiAudioQuality: RedactPiiAudioQuality?
    let redactPiiPolicies: [PiiPolicy]?
    let redactPiiSub: SubstitutionPolicy?
    let speakerLabels: Bool?
    let speakersExpected: Int?
    let contentSafety: Bool?
    let contentSafetyConfidence: Int?
    let iabCategories: Bool?
    let languageDetection: Bool?
    let customSpelling: [TranscriptCustomSpelling]?
    let disfluencies: Bool?
    let sentimentAnalysis: Bool?
    let autoChapters: Bool?
    let entityDetection: Bool?
    let speechThreshold: Double?
    let summarization: Bool?
    let summaryModel: SummaryModel?
    let summaryType: SummaryType?
    let customTopics: Bool?
    let topics: [String]?

    public enum CodingKeys: String, CodingKey {
        case languageCode = "language_code"
        case punctuate
        case formatText = "format_text"
        case dualChannel = "dual_channel"
        case speechModel = "speech_model"
        case webhookURL = "webhook_url"
        case webhookAuthHeaderName = "webhook_auth_header_name"
        case webhookAuthHeaderValue = "webhook_auth_header_value"
        case autoHighlights = "auto_highlights"
        case audioStartFrom = "audio_start_from"
        case audioEndAt = "audio_end_at"
        case wordBoost = "word_boost"
        case boostParam = "boost_param"
        case filterProfanity = "filter_profanity"
        case redactPii = "redact_pii"
        case redactPiiAudio = "redact_pii_audio"
        case redactPiiAudioQuality = "redact_pii_audio_quality"
        case redactPiiPolicies = "redact_pii_policies"
        case redactPiiSub = "redact_pii_sub"
        case speakerLabels = "speaker_labels"
        case speakersExpected = "speakers_expected"
        case contentSafety = "content_safety"
        case contentSafetyConfidence = "content_safety_confidence"
        case iabCategories = "iab_categories"
        case languageDetection = "language_detection"
        case customSpelling = "custom_spelling"
        case disfluencies
        case sentimentAnalysis = "sentiment_analysis"
        case autoChapters = "auto_chapters"
        case entityDetection = "entity_detection"
        case speechThreshold = "speech_threshold"
        case summarization
        case summaryModel = "summary_model"
        case summaryType = "summary_type"
        case customTopics = "custom_topics"
        case topics
    }
}

public struct TranscriptParams: Codable {
    
    public init(audioURL: URL, languageCode: TranscriptLanguageCode? = nil, punctuate: Bool? = nil, formatText: Bool? = nil, dualChannel: Bool? = nil, speechModel: SpeechModel? = nil, webhookURL: URL? = nil, webhookAuthHeaderName: String? = nil, webhookAuthHeaderValue: String? = nil, autoHighlights: Bool? = nil, audioStartFrom: Int? = nil, audioEndAt: Int? = nil, wordBoost: [String]? = nil, boostParam: TranscriptBoostParam? = nil, filterProfanity: Bool? = nil, redactPii: Bool? = nil, redactPiiAudio: Bool? = nil, redactPiiAudioQuality: RedactPiiAudioQuality? = nil, redactPiiPolicies: [PiiPolicy]? = nil, redactPiiSub: SubstitutionPolicy? = nil, speakerLabels: Bool? = nil, speakersExpected: Int? = nil, contentSafety: Bool? = nil, contentSafetyConfidence: Int? = nil, iabCategories: Bool? = nil, languageDetection: Bool? = nil, customSpelling: [TranscriptCustomSpelling]? = nil, disfluencies: Bool? = nil, sentimentAnalysis: Bool? = nil, autoChapters: Bool? = nil, entityDetection: Bool? = nil, speechThreshold: Double? = nil, summarization: Bool? = nil, summaryModel: SummaryModel? = nil, summaryType: SummaryType? = nil, customTopics: Bool? = nil, topics: [String]? = nil) {
        self.audioURL = audioURL
        self.languageCode = languageCode
        self.punctuate = punctuate
        self.formatText = formatText
        self.dualChannel = dualChannel
        self.speechModel = speechModel
        self.webhookURL = webhookURL
        self.webhookAuthHeaderName = webhookAuthHeaderName
        self.webhookAuthHeaderValue = webhookAuthHeaderValue
        self.autoHighlights = autoHighlights
        self.audioStartFrom = audioStartFrom
        self.audioEndAt = audioEndAt
        self.wordBoost = wordBoost
        self.boostParam = boostParam
        self.filterProfanity = filterProfanity
        self.redactPii = redactPii
        self.redactPiiAudio = redactPiiAudio
        self.redactPiiAudioQuality = redactPiiAudioQuality
        self.redactPiiPolicies = redactPiiPolicies
        self.redactPiiSub = redactPiiSub
        self.speakerLabels = speakerLabels
        self.speakersExpected = speakersExpected
        self.contentSafety = contentSafety
        self.contentSafetyConfidence = contentSafetyConfidence
        self.iabCategories = iabCategories
        self.languageDetection = languageDetection
        self.customSpelling = customSpelling
        self.disfluencies = disfluencies
        self.sentimentAnalysis = sentimentAnalysis
        self.autoChapters = autoChapters
        self.entityDetection = entityDetection
        self.speechThreshold = speechThreshold
        self.summarization = summarization
        self.summaryModel = summaryModel
        self.summaryType = summaryType
        self.customTopics = customTopics
        self.topics = topics
    }
    
    let audioURL: URL
    let languageCode: TranscriptLanguageCode?
    let punctuate: Bool?
    let formatText: Bool?
    let dualChannel: Bool?
    let speechModel: SpeechModel?
    let webhookURL: URL?
    let webhookAuthHeaderName: String?
    let webhookAuthHeaderValue: String?
    let autoHighlights: Bool?
    let audioStartFrom: Int?
    let audioEndAt: Int?
    let wordBoost: [String]?
    let boostParam: TranscriptBoostParam?
    let filterProfanity: Bool?
    let redactPii: Bool?
    let redactPiiAudio: Bool?
    let redactPiiAudioQuality: RedactPiiAudioQuality?
    let redactPiiPolicies: [PiiPolicy]?
    let redactPiiSub: SubstitutionPolicy?
    let speakerLabels: Bool?
    let speakersExpected: Int?
    let contentSafety: Bool?
    let contentSafetyConfidence: Int?
    let iabCategories: Bool?
    let languageDetection: Bool?
    let customSpelling: [TranscriptCustomSpelling]?
    let disfluencies: Bool?
    let sentimentAnalysis: Bool?
    let autoChapters: Bool?
    let entityDetection: Bool?
    let speechThreshold: Double?
    let summarization: Bool?
    let summaryModel: SummaryModel?
    let summaryType: SummaryType?
    let customTopics: Bool?
    let topics: [String]?

    public enum CodingKeys: String, CodingKey {
        case audioURL = "audio_url"
        case languageCode = "language_code"
        case punctuate
        case formatText = "format_text"
        case dualChannel = "dual_channel"
        case speechModel = "speech_model"
        case webhookURL = "webhook_url"
        case webhookAuthHeaderName = "webhook_auth_header_name"
        case webhookAuthHeaderValue = "webhook_auth_header_value"
        case autoHighlights = "auto_highlights"
        case audioStartFrom = "audio_start_from"
        case audioEndAt = "audio_end_at"
        case wordBoost = "word_boost"
        case boostParam = "boost_param"
        case filterProfanity = "filter_profanity"
        case redactPii = "redact_pii"
        case redactPiiAudio = "redact_pii_audio"
        case redactPiiAudioQuality = "redact_pii_audio_quality"
        case redactPiiPolicies = "redact_pii_policies"
        case redactPiiSub = "redact_pii_sub"
        case speakerLabels = "speaker_labels"
        case speakersExpected = "speakers_expected"
        case contentSafety = "content_safety"
        case contentSafetyConfidence = "content_safety_confidence"
        case iabCategories = "iab_categories"
        case languageDetection = "language_detection"
        case customSpelling = "custom_spelling"
        case disfluencies
        case sentimentAnalysis = "sentiment_analysis"
        case autoChapters = "auto_chapters"
        case entityDetection = "entity_detection"
        case speechThreshold = "speech_threshold"
        case summarization
        case summaryModel = "summary_model"
        case summaryType = "summary_type"
        case customTopics = "custom_topics"
        case topics
    }
}

public enum SummaryModel: String, Codable, CaseIterable {
    case informative = "informative"
    case conversational = "conversational"
    case catchy = "catchy"
}

public enum SummaryType: String, Codable, CaseIterable {
    case bullets = "bullets"
    case bulletsVerbose = "bullets_verbose"
    case gist = "gist"
    case headline = "headline"
    case paragraph = "paragraph"
}

public struct TranscriptWord: Codable {
    let confidence: Double
    let start: Int
    let end: Int
    let text: String
    let speaker: String?
}

public struct TranscriptSentence: Codable {
    let text: String
    let start: Int
    let end: Int
    let confidence: Double
    let words: [TranscriptWord]
    let speaker: String?
}

public struct SentencesResponse: Codable {
    let sentences: [TranscriptSentence]
    let id: UUID
    let confidence: Double
    let audioDuration: Int

    public enum CodingKeys: String, CodingKey {
        case sentences
        case id
        case confidence
        case audioDuration = "audio_duration"
    }
}

public struct TranscriptParagraph: Codable {
    let text: String
    let start: Int
    let end: Int
    let confidence: Double
    let words: [TranscriptWord]
    let speaker: String?
}

public struct ParagraphsResponse: Codable {
    let paragraphs: [TranscriptParagraph]
    let id: UUID
    let confidence: Double
    let audioDuration: Int

    public enum CodingKeys: String, CodingKey {
        case paragraphs
        case id
        case confidence
        case audioDuration = "audio_duration"
    }
}

public struct PageDetails: Codable {
    let limit: Int
    let resultCount: Int
    let currentURL: URL
    let prevURL: URL?
    let nextURL: URL?

    public enum CodingKeys: String, CodingKey {
        case limit
        case resultCount = "result_count"
        case currentURL = "current_url"
        case prevURL = "prev_url"
        case nextURL = "next_url"
    }
}

public struct ListTranscriptParams: Codable {
    let limit: Int?
    let status: TranscriptStatus?
    let createdOn: Date?
    let beforeID: UUID?
    let afterID: UUID?
    let throttledOnly: Bool?

    public enum CodingKeys: String, CodingKey {
        case limit
        case status
        case createdOn = "created_on"
        case beforeID = "before_id"
        case afterID = "after_id"
        case throttledOnly = "throttled_only"
    }
}

public struct TranscriptListItem: Codable {
    let id: UUID
    let resourceURL: URL
    let status: TranscriptStatus
    let created: Date
    let completed: Date?
    let audioURL: URL
    let error: String?

    public enum CodingKeys: String, CodingKey {
        case id
        case resourceURL = "resource_url"
        case status
        case created
        case completed
        case audioURL = "audio_url"
        case error
    }
}

public struct TranscriptList: Codable {
    let pageDetails: PageDetails
    let transcripts: [TranscriptListItem]

    public enum CodingKeys: String, CodingKey {
        case pageDetails = "page_details"
        case transcripts
    }
}

public enum AudioIntelligenceModelStatus: String, Codable, CaseIterable {
    case success = "success"
    case unavailable = "unavailable"
}

public struct TopicDetectionModelResult: Codable {
    let status: AudioIntelligenceModelStatus?
    let results: [TopicDetectionResult]?
    let summary: [String: Double]?
}

public struct ContentSafetyLabelsResult: Codable {
    let status: AudioIntelligenceModelStatus?
    let results: [ContentSafetyLabelResult]?
    let summary: [String: Double]?
    let severityScoreSummary: [String: SeverityScoreSummary]?

    public enum CodingKeys: String, CodingKey {
        case status
        case results
        case summary
        case severityScoreSummary = "severity_score_summary"
    }
}

public struct Chapter: Codable {
    let summary: String
    let gist: String
    let headline: String
    let start: Int
    let end: Int
}

public struct Entity: Codable {
    let entityType: EntityType
    let text: String
    let start: Int
    let end: Int

    public enum CodingKeys: String, CodingKey {
        case entityType = "entity_type"
        case text
        case start
        case end
    }
}

public enum EntityType: String, Codable, CaseIterable {
    case bankingInformation = "banking_information"
    case bloodType = "blood_type"
    case creditCardCvv = "credit_card_cvv"
    case creditCardExpiration = "credit_card_expiration"
    case creditCardNumber = "credit_card_number"
    case date = "date"
    case dateOfBirth = "date_of_birth"
    case driversLicense = "drivers_license"
    case drug = "drug"
    case emailAddress = "email_address"
    case event = "event"
    case injury = "injury"
    case language = "language"
    case location = "location"
    case medicalCondition = "medical_condition"
    case medicalProcess = "medical_process"
    case moneyAmount = "money_amount"
    case nationality = "nationality"
    case occupation = "occupation"
    case organization = "organization"
    case password = "password"
    case personAge = "person_age"
    case personName = "person_name"
    case phoneNumber = "phone_number"
    case politicalAffiliation = "political_affiliation"
    case religion = "religion"
    case time = "time"
    case url = "url"
    case usSocialSecurityNumber = "us_social_security_number"
}

public struct SentimentAnalysisResult: Codable {
    let text: String
    let start: Int
    let end: Int
    let sentiment: Sentiment
    let confidence: Double
    let speaker: String?
}

public enum Sentiment: String, Codable, CaseIterable {
    case positive = "POSITIVE"
    case neutral = "NEUTRAL"
    case negative = "NEGATIVE"
}

public struct TopicDetectionResult: Codable {
    let text: String
    let labels: [Label]?
    let timestamp: Timestamp?
}

public struct Label: Codable {
    let relevance: Double
    let label: String
}

public struct ContentSafetyLabel: Codable {
    let label: String
    let confidence: Double
    let severity: Double
}

public struct ContentSafetyLabelResult: Codable {
    let text: String
    let labels: [ContentSafetyLabel]
    let sentencesIdxStart: Int
    let sentencesIdxEnd: Int
    let timestamp: Timestamp

    public enum CodingKeys: String, CodingKey {
        case text
        case labels
        case sentencesIdxStart = "sentences_idx_start"
        case sentencesIdxEnd = "sentences_idx_end"
        case timestamp
    }
}

public struct SeverityScoreSummary: Codable {
    let low: Double
    let medium: Double
    let high: Double
}

public struct AutoHighlightsResult: Codable {
    let status: AudioIntelligenceModelStatus
    let results: [AutoHighlightResult]
}

public struct AutoHighlightResult: Codable {
    let count: Int
    let rank: Double
    let text: String
    let timestamps: [Timestamp]
}
