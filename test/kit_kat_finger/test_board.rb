require File.expand_path("../../helper", __FILE__)

class TestBoard < MiniTest::Test
    def setup
        @highline_mock = MiniTest::Mock.new

        @board = KitKatFinger::Board.new
    end
    
    def test_move_records_move
        @board.move(:C2, :X)
        assert_equal :X, @board.moves[:C2]
    end

    def test_draw_displays_recorded_move
        @board.move(:C2, :X)
        HighLine.stub :new, @highline_mock do
            @highline_mock.expect :say, true, [String]
            @board.draw
        end
    end

    def test_winning_move_returns_nil_when_no_win_is_possible
        assert_nil @board.winning_move(for_player: :X)
    end

    def test_winning_move_returns_last_open_space_in_set
        @board.move(:C1, :X)
        @board.move(:C2, :X)

        assert_equal :C3, @board.winning_move(for_player: :X)
    end

    def test_winning_player_returns_name_of_player_with_full_set
        @board.move(:C1, :X)
        @board.move(:C2, :X)
        @board.move(:C3, :X)


        assert_equal :X, @board.winning_player_name
    end

    def test_winning_player_name_is_nil_with_no_moves
        assert_nil @board.winning_player_name
    end

    def test_open_spaces_doesnt_include_moves
        @board.move(:C2, :X)
        refute_includes @board.open_spaces, :C2
    end

    def test_taken_spaces_includes_moves
        @board.move(:C2, :X)
        assert_includes @board.taken_spaces, :C2
    end
end