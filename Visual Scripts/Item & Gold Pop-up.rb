#===============================================================
# Item Popup 
# Compativel com RMVXAce
# Autor: Raizen
# Comunidade : www.centrorpg.com
# É permitido postar em outros lugares contanto que não seja mudado
# as linhas dos créditos.
#===============================================================
# Item Popup
# Descrição: O Item Popup, é um efeito que ao receber itens
# no decorrer do jogo, ele será mostrado sobre o personagem
module Raizenpop
#Switch que ativa o script, sempre que não quiser que esteja
#ativado o efeito de popup, basta desligar o switch.
SWITCH = 1
# Ajuste em x, aqui da para posicionar a coordenada inicial que
# o item pop-up fará. Valores menores aproximam o Item popup para a direita.
PX = 40
# Ajuste em y, aqui da para posicionar a coordenada inicial que
# o item pop-up fará. Valores menores aproximam o Item popup para baixo.
PY = 90
# tempo que levará para sumir o item popup, o valor está em frames
# em que 60frames = 1 segundo
TIME = 40
# distancia que subirá o item popup, medido em pixels, sendo que o valor
# 0 desliga o movimento do item popup.
DIST = 50
# mostrar a quantidade de itens recebidos? 
Mostrar = true
# Som que tocará quando for ativado o popup, caso não queira som algum coloque
# duas aspas desse modo "" . Caso queira adicionar algum som, colocar na pasta
# SE dentro da pasta Audio do projeto e colocar o nome do arquivo aqui.
SOUND = "Chime2"
# Som do popup de gold
SOUND2 = "Coin"
# Número do icone de gold.
ICON = 361
end
# Aqui começa o script, modifique apenas se sabe o que esta fazendo.
module SceneManager
  def self.raizen_initialize(item, n)
    @scene.raizen_initialize(item, n, Raizenpop::DIST)
  end
  def self.raizen_gold(n)
    @scene.raizen_gold(n, Raizenpop::DIST)
  end
end
class Window_Popup < Window_Base
  def initialize(x, y, item, n, jy)
    super(x, y, x + 544, y + 416)
    self.opacity = 0
    refresh(item, n, $game_player.screen_x - Raizenpop::PX, $game_player.screen_y - Raizenpop::PY + jy)
  end
  def refresh(item, n, x, y)
    self.contents.clear
    if n != 0
    self.contents.font.size = 16
    if item != 0 and item != nil
    draw_icon(item.icon_index, x, y)
    self.contents.draw_text(x + 0, y - 10, 100, 50, item.name, 1)
    self.contents.draw_text(x - 66, y + 10, 100, 50, "x", 2) if Raizenpop::Mostrar
    self.contents.draw_text(x - 46, y + 10, 100, 50, n, 2) if Raizenpop::Mostrar
    else
    draw_icon(Raizenpop::ICON, x, y)
    self.contents.draw_text(x + 26, y - 10, 100, 50, "x", 0) if Raizenpop::Mostrar
    self.contents.draw_text(x + 40, y - 10, 100, 50, n, 0) if Raizenpop::Mostrar
    end
    end
  end
end
class Game_Interpreter
  def command_125
    value = operate_value(@params[0], @params[1], @params[2])
    $game_party.gain_gold_raizen(value)
  end
  def command_126
    value = operate_value(@params[1], @params[2], @params[3])
    $game_party.gain_item_raizen($data_items[@params[0]], value)
  end
  def command_127
    value = operate_value(@params[1], @params[2], @params[3])
    $game_party.gain_item_raizen($data_weapons[@params[0]], value, @params[4])
  end
  def command_128
    value = operate_value(@params[1], @params[2], @params[3])
    $game_party.gain_item_raizen($data_armors[@params[0]], value, @params[4])
  end
end
class Game_Party < Game_Unit
  def gain_item_raizen(item, amount, include_equip = false)
    container = item_container(item.class)
    return unless container
    last_number = item_number(item)
    new_number = last_number + amount
    container[item.id] = [[new_number, 0].max, max_item_number(item)].min
    container.delete(item.id) if container[item.id] == 0
    if include_equip && new_number < 0
      discard_members_equip(item, -new_number)
    end
    $game_map.need_refresh = true
    if $game_switches[Raizenpop::SWITCH]
        SceneManager.raizen_initialize(item, amount)
        RPG::SE.new(Raizenpop::SOUND).play
    end
  end
      def gain_gold_raizen(amount)
      @gold = [[@gold + amount, 0].max, max_gold].min
        if $game_switches[Raizenpop::SWITCH]
        SceneManager.raizen_gold(amount) 
        RPG::SE.new(Raizenpop::SOUND2).play
        end
      end
    end
class Scene_Map < Scene_Base
  alias initializeraizen start
  def start
  @popup = Window_Popup.new(0, 0, 0, 0, 0)
  initializeraizen
end
  def raizen_initialize(item, n, jy) 
  @popup.refresh(item, n, $game_player.screen_x - Raizenpop::PX, $game_player.screen_y - Raizenpop::PY + jy) 
  @item22 = item ; @n22 = n ; @jy22 = jy
  end
  def raizen_gold(g, jy)
  @popup.refresh(0, g, $game_player.screen_x - Raizenpop::PX, $game_player.screen_y - Raizenpop::PY + jy) 
  @n22 = g ; @jy22 = jy ; @item22 = 0
end
alias raizen_update update
  def update
    raizen_update
    if @n22 != nil
    @jy22 -= 1
    @contador22 = 0 if @jy22 == 2
      if @jy22 >= 0
      raizen_initialize(@item22, @n22, @jy22) 
      else
      @contador22 += 1
        if @contador22 <= Raizenpop::TIME
        raizen_initialize(@item22, @n22, 0) 
      else
        raizen_initialize(@item22, 0, 0) 
        @gold = nil
        @n22 = nil
        @item22 = nil
        end
      end
    end
  end
end