FROM jacoblincool/workerd:latest

COPY ./worker.capnp ./worker.capnp

COPY ./dist/index.js ./dist/index.js
COPY ./dist/f5bbf199decd89a3f0c75d721b5a235524ca7235-chat.html ./dist/f5bbf199decd89a3f0c75d721b5a235524ca7235-chat.html

CMD ["serve", "--experimental", "worker.capnp"]