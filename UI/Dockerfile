# pull base image
FROM node:16

WORKDIR /ui
# Install dependencies 
COPY package.json package-lock.json /ui/ 
RUN npm install 
EXPOSE 3000 
COPY .  /ui/
RUN npm run elm:ts:generate_types
CMD ["npx", "concurrently","npm:docker:elm", "npm:dev:tailwind"]