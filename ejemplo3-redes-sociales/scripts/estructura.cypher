// Crear índices
CREATE INDEX usuario_id IF NOT EXISTS FOR (u:Usuario) ON (u.id);
CREATE INDEX post_id IF NOT EXISTS FOR (p:Post) ON (p.id);

// Crear constraints
CREATE CONSTRAINT usuario_id_unique IF NOT EXISTS ON (u:Usuario) ASSERT u.id IS UNIQUE;
CREATE CONSTRAINT usuario_email_unique IF NOT EXISTS ON (u:Usuario) ASSERT u.email IS UNIQUE;
CREATE CONSTRAINT post_id_unique IF NOT EXISTS ON (p:Post) ASSERT p.id IS UNIQUE;

// Cargar usuarios
LOAD CSV WITH HEADERS FROM 'file:///usuarios.csv' AS row
MERGE (u:Usuario {
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
MERGE (p:Post {
    id: row.id,
    contenido: row.contenido,
    fecha: datetime(row.fecha),
    likes: toInteger(row.likes),
    comentarios: toInteger(row.comentarios),
    compartidos: toInteger(row.compartidos)
})
MERGE (u)-[:PUBLICÓ]->(p);

// Crear índices adicionales para mejorar el rendimiento
CREATE INDEX usuario_pais IF NOT EXISTS FOR (u:Usuario) ON (u.pais);
CREATE INDEX post_fecha IF NOT EXISTS FOR (p:Post) ON (p.fecha);