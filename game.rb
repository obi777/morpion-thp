class Game

  attr_reader :board, :active_player, :j1, :j2
  def initialize(j1,j2, active_player=j1)
    # initialize une nouvelle partie
    @board = Board.new # On crée un nouveau board
    @cases_availables = ["A1", "A2", "A3", "B1", "B2", "B3", "C1", "C2", "C3", "QUITTER LA PARTIE"] # Les cases de choix de jeu
    @prompt = TTY::Prompt.new
    @j1 = j1
    @j2 = j2
    @active_player = active_player
  end

  def verify_endgame
    # On va vérifier si 3 pions sont alignés ou si le jeu est complet, ou si le jeu est quitté en cours
    if @board.verif_alignement_points or @board.nb_coups_joues == 9 or @board.aborted 
      true
    else
      false
    end
  end

  def place_value # On place la value
    choice = @prompt.select("#{@active_player.name} (#{@active_player.symbol}), à vous de jouer : ", @cases_availables, cycle: true) # On choisit parmi la liste des choix disponibles
    @cases_availables.delete(choice) # On supprime de la liste le choix de l'utilisateur
    @board.change_value_case(transform_choice(choice), @active_player.symbol) # On applique au boardcase correspondant la bonne valeur
    change_active_player # On change de joueur
  end

  def transform_choice(choice)
    case choice
    when "A1" then return 0
    when "A2" then return 1
    when "A3" then return 2
    when "B1" then return 3
    when "B2" then return 4
    when "B3" then return 5
    when "C1" then return 6
    when "C2" then return 7
    when "C3" then return 8
    else
      @board.ending_play 
    end
  end

  def change_active_player # Changement de joueur
    if @active_player == @j1
      @active_player = @j2
    else
      @active_player = @j1
    end
  end
end
