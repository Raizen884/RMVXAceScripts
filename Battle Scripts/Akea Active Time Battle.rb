#=======================================================
#        Akea Active Time Battle
# Author: Raizen
# Community: http://www.centrorpg.com/
# Compatibility: RMVXAce
#
#=======================================================
# Instruções: Coloque acima dos outros add-ons de batalha
# O script modifica o sistema padrão por turnos por um ativo!

# =========================Don't Modify==============================

$imported ||= Hash.new
$imported[:lune_active_battle] = true
module Akea_Active_Battle
Atb_Bar_Pos = []
# =========================Don't Modify==============================
# Você pode adicionar um custo de atb fixo para uma habilidade, 
# basta colocar ou no item, ou na habilidade o seguinte.
# <use_atb cost> aonde cost é o custo de atb, (lembrando que o atb máximo é 1000)
# <use_atb 500> em um skill do Banco de dados, fará com que o personagem
# gaste apenas 500 dos 1000 de atb ao invés da barra inteira.




# Essa é a taxa de atualização da barra, quanto menor, mais preciso
# porém pode ter impacto maior na performance da batalha
Update_Rate = 10

# Cofigure aqui as barras de atb

# Coloque Atb_Bar = 'nome_da_imagem' SE for utilizar uma imagem
# no lugar da barra de atb padrão, caso utilise a padrão basta
# colocar tb_Bar = ""
Atb_Bar = ""

# Configure a posição das barras de atb para cada personagem na
# batalha, CASO utilize imagens para as barras de atb 
# seguindo a posição [x, y, z]
Atb_Bar_Pos[0] = [200, 200, 10]
Atb_Bar_Pos[1] = [200, 240, 10]
Atb_Bar_Pos[2] = [200, 280, 10]
Atb_Bar_Pos[3] = [200, 320, 10]


# Esse é o quanto pode variar a barra de atb no inicio de uma batalha,
# por exemplo Base_Atb_Range = 100, significa que cada battler pode iniciar
# com 0 até 100 de atb preenchido(máximo é 1000)
Base_Atb_Range = 200

# Coloque aqui a quantidade de atb que o battler terá caso entre no modo
# "surpresa", por exemplo se os personagens pegarem um inimigo de surpresa
# o atb de todos os personagens da party iniciarão com esse valor
Base_Atb_Preemptive = 1000



# ========================Configurações de Fuga==============================
# Permitir fuga? Caso selecione true(sim), configure o que está abaixo
Allow_Flee = true

# Tecla de fuga, seguindo o mesmo padrão do RPG Maker VX Ace
#--------------------------------------------------------
# Mapeamento de Teclas do RPG Maker VX Ace, para auxiliar na configuração
# X = Tecla A  ;  Y = Tecla S  ;  Z = Tecla D
# L = Tecla Q  ;  R = Tecla W  ;  SHIFT
# RIGHT = Direcional(Direita) ; LEFT Direcional(Esquerda)
# Up = Direcional(Cima) ; DOWN = Direcional(Baixo)
Flee_Input = :SHIFT

# Imagem que ficará na frente da barra
Flee_Back = "base_input_hud"

# Imagem da Barra
Flee_Bar = "bar_input"

# Selecione caso use algum sistema que visualiza os battlers, 
# Isso permite o script buscar a posição dele para colocar as barras de fuga
Has_Ator = true

# Posição das barras de fuga em [x, y]
# Perceba que caso coloque true acima, a posição é em relação aos battlers
# Caso coloque false, é a posição absoluta da tela
Flee_Back_Pos = [-60, -80]
Flee_Bar_Pos = [-55, -75]


# ======================== Configurações de Fórmulas ==============================

# IMPORTANTE!!:
# Essa configuração é considerada relativamente avançada, salve os valores 
# padrões antes, e depois modifique-os como desejar, lembrando que a tabela
# de parametro está no Game_BattlerBase, e o param(6) é a agilidade!

# Fórmula de velocidade de escape
  def self.flee_formula(actor, enemy)
    (actor.param(6)/enemy.param(6))/500.0
  end
  
# Fórmula do preenchimento da barra de atb, lembrando que 1000 é o valor 
# máximo de atb!!
  def self.atb_formula(subject)
    30 + subject.param(6)/5
  end
  
end




