# 📱 Booking App (Estilo Booking.com) - Arquitectura & Guía del Proyecto

Este documento establece el contexto general, la arquitectura de software seleccionada, la estructura de carpetas, el sistema de diseño y la hoja de ruta para el desarrollo de la aplicación móvil inspirada en **Booking.com**, desarrollada en **Flutter** para celulares (Android & iOS).

---

## 📌 1. Visión General del Proyecto

- **Objetivo**: Desarrollar una experiencia móvil completa inspirada en Booking.com para búsqueda, exploración, filtrado y reserva de alojamientos (hoteles, apartamentos, resorts).
- **Plataforma objetivo**: Dispositivos móviles (Android / iOS) con soporte responsivo y diseño adaptable.
- **Tecnología**: Flutter (SDK ^3.12.2 / Dart 3.12.2) con Material Design 3.

---

## 🏛️ 2. Arquitectura: Patrón MVC (Model - View - Controller) en Flutter

Para mantener el proyecto modular, escalable y limpio sin sobrecargar la interfaz de usuario con lógica de negocio, se adopta el patrón **MVC adaptado a Flutter**:

```
                  ┌────────────────────────────────────────┐
                  │                 VIEW                   │
                  │  (Screens, Widgets, Formularios)       │
                  └───────────────▲────────┬───────────────┘
                                  │        │
                   Notifica /     │        │ Dispara acciones
                   Escucha estado │        │ del usuario
                                  │        ▼
                  ┌───────────────┴────────────────────────┐
                  │              CONTROLLER                │
                  │ (ChangeNotifier / ValueNotifier /      │
                  │  Lógica de Negocio y Validación)       │
                  └───────────────▲────────┬───────────────┘
                                  │        │
                 Retorna entidades│        │ Solicita / Transforma
                                  │        ▼
                  ┌───────────────┴────────────────────────┐
                  │            MODEL & SERVICES            │
                  │  (Entidades, Mock Data, Repositorios)  │
                  └────────────────────────────────────────┘
```

### Componentes:
1. **Models (`lib/models/`)**:
   - Representan los datos y la estructura del dominio.
   - Clases inmutables con métodos `fromJson`, `toJson`, `copyWith`.
   - Entidades principales: `User`, `Hotel`, `Room`, `Booking`, `Review`, `SearchFilter`.

2. **Views (`lib/views/`)**:
   - Componentes puramente visuales (`StatelessWidget` o `StatefulWidget`).
   - No contienen lógica de negocio ni llamadas directas a APIs o bases de datos.
   - Escuchan los cambios emitidos por los controladores (`ListenableBuilder` / `AnimatedBuilder`).
   - Organizadas por dominios o características (`auth`, `home`, `search`, `hotel_detail`, `booking`, `profile`).

3. **Controllers (`lib/controllers/`)**:
   - Clases que extienden `ChangeNotifier` para gestionar el estado y la lógica de negocio.
   - Manejan la validación de formularios, llamadas a servicios, filtrado de datos y actualización de la vista mediante `notifyListeners()`.
   - Controladores principales: `AuthController`, `HomeController`, `SearchController`, `BookingController`.

4. **Services (`lib/services/`)**:
   - Capa de datos encargada de interactuar con fuentes externas (APIs REST, almacenamiento local, mock data de hoteles).
   - Abstrae el origen de los datos para que los controladores no dependan de una API específica.

5. **Utils & Theme (`lib/utils/`)**:
   - Constantes de diseño, paleta de colores oficial de Booking.com, estilos de texto, rutas y utilidades de formateo (monedas, fechas).

---

## 🎨 3. Identidad Visual y Paleta de Colores (Booking.com Style)

El diseño replica los estándares visuales limpios y reconocibles de Booking.com:

| Nombre | Código Hex | Uso principal |
| :--- | :--- | :--- |
| **Primary Navy Blue** | `#003B95` | AppBar, encabezados, títulos destacados, branding principal |
| **Accent Action Blue** | `#006CE4` | Botones de acción principal (CTA), enlaces, estados activos |
| **Warning / Booking Yellow** | `#FEBB02` | Tarjetas de ofertas, distintivos de descuentos, botones destacados |
| **Rating Green / Badge** | `#008234` | Puntuaciones de reseñas ("Fantástico 9.2", "Muy bien") |
| **Dark Neutral / Text** | `#1A1A1A` | Tipografía principal, títulos oscuros |
| **Light Neutral / Muted** | `#6B6B6B` | Subtítulos, textos secundarios, iconos inactivos |
| **Background Gray** | `#F5F5F5` | Fondos de pantalla, separadores |
| **Surface White** | `#FFFFFF` | Tarjetas de hoteles, fondos de campos de texto |

---

## 📂 4. Estructura de Directorios Recomendada (`lib/`)

