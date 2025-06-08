import AssemblyAICommon
import AssemblyAIStreaming
import AsyncHTTPClient
import Foundation
import HTTPTypes
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

final class AssemblyAI_AHCTests {
    let client = {
        // get api key from environment
        let thisFile = URL(fileURLWithPath: #file)
        let rootFolder = thisFile.deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent()
        let apiKey = getEnvironmentVariable("ASSEMBLYAI_API_KEY", from: rootFolder.appendingPathComponent(".env"))!

        let authMiddleware = AuthenticationMiddleware(apiKey: apiKey)

        return Client(
            serverURL: try! Servers.Server1.url(),
            transport: AsyncHTTPClientTransport(),
            middlewares: [
                authMiddleware
            ]
        )
    }()

    @Test func testGenerateStreamingToken() async throws {
        let token = try await client.generateStreamingToken(.init(query: .init(expires_in_seconds: 60, max_session_duration_seconds: 600)))
        try dump(token.ok.body.json)
    }
}
