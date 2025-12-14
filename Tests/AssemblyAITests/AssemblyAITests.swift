import AssemblyAI
import AssemblyAITypes
import OpenAPIAsyncHTTPClient
import OpenAPIRuntime
import Testing
import UsefulThings
#if os(Linux)
@preconcurrency import struct Foundation.URL
@preconcurrency import struct Foundation.Data
@preconcurrency import struct Foundation.Date
#else
import struct Foundation.URL
import struct Foundation.Data
import struct Foundation.Date
#endif


struct AssemblyAITests {
    let client = {
        let envFileUrl = URL(fileURLWithPath: #filePath).deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent().appendingPathComponent(".env")
        let apiKey = getEnvironmentVariable("API_KEY", from: envFileUrl)!
        let baseURL = if let BASE_URL = getEnvironmentVariable("BASE_URL", from: envFileUrl) {
            URL(string: BASE_URL)
        } else {
            try? AssemblyAITypes.Servers.Server1.url()
        }

        return Client(
            serverURL: baseURL!,
            transport: AsyncHTTPClientTransport(),
            middlewares: [
                AuthenticationMiddleware(apiKey: apiKey)
            ]
        )
    }()

    @Test func testUploadFile_and_PollToTranscribe() async throws {
        // Upload the audio file to AssemblyAI
        let audioFileUrl = URL(fileURLWithPath: "/Users/atacan/Downloads/FF0981D5-AF30-4F35-A10C-BD907650DFD2.wav")
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

        #expect(text == wordsJoined)
        print("💬 Transcription:", text!)
    }
}
