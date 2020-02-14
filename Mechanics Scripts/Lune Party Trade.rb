#=======================================================
#         Lune Party Trade
# Autor: Raizen
# Comunidade: www.centrorpg.com
# Janela de troca de membros do grupo por membros reservas,
# função presente em vários FFs, e no chrono trigger.
#=======================================================

#==============================================================================
#------------------------------ Instruções ------------------------------------
#==============================================================================

# Para adicionar um personagem na reserva.

# Chamar Script: add_reserve(id)
# id é o id do personagem no database.


# Para retirar um personagem da reserva.

# Chamar Script: remove_reserve(id)
# id é o id do personagem no database.


# Para bloquear um personagem de sair do grupo.
# Chamar Script: lock_char(id)
# id é o id do personagem no database.


# Para desbloquear um personagem e permitir a saída do grupo.
# Chamar Script: lock_char(-id)
# id é o id do personagem no database, basta colocar o valor em negativo do id
# do personagem.


# Para Chamar o Script manualmente.

# Chamar Script: SceneManager.call(Scene_Party_Exchange)

#==============================================================================
#----------------------------- Configuração -----------------------------------
#==============================================================================

module Lune_Party_Trade
# Número máximo de personagens no grupo
Max_party = 4
# Memorizar automaticamente os personagens que passaram pela party?
# true = sim, false = não.
Memorize = true

# Chamar o script automaticamente caso a party esteja completa, e
# for ativado o comando de adicionar membros no grupo?
Automatic = true

#==============================================================================
#----------------------------- Vocabulário ------------------------------------
#==============================================================================
# Coloque o vocabulário sempre entre '' aspas, "".
# Status
Status = 'Status'
# Dispor membro
Dispose = 'Dispor Membro'
# Incluir Membro
Include_Char = 'Incluir'
# Membros no Grupo
Group_Members = 'Membros do Grupo'
# Membros Reservas
Group_Reserve = 'Membros fora do Grupo'
end

#==============================================================================
#==============================================================================
# Inicio do Script, modifique apenas caso saiba o que está acontecendo!
#==============================================================================
#==============================================================================

#==============================================================================
# ** Scene_Party_Exchange
#------------------------------------------------------------------------------
#  Esta classe executa o processamento da tela de troca de membros do grupo.
#==============================================================================

