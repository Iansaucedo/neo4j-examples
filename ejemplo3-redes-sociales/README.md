# Red Social con Neo4j

## Descripción

Este ejemplo implementa una red social básica usando Neo4j, permitiendo gestionar usuarios, posts y relaciones entre usuarios, así como analizar interacciones y tendencias.

## Estructura de Datos

### Nodos

- **Usuario**:

  - id
  - nombre
  - email
  - fecha_registro
  - pais
  - intereses (array)

- **Post**:
  - id
  - contenido
  - fecha
  - likes
  - comentarios
  - compartidos

### Relaciones

- `[:SIGUE]`: Conecta usuarios entre sí
  - fecha_inicio
  - interacciones
- `[:PUBLICÓ]`: Conecta usuarios con sus posts

## Consultas Útiles

### Análisis de Usuarios

```cypher
// Usuarios más influyentes por seguidores
MATCH (u:Usuario)<-[s:SIGUE]-()
RETURN u.nombre,
       COUNT(s) as seguidores,
       u.pais
ORDER BY seguidores DESC
LIMIT 5;
```

### Análisis de Posts

```cypher
// Posts más populares
MATCH (u:Usuario)-[:PUBLICÓ]->(p:Post)
RETURN u.nombre,
       p.contenido,
       p.likes + p.comentarios + p.compartidos as engagement
ORDER BY engagement DESC
LIMIT 10;
```

### Recomendaciones

```cypher
// Sugerir usuarios similares por intereses

```

## Importación de Datos

1. Verificar configuración:

```bash
# Editar credenciales en import.sh
nano scripts/import.sh
```

2. Ejecutar importación:

```bash
./scripts/import.sh
```

## Estructura de Archivos

```
ejemplo3-redes-sociales/
├── datos/
│   ├── usuarios.csv
│   ├── posts.csv
│   └── relaciones.csv
└── scripts/
    ├── import.sh
    └── estructura.cypher
```

## Notas

- Las fechas siguen el formato YYYY-MM-DD
- Los intereses se almacenan como arrays separados por punto y coma
- Las interacciones incluyen likes, comentarios y compartidos
