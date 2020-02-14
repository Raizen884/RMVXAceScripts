#=======================================================
#        Lune Item Craft
# Autor: Raizen
# Comunidade: centrorpg.com
# Compatibilidade: RMVXAce

# Adiciona a função de combinar itens no menu, 
# semelhante a outros jogos como Diablo II.
#=======================================================

module Lune_Combine
#===========================================================================
# Caso utilize a janela de formulas configure a seguir, caso contrário 
# pule para a parte de Perder Itens?
# Texto Superior na janela
Text_comb1 = "Veja a seguir os itens fundidos e seus resultados"
Text_comb2 = "Para combinar itens entre no Menu"
# Nome que aparecerá no menu.
Craft = "Craft"
# Adicionar no menu?
# true = sim, false = não.
Craft_Menu = true

# Para ativar a janela de Craft, SceneManager.call(Scene_LuneCraft)
# Pode ser ativado pelo Chamar Script.
#===========================================================================
# Perder Itens?
# Ao ser feito a combinação se deseja que os itens voltem
# ou que sejam perdidos.
# true = perde, false = não perde
Lose_Itens = true
# Som a ser tocado ao fundir itens,
# O som tem que estar na pasta SE do projeto.
Sound = "Item3"
# Texto na janela inferior de combinação
TextComb = "Combinação - Aperte A para confirmar"
# Para criar novas combinações copie a sequencia de comandos e adicione
# ao valor dentro de Combination[n].
# Tecla a ser pressionada para fazer a fusão,
# lembrando que são as mesmas teclas dos eventos.
# A = SHIFT, X = A, Y = S, Z = D, L = Q, R = W.
# Nesse formato :A por exemplo.
Tecla = :A
  Combination = []
  #=========================================================================
  # Combinação 0 => 10 poções grandes                                     
  #=========================================================================
   Combination[0] = {
   # ID dos itens que serão fundidos
  "Itens ID"      => [1, 2, 3],
   # Tipo dos itens que seão fundidos, na mesma ordem que acima.
   # 1 = item, 2 = armas, 3 = armaduras
  "Itens Types"   => [1, 1, 1],
   # Quantidade necessaria de cada item
  "Quantity"      => [4, 5, 5],
   # Resultado final , ID do item.
  "Result Item"   =>  3,
   # Tipo do item obtido.
   # 1 = item, 2 = armas, 3 = armaduras
  "Res Type"      =>  1,  
   # Quantidade do item obtido
  "ResQuantity"   =>  10    }
  #=========================================================================
  # Combinação 1 => 5 machados                                    
  #=========================================================================
   Combination[1] = {
   # ID dos itens que serão fundidos
  "Itens ID"      => [1, 2, 3],
   # Tipo dos itens que seão fundidos, na mesma ordem que acima.
   # 1 = item, 2 = armas, 3 = armaduras
  "Itens Types"   => [1, 1, 1],
   # Quantidade necessaria de cada item
  "Quantity"      => [3, 3, 3],
   # Resultado final , ID do item.
  "Result Item"   =>  3,
   # Tipo do item obtido.
   # 1 = item, 2 = armas, 3 = armaduras
  "Res Type"      =>  2,  
   # Quantidade do item obtido
  "ResQuantity"   =>  5    }
  #=========================================================================
  # Combinação 2 => 1 poção média                                     
  #=========================================================================
   Combination[2] = {
   # ID dos itens que serão fundidos
  "Itens ID"      => [1],
   # Tipo dos itens que seão fundidos, na mesma ordem que acima.
   # 1 = item, 2 = armas, 3 = armaduras
  "Itens Types"   => [1],
   # Quantidade necessaria de cada item
  "Quantity"      => [5],
   # Resultado final , ID do item.
  "Result Item"   =>  2,
   # Tipo do item obtido.
   # 1 = item, 2 = armas, 3 = armaduras
  "Res Type"      =>  1,  
   # Quantidade do item obtido
  "ResQuantity"   =>  1    }
  
  
#===========================================================================
# Inicio do script
#===========================================================================
end

