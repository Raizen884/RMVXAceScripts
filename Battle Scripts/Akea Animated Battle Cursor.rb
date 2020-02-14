#=======================================================
#        Akea Animated Battle Cursor
# Author: Raizen
# Community: http://www.centrorpg.com/
# Compatibility: RMVXAce
# Demo Download: http://www.mediafire.com/download/vvk4dkok6kfs4xc/Battle+Cursor.exe
#=======================================================
# =========================Don't Modify==============================
$included ||= Hash.new
$included[:akea_battlecursor] = true
module Akea_BattleCursor
# =========================Don't Modify==============================

# Configuration starts Here

#=======================================================
#        INSTRUCTIONS
# Simple, put the script above main and below any other battle scripts
# (for better compatibility)
# And then configure below, the scripts shows an animated battle cursor.
#=======================================================

# If animated, this is the framerate update of the animation, the higher the slower.
Cursor_Update = 10

# Show the default windows that identify the enemies and actors?
Show_Windows = false

# Show battler names?
Show_Name = true

# Name of fot, put '' to be used default font
Font_Name = 'Georgia' 

# Size of font, put 0 to use default font size
Font_Size = 18

#==============================================================================
# ** Enemy Configuration
#==============================================================================

# Font Color for Enemies, following the default R, G, B and on the end put the
# opacity of the font, being 0 invisible until 255 full visible
Enemy_Font_Color = [255, 100, 100, 255]

# Name of cursor image, must be in the folder Graphics/Akea
Enemy_Cursor = 'Enemy_Cursor'

# Number of frames the enemy cursor has, if not animated put
# Enemy_Frames = 1
Enemy_Frames = 5

# Cursor position over the enemies
# E_Cursor_Position = [x position, y position]
E_Cursor_Position = [0, -70]

# Position of enemy name
# E_Name_Position = [x position, y position]
E_Name_Position = [0, -30]

# Name of cursor image, must be in the folder Graphics/Akea
# In case you do not use visible actors, put
# Actor_Cursor = ''
Actor_Cursor = 'Actor_Cursor'
#==============================================================================
# ** Actor configuration
# Not necessary IF you do not use visible actors
#==============================================================================

# Font color for the actors, following the default R, G, B and on the end put the
# opacity of the font, being 0 invisible until 255 full visible
Actor_Font_Color = [100, 255, 150, 255]

# Numver of frames from the actor cursor, if not animated put
# Actor_Frames = 1
Actor_Frames = 5

# Cursor Position over the actors
# A_Cursor_Position = [x position, y position]
A_Cursor_Position = [-55, -70]
# 
# Name position of the actors
# A_Name_Position = [x position, y position]
A_Name_Position = [-10, -10]


#==============================================================================
# ** HERE starts the script
#==============================================================================

end

#==============================================================================
# ** Scene_Battle
#------------------------------------------------------------------------------
#  Esta classe executa o processamento da tela de batalha.
#==============================================================================

