# nucleus-explorer

- Run `./setup.sh` to create database schemas
- from the `big-dipper-2.0-cosmos` directory, run `yarn`, then `corepack enable && yarn dev --filter web-nucleus` generate the code to be served to the front end. 
- Check `http://localhost:3000` to confirm it loads, then `Ctl-C` to stop serving the front end.
- Build the contianers for PGSql, Nucleus, Hasura, Callisto and the front end by running `docker-compose up --build` from the project root directory.
