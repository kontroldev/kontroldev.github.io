# Portfolio de Raúl Gallego

Portfolio personal en español, generado de forma estática con Swift e [Ignite](https://github.com/twostraws/Ignite), publicado en [kontroldev.github.io](https://kontroldev.github.io).

## Desarrollo

```sh
swift run
```

El generador Swift vive en `Sources/RaulGallegoPortfolio`, el contenido principal en `Includes` y los estilos en `Assets`. Cada cambio en `main` activa el flujo de GitHub Actions que compila Ignite y publica la carpeta `Build` en GitHub Pages.
