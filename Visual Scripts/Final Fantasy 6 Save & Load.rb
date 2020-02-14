#=======================================================
#         Final Fantasy 6 Save/Load
# Autor : Raizen
# Comunidade : www.centrorpg.com
# Save/Load baseado no jogo de GBA Final Fantasy 6
#=======================================================
module RaizenFFSave
# Icone usado para o cursor de decisão"
Icone = 10
# Quantidade de arquivos máximos
Files = 16
end
# Aqui começa o script, apenas mexa se souber o que estiver fazendo.
#==============================================================================
class Game_Party < Game_Unit
  def characters_for_savefile
    battle_members.collect do |actor|
      [actor.character_name, actor.character_index, actor.name, actor.mhp, actor.hp, actor.mmp, actor.mp, actor.class.name, actor.level, actor.face_name]
    end
  end
end



module DataManager
    def self.make_save_header
    header = {}
    header[:characters] = $game_party.characters_for_savefile
    header[:playtime_s] = $game_system.playtime_s
    header[:gold] = $game_party.gold
    header[:steps] = $game_party.steps
    header[:name_display] = $data_mapinfos[$game_map.map_id]
    header
  end
    def self.savefile_max
    return RaizenFFSave::Files
  end
end

#==============================================================================
# ** Scene_File
#------------------------------------------------------------------------------
#  Esta classe executa o processamento da tela de salvar e carregar.
#==============================================================================

