FROM gliderlabs/herokuish:v0.5.25

RUN mkdir -p /app
ADD . /app
RUN /build
