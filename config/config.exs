# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :pardall_markdown_phoenix_demo, PardallMarkdownWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "vlzywSsO+2L1dOf6SVsVn7VJPMJ/oyr10wH7jCLcNl++SAuXkPQ20t/qDSefGEgI",
  render_errors: [view: PardallMarkdownWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: PardallMarkdownWeb.PubSub,
  live_view: [signing_salt: "5fx/EcCU"]

config :pardall_markdown, PardallMarkdown.Content,
  # This can be any relative or absolute path, including outside of the application,
  # which is actually, the main use case for PardallMarkdown
  root_path: "./sample_content",
  static_assets_folder_name: "static",
  cache_name: :content_cache,
  index_cache_name: :content_index_cache,
  # Site name to be appened into page titles
  site_name: "Pardall Markdown",
  recheck_pending_file_events_interval: 10_000,
  content_tree_display_home: false,
  notify_content_reloaded: &PardallMarkdownWeb.pardall_markdown_notifier/0

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id, :mfa]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :esbuild,
  version: "0.12.18",
  default: [
    args: ~w(js/app.js --bundle --target=es2016 --outdir=../priv/static/assets),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
