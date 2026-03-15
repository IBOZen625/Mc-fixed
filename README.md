# Fast Items (2D Items)
## Download
[modrinth](https://modrinth.com/mod/fast-items)

## Description

Optimize item rendering by making item entities 2-dimensional.

## License

This mod is under the CC0 license. Feel free to learn from it and incorporate it in your own projects.

## Building from Source

To build the mod from source yourself (e.g., for development or testing), you will need **Java 21** installed, as this is required for Minecraft 1.21.11.

**Requirements:**
- [Java 21 JDK](https://adoptium.net/temurin/releases/?version=21) (Ensure `JAVA_HOME` is set to your JDK 21 installation).
- Git (optional, for cloning the repository).

**Steps to Build:**
1. Open a terminal or command prompt in the root of the project folder.
2. Run the Gradle build command:
   - **Windows:** `.\gradlew clean build`
   - **Mac/Linux:** `./gradlew clean build`
3. Once the build completes, the compiled mod `.jar` files will be located in:
   - **Fabric:** `fabric/build/libs/`
   - **NeoForge:** `neoforge/build/libs/`

*Note: The first time you run the build command, it may take a few minutes to download Gradle, Minecraft, and the necessary modding toolchains.*
