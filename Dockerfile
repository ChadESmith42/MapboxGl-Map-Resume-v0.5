FROM nginx:1.17.1-alpine
COPY nginx.conf /etc/nginx.conf
COPY . /usr/share/nginx/html
