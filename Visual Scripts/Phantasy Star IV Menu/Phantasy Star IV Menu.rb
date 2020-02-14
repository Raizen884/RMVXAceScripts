#=======================================================
#         Phantasy Star IV Menu
# Autor: Raizen
# Compativel com: RMVXAce
# Comunidade: centrorpg.com
# O script traz um menu semelhante a aquele do Phantasy Star IV
# para o console Mega-Drive(Genesis)
#============================================================

# Configure abaixo como é pedido

module Phantasy_Star_Mod
# Coloque a idade dos personagens, na mesma ordem que os actors do database.
Actor_Age = [

15,   #ID 1
16,   #ID 2
17,   #ID 3
18,   #ID 4
19,   #ID 5
20]   #ID 6

# Posição das janelas

# Janela de comandos

Com_X = 30
Com_Y = 30

# Janela de personagens

Status_X = 300
Status_Y = 15

# Janela de gold

Gold_X = 25
Gold_Y = 300
end


# Nome dos arquivos de imagens, eles devem estar na pasta Graphics/System
#Nome do botão de fundo
Back = 'Fundo_but'

# Nome do botão da frente
Front = 'Front_but'
module Vocab
  # Frases de Estado
  ExpTotal        = "EX :"
  ExpNext         = "NX :"
end
#==============================================================================
#==============================================================================
#====================    Aqui Começa o Script      ============================
#==============================================================================
#==============================================================================
#==============================================================================
# ** Scene_Menu
#------------------------------------------------------------------------------
#  Esta classe executa o processamento da tela de menu.
#==============================================================================

class Scene_Menu < Scene_MenuBase
include Phantasy_Star_Mod
  #--------------------------------------------------------------------------
  # * Inicialização do processo
  #--------------------------------------------------------------------------
  def start
    super
    create_command_window
    create_gold_window
    create_status_window
    @status_window.x = Status_X
    @status_window.y = Status_Y
    @gold_window.x = Gold_X
    @gold_window.y = Gold_Y
  end
  #--------------------------------------------------------------------------
  # * Criação da janela de atributos
  #--------------------------------------------------------------------------
  def create_status_window
    @status_window = Window_MenuStatus.new(200, 0)
  end
  #--------------------------------------------------------------------------
  # * Finalização do processo
  #--------------------------------------------------------------------------
  def terminate
    Graphics.freeze
    dispose_all_windows unless @command_window.current_symbol == :status
    dispose_main_viewport
  end
end



#==============================================================================
# ** Window_MenuCommand
#------------------------------------------------------------------------------
#  Esta janela exibe os comandos do menu.
#==============================================================================

class Window_MenuCommand < Window_Command
  #--------------------------------------------------------------------------
  # * Inicialização da posição do comando de seleção (método da classe)
  #--------------------------------------------------------------------------
  def self.init_command_position
    @@last_command_symbol = nil
  end
  #--------------------------------------------------------------------------
  # * Inicialização do objeto
  #--------------------------------------------------------------------------
  def initialize
    super(0, 0)
    select_last
    @button_array = Array.new(item_max)
    self.x = Phantasy_Star_Mod::Com_X
    self.y = Phantasy_Star_Mod::Com_Y
    for n in 0...@button_array.size
      @button_array[n] = Sprite.new
      @button_array[n].bitmap = Cache.system('Fundo_but')
      @button_array[n].y = n * item_height + line_height*2/3 + self.y
      @button_array[n].z = 200
      @button_array[n].x += 10 + self.x
    end
    @select_but = Sprite.new
    @select_but.bitmap = Cache.system('Front_but')
    @select_but.y = index * item_height + line_height*2/3 + self.y
    @select_but.z = 201
    @select_but.x = 10 + self.x
  end
  #--------------------------------------------------------------------------
  # * Aquisição da largura da janela
  #--------------------------------------------------------------------------
  def window_width
    return 120
  end
  #--------------------------------------------------------------------------
  # * Aquisição do retangulo para desenhar o item (para texto)
  #     index : índice do item
  #--------------------------------------------------------------------------
  def item_rect_for_text(index)
    rect = item_rect(index)
    rect.x += 24
    rect.width -= 8
    rect
  end
  #--------------------------------------------------------------------------
  # * Atualização do cursor
  #--------------------------------------------------------------------------
  def update_cursor
    cursor_rect.empty
    @select_but.y = index * item_height + line_height*2/3 + self.y if @select_but
  end
  def dispose
    @button_array.each{|ar| ar.bitmap.dispose; ar.dispose}
    @select_but.bitmap.dispose
    @select_but.dispose
    super
  end
