module KitKatFinger
     class InvalidMoveError < StandardError; end

    class Board
        attr_reader :spaces

        def initialize
            @spaces = Hash[["A", "B", "C"].product([1, 2, 3]).map do |pair| 
                [pair.join, nil]
            end]
        end

        def move(key, name)
            raise InvalidMoveError, "Space taken" if @spaces[key]
            @spaces[key] = name.upcase
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
            player_spaces = @spaces.select { |_, name| name == player_name  }.keys
            
            (1..3).times do |n|
                row_remaining = ["A#{n}", "B#{n}", "C#{n}"] - player_spaces.select { |k| k.to_s.includes?(n) }
                return row_remaining.first if row_remaining.size == 1
            end
        end

        private

        def print_space(key)
            @spaces[key] || " "
        end
    end
end