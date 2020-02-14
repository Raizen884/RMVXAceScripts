#=======================================================
#        Akea Battle Window
# Autor: Raizen
# Comunidade: http://www.centrorpg.com/
# Compatibilidade: RMVXAce
#
# Plug n' Play, basta colocar o script acima do main e configurar
# abaixo, o script permite exibição de dano nos inimigos e no personagem.
# Download Demo: http://www.mediafire.com/download/n8cqi2lum18kivk/Akea+Battle+Window.exe
#=======================================================
# =========================Não modificar==============================
$included ||= Hash.new
$included[:akea_battlewindow] = true
module Akea_Battle_Window
Party = []
Win_Pic = []
# =========================Não modificar==============================

#==============================================================================
#------------------------------------------------------------------------------
#------------------------- CONFIGURAÇÃO DE IMAGENS ----------------------------
#------------------------------------------------------------------------------
#==============================================================================

# Imagem do Cursor
Cursor_Name = 'Cursor'

# Imagens de Fundo das janelas, para usar a janela padrão sem imagem
# basta colocar o nome como ''
# Exemplo Win_Pic[0] = ''

Win_Pic[0] = 'Status_Pic'  # Janela de Status dos personagens
Win_Pic[1] = 'Battle_Pic1' # Janela de comando do grupo
Win_Pic[2] = 'Battle_Pic1' # Janela de comando dos personagens
Win_Pic[3] = 'Status_Pic' # Janela dos inimigos
Win_Pic[4] = 'Status_Pic' # Janela de Mensagens
Win_Pic[5] = 'Skill_Pic' # Janela de Habilidades
Win_Pic[6] = 'Skill_Pic' # Janela de Itens
Win_Pic[7] = 'Help_Pic' # Janela de Ajuda
Win_Pic[8] = 'Battle_Pic1' # Janela Adicional que mostra o rosto do personagem


Correct_X = 16 # COrreção dos Textos em X
Correct_Y = 7 # Correção dos Textos em Y

Cursor_X = 0 # Correção do Cursor em X
Cursor_Y = 12 # Correção do Cursor em Y


# Configure aqui a posição da janela de comandos do personagem
# APENAS NECESSÁRIO caso não use scripts que usem battlers para os
# personagens, seguindo esse modo.
# Party[id] =  [x, y]
# Aonde id é a posição do personagem na party,
# começando a contagem de 0, x posição em x e y posição em y
Party[0] = [0, 170]
Party[1] = [136, 170] 
Party[2] = [272, 170] 
Party[3] = [408, 170] 


Column = 1 # Número de colunas para itens e magias (1 ou 2)

# Configure as correções de posição
# APENAS NECESSÁRIO caso use scriptes que usem battlers para os
# personagens
Actor_Sprt_X = -160 # Correção em X para a posição dos personagens
Actor_Sprt_Y = -120 # Correção em Y para a posição dos personagens



#==============================================================================
#------------------------------------------------------------------------------
#------------------------- CONFIGURAÇÃO DA HUD ----------------------------
#------------------------------------------------------------------------------
#==============================================================================

# Nome das imagens nessa ordem, na pasta Graphics/System
# [Imagem de fundo da hud de vida, Barra de HP, 
# Imagem de fundo da hud de mana, Barra de MP, 
# Imagem de fundo da hud de TP, Barra de TP]

Pic = ['BACK_BAR', 'HP_BAR', 'BACK_BAR', 'MP_BAR', 'BACK_BAR', 'TP_BAR']

# Correção da posição em X
# Modifique os valores, pode ser negativo, até as barras atingirem a posição ideal.
Todos_X = -10
HP_X = 1
MP_X = 1
TP_X = 1
# Correção da posição em Y
Todos_Y = 16
HP_Y = 4
MP_Y = 4
TP_Y = 4

# Manter Texto de HP/MP?

Text = true

# Manter numeração? (Ex 100/253)
Num = true

# Tamanho da fonte
Fonte = 16
end


#==============================================================================
#------------------------------------------------------------------------------
#--------------------------- AQUI COMEÇA O SCRIPT -----------------------------
#------------------------------------------------------------------------------
#==============================================================================
#==============================================================================
# ** Scene_Battle
#------------------------------------------------------------------------------
#  Esta classe executa o processamento da tela de batalha.
#==============================================================================

