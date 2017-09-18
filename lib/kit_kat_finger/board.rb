module KitKatFinger
     class InvalidMoveError < StandardError; end

    class Board
        CORNERS = [:A1, :A3, :C1, :C3]
        CENTER = :B2
        SIDES = [:B1, :C2, :B3, :A2]

        attr_reader :moves

        def initialize
            @moves = Hash[["A", "B", "C"].product([1, 2, 3]).map do |pair| 
                [pair.join.to_sym, nil]
            end]
        end

        def move(key, name)
            raise InvalidMoveError, "Space taken" if @moves[key]
            @moves[key] = name.upcase
        end

        def draw
            KitKatFinger.cli.say %Q{
                      A   B   C
    
                    +---+---+---+
                1   | #{%w(A1 B1 C1).map { |k| print_space(k.to_sym)}.join(" | ")} |
                    +---+---+---+
                2   | #{%w(A2 B2 C2).map { |k| print_space(k.to_sym)}.join(" | ")} |
                    +---+---+---+
                3   | #{%w(A3 B3 C3).map { |k| print_space(k.to_sym)}.join(" | ")} |
                    +---+---+---+
            }
        end

        def winning_move(for: player_name)
            player_spaces = @moves.select { |_, name| name == player_name  }.keys
            
            columns = %w(A B C).map do |column| 
                @moves.keys.select { |k| k.start_with? column }
            end
            rows = %w(1 2 3).map do |row|
                @moves.keys.select { |k| k.end_with? row }
            end
            diagonals = [%w(A1 B2 C3), %w(A3 B3 C1)]

            [columns, rows, diagonals].flatten.each do |set|
                set_remaining = set - player_spaces
                if set_remaining.count == 1 && @moves[set_remaining.first].blank?
                    return set_remaining.first
                end
            end
            nil
        end

        private

        def print_space(key)
            @moves[key] || " "
        end
    end
end