#==================================================================
# Event Map Memorizer
# Autor: Raizen
# Comunidade : centrorpg.com
# Compatibilidade: RMVXAce
#==================================================================

# Descrição: O script permite com que seja salvo as posições dos eventos,
# ao ser feito o teleport os eventos no mapa estarão nas mesmas posições
# em que o jogador saiu do local, não tem impacto em relação a lag no jogo.

# Ele é configurado para automaticamente salvar e carregar essas posições
# no momento do teleport.

# Para salvar manuamente.
# Chamar Script: $game_map.save_event_positions

# Para carregar manualmente.
# Chamar Script: $game_map.load_event_positions

# Para limpar o save das posições do evento de um certo mapa
# no local do map_id coloque o id do mapa.
# Chamar Script: $game_map.clear_event_positions(map_id)

module Lune_event_pos
# Switch que ao estiver ligado ele desativa o save
# das posições e carregamento das posições dos eventos.
Switch = 1
end


#==================================================================
#==================================================================
#===================== Aqui começa o script ======================#

#=================================================================#
#====================  Alias methods =============================#
# reserve_transfer     => Game_Player
# initialize           => Game_Map
# perform_transfer     => Game_Player
#=================================================================#
#========================  New methods ===========================#
# save_event_positions    => Game_Map
# load_event_positions    => Game_Map
# clear_event_positions   => Game_Map
#=================================================================#
#=================================================================#

#==============================================================================
# ** Game_Map
#------------------------------------------------------------------------------
#  Esta classe gerencia o mapa. Inclui funções de rolagem e definição de 
# passagens. A instância desta classe é referenciada por $game_map.
#==============================================================================
class Game_Map
alias :lune_memorize_initialize :initialize
  #--------------------------------------------------------------------------
  # * Inicialização das variáveis
  #--------------------------------------------------------------------------
  def initialize
    lune_memorize_initialize
    @memorize_pos = []
  end
  #--------------------------------------------------------------------------
  # * Memorização das posições
  #--------------------------------------------------------------------------
  def save_event_positions
    @memorize_pos[@map_id] = []
    $game_map.events.values.select {|event| @memorize_pos[@map_id][event.id] = [event.x, event.y]}
  end
  #--------------------------------------------------------------------------
  # * Carregamento das posições
  #--------------------------------------------------------------------------
  def load_event_positions
    return if @memorize_pos[@map_id] == nil
    $game_map.events.values.select {|event| event.moveto(@memorize_pos[@map_id][event.id][0], @memorize_pos[@map_id][event.id][1])}
  end
  def clear_event_positions(map_id)
    @memorize_pos[map_id] == nil
  end
end


#==============================================================================
# ** Game_Player
#------------------------------------------------------------------------------
#  Esta classe gerencia o jogador. 
# A instância desta classe é referenciada por $game_player.
#==============================================================================
class Game_Player < Game_Character
alias lune_perform_transfer perform_transfer
alias lune_perform_reserve reserve_transfer
  #--------------------------------------------------------------------------
  # * Carregando as posições
  #--------------------------------------------------------------------------
  def perform_transfer
    lune_perform_transfer
    $game_map.load_event_positions unless $game_switches[Lune_event_pos::Switch]
  end
  #--------------------------------------------------------------------------
  # * Salvando as posições
  #--------------------------------------------------------------------------
  def reserve_transfer(map_id, x, y, d = 2)
    lune_perform_reserve(map_id, x, y, d = 2)
    $game_map.save_event_positions unless $game_switches[Lune_event_pos::Switch]
  end
end
  