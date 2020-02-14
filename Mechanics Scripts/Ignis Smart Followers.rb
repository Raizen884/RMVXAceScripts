#=======================================================
#         Ignis Smart Followers
# Autor: Raizen
# Compativel com: RMVXAce
# Comunidade: http://www.centrorpg.com
# O script modifica o modo que os seguidores reagem a movimentos do usuário,
# desse modo eles evitam se mover se não houver necessidade, além de que
# eles evitam colidirem com obstáculos.
#========================================================



#=================================================================#
#====================  Alias methods =============================#
# move_straight          => Game_CharacterBase
# move_diagonal          => Game_CharacterBase
# initialize             => Game_CharacterBase
# initialize             => Game_Follower
#=================================================================#
#====================  Rewrite methods ===========================#
# move_straight             => Game_Player
# move_diagonal             => Game_Player
# chase_preceding_character => Game_Follower
# move                      => Game_Followers
#=================================================================#
#=================================================================#

#==============================================================================
#============================  Início do Script!  =============================
#==============================================================================
#==============================================================================

#==============================================================================
# ** Game_Player
#------------------------------------------------------------------------------
#  Esta classe gerencia o jogador. 
# A instância desta classe é referenciada por $game_player.
#==============================================================================

class Game_Player < Game_Character
  #--------------------------------------------------------------------------
  # * Movimento em linha reta em
  #     d       : direção （2,4,6,8）
  #     turn_ok : permissão para mudar de direção
  #--------------------------------------------------------------------------
  def move_straight(d, turn_ok = true)
    super
    @followers.move
  end
  #--------------------------------------------------------------------------
  # * Movimento na diagonal
  #     horz : direção horizontal （4 or 6）
  #     vert : direção vertical   (2 or 8）
  #--------------------------------------------------------------------------
  def move_diagonal(horz, vert)
    super
    @followers.move
  end
end

#==============================================================================
# ** Game_Follower
#------------------------------------------------------------------------------
#  Esta classe gerencia os seguidres. Seguidores são personagens do grupo
# que seguem o primeiro em uma fila. Ela é utilizada internamente pelas
# classe Game_Followers
#==============================================================================

class Game_Follower < Game_Character
    attr_accessor :preceding_character
alias :ignis_initialize :initialize
  #--------------------------------------------------------------------------
  # * Inicialização do objeto
  #     member_index       : índice do personagem
  #     preceding_characte : informação do personagem anterior
  #--------------------------------------------------------------------------
  def initialize(member_index, preceding_character)
    ignis_initialize(member_index, preceding_character)
    @through = false
  end
  #--------------------------------------------------------------------------
  # * Seguir personagem anterior
  #--------------------------------------------------------------------------
  def chase_preceding_character
    unless moving?
      sx = distance_x_from(@preceding_character.x)
      sy = distance_y_from(@preceding_character.y)
      @previous_position = [@x, @y]
      if ((sx.abs > 1 && sy.abs >= 1) || (sx.abs >= 1 && sy.abs > 1)) && @preceding_character.isMovingStraight && diagonal_passable?(@x, @y, sx > 0 ? 4 : 6, sy > 0 ? 8 : 2)
        move_diagonal(sx > 0 ? 4 : 6, sy > 0 ? 8 : 2)
      elsif (sx.abs > 1 && sy.abs > 1)
        sx = distance_x_from(@preceding_character.previous_position[0])
        sy = distance_y_from(@preceding_character.previous_position[1])
        move_diagonal(sx > 0 ? 4 : 6, sy > 0 ? 8 : 2)
      elsif sx.abs > 1 && passable?(@x, @y, sx > 0 ? 4 : 6)  
        move_straight(sx > 0 ? 4 : 6)
      elsif sy.abs > 1 && passable?(@x, @y, sy > 0 ? 8 : 2)
        move_straight(sy > 0 ? 8 : 2)
      elsif (sx.abs > 1 || sy.abs > 1)
        sx = distance_x_from(@preceding_character.previous_position[0])
        sy = distance_y_from(@preceding_character.previous_position[1])
        move_diagonal(sx > 0 ? 4 : 6, sy > 0 ? 8 : 2)
      end
    end
  end
end

#==============================================================================
# ** Game_Followers
#------------------------------------------------------------------------------
#  Esta classe gerencia a lista de seguidores.
# Esta classe é usada internamente pela classe Game_Player.
#==============================================================================

class Game_Followers
  #--------------------------------------------------------------------------
  # * Movimento
  #--------------------------------------------------------------------------
  def move
    each {|follower| follower.chase_preceding_character}
  end
end

  #==============================================================================
# ** Game_CharacterBase
#------------------------------------------------------------------------------
#  Esta classe gerencia os personagens. Comum a todos os persongens, armazena
# informações básicas como coordenadas e gráficos
# Esta classe é usada como superclasse da classe Game_Character.
#==============================================================================

class Game_CharacterBase
attr_accessor :isMovingStraight
attr_accessor :previous_position
alias :ignis_move_straight :move_straight
alias :ignis_move_diagonal :move_diagonal
alias :ignis_initialize_CharacterBase :initialize
  #--------------------------------------------------------------------------
  # * Inicialização do objeto
  #--------------------------------------------------------------------------
  def initialize
    @isMovingStraight = true
    ignis_initialize_CharacterBase
    @previous_position = [0, 0]
  end
  #--------------------------------------------------------------------------
  # * Movimento em linha reta em
  #     d       : direção （2,4,6,8）
  #     turn_ok : permissão para mudar de direção
  #--------------------------------------------------------------------------
  def move_straight(d, turn_ok = true)
    @isMovingStraight = true
    ignis_move_straight(d, turn_ok = true)
  end
    #--------------------------------------------------------------------------
  # * Movimento na diagonal
  #     horz : direção horizontal （4 or 6）
  #     vert : direção vertical   (2 or 8）
  #--------------------------------------------------------------------------
  def move_diagonal(horz, vert)
    @isMovingStraight = false
    ignis_move_diagonal(horz, vert)
  end
end

