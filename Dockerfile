FROM node:12

# Create app directory
WORKDIR /usr/src/app

# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)
COPY package*.json ./

RUN npm install

# Bundle app source
COPY . .

# RUN npm run build

EXPOSE 9527
CMD [ "npm", "run", "serve" ]

# TODO: build and run a http server on dist directlyt