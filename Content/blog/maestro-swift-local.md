---
title: Mi maestro de Swift disponible las 24 horas, en local
subtitle: Cómo monté en mi Mac un modelo de IA especializado en Swift, alimentado con la documentación oficial de Swift 6.4 y con el material de mi formación, sin que nada salga de mi equipo.
date: 2026-10-06
author: Raúl Gallego
tags: Swift, Inteligencia artificial, Apple Silicon
image: https://kontroldev.github.io/maestro-swift-local-blog-card.png
alt: MacBook Pro con LM Studio y el modelo Qwen2.5-Coder-7B-Swift respondiendo con fuentes de Swift 6.4 y del SDP 2024, junto a un robot con birrete y libros de Swift
---

# Mi maestro de Swift disponible las 24 horas, en local

Tuve la gran suerte de que me aceptaran en la Apple Coding Academy y de poder hacer la formación del Swift Developer Program 2024. Y no, no es una opinión pagada: muchos de mis compañeros podrían decir exactamente lo mismo. La formación fue espectacular.

Allí aprendí Swift con mi maestro, Julio César Fernández. Pero Julio, como cualquier persona, no estaba disponible a las tres de la madrugada cuando me atascaba con un `async` que no compilaba. Así que me pregunté si podía tener algo parecido a ese acompañamiento las 24 horas, en modo local: sin enviar mi código a ningún servidor, sin depender de internet y sin suscripciones.

Se puede. No sustituye a un maestro de verdad (ni lo pretende), pero como compañero de estudio que responde con el estilo y los ejemplos de mi formación, funciona de maravilla. Este tutorial está pensado para equipos con un mínimo de 24 GB de RAM; yo lo monté en mi MacBook Pro M5 Pro.

<nav class="article-toc" aria-label="Contenido de la nota">
<p class="article-toc-title">En esta nota</p>
<ol>
<li><a href="#que-vamos-a-montar">Qué vamos a montar</a></li>
<li><a href="#paso-1-el-modelo">Paso 1: el modelo</a></li>
<li><a href="#paso-2-reunir-el-conocimiento">Paso 2: reunir el conocimiento</a></li>
<li><a href="#paso-3-cargarlo-en-lm-studio">Paso 3: cargarlo en LM Studio</a></li>
<li><a href="#paso-4-el-system-prompt">Paso 4: el system prompt</a></li>
<li><a href="#paso-5-ajustes-recomendados">Paso 5: ajustes recomendados</a></li>
<li><a href="#cuidar-la-memoria">Cuidar la memoria</a></li>
<li><a href="#como-comprobar-que-funciona">Cómo comprobar que funciona</a></li>
<li><a href="#y-ahora-que">Y ahora, ¿qué?</a></li>
</ol>
</nav>

<h2 id="que-vamos-a-montar">Qué vamos a montar</h2>

```text
LM Studio (en tu Mac)
  ├─ Un modelo especializado en Swift (7B, cuantizado)
  └─ Conocimiento propio (RAG):
       ├─ Documentación oficial de Swift 6.4
       └─ Material de la formación SDP 2024
```

Todo corre en `localhost`. Ni tu código ni la documentación salen de tu Mac.

<h2 id="paso-1-el-modelo">Paso 1: el modelo</h2>

Elegí **Qwen2.5-Coder-7B-Swift-Lm**, un fine-tune comunitario basado en Qwen2.5-Coder-7B-Instruct y orientado a Swift moderno: SwiftUI, concurrencia, actors, `Sendable`, `@Observable`, AppKit y Combine.

Lo importante es la versión: cuantizada, en **Q4_K_M**. La variante F16 ronda los 15 GB, demasiado para tener a la vez LM Studio, Xcode, el Simulator y el navegador. En Q4 ocupa una fracción y deja memoria de sobra.

Se descarga desde LM Studio, en la pestaña **Discover**.

<h2 id="paso-2-reunir-el-conocimiento">Paso 2: reunir el conocimiento</h2>

Un modelo no puede conocer de memoria algo tan reciente como Swift 6.4, y tampoco conoce mis clases. En lugar de reentrenarlo, usé RAG: antes de responder, el modelo consulta mis documentos. Le di tres tipos de material:

- **Documentación oficial de Swift 6.4:**
  - El Language Guide de `swiftlang/swift-book` (`TSPL.docc/LanguageGuide`).
  - Las propuestas de Swift Evolution marcadas como *Implemented (Swift 6.4)*, no todo el histórico.
  - El `CHANGELOG.md` oficial.
