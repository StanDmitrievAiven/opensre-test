# OpenSRE, stateless, with Postgres

The container keeps no durable disk. Gateway records that must survive a restart use `DATABASE_URL`. Image and modes follow [Tracer-Cloud/opensre](https://github.com/Tracer-Cloud/opensre): `web` (default), `gateway`, `scheduler`.

```bash
cp .env.example .env   # set LLM_PROVIDER and the matching API key
docker compose up --build
curl http://localhost:8000/health
```

For an external database, set `DATABASE_URL` in `.env` (Nevia needs `sslmode=require`) and start the app without the bundled database:

```bash
docker compose up --build opensre --no-deps
```
