# nucleus-explorer

---
## Dependencies
 
 - Install [Docker](https://docs.docker.com/engine/install/ubuntu/#install-using-the-convenience-script) with [post install steps](https://docs.docker.com/engine/install/linux-postinstall/).
 - Install [NVM](https://github.com/nvm-sh/nvm?tab=readme-ov-file#installing-and-updating) with `curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash`, then `nvm install 18 && nvm use 18`.
 - Install [Yarn](https://classic.yarnpkg.com/en/docs/install/#debian-stable) with `npm install --global yarn`.
 - This repo with submodules `git clone --recurse-submodules`.
 

---
## Installation

- Copy the env template with `cp .env.example .env` and update the database credentials.
- Copy the `config.yaml.example` template in the `callisto` directory to `config.yaml` and update the database credentials.  [# TODO: This should be done automatically in the setup script using date in .env]

Run `./setup.sh` to:
- Create database schemas in PgSQL.
- Generate the UI code for the front end.
- Build the containers for PgSQL, Nucleus, Hasura, Callisto and the front end.
- Apply database schema to PgSQL.
- Apply metadata to Hasura.
- Start the containers.

---
## Notes

Setting up for SSL has some potential hurdles. Here's hwo to resolve a few of them:

If you encounter `ERROR: failed to start client: tls: first record does not look like a TLS handshake` or `ERROR: failed to start client: websocket: bad handshake`:
- Make sure you have valid SSL certs defined in the `~/.nucleus/config/config.yaml` file, and are not in conflicy with nginx for the same port / cert. 
- Regardless of SSL, in the `callisto/config.yaml` file, under node.config.rpc.address, use the `http` protocol, not `https`.

Setting up Hasura behund proxy: https://hasura.io/docs/latest/deployment/serve-behind-proxy/

