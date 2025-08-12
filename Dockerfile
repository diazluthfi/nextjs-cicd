FROM node:20-alpine

WORKDIR /home/myuser/app

# Buat user dulu
RUN adduser -D myuser

# Copy package.json dan package-lock.json dengan ownership myuser
COPY --chown=myuser:myuser package*.json ./

# Ubah kepemilikan folder kerja ke myuser (biar npm install nanti lancar)
RUN chown -R myuser:myuser /home/myuser/app

# Switch user ke myuser
USER myuser

# Install dependencies dan build
RUN npm install && npm run build

# Copy sisa file dengan ownership myuser
COPY --chown=myuser:myuser . .

EXPOSE 3000

CMD ["npm", "start"]
