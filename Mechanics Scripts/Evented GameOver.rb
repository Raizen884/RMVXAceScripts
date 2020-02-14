#=======================================================
#         Game Over por Eventos
# Autor: Raizen
# Comunidade: www.centrorpg.com
# O script fará com que o jogador ao acontecer o gameover, ele vá
# para o mapa escolhido, assim possibilitando gameovers totalmente por eventos
#=======================================================

module Lune_Event_Over
# Configure aqui o mapa e as posições do personagem 
# para aonde ele irá no game over.

# ID do mapa
MAP_ID = 2

# Map pos X
X = 5
# Map pos Y
Y = 5
end

#==============================================================================
# ** Scene_Gameover
#------------------------------------------------------------------------------
#  Esta classe executa o processamento da tela de game over.
#==============================================================================

class Scene_Gameover < Scene_Base
  #--------------------------------------------------------------------------
  # * Processamento principal
  #--------------------------------------------------------------------------
  def start
    super
    DataManager.setup_game_over
    $game_map.autoplay
    $game_map.update
    SceneManager.goto(Scene_Map)
  end
  #--------------------------------------------------------------------------
  # * Finalização do processo
  #--------------------------------------------------------------------------
  def terminate
    super
  end
end



#==============================================================================
# ** DataManager
#------------------------------------------------------------------------------
#  Este módulo gerencia o jogo e objetos do banco de dados utilizados no jogo.
# Quase todas as variáveis globais são inicializadas no módulo.
#==============================================================================

module DataManager
   #--------------------------------------------------------------------------
  # * Criação de uma tela de gameover
  #--------------------------------------------------------------------------
  def self.setup_game_over
    $game_map.setup(Lune_Event_Over::MAP_ID)
    $game_player.moveto(Lune_Event_Over::X, Lune_Event_Over::Y)
    $game_player.refresh
  end
end