class Scene_Battle < Scene_Base
alias :abw_start :start
alias :abw_turn_start :turn_start
alias :abw_turn_end :turn_end
alias :abw_terminate :terminate
alias :abw_start_actor_command_selection :start_actor_command_selection
  #--------------------------------------------------------------------------
  # * Inicialização do processo
  #--------------------------------------------------------------------------
  def start(*args, &block)
    abw_start(*args, &block)
    $abw_cursor_set = Sprite.new
    $abw_cursor_set.bitmap = Cache.akea(Akea_Battle_Window::Cursor_Name)
    $abw_cursor_set.z = 800
    $abw_cursor_set.opacity = 0
    @update_cur_position = false
    @actor_command_window.viewport = nil
    @actor_command_window.x = 0
    @actor_command_window.y = 0
  end
  #--------------------------------------------------------------------------
  # * Início do turno
  #--------------------------------------------------------------------------
  def turn_start
    $abw_cursor_set.opacity = 0
    @act_face_battle.close
    abw_turn_start
  end
  #--------------------------------------------------------------------------
  # * Inicialização da seleção de comandos do herói
  #--------------------------------------------------------------------------
  def start_actor_command_selection
    @act_face_battle.contents_opacity = 255
    $abw_cursor_set.opacity = 255
    @act_face_battle.opacity = 255 if Akea_Battle_Window::Win_Pic[8] == ''
    @act_face_battle.refresh(BattleManager.actor)
    if BattleManager.actor.use_sprite?
      @actor_command_window.x = BattleManager.actor.screen_x + Akea_Battle_Window::Actor_Sprt_X
      @actor_command_window.y = BattleManager.actor.screen_y + Akea_Battle_Window::Actor_Sprt_Y
    else
      @actor_command_window.x = Akea_Battle_Window::Party[BattleManager.actor.index][0]
      @actor_command_window.y = Akea_Battle_Window::Party[BattleManager.actor.index][1]
    end
    abw_start_actor_command_selection
  end  
  #--------------------------------------------------------------------------
  # * Criação da janela de mensagem
  #--------------------------------------------------------------------------
  def create_message_window
    @message_window = Window_Abw_Message.new
  end
  #--------------------------------------------------------------------------
  # * Criação da janela de ajuda
  #--------------------------------------------------------------------------
  def create_help_window
    @help_window = Window_Battle_Help.new
    @help_window.visible = false
    @act_face_battle = Window_Battle_Face.new(@actor_command_window.width, @actor_command_window.height, @info_viewport)
    @act_face_battle.opacity = 0
    @act_face_battle.contents_opacity = 0
  end
  #--------------------------------------------------------------------------
  # * Final do turno
  #--------------------------------------------------------------------------
  def turn_end
    abw_turn_end
    @act_face_battle.open
    $abw_cursor_set.opacity = 255
  end
  #--------------------------------------------------------------------------
  # * Finalização do processo
  #--------------------------------------------------------------------------
  def terminate
    abw_terminate
    $abw_cursor_set.bitmap.dispose
    $abw_cursor_set.dispose
    $abw_cursor_set = nil
  end
end

class Window_Battle_Face < Window_Base
  #--------------------------------------------------------------------------
  # * Inicialização do objeto
  #--------------------------------------------------------------------------
  def initialize(width, height, viewport)
    super(Graphics.width, 0, width, height)
    self.viewport = viewport
    self.opacity = 0 unless Akea_Battle_Window::Win_Pic[8] == ''
    refresh($game_party.battle_members[0])
  end
  def refresh(actor)
    contents.clear
    create_back_picture
    x = Akea_Battle_Window::Win_Pic[8] == '' ? 0 : 12
    y = Akea_Battle_Window::Win_Pic[8] == '' ? 0 : 12
    draw_face(actor.face_name, actor.face_index, x, y, enabled = true)
  end

  def create_back_picture
    return if Akea_Battle_Window::Win_Pic[8] == ''
    bitmap = Cache.akea(Akea_Battle_Window::Win_Pic[8])
    rect = Rect.new(0, 0, bitmap.width, bitmap.height)
    contents.blt(0, 0, bitmap, rect, 255)
  end
  #--------------------------------------------------------------------------
  # * Espaçamento lateral padrão
  #--------------------------------------------------------------------------
  def standard_padding
    Akea_Battle_Window::Win_Pic[8] == '' ? 12 : 0
  end
  #--------------------------------------------------------------------------
  # * Aquisição da altura da janela
  #--------------------------------------------------------------------------
  def window_height
    Akea_Battle_Window::Win_Pic[8] == '' ? fitting_height(visible_line_number) : (fitting_height(visible_line_number) + 24)
  end
end
#==============================================================================
# ** Window_Help
#------------------------------------------------------------------------------
#  Esta janela exibe explicação de habilidades e itens e outras informações.
#==============================================================================

