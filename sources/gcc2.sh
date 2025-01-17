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
tempo_estimado=$(echo "$SBU * 4.2"|bc)
echo "Este processo demora 4.2 SBU ou seja $tempo_estimado segundos"
echo $(convert_time $tempo_estimado)
sleep 3 
cd gcc-14.2.0

echo "Preparando para compilar"
tar -xf ../mpfr-4.2.1.tar.xz
mv -v mpfr-4.2.1 mpfr
tar -xf ../gmp-6.3.0.tar.xz
mv -v gmp-6.3.0 gmp
tar -xf ../mpc-1.3.1.tar.gz
mv -v mpc-1.3.1 mpc

case $(uname -m) in
  x86_64)
    sed -e '/m64=/s/lib64/lib/' \
        -i.orig gcc/config/i386/t-linux64
  ;;
esac

sed '/thread_header =/s/@.*@/gthr-posix.h/' \
-i libgcc/Makefile.in libstdc++-v3/include/Makefile.in

mkdir -v buildpasso2
cd buildpasso2
../configure                                       \
    --build=$(../config.guess)                     \
    --host=$LFS_TGT                                \
    --target=$LFS_TGT                              \
    LDFLAGS_FOR_TARGET=-L$PWD/$LFS_TGT/libgcc      \
    --prefix=/usr                                  \
    --with-build-sysroot=$LFS                      \
    --enable-default-pie                           \
    --enable-default-ssp                           \
    --disable-nls                                  \
    --disable-multilib                             \
    --disable-libatomic                            \
    --disable-libgomp                              \
    --disable-libquadmath                          \
    --disable-libsanitizer                         \
    --disable-libssp                               \
    --disable-libvtv                               \
    --enable-languages=c,c++ CXXFLAGS=-std=c++17
echo "Compilando"
sleep 3
make
echo "Instalando"
sleep 3 
make DESTDIR=$LFS install
echo "Como um toque final, crie um link simbólico de utilidade. Muitos programas e scripts run cc em vez de gcc, que é usado para manter os programas genéricos e, portanto, utilizáveis em todos os tipos de sistemas UNIX onde o compilador GNU C nem sempre é instalado. Correr cc deixa o administrador do sistema livre para decidir qual compilador C instalar"
ln -sv gcc $LFS/usr/bin/cc