# STEPS

```bash
npx @backstage/create-app@latest
```

Add `.dockerignore` to create backstage folder

Using the multistage docker build for backstage, so any modification is
properly cached and the final image is smaller.

We are using PGSQL for testing as well. We're not going to dwell too much on
how to handle properly secrets in this project, we're simply going to define
them in an `.env` file.

`
export POSTGRES_DB=db
export POSTGRES_USER=postgres
export POSTGRES_PASSWORD=postgres
export POSTGRES_DB=backstage
`

