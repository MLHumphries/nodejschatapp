FROM mhart/alpine-node
COPY . /public
CMD node /public/chat.js
EXPOSE 3000