#=======================================================
#         Follower Control
# Autor : Raizen
# Comunidade: www.centrorpg.com
# Função do script: O script permite que seja controlado as
# ações dos seguidores, assim é possível criar cenas e tudo
# mais com os seguidores.
#=======================================================

# Como utilizar o script.
# O script é inteiro movimentado pelo Chamar script e aqui estão os comandos.
# IMPORTANTE:

# Para todos os Chamar script, o follower será o número dele na fila, 
# sendo o segundo personagem do menu o primeiro da fila, logo ele é o 1,
# e assim em diante.


#============================================================================#
# Deixar um membro especifico do grupo visivel ou invisivel.

# Chamar Script: Lune.visible?(follower, visible)
# aonde visible pode ser true ou false, true para deixa-lo visivel e false
# para deixa-lo invisivel.

# Exemplo: o segundo da fila quero deixa-lo invisivel.
# Chamar Script: Lune.visible?(2, false)
#============================================================================#

#============================================================================#
#=====================   Controle dos movimentos    ========================#
#============================================================================#

# Chamar Script: Lune.follower(follower, move, var1, var2)
# No move existem 6 tipos de movimentos inclusos

# :jump, :move, :toward, :direction, :away, :move_diagonal

# Mantenha sempre o : na frente da palavra do movimento.

# Pulo
# Para o terceiro da fila pular 5 em x e -2 em y
# Chamar Script: Lune.follower(3, :jump, 5, -2)

# mover
# Para o segundo da fila mover para a esquerda
# 2 => abaixo, 4 => esquerda, 6 => direita, 8 => acima
# Chamar Script: Lune.follower(2, :move, 4)

# toward
# Para o terceiro da fila se mover na direção do herói
# Chamar Script: Lune.follower(3, :toward)

# away
# Para o primeiro da fila se mover na direção contrária do herói
# Chamar Script: Lune.follower(3, :away)

# direction
# Para o segundo da fila olhar para baixo
# 2 => abaixo, 4 => esquerda, 6 => direita, 8 => acima
# Chamar Script: Lune.follower(2, :direction, 2)

# move_diagonal
# Para o segundo da fila mover na diagonal esquerda-abaixo
# lembrando que o primeiro valor da direção sempre é a do eixo X
# e o segundo do eixo Y.

# 2 => abaixo, 4 => esquerda, 6 => direita, 8 => acima
# Chamar Script: Lune.follower(2, :move_diagonal, 4, 2)

#==============================================================================#
#==============================================================================#
#======================== A PARTIR DAQUI COMEÇA O SCRIPT ======================#
#==============================================================================#
#==============================================================================#

module Lune
  def self.follower(f, move, varX = 0, varY = 0)
    $game_player.follower_control(f, move, varX, varY)
  end
  def self.visible?(f, visible)
    $game_player.follower_visible?(f, visible)
  end
end


#==============================================================================
# ** Game_Player
#------------------------------------------------------------------------------
#  Esta classe gerencia o jogador. 
# A instância desta classe é referenciada por $game_player.
#==============================================================================

class Game_Player < Game_Character
  #--------------------------------------------------------------------------
  # * Visibilidade dos seguidores
  #--------------------------------------------------------------------------
  def follower_visible?(f, visible)
    f -= 1
    visible ? @followers[f].visibility = 255 : @followers[f].visibility = 0
    $game_player.refresh
  end
  #--------------------------------------------------------------------------
  # * Movimento dos seguidores
  #--------------------------------------------------------------------------
  def follower_control(f, move, varX = 0, varY = 0)
    f -= 1
    case move
    when :move
      @followers[f].move_straight(varX)
    when :jump
      @followers[f].jump(varX, varY)
    when :move_diagonal
      @followers[f].move_diagonal(varX, varY)
    when :direction
      @followers[f].set_direction(varX)
    when :toward
      @followers[f].move_toward_player
    when :away
      @followers[f].move_away_from_player
    end
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
attr_accessor :visibility
alias lune_followers_up update
alias lune_followers_ini initialize
  def initialize(member_index, preceding_character)
    @visibility = nil
    lune_followers_ini(member_index, preceding_character)
  end
  def update
    lune_followers_up
    @opacity = @visibility unless @visibility == nil
  end
end
