# 📱 Hartacho App

**Hartacho App** es una aplicación híbrida construida con **Flutter** que se conecta a un backend en **Laravel** a través de una API REST protegida con **JWT**. Su propósito es proporcionar a los usuarios acceso a un sistema modular con distintas funcionalidades según sus roles.

---

## 🧩 Proyecto

- **Nombre**: `artacho_app`
- **Ubicación**: `C:\...\flutter_projects\artacho_app`
- **Backend**: Laravel (`artacho.test`)
- **Autenticación**: JWT

---

## 🚀 Tecnologías

### Flutter
- `dio` → Consumo de API con headers y manejo de errores.
- `shared_preferences` → Almacenamiento local del token JWT.
- `flutter_svg` → Soporte para imágenes SVG (logos).
- `webview_flutter` y `webview_flutter_web` → Para incrustar vistas web del dashboard si es necesario.

### Laravel (Backend)
- API RESTful protegida con JWT.
- Endpoints principales:
  - `/api/login`
  - `/api/register`
  - `/api/profile`
  - `/api/change-password`
  - `/api/delete-account`

---

## 🖥️ Estructura de Pantallas

Ubicadas en `lib/screens/`:

| Pantalla                     | Funcionalidad                                    |
|-----------------------------|--------------------------------------------------|
| `splash_screen.dart`        | Carga inicial e inicio de sesión automático.     |
| `welcome_screen.dart`       | Pantalla de bienvenida con logo y botones.       |
| `login_screen.dart`         | Formulario de acceso con JWT.                    |
| `register_screen.dart`      | Registro de nuevos usuarios.                     |
| `forgot_password_screen.dart` | Recuperación de contraseña (pendiente).       |
| `help_screen.dart`          | Información de contacto/ayuda.                   |
| `dashboard_screen.dart`     | Dashboard principal con menú de usuario.         |
| `profile_screen.dart`       | Edición de nombre y correo electrónico.          |
| `change_password_screen.dart` | Cambio de contraseña.                         |
| `delete_account_screen.dart` | Confirmación de eliminación de cuenta.        |

---

## 🔧 Servicios

Ubicados en `lib/services/`:

| Servicio          | Funcionalidad                                           |
|-------------------|----------------------------------------------------------|
| `auth_service.dart` | Login, registro, logout, y manejo del JWT.              |
| `user_service.dart` | Perfil de usuario, cambio de contraseña y eliminación. |
| `api_service.dart`  | Cliente centralizado con `dio` y token incluido.       |

---

## 🧱 Componentes Reutilizables

Ubicados en `lib/widgets/`:

| Componente            | Descripción                                      |
|-----------------------|--------------------------------------------------|
| `custom_app_bar.dart` | AppBar personalizada con título y acciones.      |
| `webview_screen.dart` | Widget WebView para mostrar contenidos web.      |

---

## 🌐 Configuración de Entorno

Ubicada en `lib/config/api_config.dart`:

```dart
import 'package:flutter/foundation.dart';

class ApiConfig {
  static String get baseUrl =>
      kIsWeb ? 'http://artacho.test/api' : 'http://10.0.2.2:8000/api';
}
```

---

## ✅ Flujo Actual

1. El usuario inicia en la pantalla de bienvenida.
2. Puede registrarse o iniciar sesión.
3. Si el login es exitoso, se guarda el token JWT y se accede al dashboard.
4. Desde el menú desplegable del AppBar, puede:
   - Ver su perfil.
   - Cambiar la contraseña.
   - Eliminar su cuenta.
   - Cerrar sesión.
5. Todas las acciones se hacen mediante llamadas seguras a la API usando `Dio`.

---

## 🔜 Pendiente / Próximos pasos

- Implementar recuperación de contraseña.
- Integrar notificaciones push (Firebase o Laravel Notifications).
- Añadir WebView para módulos avanzados del backend.
- Mejorar soporte de conexión offline.
- Preparar publicación en Google Play Store.

---

## 📂 Requisitos para desarrollo

- Flutter SDK
- Android Studio (para emuladores)
- Laravel backend corriendo en `mhartacho.test`
- Hosts configurado para `mhartacho.test` apuntando a `127.0.0.1`

---

### API
Esta API está desarrollada en Laravel y utiliza JWT para autenticación. Está desplegada en:

🔗 https://reservas.artacho.org/api

---

## 🔐 Autenticación (JWT)

### Login
**POST** `/api/login`

**Parámetros:**
```json
{
  "email": "usuario@example.com",
  "password": "123456"
}
```

**Respuesta:**
```json
{
  "access_token": "jwt_token",
  "token_type": "bearer",
  "expires_in": 3600
}
```

---

## 👤 Perfil del usuario

### Obtener usuario autenticado
**GET** `/api/me`  
**Header:** `Authorization: Bearer {token}`

### Actualizar perfil
**PUT** `/api/profile`  
**Body:** `{ "name": "Nuevo Nombre", "email": "nuevo@email.com" }`

---

## 🔒 Seguridad

### Cambiar contraseña
**PUT** `/api/change-password`  
```json
{
  "current_password": "anterior",
  "new_password": "nueva"
}
```

### Eliminar cuenta
**DELETE** `/api/delete-account`

---

## 🔔 Notificaciones

### Guardar token FCM
**POST** `/api/save-fcm-token`  
**Header:** `Authorization: Bearer {token}`  
```json
{
  "fcm_token": "firebase_token"
}
```

---

## 🧪 Test de logging
**GET** `/api/test-log`  
Genera un warning en `laravel.log`.

---

## ℹ️ Notas
- Las rutas protegidas requieren token JWT en la cabecera `Authorization`.
- No uses `curl -k` salvo para pruebas con certificados no verificados.

---

## 🧑‍💻 Autor

Proyecto desarrollado y mantenido por [Harta Dev].