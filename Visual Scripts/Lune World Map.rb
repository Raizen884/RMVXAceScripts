#=======================================================
#        Lune World Map
# Autor: Raizen
# Comunidade: www.centrorpg.com
# Compatibilidade: RMVXAce

# Adiciona um World map no jogo, para ativar basta
# Chamar Script: Scene_Manager.call(Scene_Lune_Map)
#=======================================================

module Lune_Map
# Apenas visualizar?
# Você pode usar o World Map como "transporte", para 
# o personagem ir ao local escolhido, ou pode utilizar
# como apenas visualização.
# true = apenas visualizar, false = World mapa com teleporte
Visualizar = false
# Coloque aqui o Arquivo com o nome do mapa.
# sempre entre aspas. Map_Name "nomedomapa"
Map_Name = "Mapa"
# Nome do Cursor
Map_Cursor = "Cursor"
# Correção em X do cursor
Cursor_X = 50
# Correção em Y do cursor
Cursor_Y = 10
Map_Info = Array.new
# Siga as instruções abaixo para entender como criar e como funciona o world map
  #=========================================================================
  # Map_Info[0] => Mapa da grande cidade                                  
  #=========================================================================
   Map_Info[0] = {
   # Nome do Mapa
   "Name"      => 'Cidade',
   # Switch que ativa esse mapa no World_Map
   "Switch"    => 1,
   # Posição do ícone no mapa [posição em X, posição em Y]
  "Position"   => [0, 0],
   # Mapa, posição em que será movido o personagem desse modo.
   # 'Map_id' = [Id do mapa, posição em X, posição em Y]
  "Map_id"     => [2, 10, 1],
   # Nome do arquivo de imagem que aparecerá no World Map.
  "Icon"       => 'Map_icon',    
   # Descrição 1 do mapa, primeira linha, sempre entre aspas
   "Desc"      => 'A cidade mais populosa que existe',
   # Descrição 2 do mapa, segunda linha, sempre entre aspas
   "Desc2"     => ''} 
  
  #=========================================================================
  # Map_Info[1] => Mapa da floresta                                
  #=========================================================================
   Map_Info[1] = {
   # Nome do Mapa
   "Name"      => 'Floresta',
   # Switch que ativa esse mapa no World_Map
   "Switch"    => 2,
   # Posição do ícone no mapa [posição em X, posição em Y]
  "Position"   => [100, 350],
   # Mapa, posição em que será movido o personagem desse modo.
   # 'Map_id' = [Id do mapa, posição em X, posição em Y]
  "Map_id"     => [2, 8, 12],
   # Nome do arquivo de imagem que aparecerá no World Map.
  "Icon"       => 'Map_icon',    
   # Descrição 1 do mapa, primeira linha, sempre entre aspas
   "Desc"      => 'Floresta perigosa e escura',
   # Descrição 2 do mapa, segunda linha, sempre entre aspas
   "Desc2"     => ''} 
  #=========================================================================
  # Map_Info[2] => Praia de Sunide                              
  #=========================================================================
   Map_Info[2] = {
   # Nome do Mapa
   "Name"      => 'Praia de Sunide',
   # Switch que ativa esse mapa no World_Map
   "Switch"    => 3,
   # Posição do ícone no mapa [posição em X, posição em Y]
  "Position"   => [200, 200],
   # Mapa, posição em que será movido o personagem desse modo.
   # 'Map_id' = [Id do mapa, posição em X, posição em Y]
  "Map_id"     => [4, 5, 5],
   # Nome do arquivo de imagem que aparecerá no World Map.
  "Icon"       => 'Map_icon',    
   # Descrição 1 do mapa, primeira linha, sempre entre aspas
   "Desc"      => 'Praia para relaxar um pouco',
   # Descrição 2 do mapa, segunda linha, sempre entre aspas
   "Desc2"     => ''} 
   
  #=========================================================================
  # Map_Info[3] => Saphena                           
  #=========================================================================
   Map_Info[3] = {
   # Nome do Mapa
   "Name"      => 'Saphena',
   # Switch que ativa esse mapa no World_Map
   "Switch"    => 3,
   # Posição do ícone no mapa [posição em X, posição em Y]
  "Position"   => [450, 100],
   # Mapa, posição em que será movido o personagem desse modo.
   # 'Map_id' = [Id do mapa, posição em X, posição em Y]
  "Map_id"     => [5, 5, 5],
   # Nome do arquivo de imagem que aparecerá no World Map.
  "Icon"       => 'Map_icon',    
   # Descrição 1 do mapa, primeira linha, sempre entre aspas
   "Desc"      => 'Cidade dos cristais',
   # Descrição 2 do mapa, segunda linha, sempre entre aspas
   "Desc2"     => ''} 
