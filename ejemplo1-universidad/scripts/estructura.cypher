// Drop existing indexes and constraints
DROP INDEX estudiante_id IF EXISTS;
DROP INDEX materia_codigo IF EXISTS;
DROP INDEX estudiante_matricula IF EXISTS;
DROP CONSTRAINT estudiante_id_unique IF EXISTS;
DROP CONSTRAINT materia_codigo_unique IF EXISTS;

// Create constraints (these will automatically create unique indexes)
CREATE CONSTRAINT estudiante_id_unique IF NOT EXISTS FOR (e:Estudiante) REQUIRE e.id IS UNIQUE;
CREATE CONSTRAINT materia_codigo_unique IF NOT EXISTS FOR (m:Materia) REQUIRE m.codigo IS UNIQUE;

// Cargar estudiantes
LOAD CSV WITH HEADERS FROM 'file:///estudiantes.csv' AS row
MERGE (e:Estudiante {
    id: row.id,
    matricula: row.matricula,
    nombre: row.nombre,
    carrera: row.carrera,
    semestre: toInteger(row.semestre)
});

// Cargar materias
LOAD CSV WITH HEADERS FROM 'file:///materias.csv' AS row
MERGE (m:Materia {
    codigo: row.codigo,
    nombre: row.nombre,
    creditos: toInteger(row.creditos),
    departamento: row.departamento
});

// Cargar calificaciones y crear relaciones
LOAD CSV WITH HEADERS FROM 'file:///calificaciones.csv' AS row
MATCH (e:Estudiante {id: row.estudiante_id})
MATCH (m:Materia {codigo: row.materia_codigo})
MERGE (e)-[c:CURSÓ]->(m)
SET c.calificacion = toFloat(row.calificacion),
    c.periodo = row.periodo;

// Create additional indexes for performance
CREATE INDEX estudiante_carrera IF NOT EXISTS FOR (e:Estudiante) ON (e.carrera);
CREATE INDEX materia_departamento IF NOT EXISTS FOR (m:Materia) ON (m.departamento);
CREATE INDEX estudiante_matricula IF NOT EXISTS FOR (e:Estudiante) ON (e.matricula);