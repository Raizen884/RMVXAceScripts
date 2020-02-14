#=======================================================
#         Lune Item Vault
# Autor : Raizen
# Comunidade: www.centrorpg.com
# Função do script: O script adiciona um baú ou banco,
# dependendo da preferência, que permite guardar itens,
# depositar dinheiro, sacar itens e sacar o dinheiro guardado
#=======================================================

# Explicações e Funções:

# Para Chamar a tela do script basta ir no
# Chamar Script: SceneManager.call(Scene_Vault)

#==============================================================#
#=========== GERENCIANDO OS ITENS DO BAÚ / BANCO ==============#
#==============================================================#

# Para mudar um certo item do banco, remover, adicionar
# Basta utilizar o Comando Chamar Script: com o seguinte.

# Chamar Script: Lune_Vault.change_item(n, item, type)

# Aonde n é a quantidade de itens, pode ter valor negativo
# Aonde item é o ID do item no database.
# Aonde type é o tipo de item que pretende adicionar ou remover.
#     Seguindo o seguinte. 1 = itens, 2= armas, 3 = armaduras
# Exemplo: Quero retirar 5 armas de ID 3 do database, 
# Chamar Script: Lune_Vault.change_item(-5, 3, 2)

#==============================================================#
#=========== GERENCIANDO O DINHEIRO DO BAÚ/BANCO ==============#
#==============================================================#

# Para mudar a quantidade de dinheiro que se tem no banco
# Basta utilizar o Comando Chamar Script: com o seguinte.

# Chamar Script: Lune_Vault.gold(n)
# Aonde n é a quantidade de gold que você irá adicionar ou remover,
# lembrando que pode ser um número negativo.
# Por exemplo, quero adicionar 500G no banco.

# Chamar Script: Lune_Vault.gold(500)

# Ideal para utilizar com sistemas que geram uma % ou taxas caso utilize
# o script como banco, o valor total de dinheiro no banco está
# salvo nessa variável.
# $game_party.hold_money
# Você pode igualar a uma variável e trabalhar com ela

#==============================================================#
#===================== Configurações ==========================#
#==============================================================#
module Lune_Vault
# Som que tocará ao depositar/sacar um item
Sound_Item = "Decision2"
# Som que tocará caso não tenha itens ou dinheiro suficiente
Sound_Item2 = "Buzzer2"

#==========================================================================
#==================== Configure aqui o vocabulário =======================#
#==========================================================================
# Frase que aparecerá na janela abaixo para indicar que 
# é para sacar os itens.
Vault_text = "Está janela gerencia os itens a serem retirados"
# Frase que aparecerá na janela abaixo para indicar que 
# é para depositar os itens.
Vault_text2 = "Está janela gerencia os itens a serem depositados"

# Frase que aparecerá para indicar a quantidade carregada
Gold_text = "Quantia carregada:"
# Frase que aparecerá para indicar a quantidade que está no baú, ou no
# banco.
Gold_text2 = "Quantia no baú:"
#==================
# Nome dos comandos
#==================
# Saque em dinheiro
Com1 = "Sacar"
# Depósito em dinheiro
Com2 = "Depositar"
# Saque de itens
Com3 = "Retirar Item"
# Depósito de itens
Com4 = "Guardar Item"
# Sair
Com5 = "Sair"
#==============================================================================#
#==============================================================================#
#======================== A PARTIR DAQUI COMEÇA O SCRIPT ======================#
#==============================================================================#
#==============================================================================#



  def self.change_item(n, item, type)
    case type
    when 1  # Item
      $game_party.gain_item_vault($data_items[item], n)
    when 2  # Arma
      $game_party.gain_item_vault($data_weapons[item], n)
    when 3  # Armadura
      $game_party.gain_item_vault($data_armors[item], n)
    end
  end
  def self.gold(n)
    $game_party.hold_money(n)
  end
end



#==============================================================================
# ** Scene_Menu
#------------------------------------------------------------------------------
#  Esta classe executa o processamento da tela de menu.
#==============================================================================