class Scene_File < Scene_MenuBase
  #--------------------------------------------------------------------------
  # * Inicialização do processo
  #--------------------------------------------------------------------------
  def start
    super
    @confirmation = true
    @savefile_viewport = Viewport.new
    create_savefile_windows
    init_selection
    @savefiletime = Window_SaveFileFF1.new(@index)
    @savefilemap = Window_SaveFileFF2.new(@index)
    @savefileconfirm = Window_SaveFileFF3.new(@index)
    @savefileconf = Window_SaveFileconfirm.new
    @savefileconf.visible = false
    help_window_text
    @y = 0
  end
  #--------------------------------------------------------------------------
  # * Finalização do processo
  #--------------------------------------------------------------------------
  def terminate
    super
    @savefile_viewport.dispose
    @savefile_windows.each {|window| window.dispose }
  end
  #--------------------------------------------------------------------------
  # * Atualização da tela
  #--------------------------------------------------------------------------
  def update
    super
    @savefile_windows.each {|window| window.update }
    update_savefile_selection
  end
  #--------------------------------------------------------------------------
  # * Criação da janela de ajuda.
  #--------------------------------------------------------------------------
  def create_help_window
    @help_window = Window_Help.new(1)
    @help_window.set_text(help_window_text)
  end
  #--------------------------------------------------------------------------
  # * Aquisição do texto da janela de ajuda
  #--------------------------------------------------------------------------
  def help_window_text
    return ""
  end
  #--------------------------------------------------------------------------
  # * Criação das janelas dos arquivos salvos
  #--------------------------------------------------------------------------
  def create_savefile_windows
    @savefile_windows = Array.new(item_max) do |i|
    Window_SaveFile.new(savefile_height, i)
    end
    @savefile_windows.each {|window| window.viewport = @savefile_viewport }

  end
  #--------------------------------------------------------------------------
  # * Inicialização da seleção
  #--------------------------------------------------------------------------
  def init_selection
    @index = first_savefile_index
    @savefile_windows[@index].selected = true
    self.top_index = @index - visible_max / 2
    ensure_cursor_visible
  end
  #--------------------------------------------------------------------------
  # * Aquisição do número máximo de itens
  #--------------------------------------------------------------------------
  def item_max
    DataManager.savefile_max
  end
  #--------------------------------------------------------------------------
  # * Aquisição do número máximo de arquivos salvos exbidos na tela
  #--------------------------------------------------------------------------
  def visible_max
    return 1
  end
  #--------------------------------------------------------------------------
  # * Aquisição da altura da janela do arquivo salvo.
  #--------------------------------------------------------------------------
  def savefile_height
    @savefile_viewport.rect.height / visible_max
  end
  #--------------------------------------------------------------------------
  # * Aquisição do índice do primeiro arquivo selecionado
  #--------------------------------------------------------------------------
  def first_savefile_index
    return 0
  end
  #--------------------------------------------------------------------------
  # * Aquisição do índice atual
  #--------------------------------------------------------------------------
  def index
    @index
  end
  #--------------------------------------------------------------------------
  # * Aquisição do índice do topo
  #--------------------------------------------------------------------------
  def top_index
    @savefile_viewport.oy / savefile_height
  end
  #--------------------------------------------------------------------------
  # * Definição do índice do topo
  #     index : novo índice
  #--------------------------------------------------------------------------
  def top_index=(index)
    index = 0 if index < 0
    index = item_max - visible_max if index > item_max - visible_max
    @savefile_viewport.oy = index * savefile_height
  end
  #--------------------------------------------------------------------------
  # * Aquisição do último índice
  #--------------------------------------------------------------------------
  def bottom_index
    top_index + visible_max - 1
  end
  #--------------------------------------------------------------------------
  # * Definição do último índice
  #     index : novo índice
  #--------------------------------------------------------------------------
  def bottom_index=(index)
    self.top_index = index - (visible_max - 1)
  end
  #--------------------------------------------------------------------------
  # * Atualização da seleção dos arquivos salvos
  #--------------------------------------------------------------------------
  def update_savefile_selection
    return on_savefile_ok     if Input.trigger?(:C)
    return on_savefile_cancel if Input.trigger?(:B)
    update_cursor
  end
  #--------------------------------------------------------------------------
  # * Salvando o arquivo [Confirmação]
  #--------------------------------------------------------------------------
  def on_savefile_ok
  end
  #--------------------------------------------------------------------------
  # * Salvando o arquivo [Cancelamento]
  #--------------------------------------------------------------------------
  def on_savefile_cancel
    Sound.play_cancel
    if @confirmation
    return_scene
  else
    @confirmation = true
    @savefileconfirm.visible = true
    @savefileconf.visible = false
    @helpwindow.visible = true
    @y = 0
    end
  end
  #--------------------------------------------------------------------------
  # * Atualização do cursor
  #--------------------------------------------------------------------------
  def update_cursor
  if @confirmation 
    last_index = @index
    cursor_down (Input.trigger?(:DOWN))  if Input.repeat?(:DOWN)
    cursor_up   (Input.trigger?(:UP))    if Input.repeat?(:UP)
    cursor_up (Input.trigger?(:LEFT))  if Input.repeat?(:LEFT)
    cursor_down   (Input.trigger?(:RIGHT))    if Input.repeat?(:RIGHT)
    cursor_pagedown   if Input.trigger?(:R)
    cursor_pageup     if Input.trigger?(:L)
    if @index != last_index
      Sound.play_cursor
      @savefiletime.refresh(@index)
      @savefilemap.refresh(@index)
      @savefileconfirm.refresh(@index)
      @savefile_windows[last_index].selected = false
      @savefile_windows[@index].selected = true
    end
  else
    cursor_movedown if Input.trigger?(:DOWN)
    cursor_moveup   if Input.trigger?(:UP)
    end
  end
  def cursor_movedown
  Sound.play_cursor
  @y = 0
  @savefileconf.refresh(@index, @n, @y)
  end
  def cursor_moveup
  Sound.play_cursor
  @y = 1
  @savefileconf.refresh(@index, @n, @y)
  end
  #--------------------------------------------------------------------------
  # * Movimento do cursor para baixo
  #     wrap : cursor retornar a primeira ou ultima posição
  #--------------------------------------------------------------------------
  def cursor_down(wrap)
    @index = (@index + 1) % item_max if @index < item_max - 1 || wrap
    ensure_cursor_visible
  end
  #--------------------------------------------------------------------------
  # * Movimento do cursor para cima
  #     wrap : cursor retornar a primeira ou ultima posição
  #--------------------------------------------------------------------------
  def cursor_up(wrap)
    @index = (@index - 1 + item_max) % item_max if @index > 0 || wrap
    ensure_cursor_visible
  end
  #--------------------------------------------------------------------------
  # * Movimento do cursor uma página abaixo
  #--------------------------------------------------------------------------
  def cursor_pagedown
    if top_index + visible_max < item_max
      self.top_index += visible_max
      @index = [@index + visible_max, item_max - 1].min
    end
  end
  #--------------------------------------------------------------------------
  # * Movimento do cursor uma página acima
  #--------------------------------------------------------------------------
  def cursor_pageup
    if top_index > 0
      self.top_index -= visible_max
      @index = [@index - visible_max, 0].max
    end
  end
  #--------------------------------------------------------------------------
  # * Confirmação de visibilidade do cursor
  #--------------------------------------------------------------------------
  def ensure_cursor_visible
    self.top_index = index if index < top_index
    self.bottom_index = index if index > bottom_index
  end
end

#==============================================================================
# ** Scene_Save
#------------------------------------------------------------------------------
#  Esta classe executa o processamento da tela de salvar.
#==============================================================================

