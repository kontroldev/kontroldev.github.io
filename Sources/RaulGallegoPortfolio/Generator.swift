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
        Body {
            Include("site-header.html")
            content
            Include("site-footer.html")
        }
    }
}

struct Portfolio: Site {
    var name = "Raúl Gallego"
    var titleSuffix = " — Desarrollo iOS"
    var description: String? = "Portfolio y notas de Raúl Gallego, desarrollador iOS especializado en Swift y SwiftUI."
    var url = URL(string: "https://kontroldev.github.io")!
    var author = "Raúl Gallego"
    var language: Language = .spanishSpain
    var homePage = Home()
    var layout = PortfolioLayout()
    var useDefaultBootstrapURLs: BootstrapOptions = .none
    var builtInIconsEnabled: BootstrapOptions = .none
    var feedConfiguration = FeedConfiguration(
        mode: .descriptionOnly,
        contentCount: 20,
        contentTypes: ["blog"]
    )

    var staticPages: [any StaticPage] {
        Blog()
    }

    var articlePages: [any ArticlePage] {
        NoteArticle()
    }

    var tagPage = NotesTagPage()
}

struct Home: StaticPage {
    @Environment(\.articles) private var articles

    var title = "Raúl Gallego — Desarrollo apps para el ecosistema Apple"
    var description = "Portfolio y notas de Raúl Gallego, desarrollador iOS especializado en Swift y SwiftUI."
    var image = URL(string: "https://kontroldev.github.io/og.png")

    private var latestNotes: [Article] {
        Array(articles.typed("blog").sorted { $0.date > $1.date }.prefix(3))
    }

    var body: some HTML {
        Group {
            Include("home.html")
            LatestNotes(articles: latestNotes)
            Include("home-end.html")
        }
    }
}

struct Blog: StaticPage {
    @Environment(\.articles) private var articles

    var title = "Notas"
    var description = "Artículos sobre Swift, desarrollo para plataformas Apple y el trabajo detrás de Viñe."
    var path = "/blog/"

    private var notes: [Article] {
        articles.typed("blog").sorted { $0.date > $1.date }
    }

    var body: some HTML {
        Section {
            Section {
                Text("Cuaderno de desarrollo").class("kicker")
                Text("Notas sobre construir para Apple.").font(.title1)
                Text("Swift, producto y las decisiones que convierten una idea en una aplicación.")
                    .class("blog-intro")
            }
            .class("blog-heading")

            NoteFilters()

            Section {
                ForEach(notes) { article in
                    NoteCard(article: article)
                }
            }
            .class("notes-grid")
        }
        .class("blog-page shell")
        .id("contenido")
    }
}

struct LatestNotes: HTML {
    let articles: [Article]

    var body: some HTML {
        Section {
            Section {
                Text("Últimas notas").class("kicker")
                Text("El trabajo detrás del producto.").font(.title2)
                Text("Decisiones, errores y aprendizajes mientras construyo para el ecosistema Apple.")
                    .class("notes-section-copy")
            }
            .class("section-heading")

            Section {
                ForEach(articles) { article in
                    NoteCard(article: article)
                }
            }
            .class("notes-grid")

            Link("Ver todas las notas →", target: "/blog/")
                .class("all-notes-link")
        }
        .class("notes-section shell")
        .id("notas")
    }
}

struct NoteCard: HTML {
    let article: Article

    var body: some HTML {
        Section {
            Section {
                Text(article.tags?.first ?? "Nota").class("note-card-category")
                Text(formatDate(article.date)).class("note-card-date")
            }
            .class("note-card-meta")

            Text {
                Link(article.title, target: article)
            }
            .font(.title3)
            .class("note-card-title")

            Text(article.description).class("note-card-summary")

            Section {
                Text("\(article.estimatedReadingMinutes) min de lectura")
                Span("↗").class("note-card-arrow")
            }
            .class("note-card-footer")
        }
        .class("note-card")
    }
}

struct NoteFilters: HTML {
    var body: some HTML {
        Section {
            Link("Todos", target: "/blog/").class("filter-chip active")
            Link("Viñe", target: "/tags/vine/").class("filter-chip")
            Link("Swift", target: "/tags/swift/").class("filter-chip")
            Link("SwiftUI", target: "/tags/swift-u-i/").class("filter-chip")
            Link("Producto", target: "/tags/producto/").class("filter-chip")
            Link("RSS", target: "/feed.rss").class("filter-chip rss-chip")
        }
        .class("note-filters")
    }
}

struct NoteArticle: ArticlePage {
    var body: some HTML {
        Group {
            Section {
                Link("← Todas las notas", target: "/blog/").class("article-back")
                Text(article.tags?.joined(separator: " · ") ?? "Notas").class("kicker")
                Text(article.title).font(.title1).class("article-title")
                Text(article.description).class("article-intro")
                Text("\(formatDate(article.date)) · \(article.estimatedReadingMinutes) min de lectura")
                    .class("article-meta")
            }
            .class("article-header shell")
            .id("contenido")

            Section {
                articleBody(article.text)
            }
            .class("article-body")

            Section {
                Link("Volver a todas las notas", target: "/blog/").class("button secondary")
            }
            .class("article-footer shell")
        }
    }
}

struct NotesTagPage: TagPage {
    private var notes: [Article] {
        tag.articles.filter { $0.type == "blog" }.sorted { $0.date > $1.date }
    }

    var body: some HTML {
        Section {
            Link("← Todas las notas", target: "/blog/").class("article-back")
            Text("Etiqueta").class("kicker")
            Text(tag.name == "All Tags" ? "Todas las etiquetas" : tag.name).font(.title1)

            Section {
                ForEach(notes) { article in
                    NoteCard(article: article)
                }
            }
            .class("notes-grid tag-notes-grid")
        }
        .class("blog-page shell")
        .id("contenido")
    }
}

private func formatDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "es_ES")
    formatter.dateFormat = "d MMM yyyy"
    return formatter.string(from: date)
}

private func articleBody(_ html: String) -> String {
    guard html.hasPrefix("<p>"), let end = html.range(of: "</p>") else {
        return html
    }

    return String(html[end.upperBound...])
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