class Scene_Battle < Scene_Base
alias :akea_bc_start :start
alias :akea_bc_update :update
alias :akea_bc_select_enemy_selection :select_enemy_selection
alias :akea_bc_on_skill_ok :on_skill_ok
alias :akea_bc_on_enemy_cancel :on_enemy_cancel
alias :akea_bc_on_item_ok :on_item_ok
alias :akea_bc_on_actor_cancel :on_actor_cancel
alias :akea_bc_select_actor_selection :select_actor_selection
alias :akea_bc_terminate :terminate
alias :akea_bc_turn_start :turn_start
alias :akea_bc_next_command :next_command
  #--------------------------------------------------------------------------
  # * Inicialização do processo
  #--------------------------------------------------------------------------
  def start
    @bc_cursor = Array.new
    @bc_enemy_cursor = Array.new
    @bc_actor_cursor = Array.new
    @akea_target_all = false
    akea_bc_start
    akea_bc_create_pictures
  end
  def akea_bc_create_pictures
    @bc_actor_size = $game_party.battle_members.size
    @bc_frame_position = 0
    for n in 0...all_battle_members.size
      next unless all_battle_members[n].use_sprite?
      @bc_cursor[n] = Sprite.new
      @bc_cursor[n].bitmap = Bitmap.new(Graphics.width, Graphics.height)
      #@bc[n].bitmap.font.size = 48
      rect = Rect.new(0, 0, 200, 50)
      if all_battle_members[n].actor?
        @bc_cursor[n].bitmap.font.color = Color.new(Akea_BattleCursor::Actor_Font_Color[0], Akea_BattleCursor::Actor_Font_Color[1], Akea_BattleCursor::Actor_Font_Color[2], Akea_BattleCursor::Actor_Font_Color[3])
        @bc_actor_cursor[n] = Sprite.new
        @bc_actor_cursor[n].bitmap = Cache.akea(Akea_BattleCursor::Actor_Cursor)
        @bc_actor_cursor[n].src_rect.set(0, 0, @bc_actor_cursor[n].bitmap.width/Akea_BattleCursor::Actor_Frames, @bc_actor_cursor[n].bitmap.height)
        @bc_actor_cursor[n].opacity = 0
      else
        @bc_enemy_cursor << Sprite.new
        @bc_enemy_cursor.last.bitmap = Cache.akea(Akea_BattleCursor::Enemy_Cursor)
        @bc_enemy_cursor.last.src_rect.set(0, 0, @bc_enemy_cursor.last.bitmap.width/Akea_BattleCursor::Enemy_Frames, @bc_enemy_cursor.last.bitmap.height)
        @bc_enemy_cursor.last.opacity = 0
        @bc_cursor[n].bitmap.font.color = Color.new(Akea_BattleCursor::Enemy_Font_Color[0], Akea_BattleCursor::Enemy_Font_Color[1], Akea_BattleCursor::Enemy_Font_Color[2], Akea_BattleCursor::Enemy_Font_Color[3])
      end
      @bc_cursor[n].bitmap.font.size = Akea_BattleCursor::Font_Size unless Akea_BattleCursor::Font_Size == 0
      @bc_cursor[n].bitmap.font.name = Akea_BattleCursor::Font_Name unless Akea_BattleCursor::Font_Name == ''
      @bc_cursor[n].bitmap.draw_text(rect, all_battle_members[n].name, 0) if Akea_BattleCursor::Show_Name
      @bc_cursor[n].z = 105
      if all_battle_members[n].enemy?
        @bc_cursor[n].x = all_battle_members[n].screen_x + Akea_BattleCursor::E_Name_Position[0]
        @bc_cursor[n].y = all_battle_members[n].screen_y + Akea_BattleCursor::E_Name_Position[1]
      else
        @bc_cursor[n].x = all_battle_members[n].screen_x + Akea_BattleCursor::A_Name_Position[0]
        @bc_cursor[n].y = all_battle_members[n].screen_y + Akea_BattleCursor::A_Name_Position[1]
      end
      @bc_cursor[n].opacity = 0
    end
  end
  def update(*args, &block)
    akea_bc_update
    show_bc_info
  end
  def show_bc_info
    if @enemy_window.active
      @bc_enemy_cursor.each{|cursor| cursor.opacity -= 30}
      @bc_actor_cursor.each{|cursor| cursor.opacity -= 30}
      @bc_cursor.each{|cursor| cursor.opacity -= 30}
      if @akea_target_all
        for n in 0...@bc_enemy_cursor.size
          if $game_troop.members[n].alive?
            @bc_cursor[n + $game_party.members.size].opacity += 60
            @bc_enemy_cursor[n].x = $game_troop.members[n].screen_x + Akea_BattleCursor::E_Cursor_Position[0] 
            @bc_enemy_cursor[n].y = $game_troop.members[n].screen_y + Akea_BattleCursor::E_Cursor_Position[1]
            @bc_enemy_cursor[n].opacity += 60
          end
        end
      else
        @bc_enemy_cursor[@enemy_window.enemy.index].x = $game_troop.members[@enemy_window.enemy.index].screen_x + Akea_BattleCursor::E_Cursor_Position[0]
        @bc_enemy_cursor[@enemy_window.enemy.index].y = $game_troop.members[@enemy_window.enemy.index].screen_y + Akea_BattleCursor::E_Cursor_Position[1]
        @bc_enemy_cursor[@enemy_window.enemy.index].opacity += 60
        @bc_cursor[@enemy_window.enemy.index + $game_party.members.size].opacity += 60
      end
      update_bc_enemy_cursor
    elsif @actor_window.active
      if all_battle_members[0].use_sprite?
        @bc_enemy_cursor.each{|cursor| cursor.opacity -= 30}
        @bc_actor_cursor.each{|cursor| cursor.opacity -= 30}
        @bc_cursor.each{|cursor| cursor.opacity -= 30}
        if @akea_target_all
          for n in 0...@bc_actor_cursor.size
            @bc_actor_cursor[n].x = all_battle_members[n].screen_x + Akea_BattleCursor::A_Cursor_Position[0]
            @bc_actor_cursor[n].y = all_battle_members[n].screen_y + Akea_BattleCursor::A_Cursor_Position[1]
            @bc_actor_cursor[n].opacity += 60
            @bc_cursor[n].opacity += 60
          end
        else
          @bc_actor_cursor[@actor_window.index].x = all_battle_members[@actor_window.index].screen_x + Akea_BattleCursor::A_Cursor_Position[0]
          @bc_actor_cursor[@actor_window.index].y = all_battle_members[@actor_window.index].screen_y + Akea_BattleCursor::A_Cursor_Position[1]
          @bc_actor_cursor[@actor_window.index].opacity += 60
          @bc_cursor[@actor_window.index].opacity += 60
        end
      end
      update_bc_actor_cursor
    else
      for n in 0...all_battle_members.size
        next unless all_battle_members[n].use_sprite?
        @bc_cursor[n].opacity -= 30
      end
        @bc_enemy_cursor.each{|cursor| cursor.opacity -= 30}
        @bc_actor_cursor.each{|cursor| cursor.opacity -= 30}
    end
  end
  def update_bc_enemy_cursor
    return unless Graphics.frame_count % Akea_BattleCursor::Cursor_Update == 0
    if @bc_frame_position >= Akea_BattleCursor::Enemy_Frames - 1
      @bc_frame_position = 0
    else
      @bc_frame_position += 1
    end
    @bc_enemy_cursor.each{|cursor| cursor.src_rect.set(@bc_frame_position*@bc_enemy_cursor[0].bitmap.width/Akea_BattleCursor::Enemy_Frames, 0, @bc_enemy_cursor[0].bitmap.width/Akea_BattleCursor::Enemy_Frames, @bc_enemy_cursor[0].bitmap.height)}
  end
  def update_bc_actor_cursor
    return unless Graphics.frame_count % Akea_BattleCursor::Cursor_Update == 0
    if @bc_frame_position >= Akea_BattleCursor::Actor_Frames - 1
      @bc_frame_position = 0
    else
      @bc_frame_position += 1
    end
    @bc_actor_cursor.each {|cursor| cursor.src_rect.set(@bc_frame_position*@bc_actor_cursor[0].bitmap.width/Akea_BattleCursor::Actor_Frames, 0, @bc_actor_cursor[0].bitmap.width/Akea_BattleCursor::Actor_Frames, @bc_actor_cursor[0].bitmap.height)}
  end
  #--------------------------------------------------------------------------
  # * Início do turno
  #--------------------------------------------------------------------------
  def turn_start
    for n in 0...all_battle_members.size
      next unless all_battle_members[n].use_sprite?
      @bc_cursor[n].opacity = 0
    end
    @bc_enemy_cursor.each{|cursor| cursor.opacity = 0}
    @bc_actor_cursor.each{|cursor| cursor.opacity = 0}
    akea_bc_turn_start
  end
  #--------------------------------------------------------------------------
  # * Seleção da escolha de inimigos
  #--------------------------------------------------------------------------
  def select_enemy_selection
    akea_bc_select_enemy_selection
    @enemy_window.hide unless Akea_BattleCursor::Show_Windows
  end
  #--------------------------------------------------------------------------
  # * Seleção da escolha de heróis
  #--------------------------------------------------------------------------
  def select_actor_selection
    akea_bc_select_actor_selection
    @actor_window.hide if all_battle_members[0].use_sprite? && !Akea_BattleCursor::Show_Windows
  end
  #--------------------------------------------------------------------------
  # * Habilidade [Confirmação]
  #--------------------------------------------------------------------------
  def on_skill_ok
    @force_window = true
    akea_bc_on_skill_ok
    @force_window = false
    if @skill.for_opponent?
      @skill_window.hide
    else
      @skill_window.hide if all_battle_members[0].use_sprite?
    end
  end
  #--------------------------------------------------------------------------
  # * Entrada de comandos para o próximo herói
  #--------------------------------------------------------------------------
  def next_command
    if @force_window && @skill.for_opponent?
        @akea_target_all = true
        select_enemy_selection
      elsif @force_window
        @akea_target_all = true
        select_actor_selection
      else
        @akea_target_all = false
        akea_bc_next_command
    end
  end
  #--------------------------------------------------------------------------
  # * Inimigo [Cancelamento]
  #--------------------------------------------------------------------------
  def on_enemy_cancel
    akea_bc_on_enemy_cancel
    @akea_target_all = false
    case @actor_command_window.current_symbol
    when :skill
      @skill_window.show.activate
    when :item
      @item_window.show.activate
    end
  end
  #--------------------------------------------------------------------------
  # * Herói [Cancelamento]
  #--------------------------------------------------------------------------
  def on_actor_cancel
    akea_bc_on_actor_cancel
    @akea_target_all = false
    case @actor_command_window.current_symbol
    when :skill
      @skill_window.show.activate
    when :item
      @item_window.show.activate
    end
  end
  #--------------------------------------------------------------------------
  # * Item [Confirmação]
  #--------------------------------------------------------------------------
  def on_item_ok
    akea_bc_on_item_ok
    if @item.for_opponent?
      @item_window.hide
    else
      @item_window.hide if all_battle_members[0].use_sprite?
    end
  end
  #--------------------------------------------------------------------------
  # * Finalização do processo
  #--------------------------------------------------------------------------
  def terminate
    for n in 0...all_battle_members.size
      next unless all_battle_members[n].use_sprite?
      @bc_cursor[n].bitmap.dispose
      @bc_cursor[n].dispose
    end
    @bc_actor_cursor.each{|cursor| cursor.bitmap.dispose}
    @bc_actor_cursor.each{|cursor| cursor.dispose}
    @bc_enemy_cursor.each{|cursor| cursor.bitmap.dispose}
    @bc_enemy_cursor.each{|cursor| cursor.dispose}
    akea_bc_terminate
  end
