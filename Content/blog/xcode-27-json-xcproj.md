---
title: Xcode cambia por dentro: llega el nuevo formato de proyecto basado en JSON
subtitle: El nuevo archivo .xcproj busca simplificar los cambios en Git y facilitar el trabajo de los agentes de programación.
date: 2026-09-20
author: Raúl Gallego
tags: Xcode, Swift, Git, Inteligencia artificial
image: https://kontroldev.github.io/xcode-27-json-xcproj.png
alt: Ilustración editorial de un archivo JSON que organiza la configuración de un proyecto de Xcode
---

# Xcode cambia por dentro: llega el nuevo formato de proyecto basado en JSON

Si estás aprendiendo a desarrollar para las plataformas de Apple, tarde o temprano te encuentras con un archivo que parece tener vida propia: `project.pbxproj`. Normalmente Xcode lo gestiona sin que tengamos que preocuparnos. La historia cambia cuando revisamos modificaciones en Git o intentamos resolver un conflicto dentro del proyecto.

Con **Xcode 27.2 beta**, Apple presenta una alternativa: un archivo de configuración basado en JSON, con extensión `.xcproj`. No es una nueva forma de escribir aplicaciones en Swift, sino una manera distinta de guardar **cómo está organizado y configurado un proyecto**.

<nav class="article-toc" aria-label="Contenido de la nota">
<p class="article-toc-title">En esta nota</p>
<ol>
<li><a href="#que-cambia-exactamente">¿Qué cambia exactamente?</a></li>
<li><a href="#un-cambio-que-se-nota-al-trabajar-con-git">Un cambio que se nota al trabajar con Git</a></li>
<li><a href="#que-tiene-que-ver-con-los-coding-agents">¿Qué tiene que ver con los coding agents?</a></li>
<li><a href="#como-se-activa">¿Cómo se activa?</a></li>
<li><a href="#un-pequeno-archivo-un-cambio-interesante">Un pequeño archivo, un cambio interesante</a></li>
</ol>
</nav>

<h2 id="que-cambia-exactamente">¿Qué cambia exactamente?</h2>

El proyecto sigue teniendo la extensión `.xcodeproj`. Lo que cambia está dentro: el archivo de configuración tradicional, `project.pbxproj`, puede sustituirse por `project.xcproj`.

Apple describe el nuevo formato como más pequeño, jerárquico y fácil de interpretar. Según su documentación, Xcode 27 y posteriores admiten ambos formatos; a partir de Xcode 27.2 el nuevo formato pasa a ser el predeterminado para los proyectos nuevos.

Esto no significa que tengamos que migrar inmediatamente los proyectos que ya funcionan. Podemos mantener el formato anterior y decidir cuándo nos interesa cambiar.

<h2 id="un-cambio-que-se-nota-al-trabajar-con-git">Un cambio que se nota al trabajar con Git</h2>

Cuando modificamos un proyecto desde Xcode, Git registra las diferencias en sus archivos. Con el formato tradicional, entender qué parte de la configuración ha cambiado puede resultar complicado, y los conflictos entre ramas pueden ser especialmente incómodos.

El nuevo formato pretende que los cambios sean más fáciles de leer y queden mejor aislados. Apple señala que eso facilita revisar las diferencias antes de confirmar un *commit* y reduce la posibilidad de conflictos al fusionar ramas.

No quiere decir que Git vaya a resolver todos los problemas por arte de magia. Pero sí que un archivo más claro puede evitar perder tiempo descifrando cambios que no tienen nada que ver con el código que estábamos escribiendo.

<h2 id="que-tiene-que-ver-con-los-coding-agents">¿Qué tiene que ver con los coding agents?</h2>

Aquí está la parte que más me interesa. Apple menciona expresamente que el nuevo formato facilita a los **agentes de programación** editar la configuración de un proyecto.

Un agente puede ayudarnos a escribir Swift, pero trabajar en una aplicación también implica entender sus archivos, sus *targets* y sus ajustes de compilación. Si la configuración tiene una estructura más clara, estas herramientas pueden interpretarla y modificarla con menos fricción.

Eso no elimina la necesidad de revisar sus cambios, compilar la aplicación o ejecutar pruebas. La responsabilidad de comprobar el resultado sigue siendo nuestra. Lo interesante es que Xcode no solo está incorporando asistentes: también está adaptando partes del propio proyecto para trabajar mejor con ellos.

<h2 id="como-se-activa">¿Cómo se activa?</h2>

Según la documentación de Apple, en un proyecto existente podemos seleccionarlo en el **Project Navigator**, abrir el **File Inspector** y elegir **JSON** en el menú **Project Format**, dentro de **Project Document**. Xcode reemplaza entonces el archivo de configuración anterior por el nuevo.

Antes de probarlo en un proyecto importante, conviene confirmar qué versión de Xcode utiliza todo el equipo y guardar los cambios en Git. Así será más fácil revisar qué se ha modificado y volver atrás si hace falta.

<h2 id="un-pequeno-archivo-un-cambio-interesante">Un pequeño archivo, un cambio interesante</h2>

Todavía no he probado este formato en uno de mis proyectos, así que prefiero esperar a utilizarlo antes de sacar conclusiones sobre cómo se comporta en el día a día.

Aun así, me parece una novedad que merece atención: la estructura de un proyecto también forma parte de la experiencia de desarrollar. Si resulta más sencilla de entender para nosotros, más fácil de revisar en Git y más accesible para los agentes, todos salimos ganando.

A veces los cambios importantes de Xcode no están en una nueva API ni en una interfaz espectacular. A veces están en ese archivo que solo mirábamos cuando algo se rompía.

## Fuentes

- [Apple Developer — Updating your Xcode project configuration file format](https://developer.apple.com/documentation/xcode/updating-your-xcode-project-configuration-file-format)
- [Apple Developer — Xcode 27.2 Beta Release Notes](https://developer.apple.com/documentation/xcode-release-notes/xcode-27_2-release-notes)
- [Apple Developer — What's new in Xcode](https://developer.apple.com/xcode/whats-new/)