class Scene_Party_Exchange < Scene_Base
  #--------------------------------------------------------------------------
  # * Inicialização do processo
  #--------------------------------------------------------------------------
  def start
    super
    @up_index = -1
    create_all_windows
  end
  #--------------------------------------------------------------------------
  # * Criação e configuração das janelas
  #--------------------------------------------------------------------------
  def create_all_windows
    @help = Help_exch.new
    @up_window = Upper_exch.new
    @down_window = Down_exch.new
    @choose_window = Window_chose_char.new
    @choose_window.set_handler(:change_member, method(:command_change_member))
    @choose_window.set_handler(:dispose_member, method(:command_dispose_member))
    @choose_window.close
    @chooser_window = Window_reserve_char.new
    @chooser_window.set_handler(:change_member, method(:command_change_member))
    @chooser_window.set_handler(:include_member, method(:command_include_member))
    @chooser_window.close
    @up_window.activate
  end
  #--------------------------------------------------------------------------
  # * Status Window
  #--------------------------------------------------------------------------
  def command_change_member
    @actor = $game_actors[@up_index]
    SceneManager.call(Scene_Status_Trade)
    SceneManager.scene.prepare(@up_index)
  end
  #--------------------------------------------------------------------------
  # * Retirar membro do grupo
  #--------------------------------------------------------------------------
  def command_dispose_member
    if $game_party.members.size == 1 || $game_party.locked_chars.include?(@up_index)
      Sound.play_buzzer 
    else
      @up_window.index -= 1
      $game_party.remove_actor(@up_index)
      @up_index -= 1
      Sound.play_ok
      @up_window.refresh
      @down_window.refresh
    end
      @choose_window.close
      @up_window.activate
    end
  #--------------------------------------------------------------------------
  # * Adicionar membro no grupo
  #--------------------------------------------------------------------------
  def command_include_member
    if $game_party.members.size == $game_party.max_party_size
      Sound.play_buzzer 
    else
      @down_window.index -= 1
      $game_party.add_actor(@up_index)
      @up_index -= 1
      Sound.play_ok
      @down_window.refresh
      @up_window.refresh
    end
      @chooser_window.close
      @down_window.activate
    end
  #--------------------------------------------------------------------------
  # * Atualização do Processo
  #--------------------------------------------------------------------------
  def update
    super
    if Input.trigger?(:B)
      Sound.play_cancel
      if @chooser_window.open?
        @chooser_window.close
        @down_window.activate
        @up_window.deactivate
        return 
      end
      if @choose_window.open?
        @choose_window.close
        @up_window.activate
        @down_window.deactivate
        return
      end
      SceneManager.goto(Scene_Map)
    end
    if @up_window.active
      if Input.trigger?(:C)
        @up_window.deactivate
        @choose_window.open
        @choose_window.activate
      end
      unless @up_index == @up_window.char_index
        @up_index = @up_window.char_index
        @help.refresh(@up_index)
      end
      if Input.trigger?(:DOWN)
        @up_window.deactivate
        @down_window.activate
      end
    end
    if @down_window.active
      if Input.trigger?(:C)
        @down_window.deactivate
        @chooser_window.open
        @chooser_window.activate
      end
      unless @up_index == @down_window.char_index
        @up_index = @down_window.char_index
        @help.refresh(@up_index)
      end
    end
    if Input.trigger?(:UP) && @down_window.row == 0
      @down_window.deactivate
      @up_window.activate
    end
  end
  #--------------------------------------------------------------------------
  # * Finalização do processo
  #--------------------------------------------------------------------------
  def terminate
    super
    @help.dispose
    @up_window.dispose
    @down_window.dispose
  end
end
#==============================================================================
# ** Help_exch
#------------------------------------------------------------------------------
#  Esta janela lida com a informação de cada personagem
#==============================================================================
class Help_exch < Window_Base
  #--------------------------------------------------------------------------
  # * Inicialização do processo
  #--------------------------------------------------------------------------
  def initialize
    super(0, 0, Graphics.width, 80)
  end
  #--------------------------------------------------------------------------
  # * Renovação do processo
  #--------------------------------------------------------------------------
  def refresh(index)
    contents.clear
    return if index == nil
    @actor = $game_actors[index]
    draw_actor_face(@actor, 8, 0)
    draw_actor_name(@actor, 110, 0)
    draw_actor_class(@actor, 220, 0)
    draw_actor_nickname(@actor, 110, line_height)
    draw_actor_level(@actor, 460, line_height * 0)
    draw_actor_hp(@actor, 320, line_height * 1)
    draw_actor_mp(@actor, 320, line_height * 0)
  end
end


#==============================================================================
# ** Upper_exch
#------------------------------------------------------------------------------
#  Esta janela lida com seleção geral de comandos para escolha do personagem
#==============================================================================

