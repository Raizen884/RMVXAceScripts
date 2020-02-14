#=======================================================
# Autor: Raizen
#         Lune Item Grid
# Comunidade : www.centrorpg.com
# Adiciona a função de grid para os itens, tal função é encontrado por exemplo
# em Diablo 2 e 3, Resident Evil e muitos outros jogos.
#=======================================================
$imported ||= {}
$imported[:Lune_Item_Grid] = true


#=======================================================
#-------------------------------------------------------
#------------- Utilizando o Script! --------------------
#-------------------------------------------------------
#=======================================================

# Para configurar os itens do grid, utilize o bloco de notas no database,
# Um item que tem uma imagem especifica utilize a seguinte tag no database.
#<grid_pic nome_da_imagem>

# Aonde nome_da_imagem é o nome da imagem dentro da pasta Graphics/Item_Grid do
# seu projeto, esse será a imagem do item, caso não tenha essa tag no item
# A imagem será automaticamente o ícone do database.

#-------------------------------------------------------

# Para alterar o tamanho do item (lembrando que o tamanho padrão é 1x1, 
# Basta colocar uma tag nos itens desse modo
# <item_size WxH>

#Aonde W é a largura do item e H a altura, por exemplo um item 2x3 ficaria desse modo
# <item_size 2x3>

#-------------------------------------------------------

# Para um item ficar impossibilitado de jogar, adicionar essa tag a ele
# <key_item>

#-------------------------------------------------------

# Para verificar se há espaço no grid utilize a aba condições
# Script e use o seguinte comando
# Script: space_on_grid?(type, id)
# aonde o type é o tipo de item
# 1 = itens, 2 = armas, 3 = armaduras
# e id o id do database
# Muito útil para caso precise que o personagem tenha certo item,
# exemplo de utilização : space_on_grid?(1, 10) 




module Lune_Item_Grid
#-------------------------------------------------------
#------------- Vocabulário --------------------
#-------------------------------------------------------
Use = 'Use' #Usar o item
Move = 'Move' #Mover o item
Throw = 'Throw' #JOgar fora o item


# Tamanho dos itens do grid em pixels [x, y]
Item_Size = [24, 24]

# Tamanho do grid [x, y]
Grid_Size = [16, 12]

# Imagem da grid de itens, coloque Image = '' para que utilize window padrão
Image = 'Item_Grid'

# Correção da posição do Grid, para efeitos de encaixe na imagem
Grid_Position_X = - 6
Grid_Position_Y = - 8

end
# Aqui começa o script.
#=======================================================
#==============================================================================
# ** Game_Interpreter
#------------------------------------------------------------------------------
#  Um interpretador para executar os comandos de evento. Esta classe é usada
# internamente pelas classes Game_Map, Game_Troop e Game_Event.
#==============================================================================

class Game_Interpreter
  def space_on_grid?(type, id)
    case type
    when 1
      return $game_party.check_grid_available($data_items[id])
    when 2
      return $game_party.check_grid_available($data_weapons[id])
    when 3
      return $game_party.check_grid_available($data_armors[id])
    end
  end
end

#==============================================================================
# ** Game_Party
#------------------------------------------------------------------------------
#  Esta classe gerencia o grupo. Contém informações sobre dinheiro, itens.
# A instância desta classe é referenciada por $game_party.
#==============================================================================

