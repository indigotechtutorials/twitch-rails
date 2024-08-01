class LiveStreamChannel < ApplicationCable::Channel
  def subscribed
    puts "Hello from the channel in ruby"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def receive(data)
    puts "Recieved data #{data}"
    #ActionCable.server.broadcast("chat_#{params[:room]}", data)
  end
end
