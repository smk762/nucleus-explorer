# nucleus-explorer

- Run `./setup.sh` to create database schemas in pgsql
- From `big-dipper-2.0-cosmos` directory:
    - run `yarn`to install deps
    - run `corepack enable`
    - run `yarn dev --filter web-nucleus` to generate the code to be served to the front end. 

You might see an error
```
➤ YN0000: │ ESM support for PnP uses the experimental loader API and is therefore experimental
➤ YN0007: │ @sentry/cli@npm:1.74.6 must be built because it never has been before or the last one failed
➤ YN0009: │ @sentry/cli@npm:1.74.6 couldn't be built successfully (exit code 1, logs can be found here: /tmp/xfs-744bcd4f/build.log)
```
It can be ignored.


- Check `http://localhost:3000` to confirm it loads, then `Ctl-C` to stop serving the front end.
- Build the contianers for PGSql, Nucleus, Hasura, Callisto and the front end by running `docker-compose up --build` from the project root directory.
