import Foundation
import Ignite

struct SiteLayout: Layout {
    var body: some Document {
        Head {
            MetaLink(href: "/css/main.css?v=20260907-2", rel: .stylesheet)
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
    var title = "Raúl Gallego"
    var description = "Desarrollador iOS en Barcelona. Swift, SwiftUI, SwiftData y aplicaciones nativas para el ecosistema Apple."
    var image = URL(string: "https://kontroldev.github.io/og.png")

    var body: some HTML {
        ProfileHome()
    }
}

struct ProfileHome: HTML {
    var body: some HTML {
        Section {
            Section {
                Text("Desarrollador iOS").font(.title1).class("profile-title")
                Text("Creo aplicaciones nativas para el ecosistema Apple, cuidando la arquitectura, la experiencia de uso y los detalles que convierten una idea en un producto útil.")
                    .class("profile-intro")
                Text("Swift · SwiftUI · SwiftData · Barcelona")
                    .class("profile-summary")
            }
            .class("profile-hero")

            Section {
                Text("Experiencia").font(.title2).class("section-title")

                ProfessionalCard(
                    organization: "MacServiceBcn · Especialistas en Apple",
                    role: "Experiencia profesional en el ecosistema Apple",
                    meta: "Barcelona, España",
                    points: [
                        "Trabajo diario con tecnología Apple y resolución de necesidades reales de usuarios.",
                        "Conocimiento del ecosistema desde la perspectiva técnica y de producto."
                    ],
                    tags: ["Apple", "Soporte técnico", "Experiencia de usuario"]
                )

                ProfessionalCard(
                    organization: "Comunidad MoureDev",
                    role: "Moderador y colaborador",
                    meta: "Comunidad de desarrollo de software",
                    points: [
                        "Facilito conversaciones, comparto conocimiento y ayudo a mantener una experiencia positiva para la comunidad.",
                        "Participo en iniciativas colaborativas y conversaciones técnicas sobre Swift."
                    ],
                    tags: ["Comunidad", "Mentoría", "Swift", "Colaboración"]
                )
            }
            .class("profile-section")
            .id("experiencia")

            Section {
                Text("Formación").font(.title2).class("section-title")

                ProfessionalCard(
                    organization: "Apple Coding Academy",
                    role: "Formación avanzada en desarrollo Apple",
                    meta: "2024–2025",
                    points: [
                        "Swift 6, SwiftUI, patrones de desarrollo y arquitectura.",
                        "SwiftData, concurrencia con async/await, trabajo en red y Swift Testing."
                    ],
                    tags: ["Swift 6", "SwiftUI", "SwiftData", "Swift Testing"]
                )
            }
            .class("profile-section")
            .id("formacion")

            Section {
                Text("Proyectos").font(.title2).class("section-title")

                Section {
                    ProjectCard(
                        name: "Viñe",
                        status: "En desarrollo",
                        description: "Aplicación iOS para organizar colecciones de cómics, seguir series y próximos lanzamientos, e importar y leer archivos CBZ y PDF.",
                        url: "https://github.com/kontroldev/PanelMax-App",
                        tags: ["Swift 6", "SwiftUI", "SwiftData", "StoreKit 2", "PDFKit"]
                    )

                    ProjectCard(
                        name: "Proyecto Pomodoro",
                        status: "Proyecto colaborativo",
                        description: "Aplicación de productividad con métricas y estadísticas, desarrollada en colaboración con la comunidad MoureDev.",
                        url: "https://github.com/kontroldev/Proyecto_1_Pomodoro",
                        tags: ["Swift", "SwiftUI", "Colaboración"]
                    )

                    ProjectCard(
                        name: "100 días de Swift",
                        status: "Aprendizaje abierto",
                        description: "Repositorio público que documenta práctica continuada y aprendizaje dentro del ecosistema Swift.",
                        url: "https://github.com/kontroldev/100-dias-de-Swift-con-MoureDev",
                        tags: ["Swift", "Práctica", "Comunidad"]
                    )

                    ProjectCard(
                        name: "Mini‑Proyectos SwiftUI",
                        status: "Laboratorio",
                        description: "Colección de pequeñas aplicaciones para explorar componentes, patrones y posibilidades de SwiftUI.",
                        url: "https://github.com/kontroldev/Mini-Proyectos-SwiftUI",
                        tags: ["SwiftUI", "iOS", "Prototipos"]
                    )
                }
                .class("project-list")
            }
            .class("profile-section")
            .id("proyectos")

            Section {
                Text("Escribo sobre el proceso, no solo sobre el resultado.").font(.title2)
                Text("En el blog documento decisiones, errores y aprendizajes mientras construyo Viñe y otros proyectos para plataformas Apple.")
                Link("Leer el blog →", target: "/blog/").class("profile-cta")
            }
            .class("blog-callout")
        }
        .class("profile-home shell")
        .id("contenido")
    }
}

struct ProfessionalCard: HTML {
    let organization: String
    let role: String
    let meta: String
    let points: [String]
    let tags: [String]

    var body: some HTML {
        Section {
            Section {
                Text(organization).font(.title3)
                Text(role).class("professional-role")
                Text(meta).class("professional-meta")
            }
            .class("professional-heading")

            Section {
                ForEach(points) { point in
                    Text(point).class("professional-point")
                }
            }
            .class("professional-copy")

            TagRow(tags: tags)
        }
        .class("professional-card")
    }
}

struct ProjectCard: HTML {
    let name: String
    let status: String
    let description: String
    let url: String
    let tags: [String]

    var body: some HTML {
        Section {
            Section {
                Text(name).font(.title3)
                Text(status).class("project-status")
            }
            .class("project-heading")
            Text(description).class("project-description")
            TagRow(tags: tags)
            Link("Ver repositorio ↗", target: url).class("project-link")
        }
        .class("project-profile-card")
    }
}

struct TagRow: HTML {
    let tags: [String]

    var body: some HTML {
        Section {
            ForEach(tags) { tag in
                Text(tag)
            }
        }
        .class("profile-tags")
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
            Link("Todos", target: "/blog/").class("filter-chip active")
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
                Link("← Todas las notas", target: "/blog/").class("article-back")
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
                Link("Volver a todas las notas", target: "/blog/").class("back-button")
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
