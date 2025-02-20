# Función para crear y cambiar a un directorio
mkcd() {
    mkdir -p "$1"
    cd "$1"
}

# Función para buscar y reemplazar texto en un archivo
buscar_reemplazar() {
    if [ "$#" -ne 3 ]; then
        echo "Uso: buscar_reemplazar archivo patron reemplazo"
        return 1
    fi
    local archivo="$1"
    local patron="$2"
    local reemplazo="$3"

    if [ ! -f "$archivo" ]; then
        echo "El archivo $archivo no existe."
        return 1
    fi

    sed -i "s/$patron/$reemplazo/g" "$archivo"
    echo "Reemplazo de '$patron' por '$reemplazo' en $archivo completado."
}

# Función para actualizar y limpiar el sistema (Debian/Ubuntu)
actualizar_limpiar() {
    sudo apt update && sudo apt upgrade -y
    sudo apt autoremove -y
    sudo apt clean
    echo "Sistema actualizado y limpio."
}

# Función para buscar texto en archivos
buscar() {
    grep -rnw "$1" -e "$2"
}

# Función para respaldar un directorio
respaldar_directorio() {
    if [ "$#" -ne 2 ]; then
        echo "Uso: respaldar_directorio origen destino"
        return 1
    fi
    local origen="$1"
    local destino="$2"
    local fecha=$(date +%Y%m%d_%H%M%S)
    local respaldo="$destino/$(basename "$origen")_respaldado_$fecha.tar.gz"

    tar -czvf "$respaldo" "$origen"
    echo "Respaldo de $origen creado en $respaldo."
}

# Función para monitorear uso de disco
monitorear_disco() {
    if [ -z "$1" ]; then
        echo "Uso: monitorear_disco <sistema_de_archivos>"
        return 1
    fi
    df -h | grep "$1"
}

# Función para insertar fecha y hora
insert_datetime() {
    BUFFER="$BUFFER$(date '+%Y-%m-%d %H:%M:%S')"
    CURSOR=$#BUFFER
}

# Function to open cursor
cursor() {
  nohup $HOME/Downloads/cursor-0.45.11-build-250207y6nbaw5qc-x86_64.AppImage --no-sandbox "$@" > /dev/null 2>&1 &
  disown
}
