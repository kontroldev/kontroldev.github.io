import Foundation
import Ignite

struct PortfolioLayout: Layout {
    var body: some Document {
        Head {
            MetaLink(href: "/css/main.css", rel: .stylesheet)
            MetaLink(href: "/favicon.svg", rel: .icon)
            MetaTag(name: "theme-color", content: "#f5f5f7")
            MetaTag(name: "color-scheme", content: "light dark")
            MetaTag(property: "og:type", content: "website")
            MetaTag(name: "twitter:card", content: "summary_large_image")
        }
        Body { content }
    }
}

struct Portfolio: Site {
    var name = "Raúl Gallego"
    var titleSuffix = " — Desarrollo iOS"
    var description: String? = "Portfolio de Raúl Gallego, desarrollador iOS especializado en Swift y SwiftUI."
    var url = URL(string: "https://kontroldev.github.io")!
    var author = "Raúl Gallego"
    var language: Language = .spanishSpain
    var homePage = Home()
    var layout = PortfolioLayout()
    var useDefaultBootstrapURLs: BootstrapOptions = .none
    var builtInIconsEnabled: BootstrapOptions = .none
}

struct Home: StaticPage {
    var title = "Raúl Gallego — Desarrollo apps para el ecosistema Apple"
    var description = "Portfolio de Raúl Gallego, desarrollador iOS especializado en Swift y SwiftUI."
    var image = URL(string: "https://kontroldev.github.io/og.png")

    var body: some HTML { Include("home.html") }
}

@main
struct Generator {
    @MainActor
    static func main() async throws {
        var site = Portfolio()
        try await site.publish(
            sourceDirectory: URL(filePath: FileManager.default.currentDirectoryPath),
            buildDirectory: URL(filePath: FileManager.default.currentDirectoryPath).appending(path: "Build")
        )
    }
}
