#!/bin/bash

rm -rf tempdir
mkdir -p tempdir/templates tempdir/static

cp sample_app.py tempdir/main.py
cp -r templates/* tempdir/templates/
cp -r static/* tempdir/static/

cat <<EOF > tempdir/Dockerfile
FROM tiangolo/uwsgi-nginx-flask:python3.8
COPY ./static /app/static/
COPY ./templates /app/templates/
COPY main.py /app/
EXPOSE 5050
EOF

cd tempdir
docker build -t sampleapp .
docker rm -f samplerunning 2>/dev/null
docker run -t -d \
  --name samplerunning \
  -p 5050:80 \
  --ulimit nofile=65535:65535 \
  --ulimit nproc=65535 \
  sampleapp