#==============================================================================
# Aqui começa o Script!!!
#==============================================================================
#==============================================================================
# ** Game_BattlerBase
#------------------------------------------------------------------------------
#  Esta classe gerencia os battlers. Contém os principais método de
# cálculo da características especiais.
# Esta classe é usada como superclasse da classe Game_Battler.
#==============================================================================

class Game_BattlerBase
alias :akea_atb_initialize :initialize
  #--------------------------------------------------------------------------
  # * Variáveis públicas
  #--------------------------------------------------------------------------
  attr_accessor :atb
  def matb;  1000;   end    # MP Máximo
  #--------------------------------------------------------------------------
  # * Inicialização do objeto
  #     actor_id : ID do herói
  #--------------------------------------------------------------------------
  def initialize(*args, &block)
    akea_atb_initialize(*args, &block)
    @atb = 0
  end
  #--------------------------------------------------------------------------
  # * Taxa da barra de atb
  #--------------------------------------------------------------------------
  def atb_rate
    @atb.to_f / matb
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
alias :akea_atb_next_command :next_command
  #--------------------------------------------------------------------------
  # * Próxima entrada de comandos 
  #--------------------------------------------------------------------------
  def next_command
    return false if @atb < matb
    akea_atb_next_command
  end
end
#==============================================================================
# ** Window_BattleStatus
#------------------------------------------------------------------------------
#  Esta janela exibe as condições de todos membros do grupo na tela de batalha.
#==============================================================================

class Window_BattleStatus < Window_Selectable
alias :akea_atb_initialize :initialize
alias :akea_atb_dispose :dispose
  #--------------------------------------------------------------------------
  # * Inicialização do objeto
  #--------------------------------------------------------------------------
  def initialize
    create_sprite_bars unless Akea_Active_Battle::Atb_Bar == ''
    akea_atb_initialize
    refresh_atb
  end
  #--------------------------------------------------------------------------
  # * Criação dos objetos
  #--------------------------------------------------------------------------
  def create_sprite_bars
    @atb_bars = Array.new
    for n in 0...$game_party.battle_members.size
      @atb_bars[n] = Sprite.new
      @atb_bars[n].bitmap = Cache.akea(Akea_Active_Battle::Atb_Bar)
      @atb_bars[n].x = Akea_Active_Battle::Atb_Bar_Pos[n][0]
      @atb_bars[n].y = Akea_Active_Battle::Atb_Bar_Pos[n][1]
      @atb_bars[n].z = Akea_Active_Battle::Atb_Bar_Pos[n][2]
    end
  end
  #--------------------------------------------------------------------------
  # * Atualização da barra de atb
  #--------------------------------------------------------------------------
  def refresh_atb
    Akea_Active_Battle::Atb_Bar == '' ? refresh : refresh_sprite_bars
  end
  #--------------------------------------------------------------------------
  # * Atualização das imagens de atb
  #--------------------------------------------------------------------------
  def refresh_sprite_bars
    $game_party.battle_members.each{|actor| draw_actor_atb_sprite(actor)}
  end
  #--------------------------------------------------------------------------
  # * Atualização da barra por personagem
  #--------------------------------------------------------------------------
  def draw_actor_atb_sprite(actor)
    @atb_bars[$game_party.battle_members.index(actor)].zoom_x = actor.atb_rate
  end
  #--------------------------------------------------------------------------
  # * Aquisição da largura da janela
  #--------------------------------------------------------------------------
  def window_width
    Graphics.width
  end
  #--------------------------------------------------------------------------
  # * Aquisição da largura da área do medidor
  #--------------------------------------------------------------------------
  def gauge_area_width
    return 348
  end
  #--------------------------------------------------------------------------
  # * Desenho da área do medidor (com TP)
  #     rect  : retângulo
  #     actor : herói
  #--------------------------------------------------------------------------
  def draw_gauge_area_with_tp(rect, actor)
    draw_actor_hp(actor, rect.x + 0, rect.y, 72)
    draw_actor_mp(actor, rect.x + 82, rect.y, 64)
    draw_actor_tp(actor, rect.x + 156, rect.y, 64)
    draw_actor_atb(actor, rect.x + 230, rect.y, 64)
  end
  #--------------------------------------------------------------------------
  # * Desenho da área do medidor (sem TP)
  #     rect  : retângulo
  #     actor : herói
  #--------------------------------------------------------------------------
  def draw_gauge_area_without_tp(rect, actor)
    draw_actor_hp(actor, rect.x + 0, rect.y, 134)
    draw_actor_mp(actor, rect.x + 120,  rect.y, 76)
    draw_actor_atb(actor, rect.x + 240, rect.y, 76)
  end
  #--------------------------------------------------------------------------
  # * Desenho do MP
  #     actor  : herói
  #     x      : coordenada X
  #     y      : coordenada Y
  #     width  : largura
  #--------------------------------------------------------------------------
  def draw_actor_atb(actor, x, y, width = 124)
    draw_gauge(x, y, width, actor.atb_rate, atb_gauge_color1, atb_gauge_color2)
    change_color(system_color)
    draw_text(x, y, 30, line_height, "ATB")
  end
  def atb_gauge_color1;      Color.new(200, 50, 150, 255);  end;    # Sistema
  def atb_gauge_color2;      Color.new(250, 50, 200, 255);  end;    # Perigo
  #--------------------------------------------------------------------------
  # * Dispose dos objetos
  #--------------------------------------------------------------------------
  def dispose
    @atb_bars.each{|bar| bar.bitmap.dispose; bar.dispose} if @atb_bars
    akea_atb_dispose
  end