class Scene_Item < Scene_ItemBase
alias raizen_combine_start start
alias lune_terminate terminate
  def start
    raizen_combine_start
    $combine_itemicon = []
    $combine_itemcheck = []
    @combine_item = Window_Item_Combine.new
    @combine_item.viewport = @viewport
    @combine_window = Window_Combine.new
    @combine_window.viewport = @viewport
    @combine_item.set_handler(:new_game, method(:command_use))
    @combine_item.set_handler(:continue, method(:command_combine))
    @combine_item.set_handler(:shutdown, method(:command_release))
  end
  def create_item_window
    wy = @category_window.y + @category_window.height
    wh = Graphics.height - wy
    @item_window = Window_ItemList.new(0, wy, Graphics.width, wh - 80)
    @item_window.viewport = @viewport
    @item_window.help_window = @help_window
    @item_window.set_handler(:ok,     method(:on_item_ok))
    @item_window.set_handler(:cancel, method(:on_item_cancel))
    @category_window.item_window = @item_window
  end
  def on_item_ok
    if item == nil
      @item_window.activate
      return 
    end
    if @combine_item.close?
      @combine_item.open
      @combine_item.activate
    else
      determine_item    
    end
  end
  def return_itens
  return if $combine_itemicon == []
    for n in 0...$combine_itemicon.size
      $game_party.gain_item($combine_itemicon[n], $combine_itens[n])
    end
    $combine_itemicon = []
  end
  def update
    super
    if Input.trigger?(Lune_Combine::Tecla)
      @noreturn = false
      for n in 0...Lune_Combine::Combination.size
        @types = true
        @lune_combination = []
        for i in 0...Lune_Combine::Combination[n]['Itens Types'].size
          case Lune_Combine::Combination[n]['Itens Types'][i]
          when 1
            @lune_combination.push($data_items[Lune_Combine::Combination[n]['Itens ID'][i]])
          when 2
            @lune_combination.push($data_weapons[Lune_Combine::Combination[n]['Itens ID'][i]])
          when 3
            @lune_combination.push($data_armors[Lune_Combine::Combination[n]['Itens ID'][i]])
          end
        end
        for inc in 0...$combine_itemicon.size
          @types = false unless @lune_combination.include?($combine_itemicon[inc])
          get_pos = $combine_itemicon.index(@lune_combination[inc])
          if get_pos != nil
          @types = false if Lune_Combine::Combination[n]['Quantity'][inc] != $combine_itens[get_pos]
          end
        end
        @types = false unless @lune_combination.size == $combine_itemicon.size
        if @types 
          @noreturn = true
          gotoforge(n)
        end
      end
      return if @noreturn
      @number_window.close if @number_window
      command_release(Lune_Combine::Lose_Itens)
      Sound.play_buzzer
    end
    @combine_window.refresh
    if @number_window and @number_window.nitens == true
        @number_window.nitens = false
        @combine_item.close
        @item_window.refresh
        @item_window.activate
    end
    if Input.trigger?(:B) and !@combine_item.close?
      Sound.play_cancel
      if @number_window and !@number_window.close?
        @number_window.close
        @combine_item.activate
      else
        @combine_item.close
        @item_window.activate
      end
    end
  end
  def command_use
    determine_item
  end
  def command_combine
    p @index
    if @number_window and !@number_window.close?
      @combine_item.activate
      return
    end
    @number_window = Window_NumberInputInner.new(Window_Base.new(0,0,0,0), item, @item_window.index)
    @number_window.viewport = @viewport
    @number_window.start
  end
  def command_release(n = false)
    return_itens unless n
    $combine_itens = []
    $combine_itemicon = []
    @item_window.refresh
    @combine_item.close
    @item_window.activate
  end
  def terminate
    return_itens
    lune_terminate
  end
  def gotoforge(n)
    $combine_itens = []
    $combine_itemicon = []
    case Lune_Combine::Combination[n]['Res Type']
    when 1
      get_item = $data_items[Lune_Combine::Combination[n]['Result Item']]
    when 2
      get_item = $data_weapons[Lune_Combine::Combination[n]['Result Item']]
    when 3
      get_item = $data_armors[Lune_Combine::Combination[n]['Result Item']]
    end
    RPG::SE.new(Lune_Combine::Sound).play
    $game_party.gain_item(get_item, Lune_Combine::Combination[n]['ResQuantity'])
    @item_window.refresh
  end