end



#==============================================================================
# ** Window_MenuStatus
#------------------------------------------------------------------------------
#  Esta janela exibe os parâmetros dos membros do grupo na tela de menu.
#==============================================================================

class Window_MenuStatus < Window_Selectable
  #--------------------------------------------------------------------------
  # * Variáveis públicas
  #--------------------------------------------------------------------------
  attr_reader   :pending_index            # Manter a posição (para organizar)
  #--------------------------------------------------------------------------
  # * Inicialização do objeto
  #     x      : coordenada X
  #     y      : coordenada Y
  #--------------------------------------------------------------------------
  def initialize(x, y)
    @y = y
    super(x, y, window_width, window_height)
    @pending_index = -1
    refresh
  end
  #--------------------------------------------------------------------------
  # * Aquisição da largura da janela
  #--------------------------------------------------------------------------
  def window_width
    200
  end
  #--------------------------------------------------------------------------
  # * Aquisição da altura da janela
  #--------------------------------------------------------------------------
  def window_height
    [Graphics.height - @y, $game_party.members.size*100].min
  end
  #--------------------------------------------------------------------------
  # * Desenho de um item
  #     index : índice do item
  #--------------------------------------------------------------------------
  def draw_item(index)
    actor = $game_party.members[index]
    enabled = $game_party.battle_members.include?(actor)
    rect = item_rect(index)
    draw_actor_simple_status(actor, rect.x, rect.y + line_height / 2)
  end
  #--------------------------------------------------------------------------
  # * Desenho dos atributos básicos
  #     actor : herói
  #     x     : coordenada X
  #     y     : coordenada Y
  #--------------------------------------------------------------------------
  def draw_actor_simple_status(actor, x, y)
    draw_actor_name(actor, x, y)
    draw_actor_level(actor, x + 100, y)
    draw_text(x, y+line_height, 100, line_height, "HP: ", 0)
    draw_text(0, y+line_height, window_width - 20, line_height, " #{actor.hp.to_s}/ #{actor.mhp.to_s}", 2)
    draw_text(x, y+line_height*2, 100, line_height, "MP: ", 0)
    draw_text(0, y+line_height*2, window_width - 20, line_height, " #{actor.mp.to_s}/ #{actor.mmp.to_s}", 2)
  end
  #--------------------------------------------------------------------------
  # * Aquisição de altura do item
  #--------------------------------------------------------------------------
  def item_height
    (height - standard_padding * 2) / $game_party.members.size
  end
end


#==============================================================================
# ** Scene_Status
#------------------------------------------------------------------------------
#  Esta classe executa o processamento da tela de atributos.
#==============================================================================

class Scene_Status < Scene_MenuBase
  #--------------------------------------------------------------------------
  # * Inicialização do processo
  #--------------------------------------------------------------------------
  def start
    super
    @status_window = Window_Status.new(@actor)
    @status_window.set_handler(:cancel,   method(:return_scene))
    @status_window_face = Window_Status_Face.new(@actor)
    @status_window_class = Window_Status_Class.new(@actor)
    @status_window_equip = Window_Status_Equip.new(@actor)
    @status_window_exp = Window_Status_Exp.new(@actor)
    @status_window_exp.x = 300
    @status_window_exp.y = 300
    @status_window_equip.x = 30
    @status_window_equip.y = 230
    @status_window_class.x = 150
    @status_window_class.y = 30
    @status_window_face.x = 30
    @status_window_face.y = 30
    @status_window.x = 340
    @status_window.y = 30
    @status_window_face.z = 205
  end
  #--------------------------------------------------------------------------
  # * Processo da mudança de herói
  #--------------------------------------------------------------------------
  def on_actor_change
    @status_window.actor = @actor
    @status_window.activate
  end
