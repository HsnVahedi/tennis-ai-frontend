# nextjs-starter was used to create a nextjs project
FROM node:lts-alpine3.19 as nextjs-starter
WORKDIR /app

FROM nextjs-starter as base
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 3000


# Use this image for frontend development:
# 1) Build the docker image: docker build --target dev -t tennis-ai-front:dev .
# 2) Change directory to `environments/dev`: cd environments/dev
# 3) Run the docker compose project: docker compose up
FROM base as dev
ENV NODE_ENV=development
# Update apk and install git
RUN apk update && \
    apk add --no-cache git
# Do nothing, just wait for frontend developers to run `npm run dev`
CMD ["tail", "-f", "/dev/null"]
# CMD npm run dev

FROM base as build
ENV NODE_ENV=build
RUN npm run build

FROM build as prod
ENV NODE_ENV=production
CMD npm run start
