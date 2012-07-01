require 'spec_helper'

describe Hipbot::Bot do
  context "#on" do
    let(:sender) { stub_everything }
    let(:room) { stub_everything }

    it "should reply to no arguments" do
      subject.on /^hello there$/ do
        reply('hi!')
      end
      subject.expects(:reply).with(room, 'hi!')
      subject.tell(sender, room, '@robot hello there')
    end

    it "should reply with one argument" do
      subject.on /^you are (.*), robot$/ do |adj|
        reply("i know i'm #{adj}!")
      end
      subject.expects(:reply).with(room, "i know i'm cool!")
      subject.tell(sender, room, '@robot you are cool, robot')
    end

    it "should reply with multiple arguments" do
      subject.on /^send "(.*)" to (.*@.*)$/ do |message, recipient|
        reply("sent \"#{message}\" to #{recipient}")
      end
      subject.expects(:reply).with(room, 'sent "hello!" to robot@robots.org')
      subject.tell(sender, room, '@robot send "hello!" to robot@robots.org')
    end

    it "should say when does not understand" do
      subject.on /^hello there$/ do
        reply('hi!')
      end
      subject.expects(:reply).with(room, 'I don\'t understand "hello robot!"')
      subject.tell(sender, room, '@robot hello robot!')
    end

    it "should choose first option when multiple options match" do
      subject.on /hello there/ do reply('hello there') end
      subject.on /hello (.*)/ do reply('hello') end
      subject.expects(:reply).with(room, 'hello there')
      subject.tell(sender, room, '@robot hello there')
    end

    context "global messages" do
      it "should reply if callback is global" do
        subject.on /^you are (.*)$/, global: true do |adj|
          reply("i know i'm #{adj}!")
        end
        subject.expects(:reply).with(room, "i know i'm cool!")
        subject.tell(sender, room, 'you are cool')
      end

      it "should not reply if callback not global" do
        subject.on /^you are (.*)$/ do |adj|
          reply("i know i'm #{adj}!")
        end
        subject.expects(:reply).never
        subject.tell(sender, room, 'you are cool')
      end
    end

    context "messages from particular sender" do
      it "should reply" do
        subject.on /wazzup\?/, from: sender do
          reply('Wazzup, Tom?')
        end
        subject.expects(:reply).with(room, 'Wazzup, Tom?')
        subject.tell(sender, room, '@robot wazzup?')
      end
      it "should reply if sender acceptable" do
        subject.on /wazzup\?/, from: [stub, sender] do
          reply('wazzup, tom?')
        end
        subject.expects(:reply).with(room, 'wazzup, tom?')
        subject.tell(sender, room, '@robot wazzup?')
      end
      it "should not reply if sender unacceptable" do
        subject.on /wazzup\?/, from: sender do
          reply('wazzup, tom?')
        end
        subject.expects(:reply).with(room, "I don't understand \"wazzup?\"")
        subject.tell(stub, room, '@robot wazzup?')
      end
      it "should not reply if sender does not match" do
        subject.on /wazzup\?/, from: [sender] do
          reply('wazzup, tom?')
        end
        subject.expects(:reply).with(room, "I don't understand \"wazzup?\"")
        subject.tell(stub, room, '@robot wazzup?')
      end
    end

    context "default variables" do
      it "message" do
        subject.on /.*/ do
          reply("you said: #{message}")
        end
        subject.expects(:reply).with(room, "you said: hello")
        subject.tell(stub, room, "@robot hello")
      end

      it "sender" do
        subject.on /.*/ do
          reply("you are: #{sender}")
        end
        subject.expects(:reply).with(room, "you are: tom")
        subject.tell('tom', room, "@robot hello")
      end

      it "recipients" do
        subject.on /.*/ do
          reply("recipients: #{recipients.join(', ')}")
        end
        subject.expects(:reply).with(room, "recipients: robot, dave")
        subject.tell('tom', room, "@robot tell @dave hello from me")
      end
    end
  end

  describe "configurable options" do
    Hipbot::Bot::CONFIGURABLE_OPTIONS.each do |option|
      it "should delegate #{option} to configuration" do
        value = stub
        subject.configuration.expects(option).returns(value)
        subject.send(option)
      end
    end
  end
end