class Game_Party < Game_Unit
alias :lune_item_grid_initialize :initialize
alias :lune_grid_gain_item :gain_item
attr_accessor :item_grid_x
attr_accessor :item_grid_y
attr_reader :party_grid
  #--------------------------------------------------------------------------
  # * Inicialização do objeto
  #--------------------------------------------------------------------------
  def initialize
    lune_item_grid_initialize
    @item_grid_x = - 1
    @item_grid_y = - 1
    @party_grid = Array.new(Lune_Item_Grid::Grid_Size[0] - 1)
    for n in 0..@party_grid.size
      @party_grid[n] = Array.new(Lune_Item_Grid::Grid_Size[1], 0)
    end
  end
  #--------------------------------------------------------------------------
  # * Acrescentar item (redução)
  #     item          : item
  #     amount        : quantia alterada
  #     include_equip : incluir itens equipados
  #--------------------------------------------------------------------------
  def gain_item(item, amount, include_equip = false)
    while amount > 0
      lune_grid_gain_item(item, 1, include_equip = false) if check_grid_available(item)
      amount -= 1
    end
    if amount < 0
      lune_grid_gain_item(item, amount, include_equip = false) 
      amount.abs.times {remove_item(item)}
    end
  end
  #--------------------------------------------------------------------------
  # * Acrescentar item no grid
  #     item          : item
  #--------------------------------------------------------------------------
  def add_item_grid(item)
    item_size = get_item_size(item)
    if item.is_a?(RPG::Item)
      @item_type = 1
    elsif item.is_a?(RPG::Weapon)
      @item_type = 2
    else
      @item_type = 3
    end
    for x3 in @item_grid_x..(item_size[0] + @item_grid_x - 1)
      for y3 in @item_grid_y..(item_size[1] + @item_grid_y - 1)
        @party_grid[x3][y3] = [@item_type, item.id, @item_grid_x, @item_grid_y, item_size[0], item_size[1]]
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Remover item do grid
  #     item          : item
  #--------------------------------------------------------------------------
  def remove_item(item)
    return false if item == nil
    if item.is_a?(RPG::Item)
      @item_type = 1
    elsif item.is_a?(RPG::Weapon)
      @item_type = 2
    else
      @item_type = 3
    end
    item_size = get_item_size(item)

    if @item_grid_x == -1
      max_x = Lune_Item_Grid::Grid_Size[0] - 1
      max_y = Lune_Item_Grid::Grid_Size[1] - 1
      item_found = false
      item_remove_x = -1
      item_remove_y = -1
      for y in 0..max_y
        for x in 0..max_x
          next unless @party_grid.is_a?(Array)
          if @party_grid[x][y][0] == @item_type && @party_grid[x][y][1] == item.id
            item_found = true 
            item_remove_x = x
            item_remove_y = y
          end
          break if item_found
        end
        break if item_found
      end 
      return unless item_found
    else
      item_remove_x = @item_grid_x
      item_remove_y = @item_grid_y
    end
    for x in item_remove_x..(item_size[0] + item_remove_x - 1)
      for y in item_remove_y..(item_size[1] + item_remove_y - 1)
        @party_grid[x][y] = 0
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Verificar se há espaço no grid
  #     item          : item
  #--------------------------------------------------------------------------
  def check_grid_available(item, add = true)
    return false if item == nil
    max_x = Lune_Item_Grid::Grid_Size[0] - 1
    max_y = Lune_Item_Grid::Grid_Size[1] - 1
    item_size = get_item_size(item)
    space_for_item = false
    for y in 0..max_y
      for x in 0..max_x
        space_for_item = check_for_item_space(x, y, item_size[0], item_size[1])
        break if space_for_item
      end
      break if space_for_item
    end 
    return false unless space_for_item
    return true unless add
    if item.is_a?(RPG::Item)
      @item_type = 1
    elsif item.is_a?(RPG::Weapon)
      @item_type = 2
    else
      @item_type = 3
    end
    for x3 in x..(item_size[0] + x - 1)
      for y3 in y..(item_size[1] + y - 1)
        @party_grid[x3][y3] = [@item_type, item.id, x, y, item_size[0], item_size[1]]
      end
    end
    return true
  end
  #--------------------------------------------------------------------------
  # * Obter tamanho do item
  #     item          : item
  #--------------------------------------------------------------------------
  def get_item_size(item)
    return [1, 1] unless item
      if item.note != ""
      for count in 0..item.note.size
        if item.note[count...count + 10] == "<item_size"
          item_x = item.note[count + 11].to_i
          item_y = item.note[count + 13].to_i
        end
      end
    end
    item_x = 1 unless item_x
    item_y = 1 unless item_y
    return [item_x, item_y]
  end
  #--------------------------------------------------------------------------
  # * Verificar espaço no grid
  #--------------------------------------------------------------------------
  def check_for_item_space(x, y, x2, y2)
    for x3 in x..(x2 + x - 1)
      for y3 in y..(y2 + y - 1)
        return false if @party_grid[x3] == nil || @party_grid[x3][y3] != 0
      end
    end
    return true
  end