end

#==============================================================================
# ** Cache
#------------------------------------------------------------------------------
#  Este modulo carrega cada gráfico, cria um objeto de Bitmap e retém ele.
# Para acelerar o carregamento e preservar memória, este módulo matém o
# objeto de Bitmap em uma Hash interna, permitindo que retorne objetos
# pré-existentes quando mesmo Bitmap é requerido novamente.
#==============================================================================


module Cache
  #--------------------------------------------------------------------------
  # * Carregamento dos gráficos de animação
  #     filename : nome do arquivo
  #     hue      : informações da alteração de tonalidade
  #--------------------------------------------------------------------------
  def self.akea(filename)
    load_bitmap("Graphics/Akea/", filename)
  end
end



#==============================================================================
# ** Window_BattleActor
#------------------------------------------------------------------------------
#  Esta janela para seleção de heróis na tela de batalha.
#==============================================================================

class Window_BattleActor < Window_BattleStatus
  #--------------------------------------------------------------------------
  # * Movimento do cursor para baixo
  #     wrap : cursor retornar a primeira ou ultima posição
  #--------------------------------------------------------------------------
  def cursor_down(wrap = false)
    super(true)
  end
  #--------------------------------------------------------------------------
  # * Movimento do cursor para cima
  #     wrap : cursor retornar a primeira ou ultima posição
  #--------------------------------------------------------------------------
  def cursor_up(wrap = false)
    super(true)
  end
  #--------------------------------------------------------------------------
  # * Movimento do cursor para direita
  #     wrap : cursor retornar a primeira ou ultima posição
  #--------------------------------------------------------------------------
  def cursor_right(wrap = false)
    cursor_down
  end
  #--------------------------------------------------------------------------
  # * Movimento do cursor para esquerda
  #     wrap : cursor retornar a primeira ou ultima posição
  #--------------------------------------------------------------------------
  def cursor_left(wrap = false)
    cursor_up
  end
