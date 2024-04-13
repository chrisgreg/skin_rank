defmodule SkinRankWeb.LandingLive do
  use SkinRankWeb, :live_view
  alias SkinRank.{Characters, Skins}

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:characters, Characters.all())

    {:ok, socket}
  end

  def handle_event("vote", %{"skin-id" => skin_id}, socket) do
    Skins.new_vote(skin_id)
    {:noreply, socket}
  end
end
