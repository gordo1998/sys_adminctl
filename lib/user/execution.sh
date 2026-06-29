user_exec_comm(){
	local user="$1"
	local dir_complete="$2"

	echo "Creando usuario $user..."

    if sudo useradd -m -d "$dir_complete" "$user" &> /dev/null;then     
        echo "usuario $user creado correctamente."
    else
        echo "El usuario $user no se ha podido crear"
        return 1
    fi
}