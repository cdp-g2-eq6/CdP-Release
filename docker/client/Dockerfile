FROM node:latest

WORKDIR /usr/src/client

COPY client/ ./

RUN rm package-lock.json && npm install

EXPOSE 8080

CMD [ "npm", "run", "serve" ]