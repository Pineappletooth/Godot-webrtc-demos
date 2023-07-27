# Godot webrtc demos
This repo contains an adapted version of the oficial godot 4 [multiplayer bomber](https://github.com/godotengine/godot-demo-projects/tree/master/networking/multiplayer_bomber) and [multiplayer pong](https://github.com/godotengine/godot-demo-projects/tree/master/networking/multiplayer_pong) demos using WebRTC.

The demos run in godot 4.1 and the base used was taken from master branch: [commit f7e3ceb31eee9607b](https://github.com/godotengine/godot-demo-projects/tree/f7e3ceb31eee9607b1676b52a0636aa67e371a70).

The networking part both client and server was totally based on the oficial [webrtc signaling demo](https://github.com/godotengine/godot-demo-projects/tree/master/networking/webrtc_signaling)

## WebRTCMultiplayerPeer and the High level multiplayer API
The godot documentation does not explain very clearly the total capabilies of the clases that extend [MultiplayerPeer](https://docs.godotengine.org/en/stable/classes/class_multiplayerpeer.html) such as WebRTCMultiplayerPeer or  WebRTCMultiplayerPeer. There is also very scarce tutorials and resources for learning besides the oficial demos.

That lead to the confusion of some users that thought that High level networking can only work with ENetMultiplayerPeer, and other networking must be handled by hand, however the truth is that besides the initial setup they work as a drop in replacement, with all the high level functionality working without any modification, both RPCs and MultiplayerSynchronizer/MultiplayerSpawner nodes.

That means that you can easily port your existing online game to web without major effort or if you already have a free/cheap turn server and don't want to mess with another relay you can implement webRTC while we wait for this [proposal#434](https://github.com/godotengine/godot-proposals/issues/434) to be implemented.

## PreRequisites

In order to run webRTC on native plataforms (desktop/mobile) you need the official godot plugin https://github.com/godotengine/webrtc-native, just download, decompress on the proyect folder and reload godot.

Note that in order to allow any peer to conect you need:
- A hosted version of the signaling server
- A STUN/TURN server (stun servers are chap/free, TURN servers on the other hand are quite expensive)
  
> If you need a free TURN server for testing purposes https://www.metered.ca/stun-turn offers free turn servers up to 50gb of traffic, paid tier is quite expensive tho.  
> You can also host it yourself, just be aware of bandwidth usage.

Add you STUN/TURN server to the peer.initialize function in [multiplayer_pong/webRTC-client/multiplayer_client.gd](/multiplayer_pong/webRTC-client/multiplayer_client.gd) and [multiplayer_bomber/webRTC-client/multiplayer_client.gd](/multiplayer_bomber/webRTC-client/multiplayer_client.gd)

**Disclaimer** : Both the server and client are quite naive implementations, they will need some modifications in order to being able to be used in production.

## Changes made to the original demo
The changes made to the repo were intended to be the more minimal possible, it mainly includes the webrtc plugin, the client for the signaling server and a few lines of replacement of the ENet code.

Also replaced the ip box with a room feature that the signaling server provides (if you played amongus you know how it works)

