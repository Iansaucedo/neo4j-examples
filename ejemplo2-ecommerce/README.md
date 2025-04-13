# Sistema E-commerce con Neo4j

## Descripción

Este ejemplo implementa un sistema de comercio electrónico utilizando Neo4j, permitiendo gestionar productos, categorías, usuarios y sus interacciones de compra.

## Estructura de Datos

### Nodos

- **Producto**:

  - id
  - nombre
  - precio
  - stock
  - descripcion

- **Categoria**:

  - id
  - nombre
  - descripcion
  - padre_id

- **Usuario**:
  - id

### Relaciones

- `[:PERTENECE_A]`: Conecta productos con categorías
- `[:SUBCATEGORIA_DE]`: Establece jerarquía entre categorías
- `[:COMPRÓ]`: Conecta usuarios con productos
  - fecha
  - cantidad
  - monto
  - metodo_pago

## Consultas Útiles

### Análisis de Ventas

```cypher
// Top productos por ventas
MATCH (u:Usuario)-[c:COMPRÓ]->(p:Producto)
RETURN p.nombre,
       COUNT(c) as ventas,
       SUM(c.monto) as ingreso_total
ORDER BY ventas DESC
LIMIT 5;
```

### Categorías y Productos

```cypher
// Productos por categoría con stock bajo
MATCH (p:Producto)-[:PERTENECE_A]->(c:Categoria)
WHERE p.stock < 50
RETURN c.nombre as categoria,
       COUNT(p) as productos_bajos,
       COLLECT(p.nombre) as listado
ORDER BY productos_bajos DESC;
```

### Patrones de Compra

```cypher
// Productos frecuentemente comprados juntos
MATCH (u:Usuario)-[c1:COMPRÓ]->(p1:Producto)
MATCH (u)-[c2:COMPRÓ]->(p2:Producto)
WHERE p1.id < p2.id
  AND date(c1.fecha) = date(c2.fecha)
RETURN p1.nombre, p2.nombre,
       COUNT(*) as frecuencia
ORDER BY frecuencia DESC
LIMIT 10;
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
ejemplo2-ecommerce/
├── datos/
│   ├── productos.csv
│   ├── categorias.csv
│   └── compras.csv
└── scripts/
    ├── import.sh
    └── estructura.cypher
```

## Notas

- Los precios están en dólares
- Las fechas siguen el formato YYYY-MM-DD
- Los montos incluyen el precio \* cantidad
