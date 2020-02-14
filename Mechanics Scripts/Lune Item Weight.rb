#=======================================================
#         Lune Item Weight
# Autor : Raizen
# Função do script: O script adiciona um baú ou banco,
# dependendo da preferência, que permite guardar itens,
# depositar dinheiro, sacar itens e sacar o dinheiro guardado
#=======================================================
 
# Funções: Adiciona um sistema de pesos no jogo,
# limitando os itens no inventário.
 
 
module Lune_Weight
#=============================================================================#
#========================= Configurações gerais ==============================#
#=============================================================================#
 
# Para configurar um peso para o item, basta ir no database, 
# Ir no bloco de notas e colocar o seguinte.
# <peso n>, aonde n é o valor do peso
# Se quero um certo item para pesar 60, basta eu colocar nas
# Notas dentro do database na parte de itens.
# <peso 60>
 
# Para um item ficar impossibilitado de descartar, basta colocar
# nas notas.
# <keyitem>
 
# Caso não tenha anotação na parte notas do Database, 
# O script assumirá o valor padrão do peso que é de.
Default = 1
 
# Coloque o peso para cada 100Gps que tiver.
Gold = 1
 
# Receber o item mesmo sobre o peso?
# Para evitar perdas como itens importantes ou outros itens, 
# Você pode permitir que o personagem receba o item mesmo se ficar acima
# do peso, caso não permita é altamente recomendável que leia logo a seguir
# sobre como criar condições para o caso de estar acima do peso, para evitar
# que o personagem deixe de receber itens essenciais para o jogo.
# true = recebe, false = não recebe
# Essa função pode ser modificada ao longo do jogo com o comando
# Lune_Weight.receive(true) ou Lune_Weight.receive(false)
Receive = false
 
# Caso marque true, você pode configurar para o personagem ficar travado 
# quando estiver acima do peso.
Travar = false
 
# Se marcar false, é importante saber como configurar condições por eventos,
# para evitar que um item não seja recebido.
 
# Escolha uma variável para receber a quantidade de peso carregado.
Var_C = 1
# Escolha uma variável para receber a quantidade de peso máximo.
Var_M = 2
# A partir dessas 2 variáveis é possível criar condições para caso depois de
# receber o item fique acima do peso que descartaria o item, ou não.
 
LimiteB = 8000 # Configure apenas se estiver usando o Lune_Vault
# para tirar o limite do baú coloque LimiteB = ""
#=============================================================================#
#===================== Configurações do limite de peso =======================#
#=============================================================================#
 
# Quantidade máxima de peso carregado.
# Para configurar o peso máximo você pode, 
# colocar um valor de uma variável, você pode colocar um número constante
# ou colocar a força dos persongens do grupo.
 
# Para indicar que o valor a ser carregado é apenas a força do ator principal 
# coloque :for1
# Para indicar que o valor a ser carregado é a somatória das forças, coloque
# :all_for
# Para indicar que o valor a ser carregado é a apenas o level do ator principal
#, coloque :lvl1
# Para indicar que o valor a ser carregado é a somatória dos leveis, coloque
# :all_lvl
# Para indicar que é uma variável coloque :var
# Para indicar que é um número fixo coloque :fix
 
# Exemplo Carry_Limit = lvl1 fará ele considerar só o 
# level do primeiro personagem
Carry_Limit = :for
 
# Caso faça de acordo com a força ou o level acima indique aqui a 
#fórmula de peso em relação a força ou level.
 
# aonde o at significa o atributo (level ou força) que será colocado
# na fórmula, por exemplo.
# Se eu quero que o peso seja 2 vezes o valor da força do personagem eu 
# colocaria
 
# def self.weight_formula(at)
#   at * 2
# end
 
# Caso seja uma variável coloque o ID da variavel, ou se for 
# um número fixo, coloque o ID desse número.
 
# Exemplo:
 
# def self.weight_formula(at)
#   20
# end
 
# O caso acima representa que ele será a variável 20, ou o limite
# do peso será 20, dependendo do que foi escolhido dentro do 
# Carry_Limit.
 
 
def self.weight_formula(at)
  at * 10 + 1000
end
 
 
#===================== Configurações do vocabulário ==========================#
# Para o vocabulário coloque sempre a palavra em aspas "", ou ''
# Unidade de peso
PS = ' Oz'
 
# Vocabulário no menu e na loja.
Peso = 'Peso:'
Carregando = 'Carregando: '
Bau = 'No Baú: ' # Apenas caso use o script Lune_Vault
 
# Vocabulário na janela de itens.
Usar = 'Usar'
Descartar = 'Descartar'
 
#=============================================================================#
#========================== Aqui começa o script =============================#
#=============================================================================#
def self.receive(bol = nil)
  @bol = bol unless bol == nil
  return @bol
