#!/bin/bash

base_dir=$(pwd)
openresty_tar="openresty-1.11.2.1.tar.gz"
pcre_tar="pcre-8.33.tar.gz"
stream_module="https://github.com/openresty/stream-lua-nginx-module.git"

echo "$(tput setaf 2)Downloading openresty...$(tput sgr0)"
curl -O -L "http://openresty.org/download/$openresty_tar"
echo "$(tput setaf 2)Downloading pcre...$(tput sgr0)"
curl -O -L "http://downloads.sourceforge.net/sourceforge/pcre/$pcre_tar"
git clone $stream_module

tar -xzf $openresty_tar
tar -xzf $pcre_tar

export PATH=/sbin:$PATH

pcre_dir="$base_dir/$(ls -d pcre*/ | head -n 1)"


echo "$(tput setaf 2)Building openresty...$(tput sgr0)"
(
	cd $(ls -d openresty-*/ | head -n 1)
	./configure --with-pcre=$pcre_dir --with-http_postgres_module --with-pcre-jit --add-module=/app/stream-lua-nginx-module --with-stream --with-stream_ssl_module
	make
	mkdir /tmp/openresty
	make DESTDIR=/tmp/openresty install
)


echo "$(tput setaf 2)Packing build.tar.gz$(tput sgr0)"
(
	cd /tmp/
	tar czf "$base_dir/build.tar.gz" openresty
)

echo "$(tput setaf 2)Done!$(tput sgr0)"
