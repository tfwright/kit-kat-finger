require File.expand_path("../../helper", __FILE__)

class TestBoard < MiniTest::Test
    def test_draw
        KitKatFinger::Board.new.draw
    end
  
    def test_move
        KitKatFinger::Board.new.move(:B2, "x")
    end
end