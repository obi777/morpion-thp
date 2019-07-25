class Show
  def initialize(game)
    @game = game
  end

  def show_board
    rows_morp = [
      ["A".colorize(:light_red), @game.board.cases[0].content, @game.board.cases[1].content, @game.board.cases[2].content],
      ["B".colorize(:light_red), @game.board.cases[3].content, @game.board.cases[4].content, @game.board.cases[5].content],
      ["C".colorize(:light_red), @game.board.cases[6].content, @game.board.cases[7].content, @game.board.cases[8].content] 
    ]
    Terminal::Table.new :headings => ['','1'.colorize(:light_red),'2'.colorize(:light_red),'3'.colorize(:light_red)],:rows => rows_morp, :style => {:border_x => "-".colorize(:white),:border_y => "|".colorize(:white),:border_i => "+".colorize(:white), :all_separators => true}
  end

  def show_stats_players
    rows_stats = [
      ["Nb played","#{@game.j1.show_states.values[1]}", "#{@game.j2.show_states.values[1]}"],
      ["Wins","#{@game.j1.show_states.values[2]}", "#{@game.j2.show_states.values[2]}"],
      ["Loss","#{@game.j1.show_states.values[3]}", "#{@game.j2.show_states.values[3]}"],
      ["Even","#{@game.j1.show_states.values[4]}", "#{@game.j2.show_states.values[4]}"]
    ]
    Terminal::Table.new :title => "Stats", :headings => ['Parameters', "#{@game.j1.name}", "#{@game.j2.name}"], :rows => rows_stats, :style => {:alignment => :center, :width => 40}
  end
end

