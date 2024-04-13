defmodule SkinRankWeb.LandingLive do
  use SkinRankWeb, :live_view
  alias SkinRank.Characters

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:characters, Characters.all())

    {:ok, socket}
  end
end
