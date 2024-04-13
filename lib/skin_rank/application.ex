defmodule SkinRank.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      SkinRankWeb.Telemetry,
      # Start the Ecto repository
      SkinRank.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: SkinRank.PubSub},
      # Start Finch
      {Finch, name: SkinRank.Finch},
      # Start the Endpoint (http/https)
      SkinRankWeb.Endpoint
      # Start a worker by calling: SkinRank.Worker.start_link(arg)
      # {SkinRank.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SkinRank.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    SkinRankWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
