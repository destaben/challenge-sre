FROM node:12-slim
WORKDIR /usr/src/app

COPY app .
RUN npm install

EXPOSE 3000
CMD [ "node", "src/index.js" ]