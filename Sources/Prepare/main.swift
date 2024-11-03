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

func runCommand(_ command: String) throws {
    let task = Process()
    let pipe = Pipe()

    task.standardOutput = pipe
    task.standardError = pipe
    task.arguments = ["-c", command]
    task.executableURL = URL(fileURLWithPath: "/bin/zsh")
    task.standardInput = nil

    try task.run()

    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output = String(data: data, encoding: .utf8)!

    print(#function, command, "\n", output)
}

let fileURL = URL(
    string: "https://raw.githubusercontent.com/AssemblyAI/assemblyai-api-spec/refs/heads/main/openapi.yml"
)!
let destinationPaths = [
    "/Users/atacan/Developer/Repositories/AssemblyAI/Sources/AssemblyAI_AHC/openapi.yaml"
]

func downloadFile(from fileURL: URL, to destinationPaths: [String]) async throws {
    let (tempLocalUrl, _) = try await URLSession.shared.download(from: fileURL)

    let fileData = try Data(contentsOf: tempLocalUrl)
    var fileContent = String(data: fileData, encoding: .utf8)!

    // Apply content modifications
    fileContent =
        fileContent
        // Fix overflowing integers
        .replacingOccurrences(of: "9223372036854776000", with: "922337203685477600")
        // Remove the null type
        .replacingOccurrences(of: #"type: [array, "null"]"#, with: "type: array")
        .replacingOccurrences(of: #"type: [boolean, "null"]"#, with: "type: boolean")
        .replacingOccurrences(of: #"type: [integer, "null"]"#, with: "type: integer")
        .replacingOccurrences(of: #"type: [number, "null"]"#, with: "type: number")
        .replacingOccurrences(of: #"type: [string, "null"]"#, with: "type: string")
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

    fileContent = try await replaceOneOfNullableReferences(text: fileContent)

    // Save to each destination path
    try await withThrowingTaskGroup(of: Void.self) { group in
        for destinationPath in destinationPaths {
            group.addTask { [fileContent] in
                try fileContent.write(
                    toFile: destinationPath,
                    atomically: true,
                    encoding: .utf8
                )
                // Downgrade to 3.0.0
                // try runCommand("openapi-down-convert --input \(destinationPath) --output \(destinationPath)")
                print("Successfully downloaded and saved file to: \(destinationPath)")
            }
        }
        try await group.waitForAll()
    }
}
// Execute the download
try await downloadFile(from: fileURL, to: destinationPaths)
