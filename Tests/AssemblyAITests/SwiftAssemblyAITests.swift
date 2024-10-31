import Foundation
import XCTest
@testable import AssemblyAI

final class AssemblyAITests: XCTestCase {
    var referenceTestResourcesDirectory: URL! = nil
    
    /// Setup method called before the invocation of each test method in the class.
    override func setUpWithError() throws {
        self.referenceTestResourcesDirectory = try XCTUnwrap(
            Bundle.module.url(forResource: "Resources", withExtension: nil),
            "Could not find reference test resources directory."
        )
    }
    
    func test_Decoding_completed_transcript_response() throws {
        let jsonFileURL = URL(fileURLWithPath: "transcript_completed.json", relativeTo: referenceTestResourcesDirectory)
        let response = try Data(contentsOf: jsonFileURL)
        let transcript = try JSONDecoder().decode(Transcript.self, from: response)
        print(transcript)
    }
    
    func test_Decoding_default_transcript_response() throws {
        let jsonFileURL = URL(fileURLWithPath: "transcript_default.json", relativeTo: referenceTestResourcesDirectory)
        let response = try Data(contentsOf: jsonFileURL)
        let transcript = try JSONDecoder().decode(Transcript.self, from: response)
        print(transcript)
    }
    
    func test_Decoding_queeud_transcript_response() throws {
        let jsonFileURL = URL(fileURLWithPath: "transcript_queued.json", relativeTo: referenceTestResourcesDirectory)
        let response = try Data(contentsOf: jsonFileURL)
        let transcript = try JSONDecoder().decode(Transcript.self, from: response)
        print(transcript)
    }
}
