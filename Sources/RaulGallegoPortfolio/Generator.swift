import Foundation
import RaulGallegoSite

@main
struct Generator {
    @MainActor
    static func main() async throws {
        try await publishSite(from: URL(filePath: FileManager.default.currentDirectoryPath))
    }
}
