# syntax=docker/dockerfile:1

ARG NODE_VERSION=20.10-alpine

FROM node:${NODE_VERSION} as builder

# Create app directory
WORKDIR /usr/src/app

# Install app dependencies
COPY package*.json ./

RUN npm ci
COPY . .

RUN npm run build


FROM node:${NODE_VERSION} as final

WORKDIR /usr/src/app

USER node

COPY package*.json ./

RUN npm ci --production

COPY --from=builder /usr/src/app/dist ./dist

EXPOSE 3000

CMD [ "node", "dist/index.js" ]


