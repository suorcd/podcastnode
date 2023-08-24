# podcastnode

A Docker App that provides IPFS storage and hosting for IPFSPodcasting.net (Crowd/Self hosting of podcast episodes over IPFS).
If you have a Docker server and would like to participate, you can use the CLI:


## Install via server CLI

1. SSH into your server:

  ```bash
  ssh user@server.local
  ```

2. Create app directories & download/install docker-compose.yml:

  ```bash
  cd ~/
  git clone https://github.com/suorcd/podcastnode.git
  cd podcastnode
  git checkout docker-standalone
  docker compose pull
  ```

3. Create and update .env file

  Note: configure your email address to manage the node at <https://ipfspodcasting.net/Manage>

  Copy example.env to .env
  ```bash
  cp example.env .env
  ```

  In .env update the usermail value to your email address

4. Start IPFS Podcasting

  Foreground
  ```bash
  docker compose up
  ```
  
  Background
  ```bash
  docker compose up -d
  ```

4. You can browse the Web UI at <http://server.local:8675/> and  You can also view the communication log to view activity.

![image](https://user-images.githubusercontent.com/103131615/181925105-82fafb97-ed07-4071-b709-e9aef6a05f60.png)


## Other useful commands (from the "~/podcastnode" directory)

### Stop the app

  ```bash
  docker compose down
  ```

### Build a new docker image

  ```bash
  docker compose build
  ```

### Start the app

  Foreground
  ```bash
  docker compose up
  ```
  
  Background
  ```bash
  docker compose up -d
  ```

### Launch a command shell to execute IPFS commands...

  ```bash
  docker compose exec ipfspodcasting-docker sh
  ```



### update ipfs/config

If you want access to the IPFS webui you'll need to allow access.
Depending on your setup you will need to adjust the 0.0.0.0 in example.
If you used the example command the webui you will be accessible to anyone with access to the network of the Docker server.

  ```bash
  docker compose exec ipfspodcasting-docker ipfs config -- Addresses.API "/ip4/0.0.0.0/tcp/5001"
  ```

### Other examples

If these commands are run restart ipfs or container

  ```bash
  docker compose exec ipfspodcasting-docker ipfs config -- Addresses.Gateway "/ip4/0.0.0.0/tcp/8080"
  ```

  ```bash
  docker compose exec ipfspodcasting-docker ipfs config --json API.HTTPHeaders.Access-Control-Allow-Origin '["http://localhost:5001", "http://localhost:3000", "http://127.0.0.1:5001", "https://webui.ipfs.io"]'
  docker compose exec ipfspodcasting-docker ipfs config --json API.HTTPHeaders.Access-Control-Allow-Methods '["PUT", "POST"]'
  ```

*Note*: If your podcastnode is behind a firewall, you may need to adjust firewall rules and/or port-foward allow traffic to port 4001 (both tcp/upd source/destination ports from your podcastnode IP address).
