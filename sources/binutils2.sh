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
tempo_estimado=$(echo "$SBU * 0.4"|bc)
echo "Este processo demora 0.4 SBU ou seja $tempo_estimado segundos"
echo $(convert_time $tempo_estimado)
sleep 3 
cd binutils-2.43.1
mkdir -v buildpasso2
cd buildpasso2

echo "Preparando para compilar"
../configure                   \
    --prefix=/usr              \
    --build=$(../config.guess) \
    --host=$LFS_TGT            \
    --disable-nls              \
    --enable-shared            \
    --enable-gprofng=no        \
    --disable-werror           \
    --enable-64-bit-bfd        \
    --enable-new-dtags         \
    --enable-default-hash-style=gnu
echo "Compilando"
sleep 3
make
echo "Instalando"
sleep 3 
make DESTDIR=$LFS install
echo "removendo os arquivos de arquivo libtool porque eles são prejudiciais para o cross compilação, e remover bibliotecas estáticas desnecessárias"
rm -v $LFS/usr/lib/lib{bfd,ctf,ctf-nobfd,opcodes,sframe}.{a,la}