FROM node:20-alpine

WORKDIR /home/myuser/app

RUN adduser -D myuser

# Copy package.json dulu dengan ownership myuser
COPY --chown=myuser:myuser package*.json ./

USER myuser

RUN npm install && npm run build

# Copy sisa file dengan ownership myuser
COPY --chown=myuser:myuser . .

EXPOSE 3000

CMD ["npm", "start"]
