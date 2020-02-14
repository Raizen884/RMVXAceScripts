#=======================================================
#         Lune Shadow Equip
# Autor: Raizen
# Comunidade: www.centrorpg.com
# O script mudará o clássico Scene_Equip para outro com mais funções,
# que mostra a posição de cada equipamento do jogador, além de possibilitar
# imagens de fundo.
#=======================================================


module Lune_Equips_Scene
Actor = Array.new

#=======================================================
# CONFIGURE ABAIXO APENAS
#=======================================================
# Habilitar uma janela para cada equipamento?
# true para sim, false para não
Window = true


# Posição dos equips por padrão
# Coloque da seguinte forma 1 => [30, 140], e assim em diante
Default = {
# Nome da Imagem, deve estar na pasta Graphics/System
'Imagem' => 'equip_shadow',
0 => [30, 140],
1 => [300, 100],
2 => [230, 20],
3 => [200, 60],
4 => [200, 240],}

=begin
# Caso queira fazer especificamente para algum actor do database,
# utilize o seguinte template.
Actor[id] = {
'Imagem' => 'nome_da_imagem',
0 => [x, y],
1 => [x, y],
2 => [x, y],
3 => [x, y],
4 => [x, y],}

=end
# Exemplo actor de id 3 do database

Actor[3] = {
# Nome da Imagem, deve estar na pasta Graphics/System
'Imagem' => 'equip_shadow',
0 => [50, 140],
1 => [300, 100],
2 => [230, 20],
3 => [200, 60],
4 => [200, 240],}
# Nome da imagem no cursor
# Deve estar na pasta Graphics/System
Cursor = 'cursor'

# Posição do cursor
Cursor_x = 120
Cursor_y = 30

end

#=======================================================
#=======================================================
#=======================================================
#============== Aqui começa o script!!==================
#=======================================================
#=======================================================
#==============================================================================
# ** Scene_Equip
#------------------------------------------------------------------------------
#  Esta classe executa o processamento da tela de equipamentos.
#==============================================================================

class Scene_Equip < Scene_MenuBase
include Lune_Equips_Scene
alias :lune_equip_start :start
alias :lune_on_item_ok :on_item_ok
alias :lune_command_optimize :command_optimize
alias :lune_command_clear :command_clear
alias :lune_on_actor_change :on_actor_change
alias :lune_terminate :terminate
  #--------------------------------------------------------------------------
  # * Inicialização do processo
  #--------------------------------------------------------------------------
  def start
    lune_equip_start
    create_shadow_equip
    initialize_windows if Window
    @cursor = Sprite.new
    @cursor.bitmap = Cache.system(Cursor)
    @cursor.z = 200
    @cursor.opacity = 0
    @cursor_index = 0
    @item_window.x += 10 until @item_window.x >= Graphics.width
    @status_window.x -= 10 until @status_window.x <= -@status_window.width
    @slot_window.x += 10 until @slot_window.x >= Graphics.width
    @command_window.x += 10 until @command_window.x >= Graphics.width
  end
  #--------------------------------------------------------------------------
  # * Inicialização das janelas auxiliares
  #--------------------------------------------------------------------------
  def initialize_windows
    @ekps_windows = Array.new(4)
    if Actor[@actor.id]
      a = @actor.id
      for n in 0..@ekps_windows.size
        @ekps_windows[n] = Window_Base.new(Actor[a][n][0], @help_window.height+Actor[a][n][1] + 2, 220, 40)
        @ekps_windows[n].back_opacity = 0
      end
    else
      for n in 0..@ekps_windows.size
        @ekps_windows[n] = Window_Base.new(Default[n][0], @help_window.height+Default[n][1] + 2, 220, 40)
        @ekps_windows[n].back_opacity = 0 
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Item [Confirmação]
  #--------------------------------------------------------------------------
  def on_item_ok
    lune_on_item_ok
    @shadow_window.actor = @actor
    @shadow_window.refresh
  end
  #--------------------------------------------------------------------------
  # * Comando [Otimizar]
  #--------------------------------------------------------------------------
  def command_optimize
    lune_command_optimize
    @shadow_window.refresh
  end
  #--------------------------------------------------------------------------
  # * Comando [Remover]
  #--------------------------------------------------------------------------
  def command_clear
    lune_command_clear
    @shadow_window.refresh
  end
  #--------------------------------------------------------------------------
  # * Atualização
  #--------------------------------------------------------------------------
  def update
    super
    @item_window.active ? move_in : move_out
    @command_window.active ? move_com_in : move_com_out
    @slot_window.active ? @cursor.opacity = 255 : @cursor.opacity = 0
    if @cursor_index != @slot_window.index && @actor != nil
      @cursor_index = @slot_window.index
      return if @cursor_index < 0
      if Actor[@actor.id]
        @cursor.x = Actor[@actor.id][@cursor_index][0] + Cursor_x
        @cursor.y = Actor[@actor.id][@cursor_index][1] + @help_window.height + Cursor_y
      else
        @cursor.x = Default[@cursor_index][0] + Cursor_x
        @cursor.y = Default[@cursor_index][1] + @help_window.height + Cursor_y
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Atualização da posição das janelas de equipamentos
  #--------------------------------------------------------------------------
  def move_com_in
    @command_window.x -= 10 unless @command_window.x <= Graphics.width - @command_window.width
  end
  def move_com_out
    @command_window.x += 10 unless @command_window.x >= Graphics.width
  end
  def move_in
    @item_window.x -= 10 unless @item_window.x <= 0
    @status_window.x += 10 unless @status_window.x >= 0
  end
  def move_out
    @item_window.x += 10 unless @item_window.x >= Graphics.width
    @status_window.x -= 10 unless @status_window.x <= -@status_window.width
  end
  #--------------------------------------------------------------------------
  # * Criação da janela de imagens
  #--------------------------------------------------------------------------
  def create_shadow_equip
    @shadow_window = Window_ShadowEquip.new(0, @help_window.height)
    @shadow_window.actor = @actor
    @shadow_window.refresh
  end
  #--------------------------------------------------------------------------
  # * Processo da mudança de herói
  #--------------------------------------------------------------------------
  def on_actor_change
    lune_on_actor_change
    if Actor[@actor.id]
      a = @actor.id
      for n in 0..@ekps_windows.size - 1
        @ekps_windows[n].x = Actor[a][n][0]
        @ekps_windows[n].y = @help_window.height + Actor[a][n][1] + 2
      end
    else
      for n in 0..@ekps_windows.size - 1
        @ekps_windows[n].x = Default[n][0]
        @ekps_windows[n].y = @help_window.height + Default[n][1] + 2
      end
    end
    @shadow_window.actor = @actor
    @cursor_index = @slot_window.index
  end
  #--------------------------------------------------------------------------
  # * Finalização do processo
  #--------------------------------------------------------------------------
  def terminate
    lune_terminate
    dispose_cursor if Window
  end
  #--------------------------------------------------------------------------
  # * Dispose da imagem do cursor
  #--------------------------------------------------------------------------
  def dispose_cursor
    @cursor.bitmap.dispose
    @cursor.dispose
  end