class Upper_exch < Window_Selectable
  #--------------------------------------------------------------------------
  # * Inicialização do processo
  #--------------------------------------------------------------------------
  def initialize
    # Declaração de variáveis
    @max_height = 1
    @max_width = 1
    @character_index = Array.new
    super(0, 80, Graphics.width, height_window)
    @index = 0
    refresh
  end
  #--------------------------------------------------------------------------
  # * Indíce do personagem
  #-------------------------------------------------------------------------- 
  def char_index
    @character_index[@index]
  end
  #--------------------------------------------------------------------------
  # * Atualização de gráficos
  #-------------------------------------------------------------------------- 
  def refresh
    contents.clear
    @character_index.clear
    contents.font.color = text_color(1)
    draw_text(0, height_window - 60, width_window, line_height, Lune_Party_Trade::Group_Members, 1)
    contents.font.color = text_color(0)
    for n in 0...$game_party.members.size
      a = $game_party.members[n]
      draw_character(a.character_name, a.character_index, width_space*n + 40, 50)
      @character_index << a.id
    end
  end
  #--------------------------------------------------------------------------
  # * Altura da Janela
  #--------------------------------------------------------------------------
  def height_window
    (Graphics.height - 80)/3
  end
  #--------------------------------------------------------------------------
  # * Largura da Janela
  #--------------------------------------------------------------------------
  def width_window
    Graphics.width
  end
  #--------------------------------------------------------------------------
  # * Espaçamento entre personagens
  #--------------------------------------------------------------------------
  def width_space
    width_window / $game_party.max_party_size - 5
  end
  #--------------------------------------------------------------------------
  # * Aquisição do número máximo de itens
  #--------------------------------------------------------------------------
  def item_max
    return $game_party.members.size
  end
  #--------------------------------------------------------------------------
  # * Aquisição do número de colunas
  #--------------------------------------------------------------------------
  def col_max
    return $game_party.max_party_size
  end
  #--------------------------------------------------------------------------
  # * Aquisição de altura do item
  #--------------------------------------------------------------------------
  def item_height
    @max_height + 20
  end
  
  #--------------------------------------------------------------------------
  # * Atualização do cursor
  #--------------------------------------------------------------------------
  def update_cursor
    if @cursor_all
      cursor_rect.set(0, 0, @max_width, row_max * item_height)
      self.top_row = 0
    elsif @index < 0
      cursor_rect.empty
    else
      ensure_cursor_visible
      cursor_rect.set(@index * width_space + 20, 10, @max_width + 10, item_height)
    end
  end
  #--------------------------------------------------------------------------
  # * Cálculo do número de linhas
  #--------------------------------------------------------------------------
  def row_max
    1
  end
  #--------------------------------------------------------------------------
  # * Desenho do gráfico do personagem
  #     character_name  : nome do gráfico do personagem
  #     character_index : índice do gráfico de personagem
  #     x               : coordenada X
  #     y               : coordenada Y
  #--------------------------------------------------------------------------
  def draw_character(character_name, character_index, x, y)
    return unless character_name
    bitmap = Cache.character(character_name)
    sign = character_name[/^[\!\$]./]
    if sign && sign.include?('$')
      cw = bitmap.width / 3
      ch = bitmap.height / 4
    else
      cw = bitmap.width / 12
      ch = bitmap.height / 8
    end
    n = character_index
    src_rect = Rect.new((n%4*3+1)*cw, (n/4*4)*ch, cw, ch)
    contents.blt(x - cw / 2, y - ch, bitmap, src_rect)
    @max_height = ch unless @max_height > ch
    @max_width = cw unless @max_width > cw
  end
end



#==============================================================================
# ** Down_exch
#------------------------------------------------------------------------------
#  Esta janela lida com seleção geral de comandos para escolha do personagem
#==============================================================================

