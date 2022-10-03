FROM debian:latest

ARG LUA_VERSION

RUN apt-get -y update
RUN apt-get -y install lua$LUA_VERSION luarocks
RUN luarocks install luaunit

WORKDIR /workdir
COPY src ./

CMD lua$LUA_VERSION test.lua -v
