class EntriesChannel < ApplicationCable::Channel
  def subscribed
    #stream_from "entries_channel"
  end

  def unsubscribed
  end
end
