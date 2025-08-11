FROM node:20-alpine AS builder

# Set working directory
WORKDIR /app

# Salin file package.json dan package-lock.json terlebih dahulu
COPY package*.json ./

# Install dependencies
RUN npm ci

# Salin semua source code
COPY . .

# Build aplikasi Next.js
RUN npm run build

# ------------------------------
# Stage kedua untuk image final
# ------------------------------
FROM node:20-alpine

WORKDIR /app

# Buat user non-root
RUN adduser -D myuser

# Salin hasil build dan node_modules dari stage builder
COPY --from=builder /app . 

# Ubah kepemilikan folder
RUN chown -R myuser:myuser /app

# Pindah ke user non-root
USER myuser

EXPOSE 3000

# Jalankan aplikasi
CMD ["npm", "start"]
