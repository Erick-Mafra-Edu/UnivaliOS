if [ -z "$LFS" ]||[ -z $LFS_TGT ];then
	echo "Alguma das variaveis não foi definida por favor verifique a variavel LFS e LFS_TGT"
	exit 1
fi
tratamento_de_erro(){
	echo "Erro detectado!"
	echo "Comando: \"$BASH_COMMAND\""
	echo "Na linha: $LINENO"
	echo "Código de erro: $?"
	echo "No script $(basename $0)"
    	exit 1
}
trap tratamento_de_erro ERR
sbu_time(){
	echo $(($SECONDS - $START_TIME))
}
convert_time(){
	local segundos=$1
    echo $segundos
	horas=$(echo "scale=0; $segundos / 3600" | bc)
	local resto=$(echo "scale=0; $segundos % 3600" | bc)
	minutos=$(echo "scale=0; $resto / 60" | bc)
	segundos=$(echo "scale=0; $resto % 60" | bc)
	echo "tempo convertido de $horas horas $minutos minutos e $segundos segundos"
}
tempo_estimado=$(echo "$SBU * 0.1"|bc)
echo "Este processo demora 0.1 SBU ou seja $tempo_estimado segundos"
echo $(convert_time $tempo_estimado)
sleep 3 
tar -xvf sed-4.9.tar.xz 
cd sed-4.9
echo "Preparando para compilar"
./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --build=$(./build-aux/config.guess)

echo "Compilando"
sleep 2 
make
echo "Instalando"
sleep 2 
make DESTDIR=$LFS install