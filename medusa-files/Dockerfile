FROM node:22-alpine

WORKDIR /server

COPY package.json package-lock.json yarn.lock .yarnrc.yml ./

RUN npm install

COPY . .

EXPOSE 9000

CMD ["./start.sh"]