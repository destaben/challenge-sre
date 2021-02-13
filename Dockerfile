FROM node:12-slim
WORKDIR /usr/src/app

ENV NODE_ENV production

COPY app .
RUN npm ci --only=production

EXPOSE 3000

USER node
CMD [ "node", "src/index.js" ]