class Down_exch < Window_Selectable
  #--------------------------------------------------------------------------
  # * Inicialização do Processo
  #--------------------------------------------------------------------------
  def initialize
    # Declaração de variáveis
    @max_height = 1
    @max_width = 1
    @character_index = Array.new
    super(0, 80 + (Graphics.height - 80)/3, Graphics.width, height_window)
    @index = 0
    refresh
  end
  #--------------------------------------------------------------------------
  # * Altura da Janela
  #--------------------------------------------------------------------------
  def height_window
    ((Graphics.height - 80)*2)/3
  end
  #--------------------------------------------------------------------------
  # * Indíce do personagem
  #-------------------------------------------------------------------------- 
  def char_index
    @character_index[@index]
  end
  #--------------------------------------------------------------------------
  # * Atualização de gráficos
  #-------------------------------------------------------------------------- 
  def refresh
    contents.clear
    @character_index.clear
    contents.font.color = text_color(2)
    draw_text(0, height_window - 70, width_window, line_height, Lune_Party_Trade::Group_Reserve, 1)
    contents.font.color = text_color(0)
    return if $game_party.reserve_actors.size == 0
    for n in 0...$game_party.reserve_actors.size
      a = $game_party.reserve_actors[n]
      b = $game_actors[a]
      draw_character(b.character_name, b.character_index, width_space*n + 40, 60)
      @character_index << a
    end
  end
  #--------------------------------------------------------------------------
  # * Largura da Janela
  #--------------------------------------------------------------------------
  def width_window
    Graphics.width
  end
  #--------------------------------------------------------------------------
  # * Espaçamento entre personagens
  #--------------------------------------------------------------------------
  def width_space
    width_window / ($data_actors.size / 2) - 5
  end
  #--------------------------------------------------------------------------
  # * Aquisição do número máximo de itens
  #--------------------------------------------------------------------------
  def item_max
    return $game_party.reserve_actors.size
  end
  #--------------------------------------------------------------------------
  # * Aquisição do número de colunas
  #--------------------------------------------------------------------------
  def col_max
    return $data_actors.size / 2
  end
  #--------------------------------------------------------------------------
  # * Aquisição de altura do item
  #--------------------------------------------------------------------------
  def item_height
    @max_height + 20
  end
  
  #--------------------------------------------------------------------------
  # * Atualização do cursor
  #--------------------------------------------------------------------------
  def update_cursor
    if @cursor_all
      cursor_rect.set(0, 0, @max_width, row_max * item_height)
      self.top_row = 0
    elsif @index < 0
      cursor_rect.empty
    else
      ensure_cursor_visible
      index = @index
      index -= col_max if index >= col_max
      cursor_rect.set(index * width_space + 20, 20 + item_height * row, @max_width + 10, item_height)
    end
  end
  #--------------------------------------------------------------------------
  # * Cálculo do número de linhas
  #--------------------------------------------------------------------------
  def row_max
    2
  end
  #--------------------------------------------------------------------------
  # * Desenho do gráfico do personagem
  #     character_name  : nome do gráfico do personagem
  #     character_index : índice do gráfico de personagem
  #     x               : coordenada X
  #     y               : coordenada Y
  #--------------------------------------------------------------------------
  def draw_character(character_name, character_index, x, y)
    return unless character_name
    bitmap = Cache.character(character_name)
    sign = character_name[/^[\!\$]./]
    if sign && sign.include?('$')
      cw = bitmap.width / 3
      ch = bitmap.height / 4
    else
      cw = bitmap.width / 12
      ch = bitmap.height / 8
    end
    n = character_index
    src_rect = Rect.new((n%4*3+1)*cw, (n/4*4)*ch, cw, ch)
    contents.blt(x - cw / 2, y - ch, bitmap, src_rect)
    @max_height = ch unless @max_height > ch
    @max_width = cw unless @max_width > cw
  end
end


#==============================================================================
# ** Window_chose_char
#------------------------------------------------------------------------------
#  Esta janela lida com seleção geral de comandos para escolha do personagem
#==============================================================================
class Window_chose_char < Window_Command
include Lune_Party_Trade
  #--------------------------------------------------------------------------
  # * Inicio de processo
  #--------------------------------------------------------------------------
  def initialize
    super(0, 0)
    self.x = center_x
    self.y = center_y
  end
  #--------------------------------------------------------------------------
  # * Centralizar em x
  #--------------------------------------------------------------------------
  def center_x
    (Graphics.width - self.width)/2
  end
  #--------------------------------------------------------------------------
  # * Centralizar em y
  #--------------------------------------------------------------------------
  def center_y
    (Graphics.height - self.height)/2
  end
  #--------------------------------------------------------------------------
  # * Criação da lista de comandos
  #--------------------------------------------------------------------------
  def make_command_list
    add_command(Status, :change_member)
    add_command(Dispose, :dispose_member)
  end
end


