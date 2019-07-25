class Application

  attr_reader :game, :all_players, :joueur1, :joueur2
  def initialize
    @prompt = TTY::Prompt.new # Permet d'utiliser la gem tty-prompt
    @replay = true 
    @retour_menu = true
    welcome
    choice_load
    @all_players = []
  end

  def welcome # Fonction qui se lance au début de l'application
    system "clear"
    t = Time.now
    puts ("#"*50).colorize(:blue)
    puts ("#" + "MORPION QUI DECHIRE".center(48) + "#").colorize(:blue)
    puts ("#" + " "*48 + "#").colorize(:blue)
    puts ("#" + "VERSION FINALE".center(48) + "#").colorize(:blue)
    puts ("#" + " "*48 + "#").colorize(:blue)
    puts ("#" + "#{t.httpdate}".center(48) + "#").colorize(:blue)
    puts ("#"*50).colorize(:blue)
    puts ""
    puts "Bienvenue dans ce jeu de morpion designé par votre serviteur Carsano".fit(50)
    puts "Que dit Wikipédia ? : "
    puts "Le morpion est un jeu de réflexion se pratiquant à deux joueurs au tour par tour et dont le but est de créer le premier un alignement sur une grille (3x3)".fit(50)
    @prompt.keypress("Appuie sur une touche pour continuer")
  end

  def choice_load # On demande à l'utilisateur si il veut charger une sauvegarde, sinon on lance la methode ask_name
    @prompt.select("Voulez-vous charger votre dernière partie sauvegardée?", %w(Oui Non), cycle: true) == "Oui" ? load_saving : ask_name
  end

  def saving_players # Permet de sauvegarder les stats des players
    system "clear"
    if File.exist?("db/saves.json") # si le fichier existe on l'ouvre
      json_file = File.open("db/saves.json","w")
    else # sinon on le créé
      json_file = File.new("db/saves.json","w")
    end
    @all_players.each do |player| # pour chaque player, on enregistre ses données dans une nouvelle ligne du fichier de sauvegarde
      json_file.puts player.to_json
    end
    json_file.close # On ferme le fichier
    puts "Stats sauvegardées"
  end

  def load_saving # permet de charger une sauvegarde
    if File.exist?("db/saves.json") # Vérifier si le fichier existe
      @all_players = []
      json_file = File.open("db/saves.json","r") # On lis le fichier de sauvegarde
      i = 0
      json_file.readlines.each do |line|
        @all_players[i] = line # On ajoute chaque ligne dans un array
        i += 1
      end
      @joueur1 = @all_players[0] # On récupère les données pour chaque joueurs
      @joueur2 = @all_players[1]
      json_file.close
      recover_players # On appelle la methode qui va permettre de créer des nouveaux joueurs avec les stats récupérées
    else # Sinon on continue normalement en lancant la methode ask_name
      puts "Aucune sauvegarde n'existe"
      ask_name
    end
  end

  def delete_load # Permet de supprimer le fichier de sauvegarde
    system "clear"
    if File.exist?("db/saves.json")
      File.delete("db/saves.json")
      puts "Sauvegarde supprimée"
    else
      puts "Aucune sauvegarde à supprimer"
    end
  end

  def recover_players # Permet de créer des nouveaux joueurs avec les stats enregistrés
    @joueur1 = JSON.parse(@joueur1)
    @joueur2 = JSON.parse(@joueur2)
    @joueur1 = Player.new(@joueur1.values[0], "x".colorize(:blue), @joueur1.values[1], @joueur1.values[2], @joueur1.values[3], @joueur1[4])
    @joueur2 = Player.new(@joueur2.values[0], "o".colorize(:yellow), @joueur2.values[1], @joueur2.values[2], @joueur2.values[3], @joueur2[4])
    @last_loser = [@joueur1, @joueur2].sample
    system "clear"
  end

  def ask_name # Initialise de nouveaux joueurs
    puts '-'*50
    print "Veuillez rentrer le nom du joueur1\n> "
    name1 = gets.chomp.colorize(:blue)
    @joueur1 = Player.new(name1,"x".colorize(:blue))
    print "Veuillez rentrer le nom du joueur2\n> "
    name2 = gets.chomp.colorize(:yellow)
    @joueur2 = Player.new(name2, "o".colorize(:yellow))
    @last_loser = [@joueur1, @joueur2].sample
  end

  def play_app
    # On joue à l'infini tant que le replay est ok
    @replay = true
    while @replay
      @retour_menu = true # Pour revenir au menu après chaque tour
      system "clear"
      play_game # Appelle la méthode play_game
      while @retour_menu # Tant que le retour au menu est vrai on affiche le menu
        menu
      end
    end
    system "clear"
    puts "Ciao !"
  end

  def play_game
    # Ici on joue une partie entière
    @game = Game.new(@joueur1, @joueur2, @last_loser)
    @all_players = [@game.j1, @game.j2] 
    end_game = @game.verify_endgame
    show_table
    until end_game # Tant que end_game est false
      system "clear"
      show_table # Affiche le tableau
      @game.place_value # Appelle la fonction de placement
      end_game = @game.verify_endgame  # Vérifie si le joueur gagne ou match nul
    end
    system "clear" # On efface le terminal
    show_table # On remet à jour le tableau avec les valeurs de fin
    end_of_the_game # On appelle la fonction de fin de jeu
  end

  def show_table # Affiche le tableau de jeu
    show = Show.new(@game)
    puts show.show_board
  end

  def end_of_the_game
    if @game.board.aborted == true # Dans le cas où l'on a quitté la partie en cours de jeu
      system 'clear'
      puts "Ciao !"
      exit # On sort
    elsif @game.board.nb_coups_joues == 9 # Sinon cas où match nul
      puts "Match nul"
      @game.j1.even # On ajoute une stat à chaque joueur
      @game.j2.even
      @last_loser = [@game.j1, @game.j2].sample
    else
      @last_loser = @game.active_player # On initialize un last loser
      @game.active_player.lose # On ajoute les stats
      @game.change_active_player
      @game.active_player.win
      puts "   ".colorize(:yellow) + " #{@game.active_player.name} remporte la partie !"+ "     ".colorize(:yellow) # On affiche le gagnant avec des bonnes grosses flammes de beaufs
    end

  end

  def shows_statistics # Permet de montrer les statistiques
    show = Show.new(@game)
    puts show.show_stats_players
  end

  def menu # Affiche le menu 
    choice = @prompt.select('MENU', ["Voir les stats", "Rejouer", "Sauvegarder les stats", "Supprimer la sauvegarde", "Quitter"], cycle: true)
    case choice
    when "Voir les stats" # Soit voir les stats
      system "clear"
      shows_statistics
      @prompt.keypress("Appuie sur une touche pour continuer")
      system "clear"
      @retour_menu = true # On retourne au menu
    when "Quitter" # Quitter le jeu
      @replay = false
      @retour_menu = false
    when "Sauvegarder les stats" # Sauvegarder les stats
      saving_players
      @retour_menu = true # Retour au menu
    when "Supprimer la sauvegarde" # Supprimer la sauvegarde
      delete_load
      @retour_menu = true # Retour au menu
    else # Rejoue
      @retour_menu = false
    end
  end
end