end

#==============================================================================
# ** Scene_Battle
#------------------------------------------------------------------------------
#  Esta classe executa o processamento da tela de batalha.
#==============================================================================

class Scene_Battle < Scene_Base
alias :akea_atb_update :update
alias :akea_atb_start :start
alias :akea_atb_start_actor_command_selection :start_actor_command_selection
alias :akea_atb_next_command :next_command
alias :akea_atb_turn_end :turn_end
alias :akea_atb_terminate :terminate
  #--------------------------------------------------------------------------
  # * Fim de turno
  #--------------------------------------------------------------------------
  def turn_end
    if !@actor_atb_array.empty? && $game_party.members[@actor_atb_array.first].dead?
      @actor_atb_array.shift 
      @back_flee_atb.opacity = 0
      @bar_flee_atb.opacity = 0  
      @start_flee = true
    end
    akea_atb_turn_end
  end
  #--------------------------------------------------------------------------
  # * Inicialização da cena
  #--------------------------------------------------------------------------
  def start
    akea_initialize_atb_variables
    akea_initialize_atb_states
    akea_atb_start
  end
  #--------------------------------------------------------------------------
  # * Inicialização das variáveis
  #--------------------------------------------------------------------------
  def akea_initialize_atb_variables
    @actor_atb_array = []
    @enemy_atb_array = -1
    @back_flee_atb = Sprite.new
    @back_flee_atb.bitmap = Cache.akea(Akea_Active_Battle::Flee_Back)
    @back_flee_atb.x = Akea_Active_Battle::Flee_Back_Pos[0]
    @back_flee_atb.y = Akea_Active_Battle::Flee_Back_Pos[1]
    @back_flee_atb.opacity = 0
    @back_flee_atb.z = 200
    @bar_flee_atb = Sprite.new
    @bar_flee_atb.bitmap = Cache.akea(Akea_Active_Battle::Flee_Bar)
    @bar_flee_atb.x = Akea_Active_Battle::Flee_Bar_Pos[0]
    @bar_flee_atb.y = Akea_Active_Battle::Flee_Bar_Pos[1]
    @bar_flee_atb.opacity = 0
    @bar_flee_atb.zoom_x = 0
    @start_flee = true
  end
  #--------------------------------------------------------------------------
  # * Inicialização de status do atb
  #--------------------------------------------------------------------------
  def akea_initialize_atb_states
    if BattleManager.get_preemptive
      $game_party.battle_members.each{|member| member.atb = Akea_Active_Battle::Base_Atb_Preemptive}
      $game_troop.members.each{|member| member.atb = rand(Akea_Active_Battle::Base_Atb_Range)}
    elsif BattleManager.get_surprise
      $game_troop.members.each{|member| member.atb = Akea_Active_Battle::Base_Atb_Preemptive}
      $game_party.battle_members.each{|member| member.atb = rand(Akea_Active_Battle::Base_Atb_Range)}
    else
      all_battle_members.each{|member| member.atb = rand(Akea_Active_Battle::Base_Atb_Range)}
    end
  end
  #--------------------------------------------------------------------------
  # * Atualização da tela
  #--------------------------------------------------------------------------
  def update
    call_update_flee if Akea_Active_Battle::Allow_Flee
    call_update_atb_bar if Graphics.frame_count % Akea_Active_Battle::Update_Rate == 0
    akea_atb_update
  end
  #--------------------------------------------------------------------------
  # * Atualização de fuga
  #--------------------------------------------------------------------------
  def call_update_flee
    return unless BattleManager.can_escape?
    return if @actor_atb_array.empty?
    if Input.press?(Akea_Active_Battle::Flee_Input)
      if @start_flee
        if $imported[:lune_animated_battle]
          for n in 0...$game_party.members.size
            change_character_animation(n, Lune_Anime_Battle::Standard['Escape']) if $game_party.members[n].alive?
          end
        end
        if Akea_Active_Battle::Has_Ator
          @back_flee_atb.x = Akea_Active_Battle::Flee_Back_Pos[0] + $game_party.members[@actor_atb_array.first].screen_x
          @back_flee_atb.y = Akea_Active_Battle::Flee_Back_Pos[1] + $game_party.members[@actor_atb_array.first].screen_y
          @bar_flee_atb.x = Akea_Active_Battle::Flee_Bar_Pos[0] + $game_party.members[@actor_atb_array.first].screen_x
          @bar_flee_atb.y = Akea_Active_Battle::Flee_Bar_Pos[1] + $game_party.members[@actor_atb_array.first].screen_y
        end
        @back_flee_atb.opacity = 255
        @bar_flee_atb.opacity = 255
        @bar_flee_atb.zoom_x = 0
      else
        @bar_flee_atb.zoom_x += Akea_Active_Battle.flee_formula($game_party.members[@actor_atb_array.first], $game_troop.alive_members[0])
        @bar_flee_atb.zoom_x = [@bar_flee_atb.zoom_x, 1.0].min
        BattleManager.process_escape if @bar_flee_atb.zoom_x >= 1.0
      end
    else 
      if $imported[:lune_animated_battle] && !@start_flee
        for n in 0...$game_party.members.size
          $game_party.battle_members[n].update_current_condition(0)
          change_character_animation(n, $game_party.battle_members[n].current_hp_condition)
        end
      end
      @back_flee_atb.opacity = 0
      @bar_flee_atb.opacity = 0    
    end
    @start_flee = !Input.press?(Akea_Active_Battle::Flee_Input)
  end
  #--------------------------------------------------------------------------
  # * Entrada de comandos para o próximo herói
  #--------------------------------------------------------------------------
  def next_command
    if BattleManager.actor
      if Input.press?(Akea_Active_Battle::Flee_Input)
        akea_atb_next_command
        return 
      end
      @actor_atb_array.shift
      BattleManager.add_actor_order 
    end
     BattleManager.make_actor_index(@actor_atb_array.first) unless @actor_atb_array.empty?
    akea_atb_next_command
  end
  #--------------------------------------------------------------------------
  # * Inicialização da seleção de comandos do grupo
  #--------------------------------------------------------------------------
  def start_party_command_selection
    refresh_status
    @status_window.unselect
    @status_window.open
    if @actor_atb_array.empty?
      return 
    end
    if BattleManager.input_start
      next_command
    else
      @party_command_window.deactivate
      turn_start
    end
  end
  #--------------------------------------------------------------------------
  # * Método de atualização do ATB
  #--------------------------------------------------------------------------
  def call_update_atb_bar
    return if (!@actor_atb_array.empty? && !Input.press?(Akea_Active_Battle::Flee_Input)) || BattleManager.has_action?
    $game_troop.alive_members.each{|member|
    member.atb = increment_atb(member)
    if member.atb >= 1000
      @enemy_atb_array = $game_troop.members.index(member)
       BattleManager.add_enemy_order(@enemy_atb_array) 
       Akea_Active_Battle.atb_formula(member)
       BattleManager.input_start
      turn_start
      return
    end
    }
    return unless @actor_atb_array.empty?
    $game_party.alive_members.each{|member|
    member.atb = increment_atb(member)
    if member.atb >= 1000
      @actor_atb_array << $game_party.members.index(member)
      @status_window.refresh_atb
      start_party_command_selection
      return
    end
    }
    @status_window.refresh_atb
  end
  #--------------------------------------------------------------------------
  # * Método de incrementação do atb
  #--------------------------------------------------------------------------
  def increment_atb(subject)
    return [subject.atb + Akea_Active_Battle.atb_formula(subject), 1000].min
  end
  #--------------------------------------------------------------------------
  # * Inicialização da seleção de comandos do herói
  #--------------------------------------------------------------------------
  def start_actor_command_selection
    return turn_start if BattleManager.has_action?
    akea_atb_start_actor_command_selection
  end
  def prior_command
    start_actor_command_selection
  end
  #--------------------------------------------------------------------------
  # * Atualização do viewport de informações
  #--------------------------------------------------------------------------
  def update_info_viewport
    move_info_viewport(128)
  end
  #--------------------------------------------------------------------------
  # * Finalização da batalha
  #--------------------------------------------------------------------------
  def terminate
    @back_flee_atb.bitmap.dispose
    @bar_flee_atb.bitmap.dispose
    @back_flee_atb.dispose
    @bar_flee_atb.dispose
    akea_atb_terminate
  end
