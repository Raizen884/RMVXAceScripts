#=======================================================
#         Advanced Dash Run
# Autor: Raizen
# Compativel com: RMVXAce
# Função: O Script adiciona uma barra de stamina, que ao
# correr ela é diminuida, ao andar sobe lentamente e ao
# ficar parado sobe mais rapidamente. O script associa uma
# variável a stamina, portanto pode-se criar poções e outras 
# coisas baseadas na variável de stamina.
#========================================================
module Lune_Stamina
# Nome do arquivo da bar de stamina.(sempre entre aspas "")
# O Arquivo deve estar na pasta System, dentro de Graphics.
Name = "Fome_100"
# Posição da hud em X
Lx = 250
# Posição da hud em Y
Ly = 300
# Variavel que controlará a stamina do jogador.
Variable = 5
# Valor máximo de stamina.
MaxVar = 1000
# Valor que cai ao estar correndo.
Queda = 4
# Valor obtido ao andar.
Andar = 1
# Valor obtido ao ficar parado.
Stop = 2
# Atualização da hud, para fins de melhor perfomance, valor em frames.
# Quanto maior, menos atualização
Atualiza = 5
end

# Informações gerais do script
# Para fins de maior compatibilidade, mantenha esse script abaixo de todos
# os scripts adicionais, e acima do main.

#==============================================================
# Alias dos seguintes métodos.
# start         => Scene_Map
# update        => Scene_Map
# terminate     => Scene_Map

# dash?         => Game_Player
# move_by_imput => Game_Player

# Novo método.
# update_stamina_bar   => Scene_Map
#==============================================================
#==============================================================
# Aqui começa o script.
#==============================================================
class Scene_Map < Scene_Base
alias raizen_stamina_start start
alias raizen_stamina_update update
alias raizen_stamina_terminate terminate
  #--------------------------------------------------------------------------
  # * Inicialização do processo
  #--------------------------------------------------------------------------
  def start
    @stamina_hud = Sprite.new
    @stamina_hud.bitmap = Cache.system(Lune_Stamina::Name)
    @stamina_hud.x = Lune_Stamina::Lx
    @stamina_hud.y = Lune_Stamina::Ly
    update_stamina_bar
    raizen_stamina_start
  end
  def update
    raizen_stamina_update
    update_stamina_bar if Graphics.frame_count % Lune_Stamina::Atualiza == 1
  end
  def update_stamina_bar
    if $game_variables[Lune_Stamina::Variable] > Lune_Stamina::MaxVar
    $game_variables[Lune_Stamina::Variable] = Lune_Stamina::MaxVar 
    elsif $game_variables[Lune_Stamina::Variable] < Lune_Stamina::MaxVar
    $game_variables[Lune_Stamina::Variable] += Lune_Stamina::Andar if $game_player.moving? and !$game_player.dash?
    $game_variables[Lune_Stamina::Variable] += Lune_Stamina::Stop unless $game_player.moving?
    end
    @stamina_hud.zoom_x = $game_variables[Lune_Stamina::Variable].to_f / Lune_Stamina::MaxVar
  end
  def terminate
    raizen_stamina_terminate
    @stamina_hud.dispose
    @stamina_hud.bitmap.dispose
  end
end

class Game_Player < Game_Character
alias raizen_stamina_dash? dash?
alias raizen_stamina_move move_by_input
  def dash?
  return false if $game_variables[Lune_Stamina::Variable] <= 0
  raizen_stamina_dash?
  end
  def move_by_input
    raizen_stamina_move
    $game_variables[Lune_Stamina::Variable] -= Lune_Stamina::Queda if dash?
    $game_variables[Lune_Stamina::Variable] = 0 if  $game_variables[Lune_Stamina::Variable] < 0
  end
end