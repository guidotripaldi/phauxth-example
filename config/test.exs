use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :forks_the_egg_sample, ForksTheEggSampleWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :forks_the_egg_sample, ForksTheEggSample.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "forks_the_egg_sample_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# Configures mailer for testing
config :forks_the_egg_sample, ForksTheEggSample.Mailer,
  adapter: Bamboo.TestAdapter
