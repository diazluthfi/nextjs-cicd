FROM node:20-alpine

WORKDIR /home/myuser/app

RUN adduser -D myuser

# Copy semua file dengan ownership myuser langsung
COPY --chown=myuser:myuser package*.json ./
COPY --chown=myuser:myuser . .

USER myuser

RUN npm install
RUN npm run build

EXPOSE 3000

CMD ["npm", "start"]
