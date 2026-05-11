# Innovatech Chile — Backend API

API REST desarrollada en **Node.js + Express** que gestiona usuarios y se conecta a una base de datos MySQL. Diseñada para ejecutarse como contenedor Docker en AWS EC2.

## Stack tecnológico

| Componente | Tecnología |
|---|---|
| Backend | Node.js 20 + Express |
| Base de datos | MySQL 8.0 |
| Contenedor | Docker (multi-stage, usuario no-root) |
| CI/CD | GitHub Actions → Docker Hub → EC2 |

## Estructura del repositorio

```
Back_EVAL2/
├── server.js                       # Servidor Express principal
├── package.json                    # Dependencias Node.js
├── Dockerfile                      # Multi-stage build (builder + producción)
├── .env.example                    # Variables de entorno requeridas
└── .github/
    └── workflows/
        └── deploy.yml              # Pipeline CI/CD (trigger: rama deploy)
```

## Endpoints disponibles

| Método | Ruta | Descripción |
|---|---|---|
| GET | `/` | Estado de la API |
| GET | `/api/usuarios` | Listar todos los usuarios |
| POST | `/api/usuarios` | Crear nuevo usuario |
| PUT | `/api/usuarios/:id` | Actualizar usuario |
| DELETE | `/api/usuarios/:id` | Eliminar usuario |

## Variables de entorno

```bash
cp .env.example .env
```

| Variable | Descripción | Default |
|---|---|---|
| `PORT` | Puerto del servidor | `3000` |
| `DB_HOST` | Host de MySQL | `db` |
| `DB_USER` | Usuario de la BD | `appuser` |
| `DB_PASSWORD` | Contraseña de la BD | — |
| `DB_NAME` | Nombre de la BD | `proyecto_db` |
| `DB_PORT` | Puerto MySQL | `3306` |

## Ejecución local con Docker

```bash
# Build de la imagen
docker build -t innovatech-backend .

# Ejecutar con variables de entorno
docker run -d -p 3000:3000 --env-file .env innovatech-backend

# Verificar que la API responde
curl http://localhost:3000/
```

## Pipeline CI/CD

El pipeline se activa al hacer push a la rama **deploy**:

```
push rama deploy
       │
       ▼
  [build-and-push]
  ├── Checkout código
  ├── Login Docker Hub
  ├── Build imagen (multi-stage)
  └── Push imagen (tags: latest + SHA commit)
       │
       ▼
     [deploy]
  ├── SSH a EC2 Backend
  ├── Pull imagen nueva
  └── Restart contenedor con variables de entorno de BD
```

### GitHub Secrets requeridos

| Secret | Descripción |
|---|---|
| `DOCKERHUB_USERNAME` | Usuario de Docker Hub |
| `DOCKERHUB_TOKEN` | Access token de Docker Hub |
| `EC2_BACKEND_HOST` | IP pública de la instancia EC2 del backend |
| `EC2_USER` | Usuario SSH de EC2 |
| `EC2_SSH_KEY` | Clave privada SSH |
| `DB_HOST` | Host de MySQL (IP privada de la instancia de BD) |
| `DB_USER` | Usuario de la base de datos |
| `DB_PASSWORD` | Contraseña de la base de datos |
| `DB_NAME` | Nombre de la base de datos |
