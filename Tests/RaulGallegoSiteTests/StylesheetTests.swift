import Foundation
import Testing

@Suite("Hoja de estilos")
struct StylesheetTests {
    private let stylesheet = ProjectFiles.assetsDirectory.appending(path: "css/main.css")

    @Test("El código dentro de los bloques no hereda el fondo del código en línea")
    func codeBlocksHaveTransparentBackground() throws {
        let css = try ProjectFiles.contents(of: stylesheet)

        // Bloque de la regla `.article-body pre code { ... }`.
        let start = try #require(css.range(of: ".article-body pre code {"))
        let end = try #require(css.range(of: "}", range: start.upperBound..<css.endIndex))
        let rule = css[start.upperBound..<end.lowerBound]

        #expect(rule.contains("background: transparent"))
        #expect(rule.contains("color: inherit"))
    }
}
