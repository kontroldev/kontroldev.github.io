---
title: Reabrí un proyecto en equipo dos años después, y nadie lo había documentado
subtitle: Qué me encontré al retomar una app comunitaria de Dragon Ball en SwiftUI, qué problemas resolví y qué todavía no puedo darte por bueno.
date: 2026-10-12
author: Raúl Gallego
tags: Swift, SwiftUI, Refactorización
image: https://kontroldev.github.io/proyecto-heredado-sin-documentar-blog-card.png
alt: MacBook Pro con Xcode mostrando código Swift de una app de Dragon Ball en refactorización, junto a un iPhone con la lista de personajes y una bola de dragón de cuatro estrellas
---

# Reabrí un proyecto en equipo dos años después, y nadie lo había documentado

Hace dos años participé en un proyecto comunitario de Dragon Ball, una app iOS en SwiftUI. Ahora lo he retomado en una rama propia para refactorizarlo, y me he encontrado con lo que le pasa a casi todo el mundo cuando hereda código: sin documentación, sin recordar nada y con cosas rotas. Te cuento qué problemas salieron, cómo los resolví y qué todavía no puedo darte por bueno.

<nav class="article-toc" aria-label="Contenido de la nota">
<p class="article-toc-title">En esta nota</p>
<ol>
<li><a href="#como-empezo-todo">Cómo empezó todo</a></li>
<li><a href="#primer-golpe-firebase-bloquea-la-app">Primer golpe: Firebase falla y la app entera se queda bloqueada</a></li>
<li><a href="#segundo-golpe-problemas-que-el-compilador-no-avisa">Segundo golpe: problemas que el compilador no te avisa</a></li>
<li><a href="#tercer-golpe-las-apis-desaparecen">Tercer golpe: las APIs desaparecen</a></li>
<li><a href="#la-decision-grande-mi-propio-backend">La decisión grande: montar mi propio backend</a></li>
<li><a href="#como-he-trabajado-con-ia">Cómo he trabajado con IA</a></li>
<li><a href="#lo-que-esta-comprobado-y-lo-que-no">Lo que está comprobado y lo que no</a></li>
<li><a href="#lo-que-me-llevo">Lo que me llevo</a></li>
</ol>
</nav>

<h2 id="como-empezo-todo">Cómo empezó todo</h2>

Muchos de los que estamos en la comunidad MoureDev no tenemos formación reglada. Por eso, un día nos lanzamos a montar este proyecto: trabajar como un equipo de verdad, repartirnos tareas, coordinarnos y tocar código que no habías escrito tú. Justo lo que no te enseña ningún tutorial.

Salió bien, pero siempre me quedó la espinita de que se podía haber hecho mejor. Así que dos años después abrí una rama aparte en Git, con la idea de arreglar lo que estaba mal y aplicar todo lo que he aprendido desde entonces.

Y fue exactamente como un trabajo real: un proyecto heredado, sin documentar, que llevaba años sin abrir. Aquí tuve suerte. Como entiendo Swift, pude leer el código, entender qué hacía cada pieza y ver dónde podía aportar. Sin eso, me habría costado mucho más.

<h2 id="primer-golpe-firebase-bloquea-la-app">Primer golpe: Firebase falla y la app entera se queda bloqueada</h2>

El login de Google/Firebase empezó a fallar, y estaba enganchado al arranque. Resultado: si el login no respondía, nadie podía ver la wiki ni jugar. Para colmo, al subir a Swift 6 el compilador empezó a quejarse de código que hasta entonces compilaba tan tranquilo.

Desacoplé Firebase del arranque y subí el proyecto a Swift 6. Me quedé con una lección que ahora tengo muy clara: una dependencia que no controlas no puede estar en el camino crítico de tu app.

<h2 id="segundo-golpe-problemas-que-el-compilador-no-avisa">Segundo golpe: problemas que el compilador no te avisa</h2>

Leyendo el código fui encontrando cosas que no daban error, pero que no estaban bien:

- Servicios duplicados para hacer lo mismo.
- Errores de red que solo salían por consola, así que el usuario no veía nada.
- Forzados con `!` por todas partes, con riesgo de que la app se cerrara.
- Procesamiento de imágenes en el hilo principal.

