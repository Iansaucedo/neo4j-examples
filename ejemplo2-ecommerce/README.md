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

- **UsuariosEcommerce**:
  - id
  - nombre
  - email
  - fecha_registro
  - pais
  - metodo_pago_preferido

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
MATCH (u:UsuariosEcommerce)-[c:COMPRÓ]->(p:Producto)
RETURN p.nombre,
       COUNT(c) as ventas,
       SUM(c.monto) as ingreso_total
ORDER BY ventas DESC
LIMIT 5;

// Ventas por país
MATCH (u:UsuariosEcommerce)-[c:COMPRÓ]->(p:Producto)
RETURN u.pais,
       COUNT(DISTINCT u) as compradores,
       COUNT(c) as ventas,
       SUM(c.monto) as ingreso_total
ORDER BY ingreso_total DESC;
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

// Ventas por categoría principal
MATCH (p:Producto)-[:PERTENECE_A]->(c:Categoria)
WHERE c.padre_id IS NULL
MATCH (u:UsuariosEcommerce)-[compra:COMPRÓ]->(p)
RETURN c.nombre as categoria,
       COUNT(compra) as total_ventas,
       SUM(compra.monto) as monto_total
ORDER BY monto_total DESC;
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
│   ├── usuarios.csv
│   └── compras.csv
└── scripts/
    ├── import.sh
    └── estructura.cypher
```

## Notas

- Los precios están en dólares
- Las fechas siguen el formato YYYY-MM-DD
- Los montos incluyen el precio \* cantidad
