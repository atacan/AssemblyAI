# AssemblyAI Swift SDK

[![Swift 5.9+](https://img.shields.io/badge/Swift-5.9+-orange.svg)](https://swift.org)
[![Platforms](https://img.shields.io/badge/Platforms-macOS%20|%20iOS%20|%20tvOS%20|%20watchOS%20|%20Linux-blue.svg)](https://swift.org)
[![Swift Package Manager](https://img.shields.io/badge/SPM-compatible-brightgreen.svg)](https://swift.org/package-manager/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

An unofficial Swift SDK for [AssemblyAI](https://www.assemblyai.com/) - the AI platform for speech-to-text, speaker diarization, sentiment analysis, and more.

> **Note:** This is a community-maintained SDK, not an official AssemblyAI product.

## Features

- Full AssemblyAI API coverage
- Built with Apple's [Swift OpenAPI Generator](https://github.com/apple/swift-openapi-generator)
- Async/await support
- Type-safe API
- Cross-platform: macOS, iOS, tvOS, watchOS, and Linux

## Requirements

- Swift 5.9+
- macOS 13+ / iOS 16+ / tvOS 16+ / watchOS 9+

## Installation

### Swift Package Manager

Add the following to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/atacan/AssemblyAI.git", from: "1.0.0")
]
```

Then add the dependency to your target:

```swift
.target(
    name: "YourTarget",
    dependencies: [
        .product(name: "AssemblyAI", package: "AssemblyAI"),
        .product(name: "AssemblyAITypes", package: "AssemblyAI"),
    ]
)
```

### Xcode

1. File → Add Package Dependencies
2. Enter: `https://github.com/atacan/AssemblyAI.git`
3. Select your desired version

## Quick Start

### Setup

```swift
import AssemblyAI
import AssemblyAITypes
import OpenAPIAsyncHTTPClient

// Create the client with your API key
let client = Client(
    serverURL: try AssemblyAITypes.Servers.Server1.url(),
    transport: AsyncHTTPClientTransport(),
    middlewares: [
        AuthenticationMiddleware(apiKey: "your-api-key")
    ]
)
```

### Transcribe an Audio File

```swift
import Foundation

// 1. Upload your audio file
let audioData = try Data(contentsOf: audioFileURL)
let uploadResponse = try await client.uploadFile(
    .init(body: .binary(.init(audioData)))
)
let uploadUrl = try uploadResponse.ok.body.json.upload_url

// 2. Start transcription
let transcriptResponse = try await client.createTranscript(
    .init(body: .json(.init(
        value1: .init(audio_url: uploadUrl),
        value2: .init()
    )))
)
var transcript = try transcriptResponse.ok.body.json

// 3. Poll for completion
while transcript.status != .completed {
    try await Task.sleep(for: .seconds(1))
    let response = try await client.getTranscript(
        .init(path: .init(transcript_id: transcript.id))
    )
    transcript = try response.ok.body.json
}

// 4. Get the transcription text
print("Transcription: \(transcript.text ?? "")")
```

### Transcribe from URL

If your audio is already hosted online:

```swift
let response = try await client.createTranscript(
    .init(body: .json(.init(
        value1: .init(audio_url: "https://example.com/audio.mp3"),
        value2: .init()
    )))
)
```

## API Reference

### Available Endpoints

| Method | Description |
|--------|-------------|
| `uploadFile` | Upload a local audio file |
| `createTranscript` | Start a new transcription |
| `getTranscript` | Get transcription status/result |
| `listTranscripts` | List all transcripts |
| `deleteTranscript` | Delete a transcript |
| `getSubtitles` | Get subtitles (SRT/VTT) |
| `getSentences` | Get transcript split by sentences |
| `getParagraphs` | Get transcript split by paragraphs |
| `wordSearch` | Search for words in transcript |
| `createLemurTask` | Use LeMUR AI models |

### Transcription Options

Enable additional features when creating a transcript:

```swift
let response = try await client.createTranscript(
    .init(body: .json(.init(
        value1: .init(audio_url: audioUrl),
        value2: .init(
            speaker_labels: true,      // Speaker diarization
            auto_chapters: true,       // Auto chapters
            entity_detection: true,    // Entity detection
            sentiment_analysis: true,  // Sentiment analysis
            auto_highlights: true,     // Key phrases
            language_code: .en_us      // Language
        )
    )))
)
```

### Working with Results

```swift
// Get words with timestamps
if let words = transcript.words {
    for word in words {
        print("\(word.text) [\(word.start)ms - \(word.end)ms]")
    }
}

// Get speaker labels
if let utterances = transcript.utterances {
    for utterance in utterances {
        print("Speaker \(utterance.speaker): \(utterance.text)")
    }
}

// Get chapters
if let chapters = transcript.chapters {
    for chapter in chapters {
        print("\(chapter.headline): \(chapter.summary)")
    }
}
```

## Environment Variables

Create a `.env` file for local development:

```
API_KEY=your_assemblyai_api_key
```

## Examples

See the [Tests](Tests/AssemblyAITests) directory for more usage examples.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is available under the MIT License. See the [LICENSE](LICENSE) file for details.

## Related Links

- [AssemblyAI Documentation](https://www.assemblyai.com/docs)
- [AssemblyAI API Reference](https://www.assemblyai.com/docs/api-reference)
- [Swift OpenAPI Generator](https://github.com/apple/swift-openapi-generator)

---

**Keywords:** AssemblyAI Swift, AssemblyAI iOS, AssemblyAI macOS, Speech-to-Text Swift, Transcription Swift SDK, AssemblyAI Swift Package, Audio Transcription iOS, Voice Recognition Swift, ASR Swift, Automatic Speech Recognition Swift