#==============================================================================
# ** Window_Command
#------------------------------------------------------------------------------
#  Esta janela lida com seleção geral de comandos.
#==============================================================================
class Window_reserve_char < Window_Command
include Lune_Party_Trade
  #--------------------------------------------------------------------------
  # * Inicio de processo
  #--------------------------------------------------------------------------
  def initialize
    super(0, 0)
    self.x = center_x
    self.y = center_y
  end
  #--------------------------------------------------------------------------
  # * Centralizar em x
  #--------------------------------------------------------------------------
  def center_x
    (Graphics.width - self.width)/2
  end
  #--------------------------------------------------------------------------
  # * Centralizar em y
  #--------------------------------------------------------------------------
  def center_y
    (Graphics.height - self.height)/2
  end
  #--------------------------------------------------------------------------
  # * Criação da lista de comandos
  #--------------------------------------------------------------------------
  def make_command_list
    add_command(Status, :change_member)
    add_command(Include_Char, :include_member)
  end
end

#==============================================================================
# ** Game_Party
#------------------------------------------------------------------------------
#  Esta classe gerencia o grupo. Contém informações sobre dinheiro, itens.
# A instância desta classe é referenciada por $game_party.
#==============================================================================

class Game_Party < Game_Unit
alias :lune_add_actor :add_actor
alias :lune_initi_initialize :initialize
alias :lune_remv_actor :remove_actor
attr_accessor :locked_chars
attr_accessor :reserve_actors
  #--------------------------------------------------------------------------
  # * Inicialização do objeto
  #--------------------------------------------------------------------------
  def initialize(*args, &block)
    lune_initi_initialize(*args, &block)
    @reserve_actors = []
    @locked_chars = []
  end
  #--------------------------------------------------------------------------
  # * Adição do herói
  #     actor_id : ID do herói
  #--------------------------------------------------------------------------
  def add_actor(actor_id)
    if @actors.size >= max_party_size
      @reserve_actors.push(actor_id) unless @reserve_actors.include?(actor_id)
      SceneManager.call(Scene_Party_Exchange) if Lune_Party_Trade::Automatic
      return
    end
    @reserve_actors.delete(actor_id)
    lune_add_actor(actor_id)
  end
  #--------------------------------------------------------------------------
  # * Valor máximo de personagens dentro do grupo
  #--------------------------------------------------------------------------
  def max_party_size
    return Lune_Party_Trade::Max_party
  end
  #--------------------------------------------------------------------------
  # * Remoção do herói
  #     actor_id : ID do herói
  #--------------------------------------------------------------------------
  def remove_actor(actor_id)
    if Lune_Party_Trade::Memorize
      @reserve_actors.push(actor_id) unless @reserve_actors.include?(actor_id)
    end
    lune_remv_actor(actor_id)
  end
end


#==============================================================================
# ** Scene_Status
#------------------------------------------------------------------------------
#  Esta classe executa o processamento da tela de atributos.
#==============================================================================

class Scene_Status_Trade < Scene_MenuBase
  #--------------------------------------------------------------------------
  # * Inicialização do processo
  #--------------------------------------------------------------------------
  def start
    super
  end
  def prepare(actor)
    @status_window = Window_Status.new($game_actors[actor])
    @status_window.set_handler(:cancel,   method(:return_scene))
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
# ** Game_Interpreter
#------------------------------------------------------------------------------
#  Um interpretador para executar os comandos de evento. Esta classe é usada
# internamente pelas classes Game_Map, Game_Troop e Game_Event.
#==============================================================================

class Game_Interpreter
  #--------------------------------------------------------------------------
  # * Adiciona um herói na reserva
  #--------------------------------------------------------------------------
  def add_reserve(id)
    $game_party.reserve_actors.push(id) unless $game_party.reserve_actors.include?(id) || $game_party.members.include?($game_actors[id])
  end
  #--------------------------------------------------------------------------
  # * Remove o herói na reserva
  #--------------------------------------------------------------------------
  def remove_reserve(id)
    $game_party.reserve_actors.delete(id)
  end
  #--------------------------------------------------------------------------
  # * Bloqueia um personagem de ser removido
  #--------------------------------------------------------------------------
  def lock_char(id)
    if id > 0
      $game_party.locked_chars << id unless $game_party.locked_chars.include?(id)
    else
      $game_party.locked_chars.delete(id.abs)
    end
  end
end