end


#==============================================================================
# ** Scene_Item
#------------------------------------------------------------------------------
#  Esta classe executa o processamento da tela de item.
#==============================================================================

class Scene_Item < Scene_ItemBase
  #--------------------------------------------------------------------------
  # * Inicialização do processo
  #--------------------------------------------------------------------------
  def start
    super
    create_help_window
    create_category_window
    create_item_window
    create_back_sprite
    create_use_window
    @item_used = false
    @category_window.opacity = 0 unless Lune_Item_Grid::Image == ''
    @category_window.contents_opacity = 0
    @help_window.opacity = 0 unless Lune_Item_Grid::Image == ''
    @category_window.deactivate
    @item_window.select(0)
    @item_window.activate
    wy = @category_window.y + @category_window.height
    wh = Graphics.height - wy
    @dummy_item_window = Window_Base.new(0, wy, Graphics.width, wh)
    @dummy_item_window.opacity = 0 unless Lune_Item_Grid::Image == ''
  end
  #--------------------------------------------------------------------------
  # * Definição de cursor na coluna da esquerda
  #--------------------------------------------------------------------------
  def cursor_left?
    @item_window.index % Lune_Item_Grid::Grid_Size[0] < Lune_Item_Grid::Grid_Size[0]/2
  end
  #--------------------------------------------------------------------------
  # * Criação da janela de itens
  #--------------------------------------------------------------------------
  def create_item_window
    wy = @category_window.y + @category_window.height
    wh = Graphics.height - wy
    @item_window = Window_Grid_ItemList.new(0, wy, Graphics.width, wh + 20)
    @item_window.viewport = @viewport
    @item_window.help_window = @help_window
    @item_window.set_handler(:ok,     method(:on_item_ok))
    @item_window.set_handler(:cancel, method(:on_item_cancel))
    @category_window.item_window = @item_window
    @item_window.x += Lune_Item_Grid::Grid_Position_X
    @item_window.y += Lune_Item_Grid::Grid_Position_Y
    @item_window.opacity = 0 
  end
  #--------------------------------------------------------------------------
  # * Criando Imagem de fundo
  #--------------------------------------------------------------------------
  def create_back_sprite
    @back_sprite_grid = Sprite.new
    @back_sprite_grid.bitmap = Cache.item_grid(Lune_Item_Grid::Image)
  end
  def create_use_window
    @use_item = Window_Item_Grid_Use.new
    @use_item.set_handler(:new_game, method(:command_use))
    @use_item.set_handler(:continue, method(:command_move))
    @use_item.set_handler(:shutdown, method(:command_release))
  end
  #--------------------------------------------------------------------------
  # * Cancelamento de ação 
  #--------------------------------------------------------------------------
  def on_actor_cancel
    super
    @item_window.index = @old_index if @old_index
    @item_used = false
  end
  #--------------------------------------------------------------------------
  # * Cancelamento da janela de itens
  #--------------------------------------------------------------------------
  def on_item_cancel
    if @on_move
      $game_party.add_item_grid(@item_old)
      @item_window.set_on_move(nil, false)
      @on_move = false
    end
    @item_window.unselect
    return_scene
  end
  #--------------------------------------------------------------------------
  # * Usando um item
  #--------------------------------------------------------------------------
  def use_item
    $game_party.item_grid_x = @item_window.current_col
    $game_party.item_grid_y = @item_window.current_row   
    super
    @item_used = true
    @item_window.dispose
    create_item_window
    $game_party.item_grid_x = $game_party.item_grid_y = -1
  end
  #--------------------------------------------------------------------------
  # * Comando de utilização
  #--------------------------------------------------------------------------
  def command_use
    @use_item.close
    if item.is_a?(RPG::Item)
      @old_index = @item_window.index
      determine_item
    else
      Sound.play_buzzer
      @item_window.activate
    end 
  end
  #--------------------------------------------------------------------------
  # * Definição de itens disponíveis para uso
  #--------------------------------------------------------------------------
  def item_usable?
    user.usable?(item) && item_effects_valid? && !@item_used
  end
  #--------------------------------------------------------------------------
  # * Comando de movimento do item
  #--------------------------------------------------------------------------
  def command_move
    @item_old = @item_window.selected_item 
    $game_party.item_grid_x = @item_window.current_col
    $game_party.item_grid_y = @item_window.current_row
    @item_window.set_on_move(item, true)
    $game_party.remove_item(@item_old)
    @on_move = true
    @use_item.close
    @item_window.activate
    @item_window.index = 0
  end
  #--------------------------------------------------------------------------
  # * Comando de dipose do item
  #--------------------------------------------------------------------------
  def command_release
    return unless @item_window.selected_item 
    old_index = @item_window.index
    @item_old = @item_window.selected_item 
    if @item_old.note.include?("<key_item>")
      Sound.play_buzzer
      @use_item.close
      @item_window.activate  
      return
    end
    $game_party.item_grid_x = @item_window.current_col
    $game_party.item_grid_y = @item_window.current_row
    $game_party.gain_item(@item_old, -1, true)
    $game_party.item_grid_x = $game_party.item_grid_y = -1
    @item_window.dispose
    create_item_window
    @use_item.close
    @item_window.activate  
    @item_window.index = old_index
  end
  #--------------------------------------------------------------------------
  # * Comando de seleção do item
  #--------------------------------------------------------------------------
  def on_item_ok
    if @on_move
      if @item_window.check_for_space
        $game_party.item_grid_x = @item_window.current_col
        $game_party.item_grid_y = @item_window.current_row
        $game_party.add_item_grid(@item_old)
        $game_party.item_grid_x = $game_party.item_grid_y = -1
        @item_window.dispose
        create_item_window
        @item_window.activate
        @item_window.set_on_move(nil, false)
        @on_move = false
      else
        Sound.play_buzzer
        @item_window.activate
      end
      return
    end
    if item == nil
      @item_window.activate
      return 
    end
    if @use_item.close?
      @use_item.open
      @use_item.activate
    else
      determine_item
    end
  end
  #--------------------------------------------------------------------------
  # * Método de atualização
  #--------------------------------------------------------------------------
  def update
    super
    if Input.trigger?(:B) and !@use_item.close?
      Sound.play_cancel
      @use_item.close
      @item_window.activate
    end
  end