- **Las transcripciones de las clases** del SDP 2024.
- **El código que generó el profesor** durante la formación.

Esta última parte es la que lo convierte en "mi Julio": cuando le pregunto algo, puede apoyarse en cómo se explicó en clase y en el código real que escribimos.

Lo organicé así, un archivo por tema:

```text
~/SwiftRAG/
├── Docs-Swift-6.4/
│   ├── LanguageGuide/
│   ├── SwiftEvolution-6.4/
│   └── CHANGELOG.md
└── SDP-2024/
    ├── Transcripciones/
    └── Codigo-profesor/
```

Los archivos pequeños y con nombres descriptivos son lo que mejor funciona en un RAG, y ayudan a que LM Studio cite la fuente exacta.

<h2 id="paso-3-cargarlo-en-lm-studio">Paso 3: cargarlo en LM Studio</h2>

LM Studio trae RAG integrado ("Chat with Documents"), pero solo reconoce `.docx`, `.pdf` y `.txt`. Ni los `.md` ni los `.swift` entran tal cual. La solución es copiarlos con extensión `.txt`, porque ambos son texto plano:

```bash
cd ~/SwiftRAG
find . \( -name "*.md" -o -name "*.swift" \) -exec sh -c 'cp "$1" "$1.txt"' _ {} \;
```

Esto añade `.txt` al final del nombre (`Closures.md.txt`, `ContentView.swift.txt`), así se ve de un vistazo qué era cada archivo, y conserva los originales.

Después, en LM Studio:

1. Carga el modelo y abre una conversación nueva.
2. Pulsa el clip junto al campo de mensaje, o arrastra los archivos a la ventana del chat.
3. Selecciona los `.txt` de tu carpeta `~/SwiftRAG`.
4. Como el conjunto no cabe en el contexto del modelo, LM Studio pasa solo a modo RAG: fragmenta, indexa y recupera los trozos relevantes en cada pregunta.
5. Revisa las citas que muestra con cada respuesta: te dicen qué archivo y qué fragmento usó.

<h2 id="paso-4-el-system-prompt">Paso 4: el system prompt</h2>

Este es el prompt base que usé:

> Eres un desarrollador senior especializado en Swift e iOS. Prioriza siempre la documentación proporcionada frente a tu conocimiento de entrenamiento. Si la documentación contradice lo que recuerdas, utiliza la documentación. Si una API o comportamiento no aparece en las fuentes disponibles, indícalo claramente y no inventes.

Con material de dos épocas distintas (una formación de 2024 y documentación de Swift 6.4), conviene añadir una línea para que no mezcle versiones sin avisar:

> Si el material de la formación difiere de la documentación oficial de Swift 6.4, indícalo y dime cuál es la forma actual.

Y si lo quieres más maestro que resolvedor de problemas:

> Cuando te haga una pregunta de aprendizaje, guíame con pistas y un ejemplo sencillo antes de darme la solución completa.

<h2 id="paso-5-ajustes-recomendados">Paso 5: ajustes recomendados</h2>

- **Context Length:** entre 8192 y 16384 tokens. Más ventana significa más RAM, y para dudas puntuales no hace falta.
- **Temperature:** entre 0.2 y 0.3, para respuestas técnicas consistentes y no creativas.
- **GPU Offload:** en Apple Silicon, LM Studio usa Metal automáticamente; con un 7B en Q4 no necesitas tocarlo.

<h2 id="cuidar-la-memoria">Cuidar la memoria</h2>

Con el modelo y el índice cargados, el consumo es moderado y deja sitio para trabajar. Aun así:

- Evita tener dos simuladores de iOS abiertos a la vez.
- Cierra pestañas pesadas del navegador mientras compilas.
- Si el Mac empieza a usar swap, baja primero el Context Length antes de cambiar de modelo.

<h2 id="como-comprobar-que-funciona">Cómo comprobar que funciona</h2>

- Pregunta por una API de una propuesta concreta de Swift 6.4 (por ejemplo, los borrow accessors de SE-0507) y comprueba que cita el archivo correcto.
- Pregunta por un tema que se explicó en clase y mira si recupera la transcripción o el código del profesor.
- Pregunta por algo que no esté en tu carpeta y confirma que dice que no lo encuentra, en lugar de inventarlo.

<h2 id="y-ahora-que">Y ahora, ¿qué?</h2>

Con esto ya puedo preguntarle dudas y pedirle ayuda con código desde el chat de LM Studio, a cualquier hora. En el siguiente artículo cuento cómo conecté este mismo modelo a Xcode para usarlo sin salir del editor.
