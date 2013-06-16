module Hipbot
  class Message < Struct.new(:raw_body, :room, :sender)
    attr_accessor :body, :recipients

    def initialize *args
      super
      Hipbot.logger.info("MESSAGE from #{sender} in #{room}")
      self.body       = strip_recipient(raw_body)
      self.recipients = raw_body.scan(/@(\p{L}++)/).flatten.compact.uniq
    end

    def for? recipient
      recipients.include? recipient.mention
    end

    def strip_recipient body
      body.gsub(/^@\p{L}++[^\p{L}]*/, '').strip
    end

    def mentions
      recipients[1..-1] || [] # TODO: Fix global message case
    end

    def private?
      room.nil?
    end
  end
end
