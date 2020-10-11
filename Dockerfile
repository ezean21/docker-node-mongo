FROM node:10

RUN apt update
RUN apt install -y curl
RUN curl https://www.mongodb.org/static/pgp/server-4.0.asc | apt-key add -
RUN echo "deb http://repo.mongodb.org/apt/debian stretch/mongodb-org/4.0 main" | tee /etc/apt/sources.list.d/mongodb-org-4.0.list
RUN apt update
RUN apt install -y mongodb-org-shell

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install

COPY . .

EXPOSE 3000

CMD ["npm", "start"]