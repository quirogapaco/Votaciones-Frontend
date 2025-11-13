# Etapa de construcción
FROM node:20-alpine AS build

WORKDIR /app

COPY package.json pnpm-lock.yaml ./

# Instalar pnpm
RUN npm install -g pnpm

# Instalar dependencias
RUN pnpm install

COPY . .

# Definir variable de entorno para el build
ENV VITE_API_URL=http://localhost:4200

# Construir la aplicación
RUN pnpm build


# Etapa de producción con nginx
FROM nginx:alpine

COPY --from=build /app/dist /usr/share/nginx/html

# Copiar configuración de nginx
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