class Window_Battle_Help < Window_Help
  #--------------------------------------------------------------------------
  # * Inicialização do objeto
  #     line_number : número de linhas
  #--------------------------------------------------------------------------
  def initialize(line_number = 2)
    unless Akea_Battle_Window::Win_Pic[7] == ''
      @abw_picture = Sprite.new
      @abw_picture.bitmap = Cache.akea(Akea_Battle_Window::Win_Pic[7])
      @abw_picture.opacity = 0
    end
    super(line_number = 2)
    self.opacity = 0 unless Akea_Battle_Window::Win_Pic[7] == ''
  end
  #--------------------------------------------------------------------------
  # * Exibição da janela
  #--------------------------------------------------------------------------
  def show
    if @abw_picture
      @abw_picture.opacity = 255
      @abw_picture.x = self.x
      @abw_picture.y = self.y
    end
    super
  end
  #--------------------------------------------------------------------------
  # * Ocultação da janela
  #--------------------------------------------------------------------------
  def hide
    @abw_picture.opacity = 0 if @abw_picture
    super
  end
  #--------------------------------------------------------------------------
  # * Desenho do texto
  #     args : Bitmap.draw_text
  #--------------------------------------------------------------------------
  def draw_text(*args)
    if args[0].is_a?(Integer) && Akea_Battle_Window::Win_Pic[7] != ''
      args[0] += Akea_Battle_Window::Correct_X - 6
      args[1] += Akea_Battle_Window::Correct_Y - 6
    elsif Akea_Battle_Window::Win_Pic[7] != ''
      args[0].x += Akea_Battle_Window::Correct_X - 6
      args[0].y += Akea_Battle_Window::Correct_Y - 6
    end
    contents.draw_text(*args)
  end
  def dispose
    super
    @abw_picture.bitmap.dispose
    @abw_picture.dispose
  end
end

#==============================================================================
# ** Window_BattleItem
#------------------------------------------------------------------------------
#  Esta janela para seleção de itens na tela de batalha.
#==============================================================================

class Window_BattleItem < Window_ItemList
alias :abw_draw_all_items :draw_all_items
alias :abw_show :show
alias :abw_hide :hide
alias :abw_update_cursor :update_cursor
  #--------------------------------------------------------------------------
  # * Inicialização do objeto
  #     info_viewport : viewport para exibir informações
  #--------------------------------------------------------------------------
  def initialize(help_window, info_viewport)
    unless Akea_Battle_Window::Win_Pic[5] == ''
      @abw_picture = Sprite.new
      @abw_picture.bitmap = Cache.akea(Akea_Battle_Window::Win_Pic[5])
      @abw_picture.opacity = 0
    end
    y = help_window.height
    width = Graphics.width/2 * Akea_Battle_Window::Column
    super(0, y, Graphics.width, info_viewport.rect.y - y)
    self.visible = false
    @help_window = help_window
    @info_viewport = info_viewport
    self.opacity = 0 unless Akea_Battle_Window::Win_Pic[5] == ''
  end
  #--------------------------------------------------------------------------
  # * Exibição da janela
  #--------------------------------------------------------------------------
  def show
    if @abw_picture
      @abw_picture.opacity = 255
      @abw_picture.x = self.x
      @abw_picture.y = self.y
    end
    abw_show
  end
  #--------------------------------------------------------------------------
  # * Ocultação da janela
  #--------------------------------------------------------------------------
  def hide
    @abw_picture.opacity = 0 if @abw_picture
    abw_hide
  end
  #--------------------------------------------------------------------------
  # * Aquisição do número de colunas
  #--------------------------------------------------------------------------
  def col_max
    return Akea_Battle_Window::Column
  end
  #--------------------------------------------------------------------------
  # * Desenho do texto
  #     args : Bitmap.draw_text
  #--------------------------------------------------------------------------
  def draw_text(*args)
    if args[0].is_a?(Integer) && Akea_Battle_Window::Win_Pic[5] != ''
      args[0] += Akea_Battle_Window::Correct_X - 6
      args[1] += Akea_Battle_Window::Correct_Y - 6
    elsif Akea_Battle_Window::Win_Pic[5] != ''
      args[0].x += Akea_Battle_Window::Correct_X - 6
      args[0].y += Akea_Battle_Window::Correct_Y - 6
    end
    contents.draw_text(*args)
  end
  #--------------------------------------------------------------------------
  # * Desenho do número de itens possuido
  #     rect : retângulo
  #     item : item
  #--------------------------------------------------------------------------
  def draw_item_number(rect, item)
    rect.x -= Akea_Battle_Window::Correct_X
    rect.width /= (2 / Akea_Battle_Window::Column)
    draw_text(rect, sprintf(":%2d", $game_party.item_number(item)), 2)
  end
  #--------------------------------------------------------------------------
  # * Atualização do cursor
  #--------------------------------------------------------------------------
  def update_cursor
    abw_update_cursor unless $abw_cursor_set
    if $abw_cursor_set
      $abw_cursor_set.x = self.x + item_rect(@index).x + Akea_Battle_Window::Cursor_X
      $abw_cursor_set.y = self.y + item_rect(@index - self.top_row).y + Akea_Battle_Window::Cursor_Y
    end
  end
  def dispose
    super
    @abw_picture.bitmap.dispose
    @abw_picture.dispose
  end