class Scene_Save < Scene_File
  #--------------------------------------------------------------------------
  # * Aquisição do texto da janela de ajuda
  #--------------------------------------------------------------------------
  def help_window_text
    @helpwindow = Window_SaveFilehelp.new(0)
  end
  #--------------------------------------------------------------------------
  # * Aquisição do índice do primeiro arquivo selecionado
  #--------------------------------------------------------------------------
  def first_savefile_index
    DataManager.last_savefile_index
  end
  #--------------------------------------------------------------------------
  # * Definição de arquivo salvo
  #--------------------------------------------------------------------------
  def on_savefile_ok
    super
    if @confirmation == false or DataManager.load_header(@index) == nil
    if @y == 1 or DataManager.load_header(@index) == nil
    if DataManager.save_game(@index)
      on_save_success
    else
      Sound.play_buzzer
    end
  else
    on_savefile_cancel
    end
  else
    Sound.play_save
    @savefileconfirm.visible = false
    @helpwindow.visible = false
    @savefileconf.visible = true
    @n = 1
    @savefileconf.refresh(@index, 1, 0)
    @confirmation = false
  end
  end
  #--------------------------------------------------------------------------
  # * Processo de salvar aquivo bem sucedido
  #--------------------------------------------------------------------------
  def on_save_success
    Sound.play_save
    return_scene
  end
end

#==============================================================================
# ** Scene_Load
#------------------------------------------------------------------------------
#  Esta classe executa o processamento da tela de carregar.
#==============================================================================

class Scene_Load < Scene_File
  #--------------------------------------------------------------------------
  # * Aquisição do texto da janela de ajuda
  #--------------------------------------------------------------------------
  def help_window_text
    @helpwindow = Window_SaveFilehelp.new(1)
  end
  #--------------------------------------------------------------------------
  # * Aquisição do índice do primeiro arquivo selecionado
  #--------------------------------------------------------------------------
  def first_savefile_index
    DataManager.latest_savefile_index
  end
  #--------------------------------------------------------------------------
  # * Definição de arquivo salvo
  #--------------------------------------------------------------------------
  def on_savefile_ok
    super
  if @confirmation == false 
    if @y == 0 
    on_savefile_cancel
    else
    if DataManager.load_game(@index)
      on_load_success
    else
      Sound.play_buzzer
    end
    end
  elsif @confirmation and DataManager.load_header(@index) != nil
    Sound.play_save
    @savefileconfirm.visible = false
    @helpwindow.visible = false
    @savefileconf.visible = true
    @n = 0
    @savefileconf.refresh(@index, 0, 0)
    @confirmation = false
  elsif DataManager.load_header(@index) == nil
    Sound.play_buzzer
  end
  end
  #--------------------------------------------------------------------------
  # * Processo de carregamento aquivo bem sucedido
  #--------------------------------------------------------------------------
  def on_load_success
    Sound.play_load
    fadeout_all
    $game_system.on_after_load
    SceneManager.goto(Scene_Map)
  end
end


#==============================================================================
# ** Window_SaveFile
#------------------------------------------------------------------------------
# Esta janela exibe os arquivos salvos nas telas de salvar e carregar.
#==============================================================================

class Window_SaveFile < Window_Base
  #--------------------------------------------------------------------------
  # * Variáveis públicas
  #--------------------------------------------------------------------------
  attr_reader   :selected                 # Estado da seleção
  #--------------------------------------------------------------------------
  # * Inicialização do objeto
  #     height : altura
  #     index  : índice do arquivo salvo
  #--------------------------------------------------------------------------
  def initialize(height, index)
    super(0, index * height, Graphics.width, height)
    @file_index = index
    refresh
    @selected = false
  end
  #--------------------------------------------------------------------------
  # * Renovação
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    draw_party_characters(0, 0)

  end
  #--------------------------------------------------------------------------
  # * Desenho dos personagens do grupo
  #     x : coordenada X
  #     y : coordenada Y
  #--------------------------------------------------------------------------
  def draw_party_characters(x, y)
    header = DataManager.load_header(@file_index)
    return unless header
    header[:characters].each_with_index do |data, i|
      draw_face(data[9], data[1], x, y + i * 100)
      contents.font.color = text_color(0)
      draw_text(100, -5 + i * 67, 110, 20 + i * 67, data[2] , 0)
      draw_text(210, -5 + i * 67, 110, 20 + i * 67, data[7] , 0)
      draw_text(240, 28 + i * 67, 40, 53 + i * 67, data[3] , 2)
      draw_text(230, 28 + i * 67, 50, 53 + i * 67, "/" , 0)
      draw_text(190, 28 + i * 67, 40, 53 + i * 67, data[4] , 2)
      draw_text(240, 41 + i * 67, 40, 66 + i * 67, data[5] , 2)
      draw_text(230, 41 + i * 67, 50, 66 + i * 67, "/" , 0)
      draw_text(190, 41 + i * 67, 40, 66 + i * 67, data[6] , 2)
      draw_text(190, 15 + i * 67, 40, 40 + i * 67, data[8] , 2)
      contents.font.color = text_color(1)
      draw_text(130, 15 + i * 67, 50, 40 + i * 67, "Level" , 1)
      draw_text(130, 28 + i * 67, 40, 53 + i * 67, "HP" , 1)
      draw_text(130, 41 + i * 67, 40, 66 + i * 67, "MP" , 1)
    end
  end
  #--------------------------------------------------------------------------
  # * Desenho do tempo de jogo
  #     x     : coordenada X
  #     y     : coordenada Y
  #     width : largura
  #     align : alinhamento
  #--------------------------------------------------------------------------
    
  #--------------------------------------------------------------------------
  # * Definição de estado da seleção
  #     selected : estado da seleção
  #--------------------------------------------------------------------------
  def selected=(selected)
    @selected = selected
  end
  #--------------------------------------------------------------------------
  # * Atualização do cursor
  #--------------------------------------------------------------------------
 
