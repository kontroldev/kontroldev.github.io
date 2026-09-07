import Foundation
import Ignite

struct SiteLayout: Layout {
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

struct RaulGallegoSite: Site {
    var name = "Raúl Gallego"
    var titleSuffix = " — Desarrollo iOS"
    var description: String? = "Notas de Raúl Gallego sobre Swift, desarrollo para plataformas Apple y Viñe."
    var url = URL(string: "https://kontroldev.github.io")!
    var author = "Raúl Gallego"
    var language: Language = .spanishSpain
    var homePage = Home()
    var layout = SiteLayout()
    var useDefaultBootstrapURLs: BootstrapOptions = .none
    var builtInIconsEnabled: BootstrapOptions = .none
    var feedConfiguration = FeedConfiguration(
        mode: .descriptionOnly,
        contentCount: 20,
        contentTypes: ["blog"]
    )

    var staticPages: [any StaticPage] {
        BlogArchive()
    }

    var articlePages: [any ArticlePage] {
        NoteArticle()
    }

    var tagPage = NotesTagPage()
}

struct Home: StaticPage {
    @Environment(\.articles) private var articles

    var title = "Blog"
    var description = "Swift, Viñe y el trabajo detrás de cada decisión."
    var image = URL(string: "https://kontroldev.github.io/og.png")

    private var notes: [Article] {
        articles.typed("blog").sorted { $0.date > $1.date }
    }

    var body: some HTML {
        BlogListing(articles: notes)
    }
}

struct BlogArchive: StaticPage {
    @Environment(\.articles) private var articles

    var title = "Blog"
    var description = "Swift, Viñe y el trabajo detrás de cada decisión."
    var path = "/blog/"

    private var notes: [Article] {
        articles.typed("blog").sorted { $0.date > $1.date }
    }

    var body: some HTML {
        BlogListing(articles: notes)
    }
}

struct BlogListing: HTML {
    let articles: [Article]

    var body: some HTML {
        Section {
            Text("Blog").font(.title1).class("page-title")

            NoteFilters()

            Section {
                ForEach(articles) { article in
                    NoteCard(article: article)
                }
            }
            .class("notes-grid")
        }
        .class("blog-home shell")
        .id("contenido")
    }
}

struct NoteCard: HTML {
    let article: Article

    private var displayTags: [String] {
        Array((article.tags ?? ["Nota"]).prefix(3))
    }

    var body: some HTML {
        Section {
            Text {
                Link(article.title, target: article)
            }
            .font(.title3)
            .class("note-card-title")

            Link(target: article) {
                Image("/vine-blog-card.svg", description: "Portada de \(article.title)")
                    .class("note-card-image")
            }

            Section {
                Section {
                    ForEach(displayTags) { tag in
                        Text(tag).class("note-card-tag")
                    }
                }
                .class("note-card-tags")

                Text(formatNumericDate(article.date)).class("note-card-date")
            }
            .class("note-card-footer")
        }
        .class("note-card")
    }
}

struct NoteFilters: HTML {
    var body: some HTML {
        Section {
            Link("Todos", target: "/").class("filter-chip active")
            Link("Viñe", target: "/tags/vine/").class("filter-chip")
            Link("Swift", target: "/tags/swift/").class("filter-chip")
            Link("SwiftUI", target: "/tags/swift-u-i/").class("filter-chip")
            Link("Producto", target: "/tags/producto/").class("filter-chip")
            Link("◔  RSS", target: "/feed.rss").class("rss-link")
        }
        .class("note-filters")
    }
}

struct NoteArticle: ArticlePage {
    var body: some HTML {
        Group {
            Section {
                Link("← Todas las notas", target: "/").class("article-back")
                Text(article.title).font(.title1).class("article-title")
                Image("/vine-blog-card.svg", description: "Portada de \(article.title)")
                    .class("article-image")
            }
            .class("article-header shell")
            .id("contenido")

            Section {
                articleBody(article.text)
            }
            .class("article-body")

            Section {
                Link("Volver a todas las notas", target: "/").class("back-button")
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
            Link("← Todas las notas", target: "/").class("article-back")
            Text(tag.name == "All Tags" ? "Todas" : tag.name).font(.title1).class("page-title")

            Section {
                ForEach(notes) { article in
                    NoteCard(article: article)
                }
            }
            .class("notes-grid tag-notes-grid")
        }
        .class("tag-page shell")
        .id("contenido")
    }
}

private func formatDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "es_ES")
    formatter.dateFormat = "d MMM yyyy"
    return formatter.string(from: date)
}

private func formatNumericDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "es_ES")
    formatter.dateFormat = "dd/MM/yy"
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
        var site = RaulGallegoSite()
        try await site.publish(
            sourceDirectory: URL(filePath: FileManager.default.currentDirectoryPath),
            buildDirectory: URL(filePath: FileManager.default.currentDirectoryPath).appending(path: "Build")
        )
    }
}
