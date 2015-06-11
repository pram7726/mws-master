require_relative '../../models/websocket_message'
require_relative '../../middlewares/websocket_backend'

module Websockets
  class SendRawMessage < Mutations::Command

    required do
      string :data
      hash :receivers do
        required do
          array :sockets, nils: true do
            string
          end
          array :tags, nils: true do
            string
          end
        end
      end
    end

    def execute
      message = WebsocketMessage.new(data: self.data, receivers: self.receivers)
      publish_message(message)
      message
    end

    private

    ##
    # @param [WebsocketMessage] message
    def publish_message(message)
      message = {
          data: message.data,
          receivers: message.receivers
      }
      $redis.publish(WebsocketBackend::CHANNEL, JSON.dump(message))

      message
    end
  end
end