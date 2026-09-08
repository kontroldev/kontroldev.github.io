---
title: Viñe, una aplicación para disfrutar tu colección de cómics
subtitle: Una aplicación con una dirección clara.
date: 2026-09-07
author: Raúl Gallego
tags: Viñe, Swift, SwiftUI, Producto
image: https://kontroldev.github.io/vine-blog-card.svg
alt: Portada de Viñe, una aplicación para disfrutar tu colección de cómics
---

# Viñe, una aplicación para disfrutar tu colección de cómics

Viñe es una aplicación para organizar colecciones de cómics, seguir series y próximos lanzamientos, e importar y leer archivos CBZ y PDF. El proyecto ya tiene nombre propio y una dirección clara.

<nav class="article-toc" aria-label="Contenido de la nota">
<p class="article-toc-title">En esta nota</p>
<ol>
<li><a href="#el-punto-de-partida">El punto de partida</a></li>
<li><a href="#las-decisiones">Las decisiones</a></li>
<li><a href="#el-desarrollo">El desarrollo</a></li>
<li><a href="#el-resultado-que-busco">El resultado que busco</a></li>
<li><a href="#lo-aprendido-hasta-ahora">Lo aprendido hasta ahora</a></li>
</ol>
</nav>

<h2 id="el-punto-de-partida">El punto de partida</h2>

Una colección crece de muchas formas: números sueltos, series abiertas, próximos lanzamientos y archivos digitales guardados en distintos lugares. La idea de Viñe es reunir todo eso en una experiencia nativa, clara y agradable de usar.

No quiero que sea solo una lista de títulos. El objetivo es que ayude a entender qué tienes, qué estás siguiendo y qué quieres leer después.

<h2 id="las-decisiones">Las decisiones</h2>

Viñe está construida para el ecosistema Apple con Swift y SwiftUI. SwiftData se ocupa de la biblioteca, PDFKit e ImageIO ayudan con los formatos de lectura y ZIPFoundation permite trabajar con archivos CBZ. StoreKit 2 formará parte de la preparación comercial de la aplicación.

La prioridad es que cada decisión técnica tenga una razón visible en el producto: rapidez, privacidad, una biblioteca ordenada y una lectura que se sienta natural.

<h2 id="el-desarrollo">El desarrollo</h2>

El trabajo continúa alrededor de tres áreas principales:

- Organizar la colección y sus series.
- Importar y leer cómics en CBZ y PDF.
- Seguir próximos lanzamientos sin añadir complejidad innecesaria.

En próximas notas iré explicando estas partes por separado, incluyendo los problemas encontrados y las decisiones que hayan cambiado durante el desarrollo.

<h2 id="el-resultado-que-busco">El resultado que busco</h2>

Viñe debe sentirse como una aplicación Apple desde el primer gesto: directa, rápida y cuidadosa con los detalles. Este cuaderno servirá para enseñar el proceso real, no solo el resultado terminado.

<h2 id="lo-aprendido-hasta-ahora">Lo aprendido hasta ahora</h2>

Poner nombre al proyecto también ayuda a definirlo. Viñe representa la aplicación que quiero construir y compartir.
