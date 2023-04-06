FROM node:19-alpine3.15 AS builder
ENV NODE_ENV production

WORKDIR /app

COPY package.json .
COPY package-lock.json .
RUN npm install --production

RUN npm run build


FROM nginx:1.23-alpine as production
ENV NODE_ENV production
COPY --from=builder /app/build /usr/share/nginx/html

COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 3000
CMD ["nginx", "-g", "daemon off;"]