FROM node:20-alpine

RUN mkdir -p /home/app

COPY . /home/app

WORKDIR /home/app

EXPOSE 3000

RUN npm install

CMD ["node", "server.js"]