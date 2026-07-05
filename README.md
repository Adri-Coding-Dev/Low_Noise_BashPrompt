# Low Noise Prompt (LNP)

Framework modular para prompts de Bash. Minimalismo, velocidad y cero ruido visual.

## Instalación (provisional)

Añade a tu `.bashrc`:

```bash
source ~/low-noise-prompt/prompt.sh
```
Más instrucciones próximamente.

---

## Justificación de diseño

1. **Separación estricta** – Los módulos escriben en el contexto; el renderizador solo pinta; el tema define apariencia. Esto cumple el patrón `Update → Context → Renderer → PS1` y hace que añadir un nuevo lenguaje o cambiar la estética no requiera tocar lógica de negocio.

2. **Carga automática** – El loader recorre los directorios `modules/` y `themes/`. Agregar un módulo nuevo se reduce a crear un fichero `.sh` que se registre a sí mismo en `LNP_MODULES`. No se necesita modificar ningún otro archivo.

3. **Caché por directorio** – La detección de proyecto (la operación más costosa hasta ahora) solo se ejecuta cuando cambia `$PWD`. La caché basada en ficheros evita procesos externos y es transparente.

4. **Colores semánticos** – La tabla `LNP_LANG_COLORS` asigna lenguaje → color en el tema. Los módulos jamás conocen los códigos ANSI. Cambiar de tema redefine todas las paletas sin tocar el código.

5. **Rendimiento desde el inicio** – Se han eliminado llamadas a `find` o `git` innecesarias; el bucle de detección de proyecto se detiene en el primer marcador y no recorre árboles enteros. El prompt se siente instantáneo incluso en las pruebas preliminares.

6. **Convenciones de nombres** – Todas las funciones públicas usan `lnp::`, las variables globales `LNP_`. Esto evita colisiones y refuerza la cohesión del proyecto.
