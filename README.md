# 🚗 App Concesionario 

Aplicación móvil orientada a uso interno para empleados, desarrollada con **Flutter** y **Dart**. El objetivo principal es la gestión centralizada del inventario de vehículos mediante operaciones **CRUD**, utilizando **Firebase** como base de datos en tiempo real.

---

### 🛠️ Funcionalidades Principales (CRUD)
* **Lectura:** Visualización en tiempo real del listado de vehículos disponibles.
* **Creación:** Registro de nuevos vehículos en el sistema.
* **Actualización:** Modificación de datos técnicos, disponibilidad o detalles de la flota.
* **Borrado:** Eliminación de registros de vehículos del inventario.

---

### 🏗️ Tecnologías y Herramientas

* **Framework:** [Flutter](https://flutter.dev/)
* **Lenguaje:** [Dart](https://dart.dev/)
* **Base de Datos:** [Firebase Cloud Firestore](https://firebase.google.com/docs/firestore) (Base de datos NoSQL en tiempo real).
* **Gestión de Dependencias:** `pubspec.yaml`

---

### 🚀 Instalación y Configuración

Para desplegar la herramienta en un entorno de desarrollo:

1.  **Requisitos previos:**
    * SDK de Flutter instalado.
    * Dispositivo físico o emulador configurado.

2.  **Configuración de Firebase:**
    * Este proyecto requiere conexión con un proyecto de Firebase.
    * Asegúrate de incluir el archivo `google-services.json` en `android/app/` para habilitar la comunicación con Firestore.

3.  **Clonar e instalar:**
    ```bash
    git clone [https://github.com/cbn0003/PracticaConcesionario.git](https://github.com/cbn0003/PracticaConcesionario.git)
    cd PracticaConcesionario/PracticaConcesionario
    flutter pub get
    ```

4.  **Lanzar la App:**
    ```bash
    flutter run
    ```

---

### 📁 Organización del Código (`lib`)

* **`models/`**: Definición de la entidad Vehículo y métodos de conversión (toFirestore/fromFirestore).
* **`services/`**: Lógica de acceso a datos y funciones CRUD directas con Firebase.
* **`screens/`**: Pantallas de formulario, listado y edición para los trabajadores.
* **`widgets/`**: Elementos de UI reutilizables (botones, tarjetas de inventario, etc.).

---

### 🎓 Contexto Académico
Proyecto desarrollado para el ciclo de **Desarrollo de Aplicaciones Multiplataforma (DAM)**. Enfocado en la implementación de backends NoSQL y flujos de trabajo administrativos en aplicaciones móviles.

---

### 👤 Autor
* **Bazan** - [cbn0003](https://github.com/cbn0003)
* **Inma** - [Inma_Gonzalez](https://github.com/Inma-Gonzalez)
* **amm0191** - [amm0191](https://github.com/amm0191)