end
  #--------------------------------------------------------------------------
  # * Calculo do limite de peso
  #--------------------------------------------------------------------------
  def self.weight_limit
    return 10 unless $game_party.members[0]
    case Carry_Limit
    when :for1
      weight = weight_formula($game_party.members[0].param(2))
    when :all_for
      weight = 0
      for members in 0...$game_party.members.size - 1
        weight += weight_formula($game_party.members[members].param(2))
      end
    when :lvl1
      weight = weight_formula($game_party.members[0].level)
    when :all_lvl
      weight = 0
      for members in 0...$game_party.members.size - 1
        weight += weight_formula($game_party.members[members].level)
      end
    when :fix
      weight = weight_formula(0)
    when :var
      weight = $game_variables[weight_formula(0)]
    end
    $game_variables[Var_M] = weight
    weight
  end
end
 
Lune_Weight.receive(Lune_Weight::Receive)
 
#==============================================================================
# ** Game_Party
#------------------------------------------------------------------------------
#  Esta classe gerencia o grupo. Contém informações sobre dinheiro, itens.
# A instância desta classe é referenciada por $game_party.
#==============================================================================
 
class Game_Party < Game_Unit
alias :lune_weight_gain :gain_item
  #--------------------------------------------------------------------------
  # * Quantidade de itens carregados mais os itens equipados
  #--------------------------------------------------------------------------
  def carried_items
    @all_carried_items = 0
    all_items.each {|item| get_weight(item)}
    for i in 0...4
      members.each {|actor| @all_carried_items += calc_weight(actor.equips[i], 1)}
    end
    @all_carried_items += Lune_Weight::Gold * gold/100
    $game_variables[Lune_Weight::Var_C] = @all_carried_items
    @all_carried_items
  end
  #--------------------------------------------------------------------------
  # * Calculo do peso de um item no inventário
  #--------------------------------------------------------------------------
  def get_weight(item)
    if item.note =~ /<peso (.*)>/i
      @all_carried_items += $1.to_i * item_number(item)
    else
      @all_carried_items += Lune_Weight::Default * item_number(item)
    end
  end
  #--------------------------------------------------------------------------
  # * Calculo do peso de um item relativo a quantidade
  #--------------------------------------------------------------------------
  def calc_weight(item, amount)
    return 0 unless item
    if item.note =~ /<peso (.*)>/i
      carried_itens = $1.to_i * amount
    else
      carried_itens = Lune_Weight::Default * amount
    end
    carried_itens
  end
  #--------------------------------------------------------------------------
  # * Acrescentar item (redução)
  #     item          : item
  #     amount        : quantia alterada
  #     include_equip : incluir itens equipados
  #--------------------------------------------------------------------------
  def gain_item(item, amount, include_equip = false)
    if Lune_Weight.receive
      lune_weight_gain(item, amount, include_equip = false)
      return
    end
    return if item == nil
    weight = calc_weight(item, amount) + carried_items
    while weight > Lune_Weight.weight_limit
      amount -= 1
      weight = calc_weight(item, amount) + carried_items
      return if amount == 0
    end
    lune_weight_gain(item, amount, include_equip = false)
  end
end
 
#==============================================================================
# ** Scene_Shop
#------------------------------------------------------------------------------
#  Esta classe executa o processamento da tela de loja.
#==============================================================================
 
class Scene_Shop < Scene_MenuBase
alias :lune_max_buy :max_buy
  #--------------------------------------------------------------------------
  # * Aquisição do número máximo disponível para compra
  #--------------------------------------------------------------------------
  def max_buy
    max = lune_max_buy
    weight = $game_party.calc_weight(@item, max) + $game_party.carried_items
    while weight > Lune_Weight.weight_limit && max > 0
      max -= 1
      weight = $game_party.calc_weight(@item, max) + $game_party.carried_items
    end
    max
  end
  #--------------------------------------------------------------------------
  # * Criação da janela de ajuda.
  #--------------------------------------------------------------------------
  def create_help_window
    @help_window = Window_Weight_Help.new
    @help_window.viewport = @viewport
    @get_item_num = $game_party.carried_items
  end
  #--------------------------------------------------------------------------
  # * Atualização da janela de peso
  #--------------------------------------------------------------------------
  def update
    super
    if @get_item_num != $game_party.carried_items
      @help_window.refresh 
      @get_item_num = $game_party.carried_items
    end
  end
end
 
#==============================================================================
# ** Window_ShopBuy
#------------------------------------------------------------------------------
#  Esta janela exibe bens compráveis na tela de loja.
#==============================================================================
 
class Window_ShopBuy < Window_Selectable
alias :lune_enable_item :enable?
  #--------------------------------------------------------------------------
  # * Definição de habilitação do item
  #     item : item
  #--------------------------------------------------------------------------
  def enable?(item)
    return false if $game_party.calc_weight(item, 1) + $game_party.carried_items > Lune_Weight.weight_limit
    lune_enable_item(item)
  end
end
 
 
#==============================================================================
# ** Window_Help
#------------------------------------------------------------------------------
#  Esta janela exibe explicação de habilidades e itens e outras informações.
#==============================================================================
 
