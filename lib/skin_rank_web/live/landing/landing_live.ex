defmodule SkinRankWeb.LandingLive do
  use SkinRankWeb, :live_view
  alias SkinRank.{Characters, Messaging, Skins}

  def mount(_params, _session, socket) do
    if connected?(socket), do: Messaging.subscribe("votes")

    socket =
      socket
      |> assign(:characters, Characters.all())

    {:ok, socket}
  end

  def handle_event("vote", %{"skin-id" => skin_id}, socket) do
    Skins.new_vote(skin_id)

    socket =
      socket
      |> assign(:characters, Characters.all())

    {:noreply, socket}
  end

  def handle_info({SkinRank.Messaging, {:new_vote, skin_id}, _}, socket) do
    socket =
      socket
      |> assign(:characters, Characters.all())

    {:noreply, socket}
  end
end