end



#==============================================================================
# ** Window_Status
#------------------------------------------------------------------------------
#  Esta janela exibe as especificações completas na janela de atributos.
#==============================================================================

class Window_Status < Window_Selectable
  #--------------------------------------------------------------------------
  # * Inicialização do objeto
  #     actor : herói
  #--------------------------------------------------------------------------
  def initialize(actor)
    super(0, 0, 190, fitting_height(6))
    @actor = actor
    refresh
    activate
  end
  #--------------------------------------------------------------------------
  # * Definição de herói
  #     actor : herói
  #--------------------------------------------------------------------------
  def actor=(actor)
    return if @actor == actor
    @actor = actor
    refresh
  end
  #--------------------------------------------------------------------------
  # * Renovação
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    draw_block1
  end
  #--------------------------------------------------------------------------
  # * Desenho do bloco 1
  #     y : coordenada Y
  #--------------------------------------------------------------------------
  def draw_block1
    draw_parameters(0, 0)
  end
  #--------------------------------------------------------------------------
  # * Desenho dos parâmetros
  #     x : coordenada X
  #     y : coordenada Y
  #--------------------------------------------------------------------------
  def draw_parameters(x, y)
    6.times {|i| draw_actor_param(@actor, x, y + line_height * i, i + 2) }
  end
  #--------------------------------------------------------------------------
  # * Desenho dos parâmetros
  #     actor : herói
  #     x     : coordenada X
  #     y     : coordenada Y
  #--------------------------------------------------------------------------
  def draw_actor_param(actor, x, y, param_id)
    change_color(system_color)
    draw_text(x, y, 120, line_height, "#{Vocab::param(param_id)}:")
    change_color(normal_color)
    draw_text(x + 120, y, 36, line_height, actor.param(param_id), 2)
  end
end



#==============================================================================
# ** Window_Status
#------------------------------------------------------------------------------
#  Esta janela exibe as especificações completas na janela de atributos.
#==============================================================================

class Window_Status_Face < Window_Selectable
  #--------------------------------------------------------------------------
  # * Inicialização do objeto
  #     actor : herói
  #--------------------------------------------------------------------------
  def initialize(actor)
    super(0, 0, 120, 120)
    @actor = actor
    refresh
    activate
  end
  #--------------------------------------------------------------------------
  # * Definição de herói
  #     actor : herói
  #--------------------------------------------------------------------------
  def actor=(actor)
    return if @actor == actor
    @actor = actor
    refresh
  end
  #--------------------------------------------------------------------------
  # * Renovação
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    draw_block1
  end
  #--------------------------------------------------------------------------
  # * Desenho do bloco 1
  #     y : coordenada Y
  #--------------------------------------------------------------------------
  def draw_block1
    draw_actor_face(@actor, 0, 0)
  end
end

#==============================================================================
# ** Window_Status
#------------------------------------------------------------------------------
#  Esta janela exibe as especificações completas na janela de atributos.
#==============================================================================