class Scene_Vault < Scene_MenuBase
  #--------------------------------------------------------------------------
  # * Inicialização do processo
  #--------------------------------------------------------------------------
  def start
    Window_MenuCommand::init_command_position
    super
    create_help_window
    create_category_window
    create_item_window
    create_command_window
    @command_window.activate
    @category_window.deactivate
  end
  #--------------------------------------------------------------------------
  # * Criação da janela de ajuda.
  #--------------------------------------------------------------------------
  def create_help_window
    unless $lune_weight_script
      super
    else
      @help_window = Window_Weight_Help.new
      @help_window.viewport = @viewport
    end
  end
  def create_command_window
    @command_window = Window_Create_Vault.new
    @command_window.set_handler(:deposit, method(:deposit))
    @command_window.set_handler(:draw, method(:draw))
    @command_window.set_handler(:depoitem, method(:depoitem))
    @command_window.set_handler(:drawitem, method(:drawitem))
    @command_window.set_handler(:exit, method(:exit))
    @command_window.viewport = @viewport
    @command_window.open
    @money_window = Window_NumberInput_Deposit.new(Window_Base.new(0,0,0,0))
    @money_window.viewport = @viewport
    @item_get_window = Window_Item_Deposit.new(Window_Base.new(0,0,0,0))
    @item_get_window.viewport = @viewport
  end
  def update
    super
    if @item_window.active || @category_window.active || @item_get_window.active
      @item_window.change_view ? @bank_window.refresh(1) : @bank_window.refresh(2)
    else
      @bank_window.refresh(0)
    end
    if Input.trigger?(:B)
      SceneManager.goto(Scene_Map) if @command_window.active
      if @money_window.open?
        @command_window.activate 
        @money_window.close
      end
      if @item_get_window.open?
        @item_window.activate 
        @item_get_window.close
      end
    end
    change_itens(@item_get_window.nitens) if @item_get_window.nitens
    @command_window.activate unless all_windows_down?
  end
  def all_windows_down?
    @command_window.active || @category_window.active || @item_window.active || !@money_window.close? || !@item_get_window.close?
  end
  #--------------------------------------------------------------------------
  # * Criação da janela de categorias
  #--------------------------------------------------------------------------
  def create_category_window
    @bank_window = Window_Bank_System.new
    @bank_window.viewport = @viewport
    @category_window = Window_ItemCategory.new
    @category_window.viewport = @viewport
    @category_window.help_window = @help_window
    @category_window.y = @help_window.height
    @category_window.set_handler(:ok,     method(:on_category_ok))
    @category_window.set_handler(:cancel, method(:on_select_choice))
  end
  #--------------------------------------------------------------------------
  # * Criação da janela de itens
  #--------------------------------------------------------------------------
  def create_item_window
    wy = @category_window.y + @category_window.height
    wh = Graphics.height - wy - @bank_window.height
    @item_window = Window_ItemList_Vault.new(0, wy, Graphics.width, wh)
    @item_window.viewport = @viewport
    @item_window.help_window = @help_window
    @item_window.set_handler(:ok,     method(:on_item_ok))
    @item_window.set_handler(:cancel, method(:on_item_cancel))
    @item_window.get_pos(true)
    @category_window.item_window = @item_window
  end
  def change_itens(n)
    $game_party.gain_item(@item_window.item, n)
    $game_party.gain_item_vault(@item_window.item, -n)
    @item_get_window.nitens = nil
    on_item_cancel
    @item_window.refresh
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
    @item_get_window.start(false, @item_window.item)
  end
  #--------------------------------------------------------------------------
  # * Item [Cancelamento]
  #--------------------------------------------------------------------------
  def on_item_cancel(t = nil)
    @item_window.unselect
    @item_window.get_pos(t)
    @item_get_window.get_pos(t)
    @category_window.activate
    @command_window.close
  end
  def on_select_choice
    @category_window.deactivate
    @command_window.open
    @command_window.activate
  end
  #--------------------------------------------------------------------------
  # * Comando [Gerenciar GPs]
  #--------------------------------------------------------------------------
  def draw
    on_money_get
  end
  def deposit
    on_money_dep
  end
  def on_money_dep
    @money_window.start(false)
  end
  def on_money_get
    @money_window.start(true)
  end
  #--------------------------------------------------------------------------
  # * Comando [Deposito de itens]
  #--------------------------------------------------------------------------
  def depoitem
    @help_window.on_bau(true) if $lune_weight_script
    on_item_cancel(false)
  end
  #--------------------------------------------------------------------------
  # * Comando [Sacar Itens]
  #--------------------------------------------------------------------------
  def drawitem
    @help_window.on_bau if $lune_weight_script
    on_item_cancel(true)
  end
  #--------------------------------------------------------------------------
  # * Comando [Fechar]
  #--------------------------------------------------------------------------
  def exit
    return_scene
  end
end


#==============================================================================
# ** Window_MenuStatus
#------------------------------------------------------------------------------
#  Esta janela exibe os parâmetros dos membros do grupo na tela de menu.
#==============================================================================

