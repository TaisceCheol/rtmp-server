### Live-streaming to multiple endpoints

This Irish Traditional Music Archive's docker setup for live-streaming to multiple endpoints.

Our setup involves sending [OBS](https://obsproject.com/) to an [nginx](https://www.nginx.com/resources/wiki/) process running in a Docker container. Nginx can push the rtmp stream to as many endpoints as you like. Endpoint keys can be specified dynamically using the docker-compose file. Nginx expects rtmp streams via port 1935, but you can map this howeverso you like in docker-compose.

===

Digital Projects @ ITMA

piaras.hoban@itma.ie