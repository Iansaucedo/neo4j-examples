#!/bin/bash

# Configuración de Neo4j
NEO4J_IMPORT_DIR="/var/lib/neo4j/import"
NEO4J_USER="neo4j"
NEO4J_PASSWORD="tu_password"
DATOS_DIR="../datos"

# Colores para output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo "Iniciando importación de datos universidad..."

# Verificar que existan los archivos necesarios
for file in estudiantes.csv materias.csv calificaciones.csv; do
    if [ ! -f "$DATOS_DIR/$file" ]; then
        echo -e "${RED}Error: No se encuentra el archivo $file${NC}"
        exit 1
    fi
done

# Copiar archivos CSV al directorio de importación
echo "Copiando archivos CSV..."
sudo cp $DATOS_DIR/*.csv $NEO4J_IMPORT_DIR/

# Dar permisos necesarios
echo "Configurando permisos..."
sudo chown neo4j:neo4j $NEO4J_IMPORT_DIR/*.csv

# Ejecutar script Cypher
echo "Ejecutando script Cypher..."
cat estructura.cypher | cypher-shell -u $NEO4J_USER -p $NEO4J_PASSWORD

if [ $? -eq 0 ]; then
    echo -e "${GREEN}Importación completada exitosamente${NC}"
else
    echo -e "${RED}Error durante la importación${NC}"
    exit 1
fi

# Limpiar archivos temporales
echo "Limpiando archivos temporales..."
sudo rm $NEO4J_IMPORT_DIR/{estudiantes,materias,calificaciones}.csv

echo "Proceso finalizado"