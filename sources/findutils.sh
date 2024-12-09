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
	horas=$(echo "$segundos/3600" | bc)
	local resto=$(echo "$seconds%3600" | bc)
	minutos=$(echo "$resto/60" | bc)
	segundos=$(echo "$resto%60" | bc)
	echo "tempo convertido de $horas horas $minutos minutos e $segundos segundos"
}
tempo_estimado=$(echo "$SBU * 0.1"|bc)
echo "Este processo demora 0.1 SBU ou seja $tempo_estimado segundos"
echo "ou $(convert_time $tempo_estimado)"
sleep 3 

tar -xvf findutils-4.10.0.tar.xz
cd findutils-4.10.0
echo "Configurando"
./configure --prefix=/usr                   \
            --localstatedir=/var/lib/locate \
            --host=$LFS_TGT                 \
            --build=$(build-aux/config.guess)
        
echo "Compilando"
make
echo "Instalando"
make DESTDIR=$LFS install