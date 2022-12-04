class Player
  @@tictac = Array.new(3){Array.new(3)}
  @@positions = {A: [0, 0], B: [0, 1], C: [0, 2], D: [1, 0], E: [1, 1], F: [1, 2], G: [2, 0], H: [2, 1], I: [2, 2]}
  
  def initialize(name, symbol)
    @name = name
    @player = {name => symbol}
  end

  def choose_move
    while (true)
      puts "#{@name}, enter your move (A to I):"
      move = gets.chomp
      break if self.position_valid?(move)
    end
  end
  
  def position_valid?(letter)
    unless ("A".."I").include?(letter.to_s.upcase)
      puts "Letter outside A-I range" 
      return false
    end

    unless @@tictac[@@positions[letter.upcase.to_sym][0]][@@positions[letter.upcase.to_sym][1]] == nil
      puts "Space already chosen"
      return false
    end
    update_table(@@positions[letter.upcase.to_sym][0], @@positions[letter.upcase.to_sym][1])
  end

  def update_table(row, column) 
    @@tictac[row][column] = @player[@name]
    true
  end

  def self.check_winner()
    @@tictac.flatten.each_index { |i|
      if i % 3 == 0
        return @@tictac.flatten[i] if @@tictac.flatten[i] == @@tictac.flatten[i + 1] && @@tictac.flatten[i] == @@tictac.flatten[i + 2] && @@tictac.flatten[i] != nil
      end

      if i < 3
        return @@tictac.flatten[i] if @@tictac.flatten[i] == @@tictac.flatten[i + 3] && @@tictac.flatten[i] == @@tictac.flatten[i + 6] && @@tictac.flatten[i] != nil
      end
    }
    
    return @@tictac[0][0] if @@tictac[0][0] == @@tictac[1][1] && @@tictac[0][0] == @@tictac[2][2] && @@tictac[0][0] != nil
    return @@tictac[2][0] if @@tictac[2][0] == @@tictac[1][1] && @@tictac[2][0] == @@tictac[0][2] && @@tictac[2][0] != nil

    @@tictac.each_with_index { |value, index|
      value.each_index { |j| return true if (@@tictac[index][j] == nil) }
    }
    
    Player.print_table

    puts "\n\nIt's a Draw.\n\n\n"
  end

  def self.print_table
    3.times { |i|
      puts "     |     |"
      3.times { |j|
        if (@@tictac[i][j] == nil)
          print "  #{@@positions.key([i, j])}  "
        else
          print "  #{@@tictac[i][j]}  "
        end

        print "|" unless j == 2
        puts "" if j == 2
      }

      if i == 2
        puts "     |     |"
      else
        puts "_____|_____|_____"
      end
    }
  end

  def self.reset
    @@tictac = Array.new(3){Array.new(3)}
  end
end

puts "Enter Player 1 Name: "
name_1 = gets.chomp

puts "Enter Symbol for Player 1: "

while (true)
  symbol_1 = gets.chomp
  break if symbol_1.length == 1
  puts "Symbol must be ONE character, try again: "
end

p1 = Player.new(name_1, symbol_1)

puts "Enter Player 2 Name: "
name_2 = gets.chomp

puts "Enter Symbol for Player 2: "

while (true)
  symbol_2 = gets.chomp
  break if symbol_2.length == 1 && symbol_2 != symbol_1
  puts "Symbol must be ONE character AND different from P1, try again: "
end

puts "\n"

p2 = Player.new(name_2, symbol_2)

game_ongoing = true

i = 0

while (true)
  while (game_ongoing)
    move = nil
    Player.print_table
    puts "\n"
    if i % 2 == 0
      move = p1.choose_move
    else
      move = p2.choose_move
    end
    game_ongoing = Player.check_winner
    if game_ongoing == symbol_1
      Player.print_table
      puts "\n\n#{name_1} wins!\n\n\n"
      game_ongoing = false
    elsif game_ongoing == symbol_2
      Player.print_table
      puts "\n\n#{name_2} wins!\n\n\n"
      game_ongoing = false
    end

    i += 1
  end
  puts "Do you want to play again? (y/n)"
  answer = gets.chomp.upcase
  if answer == "N"
    puts "\n\nGame ended."
    break
  else
    Player.reset
    game_ongoing = true
  end
end