# pull base image
FROM node:16

WORKDIR /ui
# install glob debs (Check if you have to cd into work dev [if so then below runs will not be needed])
RUN npm i -g elm 
RUN npm i -g elm-live
RUN npm i -g tailwindcss 
RUN npm i -g concurrently

# Install dependencies 
COPY package.json package-lock.json /ui/ 
RUN npm install 
EXPOSE 3000 
COPY .  /ui/
RUN npm run elm:ts:generate_types
CMD ["npm", "start"]