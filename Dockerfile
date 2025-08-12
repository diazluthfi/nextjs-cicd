FROM node:20-alpine

WORKDIR /home/myuser/app

# Tambahkan user dan install dependencies + build dalam satu layer
RUN adduser -D myuser \
 && apk add --no-cache git  # jika perlu tools tambahan, hapus kalau gak perlu \
 && chown -R myuser:myuser /home/myuser

# Copy package.json dulu untuk caching yang optimal
COPY package*.json ./

# Install dependencies dan build sebagai user myuser (pakai su-exec atau gosu, atau workaround)
USER myuser

RUN npm install && npm run build

# Copy sisa file setelah build supaya cache lebih efektif
COPY --chown=myuser:myuser . .

EXPOSE 3000

CMD ["npm", "start"]
