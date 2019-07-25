class Board

  attr_reader :cases, :nb_coups_joues, :aborted
  def initialize
    # Ici on initialise un plateau
    # On crée les boardcases
    a1=BoardCase.new(1) 
    a2=BoardCase.new(2)
    a3=BoardCase.new(3) 
    b1=BoardCase.new(4) 
    b2=BoardCase.new(5) 
    b3=BoardCase.new(6) 
    c1=BoardCase.new(7) 
    c2=BoardCase.new(8) 
    c3=BoardCase.new(9)  
    @cases = [a1, a2, a3, b1, b2, b3, c1, c2, c3] # On stocke les boardcases
    @nb_coups_joues = 0
    @aborted = false
  end

  def change_value_case(bcase, value) # On applique le changement à la case
    begin
      @cases[bcase].change_content(value)
      add_coup
    rescue
      ending_play # Si on joue quitter
    end
  end

  def ending_play
    @aborted = true
  end

  def add_coup
    @nb_coups_joues += 1
  end

  def verif_alignement_points # On vérifie si le joueur gagne
    if verif_lines or verif_columns or verif_diagos
      true
    else
      false
    end
  end

  def verif_lines # On vérifie chaque ligne
    # verif lignes
    if @cases[0].content != " " and [@cases[0].content, @cases[1].content, @cases[2].content] == [@cases[0].content, @cases[0].content, @cases[0].content]
      colorize_win(@cases[0], @cases[1], @cases[2]) # Si c'est bon on color en vert les cases
      return true
    elsif @cases[3].content != " " and [@cases[3].content, @cases[4].content, @cases[5].content] == [@cases[3].content, @cases[3].content, @cases[3].content]
      colorize_win(@cases[3], @cases[4], @cases[5])
      return true
    elsif @cases[6].content != " " and [@cases[6].content, @cases[7].content, @cases[8].content] == [@cases[6].content, @cases[6].content, @cases[6].content]
      colorize_win(@cases[6], @cases[7], @cases[8])
      return true
    else
      return false 
    end
  end

  def verif_columns
    if @cases[0].content != " " and [@cases[0].content, @cases[3].content, @cases[6].content] == [@cases[0].content, @cases[0].content, @cases[0].content]
      colorize_win(@cases[0], @cases[3], @cases[6])
      return true
    elsif @cases[1].content != " " and [@cases[1].content, @cases[4].content, @cases[7].content] == [@cases[1].content, @cases[1].content, @cases[1].content]
      colorize_win(@cases[1], @cases[4], @cases[7])
      return true
    elsif @cases[2].content != " " and [@cases[2].content, @cases[5].content, @cases[8].content] == [@cases[2].content, @cases[2].content, @cases[2].content]
      colorize_win(@cases[2], @cases[5], @cases[8])
      return true
    else
      return false 
    end

  end

  def verif_diagos
    if @cases[0].content != " " and [@cases[0].content, @cases[4].content, @cases[8].content] == [@cases[0].content, @cases[0].content, @cases[0].content]
      colorize_win(@cases[0], @cases[4], @cases[8])
      return true
    elsif @cases[2].content != " " and [@cases[2].content, @cases[4].content, @cases[6].content] == [@cases[2].content, @cases[2].content, @cases[2].content]
      colorize_win(@cases[2], @cases[4], @cases[6])
      return true
    else
      return false 
    end
  end

  def colorize_win(cells1, cells2, cells3) # Color les cases en vert
    cells1.change_color
    cells2.change_color
    cells3.change_color
  end
end
