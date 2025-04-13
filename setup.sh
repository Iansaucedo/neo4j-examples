#!/bin/bash

# Colores para output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

# Configuración
NEO4J_USER="neo4j"
NEO4J_PASSWORD="12345678"  # Contraseña por defecto inicial
NEO4J_NEW_PASSWORD="tu_password"  # Misma contraseña usada en los scripts de importación

echo "Configurando Neo4j..."

# Verificar si Neo4j está instalado
if ! command -v neo4j &> /dev/null; then
    echo -e "${RED}Neo4j no está instalado. Instalando...${NC}"
    
    # Añadir repositorio Neo4j
    wget -O - https://debian.neo4j.com/neotechnology.gpg.key | sudo apt-key add -
    echo 'deb https://debian.neo4j.com stable latest' | sudo tee /etc/apt/sources.list.d/neo4j.list
    
    sudo apt-get update
    sudo apt-get install -y neo4j
fi

# Configurar permisos del directorio de importación
echo "Configurando permisos del directorio de importación..."
sudo chown -R neo4j:neo4j /var/lib/neo4j/import
sudo chmod 755 /var/lib/neo4j/import

# Iniciar Neo4j
echo "Iniciando Neo4j..."
sudo systemctl start neo4j
sudo systemctl enable neo4j

# Esperar a que Neo4j esté disponible
echo "Esperando a que Neo4j esté disponible..."
sleep 15

# Cambiar contraseña
echo "Cambiando contraseña de Neo4j, si es tu primera vez pon de contrasena 12345678 si no cierra el script y cambia la contrasena que tiene o modifica los setup.sh..."
cypher-shell -u $NEO4J_USER -p $NEO4J_PASSWORD \
  "ALTER CURRENT USER SET PASSWORD FROM '$NEO4J_PASSWORD' TO '$NEO4J_NEW_PASSWORD'"


if [ $? -eq 0 ]; then
    echo -e "${GREEN}Contraseña actualizada exitosamente${NC}"
    
    # Actualizar permisos de los scripts de importación
    echo "Configurando permisos de los scripts..."
    find . -name "import.sh" -type f -exec chmod +x {} \;
    
    # Crear archivo de configuración para los scripts
    echo "Creando archivo de configuración..."
    cat > neo4j.conf << EOL
NEO4J_USER=$NEO4J_USER
NEO4J_PASSWORD=$NEO4J_NEW_PASSWORD
NEO4J_IMPORT_DIR="/var/lib/neo4j/import"
EOL
    
    echo -e "${GREEN}Configuración completada${NC}"
    echo "Las credenciales se han guardado en neo4j.conf"
    echo "Puedes proceder a ejecutar los scripts de importación en cada ejemplo"
else
    echo -e "${RED}Error al cambiar la contraseña${NC}"
    exit 1
fi

# Verificar el estado de Neo4j
echo "Estado de Neo4j:"
sudo systemctl status neo4j

echo -e "\n${GREEN}Setup completado. Ahora puedes ejecutar los scripts de importación de cada ejemplo${NC}"