class Window_Create_Vault < Window_Command
include Lune_Vault
  #--------------------------------------------------------------------------
  # * Inicialização do objeto
  #--------------------------------------------------------------------------
  def initialize
    super(0, 0)
    self.z = 9999
    self.x = (Graphics.width / 2) - (window_width / 2)
    self.y = Graphics.height / 2 - 80
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
    add_command(Com2,   :deposit,   true)
    add_command(Com1,  :draw,  true)
    add_command(Com4,  :depoitem,  true)
    add_command(Com3,  :drawitem,  true)
    add_command(Com5,  :exit,  true)
  end
end

#==============================================================================
# ** Window_NumberInputInner
#------------------------------------------------------------------------------
#  Esta janela é utilizada para o comando de eventos [Armazenar Número]
#==============================================================================

class Window_NumberInput_Deposit < Window_NumberInput
attr_accessor :nitens
def initialize(message_window)
  @get_lost_itens = 0
  super(message_window)
end
  #--------------------------------------------------------------------------
  # * Inicialização do processo
  #--------------------------------------------------------------------------
  def start(cond)
    @cond = cond
    @digits_max = 8
    @number = @get_lost_itens
    @number = [[@number, 0].max, 10 ** @digits_max - 1].min
    @index = 0
    update_placement
    create_contents
    refresh
    open
    activate
  end
  #--------------------------------------------------------------------------
  # * Atualização da posição da janela
  #--------------------------------------------------------------------------
  def update_placement
    self.width = @digits_max * 20 + padding * 2
    self.height = fitting_height(1)
    self.x = (Graphics.width - width) / 2
    self.y = Graphics.height/2 + height + 20
    self.z = 150
  end

  #--------------------------------------------------------------------------
  # * Definição de resultado ao pressionar o botão de confirmação
  #--------------------------------------------------------------------------
  def process_ok
    if @cond
      number = $game_party.hold_money
      if @number <= number
        Sound.play_shop
        make_draw
      else
        RPG::SE.new(Lune_Vault::Sound_Item2).play
      end
    else
      number = $game_party.gold
      if @number <= number
        Sound.play_shop
        make_deposit
      else
        RPG::SE.new(Lune_Vault::Sound_Item2).play
      end
    end
    deactivate
    close
  end
  def make_deposit
    $game_party.hold_money(@number)
    $game_party.gold -= @number
  end
  def make_draw
    $game_party.hold_money(-@number)
    $game_party.gold += @number
  end
end



#==============================================================================
# ** Game_Party
#------------------------------------------------------------------------------
#  Esta classe gerencia o grupo. Contém informações sobre dinheiro, itens.
# A instância desta classe é referenciada por $game_party.
#==============================================================================

class Game_Party < Game_Unit
alias :lune_vault_initialize :initialize
attr_accessor :gold
attr_accessor :hold_itens
  def initialize
    @hold_money = 0
    @items_vault = {}
    @weapons_vault = {}
    @armors_vault = {}
    lune_vault_initialize
  end
  #--------------------------------------------------------------------------
  # * Acrescentar item (redução)
  #     item          : item
  #     amount        : quantia alterada
  #     include_equip : incluir itens equipados
  #--------------------------------------------------------------------------
  def gain_item_vault(item, amount, include_equip = false)
    container = item_container_vault(item.class)
    return unless container
    last_number = item_number_vault(item)
    new_number = last_number + amount
    container[item.id] = [[new_number, 0].max, max_item_number(item)].min
    container.delete(item.id) if container[item.id] == 0
    if include_equip && new_number < 0
      discard_members_equip(item, -new_number)
    end
    $game_map.need_refresh = true
  end
  def hold_money(g = nil)
    g == nil ? (return @hold_money) : (@hold_money += g)
  end
  def all_items_vault
    items_vault + equip_items_vault
  end
  #--------------------------------------------------------------------------
  # * Lista de itens do grupo
  #--------------------------------------------------------------------------
  def items_vault
    @items_vault.keys.sort.collect {|id| $data_items[id] }
  end
  #--------------------------------------------------------------------------
  # * Lista de armas do grupo
  #--------------------------------------------------------------------------
  def weapons_vault
    @weapons_vault.keys.sort.collect {|id| $data_weapons[id] }
  end
  #--------------------------------------------------------------------------
  # * Lista de armadures do grupo
  #--------------------------------------------------------------------------
  def armors_vault
    @armors_vault.keys.sort.collect {|id| $data_armors[id] }
  end
  #--------------------------------------------------------------------------
  # * Lista de equipamentos do grupo
  #--------------------------------------------------------------------------
  def equip_items_vault
    weapons_vault + armors_vault
  end
  def item_number_vault(item)
    container = item_container_vault(item.class)
    container ? container[item.id] || 0 : 0
  end
  #--------------------------------------------------------------------------
  # * Aquisição das informações da classe de determinado item
  #     item_class : classe do item
  #--------------------------------------------------------------------------
  def item_container_vault(item_class)
    return @items_vault   if item_class == RPG::Item
    return @weapons_vault if item_class == RPG::Weapon
    return @armors_vault  if item_class == RPG::Armor
    return nil
  end
  def items_on_vault
    @all_vault_items = 0
    all_items_vault.each {|item| get_vault_weight(item)}
    @all_vault_items
  end
  #--------------------------------------------------------------------------
  # * Calculo do peso de um item no inventário
  #--------------------------------------------------------------------------
  def get_vault_weight(item)
    if item.note =~ /<peso (.*)>/i
      @all_vault_items += $1.to_i * item_number_vault(item)
    else
      @all_vault_items += Lune_Weight::Default * item_number_vault(item)
    end
  end
