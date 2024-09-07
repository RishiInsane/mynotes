# Stage 1
FROM debian:latest AS app-build

RUN apt-get update 
RUN apt-get install -y curl git wget unzip libgconf-2-4 gdb libstdc++6 libglu1-mesa fonts-droid-fallback python3
RUN apt-get clean

RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter

ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

RUN flutter doctor -v

RUN flutter channel master
RUN flutter upgrade
RUN flutter config --enable-web

RUN mkdir /project_notesapp/
COPY . /project_notesapp/
WORKDIR /project_notesapp/
RUN flutter build web

# Stage 2
FROM nginx:1.21.1-alpine
COPY --from=app-build /project_notesapp/build/web /usr/share/nginx/html
