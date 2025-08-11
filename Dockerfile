FROM node:20-alpine

WORKDIR /home/myuser/app

RUN adduser -D myuser

COPY package*.json ./

RUN npm install

COPY . .

RUN chown -R myuser:myuser /home/myuser

USER myuser

RUN npm run build

EXPOSE 3000

# Jalankan aplikasi
CMD ["npm", "start"]