#===========================================================================
# Inicio do script
#===========================================================================
end



module Cache
  #--------------------------------------------------------------------------
  # * Carregamento dos gráficos de animação
  #     filename : nome do arquivo
  #     hue      : informações da alteração de tonalidade
  #--------------------------------------------------------------------------
  def self.world_map(filename)
    load_bitmap("Graphics/World Map/", filename)
  end
end

#==============================================================================
# ** Scene_Item
#------------------------------------------------------------------------------
#  Esta classe executa o processamento da tela de item.
#==============================================================================

class Scene_Lune_Map < Scene_ItemBase
  #--------------------------------------------------------------------------
  # * Inicialização do processo
  #--------------------------------------------------------------------------
  def start
    super
    @get_index = 0
    $lune_map_info = Array.new
    Lune_Map::Map_Info.each {|map| $lune_map_info.push(map) if $game_switches[map['Switch']]}
    create_category_window
    create_map_window
  end
  #--------------------------------------------------------------------------
  # * Criação da janela de categorias
  #--------------------------------------------------------------------------
  def create_category_window
    @help_window = Window_Help_Map.new
    @help_window.viewport = @viewport
    @category_window = Window_MapList.new
    @category_window.viewport = @viewport
    @category_window.y = @help_window.height
    @help_window.z = @category_window.z = 400
    @category_window.set_handler(:cancel, method(:return_scene))
  end
  #--------------------------------------------------------------------------
  # * Criação da janela de itens
  #--------------------------------------------------------------------------
  def create_map_window
    @item_window = Window_ShowMap.new
    @item_window.viewport = @viewport
    @category_window.item_window = @item_window
  end
  def update
    super
    @item_window.refresh(@category_window.index) unless $lune_map_info == []
    @help_window.refresh(@category_window.index) unless $lune_map_info == []
  end
  #--------------------------------------------------------------------------
  # * Categoria [Confirmação]
  #--------------------------------------------------------------------------
  def on_category_ok
    @item_window.activate
    @item_window.select_last
  end
  #--------------------------------------------------------------------------
  # * Item [Confirmação]
  #--------------------------------------------------------------------------
  def on_item_ok
    $game_party.last_item.object = item
    determine_item
  end
  #--------------------------------------------------------------------------
  # * Item [Cancelamento]
  #--------------------------------------------------------------------------
  def on_item_cancel
    @item_window.unselect
    @category_window.activate
  end
  #--------------------------------------------------------------------------
  # * Execução de SE para o item
  #--------------------------------------------------------------------------
  def play_se_for_item
    Sound.play_use_item
  end
  #--------------------------------------------------------------------------
  # * Usando um item
  #--------------------------------------------------------------------------
  def use_item
    super
    @item_window.redraw_current_item
  end
  def terminate
    super
    @help_window.dispose
    @item_window.dispose
    @category_window.dispose
  end
end


#==============================================================================
# ** Window_ItemCategory
#------------------------------------------------------------------------------
#  Esta janela é usada para selecionar o tipo de item e equipamentos para
# tela de itens ou lojas.
#==============================================================================

class Window_MapList < Window_Command
include Lune_Map
  #--------------------------------------------------------------------------
  # * Variáveis públicas
  #--------------------------------------------------------------------------
  attr_reader   :item_window
  #--------------------------------------------------------------------------
  # * Inicialização do objeto
  #--------------------------------------------------------------------------
  def initialize
    super(0, 0)
  end
  #--------------------------------------------------------------------------
  # * Aquisição da largura da janela
  #--------------------------------------------------------------------------
  def window_width
    150
  end
  def window_height
    Graphics.height - fitting_height(2)
  end
  #--------------------------------------------------------------------------
  # * Definição de resultado ao pressionar o botão de confirmação
  #--------------------------------------------------------------------------
  def process_ok
    if current_item_enabled?
      Sound.play_ok
      Input.update
      deactivate
      transf = $lune_map_info[@index]['Map_id']
      $game_player.reserve_transfer(transf[0], transf[1], transf[2])
      SceneManager.return
      call_ok_handler
    else
      Sound.play_buzzer
    end
  end
  #--------------------------------------------------------------------------
  # * Aquisição do número de colunas
  #--------------------------------------------------------------------------
  def col_max
    return 1
  end
  #--------------------------------------------------------------------------
  # * Atualização da tela
  #--------------------------------------------------------------------------
  def update
    super
  end
  #--------------------------------------------------------------------------
  # * Criação da lista de comandos
  #--------------------------------------------------------------------------
  def make_command_list
    for i in 0...$lune_map_info.length
      command = $lune_map_info[i]['Name']
      add_command(command, nil) 
    end
  end
  #--------------------------------------------------------------------------
  # * Definição da janela de itens
  #     item_window : janela de itens
  #--------------------------------------------------------------------------
  def item_window=(item_window)
    @item_window = item_window
    update
  end