end


#==============================================================================
# ** Window_BattleSkill
#------------------------------------------------------------------------------
#  Esta janela para seleção de habilidades na tela de batalha.
#==============================================================================

class Window_BattleSkill < Window_SkillList
alias :abw_draw_all_items :draw_all_items
alias :abw_show :show
alias :abw_hide :hide
alias :abw_draw_skill_cost :draw_skill_cost
  #--------------------------------------------------------------------------
  # * Inicialização do objeto
  #     info_viewport : viewport para exibir informações
  #--------------------------------------------------------------------------
  def initialize(help_window, info_viewport)
    unless Akea_Battle_Window::Win_Pic[5] == ''
      @abw_picture = Sprite.new
      @abw_picture.bitmap = Cache.akea(Akea_Battle_Window::Win_Pic[5])
      @abw_picture.opacity = 0
    end
    y = help_window.height
    width = Graphics.width/2 * Akea_Battle_Window::Column
    super(0, y, width, info_viewport.rect.y - y)
    self.visible = false
    @help_window = help_window
    @info_viewport = info_viewport
    self.opacity = 0 unless Akea_Battle_Window::Win_Pic[5] == ''
  end
  #--------------------------------------------------------------------------
  # * Atualização do cursor
  #--------------------------------------------------------------------------
  def update_cursor
    super
    if $abw_cursor_set
      $abw_cursor_set.x = self.x + item_rect(@index).x + Akea_Battle_Window::Cursor_X
      $abw_cursor_set.y = self.y + item_rect(@index - self.top_row).y + Akea_Battle_Window::Cursor_Y
    end
  end
  #--------------------------------------------------------------------------
  # * Exibição da janela
  #--------------------------------------------------------------------------
  def show
    if @abw_picture
      @abw_picture.opacity = 255
      @abw_picture.x = self.x
      @abw_picture.y = self.y
    end
    abw_show
  end
  #--------------------------------------------------------------------------
  # * Ocultação da janela
  #--------------------------------------------------------------------------
  def hide
    @abw_picture.opacity = 0 if @abw_picture
    abw_hide
  end
  #--------------------------------------------------------------------------
  # * Aquisição do número de colunas
  #--------------------------------------------------------------------------
  def col_max
    return Akea_Battle_Window::Column
  end
  #--------------------------------------------------------------------------
  # * Desenho do texto
  #     args : Bitmap.draw_text
  #--------------------------------------------------------------------------
  def draw_text(*args)
    if args[0].is_a?(Integer) && Akea_Battle_Window::Win_Pic[2] != ''
      args[0] += Akea_Battle_Window::Correct_X - 6
      args[1] += Akea_Battle_Window::Correct_Y - 6
    elsif Akea_Battle_Window::Win_Pic[2] != ''
      args[0].x += Akea_Battle_Window::Correct_X - 6
      args[0].y += Akea_Battle_Window::Correct_Y - 6
    end
    contents.draw_text(*args)
  end
  #--------------------------------------------------------------------------
  # * Desenho do custo das habilidades
  #     rect  : retângulo
  #     skill : habilidade
  #--------------------------------------------------------------------------
  def draw_skill_cost(rect, skill)
    rect.x -= Akea_Battle_Window::Correct_X/2
    abw_draw_skill_cost(rect, skill)
  end
  def dispose
    super
    @abw_picture.bitmap.dispose
    @abw_picture.dispose
  end
end


#==============================================================================
# ** Window_Message
#------------------------------------------------------------------------------
#  Esta janela de mensagem é usada para exibir textos.
#==============================================================================

