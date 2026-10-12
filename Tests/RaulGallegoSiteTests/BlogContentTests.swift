import Foundation
import Testing

@Suite("Contenido del blog")
struct BlogContentTests {
    @Test("Hay artículos en Content/blog")
    func blogHasArticles() {
        #expect(!ProjectFiles.blogArticles.isEmpty)
    }

    @Test("Cada artículo tiene los metadatos obligatorios", arguments: ProjectFiles.blogArticles)
    func requiredMetadata(article: URL) throws {
        let metadata = try #require(frontMatter(of: ProjectFiles.contents(of: article)))

        for key in ["title", "subtitle", "date", "author", "tags", "image", "alt"] {
            let value = metadata[key] ?? ""
            #expect(!value.isEmpty, "Falta «\(key)» en \(article.lastPathComponent)")
        }
    }

    @Test("La fecha tiene el formato yyyy-MM-dd", arguments: ProjectFiles.blogArticles)
    func validDate(article: URL) throws {
        let metadata = try #require(frontMatter(of: ProjectFiles.contents(of: article)))
        let date = try #require(metadata["date"])

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd"
        #expect(formatter.date(from: date) != nil, "Fecha no válida: \(date)")
    }

    @Test("La imagen de portada existe en Assets", arguments: ProjectFiles.blogArticles)
    func coverImageExists(article: URL) throws {
        let metadata = try #require(frontMatter(of: ProjectFiles.contents(of: article)))
        let image = try #require(metadata["image"])
        let path = URL(string: image)?.path ?? image

        let file = ProjectFiles.assetsDirectory.appending(path: path)
        #expect(
            FileManager.default.fileExists(atPath: file.path),
            "No existe \(path) para \(article.lastPathComponent)"
        )
    }

    @Test("No hay títulos repetidos")
    func uniqueTitles() throws {
        let titles = try ProjectFiles.blogArticles.compactMap {
            frontMatter(of: try ProjectFiles.contents(of: $0))?["title"]
        }
        #expect(Set(titles).count == titles.count)
    }
}
