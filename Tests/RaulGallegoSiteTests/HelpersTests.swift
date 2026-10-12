import Foundation
import Testing
@testable import RaulGallegoSite

@Suite("Funciones auxiliares")
struct HelpersTests {
    @Test("articleBody quita el primer párrafo")
    func articleBodyRemovesFirstParagraph() {
        let html = "<p>Entradilla</p><h2>Sección</h2><p>Texto</p>"
        #expect(articleBody(html) == "<h2>Sección</h2><p>Texto</p>")
    }

    @Test("articleBody no toca el HTML que no empieza por un párrafo")
    func articleBodyKeepsOtherHTML() {
        let html = "<h1>Título</h1><p>Texto</p>"
        #expect(articleBody(html) == html)
    }

    @Test("imagePath usa og.png cuando el artículo no tiene imagen")
    func imagePathFallsBackToOpenGraphImage() {
        #expect(imagePath(for: nil) == "/og.png")
    }

    @Test("imagePath convierte una URL absoluta en una ruta local")
    func imagePathUsesURLPath() {
        #expect(imagePath(for: "https://kontroldev.github.io/vine-blog-card.svg") == "/vine-blog-card.svg")
        #expect(imagePath(for: "/og.png") == "/og.png")
    }

    @Test("Las fechas de las tarjetas usan el formato dd/MM/yy")
    func numericDateFormat() throws {
        let date = try #require(DateComponents(calendar: .current, year: 2026, month: 9, day: 7).date)
        #expect(formatNumericDate(date) == "07/09/26")
    }

    @Test("Las fechas largas usan los meses en español")
    func longDateFormat() throws {
        let date = try #require(DateComponents(calendar: .current, year: 2026, month: 10, day: 6).date)
        #expect(formatDate(date) == "6 oct 2026")
    }
}
