import Foundation

/// Acceso a los archivos del repositorio desde los tests.
enum ProjectFiles {
    /// Raíz del repositorio, calculada a partir de la ubicación de este archivo.
    static let root = URL(filePath: #filePath)
        .deletingLastPathComponent() // RaulGallegoSiteTests
        .deletingLastPathComponent() // Tests
        .deletingLastPathComponent()

    static let blogDirectory = root.appending(path: "Content/blog")
    static let assetsDirectory = root.appending(path: "Assets")

    /// Todos los artículos en Markdown de `Content/blog`.
    static var blogArticles: [URL] {
        let files = (try? FileManager.default.contentsOfDirectory(
            at: blogDirectory,
            includingPropertiesForKeys: nil
        )) ?? []
        return files
            .filter { $0.pathExtension == "md" }
            .sorted { $0.lastPathComponent < $1.lastPathComponent }
    }

    static func contents(of url: URL) throws -> String {
        try String(contentsOf: url, encoding: .utf8)
    }
}

/// Lee el bloque `---` inicial de un Markdown como pares clave-valor.
func frontMatter(of markdown: String) -> [String: String]? {
    let lines = markdown.components(separatedBy: .newlines)
    guard lines.first == "---",
          let end = lines.dropFirst().firstIndex(of: "---") else {
        return nil
    }

    var values: [String: String] = [:]
    for line in lines[1..<end] {
        // Se separa solo por el primer ":" porque los títulos pueden contener más.
        guard let separator = line.firstIndex(of: ":") else { continue }
        let key = line[..<separator].trimmingCharacters(in: .whitespaces)
        let value = line[line.index(after: separator)...].trimmingCharacters(in: .whitespaces)
        values[key] = value
    }
    return values
}
