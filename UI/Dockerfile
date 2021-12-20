# pull base image
FROM node:16

WORKDIR /ui
# Install dependencies 
COPY package.json package-lock.json /ui/ 
RUN npm install 
COPY ./index.html  /ui/
COPY tailwind.css tailwind.config.js /ui/ 
COPY elm.json /ui/ 
EXPOSE 3000 
COPY ./src/ /ui/
CMD ["npm", "run", "docker:elm"]
#running with  doocker:dev resulted in inifnite loop somehow 