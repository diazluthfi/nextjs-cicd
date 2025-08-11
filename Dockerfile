FROM node:20-alpine

WORKDIR /home/myuser/app

RUN adduser -D myuser

COPY --chown=myuser:myuser package*.json ./
RUN npm install

COPY --chown=myuser:myuser . .

USER myuser

RUN npm run build

EXPOSE 3000

CMD ["npm", "start"]
