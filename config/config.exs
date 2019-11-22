use Mix.Config

config :favro,
  username:     System.get_env("FAVRO_USERNAME"),
  password:     System.get_env("FAVRO_PASSWORD"),
  organization: System.get_env("FAVRO_ORGANIZATION")
