#==================================================================
# Lune Anti-Lag
# Autor: Raizen
# Comunidade: centrorpg.com
# Compatibilidade: RMVXAce
#==================================================================

# Instruções:

# Para um evento atualizar constantemente coloque um comentário
# no primeiro comando da página do evento com
# :update:


# Log das versões

# 1.1 => Corrigido o comando de posição de evento, sem nenhum
# impacto extra no processamento do rpg maker.
#==================================================================
#==================================================================
#===================== Aqui começa o script ======================#

#=================================================================#
#====================  Alias methods =============================#
# command_203          => Game_Interpreter
#=================================================================#
#====================  Rewrite methods ===========================#
# update_events        => Game_Map
# update_one_event     => Spriteset_Map
#=================================================================#
#========================  New methods ===========================#
# need_to_update?      => Game_Event
# near_the_screen?     => Sprite_Character
# call_position_event  => Scene_Map
# update_one_event     => Spriteset_Map
#=================================================================#
#=================================================================#

#==============================================================================
# ** Aumento da prioridade do rpg maker
#------------------------------------------------------------------------------
Lune_high = Win32API.new("kernel32", "SetPriorityClass", "pi", "i")
Lune_high.call(-1, 0x90)
#==============================================================================

#==============================================================================
# ** Game_Event
#------------------------------------------------------------------------------
#  Esta classe gerencia os eventos. Ela controla funções incluindo a mudança
# de páginas de event por condições determinadas, e processos paralelos.
# Esta classe é usada internamente pela classe Game_Map. 
#==============================================================================

class Game_Event < Game_Character
  #--------------------------------------------------------------------------
  # * necessário atualizar?
  #--------------------------------------------------------------------------
  def need_to_update?
    ax = $game_map.adjust_x(@real_x) - 8
    ay = $game_map.adjust_y(@real_y) - 6
    ax >= -9 && ax <= 9 && ay >= -7 && ay <= 7 || @list[0].parameters.include?(':update:')
  end
end

#==============================================================================
# ** Sprite_Character
#------------------------------------------------------------------------------
#  Este sprite é usado para mostrar personagens. Ele observa uma instância
# da classe Game_Character e automaticamente muda as condições do sprite.
#==============================================================================

class Sprite_Character < Sprite_Base
  #--------------------------------------------------------------------------
  # * Evento próximo a tela?
  #--------------------------------------------------------------------------
  def near_the_screen?
    ax = $game_map.adjust_x(@character.x) - 8
    ay = $game_map.adjust_y(@character.y) - 6
    ax >= -11 && ax <= 11 && ay >= -8 && ay <= 8
  end
end

#==============================================================================
# ** Game_Interpreter
#------------------------------------------------------------------------------
#  Um interpretador para executar os comandos de evento. Esta classe é usada
# internamente pelas classes Game_Map, Game_Troop e Game_Event.
#==============================================================================

class Game_Interpreter
alias lune_lag_command_203 command_203
  #--------------------------------------------------------------------------
  # Definir posição do evento
  #--------------------------------------------------------------------------
  def command_203
    lune_lag_command_203
    SceneManager.scene.call_position_event(@event_id - 1)
  end
end
#==============================================================================
# ** Game_Map
#------------------------------------------------------------------------------
#  Esta classe gerencia o mapa. Inclui funções de rolagem e definição de 
# passagens. A instância desta classe é referenciada por $game_map.
#==============================================================================

class Game_Map
  #--------------------------------------------------------------------------
  # * Atualização dos comandos dos eventos
  #--------------------------------------------------------------------------
  def update_events
    @events.each_value {|event| event.update if event.need_to_update?}
    @common_events.each {|event| event.update}
  end
end


#==============================================================================
# ** Spriteset_Map
#------------------------------------------------------------------------------
#  Esta classe reune os sprites da tela de mapa e tilesets. Esta classe é
# usada internamente pela classe Scene_Map. 
#==============================================================================
class Spriteset_Map
  #--------------------------------------------------------------------------
  # * Atualização dos personagens
  #--------------------------------------------------------------------------
  def update_characters
    refresh_characters if @map_id != $game_map.map_id
    @character_sprites.each {|sprite| sprite.update if sprite.near_the_screen? }
  end
  #--------------------------------------------------------------------------
  # * Atualização de algum personagem remoto
  #--------------------------------------------------------------------------
  def update_one_event(id)
    @character_sprites[id].update
  end
end


#==============================================================================
# ** Scene_Map
#------------------------------------------------------------------------------
#  Esta classe executa o processamento da tela de mapa.
#==============================================================================

class Scene_Map < Scene_Base
  #--------------------------------------------------------------------------
  # * Atualização de um personagem especifico
  #--------------------------------------------------------------------------
  def call_position_event(id)
    @spriteset.update_one_event(id)
  end
end