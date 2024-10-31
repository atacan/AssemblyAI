import Foundation

let fileURL = URL(
    string: "https://raw.githubusercontent.com/AssemblyAI/assemblyai-api-spec/refs/heads/main/openapi.yml"
)!
let destinationPaths = [
    "./Sources/AssemblyAI_AHC/openapi.yaml",
]

func downloadFile(from fileURL: URL, to destinationPaths: [String]) async throws {
    let (tempLocalUrl, _) = try await URLSession.shared.download(from: fileURL)

    let fileData = try Data(contentsOf: tempLocalUrl)
    var fileContent = try String(data: fileData, encoding: .utf8)!

    // Apply content modifications
    fileContent = fileContent
                    // Fix overflowing integers
                    .replacingOccurrences(of: "9223372036854776000", with: "922337203685477600")

    // Save to each destination path
    try await withThrowingTaskGroup(of: Void.self) { group in
        for destinationPath in destinationPaths {
            group.addTask {
                try fileContent.write(
                    toFile: destinationPath,
                    atomically: true,
                    encoding: .utf8
                )
                print("Successfully downloaded and saved file to: \(destinationPath)")
            }
        }
        try await group.waitForAll()
    }
}

// Execute the download
try await downloadFile(from: fileURL, to: destinationPaths)
