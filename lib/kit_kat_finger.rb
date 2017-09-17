require 'highline'
require File.expand_path("../kit_kat_finger/game", __FILE__)
require File.expand_path("../kit_kat_finger/board", __FILE__)

module KitKatFinger

    class << self
        def play
            KitKatFinger::Game.new
        end

        def cli
            @cli ||= HighLine.new
        end
    end
    
end