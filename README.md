# Portfolio de Raúl Gallego

Portfolio personal de [Raúl Gallego](https://github.com/kontroldev), desarrollador de aplicaciones para el ecosistema Apple. La web está creada con Swift e [Ignite](https://github.com/twostraws/Ignite), se genera como un sitio completamente estático y se publica mediante GitHub Pages.

**Web:** [kontroldev.github.io](https://kontroldev.github.io)

## Qué contiene

- Presentación profesional y enlaces de contacto.
- Proyecto destacado con sus tecnologías principales.
- Diseño responsive para escritorio, tablet y móvil.
- Compatibilidad automática con los modos claro y oscuro del sistema.
- Metadatos básicos para buscadores y redes sociales.
- Navegación accesible, enlace para saltar al contenido y soporte para movimiento reducido.

## Tecnologías

- **Swift 6** para definir y ejecutar el generador.
- **Ignite 0.6.9** para convertir la estructura del sitio en archivos estáticos.
- **HTML y CSS** para el contenido editorial y el diseño visual personalizado.
- **Swift Package Manager** para gestionar Ignite y sus dependencias.
- **GitHub Actions y GitHub Pages** para compilar y publicar automáticamente la web.

## Cómo está creada con Ignite

Ignite es un generador de sitios estáticos para desarrolladores Swift. Permite describir la estructura de una web con tipos y una sintaxis familiar para quien trabaja con Swift, y después produce HTML, CSS, JavaScript y otros recursos listos para servir desde cualquier alojamiento estático.

Este portfolio combina Ignite con HTML personalizado:

1. `Package.swift` declara el proyecto como un ejecutable Swift y añade Ignite como dependencia.
2. `PortfolioLayout` construye el documento común e incorpora la hoja de estilos y los metadatos.
3. `Portfolio` adopta `Site` y configura el nombre, la URL, el idioma, la descripción y la página inicial.
4. `Home` adopta `StaticPage` e inserta el contenido de `Includes/home.html` mediante `Include`.
5. `Generator.main()` llama a `site.publish(...)` para generar el resultado final en `Build/`.
6. Los archivos de `Assets/` se copian al sitio generado conservando su organización.

El punto de entrada se encuentra en `Sources/RaulGallegoPortfolio/Generator.swift`:

```swift
@main
struct Generator {
    @MainActor
    static func main() async throws {
        var site = Portfolio()
        try await site.publish(
            sourceDirectory: URL(filePath: FileManager.default.currentDirectoryPath),
            buildDirectory: URL(filePath: FileManager.default.currentDirectoryPath)
                .appending(path: "Build")
        )
    }
}
```

## Estructura del proyecto

```text
.
├── .github/workflows/pages.yml
├── Assets/
│   ├── css/main.css
│   └── og.png
├── Includes/
│   └── home.html
├── Sources/RaulGallegoPortfolio/
│   └── Generator.swift
├── Package.resolved
├── Package.swift
└── README.md
```

- `Sources/`: configuración del sitio, layout, página inicial y proceso de generación.
- `Includes/`: fragmentos HTML incorporados por Ignite.
- `Assets/`: estilos e imágenes que se copian al resultado final.
- `Build/`: web generada. Se crea de nuevo en cada compilación y no debe editarse manualmente.
- `.github/workflows/pages.yml`: automatización de compilación y despliegue.

## Ejecutar el portfolio en local

### Requisitos

- macOS 14 o posterior.
- Xcode o las Command Line Tools con soporte para Swift 6.
- Git.

### Generar la web

```sh
git clone https://github.com/kontroldev/kontroldev.github.io.git
cd kontroldev.github.io
swift package resolve
swift run
```

Al terminar, Ignite crea la web en `Build/`.

### Previsualizarla

Es recomendable servir `Build/` mediante un servidor local. Abrir `Build/index.html` directamente puede impedir que el navegador encuentre rutas absolutas como `/css/main.css`.

Por ejemplo, con Python:

```sh
python3 -m http.server 8000 --directory Build
```

Después abre [http://localhost:8000](http://localhost:8000) en el navegador.

Si tienes instalada la herramienta de línea de comandos de Ignite, también puedes usar su modo de previsualización:

```sh
ignite run --preview
```

## Cómo modificar esta web

- Edita el contenido visible en `Includes/home.html`.
- Ajusta colores, tipografía, composición y breakpoints en `Assets/css/main.css`.
- Cambia el título, la descripción, la URL o los metadatos sociales en `Generator.swift`.
- Ejecuta `swift run` después de cada cambio para regenerar `Build/`.
- Comprueba el resultado desde un servidor local en varios tamaños de pantalla y en modo claro y oscuro.

## Crear una web similar desde cero

La forma más directa de reproducir este enfoque es crear un paquete ejecutable de Swift y añadir Ignite como dependencia:

```sh
mkdir MiPortfolio
cd MiPortfolio
swift package init --type executable
mkdir -p Assets/css Includes
mkdir -p Sources/MiPortfolio
mv Sources/main.swift Sources/MiPortfolio/Generator.swift
```

En `Package.swift`, añade Ignite al paquete y al target ejecutable:

```swift
// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "MiPortfolio",
    platforms: [.macOS(.v14)],
    dependencies: [
        .package(
            url: "https://github.com/twostraws/Ignite.git",
            from: "0.6.0"
        )
    ],
    targets: [
        .executableTarget(
            name: "MiPortfolio",
            dependencies: [
                .product(name: "Ignite", package: "Ignite")
            ]
        )
    ]
)
```

A continuación:

1. Crea un tipo que adopte `Layout` para definir la estructura común del documento.
2. Crea un tipo que adopte `StaticPage` para cada página estática.
3. Crea un tipo que adopte `Site` y asigna su página inicial y su layout.
4. Añade un punto de entrada `@main` que ejecute `publish()`.
5. Coloca recursos estáticos en `Assets/` y, si los necesitas, fragmentos HTML en `Includes/`.
6. Ejecuta `swift run` y sirve la carpeta `Build/` localmente.

Ignite también dispone de una herramienta de línea de comandos capaz de crear una plantilla inicial con:

```sh
ignite new MiPortfolio
```

La documentación y las instrucciones para instalar esa herramienta están en el [repositorio oficial de Ignite](https://github.com/twostraws/Ignite).

## Publicación en GitHub Pages

Cada `push` a `main` inicia el workflow `.github/workflows/pages.yml`:

1. GitHub Actions descarga el repositorio.
2. Ejecuta `swift run -c release` en macOS.
3. Sube la carpeta `Build/` como artefacto de Pages.
4. El job de despliegue publica el artefacto en GitHub Pages.

Para reutilizar el workflow en otro repositorio, configura **Settings → Pages → Build and deployment → Source** con la opción **GitHub Actions** y adapta la propiedad `url` del tipo `Site` al dominio final.

## Recursos

- [Repositorio oficial de Ignite](https://github.com/twostraws/Ignite)
- [Documentación de GitHub Pages](https://docs.github.com/pages)
- [Código fuente de este portfolio](https://github.com/kontroldev/kontroldev.github.io)
