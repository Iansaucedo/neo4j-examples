# Neo4j Ejemplos Prácticos

## Descripción

Este repositorio contiene una colección de ejemplos prácticos que demuestran diferentes casos de uso de Neo4j, una base de datos orientada a grafos. Cada ejemplo incluye datos de muestra, scripts de importación y consultas comunes.

## Estructura del Repositorio

```
neo4j-examples/
├── ejemplo1-universidad/    # Sistema de gestión universitaria
├── ejemplo2-ecommerce/     # Plataforma de comercio electrónico
└── ejemplo3-redes-sociales/# Red social y análisis de relaciones
```

## Ejemplos Disponibles

### 1. Sistema Universitario

- Gestión de estudiantes y materias
- Seguimiento de calificaciones
- Análisis de rendimiento académico
- [Ver documentación](./ejemplo1-universidad/README.md)

### 2. E-commerce

- Recomendación de productos
- Análisis de compras
- Categorización de productos
- [Ver documentación](./ejemplo2-ecommerce/README.md)

### 3. Red Social

- Gestión de usuarios y relaciones
- Análisis de interacciones
- Recomendación de conexiones
- [Ver documentación](./ejemplo3-redes-sociales/README.md)

## Requisitos

- Neo4j 4.4 o superior
- Bash
- Python 3.8+ (para scripts auxiliares)
- Neo4j Browser o Neo4j Desktop

## Instalación

1. Clonar el repositorio:

```bash
git clone https://github.com/tu-usuario/neo4j-examples
cd neo4j-examples
```

2. Configurar permisos:

```bash
chmod +x */scripts/import.sh
```

3. Configurar Neo4j:

- Asegúrate de que Neo4j esté instalado y ejecutándose
- Configura las credenciales en los scripts de importación
- Verifica que el directorio de importación esté accesible

## Uso

Cada ejemplo contiene:

- Archivos CSV con datos de muestra
- Scripts Cypher para crear la estructura
- Script Bash para automatizar la importación
- README con consultas útiles y casos de uso

Para ejecutar un ejemplo:

```bash
cd ejemplo1-universidad
./scripts/import.sh
```