class Window_Status_Class < Window_Selectable
  #--------------------------------------------------------------------------
  # * Inicialização do objeto
  #     actor : herói
  #--------------------------------------------------------------------------
  def initialize(actor)
    super(0, 0, 190, 200)
    @actor = actor
    refresh
    activate
  end
  #--------------------------------------------------------------------------
  # * Definição de herói
  #     actor : herói
  #--------------------------------------------------------------------------
  def actor=(actor)
    return if @actor == actor
    @actor = actor
    refresh
  end
  #--------------------------------------------------------------------------
  # * Renovação
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    draw_block1
  end
  #--------------------------------------------------------------------------
  # * Desenho do bloco 1
  #     y : coordenada Y
  #--------------------------------------------------------------------------
  def draw_block1
    draw_actor_name(@actor, 4, 0)
    draw_actor_class(@actor, 4, line_height)
    draw_text(4, line_height*3, 100, line_height, "LV : #{@actor.level.to_s}", 0)
    draw_actor_age(@actor, 4, line_height*4)
    draw_text(4, line_height*5, 100, line_height, "HP: ", 0)
    draw_text(0, line_height*5, 160, line_height, " #{@actor.hp.to_s}/ #{@actor.mhp.to_s}", 2)
    draw_text(4, line_height*6, 100, line_height, "MP: ", 0)
    draw_text(0, line_height*6, 160, line_height, " #{@actor.mp.to_s}/ #{@actor.mmp.to_s}", 2)
  end
  def draw_actor_age(actor, x, y)
    age = Phantasy_Star_Mod::Actor_Age[@actor.index].to_s
    draw_text(x, y, 100, line_height, "Age : #{age}", 0)
  end
end


#==============================================================================
# ** Window_Status
#------------------------------------------------------------------------------
#  Esta janela exibe as especificações completas na janela de atributos.
#==============================================================================

class Window_Status_Equip < Window_Selectable
  #--------------------------------------------------------------------------
  # * Inicialização do objeto
  #     actor : herói
  #--------------------------------------------------------------------------
  def initialize(actor)
    super(0, 0, 220, 180)
    @actor = actor
    refresh
    activate
  end
  #--------------------------------------------------------------------------
  # * Definição de herói
  #     actor : herói
  #--------------------------------------------------------------------------
  def actor=(actor)
    return if @actor == actor
    @actor = actor
    refresh
  end
  #--------------------------------------------------------------------------
  # * Renovação
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    draw_block1
  end
  #--------------------------------------------------------------------------
  # * Desenho do bloco 1
  #     y : coordenada Y
  #--------------------------------------------------------------------------
  def draw_block1
    draw_equipments(4, 0)
  end
  #--------------------------------------------------------------------------
  # * Desenho dos equipamentos
  #     x : coordenada X
  #     y : coordenada Y
  #--------------------------------------------------------------------------
  def draw_equipments(x, y)
    @actor.equips.each_with_index do |item, i|
      draw_item_name(item, x, y + line_height * i)
    end
  end
end

#==============================================================================
# ** Window_Status
#------------------------------------------------------------------------------
#  Esta janela exibe as especificações completas na janela de atributos.
#==============================================================================

class Window_Status_Exp < Window_Selectable
  #--------------------------------------------------------------------------
  # * Inicialização do objeto
  #     actor : herói
  #--------------------------------------------------------------------------
  def initialize(actor)
    super(0, 0, 160, fitting_height(2))
    @actor = actor
    refresh
    activate
  end
  #--------------------------------------------------------------------------
  # * Definição de herói
  #     actor : herói
  #--------------------------------------------------------------------------
  def actor=(actor)
    return if @actor == actor
    @actor = actor
    refresh
  end
  #--------------------------------------------------------------------------
  # * Renovação
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    draw_block1
  end
  #--------------------------------------------------------------------------
  # * Desenho do bloco 1
  #     y : coordenada Y
  #--------------------------------------------------------------------------
  def draw_block1
    draw_exp_info(4, 0)
  end
  #--------------------------------------------------------------------------
  # * Desenho das informações de experiência
  #     x : coordenada X
  #     y : coordenada Y
  #--------------------------------------------------------------------------
  def draw_exp_info(x, y)
    s1 = @actor.max_level? ? "---" : @actor.exp
    s2 = @actor.max_level? ? "---" : @actor.next_level_exp - @actor.exp
    s_next = sprintf(Vocab::ExpNext, Vocab::level)
    change_color(system_color)
    draw_text(x, y + line_height * 0, 130, line_height, Vocab::ExpTotal)
    draw_text(x, y + line_height * 1, 130, line_height, s_next)
    change_color(normal_color)
    draw_text(x, y + line_height * 0, 130, line_height, s1, 2)
    draw_text(x, y + line_height * 1, 130, line_height, s2, 2)
  end
end
