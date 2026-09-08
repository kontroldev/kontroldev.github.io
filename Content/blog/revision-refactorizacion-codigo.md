---
title: Lo que aprendí (a base de errores) revisando y refactorizando mi código
subtitle: Una revisión honesta de APIs que desaparecen, errores silenciosos y parches que terminan pesando demasiado.
date: 2026-09-08
author: Raúl Gallego
tags: Swift, Producto, Refactorización
image: https://kontroldev.github.io/refactor-blog-card.svg
alt: Editor de código con cambios y comprobaciones de una refactorización
---

# Lo que aprendí (a base de errores) revisando y refactorizando mi código

Estos últimos días me he metido de lleno en algo que llevaba tiempo posponiendo: hacer una revisión seria de mi proyecto de la app de Dragon Ball y de mi portfolio en GitHub Pages. No ha sido una limpieza rápida de cuatro líneas. Ha sido más bien destapar la caja y encontrarme con varios problemas encadenados que no había visto venir. Aquí dejo el resumen honesto: qué se rompió, por qué, y cómo lo fui arreglando.

<nav class="article-toc" aria-label="Contenido de la nota">
<p class="article-toc-title">En esta nota</p>
<ol>
<li><a href="#cuando-la-api-desaparece">Cuando la API de la que dependes simplemente desaparece</a></li>
<li><a href="#pequenos-problemas">Los "pequeños" problemas que aparecieron al mirar de cerca</a></li>
<li><a href="#css-corrupto">Un archivo CSS corrupto que casi pasa desapercibido</a></li>
<li><a href="#lo-que-me-llevo">Lo que me llevo de todo esto</a></li>
</ol>
</nav>

<h2 id="cuando-la-api-desaparece">Cuando la API de la que dependes simplemente desaparece</h2>

La app de Dragon Ball nació hace tiempo como un proyecto colaborativo de prácticas de Git dentro de la comunidad de Discord de MoureDev. La hicimos entre varios para aprender a trabajar en equipo con control de versiones: ramas, pull requests, revisiones cruzadas. Con el paso del tiempo me di cuenta de que ese proyecto necesitaba una refactorización en condiciones, así que estas semanas me puse manos a la obra en serio.

El primer golpe fue descubrir que la app se había quedado sin datos. Uno de mis compañeros de equipo había montado una API propia en Vercel para el proyecto, y en algún momento ese servicio dejó de estar disponible. Sin avisar, sin deprecación, simplemente un día dejó de responder.

Esto me enseñó algo que ya sabía en la teoría pero no había sufrido en la práctica: **cuando tu app depende de una API que no controlas, esa dependencia es un punto de fallo silencioso**. No hay warning en Xcode que te diga "oye, esto se va a caer dentro de tres meses".

La solución fue buscar una alternativa mantenida por la comunidad, `dragonball-api.com`, y migrar el consumo de datos hacia ahí. Pero la migración no fue un simple cambio de URL.

<h2 id="pequenos-problemas">Los "pequeños" problemas que aparecieron al mirar de cerca</h2>

Al ponerme a revisar el código para hacer la migración, empezaron a salir cosas que llevaban tiempo escondidas:

- **Errores tragados en silencio.** Había bloques `catch` vacíos y variables de error que se quedaban en blanco en vez de propagar el fallo real. Es decir: cuando algo fallaba, la app no se enteraba, y yo tampoco. Arreglar esto significó hacer que los errores reales llegaran hasta la interfaz en vez de desaparecer por el camino.

- **Llamadas en cascada donde no hacían falta.** Para cargar los favoritos, el código lanzaba cinco llamadas de red seguidas, una por cada personaje, en vez de pedir todo de una vez. Funcionaba, pero era lento y frágil: si una fallaba, arrastraba a las demás. La solución fue centralizar la petición en una sola llamada.

- **Paginación que no paginaba de verdad.** La nueva API solo devuelve 10 resultados por página, pero el código pedía 58 de golpe asumiendo que llegarían todos. Aquí tocó implementar paginación real, trayendo los resultados en paralelo en vez de a lo bruto.

- **Un modelo de datos que no encajaba con el nuevo.** La API nueva no devuelve exactamente los mismos campos que la vieja (por ejemplo, no incluye el planeta del personaje). En vez de reescribir toda la parte visual que ya funcionaba, construí un adaptador que traduce el modelo nuevo al formato que las vistas ya esperaban. Fue más trabajo al principio, pero evitó tocar código que no tenía necesidad de tocar.

- **Archivos fantasma.** El descubrimiento más incómodo: unos cuantos archivos Swift existían en el disco, con código dentro, pero nunca habían sido añadidos al target de Xcode. Es decir, llevaban tiempo sin compilarse ni ejecutarse nunca, aunque parecía que formaban parte del proyecto. Tocó revisarlos uno a uno y darlos de alta donde correspondía.

Ninguno de estos problemas era, por separado, muy grave. Juntos, explicaban por qué la app se sentía inestable y por qué era tan difícil saber qué estaba pasando cuando algo fallaba.

<h2 id="css-corrupto">Un archivo CSS corrupto que casi pasa desapercibido</h2>

El segundo frente fue mi portfolio, hecho con Ignite y publicado en GitHub Pages. Quería centrar todo el contenido y unificar el estilo visual. El resultado a simple vista parecía correcto, pero al revisar el histórico de commits encontré dos problemas de fondo:

1. Uno de los commits había introducido una corrupción binaria al principio del archivo `main.css`. Unos pocos bytes fuera de lugar, invisibles a simple vista, pero suficientes para que todas las variables CSS (colores, sombras, espaciados) dejaran de funcionar en producción.

2. En vez de editar las reglas de centrado ya existentes, se habían ido añadiendo bloques nuevos encima en distintos commits. El resultado era un CSS con reglas repetidas y, en algunos casos, contradictorias entre sí.

La solución no fue parchear encima (que es justo lo que había causado el problema), sino reescribir el archivo entero desde cero, limpio y consistente. Aquí el aprendizaje fue simple pero importante: **cuando algo empieza a acumular parches sobre parches, muchas veces sale más barato pararse y reescribirlo bien que seguir apilando arreglos**.

<h2 id="lo-que-me-llevo">Lo que me llevo de todo esto</h2>

- Los errores más peligrosos no son los que rompen la app a la vista, sino los que se quedan callados (un `catch` vacío, una corrupción de un archivo que "funciona a medias").
- Depender de una API externa sin plan B es aceptar un riesgo que tarde o temprano se cobra su precio.
- Revisar código antiguo con calma, archivo por archivo, saca a la luz cosas que nunca habrías encontrado añadiendo funcionalidades nuevas.
- A veces la solución elegante no es la más rápida de escribir, sino la que evita tener que tocar diez sitios más adelante (como el adaptador de modelos, en vez de reescribir toda la UI).

Todavía queda trabajo por delante, sobre todo decidir cómo reorganizar la parte de la wiki por sagas, ya que la nueva API no separa los personajes de esa forma. Pero el proyecto ya compila entero, ya no traga errores en silencio, y el portfolio por fin se ve como quería que se viera.

Si estás en medio de un refactor parecido: revisa siempre el `git log` con calma antes de asumir que un archivo "está bien porque compila". A veces no cuenta toda la historia.
