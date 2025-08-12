FROM node:20-alpine

RUN adduser -D myuser

WORKDIR /home/myuser/app

# Pastikan ownership folder kerja sudah myuser
RUN chown -R myuser:myuser /home/myuser/app

# Copy package.json dan package-lock.json saja dulu dengan ownership myuser
COPY --chown=myuser:myuser package*.json ./

USER myuser

RUN npm install

# Copy source code lainnya, juga dengan ownership myuser
COPY --chown=myuser:myuser . .

RUN npm run build

EXPOSE 3000

CMD ["npm", "start"]