end
#==============================================================================
# ** BattleManager
#------------------------------------------------------------------------------
#  Este módulo gerencia o andamento da batalha.
#==============================================================================

module BattleManager
  #--------------------------------------------------------------------------
  # * Retorna a variável preemptive
  #--------------------------------------------------------------------------
  def self.get_preemptive
    return @preemptive
  end
  #--------------------------------------------------------------------------
  # * Retorna a variável surprise
  #--------------------------------------------------------------------------
  def self.get_surprise
    return @surprise
  end
  #--------------------------------------------------------------------------
  # * Criação da seqüencia de ações
  #--------------------------------------------------------------------------
  def self.add_enemy_order(id)
    @action_battlers = [] unless @action_battlers.is_a?(Array)  
    @action_battlers << $game_troop.members[id]
  end
  #--------------------------------------------------------------------------
  # * Adiciona ordem aos battlers
  #--------------------------------------------------------------------------
  def self.add_actor_order
    @action_battlers = [] unless @action_battlers.is_a?(Array)  
    @action_battlers << self.actor
  end
  #--------------------------------------------------------------------------
  # * Verifica se há ações
  #--------------------------------------------------------------------------
  def self.has_action?
    @action_battlers.empty? ? false : true
  end
  #--------------------------------------------------------------------------
  # * Criação da seqüencia de ações
  #--------------------------------------------------------------------------
  def self.make_action_orders
    return
  end
  #--------------------------------------------------------------------------
  # * Próximo comando
  #--------------------------------------------------------------------------
  def self.next_command
    return true
  end
  #--------------------------------------------------------------------------
  # * Comando Anterior
  #--------------------------------------------------------------------------
  def self.prior_command
    return true
  end
  #--------------------------------------------------------------------------
  # * Retorna o índice do ator
  #--------------------------------------------------------------------------
  def self.actor_index
    @actor_index
  end
  #--------------------------------------------------------------------------
  # * Força um ator a ser o próximo
  #--------------------------------------------------------------------------
  def self.make_actor_index(index)
    @actor_index = index
  end
  #--------------------------------------------------------------------------
  # * Processar fuga
  #--------------------------------------------------------------------------
  def self.process_escape
    $game_message.add(sprintf(Vocab::EscapeStart, $game_party.name))
    success = true
    Sound.play_escape
    if success
      process_abort
    else
      @escape_ratio += 0.1
      $game_message.add('\.' + Vocab::EscapeFailure)
      $game_party.clear_actions
    end
    wait_for_message
    return success
  end
end

#==============================================================================
# ** Game_Battler
#------------------------------------------------------------------------------
#  Esta classe gerencia os battlers. Controla a adição de sprites e ações 
# dos lutadores durante o combate.
# É usada como a superclasse das classes Game_Enemy e Game_Actor.
#==============================================================================

class Game_Battler < Game_BattlerBase
alias :akea_atb_use_Item :use_item
  #--------------------------------------------------------------------------
  # ? Usando habilidade/item
  #     item :  habilidade/item
  #--------------------------------------------------------------------------
  def use_item(item)
    note = /<use_atb *(\d+)?>/i
    item.note =~ note ? @atb -= $1.to_i : @atb = 0
    akea_atb_use_Item(item)
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