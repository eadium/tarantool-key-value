FROM tarantool/tarantool
COPY app.lua /opt/tarantool
# RUN tarantoolctl rocks install document
CMD ["tarantool", "/opt/tarantool/app.lua"]