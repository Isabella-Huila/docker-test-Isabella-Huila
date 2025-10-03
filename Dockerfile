# Usa una imagen base oficial de Node.js
FROM node:18-alpine AS builder

# Establece el directorio de trabajo
WORKDIR /app

# Copia los archivos de dependencias
COPY package.json package-lock.json* ./

# Instala las dependencias
RUN npm install

# Copia el resto de los archivos de la aplicación
COPY . .

# Construye la aplicación para producción
RUN npm run build

# Usa una imagen ligera de nginx para servir los archivos estáticos
FROM nginx:alpine
WORKDIR /usr/share/nginx/html
COPY --from=builder /app/build .

# Expone el puerto 80
EXPOSE 80

# Comando por defecto para nginx
CMD ["nginx", "-g", "daemon off;"]