defmodule SkinRank.Repo do
  use Ecto.Repo,
    otp_app: :skin_rank,
    adapter: Ecto.Adapters.Postgres
end
