#===============================================================
# Followers rotation
# Compativel com RMVXAce
# Autor: Raizen
# Comunidade : www.centrorpg.com
# É permitido postar em outros lugares contanto que não seja mudado
# as linhas dos créditos.

# Descrição: O script adiciona uma função presente em vários jogos
# de RPG, em que ao apertar o L/R rotaciona o grupo, em adição ao script
# é possível definir uma variável que será igual ao membro principal do grupo,
# assim criar eventos de acordo com o membro lider.

#==============================================================================
module Swap_Cont_Memb
# Teclas que irão mudar a ordem da equipe ( padrão :L, :R)
Keys = [:L,:R]
# Som ao mudar o grupo, deve estar na pasta SE do seu projeto
Sound = "Evasion1"
# Variável de controle do membro lider do grupo.
Vari = 1
end
#==============================================================================
#==============================================================================
# ** Game_Map
#------------------------------------------------------------------------------
#  Esta classe gerencia o mapa. Inclui funções de rolagem e definição de 
# passagens. A instância desta classe é referenciada por $game_map.
#==============================================================================

class Game_Map
alias :foll_cont_update :update
  def update(*args)
    foll_cont_update(*args)
    $game_party.member_rotation(1) if Input.trigger?(Swap_Cont_Memb::Keys[0])
    $game_party.member_rotation(-1) if Input.trigger?(Swap_Cont_Memb::Keys[1])
  end
end
#==============================================================================
# ** Game_Party
#------------------------------------------------------------------------------
#  Esta classe gerencia o grupo. Contém informações sobre dinheiro, itens.
# A instância desta classe é referenciada por $game_party.
#==============================================================================

class Game_Party < Game_Unit
alias :raizen_swap :swap_order
  #--------------------------------------------------------------------------
  # * Mudança de ordem
  #     index1 : índice do primeiro herói
  #     index2 : índice do segundo herói
  #--------------------------------------------------------------------------
  def swap_order(index1, index2)
   raizen_swap(index1, index2)
   $game_variables[Swap_Cont_Memb::Vari] = @actors[0]
  end
  def member_rotation(n)
    @actors.rotate!(n)
    $game_variables[Swap_Cont_Memb::Vari] = @actors[0]
    RPG::SE.new(Swap_Cont_Memb::Sound)
    $game_player.refresh
  end
end
