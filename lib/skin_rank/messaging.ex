defmodule SkinRank.Messaging do
  def subscribe(topic) do
    Phoenix.PubSub.subscribe(SkinRank.PubSub, topic)
  end

  def notify_subscrbers({:ok, vote}, topic, event) do
    Phoenix.PubSub.broadcast(SkinRank.PubSub, topic, {__MODULE__, event, vote})
  end

  def notify_subscribers({:error, _reason} = error, _topic, _event), do: error
end
