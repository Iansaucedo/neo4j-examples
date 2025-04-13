// First, delete all existing data
MATCH (n) DETACH DELETE n;

// Drop existing indexes and constraints
DROP INDEX usuario_id IF EXISTS;
DROP INDEX post_id IF EXISTS;
DROP INDEX usuario_pais IF EXISTS;
DROP INDEX post_fecha IF EXISTS;
DROP CONSTRAINT usuario_id_unique IF EXISTS;
DROP CONSTRAINT usuario_email_unique IF EXISTS;
DROP CONSTRAINT post_id_unique IF EXISTS;

// Create constraints (these will automatically create unique indexes)
CREATE CONSTRAINT usuario_id_unique IF NOT EXISTS FOR (u:Usuario) REQUIRE u.id IS UNIQUE;
CREATE CONSTRAINT usuario_email_unique IF NOT EXISTS FOR (u:Usuario) REQUIRE u.email IS UNIQUE;
CREATE CONSTRAINT post_id_unique IF NOT EXISTS FOR (p:Post) REQUIRE p.id IS UNIQUE;

// Cargar usuarios
LOAD CSV WITH HEADERS FROM 'file:///usuarios.csv' AS row
CREATE (u:Usuario {
    id: row.id,
    nombre: row.nombre,
    email: row.email,
    fecha_registro: date(row.fecha_registro),
    pais: row.pais,
    intereses: split(row.intereses, ';')
});

// Cargar relaciones entre usuarios
LOAD CSV WITH HEADERS FROM 'file:///relaciones.csv' AS row
MATCH (u1:Usuario {id: row.usuario1_id})
MATCH (u2:Usuario {id: row.usuario2_id})
MERGE (u1)-[r:SIGUE]->(u2)
SET r.fecha_inicio = date(row.fecha_inicio),
    r.interacciones = toInteger(row.interacciones);

// Cargar posts
LOAD CSV WITH HEADERS FROM 'file:///posts.csv' AS row
MATCH (u:Usuario {id: row.usuario_id})
CREATE (p:Post {
    id: row.id,
    contenido: row.contenido,
    fecha: datetime(row.fecha),
    likes: toInteger(row.likes),
    comentarios: toInteger(row.comentarios),
    compartidos: toInteger(row.compartidos)
})
MERGE (u)-[:PUBLICÓ]->(p);

// Create additional indexes for performance
CREATE INDEX usuario_pais IF NOT EXISTS FOR (u:Usuario) ON (u.pais);
CREATE INDEX post_fecha IF NOT EXISTS FOR (p:Post) ON (p.fecha);