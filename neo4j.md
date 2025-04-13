# Neo4j Cheatsheet - Guía Rápida

## Conceptos Básicos

### Nodos y Relaciones

```cypher
// Crear nodo
CREATE (n:Persona {nombre: 'Juan', edad: 30})

// Crear relación
MATCH (a:Persona), (b:Persona)
WHERE a.nombre = 'Juan' AND b.nombre = 'María'
CREATE (a)-[r:CONOCE {desde: '2024'}]->(b)
```

## Consultas Básicas

### Buscar Nodos

```cypher
// Buscar todos los nodos de un tipo
MATCH (p:Persona) RETURN p

// Buscar por propiedad
MATCH (p:Persona {nombre: 'Juan'}) RETURN p

// Buscar usando WHERE
MATCH (p:Persona)
WHERE p.edad > 25
RETURN p
```

### Relaciones

```cypher
// Buscar relaciones directas
MATCH (p1:Persona)-[:CONOCE]->(p2:Persona)
RETURN p1.nombre, p2.nombre

// Relaciones con profundidad variable
MATCH (p1:Persona)-[:CONOCE*1..3]->(p2:Persona)
RETURN p1.nombre, p2.nombre
```

## Operaciones CRUD

### Create

```cypher
// Crear nodo simple
CREATE (n:Etiqueta {prop: 'valor'})

// Crear múltiples nodos
CREATE
  (a:Persona {nombre: 'Ana'}),
  (b:Persona {nombre: 'Bob'})
```

### Read

```cypher
// Leer con condiciones
MATCH (n:Persona)
WHERE n.edad > 25 AND n.ciudad = 'Madrid'
RETURN n

// Contar resultados
MATCH (n:Persona)
RETURN COUNT(n) as total
```

### Update

```cypher
// Actualizar propiedades
MATCH (n:Persona {nombre: 'Juan'})
SET n.edad = 31
RETURN n

// Añadir propiedades
MATCH (n:Persona {nombre: 'Juan'})
SET n += {trabajo: 'Developer'}
```

### Delete

```cypher
// Eliminar nodo
MATCH (n:Persona {nombre: 'Juan'})
DELETE n

// Eliminar nodo y relaciones
MATCH (n:Persona {nombre: 'Juan'})
DETACH DELETE n
```

## Funciones Útiles

### Agregación

```cypher
// Contar y agrupar
MATCH (p:Persona)
RETURN p.ciudad, COUNT(*) as total
ORDER BY total DESC

// Promedio
MATCH (p:Persona)
RETURN AVG(p.edad) as edad_promedio
```

### Colecciones

```cypher
// Recolectar valores
MATCH (p:Persona)
RETURN p.ciudad, COLLECT(p.nombre) as personas

// Operaciones con arrays
MATCH (p:Persona)
WHERE 'programación' IN p.intereses
RETURN p
```

## Índices y Constraints

### Índices

```cypher
// Crear índice simple
CREATE INDEX persona_nombre IF NOT EXISTS
FOR (p:Persona) ON (p.nombre)

// Índice compuesto
CREATE INDEX persona_ciudad_edad IF NOT EXISTS
FOR (p:Persona) ON (p.ciudad, p.edad)
```

### Constraints

```cypher
// Unicidad
CREATE CONSTRAINT persona_email_unique IF NOT EXISTS
ON (p:Persona) ASSERT p.email IS UNIQUE

// Propiedad requerida
CREATE CONSTRAINT persona_nombre_exists IF NOT EXISTS
ON (p:Persona) ASSERT EXISTS(p.nombre)
```

## Ejemplos Prácticos

### Recomendaciones

```cypher
// Encontrar amigos de amigos
MATCH (p:Persona {nombre: 'Juan'})-[:CONOCE]->(amigo)-[:CONOCE]->(amigo_de_amigo)
WHERE NOT (p)-[:CONOCE]->(amigo_de_amigo)
RETURN DISTINCT amigo_de_amigo.nombre
```

### Análisis de Rutas

```cypher
// Camino más corto
MATCH path = shortestPath(
  (inicio:Persona {nombre: 'Juan'})-[:CONOCE*]-(fin:Persona {nombre: 'María'})
)
RETURN path
```

## Optimización

### Buenas Prácticas

- Usar índices para propiedades frecuentemente consultadas
- Limitar resultados con LIMIT
- Usar parámetros en lugar de valores hardcodeados
- Evitar MATCH sin etiquetas

### Rendimiento

```cypher
// Usar EXPLAIN para ver plan de ejecución
EXPLAIN MATCH (p:Persona)-[:CONOCE]->(amigo)
RETURN p.nombre, COUNT(amigo)

// Usar PROFILE para análisis detallado
PROFILE MATCH (p:Persona {ciudad: 'Madrid'})
RETURN p
```

## Referencias

- [Documentación Oficial Neo4j](https://neo4j.com/docs/)
- [Neo4j Cypher Manual](https://neo4j.com/docs/cypher-manual/current/)
- [APOC Library](https://neo4j.com/docs/apoc/current/)
