if [ -z "$LFS"]||[ -z $LFS_TGT];then
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
	horas=$(($segundos/3600))
	local resto=$(($seconds%3600))
	minutos=$(($resto/60))
	segundos=$(($resto%60))
	echo "tempo convertido de $horas horas $minutos minutos e $segundos segundos"
}
tar -xvf m4-1.4.19.tar.xz
cd m4-1.4.19
#mkdir -v build
#cd build
tempo_estimado=$(echo "$SBU * 0.1"|bc)
echo "Este processo demora 0.1 SBU ou seja $tempo_estimado segundos"

./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --build=$(./build-aux/config.guess)
        

echo "Iniciando compilação"
sleep 2 
make
echo "Instalando"
make DESTDIR=$LFS install