end
#==============================================================================
# ** Window_Combine
#------------------------------------------------------------------------------
#  Esta janela exibe os itens a serem fundidos.
#==============================================================================

class Window_Combine < Window_Base
include Lune_Combine
  #--------------------------------------------------------------------------
  # * Inicialização do objeto
  #--------------------------------------------------------------------------
  def initialize
    super(0, window_height, Graphics.width, 80)
    $combine_itens = []
    refresh
  end
  #--------------------------------------------------------------------------
  # * Aquisição da largura da janela
  #--------------------------------------------------------------------------
  def window_width
    return 160
  end
  def window_height
    Graphics.height - 80
  end
  
  #--------------------------------------------------------------------------
  # * Renovação
  #--------------------------------------------------------------------------
  def refresh
    contents.clear

    draw_text(0, -5, Graphics.width, 30, TextComb, 0)
    unless $combine_itens.nil?
      for i in 0...$combine_itens.size
        draw_combine_icons(i)
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Aquisição do valor em dinheiro
  #--------------------------------------------------------------------------
  def value
    $game_party.gold
  end
  def draw_combine_icons(i)
    item_icon = $combine_itemicon[i].icon_index
    item_number = $combine_itens[i]
    draw_icon(item_icon, 0 + i*50, 30)
    draw_text(i*50 + 5, 30, 20, 30, "x", 0)
    draw_text(i*50 + 20, 30, 20, 30, item_number, 0)
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
  def open
    refresh
    super
  end
end

#==============================================================================
# ** Window_MenuStatus
#------------------------------------------------------------------------------
#  Esta janela exibe os parâmetros dos membros do grupo na tela de menu.
#==============================================================================

class Window_Item_Combine < Window_Command

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
    add_command("Usar",   :new_game,   true)
    add_command("Combinar",  :continue,  true)
    add_command("Liberar",  :shutdown,  true)
  end

end




#==============================================================================
# ** Scene_ItemBase
#------------------------------------------------------------------------------
#  Esta é a superclasse das classes que executam as telas de itens e 
# habilidades.
#==============================================================================

class Scene_ItemBase < Scene_MenuBase
  def determine_item
    @combine_item.close
    if item.is_a?(RPG::Item) and item.for_friend?
      show_sub_window(@actor_window)
      @actor_window.select_for_item(item)
    else
      item.is_a?(RPG::Item) ? use_item : Sound.play_buzzer 
      activate_item_window
    end
  end
end

#==============================================================================
# ** Window_NumberInputInner
#------------------------------------------------------------------------------
#  Esta janela é utilizada para o comando de eventos [Armazenar Número]
#==============================================================================

class Window_NumberInputInner < Window_NumberInput
attr_accessor :nitens
def initialize(message_window, item, index_2)
  @index_2 = index_2
  @item = item
  @get_lost_itens = 0
  super(message_window)
end
  #--------------------------------------------------------------------------
  # * Inicialização do processo
  #--------------------------------------------------------------------------
  def start
    @digits_max = 2
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
    self.y = Graphics.height/2 - height
    self.z = 150
  end

  #--------------------------------------------------------------------------
  # * Definição de resultado ao pressionar o botão de confirmação
  #--------------------------------------------------------------------------
  def process_ok
    Sound.play_ok
    number = $game_party.item_number(@item)
    if @number <= number
    make_icon 
    end
    deactivate
    @nitens = true
    close
  end
  def make_icon
    @nitens = true
    $combine_itemicon.push(@item)
    $combine_itemcheck.push(@item.id)
    $combine_itens.push(@number)
    $game_party.lose_item(@item, @number)
  end
end