end
#==============================================================================
# ** Window_BattleEnemy
#------------------------------------------------------------------------------
#  Esta janela para seleção de inimigos na tela de batalha.
#==============================================================================

class Window_BattleEnemy < Window_Selectable
  #--------------------------------------------------------------------------
  # * Aquisição do número de colunas
  #--------------------------------------------------------------------------
  def col_max
    if Akea_BattleCursor::Show_Windows
      return 2
    else
      return 1
    end
  end
  #--------------------------------------------------------------------------
  # * Movimento do cursor para baixo
  #     wrap : cursor retornar a primeira ou ultima posição
  #--------------------------------------------------------------------------
  def cursor_down(wrap = false)
    super(true)
  end
  #--------------------------------------------------------------------------
  # * Movimento do cursor para cima
  #     wrap : cursor retornar a primeira ou ultima posição
  #--------------------------------------------------------------------------
  def cursor_up(wrap = false)
    super(true)
  end
  #--------------------------------------------------------------------------
  # * Movimento do cursor para direita
  #     wrap : cursor retornar a primeira ou ultima posição
  #--------------------------------------------------------------------------
  def cursor_right(wrap = false)
    cursor_down
  end
  #--------------------------------------------------------------------------
  # * Movimento do cursor para esquerda
  #     wrap : cursor retornar a primeira ou ultima posição
  #--------------------------------------------------------------------------
  def cursor_left(wrap = false)
    cursor_up
  end
end