end




#==============================================================================
# ** Window_ItemList
#------------------------------------------------------------------------------
#  Esta janela exibe a lista de itens possuidos na tela de itens.
#==============================================================================

class Window_Grid_ItemList < Window_ItemList
include Lune_Item_Grid
  #--------------------------------------------------------------------------
  # * Inicialização do processo
  #--------------------------------------------------------------------------
  def initialize(*args)
    @index = 0
    set_on_move(nil, false)
    super(*args)
  end
  #--------------------------------------------------------------------------
  # * Verificar espaço
  #--------------------------------------------------------------------------
  def check_for_space
    $game_party.check_for_item_space(current_col, current_row, @size_item_move[0]/Item_Size[0], @size_item_move[1]/Item_Size[1])
  end
  #--------------------------------------------------------------------------
  # * Coluna atual
  #--------------------------------------------------------------------------
  def current_col 
    index % col_max
  end
  #--------------------------------------------------------------------------
  # * Linha atual
  #--------------------------------------------------------------------------
  def current_row
    index / col_max
  end
  #--------------------------------------------------------------------------
  # * Selecionado comando de mover
  #--------------------------------------------------------------------------
  def set_on_move(item, on_move)
    if on_move
      @size_item_move = [item_width, item_height]
    else
      @size_item_move = nil
    end
    @on_move = on_move
  end
  #--------------------------------------------------------------------------
  # * Retorno à seleção anterior
  #--------------------------------------------------------------------------
  def select_last
    inndex = @data.index($game_party.last_item.object) || 0
    if  $game_party.party_grid[inndex % Grid_Size[0]][inndex / Grid_Size[0]].is_a?(Array)
      inndex = $game_party.party_grid[inndex % Grid_Size[0]][inndex / Grid_Size[0]][2] + $game_party.party_grid[inndex % Grid_Size[0]][inndex / Grid_Size[0]][3] * Grid_Size[0]
      select(inndex)
      return
    end
    select(@data.index($game_party.last_item.object) || 0)
  end
  #--------------------------------------------------------------------------
  # * Aquisição do número de colunas
  #--------------------------------------------------------------------------
  def col_max
    if @size_item_move
      return Grid_Size[0] + 1 - (@size_item_move[0] / Item_Size[0])
    end 
    return Grid_Size[0]
  end
  #--------------------------------------------------------------------------
  # * Aquisição do espaçamento entre os itens
  #--------------------------------------------------------------------------
  def spacing
    return 0
  end
  #--------------------------------------------------------------------------
  # * Inclusão do item na lista
  #     item : item
  #--------------------------------------------------------------------------
  def include?(item)
    true
  end
  #--------------------------------------------------------------------------
  # * Aquisição do retangulo para desenhar o item
  #     index : índice do item
  #--------------------------------------------------------------------------
  def item_rect(index)
    @index = index
    rect = Rect.new
    rect.width = item_width
    rect.height = item_height
    rect.x = index % col_max * (Item_Size[0] + spacing)
    rect.y = index / col_max * Item_Size[1]
    rect
  end
  #--------------------------------------------------------------------------
  # * Aquisição de largura do item
  #--------------------------------------------------------------------------
  def item_width
    return @size_item_move[0] if @size_item_move != nil
    if  $game_party.party_grid[@index % Grid_Size[0]][@index / Grid_Size[0]].is_a?(Array)
      $game_party.party_grid[@index % Grid_Size[0]][@index / Grid_Size[0]][4] * Item_Size[0]
    else
      Item_Size[0]
    end
  end
  #--------------------------------------------------------------------------
  # * Aquisição de altura do item
  #--------------------------------------------------------------------------
  def item_height
    return @size_item_move[1] if @size_item_move != nil
    if  $game_party.party_grid[@index % Grid_Size[0]][@index / Grid_Size[0]].is_a?(Array)
      $game_party.party_grid[@index % Grid_Size[0]][@index / Grid_Size[0]][5] * Item_Size[1]
    else
      Item_Size[1]
    end
  end
  #--------------------------------------------------------------------------
  # * Aquisição do número máximo de itens
  #--------------------------------------------------------------------------
  def item_max
    if @size_item_move
      return (Grid_Size[0] + 1 - (@size_item_move[0] / Item_Size[0]))*(Grid_Size[1] + 1 - (@size_item_move[1] / Item_Size[1]))
    end 
    Grid_Size[0]*Grid_Size[1]
  end
  #--------------------------------------------------------------------------
  # * Desenho de um item
  #     index : índice do item
  #--------------------------------------------------------------------------
  def draw_item(index)
    item = @data[index]
    if item
      rect = item_rect(index)
      rect.width -= 4
      if item.note.include?("<grid_pic")
        for count in 0..item.note.size
          if item.note[count...count + 9] == "<grid_pic"
            count2 = 0
            count2 += 1 until item.note[count2 + count + 10] == ">"
            draw_grid_item(item.note[(count + 10)..(count + count2 + 9)], rect.x, rect.y)
          end
        end
      else
        draw_icon(item.icon_index, rect.x, rect.y, enable?(item))
      end
      #draw_item_number(rect, item)
    end
  end
  #--------------------------------------------------------------------------
  # * Desenho de ícones
  #     icon_index : índice do ícone
  #     x          : coordenada X
  #     y          : coordenada Y
  #     enabled    : habilitar flag, translucido quando false
  #--------------------------------------------------------------------------
  def draw_grid_item(item_name, x, y)
    bitmap = Cache.item_grid(item_name)
    rect = Rect.new(0, 0, bitmap.width, bitmap.height)
    contents.blt(x, y, bitmap, rect,  255)
  end
  #--------------------------------------------------------------------------
  # * Criação da lista de itens
  #--------------------------------------------------------------------------
  def make_item_list
    for n in 0..Grid_Size[1] - 1
      for i in 0..Grid_Size[0] - 1
        if $game_party.party_grid[i][n] == 0 || $game_party.party_grid[i][n][2] != i || $game_party.party_grid[i][n][3] != n
          @data << nil 
        else
          case $game_party.party_grid[i][n][0]
          when 1
            @data << $data_items[$game_party.party_grid[i][n][1]]
          when 2
            @data << $data_weapons[$game_party.party_grid[i][n][1]] 
          when 3
            @data << $data_armors[$game_party.party_grid[i][n][1]]
          end  
        end
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Movimento do cursor para baixo
  #     wrap : cursor retornar a primeira ou ultima posição
  #--------------------------------------------------------------------------
  def cursor_down(wrap = false)
    if @size_item_move
      super(true)
      return
    end
    correction = 1
    correction = $game_party.party_grid[index % Grid_Size[0]][index / Grid_Size[0]][5] if $game_party.party_grid[index % Grid_Size[0]][index / Grid_Size[0]].is_a?(Array)
    inndex = (index + col_max * correction) % item_max
    if  $game_party.party_grid[inndex % Grid_Size[0]][inndex / Grid_Size[0]].is_a?(Array)
      inndex = $game_party.party_grid[inndex % Grid_Size[0]][inndex / Grid_Size[0]][2] + $game_party.party_grid[inndex % Grid_Size[0]][inndex / Grid_Size[0]][3] * Grid_Size[0]
      select(inndex)
      return
    end
    select((index + col_max * correction) % item_max)
  end
  #--------------------------------------------------------------------------
  # * Movimento do cursor para cima
  #     wrap : cursor retornar a primeira ou ultima posição
  #--------------------------------------------------------------------------
  def cursor_up(wrap = false)
    if @size_item_move
      super(true)
      return
    end
    inndex = (index - col_max + item_max) % item_max
    if  $game_party.party_grid[inndex % Grid_Size[0]][inndex / Grid_Size[0]].is_a?(Array)
      inndex = $game_party.party_grid[inndex % Grid_Size[0]][inndex / Grid_Size[0]][2] + $game_party.party_grid[inndex % Grid_Size[0]][inndex / Grid_Size[0]][3] * Grid_Size[0]
      select(inndex)
      return
    end
    select((index - col_max) % item_max)
  end
  #--------------------------------------------------------------------------
  # * Movimento do cursor para direita
  #     wrap : cursor retornar a primeira ou ultima posição
  #--------------------------------------------------------------------------
  def cursor_right(wrap = false)
    if @size_item_move
      super(true)
      return
    end
    correction = 1
    correction = $game_party.party_grid[index % Grid_Size[0]][index / Grid_Size[0]][4] if $game_party.party_grid[index % Grid_Size[0]][index / Grid_Size[0]].is_a?(Array)
    inndex = (index + correction) % item_max
    if  $game_party.party_grid[inndex % Grid_Size[0]][inndex / Grid_Size[0]].is_a?(Array)
      inndex = $game_party.party_grid[inndex % Grid_Size[0]][inndex / Grid_Size[0]][2] + $game_party.party_grid[inndex % Grid_Size[0]][inndex / Grid_Size[0]][3] * Grid_Size[0]
      select(inndex)
      return
    end
    select((index + correction) % item_max)
  end
  #--------------------------------------------------------------------------
  # * Movimento do cursor para esquerda
  #     wrap : cursor retornar a primeira ou ultima posição
  #--------------------------------------------------------------------------
  def cursor_left(wrap = false)
    if @size_item_move
      super(true)
      return
    end
    inndex = (index - 1 + item_max) % item_max
    if  $game_party.party_grid[inndex % Grid_Size[0]][inndex / Grid_Size[0]].is_a?(Array)
      inndex = $game_party.party_grid[inndex % Grid_Size[0]][inndex / Grid_Size[0]][2] + $game_party.party_grid[inndex % Grid_Size[0]][inndex / Grid_Size[0]][3] * Grid_Size[0]
      select(inndex)
      return
    end
    select((index - 1 + item_max) % item_max)
  end  
  #--------------------------------------------------------------------------
  # * Movimento do cursor uma página abaixo
  #--------------------------------------------------------------------------
  def cursor_pagedown
  end
  #--------------------------------------------------------------------------
  # * Movimento do cursor uma página acima
  #--------------------------------------------------------------------------
  def cursor_pageup
  end
  #--------------------------------------------------------------------------
  # * Confirmação de visibilidade do cursor
  #--------------------------------------------------------------------------
  def ensure_cursor_visible
  end
  def selected_item
    return false unless $game_party.party_grid[@index % Grid_Size[0]][@index / Grid_Size[0]].is_a?(Array)
    case $game_party.party_grid[@index % Grid_Size[0]][@index / Grid_Size[0]][0]
      when 1
        return $data_items[$game_party.party_grid[@index % Grid_Size[0]][@index / Grid_Size[0]][1]]
      when 2
        return $data_weapons[$game_party.party_grid[@index % Grid_Size[0]][@index / Grid_Size[0]][1]]
      when 3
        return $data_armors[$game_party.party_grid[@index % Grid_Size[0]][@index / Grid_Size[0]][1]]
    end
  end
  #--------------------------------------------------------------------------
  # * Definição de habilitação do item
  #     item : item
  #--------------------------------------------------------------------------
  def enable?(item)
    true
  end