class Window_Abw_Message < Window_Message
  #--------------------------------------------------------------------------
  # * Inicialização do objeto
  #--------------------------------------------------------------------------
  def initialize
    super
  end
  #--------------------------------------------------------------------------
  # * Atualização do fundo da janela
  #--------------------------------------------------------------------------
  def update_background
    Akea_Battle_Window::Win_Pic[4] == '' ? super : self.opacity = 0
  end
  #--------------------------------------------------------------------------
  # * Definição de quebra de página
  #     text : texto
  #     pos  : posição
  #--------------------------------------------------------------------------
  def new_page(text, pos)
    super(text, pos)
    create_back_picture
  end
  def create_back_picture
    return if Akea_Battle_Window::Win_Pic[4] == ''
    bitmap = Cache.akea(Akea_Battle_Window::Win_Pic[4])
    rect = Rect.new(0, 0, bitmap.width, bitmap.height)
    contents.blt(0, 0, bitmap, rect, 255)
  end
  #--------------------------------------------------------------------------
  # * Espaçamento lateral padrão
  #--------------------------------------------------------------------------
  def standard_padding
    Akea_Battle_Window::Win_Pic[4] == '' ? 12 : 0
  end
  #--------------------------------------------------------------------------
  # * Aquisição da altura da janela
  #--------------------------------------------------------------------------
  def window_height
    Akea_Battle_Window::Win_Pic[4] == '' ? fitting_height(visible_line_number) : (fitting_height(visible_line_number) + 24)
  end
  #--------------------------------------------------------------------------
  # * Desenho do texto
  #     args : Bitmap.draw_text
  #--------------------------------------------------------------------------
  def draw_text(*args)
    if args[0].is_a?(Integer) && Akea_Battle_Window::Win_Pic[4] != ''
      args[0] += Akea_Battle_Window::Correct_X 
      args[1] += Akea_Battle_Window::Correct_Y
    elsif Akea_Battle_Window::Win_Pic[4] != ''
      args[0].x += Akea_Battle_Window::Correct_X 
      args[0].y += Akea_Battle_Window::Correct_Y 
    end
    contents.draw_text(*args)
  end
end
#==============================================================================
# ** Window_BattleEnemy
#------------------------------------------------------------------------------
#  Esta janela para seleção de inimigos na tela de batalha.
#==============================================================================

class Window_BattleEnemy < Window_Selectable
alias :abw_draw_all_items :draw_all_items
  #--------------------------------------------------------------------------
  # * Inicialização do objeto
  #--------------------------------------------------------------------------
  def initialize(info_viewport)
    Akea_Battle_Window::Win_Pic[3] == '' ? y = 0 : y = 24
    super(0, info_viewport.rect.y, window_width, fitting_height(4) + y)
    refresh
    self.visible = false
    @info_viewport = info_viewport
    self.opacity = 0 unless Akea_Battle_Window::Win_Pic[3] == ''
  end
  #--------------------------------------------------------------------------
  # * Criação da lista de comandos
  #--------------------------------------------------------------------------
  def draw_all_items
    create_back_picture
    abw_draw_all_items
  end
  def create_back_picture
    return if Akea_Battle_Window::Win_Pic[3] == ''
    bitmap = Cache.akea(Akea_Battle_Window::Win_Pic[3])
    rect = Rect.new(0, 0, bitmap.width, bitmap.height)
    contents.blt(0, 0, bitmap, rect, 255)
  end
  #--------------------------------------------------------------------------
  # * Espaçamento lateral padrão
  #--------------------------------------------------------------------------
  def standard_padding
    Akea_Battle_Window::Win_Pic[3] == '' ? 12 : 0
  end
  #--------------------------------------------------------------------------
  # * Aquisição da altura da janela
  #--------------------------------------------------------------------------
  def window_height
    Akea_Battle_Window::Win_Pic[3] == '' ? fitting_height(visible_line_number) : (fitting_height(visible_line_number) + 24)
  end
  #--------------------------------------------------------------------------
  # * Desenho do texto
  #     args : Bitmap.draw_text
  #--------------------------------------------------------------------------
  def draw_text(*args)
    if args[0].is_a?(Integer) && Akea_Battle_Window::Win_Pic[3] != ''
      args[0] += Akea_Battle_Window::Correct_X 
      args[1] += Akea_Battle_Window::Correct_Y
    elsif Akea_Battle_Window::Win_Pic[3] != ''
      args[0].x += Akea_Battle_Window::Correct_X 
      args[0].y += Akea_Battle_Window::Correct_Y 
    end
    contents.draw_text(*args)
  end
  #--------------------------------------------------------------------------
  # * Atualização do cursor
  #--------------------------------------------------------------------------
  def update_cursor
    super
    if $abw_cursor_set
      $abw_cursor_set.x = self.x + item_rect(@index).x + Akea_Battle_Window::Cursor_X
      $abw_cursor_set.y = self.y + item_rect(@index).y + Akea_Battle_Window::Cursor_Y
      $abw_cursor_set.x = Graphics.width if $included[:akea_battlecursor]
    end
  end
