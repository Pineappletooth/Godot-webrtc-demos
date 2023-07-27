# Signaling server
This code is meant to be hosted on the internet in a server. You only need one, either the gdscript one or the js.
The signaling server is needed to be able to find the other peer over the internet, it creates a lobby with some id (originaly 16 characters, 5 in this version) and the other player sends the id to conect with.

This servers are relatively cheap to host and mantain, they do not relay the trafic of the game, they mainly redirect the ICE packet to the other peer.

## Run instructions

### Js server
For the js server you need nodejs instaled, then run.
```
npm install
npm run start
```

There are some PaaS that let you host by free or paid take a look at https://free-for.dev/#/?id=paas

### Gdscript server
Add the script to a node, then export the game as headless.

This is mainly meant to be added to an dedicated client server, if you only need signaling i recommend using the js one.