end

module Cache
  #--------------------------------------------------------------------------
  # * Carregamento dos gráficos de itens
  #     filename : nome do arquivo
  #--------------------------------------------------------------------------
  def self.item_grid(filename)
    load_bitmap("Graphics/Item_Grid/", filename)
  end
end


#==============================================================================
# ** Window_MenuStatus
#------------------------------------------------------------------------------
#  Esta janela exibe os parâmetros dos membros do grupo na tela de menu.
#==============================================================================

class Window_Item_Grid_Use < Window_Command
include Lune_Item_Grid
  #--------------------------------------------------------------------------
  # * Inicialização do objeto
  #--------------------------------------------------------------------------
  def initialize
    super(0, 0)
    self.z = 9999
    self.x = (Graphics.width / 2) - (window_width / 2)
    self.y = Graphics.height / 2
    self.openness = 0
  end
  #--------------------------------------------------------------------------
  # * Aquisição da largura da janela
  #--------------------------------------------------------------------------
  def window_width
    return 160
  end
  #--------------------------------------------------------------------------
  # * Criação da lista de comandos
  #--------------------------------------------------------------------------
  def make_command_list
    add_main_commands

  end
  #--------------------------------------------------------------------------
  # * Adição dos comandos principais
  #--------------------------------------------------------------------------
  def add_main_commands
    add_command(Use,   :new_game,   true)
    add_command(Move,  :continue,  true)
    add_command(Throw,  :shutdown,  true)
  end

end
#==============================================================================
# ** Game_Actor
#------------------------------------------------------------------------------
#  Esta classe gerencia os heróis. Ela é utilizada internamente pela classe
# Game_Actors ($game_actors). A instância desta classe é referenciada
# pela classe Game_Party ($game_party).
#==============================================================================

class Game_Actor < Game_Battler
  #--------------------------------------------------------------------------
  # * Trocar item com membro do grupo
  #     new_item : item removido do grupo
  #     old_item : item devolvido ao grupo
  #--------------------------------------------------------------------------
  def trade_item_with_party(new_item, old_item)
    return false if new_item && !$game_party.has_item?(new_item)
    if !old_item || $game_party.check_grid_available(old_item, false)
      $game_party.gain_item(old_item, 1)
      $game_party.lose_item(new_item, 1)
    else
      return false
    end
    return true
  end
end