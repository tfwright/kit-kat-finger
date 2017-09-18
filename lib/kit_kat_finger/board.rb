module KitKatFinger
     class InvalidMoveError < StandardError; end

    class Board
        CORNERS = [:A1, :A3, :C1, :C3]
        CENTER = :B2
        SIDES = [:B1, :C2, :B3, :A2]
        ALL_SPACES = [CORNERS, CENTER, SIDES].flatten
        COLUMNS = %w(A B C).map do |column| 
            ALL_SPACES.select { |s| s.to_s.start_with? column }
        end
        ROWS = %w(1 2 3).map do |row|
            ALL_SPACES.select { |s| s.to_s.end_with? row }.sort
        end
        DIAGONALS = [[:A1, :B2, :C3], [:A3, :B3, :C1]]

        attr_reader :moves

        def initialize
            @moves = Hash[ALL_SPACES.map { |space| [space, nil] }]
        end

        def move(space, name)
            raise InvalidMoveError, "Space taken" if @moves[space]
            @moves[space.to_sym] = name
        end

        def draw
            KitKatFinger.cli.say %Q{
                      A   B   C
    
                    +---+---+---+
                1   | #{ROWS[0].map { |s| print_space(s) }.join(" | ")} |
                    +---+---+---+
                2   | #{ROWS[1].map { |s| print_space(s)}.join(" | ")} |
                    +---+---+---+
                3   | #{ROWS[2].map { |s| print_space(s)}.join(" | ")} |
                    +---+---+---+

            }
        end

        def winning_move(for_player: name)
            (COLUMNS + ROWS + DIAGONALS).each do |set|
                set_remaining = set - player_spaces(for_player)
                if set_remaining.count == 1 && @moves[set_remaining.first].nil?
                    return set_remaining.first
                end
            end

            nil
        end

        def winning_player_name
            winning_set = (COLUMNS + ROWS + DIAGONALS).select do |set|
                @moves.values_at(*set).none? { |name| name.nil? } &&
                    @moves.values_at(*set).uniq.size == 1
            end.first
            if winning_set
                @moves[winning_set.first]
            end
        end

        def open_spaces
            @moves.select { |_, player_name| player_name.nil? }.keys
        end

        def taken_spaces
            @moves.reject { |_, player_name| player_name.nil? }.keys
        end

        private

        def player_spaces(player_name)
            @moves.select { |_, name| name == player_name  }.keys
        end
            
        def print_space(space)
            "#{space} => #{@moves[space]}" || " "
        end
    end
end