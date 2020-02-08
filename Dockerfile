#builder phase of production Dockerfile
FROM node:alpine as builder
WORKDIR /app
COPY package.json .
RUN npm install
#copy all source code. We don't need to map since we will not be working with source code since
#this is the production Dockerfile
COPY . . 
#Note: Don’t confuse RUN with CMD. 
#RUN actually runs a command and commits the result; 
#CMD does not execute anything at build time, but specifies the intended command for the image.
RUN npm run build

#run phase
FROM nginx
EXPOSE 80
#copy from builder phase - copy /app/build to: /usr/share/nginx/html
COPY --from=builder /app/build /usr/share/nginx/html

#default nginx command starts nginx so no need for a CMD command
#https://docs.docker.com/engine/reference/builder/#cmd