end


#==============================================================================
# ** Window_Bank_System
#------------------------------------------------------------------------------
#  Esta janela exibe a quantia de dinheiro.
#==============================================================================

class Window_Bank_System < Window_Base
include Lune_Vault
  #--------------------------------------------------------------------------
  # * Inicialização do objeto
  #--------------------------------------------------------------------------
  def initialize
    super(0, Graphics.height - fitting_height(2), window_width, fitting_height(2))
    refresh(0)
  end
  #--------------------------------------------------------------------------
  # * Aquisição da largura da janela
  #--------------------------------------------------------------------------
  def window_width
    return Graphics.width
  end
  #--------------------------------------------------------------------------
  # * Renovação
  #--------------------------------------------------------------------------
  def refresh(n)
    contents.clear
    case n
    when 0
      draw_text(window_width/10, 0, window_width / 2, line_height, Gold_text, 2 )
      draw_currency_value(value, currency_unit, 4, 0, contents.width - 8)
      draw_text(window_width/10, line_height, window_width / 2, line_height, Gold_text2, 2 )
      draw_currency_value($game_party.hold_money, currency_unit, 4, line_height, contents.width - 8)
    when 1
      draw_text(0, 0, window_width, line_height*2, Vault_text, 0)
    when 2
      draw_text(0, 0, window_width, line_height*2, Vault_text2, 0)
    end
  end
  #--------------------------------------------------------------------------
  # * Aquisição do valor em dinheiro
  #--------------------------------------------------------------------------
  def value
    $game_party.gold
  end
  #--------------------------------------------------------------------------
  # * Aquisição da unidade monetária
  #--------------------------------------------------------------------------
  def currency_unit
    Vocab::currency_unit
  end
  #--------------------------------------------------------------------------
  # * Abertura da janela
  #--------------------------------------------------------------------------
end

#==============================================================================
# ** Window_NumberInputInner
#------------------------------------------------------------------------------
#  Esta janela é utilizada para o comando de eventos [Armazenar Número]
#==============================================================================

class Window_Item_Deposit < Window_NumberInput
attr_accessor :nitens
def initialize(message_window)
  @get_lost_itens = 0
  @nitens = nil
  super(message_window)
end
  #--------------------------------------------------------------------------
  # * Inicialização do processo
  #--------------------------------------------------------------------------
  def start(cond, item)
    @digits_max = 2
    @item = item
    @number = @get_lost_itens
    @number = [[@number, 0].max, 10 ** @digits_max - 1].min
    @index = 0
    update_placement
    create_contents
    refresh
    open
    activate
  end
  def get_pos(t)
    @cond = t unless t == nil
  end
  #--------------------------------------------------------------------------
  # * Atualização da posição da janela
  #--------------------------------------------------------------------------
  def update_placement
    self.width = @digits_max * 20 + padding * 2
    self.height = fitting_height(1)
    self.x = (Graphics.width - width) / 2
    self.y = Graphics.height/2 + height + 20
    self.z = 150
  end

  #--------------------------------------------------------------------------
  # * Definição de resultado ao pressionar o botão de confirmação
  #--------------------------------------------------------------------------
  def process_ok
    @nitens = 0
    if @cond
      make_draw 
    else
      make_deposit 
    end
    deactivate
    close
  end
  def make_deposit
    if @number <= $game_party.item_number(@item)
      if $lune_weight_script
        if Lune_Weight::LimiteB.is_a?(Integer)
          if $game_party.carried_items + $game_party.calc_weight(@item, @number) > Lune_Weight::LimiteB
            RPG::SE.new(Lune_Vault::Sound_Item2).play
          else
            @nitens = -@number 
            RPG::SE.new(Lune_Vault::Sound_Item).play
          end
        else
          @nitens = -@number 
          RPG::SE.new(Lune_Vault::Sound_Item).play 
        end
      else
          @nitens = -@number 
          RPG::SE.new(Lune_Vault::Sound_Item).play
      end
    else
      RPG::SE.new(Lune_Vault::Sound_Item2).play
    end  
  end
  def make_draw
    if @number <= $game_party.item_number_vault(@item)
      if $lune_weight_script
        if $game_party.carried_items + $game_party.calc_weight(@item, @number) > Lune_Weight.weight_limit
          RPG::SE.new(Lune_Vault::Sound_Item2).play
        else
          @nitens = @number 
          RPG::SE.new(Lune_Vault::Sound_Item).play
        end
      else
          @nitens = @number 
          RPG::SE.new(Lune_Vault::Sound_Item).play
      end
    else
      RPG::SE.new(Lune_Vault::Sound_Item2).play
    end
  end
