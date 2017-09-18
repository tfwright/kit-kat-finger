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
            @board.draw
        end

    private

        def choose_move
            @board.winning_move(for_player: computer_name) ||
                @board.winning_move(for_player: @player_name) ||
                (Board::CORNERS - @board.taken_spaces).sample ||
                ([Board::CENTER] - @board.taken_spaces) ||
                (Board::SIDES - @board.taken_spaces).sample
        end

        def computer_name
            @player_name == :X ? :O : :X
        end

        def get_move
            KitKatFinger.cli.choose(*@board.open_spaces.map { |m| m.to_s }.sort) do |menu|
                menu.prompt = "Where do you want to move?"
            end
        end

        def set_turn
            @player_name = KitKatFinger.cli.choose do |menu|
                menu.prompt = "Which player do you want to be? X or O?"
                menu.choices(:X) { @turn = :player; :X }
                menu.choices(:O) { @turn = :computer; :O }
            end
        end

        def playing?
            !(@board.winning_player_name || @board.open_spaces.none?)
        end

        def next_turn!
            @turn = (@turn == :player ? :computer : :player)
        end

        def report_result
            KitKatFinger.cli.say "#{@board.winning_player_name || "Nobody"} has won!"
        end
    end
end