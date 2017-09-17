module KitKatFinger

    class Game
        def initialize
            set_turn

            @board = Board.new
            while playing? do
                if @turn == :player
                    @board.draw
                    @board.move(get_move, @player_name)
                else
                    @board.move(choose_move, computer_name)
                end

                next_turn!
            end

            report_result
        end

        private

        def choose_move
            @board.winning_move(for: computer_name) ||
                @board.blocking_move(against: @player_name) ||
                @board.any_corner_move ||
                @board.center_move ||
                @board.side_move
        end

        def computer_name
            @player_name == "x" ? "o" : "x"
        end

        def get_move
            KitKatFinger.cli.choose(@board.spaces.select{ |_, v| v.blank? } ) do |menu|
                menu.prompt = "Where do you want to move?"
            end
        end

        def set_turn
            KitKatFinger.cli.choose(:x, :o) do |menu|
                menu.prompt = "Which player do you want to be? X or O?"
                menu.choices(:x) { @turn = :player }
                menu.choices(:o) { @turn = :computer }
                menu.default = :x
            end
        end

        def playing?
            !(@board.has_winner? || @board.full?)
        end

        def next_turn!
            @turn = (@turn == :player ? :computer : :player)
        end
    end
    
end