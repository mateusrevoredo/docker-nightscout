FROM node:10-buster

ENV NIGHTSCOUT_VERSION=14.2.1
ENV HOSTNAME=0.0.0.0

RUN mkdir -p /opt/app
RUN curl -Lo nightscout.tar.gz https://github.com/nightscout/cgm-remote-monitor/archive/${NIGHTSCOUT_VERSION}.tar.gz \
    && tar -xzf nightscout.tar.gz --strip-components=1 -C /opt/app \
    && rm nightscout.tar.gz 

WORKDIR /opt/app

# Make express.js server listen on all interfaces in case the container has more than one
RUN sed -i "s/var HOSTNAME = env.HOSTNAME;/var HOSTNAME = '0.0.0.0';/g" lib/server/server.js

RUN chown -R node:node /opt/app
USER node

RUN npm install && \
  npm run postinstall && \
  npm run env && \
  npm audit fix

EXPOSE 1337

CMD ["node", "server.js"]
