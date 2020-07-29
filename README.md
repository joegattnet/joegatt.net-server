# joegatt.net-server

Server setup for joegatt.net (docker-compose).

## Clone this repository

This repository includes submodules for several applications. To clone the entire project:

    git clone --recursive git@github.com:joegattnet/joegatt.net-server.git

## pull all changes in the repo including changes in the submodules

    git pull --recurse-submodules

## pull all changes for the submodules

    git submodule update --remote

    git submodule foreach 'git reset --hard'

## Dashboard

    docker-compose up

Then go to http://localhost:8080/dashboard/ for Traefik's dashboard.

## To-do
- ~~Try to use better-sounding image than postgraphile-forum-example~~
- ~~Remove /graphql (it's not being used)~~
- Dockerise frontend
- Fix privileges
- Get basic design of website up
- Do hello world node/nodemon
- Do webhooks
- Do formattter
- Do joegatt.net-couriers
- Do puller
- Do pusher