end


#==============================================================================
# ** Window_ItemList
#------------------------------------------------------------------------------
#  Esta janela exibe a lista de itens possuidos na tela de itens.
#==============================================================================

class Window_ItemList_Vault < Window_Selectable
attr_reader :change_view
  #--------------------------------------------------------------------------
  # * Inicialização do objeto
  #     x      : coordenada X
  #     y      : coordenada Y
  #     width  : largura
  #     height : altura
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height)
    @change_view = false
    super
    @category = :none
    @data = []
  end
  #--------------------------------------------------------------------------
  # * Definição de categoria
  #--------------------------------------------------------------------------
  def category=(category)
    return if @category == category
    @category = category
    refresh
    self.oy = 0
  end
  #--------------------------------------------------------------------------
  # * Aquisição do número de colunas
  #--------------------------------------------------------------------------
  def col_max
    return 2
  end
  #--------------------------------------------------------------------------
  # * Aquisição do número máximo de itens
  #--------------------------------------------------------------------------
  def item_max
    @data ? @data.size : 1
  end
  #--------------------------------------------------------------------------
  # * Aquisição das informações do item
  #--------------------------------------------------------------------------
  def item
    @data && index >= 0 ? @data[index] : nil
  end
  #--------------------------------------------------------------------------
  # * Definição de habilitação de seleção
  #--------------------------------------------------------------------------
  def current_item_enabled?
    enable?(@data[index])
  end
  #--------------------------------------------------------------------------
  # * Inclusão do item na lista
  #     item : item
  #--------------------------------------------------------------------------
  def include?(item)
    case @category
    when :item
      item.is_a?(RPG::Item) && !item.key_item?
    when :weapon
      item.is_a?(RPG::Weapon)
    when :armor
      item.is_a?(RPG::Armor)
    when :key_item
      item.is_a?(RPG::Item) && item.key_item?
    else
      false
    end
  end
  #--------------------------------------------------------------------------
  # * Definição de habilitação do item
  #     item : item
  #--------------------------------------------------------------------------
  def enable?(item)
    true
  end
  #--------------------------------------------------------------------------
  # * Criação da lista de itens
  #--------------------------------------------------------------------------
  def make_item_list
    if @change_view
      @data = $game_party.all_items_vault.select {|item| include?(item) }
    else
      @data = $game_party.all_items.select {|item| include?(item) }
    end
    @data.push(nil) if include?(nil)
  end
  #--------------------------------------------------------------------------
  # * Retorno à seleção anterior
  #--------------------------------------------------------------------------
  def select_last
    select(@data.index($game_party.last_item.object) || 0)
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
      draw_item_name(item, rect.x, rect.y, enable?(item))
      draw_item_number(rect, item)
    end
  end
  def get_pos(t)
    @change_view = t unless t == nil
    refresh
  end
  #--------------------------------------------------------------------------
  # * Desenho do número de itens possuido
  #     rect : retângulo
  #     item : item
  #--------------------------------------------------------------------------
  def draw_item_number(rect, item)
    if @change_view
      draw_text(rect, sprintf(":%2d", $game_party.item_number_vault(item)), 2)
    else
      draw_text(rect, sprintf(":%2d", $game_party.item_number(item)), 2)
    end
  end
  #--------------------------------------------------------------------------
  # * Atualização da janela de ajuda
  #--------------------------------------------------------------------------
  def update_help
    @help_window.set_item(item)
  end
  #--------------------------------------------------------------------------
  # * Renovação
  #--------------------------------------------------------------------------
  def refresh
    make_item_list
    create_contents
    draw_all_items
  end
end