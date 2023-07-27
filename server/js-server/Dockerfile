FROM node:18-alpine as base

WORKDIR /app

COPY . .

RUN npm install

EXPOSE 9080

CMD [ "npm", "start" ]
