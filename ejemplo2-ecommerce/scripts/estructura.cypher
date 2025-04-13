// Crear índices
CREATE INDEX producto_id IF NOT EXISTS FOR (p:Producto) ON (p.id);
CREATE INDEX categoria_id IF NOT EXISTS FOR (c:Categoria) ON (c.id);
CREATE INDEX usuario_id IF NOT EXISTS FOR (u:Usuario) ON (u.id);

// Crear constraints
CREATE CONSTRAINT producto_id_unique IF NOT EXISTS ON (p:Producto) ASSERT p.id IS UNIQUE;
CREATE CONSTRAINT categoria_id_unique IF NOT EXISTS ON (c:Categoria) ASSERT c.id IS UNIQUE;

// Cargar categorías y crear jerarquía
LOAD CSV WITH HEADERS FROM 'file:///categorias.csv' AS row
MERGE (c:Categoria {
    id: row.id,
    nombre: row.nombre,
    descripcion: row.descripcion
});

// Establecer relaciones padre-hijo entre categorías
LOAD CSV WITH HEADERS FROM 'file:///categorias.csv' AS row
WHERE row.padre_id IS NOT NULL
MATCH (hijo:Categoria {id: row.id})
MATCH (padre:Categoria {id: row.padre_id})
MERGE (hijo)-[:SUBCATEGORIA_DE]->(padre);

// Cargar productos
LOAD CSV WITH HEADERS FROM 'file:///productos.csv' AS row
MERGE (p:Producto {
    id: row.id,
    nombre: row.nombre,
    precio: toFloat(row.precio),
    stock: toInteger(row.stock),
    descripcion: row.descripcion
})
WITH p, row
MATCH (c:Categoria {nombre: row.categoria})
MERGE (p)-[:PERTENECE_A]->(c);

// Cargar compras y crear relaciones
LOAD CSV WITH HEADERS FROM 'file:///compras.csv' AS row
MERGE (u:Usuario {id: row.usuario_id})
WITH row, u
MATCH (p:Producto {id: row.producto_id})
MERGE (u)-[c:COMPRÓ]->(p)
SET c.fecha = datetime(row.fecha),
    c.cantidad = toInteger(row.cantidad),
    c.monto = toFloat(row.monto),
    c.metodo_pago = row.metodo_pago;

// Crear índices adicionales para mejorar el rendimiento
CREATE INDEX producto_nombre IF NOT EXISTS FOR (p:Producto) ON (p.nombre);
CREATE INDEX categoria_nombre IF NOT EXISTS FOR (c:Categoria) ON (c.nombre);