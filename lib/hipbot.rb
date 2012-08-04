require 'active_support/all'
require 'eventmachine'
require 'em-http-request'
require 'xmpp4r'
require 'xmpp4r/muc'

require 'hipbot/patches/mucclient'
require 'hipbot/patches/encoding'

require 'hipbot/adapters/hipchat/hipchat'
require 'hipbot/adapters/hipchat/connection'
require 'hipbot/adapters/telnet/telnet'
require 'hipbot/adapters/telnet/connection'
require 'hipbot/bot'
require 'hipbot/configuration'
require 'hipbot/message'
require 'hipbot/reaction'
require 'hipbot/response'
require 'hipbot/http_response'
require 'hipbot/room'
require 'hipbot/version'
