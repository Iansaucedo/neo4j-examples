# Sistema Universitario con Neo4j

## Descripción

Este ejemplo implementa un sistema de gestión universitaria usando Neo4j, permitiendo el seguimiento de estudiantes, materias, calificaciones y relaciones académicas.

## Estructura de Datos

### Nodos

- **Estudiante**: Información de alumnos

  - id
  - matricula
  - nombre
  - carrera
  - semestre

- **Materia**: Información de asignaturas
  - codigo
  - nombre
  - creditos
  - departamento

### Relaciones

- `[:CURSÓ]`: Conecta estudiantes con materias
  - calificacion
  - periodo
- `[:REQUIERE]`: Indica prerequisitos entre materias

## Consultas Útiles

### Rendimiento Académico

```cypher
// Promedio por estudiante
MATCH (e:Estudiante)-[c:CURSÓ]->(m:Materia)
RETURN e.nombre,
       ROUND(AVG(c.calificacion), 2) as promedio
ORDER BY promedio DESC;
```

### Análisis por Carrera

```cypher
// Promedio por carrera
MATCH (e:Estudiante)-[c:CURSÓ]->(m:Materia)
RETURN e.carrera,
       COUNT(DISTINCT e) as estudiantes,
       ROUND(AVG(c.calificacion), 2) as promedio
ORDER BY promedio DESC;
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
ejemplo1-universidad/
├── datos/
│   ├── estudiantes.csv
│   ├── materias.csv
│   └── calificaciones.csv
└── scripts/
    ├── import.sh
    └── estructura.cypher
```

## Notas

- Asegúrate de tener permisos de escritura en el directorio de importación de Neo4j
- Las calificaciones están en escala 0-100
- Los periodos académicos siguen el formato YYYY-N