end


#==============================================================================
# ** Window_EquipSlot
#------------------------------------------------------------------------------
#  Esta janela exibe a lista de itens que estão equipados com em um herói.
#==============================================================================

class Window_ShadowEquip < Window_Base
  #--------------------------------------------------------------------------
  # * Variáveis públicas
  #--------------------------------------------------------------------------
  attr_reader   :status_window            # Janela de atributos
  attr_reader   :item_window              # Janela de itens
  #--------------------------------------------------------------------------
  # * Inicialização do objeto
  #     x      : coordenada X
  #     y      : coordenada Y
  #     width  : largura
  #--------------------------------------------------------------------------
  def initialize(x, y)
    @y = y
    super(x, y, Graphics.width, window_height)
    @actor = nil
    refresh
  end
  #--------------------------------------------------------------------------
  # * Aquisição da largura da janela
  #--------------------------------------------------------------------------
  def window_height
    Graphics.height - @y
  end
  #--------------------------------------------------------------------------
  # * Atualização de cena
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    refresh_scenes unless @actor.nil?
  end
  #--------------------------------------------------------------------------
  # * Atualização de cena do ator
  #--------------------------------------------------------------------------
  def refresh_scenes
    change_color(system_color, enable?(1))
    if Lune_Equips_Scene::Actor[@actor.id]
      bitmap = Cache.system(Lune_Equips_Scene::Actor[@actor.id]['Imagem'])
    else
      bitmap = Cache.system(Lune_Equips_Scene::Default['Imagem'])
    end
    rect = Rect.new(0, 0, bitmap.width, bitmap.height)
    contents.blt(0, 0, bitmap, rect, 255) 
    if Lune_Equips_Scene::Actor[@actor.id]
      act = Lune_Equips_Scene::Actor[@actor.id]
    else
      act = Lune_Equips_Scene::Default
    end
    for n in 0..@actor.equips.size - 1
      draw_item_name(@actor.equips[n], act[n][0], act[n][1], enable?(0))
    end
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
  # * Definição de habilitação do item
  #     item : item
  #--------------------------------------------------------------------------
  def enable?(index)
    @actor ? @actor.equip_change_ok?(index) : false
  end
end