end

#==============================================================================
# ** Window_ActorCommand
#------------------------------------------------------------------------------
#  Esta janela é usada para selecionar os comandos do herói na tela de batalha.
#==============================================================================

class Window_ActorCommand < Window_Command
alias :abw_initialize :initialize
alias :abw_deactivate :deactivate
alias :abw_activate :activate
  #--------------------------------------------------------------------------
  # * Inicialização do objeto
  #--------------------------------------------------------------------------
  def initialize
    unless Akea_Battle_Window::Win_Pic[2] == ''
      @abw_picture = Sprite.new
      @abw_picture.bitmap = Cache.akea(Akea_Battle_Window::Win_Pic[2])
    end
    abw_initialize
    self.opacity = 0 unless Akea_Battle_Window::Win_Pic[2] == ''
  end
  #--------------------------------------------------------------------------
  # * Desenho do texto
  #     args : Bitmap.draw_text
  #--------------------------------------------------------------------------
  def draw_text(*args)
    if args[0].is_a?(Integer) && Akea_Battle_Window::Win_Pic[2] != ''
      args[0] += Akea_Battle_Window::Correct_X - 6
      args[1] += Akea_Battle_Window::Correct_Y - 6
    elsif Akea_Battle_Window::Win_Pic[2] != ''
      args[0].x += Akea_Battle_Window::Correct_X - 6
      args[0].y += Akea_Battle_Window::Correct_Y - 6
    end
    contents.draw_text(*args)
  end
  #--------------------------------------------------------------------------
  # * Exibição da janela
  #--------------------------------------------------------------------------
  def open
    super
    if @abw_picture
      @abw_picture.opacity = 255
      @abw_picture.x = self.x
      @abw_picture.y = self.y
    end
  end
  def close
    super
    @abw_picture.opacity = 0 if @abw_picture
  end
  #--------------------------------------------------------------------------
  # * Atualização do cursor
  #--------------------------------------------------------------------------
  def update_cursor
    super
    if $abw_cursor_set
      $abw_cursor_set.x = self.x + Akea_Battle_Window::Cursor_X
      $abw_cursor_set.y = self.y + item_rect(@index - self.top_row).y + Akea_Battle_Window::Cursor_Y
    end
  end
  def deactivate
    abw_deactivate
    self.arrows_visible = false
    self.opacity = 0
    self.contents_opacity = 0
    @abw_picture.opacity = 0 unless Akea_Battle_Window::Win_Pic[2] == ''
  end
  def activate
    abw_activate
    self.arrows_visible = true
    @abw_picture.opacity = 255 unless Akea_Battle_Window::Win_Pic[2] == ''
    self.opacity = 255 if Akea_Battle_Window::Win_Pic[2] == ''
    self.contents_opacity = 255 
  end
  def dispose
    super
    @abw_picture.bitmap.dispose
    @abw_picture.dispose
  end
end

#==============================================================================
# ** Window_PartyCommand
#------------------------------------------------------------------------------
#  Esta janela é usada para se escolher se deseja lutar ou fugir na 
# tela de batalha.
#==============================================================================