```
lib/
├── controllers/          # Controladores (ChangeNotifier)
│   ├── auth_controller.dart
│   ├── hotel_controller.dart
│   └── booking_controller.dart
├── models/               # Modelos de datos
│   ├── user_model.dart
│   ├── hotel_model.dart
│   ├── room_model.dart
│   └── booking_model.dart
├── services/             # Servicios y repositorios de datos
│   ├── mock_hotel_service.dart
│   └── auth_service.dart
├── utils/                # Constantes, temas y helpers
│   ├── app_colors.dart
│   ├── app_routes.dart
│   ├── constants.dart
│   └── formatters.dart
├── views/                # Pantallas y vistas de la aplicación
│   ├── auth/
│   │   ├── login_screen.dart
│   │   └── register_screen.dart
│   ├── home/
│   │   ├── home_screen.dart
│   │   └── main_navigation_screen.dart  # BottomNavigationBar (Buscar, Guardados, Reservas, Perfil)
│   ├── search/
│   │   ├── search_results_screen.dart
│   │   └── filter_modal.dart
│   ├── hotel_detail/
│   │   ├── hotel_detail_screen.dart
│   │   └── select_room_screen.dart
│   ├── booking/
│   │   ├── checkout_screen.dart
│   │   └── booking_confirmation_screen.dart
│   ├── profile/
│   │   └── profile_screen.dart
│   └── widgets/          # Widgets reutilizables comunes
│       ├── custom_button.dart
│       ├── custom_text_field.dart
│       ├── hotel_card.dart
│       └── rating_badge.dart
└── main.dart             # Punto de entrada de la aplicación
```

---

## 🔍 5. Diagnóstico y Estado Actual del Repositorio

1. **Estructura base creada**: Ya existen las carpetas `controllers/`, `models/`, `utils/`, y `views/`.
2. **Vistas iniciales**:
   - `views/auth/login_screen.dart`: Maquetado visual avanzado. Contiene un detalle menor a corregir (`0xFF03B95` en lugar de `0xFF003B95` y llamada a `print`).
   - `views/auth/register_screen.dart`: Maquetado visual con formulario de registro.
3. **Archivos pendientes de implementar**:
   - `models/user_model.dart` (vacío).
   - `controllers/auth_controller.dart` (vacío).
   - `utils/constants.dart` (vacío).
   - `views/home/home_screen.dart` (vacío).

---

## 🚀 6. Hoja de Ruta (Roadmap)

- [ ] **Fase 1: Configuración Base y Constantes**
  - Implementar `utils/app_colors.dart` y `utils/constants.dart` con la paleta oficial de Booking.com.
  - Corregir advertencias de linter en las pantallas existentes.
- [ ] **Fase 2: Arquitectura MVC de Autenticación**
  - Desarrollar `UserModel` con validaciones y serialización.
  - Desarrollar `AuthController` con lógica de login, registro y validación de credenciales.
  - Conectar `LoginScreen` y `RegisterScreen` con el `AuthController`.
- [ ] **Fase 3: Navegación Principal Móvil (`MainNavigationScreen`)**
  - Barra de navegación inferior (BottomNavigationBar) con 4 pestañas:
    1. 🔍 **Buscar** (Home)
    2. 💙 **Guardados** (Favoritos)
    3. 🧳 **Reservas** (Activas y Pasadas)
    4. 👤 **Perfil** (Cuenta y Ajustes)
- [ ] **Fase 4: Pantalla de Inicio y Buscador de Hoteles (Home)**
  - Banner de destino ("¿A dónde vas?"), selector de fechas y número de huéspedes.
  - Sección de ofertas y promociones ("Ofertas de escapada").
  - Carrusel de destinos populares y alojamientos recomendados.
- [ ] **Fase 5: Resultados de Búsqueda y Filtros**
  - `HotelModel` con fotos, precio, calificación, ubicación, servicios (WiFi, piscina, desayuno).
  - Pantalla con tarjetas detalladas de hoteles y filtros (rango de precio, estrellas, cancelación gratis).
- [ ] **Fase 6: Ficha Detallada del Hotel y Selección de Habitación**
  - Galería de imágenes, mapa de ubicación, lista de comodidades, reseñas de usuarios.
  - Desglose de tipos de habitación (Deluxe, Estándar, Suite) con botón "Reservar".
- [ ] **Fase 7: Flujo de Reserva (Checkout & Confirmación)**
  - Datos del titular, desglose de impuestos y cargos, simulación de pago.
  - Pantalla de confirmación con código de reserva descargable/visualizable.
- [ ] **Fase 8: Módulo de Reservas y Perfil de Usuario**
  - Consulta de reservas activas con opción de ver detalles o cancelar.
  - Edición del perfil de usuario y cierre de sesión.
