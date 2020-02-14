#=======================================================
#        Any Event Updater
# Autor: Raizen
# Comunidade: http://www.centrorpg.com/
# Compatibilidade: RMVXAce
#
#=======================================================
# Funcionalidade:
# Permite que um evento seja atualizado mesmo em outro mapa, 
# Isso pode ser usado para eventos em processo paralelo por exemplo que 
# tenham switches locais ou outras funcionalidades que não seriam possíveis ou seriam mais 
# complicados se usado apenas eventos comuns.


module Raizen_Upd_Event
# Coloque abaixo os eventos que sempre serão atualizados, desse modo.
# Event[map_id] = [event_id, event_id]
# Pode colocar quantas linhas desejar
Event = Array.new

Event[2] = [1, 2]
  
end



#==============================================================================
# ** Game_Map
#------------------------------------------------------------------------------
#  Esta classe gerencia o mapa. Inclui funções de rolagem e definição de 
# passagens. A instância desta classe é referenciada por $game_map.
#==============================================================================

class Game_Map
alias :raizen_so_update_events :update_events
alias :raizen_so_setup_events :setup_events
  #--------------------------------------------------------------------------
  # * Atualização do eventos
  #--------------------------------------------------------------------------
  def update_events
    raizen_so_update_events
    @raizen_so_events.each{|event| event.update}
    @events.each_value {|event| event.update }
    @common_events.each {|event| event.update }
  end
  #--------------------------------------------------------------------------
  # * Configuração dos eventos
  #--------------------------------------------------------------------------
  def setup_events
    @raizen_so_events = []
    raizen_so_setup_events
    Raizen_Upd_Event::Event.each_with_index{|item, index|
    next unless item
      @map = load_data(sprintf("Data/Map%03d.rvdata2", index))
      for n in 0...item.size
        @raizen_so_events << Game_Event.new(index, @map.events[item[n]])
      end
    }
    @map = load_data(sprintf("Data/Map%03d.rvdata2", @map_id))
  end
end