end
class Window_SaveFileFF1 < Window_Base
  def initialize(i)
    super(354, 300, 190, 116)
    refresh(i)
    @selected = false
  end
  def refresh(i)
    contents.clear
    contents.font.color = text_color(1)
    draw_text(0, 0, 100, 40, "Tempo" , 0)
    draw_text(0, 30, 100, 40, "Passos" , 0)
    draw_text(0, 60, 100, 40, "G" , 0)
    contents.font.color = text_color(0)
    gold(i)
    steps(i)
    draw_playtime(i)
  end
  def draw_playtime(i)
    header = DataManager.load_header(i)
    return unless header
    draw_text(115, 0, 140, 40, header[:playtime_s], 0)
  end
    def gold(i)
    header = DataManager.load_header(i)
    return unless header
    draw_text(80, 60, 87, 40, header[:gold], 2)
  end
    def steps(i)
    header = DataManager.load_header(i)
    return unless header
    draw_text(80, 30, 87, 40, header[:steps], 2)
  end
    def selected=(selected)
    @selected = selected
  end
end

class Window_SaveFileFF2 < Window_Base
  def initialize(i)
    super(354, 220, 190, 80)
    refresh(i)
    @selected = false
  end
  def refresh(i)
    contents.clear
    contents.font.color = text_color(0)
    map_name(i)
  end
  def map_name(i)
    header = DataManager.load_header(i)
    return unless header
    draw_text(10, 0, 180, 60, header[:name_display].name, 0)
  end
    def selected=(selected)
    @selected = selected
  end
end

class Window_SaveFileFF3 < Window_Base
  def initialize(i)
    super(354, 70, 190, 150)
    refresh(i)
    @selected = false
  end
  def refresh(index)
    contents.clear
    contents.font.color = text_color(0)
    contents.font.size = 30
    draw_text(10, 40, 120, 60, "Z", 0)
    draw_text(10, 80, 120, 60, "X", 0)
    contents.font.size = Font.default_size
    draw_text(40, 40, 120, 60, "Confirma", 0)
    draw_text(40, 80, 120, 60, "Volta", 0)
    draw_text(0, 0, 180, 60, "Arquivo", 0)
    draw_text(0, 0, 120, 60, index + 1, 2)
    draw_text(125, 0, 120, 60, "/", 0)
    draw_text(135, 0, 120, 60, DataManager.savefile_max, 0)
  end
    def selected=(selected)
    @selected = selected
  end
end

class Window_SaveFilehelp < Window_Base
  def initialize(n)
    super(354, 0, 190, 70)
    n == 1 ? (draw_text(-10, 0, 190, 50, "Carregar Jogo", 1)) :  draw_text(-10, 0, 190, 50, "Salvar Jogo", 1) 
  end
end

class Window_SaveFileconfirm < Window_Base
  def initialize
    super(354, 0, 190, 220)
  end
  def refresh(index, n, y)
    contents.clear
    contents.font.color = text_color(6)
    if n == 1
    draw_text(0, 60, 180, 60, "Reescrever esse", 0)
    draw_text(0, 80, 180, 60, "Arquivo Salvo?", 0)
    elsif n == 0
    draw_text(0, 60, 180, 60, "Carregar esse", 0)
    draw_text(0, 80, 180, 60, "Arquivo Salvo?", 0)
  end
    contents.font.color = text_color(0)
    draw_text(40, 120, 180, 60, "Sim", 0)
    draw_text(40, 140, 180, 60, "Não", 0)
    y == 0 ? (draw_icon(RaizenFFSave::Icone, 10, 156)) :  draw_icon(RaizenFFSave::Icone, 10, 135)
    draw_text(0, 0, 180, 60, "Arquivo", 0)
    draw_text(0, 0, 120, 60, index + 1, 2)
    draw_text(125, 0, 120, 60, "/", 0)
    draw_text(135, 0, 120, 60, DataManager.savefile_max, 0)
  end
end