FROM debian:latest

RUN apt-get -y update
RUN apt-get -y install lua5.3 luarocks
RUN luarocks install luaunit

WORKDIR /workdir
COPY src ./

CMD [ "lua5.3",  "test.lua", "-v" ]
