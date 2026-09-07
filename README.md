# Notas de Raúl Gallego

Blog personal de [Raúl Gallego](https://github.com/kontroldev) sobre Swift, desarrollo para plataformas Apple y el trabajo detrás de Viñe.

La web está creada con Swift e [Ignite](https://github.com/twostraws/Ignite), se genera como un sitio completamente estático y se publica mediante GitHub Pages.

**Web:** [kontroldev.github.io](https://kontroldev.github.io)

## Contenido

- Portada con todas las notas ordenadas por fecha.
- Entradas escritas en Markdown.
- Filtros y páginas por etiquetas.
- Tiempo estimado de lectura.
- Índice interno para artículos extensos.
- RSS, sitemap y metadatos para buscadores y redes sociales.
- Diseño responsive con modos claro y oscuro, inspirado en la estructura del blog de Jorge Calderita y adaptado a la identidad azul de KontrolDev.

## Estructura

```text
.
├── .github/workflows/pages.yml
├── Assets/
│   ├── css/main.css
│   ├── og.png
│   └── vine-blog-card.svg
├── Content/blog/
│   └── vine-una-app-para-tu-coleccion.md
├── Includes/
│   ├── site-header.html
│   └── site-footer.html
├── Sources/RaulGallegoPortfolio/
│   └── Generator.swift
├── Package.resolved
├── Package.swift
└── README.md
```

- `Content/blog/`: artículos Markdown y sus metadatos.
- `Generator.swift`: portada, tarjetas, filtros, páginas de etiquetas y plantilla de artículo.
- `Assets/css/main.css`: identidad visual y diseño responsive.
- `Assets/vine-blog-card.svg`: portada reutilizada por la tarjeta y el artículo de Viñe.
- `Includes/`: cabecera y pie compartidos.
- `Build/`: resultado generado por Ignite; no debe editarse manualmente.

## Añadir una nota

Crea un archivo Markdown dentro de `Content/blog/`:

```yaml
---
title: Título de la nota
subtitle: Una explicación breve.
date: 2026-09-07
author: Raúl Gallego
tags: Swift, SwiftUI, Producto
---

# Título de la nota

Contenido del artículo.
```

El primer encabezado Markdown permite que Ignite identifique correctamente el título y no se repite dentro del cuerpo del artículo.

Al generar la web, Ignite actualiza automáticamente la portada, las páginas de etiquetas, el RSS y el sitemap.

## Generar y revisar en local

Requisitos: macOS 14 o posterior, Swift 6 y Git.

```sh
git clone https://github.com/kontroldev/kontroldev.github.io.git
cd kontroldev.github.io
swift package resolve
swift run
python3 -m http.server 8000 --directory Build
```

Después abre [http://localhost:8000](http://localhost:8000).

También puedes previsualizarla con la herramienta de Ignite:

```sh
ignite run --preview
```

## Publicación

Cada `push` a `main` inicia `.github/workflows/pages.yml`. GitHub Actions genera la web con `swift run -c release` y publica el contenido de `Build/` en GitHub Pages.

## Recursos

- [Ignite](https://github.com/twostraws/Ignite)
- [GitHub Pages](https://docs.github.com/pages)
- [Código fuente de la web](https://github.com/kontroldev/kontroldev.github.io)