end

#==============================================================================
# ** Window_ShowCombs
#------------------------------------------------------------------------------
#  Esta janela exibe a quantia de dinheiro.
#==============================================================================

class Window_ShowMap < Window_Base
include Lune_Map
  #--------------------------------------------------------------------------
  # * Inicialização do objeto
  #--------------------------------------------------------------------------
  def initialize
    super(138, fitting_height(2) - 12, window_width, window_height)
    self.opacity = 0
    @x = 0
    @y = 0
    @nx = 0
    @ny = 0
    @cursor = Sprite.new
    @cursor.bitmap = Cache.world_map(Map_Cursor)
    @icon = Sprite.new
    @icon.z = 201
    @cursor.z = 200
    @bitmap = Cache.world_map(Map_Name)
    refresh(0) unless $lune_map_info == []
  end
  def draw_horz_line(y)
    line_y = y + line_height / 2 - 1
    contents.fill_rect(0, line_y, contents_width, 2, line_color)
  end
  #--------------------------------------------------------------------------
  # * Aquisição da largura da janela
  #--------------------------------------------------------------------------
  def window_width
    Graphics.width - 126
  end
  def window_height
    Graphics.height - fitting_height(2) + 24
  end
  def line_color
    color = normal_color
    color.alpha = 48
    color
  end
  #--------------------------------------------------------------------------
  # * Renovação
  #--------------------------------------------------------------------------
  def refresh(index)
    self.contents.clear
    @x += 10 if @x <= $lune_map_info[index]['Position'][0] - window_width/2
    @x -= 10 if @x >= $lune_map_info[index]['Position'][0] - window_width/2
    @y += 10 if @y <= $lune_map_info[index]['Position'][1] - window_height/2
    @y -= 10 if @y >= $lune_map_info[index]['Position'][1] - window_height/2
    @cursor.x = @x + 126 + Cursor_X - @nx + window_width/2
    @cursor.y = @y + fitting_height(2) + 24 + Cursor_Y - @ny + window_height/2
    unless @index == index
      @index = index 
      @icon.bitmap = Cache.world_map($lune_map_info[index]['Icon']) 
    end
      @icon.x = $lune_map_info[index]['Position'][0] + 160 - @nx
      @icon.y = $lune_map_info[index]['Position'][1] + 80 - @ny
    if @x > @bitmap.width + 24 - window_width
      @nx = @bitmap.width + 24 - window_width
    elsif @x < 0
      @nx = 0
    else
      @nx = @x
    end
    if @y > @bitmap.height + 24 - window_height
      @ny = @bitmap.height + 24 - window_height 
    elsif @y < 0
      @ny = 0
    else
      @ny = @y
    end
    rect = Rect.new(@nx, @ny, self.width , self.height)
    contents.blt(0, 0, @bitmap, rect)
  end
  def dispose
    super
    @icon.bitmap.dispose
    @icon.dispose
    @cursor.bitmap.dispose
    @cursor.dispose
  end
end

#==============================================================================
# ** Window_Gold
#------------------------------------------------------------------------------
#  Esta janela exibe a quantia de dinheiro.
#==============================================================================

class Window_Help_Map < Window_Base
include Lune_Map
  #--------------------------------------------------------------------------
  # * Inicialização do objeto
  #--------------------------------------------------------------------------
  def initialize
    super(0, 0, Graphics.width, fitting_height(2))
    refresh(nil)
  end
  def refresh(index)
    unless index == nil
      self.contents.clear
      draw_text(0, - 15, Graphics.width, fitting_height(1), $lune_map_info[index]['Desc'], 0)
      draw_text(0, 15, Graphics.width, fitting_height(1), $lune_map_info[index]['Desc2'], 0)
    end
  end
end