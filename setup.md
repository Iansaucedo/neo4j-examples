```bash
#!/bin/bash

# Colores para output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

# Configuración
NEO4J_USER="neo4j"
NEO4J_PASSWORD="tu_password"
NEO4J_NEW_PASSWORD="mi_password_segura"

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

# Iniciar Neo4j
sudo systemctl start neo4j
sudo systemctl enable neo4j

# Esperar a que Neo4j esté disponible
echo "Esperando a que Neo4j esté disponible..."
sleep 10

# Cambiar contraseña
echo "Cambiando contraseña de Neo4j..."
cypher-shell -u $NEO4J_USER -p $NEO4J_PASSWORD \
  "CALL system.change_password('$NEO4J_NEW_PASSWORD')"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}Contraseña actualizada exitosamente${NC}"

    # Crear archivo de configuración para los scripts
    echo "Creando archivo de configuración..."
    cat > neo4j.conf << EOL
NEO4J_USER=$NEO4J_USER
NEO4J_PASSWORD=$NEO4J_NEW_PASSWORD
EOL

    echo -e "${GREEN}Configuración completada${NC}"
    echo "Las credenciales se han guardado en neo4j.conf"
else
    echo -e "${RED}Error al cambiar la contraseña${NC}"
    exit 1
fi

# Verificar el estado de Neo4j
echo "Estado de Neo4j:"
sudo systemctl status neo4j
```

Este script:

1. Instala Neo4j si no está instalado
2. Inicia el servicio
3. Cambia la contraseña por defecto
4. Crea un archivo de configuración para los scripts
5. Muestra el estado del servicio

Para usarlo:

```bash
chmod +x setup_neo4j.sh
./setup_neo4j.sh
```

Después de ejecutarlo, podrás usar las credenciales en tus scripts de importación reemplazando los valores en los archivos `import.sh`.