class Window_PartyCommand < Window_Command
alias :abw_initialize :initialize
alias :abw_draw_all_items :draw_all_items
  #--------------------------------------------------------------------------
  # * Inicialização do objeto
  #--------------------------------------------------------------------------
  def initialize
    abw_initialize
    self.opacity = 0 unless Akea_Battle_Window::Win_Pic[1] == ''
  end
  #--------------------------------------------------------------------------
  # * Criação da lista de comandos
  #--------------------------------------------------------------------------
  def draw_all_items
    create_back_picture
    abw_draw_all_items
  end
  def create_back_picture
    return if Akea_Battle_Window::Win_Pic[1] == ''
    bitmap = Cache.akea(Akea_Battle_Window::Win_Pic[1])
    rect = Rect.new(0, 0, bitmap.width, bitmap.height)
    contents.blt(0, 0, bitmap, rect, 255)
  end
  #--------------------------------------------------------------------------
  # * Espaçamento lateral padrão
  #--------------------------------------------------------------------------
  def standard_padding
    Akea_Battle_Window::Win_Pic[1] == '' ? 12 : 0
  end
  #--------------------------------------------------------------------------
  # * Aquisição da altura da janela
  #--------------------------------------------------------------------------
  def window_height
    Akea_Battle_Window::Win_Pic[1] == '' ? fitting_height(visible_line_number) : (fitting_height(visible_line_number) + 24)
  end
  #--------------------------------------------------------------------------
  # * Desenho do texto
  #     args : Bitmap.draw_text
  #--------------------------------------------------------------------------
  def draw_text(*args)
    if args[0].is_a?(Integer) && Akea_Battle_Window::Win_Pic[1] != ''
      args[0] += Akea_Battle_Window::Correct_X 
      args[1] += Akea_Battle_Window::Correct_Y
    elsif Akea_Battle_Window::Win_Pic[1] != ''
      args[0].x += Akea_Battle_Window::Correct_X 
      args[0].y += Akea_Battle_Window::Correct_Y 
    end
    contents.draw_text(*args)
  end
  #--------------------------------------------------------------------------
  # * Atualização do cursor
  #--------------------------------------------------------------------------
  def update_cursor
    super
    if $abw_cursor_set
      $abw_cursor_set.x = self.x + Akea_Battle_Window::Cursor_X 
      $abw_cursor_set.y = self.viewport.rect.y + item_rect(@index).y + Akea_Battle_Window::Cursor_Y
    end
  end
end


#==============================================================================
# ** Window_BattleStatus
#------------------------------------------------------------------------------
#  Esta janela exibe as condições de todos membros do grupo na tela de batalha.
#==============================================================================