Lo arreglé creando un cliente de red reutilizable, inyectando dependencias para poder probar sin conexión, sacando el procesamiento de imágenes del hilo principal y añadiendo un adaptador entre el modelo de la API y el de las vistas.

Ese adaptador fue lo que más compensó. Pocos días después la API cambió y la interfaz casi ni se enteró.

<h2 id="tercer-golpe-las-apis-desaparecen">Tercer golpe: las APIs desaparecen</h2>

El 19 de septiembre, los dos endpoints que usaba la app dejaron de responder. Se cayeron la wiki y los favoritos. La API nueva no tenía rutas por saga, así que cambié las categorías por filtros locales. De paso arreglé un fallo del buscador (una búsqueda sin resultados mostraba todo el catálogo) y añadí estados de carga y error con botón de reintentar.

Hay un detalle del que estoy especialmente contento: el listado nuevo no trae planeta ni transformaciones, así que esos datos se piden al abrir la ficha. No usé otro dato como sustituto ni me inventé nada. Prefiero un dato ausente a uno falso.

<h2 id="la-decision-grande-mi-propio-backend">La decisión grande: montar mi propio backend</h2>

Después de tres roturas por culpa de terceros, decidí dejar de depender de Firebase y empecé a montar mi propio servidor con Vapor, PostgreSQL y JWTKit, sin pagar nada. La parte que más disfruté fue la seguridad:

- El servidor valida el login de Google y crea su propia sesión de siete días, guardando solo su hash.
- El usuario sale siempre de la sesión verificada, nunca de un dato que mande el cliente.
- En la app, la sesión vive en Keychain y los favoritos de una cuenta nunca se pueden mezclar con los de otra.

Como extra, me animé con un juego de cartas online para cuatro jugadores. Aquí el servidor manda: valida cada jugada y cada jugador solo recibe su propia mano, así que hacer trampas es imposible. Para evitar que dos jugadas simultáneas se pisen, uso bloqueo de filas en la base de datos junto con un número de versión.

<!-- TODO: captura de la app y diagrama sencillo (app → servidor → base de datos) -->

<h2 id="como-he-trabajado-con-ia">Cómo he trabajado con IA</h2>

Lo digo claro: he usado IA durante todo el proceso, pero no para pedirle "hazme el backend" y copiar lo que saliera. Cuando llegaba a una bifurcación y no sabía qué camino coger, le pedía que me explicara las opciones con sus ventajas y sus problemas. Y después elegía yo.

Cuando una explicación no me cuadraba, o sonaba convincente pero no terminaba de entenderla, tiraba de mi comodín: la documentación oficial. Así aprendí algo importante: una respuesta que suena segura no tiene por qué ser la correcta.

<h2 id="lo-que-esta-comprobado-y-lo-que-no">Lo que está comprobado y lo que no</h2>

Esta es la parte que más me importa.

**Comprobado:** 23 pruebas de regresión con Swift 6, compilación de las 75 fuentes del target principal, y pruebas del backend con 100 partidas completas que siempre conservan las 108 cartas.

**Todavía pendiente:** la compilación completa en Xcode, probar en dispositivo real (incluido el login de Google), el despliegue y los bloqueos sobre PostgreSQL, porque mis tests usaron SQLite y no los valida.

No voy a decirte que algo funciona si no lo he visto funcionar.

<h2 id="lo-que-me-llevo">Lo que me llevo</h2>

- Documenta tu código. Yo habría tardado mucho menos si alguien lo hubiera hecho hace dos años, y ahora me toca a mí dejarlo mejor para el siguiente.
- Los servicios externos no van en el camino crítico.
- Un adaptador entre la API y la interfaz absorbe los cambios.
- Inyectar dependencias es lo que permite probar sin red.
- La IA acelera, pero la decisión y la responsabilidad son tuyas.
- Decir lo que no has probado genera más confianza que presumir.

Ahora mismo [tu objetivo: busco mi primer puesto como desarrollador iOS, etc.]. Si en tu equipo necesitáis a alguien que sepa leer código ajeno, arreglar lo que se rompe y contrastar lo que le cuentan, me encantará hablar contigo. El código está en [enlace al repositorio] y me encuentras en [LinkedIn / contacto].
