// Drop existing indexes and constraints
DROP INDEX producto_id IF EXISTS;
DROP INDEX categoria_id IF EXISTS;
DROP INDEX usuario_id IF EXISTS;
DROP INDEX producto_nombre IF EXISTS;
DROP INDEX categoria_nombre IF EXISTS;
DROP CONSTRAINT producto_id_unique IF EXISTS;
DROP CONSTRAINT categoria_id_unique IF EXISTS;
DROP CONSTRAINT compra_id_unique IF EXISTS;

// Create constraints (these will automatically create unique indexes)
CREATE CONSTRAINT producto_id_unique IF NOT EXISTS FOR (p:Producto) REQUIRE p.id IS UNIQUE;
CREATE CONSTRAINT categoria_id_unique IF NOT EXISTS FOR (c:Categoria) REQUIRE c.id IS UNIQUE;
CREATE CONSTRAINT compra_id_unique IF NOT EXISTS FOR (co:Compra) REQUIRE co.id IS UNIQUE;

// Cargar categorías y crear jerarquía
LOAD CSV WITH HEADERS FROM 'file:///categorias.csv' AS row
MERGE (c:Categoria {
    id: row.id,
    nombre: row.nombre,
    descripcion: row.descripcion
});

// Establecer relaciones padre-hijo entre categorías
LOAD CSV WITH HEADERS FROM 'file:///categorias.csv' AS row
WITH row
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

// Create non-unique indexes for performance
CREATE INDEX producto_nombre IF NOT EXISTS FOR (p:Producto) ON (p.nombre);
CREATE INDEX categoria_nombre IF NOT EXISTS FOR (c:Categoria) ON (c.nombre);
CREATE INDEX usuario_id IF NOT EXISTS FOR (u:Usuario) ON (u.id);