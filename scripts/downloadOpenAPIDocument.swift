import Foundation

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
    "./Sources/AssemblyAI_AHC/openapi.yaml"
]

func downloadFile(from fileURL: URL, to destinationPaths: [String]) async throws {
    let (tempLocalUrl, _) = try await URLSession.shared.download(from: fileURL)

    let fileData = try Data(contentsOf: tempLocalUrl)
    var fileContent = try String(data: fileData, encoding: .utf8)!

    // Apply content modifications
    fileContent =
        fileContent
        // Fix overflowing integers
        .replacingOccurrences(of: "9223372036854776000", with: "922337203685477600")
        // Remove the null type
//         .replacingOccurrences(of: #"  - type: "null""#, with: "nullable: true")
//         .replacingOccurrences(of: #"          type: [string, "null"]"#, with: """
//           type: string
//           nullable: true
// """)

    // Save to each destination path
    try await withThrowingTaskGroup(of: Void.self) { group in
        for destinationPath in destinationPaths {
            group.addTask {
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
