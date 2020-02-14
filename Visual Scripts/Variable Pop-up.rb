#=======================================================
#         Pop-up Variable
# Autor: Raizen
# Comunidade : www.centrorpg.com
# O script permite um pop-up de uma variável a ser escolhida
# abaixo, útil para ABS e outros usos com variaveis.
#=======================================================

# Instruções: Basta 
# Chamar Script: popup_var(event_id, time)
# Aonde event_id = id do evento que ocorre o popup
# time = o tempo em frames que a variável ficará a amostra

module Popup_Var
# Distancia em pixels que vai percorrer o popup
Dist = 30

# Fonte das letras no popup
Font = "arial"

# Tamanho da font
Font_size = 20

# Correção da posição em X
X = -10

# Correção da posição em Y
Y = -90

# Variável que será escolhida para o Popup

Var = 1

end

#====================== Aqui Começa o script ===========================#
class Window_Var_Pop < Window_Base
  def initialize
    super(0, 0, 150, 80)
    self.opacity = 0
    @time = 0
    @mtime = 0
    refresh
  end
  def config(event_id, time)
    @event_id = event_id
    @time = time
    @mtime = time
    draw_t
  end
  def refresh
    if @time >= @mtime - Popup_Var::Dist && @time != 0
      @time -= 1
      self.x = $game_map.events[@event_id].screen_x + Popup_Var::X
      self.y = $game_map.events[@event_id].screen_y + Popup_Var::Y + @time + Popup_Var::Dist - @mtime
    elsif @time > 0
      @time -= 1
      self.x = $game_map.events[@event_id].screen_x + Popup_Var::X
      self.y = $game_map.events[@event_id].screen_y + Popup_Var::Y
    else 
      @mtime = 0
      self.contents.clear
    end
  end
  def draw_t
    self.contents.clear
    self.contents.font.name = Popup_Var::Font
    self.contents.font.size = Popup_Var::Font_size
    draw_text(0, 0, 150, 30, $game_variables[Popup_Var::Var], 0)
  end
end

class Game_Interpreter
  def popup_var(event_id, time)
    $game_popup.config(event_id, time)
  end
end

class Scene_Map < Scene_Base
alias popup_start start
alias popup_update update
alias popup_terminate terminate
  def start
    popup_start
    $game_popup = Window_Var_Pop.new
  end
  def update
    popup_update
    $game_popup.refresh
  end
  def terminate
    $game_popup.dispose
  end
end