class Window_BattleStatus < Window_Selectable
alias :abw_initialize :initialize
alias :abw_draw_all_items :draw_all_items
  #--------------------------------------------------------------------------
  # * Inicialização do objeto
  #--------------------------------------------------------------------------
  def initialize
    abw_initialize
    self.opacity = 0 unless Akea_Battle_Window::Win_Pic[0] == ''
  end
  def create_back_picture
    return if Akea_Battle_Window::Win_Pic[0] == ''
    bitmap = Cache.akea(Akea_Battle_Window::Win_Pic[0])
    rect = Rect.new(0, 0, bitmap.width, bitmap.height)
    contents.blt(0, 0, bitmap, rect, 255)
  end
  #--------------------------------------------------------------------------
  # * Espaçamento lateral padrão
  #--------------------------------------------------------------------------
  def standard_padding
    Akea_Battle_Window::Win_Pic[0] == '' ? 12 : 0
  end
  def draw_all_items
    create_back_picture
    abw_draw_all_items
  end
  #--------------------------------------------------------------------------
  # * Aquisição da altura da janela
  #--------------------------------------------------------------------------
  def window_height
    Akea_Battle_Window::Win_Pic[0] == '' ? fitting_height(visible_line_number) : (fitting_height(visible_line_number) + 24)
  end
  #--------------------------------------------------------------------------
  # * Desenho do HP
  #     actor  : herói
  #     x      : coordenada X
  #     y      : coordenada Y
  #     width  : largura
  #--------------------------------------------------------------------------
  def draw_actor_hp(actor, x, y, width = 124)
    if Akea_Battle_Window::Pic[1] == ''
      super(actor, x, y, width = 124)
      return
    end
    x += Akea_Battle_Window::Todos_X + Akea_Battle_Window::HP_X
    y += Akea_Battle_Window::HP_Y + Akea_Battle_Window::Todos_Y
    bitmap = Cache.akea(Akea_Battle_Window::Pic[1])
    rect = Rect.new(0, 0, bitmap.width*actor.hp/actor.mhp, bitmap.height)
    contents.blt(x, y, bitmap, rect, 255)
    bitmap = Cache.akea(Akea_Battle_Window::Pic[0])
    rect = Rect.new(0, 0, bitmap.width, bitmap.height)
    contents.blt(x - Akea_Battle_Window::HP_X, y-Akea_Battle_Window::HP_Y, bitmap, rect, 255)
    x -= Akea_Battle_Window::Todos_X + Akea_Battle_Window::HP_X
    y -= Akea_Battle_Window::HP_Y + Akea_Battle_Window::Todos_Y
    change_color(system_color)
    contents.font.size = Akea_Battle_Window::Fonte
    draw_text(x, y, 30, line_height, Vocab::hp_a) if Akea_Battle_Window::Text
    draw_current_and_max_values(x - 20, y, width, actor.hp, actor.mhp,
    hp_color(actor), normal_color) if Akea_Battle_Window::Num
    contents.font.size = Font.default_size
  end
  #--------------------------------------------------------------------------
  # * Desenho do MP
  #     actor  : herói
  #     x      : coordenada X
  #     y      : coordenada Y
  #     width  : largura
  #--------------------------------------------------------------------------
  def draw_actor_mp(actor, x, y, width = 124)
    if Akea_Battle_Window::Pic[3] == ''
      super(actor, x, y, width = 124)
      return
    end
    x += Akea_Battle_Window::Todos_X + Akea_Battle_Window::MP_X
    y += Akea_Battle_Window::MP_Y + Akea_Battle_Window::Todos_Y
    bitmap = Cache.akea(Akea_Battle_Window::Pic[3])
    rect = Rect.new(0, 0, bitmap.width*actor.mp/actor.mmp, bitmap.height)
    contents.blt(x, y, bitmap, rect, 255)
    bitmap = Cache.akea(Akea_Battle_Window::Pic[2])
    rect = Rect.new(0, 0, bitmap.width, bitmap.height)
    contents.blt(x - Akea_Battle_Window::MP_X, y-Akea_Battle_Window::MP_Y, bitmap, rect, 255)
    x -= Akea_Battle_Window::Todos_X + Akea_Battle_Window::MP_X
    y -= Akea_Battle_Window::MP_Y + Akea_Battle_Window::Todos_Y
    change_color(system_color)
    contents.font.size = Akea_Battle_Window::Fonte
    draw_text(x, y, 30, line_height, Vocab::mp_a) if Akea_Battle_Window::Text
    draw_current_and_max_values(x - 20, y, width, actor.mp, actor.mmp,
    mp_color(actor), normal_color) if Akea_Battle_Window::Num
    contents.font.size = Font.default_size
  end
  #--------------------------------------------------------------------------
  # * Desenho do TP
  #     actor  : herói
  #     x      : coordenada X
  #     y      : coordenada Y
  #     width  : largura
  #--------------------------------------------------------------------------
  def draw_actor_tp(actor, x, y, width = 124)
    if Akea_Battle_Window::Pic[5] == ''
      super(actor, x, y, width = 124)
      return
    end
    x += Akea_Battle_Window::Todos_X + Akea_Battle_Window::TP_X
    y += Akea_Battle_Window::TP_Y + Akea_Battle_Window::Todos_Y
    bitmap = Cache.akea(Akea_Battle_Window::Pic[5])
    rect = Rect.new(0, 0, bitmap.width*actor.tp/100, bitmap.height)
    contents.blt(x, y, bitmap, rect, 255)
    bitmap = Cache.akea(Akea_Battle_Window::Pic[4])
    rect = Rect.new(0, 0, bitmap.width, bitmap.height)
    contents.blt(x - Akea_Battle_Window::TP_X, y-Akea_Battle_Window::TP_Y, bitmap, rect, 255)
    x -= Akea_Battle_Window::Todos_X + Akea_Battle_Window::TP_X
    y -= Akea_Battle_Window::TP_Y + Akea_Battle_Window::Todos_Y
    change_color(system_color)
    contents.font.size = Akea_Battle_Window::Fonte
    draw_text(x, y, 30, line_height, Vocab::tp_a) if Akea_Battle_Window::Text
    draw_text(x + width - 62, y, 42, line_height, actor.tp.to_i, 2) if Akea_Battle_Window::Num
    contents.font.size = Font.default_size
  end
  #--------------------------------------------------------------------------
  # * Desenho do texto
  #     args : Bitmap.draw_text
  #--------------------------------------------------------------------------
  def draw_text(*args)
    if args[0].is_a?(Integer) && Akea_Battle_Window::Win_Pic[0] != ''
      args[0] += Akea_Battle_Window::Correct_X 
      args[1] += Akea_Battle_Window::Correct_Y
    elsif Akea_Battle_Window::Win_Pic[0] != ''
      args[0].x += Akea_Battle_Window::Correct_X 
      args[0].y += Akea_Battle_Window::Correct_Y 
    end
    contents.draw_text(*args)
  end
  #--------------------------------------------------------------------------
  # * Atualização do cursor
  #--------------------------------------------------------------------------
  def update_cursor
    super
    if $abw_cursor_set
      $abw_cursor_set.x = self.x + Akea_Battle_Window::Cursor_X
      $abw_cursor_set.y = self.y + item_rect(@index - self.top_row).y + Akea_Battle_Window::Cursor_Y
      $abw_cursor_set.x = Graphics.width if $included[:akea_battlecursor]
    end
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