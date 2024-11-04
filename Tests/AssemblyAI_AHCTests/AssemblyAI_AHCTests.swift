import AsyncHTTPClient
import Foundation
import HTTPTypes
import OpenAPIAsyncHTTPClient
import OpenAPIRuntime
import Testing

@testable import AssemblyAI_AHC

#if os(Linux)
@preconcurrency import struct Foundation.URL
@preconcurrency import struct Foundation.Data
@preconcurrency import struct Foundation.Date
#else
import struct Foundation.URL
import struct Foundation.Data
import struct Foundation.Date
#endif

final class AssemblyAI_AHCTests {
    let client = {
        // get api key from environment
        let apiKey = ProcessInfo.processInfo.environment["ASSEMBLYAI_API_KEY"]!

        let authMiddleware = AuthenticationMiddleware(apiKey: apiKey)

        return Client(
            serverURL: URL(string: "https://api.assemblyai.com")!,
            transport: AsyncHTTPClientTransport(),
            middlewares: [
                authMiddleware
            ]
        )
    }()

    @Test func testDecodingPostTranscriptResponse() throws {
        let jsonUrl = Bundle.module.url(forResource: "Resources/post_transcript_response", withExtension: "json")!
        let jsonData = try Data(contentsOf: jsonUrl)
        let transcript = try JSONDecoder().decode(Components.Schemas.Transcript.self, from: jsonData)
        #expect(transcript.id == "6cfe335a-a92c-4079-ad88-7be3f0fd7bf5")
    }

    @Test func testUploadFile_and_PollToTranscribe() async throws {
        // Upload the audio file to AssemblyAI
        let audioFileUrl = Bundle.module.url(forResource: "Resources/amazing-things", withExtension: "wav")!
        let audioData = try Data(contentsOf: audioFileUrl)

        let uploadFileResponse = try await client.uploadFile(.init(body: .binary(.init(audioData))))
        let upload_url = try uploadFileResponse.ok.body.json.upload_url

        // Make a request to the transcription endpoint with the upload URL
        let transcriptionResponse = try await client.createTranscript(.init(body: .json(.init(value1: .init(audio_url: upload_url), value2: .init()))))
        var transcript = try transcriptionResponse.ok.body.json

        while transcript.status != .completed {
            try await Task.sleep(for: .seconds(0.3))
            let updatedTranscriptResponse = try await client.getTranscript(.init(path: .init(transcript_id: transcript.id)))
            transcript = try updatedTranscriptResponse.ok.body.json
        }

        let text = transcript.text
        let wordsJoined = transcript.words?.map { $0.text }.joined(separator: " ")
        print(text)
        #expect(text == wordsJoined)
    }

    @Test func testExample() throws {
        // This is an example test case
        #expect(true)
    }
}
