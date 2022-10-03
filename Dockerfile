ARG LUA_VERSION

FROM kieferro/debian-lua:$LUA_VERSION

WORKDIR /workdir
COPY src ./

CMD lua$LUA_VERSION test.lua -v
