import Foundation
import RegexBuilder

func replaceOneOfNullableReferences(text: String) async throws -> String {
    let oneOfTypeNullRegex = /([ ]+)oneOf:\n[ ]+-[ ]+(\$ref: "#\/components\/schemas\/[^"]+")\n[ ]+-[ ]+type: "null"/

    // Replace all matches with their captured reference
    let newText = text.replacing(oneOfTypeNullRegex) { match in
        "\(match.1)\(match.2)"
    }
    return newText
}

func replaceNullTypes(text: String) async throws -> String {
    text
        // MARK: - Remove the null type

        .replacingOccurrences(of: #"type: [array, "null"]"#, with: "type: array")
        .replacingOccurrences(of: #"type: [boolean, "null"]"#, with: "type: boolean")
        .replacingOccurrences(of: #"type: [integer, "null"]"#, with: "type: integer")
        .replacingOccurrences(of: #"type: [number, "null"]"#, with: "type: number")
        .replacingOccurrences(of: #"type: [string, "null"]"#, with: "type: string")

        // MARK: - Fix nullable properties

        .replacingOccurrences(
            of: """
                          oneOf:
                            - anyOf:
                                - $ref: "#/components/schemas/TranscriptLanguageCode"
                                - type: string
                            - type: "null"
                """,
            with: """
                          anyOf:
                            - $ref: "#/components/schemas/TranscriptLanguageCode"
                            - type: string
                """
        )
        .replacingOccurrences(
            of: """
                      required:
                        - id
                        - speech_model
                        - language_model
                        - acoustic_model
                        - status
                        - audio_url
                        - webhook_auth
                        - auto_highlights
                        - redact_pii
                        - summarization
                        - language_confidence_threshold
                        - language_confidence
                """,
            with: """
                      required:
                        - audio_url
                        - auto_highlights
                        - id
                        - redact_pii
                        - status
                        - summarization
                        - webhook_auth
                """
        )
        .replacingOccurrences(
            of: """
                      required:
                        - status
                        - results
                        - summary
                        - severity_score_summary
                """,
            with: ""
        )
        .replacingOccurrences(
            of: """
                    TopicDetectionModelResult:
                      x-label: Topic Detection result
                      description: |
                        The result of the Topic Detection model, if it is enabled.
                        See [Topic Detection](https://www.assemblyai.com/docs/models/topic-detection) for more information.
                      x-fern-sdk-group-name: transcripts
                      type: object
                      required:
                        - status
                        - results
                        - summary
                """,
            with: """
                    TopicDetectionModelResult:
                      x-label: Topic Detection result
                      description: |
                        The result of the Topic Detection model, if it is enabled.
                        See [Topic Detection](https://www.assemblyai.com/docs/models/topic-detection) for more information.
                      x-fern-sdk-group-name: transcripts
                      type: object
                """
        )
        .replacingOccurrences(
            of: """
                    Transcript:
                      x-label: Transcript
                      description: A transcript object
                      type: object
                      x-fern-sdk-group-name: transcripts
                      additionalProperties: false
                """,
            with: """
                    Transcript:
                      x-label: Transcript
                      description: A transcript object
                      type: object
                      x-fern-sdk-group-name: transcripts
                      additionalProperties: true
                """
        )
        .replacingOccurrences(
            of: """
                    TranscriptWord:
                      x-label: Word
                      type: object
                      x-fern-sdk-group-name: transcripts
                      additionalProperties: false
                      required:
                        - confidence
                        - start
                        - end
                        - text
                        - speaker
                """,
            with: """
                    TranscriptWord:
                      x-label: Word
                      type: object
                      x-fern-sdk-group-name: transcripts
                      additionalProperties: false
                      required:
                        - confidence
                        - start
                        - end
                        - text
                """
        )
        .replacingOccurrences(
            of: """
    TranscriptSentence:
      x-label: Sentence
      type: object
      x-fern-sdk-group-name: transcripts
      additionalProperties: false
      required:
        - text
        - start
        - end
        - confidence
        - words
        - speaker
""",
            with: """
    TranscriptSentence:
      x-label: Sentence
      type: object
      x-fern-sdk-group-name: transcripts
      additionalProperties: false
      required:
        - text
        - start
        - end
        - confidence
        - words
"""
        )
}

// MARK: - Fix Response Content Types

func replaceResponseContentTypes(text: String) async throws -> String {

    return text.replacingOccurrences(of: """
      responses:
        "200":
          description: The exported captions as text
          content:
            text/plain:
              schema:
                type: string
                example: |
                  WEBVTT
                  00:12.340 --> 00:16.220
                  Last year I showed these two slides said that demonstrate
                  00:16.200 --> 00:20.040
                  that the Arctic ice cap which for most of the last 3,000,000 years has been the
                  00:20.020 --> 00:25.040
                  size of the lower 48 States has shrunk by 40% but this understates
              examples:
                srt:
                  $ref: "#/components/examples/SrtSubtitlesResponse"
                vtt:
                  $ref: "#/components/examples/VttSubtitlesResponse"
""", with: """
      responses:
        "200":
          description: The exported captions as text
          content:
            text/plain:
              schema:
                type: string
                example: |
                  WEBVTT
                  00:12.340 --> 00:16.220
                  Last year I showed these two slides said that demonstrate
                  00:16.200 --> 00:20.040
                  that the Arctic ice cap which for most of the last 3,000,000 years has been the
                  00:20.020 --> 00:25.040
                  size of the lower 48 States has shrunk by 40% but this understates
              examples:
                srt:
                  $ref: "#/components/examples/SrtSubtitlesResponse"
                vtt:
                  $ref: "#/components/examples/VttSubtitlesResponse"
            text/html:
              schema:
                type: string
"""
    )
    .replacingOccurrences(of: """
  responses:
    BadRequest:
      x-label: Bad request
      description: Bad request
      content:
        application/json:
          schema:
            $ref: "#/components/schemas/Error"
          example: { "error": "This is a sample error message" }
    Unauthorized:
      x-label: Unauthorized
      description: Unauthorized
      content:
        application/json:
          schema:
            $ref: "#/components/schemas/Error"
          example:
            { "error": "Authentication error, API token missing/invalid" }
    NotFound:
      x-label: Not found
      description: Not found
      content:
        application/json:
          schema:
            $ref: "#/components/schemas/Error"
          example: { "error": "Not found" }
    TooManyRequests:
      x-label: Too many requests
      description: Too many requests
      content:
        application/json:
          schema:
            $ref: "#/components/schemas/Error"
          example: { "error": "Too Many Requests" }
      headers:
        Retry-After:
          description: The number of seconds to wait before retrying the request
          schema:
            type: integer
    InternalServerError:
      x-label: Internal server error
      description: An error occurred while processing the request
      content:
        application/json:
          schema:
            $ref: "#/components/schemas/Error"
          example: { "error": "Internal Server Error" }
    ServiceUnavailable:
      x-label: Service unavailable
      description: Service unavailable
    GatewayTimeout:
      x-label: Gateway timeout
      description: Gateway timeout

  securitySchemes:
    ApiKey:
      type: apiKey
      in: header
      name: Authorization
""", with: """
  responses:
    BadRequest:
      x-label: Bad request
      description: Bad request
      content:
        application/json:
          schema:
            $ref: "#/components/schemas/Error"
          example: { "error": "This is a sample error message" }
        text/plain:
          schema:
            type: string
          example: This is a sample error message
    Unauthorized:
      x-label: Unauthorized
      description: Unauthorized
      content:
        application/json:
          schema:
            $ref: "#/components/schemas/Error"
          example:
            { "error": "Authentication error, API token missing/invalid" }
        text/plain:
          schema:
            type: string
          example: Authentication error, API token missing/invalid
    NotFound:
      x-label: Not found
      description: Not found
      content:
        application/json:
          schema:
            $ref: "#/components/schemas/Error"
          example: { "error": "Not found" }
        text/plain:
          schema:
            type: string
          example: Not found
    TooManyRequests:
      x-label: Too many requests
      description: Too many requests
      content:
        application/json:
          schema:
            $ref: "#/components/schemas/Error"
          example: { "error": "Too Many Requests" }
        text/plain:
          schema:
            type: string
          example: Too Many Requests
      headers:
        Retry-After:
          description: The number of seconds to wait before retrying the request
          schema:
            type: integer
    InternalServerError:
      x-label: Internal server error
      description: An error occurred while processing the request
      content:
        application/json:
          schema:
            $ref: "#/components/schemas/Error"
          example: { "error": "Internal Server Error" }
        text/plain:
          schema:
            type: string
          example: Internal Server Error
    ServiceUnavailable:
      x-label: Service unavailable
      description: Service unavailable
    GatewayTimeout:
      x-label: Gateway timeout
      description: Gateway timeout

  securitySchemes:
    ApiKey:
      type: apiKey
      in: header
      name: Authorization
""")
}

func runCommand(_ command: String, workingDirectory: String? = nil) throws {
    let task = Process()
    let pipe = Pipe()

    task.standardOutput = pipe
    task.standardError = pipe
    task.arguments = ["-c", command]
    task.executableURL = URL(fileURLWithPath: "/bin/zsh")
    task.standardInput = nil

    if let workingDirectory {
        task.currentDirectoryURL = URL(fileURLWithPath: workingDirectory)
    }

    try task.run()

    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output = String(data: data, encoding: .utf8)!

    print(#function, command, "\n", output)
}

func downloadFile(from fileURL: URL, to destinationUrls: [URL]) async throws {
    let (tempLocalUrl, _) = try await URLSession.shared.download(from: fileURL)

    let fileData = try Data(contentsOf: tempLocalUrl)
    var fileContent = String(data: fileData, encoding: .utf8)!

    // Apply content modifications
    fileContent = try await replaceNullTypes(text: fileContent)
    fileContent = try await replaceOneOfNullableReferences(text: fileContent)
    fileContent = try await replaceResponseContentTypes(text: fileContent)

    // Save to each destination path
    try await withThrowingTaskGroup(of: Void.self) { group in
        for destinationUrl in destinationUrls {
            group.addTask { [fileContent] in
                try fileContent.write(
                    to: destinationUrl,
                    atomically: true,
                    encoding: .utf8
                )
                do {
                    let originalContent = String(data: fileData, encoding: .utf8)!
                    // Save the file to the same folder with name "original.yaml"
                    let originalFileURL = destinationUrl.deletingLastPathComponent().appendingPathComponent("original.yaml")
                    try originalContent.write(to: originalFileURL, atomically: true, encoding: .utf8)
                }
                // Downgrade to 3.0.0
                // try runCommand("openapi-down-convert --input \(destinationPath) --output \(destinationPath)")
                print("Successfully downloaded and saved file to: \(destinationUrl)")
            }
        }
        try await group.waitForAll()
    }
}

// MARK: - Execute

let currentFile = URL(fileURLWithPath: #file)
let projectRoot =
    currentFile
    .deletingLastPathComponent()  // Remove 'main.swift'
    .deletingLastPathComponent()  // Remove 'Prepare'
    .deletingLastPathComponent()  // Remove 'Sources'

let destinationUrls = [
    projectRoot
        .appendingPathComponent("Sources")
        .appendingPathComponent("AssemblyAI_AHC")
        .appendingPathComponent("openapi.yaml")
]

// Execute the download
let remoteFileURL = URL(
    string: "https://raw.githubusercontent.com/AssemblyAI/assemblyai-api-spec/refs/heads/main/openapi.yml"
)!

try await downloadFile(from: remoteFileURL, to: destinationUrls)
// Generate the code
try runCommand("make generate-openapi", workingDirectory: projectRoot.path)