class Window_Weight_Help < Window_Base
include Lune_Weight
  #--------------------------------------------------------------------------
  # * Inicialização do objeto
  #     line_number : número de linhas
  #--------------------------------------------------------------------------
  def initialize(line_number = 2, bau = false)
    @bau = bau
    super(0, 0, Graphics.width, fitting_height(line_number))
  end
  #--------------------------------------------------------------------------
  # * Configuração de texto
  #     text : texto
  #--------------------------------------------------------------------------
  def set_text(text)
    if text != @text
      @text = text
      refresh
    end
  end
  def on_bau(bau = false)
    @bau = bau
  end
  #--------------------------------------------------------------------------
  # * Limpeza
  #--------------------------------------------------------------------------
  def clear
    set_text("")
  end
  #--------------------------------------------------------------------------
  # * Definição de item
  #     item : habilidades, itens, etc.
  #--------------------------------------------------------------------------
  def set_item(item)
    @item = item
    set_text(item ? item.description : "")
  end
  #--------------------------------------------------------------------------
  # * Renovação
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    draw_text_ex(4, 0, @text)
    if @item
      text = Peso + $game_party.calc_weight(@item,1).to_s + PS
      draw_text(4, line_height, 200, line_height, text, 0)
      if @bau == true
        LimiteB == "" ? text_lim = "????" : text_lim = LimiteB
        text = Bau + $game_party.items_on_vault.to_s + "/" + text_lim.to_s + PS
      else
        text = Carregando + $game_party.carried_items.to_s + "/" + Lune_Weight.weight_limit.to_s + PS
      end
      draw_text(- 20, line_height, Graphics.width, line_height, text, 2) 
    end
  end
end
 
 
#==============================================================================
# ** Game_Player
#------------------------------------------------------------------------------
#  Esta classe gerencia o jogador. 
# A instância desta classe é referenciada por $game_player.
#==============================================================================
 
class Game_Player < Game_Character
alias :lune_move_by :move_by_input
  #--------------------------------------------------------------------------
  # * Processamento de movimento através de pressionar tecla
  #--------------------------------------------------------------------------
  def move_by_input
    return if Lune_Weight::Travar && $game_party.carried_items > Lune_Weight.weight_limit
    lune_move_by
  end
end
 
 
#==============================================================================
# ** Scene_Item
#------------------------------------------------------------------------------
#  Esta classe executa o processamento da tela de item.
#==============================================================================
class Scene_Item < Scene_ItemBase
alias raizen_combine_start start
  def start
    raizen_combine_start
    @combine_item = Window_Item_Combine.new
    @combine_item.viewport = @viewport
    @combine_item.set_handler(:new_game, method(:command_use))
    @combine_item.set_handler(:continue, method(:command_combine))
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
 
  def update
    super
    if @number_window and @number_window.nitens == true
        @number_window.nitens = false
        @combine_item.close
        @item_window.refresh
        @help_window.refresh
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
    if @number_window and !@number_window.close?
      @combine_item.activate
      return
    end
    @number_window = Window_NumberInputInner.new(Window_Base.new(0,0,0,0), item, @item_window.index)
    @number_window.viewport = @viewport
    @number_window.start
  end
  def create_help_window
    @help_window = Window_Weight_Help.new
    @help_window.viewport = @viewport
  end
end
 
#==============================================================================
# ** Window_MenuStatus
#------------------------------------------------------------------------------
#  Esta janela exibe os parâmetros dos membros do grupo na tela de menu.
#==============================================================================
 
class Window_Item_Combine < Window_Command
include Lune_Weight
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
    add_command(Usar,   :new_game,   true)
    add_command(Descartar,  :continue,  true)
  end
end
 
 
 
 
#==============================================================================
# ** Scene_ItemBase
#------------------------------------------------------------------------------
#  Esta é a superclasse das classes que executam as telas de itens e 
# habilidades.
#==============================================================================
 
class Scene_Item < Scene_ItemBase
  def determine_item
    @combine_item.close if @combine_item
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
    number = $game_party.item_number(@item)
    if @number <= number
      make_icon 
    else
      Sound.play_cancel
    end
    deactivate
    @nitens = true
    close
  end
  def make_icon
    @nitens = true
    if @item.note =~ /<keyitem>/
      Sound.play_cancel
    else
      Sound.play_ok
      $game_party.lose_item(@item, @number)
    end
  end
end
 
#==============================================================================
# ** Window_ItemList
#------------------------------------------------------------------------------
#  Esta janela exibe a lista de itens possuidos na tela de itens.
#==============================================================================
 
class Window_ItemList < Window_Selectable
  #--------------------------------------------------------------------------
  # * Definição de habilitação do item
  #     item : item
  #--------------------------------------------------------------------------
  def enable?(item)
    true
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
    $game_party.lose_item(new_item, 1)
    $game_party.gain_item(old_item, 1)
    return true
  end
end

$lune_weight_script = true