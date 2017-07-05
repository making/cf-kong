#!/bin/sh

export KONG_PROXY_LISTEN=0.0.0.0:8080
#export KONG_ADMIN_LISTEN=0.0.0.0:8080
export LD_LIBRARY_PATH=/home/vcap/app/.apt/usr/local/lib:/home/vcap/app/.apt/usr/local/lib/lua/5.1/:$LD_LIBRARY_PATH
export LUA_PATH='/home/vcap/app/.apt/usr/local/share/lua/5.1/?.lua;/home/vcap/app/.apt/usr/local/share/lua/5.1/?/init.lua;/home/vcap/app/.apt/usr/local/openresty/lualib/?.lua'
export LUA_CPATH='/home/vcap/app/.apt/usr/local/lib/lua/5.1/?.so'
export PATH=/home/vcap/app/.apt/usr/local/bin/:$PATH


# hack ;)
grep -irIl '/usr/local' ./.apt | xargs sed -i -e 's|/usr/local|/home/vcap/app/.apt/usr/local|'

# configure postgres
SERVICE=elephantsql
URI=`echo $VCAP_SERVICES | jq -r '.["'$SERVICE'"][0].credentials.uri'`
export KONG_PG_USER=`echo $URI | cut -d : -f 2 | tr -d '/'`
export KONG_PG_HOST=`echo $URI | cut -d @ -f 2 | cut -d : -f 1`
export KONG_PG_PORT=5432
export KONG_PG_DATABASE=$KONG_PG_USER
export KONG_PG_PASSWORD=`echo $URI | sed  "s|$KONG_PG_HOST||g" | sed  "s|$KONG_PG_USER||g" | sed  "s|$KONG_PG_PORT||g" | sed "s|/||g"  | sed "s|:||g"  | sed "s|postgres||g"  | sed "s|@||g"`
export KONG_LUA_PACKAGE_PATH=$LUA_PATH
export KONG_LUA_PACKAGE_CPATH=$LUA_CPATH

# start kong
kong start --vv

# keep this process alive
while true
do
    sleep 1d
done

