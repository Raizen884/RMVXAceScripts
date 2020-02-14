#=======================================================
#         Lune Skill Tree
# Autor: Raizen
# Comunidade: www.centrorpg.com
# Classica árvore de habilidades para jogos de rpg, 
# leia atentamente as instruções para configurar corretamente
# o script.
#=======================================================

module Skill_Tree
#+++++++++++++++++++++++++++++++++++++++++++++ 
# Comandos possíveis pelo script.
#+++++++++++++++++++++++++++++++++++++++++++++

# Adicionar pontos de habilidade manualmente.
# Chamar Script: $game_actors[id].skill_tree[0]
# lembrando as operações += adiciona, -= subtrai.
# Exemplo, quero adicionar 4 pontos de habilidade no personagem com id 5.
# Chamar Script: $game_actors[5].skill_tree[0] += 4


# Mudar uma habilidade manualmente.

# Chamar Script: $game_actors[id].skill_tree[skill_id]
# aonde id é o id do personagem no Database e skill_id o id de skill no database
# Exemplo, quero adicionar 5 no skill 3 do personagem com id 2.
# Chamar Script: $game_actors[2].skill_tree[3] += 5

# lembrando as operações += adiciona, -= subtrai.


# Para ativar a tela de skill tree manualmente.
# Chamar Script: SceneManager.call(Scene_Skill_Change)
#+++++++++++++++++++++++++++++++++++++++++++++
# Configurações Iniciais
#+++++++++++++++++++++++++++++++++++++++++++++

# Permitir imagem de fundo? true ou false
# se true, ele irá desenhar uma imagem na frente do Skill Tree,
# logo permitindo que seja feito por imagens qualquer adição.
# A imagem deve estar na pasta Graphics/System com o nome Actor1, Actor2...
# referente ao id de cada personagem.
Images = true
#---------------------------------------------
# Configurações de Textos
#---------------------------------------------

#texto de confirmação de adição de 1 ponto. 
# lembre-se de manter dentro de aspas ''.
Bot1 = 'Adicionar 1 ponto'
# cancelamento
Bot2 = 'Cancelar'
# Pontos restantes.
Rest = 'Pontos Restantes'
# Pontos totais.
Total = 'Pontos Totais'
# Nome no menu.
Menu = 'Skill Tree'
#====================================================

# Criação da tela de personagens, leia atentamente para as instruções,
# é muito importante que configure corretamente o script.
#====================================================
# Não modificar.
  Actor = []
  Sk = []
  
# Base para a criação de personagens, evite apagar essas linhas, 
# caso necessite sempre utilize esse template para criar os personagens.
=begin
#
Actor[id] = [

Sk[0] = {
'x' => 100, #posição do ícone em x
'y' => 32, #posição do ícone em y
'skill' => 5, #habilidade adquirida
'desc1' => 'Requer: Lvl 5, Bola de Fogo lvl 5', #descrição 1
'desc2' => 'Member1', #descrição 2
'desc3' => 'Habilidade com ataque em área', #descrição 3
'req' => [0, 1, 5, 9, 5], #requerimentos [level necessário do personagem,
#id do Skill necessário, level do skill, id do skill, level do skill.
# de acordo com essa tabela de Sk[id]
'maxlvl' => 5, # level máximo da habilidade
'mult' => [10, 5], # multiplicadores, o primeiro é multiplicador de dano/cura
# o segundo de leveis necessários a cada skill de habilidade adicionado.
},


Sk[1] = {
'x' => 100, #posição do ícone em x
'y' => 32, #posição do ícone em y
'skill' => 5, #habilidade adquirida
'desc1' => 'Requer: Lvl 5, Bola de Fogo lvl 5', #descrição 1
'desc2' => 'Member1', #descrição 2
'desc3' => 'Habilidade com ataque em área', #descrição 3
'req' => [0, 1, 5, 9, 5], #requerimentos [level necessário do personagem,
#id do Skill necessário, level do skill, id do skill, level do skill.
# de acordo com essa tabela de Sk[id]
'maxlvl' => 5, # level máximo da habilidade
'mult' => [10, 5], # multiplicadores, o primeiro é multiplicador de dano/cura
# o segundo de leveis necessários a cada skill de habilidade adicionado.
} 

# pode adicionar quantos bem entender do mesmo bloco
]
=end
# ============================================================================
# ======= Personagem 1 =======================================================
# ============================================================================
Actor[8] = [
Sk[0] = {
'x' => 30, #posição do ícone em x
'y' => 30, #posição do ícone em y
'skill' => 51, #habilidade adquirida
'desc1' => 'Requer: Level 1', #descrição 1
'desc2' => '', #descrição 2
'desc3' => 'Fogo 1 - Habilidade de fogo', #descrição 3
'req' => [0], #requerimentos [level necessário do personagem,
#id do Skill necessário, level do skill, id do skill, level do skill.
# de acordo com essa tabela de Sk[id]
'maxlvl' => 10, # level máximo da habilidade
'mult' => [10, 2], # multiplicadores, o primeiro é multiplicador de dano/cura
# o segundo de leveis necessários a cada skill de habilidade adicionado.
},

Sk[1] = {
'x' => 90, #posição do ícone em x
'y' => 30, #posição do ícone em y
'skill' => 119, #habilidade adquirida
'desc1' => 'Requer: Level 1', #descrição 1
'desc2' => '', #descrição 2
'desc3' => 'Reflexão Mágica', #descrição 3
'req' => [0], #requerimentos [level necessário do personagem,
#id do Skill necessário, level do skill, id do skill, level do skill.
# de acordo com o database
'maxlvl' => 1, # level máximo da habilidade
'mult' => [10, 2], # multiplicadores, o primeiro é multiplicador de dano/cura
# o segundo de leveis necessários a cada skill de habilidade adicionado.
},

Sk[2] = {
'x' => 30, #posição do ícone em x
'y' => 90, #posição do ícone em y
'skill' => 52, #habilidade adquirida
'desc1' => 'Requer: Level 8 + 4xlevel', #descrição 1
'desc2' => 'Fogo1 - Level 5', #descrição 2
'desc3' => 'Fogo 2 - Habilidade aprimorada de fogo', #descrição 3
'req' => [8, 51, 5], #requerimentos [level necessário do personagem,
#id do Skill necessário, level do skill, id do skill, level do skill.
# de acordo com o database
'maxlvl' => 10, # level máximo da habilidade
'mult' => [10, 4], # multiplicadores, o primeiro é multiplicador de dano/cura
# o segundo de leveis necessários a cada skill de habilidade adicionado.
},

Sk[3] = {
'x' => 30, #posição do ícone em x
'y' => 150, #posição do ícone em y
'skill' => 53, #habilidade adquirida
'desc1' => 'Requer: Level 15 + 4xlevel', #descrição 1
'desc2' => 'Fogo 1 lvl 7, Fogo 2 lvl 5', #descrição 2
'desc3' => 'Fogo 2 - Habilidade aprimorada de fogo', #descrição 3
'req' => [15, 51, 7, 52, 5], #requerimentos [level necessário do personagem,
#id do Skill necessário, level do skill, id do skill, level do skill.
# de acordo com o database
'maxlvl' => 10, # level máximo da habilidade
'mult' => [10, 4], # multiplicadores, o primeiro é multiplicador de dano/cura
# o segundo de leveis necessários a cada skill de habilidade adicionado.
},
]


# ============================================================================
# ======= Personagem 2 =======================================================
# ============================================================================
Actor[9] = [
Sk[0] = {
'x' => 30, #posição do ícone em x
'y' => 30, #posição do ícone em y
'skill' => 51, #habilidade adquirida
'desc1' => 'Requer: Level 1', #descrição 1
'desc2' => '', #descrição 2
'desc3' => 'Fogo 1 - Habilidade de fogo', #descrição 3
'req' => [0], #requerimentos [level necessário do personagem,
#id do Skill necessário, level do skill, id do skill, level do skill.
# de acordo com essa tabela de Sk[id]
'maxlvl' => 10, # level máximo da habilidade
'mult' => [10, 2], # multiplicadores, o primeiro é multiplicador de dano/cura
# o segundo de leveis necessários a cada skill de habilidade adicionado.
},

Sk[1] = {
'x' => 90, #posição do ícone em x
'y' => 30, #posição do ícone em y
'skill' => 119, #habilidade adquirida
'desc1' => 'Requer: Level 1', #descrição 1
'desc2' => '', #descrição 2
'desc3' => 'Reflexão Mágica', #descrição 3
'req' => [0], #requerimentos [level necessário do personagem,
#id do Skill necessário, level do skill, id do skill, level do skill.
# de acordo com o database
'maxlvl' => 1, # level máximo da habilidade
'mult' => [10, 2], # multiplicadores, o primeiro é multiplicador de dano/cura
# o segundo de leveis necessários a cada skill de habilidade adicionado.
},

Sk[2] = {
'x' => 30, #posição do ícone em x
'y' => 90, #posição do ícone em y
'skill' => 52, #habilidade adquirida
'desc1' => 'Requer: Level 8 + 4xlevel', #descrição 1
'desc2' => 'Fogo1 - Level 5', #descrição 2
'desc3' => 'Fogo 2 - Habilidade aprimorada de fogo', #descrição 3
'req' => [8, 51, 5], #requerimentos [level necessário do personagem,
#id do Skill necessário, level do skill, id do skill, level do skill.
# de acordo com o database
'maxlvl' => 10, # level máximo da habilidade
'mult' => [10, 4], # multiplicadores, o primeiro é multiplicador de dano/cura
# o segundo de leveis necessários a cada skill de habilidade adicionado.
},

Sk[3] = {
'x' => 30, #posição do ícone em x
'y' => 150, #posição do ícone em y
'skill' => 53, #habilidade adquirida
'desc1' => 'Requer: Level 15 + 4xlevel', #descrição 1
'desc2' => 'Fogo 1 lvl 7, Fogo 2 lvl 5', #descrição 2
'desc3' => 'Fogo 2 - Habilidade aprimorada de fogo', #descrição 3
'req' => [15, 51, 7, 52, 5], #requerimentos [level necessário do personagem,
#id do Skill necessário, level do skill, id do skill, level do skill.
# de acordo com o database
'maxlvl' => 10, # level máximo da habilidade
'mult' => [10, 4], # multiplicadores, o primeiro é multiplicador de dano/cura
# o segundo de leveis necessários a cada skill de habilidade adicionado.
},
]
end

#==============================================================================
# ** Scene_Status
#------------------------------------------------------------------------------
#  Esta classe executa o processamento da tela de atributos.
#==============================================================================

class Scene_Skill_Change < Scene_MenuBase
  #--------------------------------------------------------------------------
  # * Inicialização do processo
  #--------------------------------------------------------------------------
  def start
    @set = $game_party.actors # array com ids dos personagens do grupo
    @control_index = 0 #controle do indice de personagens
    @control_inindex = 0 # controle do indice de habilidades
    @status_window = Window_Skill_Select.new($game_party.actors[0]) # inicialização do menu de habilidades
    @actor_window = Window_Actor_Sk.new(0, 0) # inicialização do menu de atores
    @desc_window = Window_Help_Sk.new($game_party.actors[0]) # inicialização do menu de ajuda
    @confirm = Window_Skill_Confirm.new # inicialização do menu de confirmação
    @confirm.set_handler(:use_point, method(:command_use))
    @confirm.set_handler(:return_window, method(:command_return))
    @confirm.close
    @actor_window.active = true
    @status_window.active = false
    @table = Skill_Tree::Actor
    super
  end
  #--------------------------------------------------------------------------
  # * Atualização do Processo
  #--------------------------------------------------------------------------
  def update
    super
    # Verificação do índice do menu
    if @control_index != @actor_window.index
       @control_index = @actor_window.index
       @status_window.refresh(@set[@actor_window.index]) # mudança da janela de skills
       @desc_window.refresh(@set[@actor_window.index], @status_window.index) # mudança da janela de skills
     end
    # Verificação do índice de habilidade
    if @control_inindex != @status_window.index
       @control_inindex = @status_window.index
       @desc_window.refresh(@set[@actor_window.index], @status_window.index) # mudança da janela de skills
    end
    # Confirmação 
    if Input.trigger?(:C) 
      if @actor_window.active == true
        Sound.play_ok
        @status_window.active = true
        @actor_window.active = false
      elsif @status_window.active == true
        @status_window.active = false
        @confirm.open
        @confirm.activate
      end
    end
    # Retorno
    if Input.trigger?(:B)
      if @actor_window.active == true
        return_scene
      elsif @status_window.active == true
        @status_window.active = false
        @actor_window.active = true        
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Confirmação de saída
  #--------------------------------------------------------------------------
  def command_return
    @confirm.close
    @status_window.active = true
  end
  #--------------------------------------------------------------------------
  # Confirmação de distribuição
  #--------------------------------------------------------------------------
  def command_use
    @nocall = true
    id = $game_party.actors[@actor_window.index]
    # verificação dos requisitos
    if $game_actors[id].skill_tree[0] > 0 && $game_actors[id].skill_tree[@table[id][@status_window.index]['skill']] < @table[id][@status_window.index]['maxlvl']
      for n in 1...@table[id][@status_window.index]['req'].size
        if n.even?
          @nocall = false if @table[id][@status_window.index]['req'][n] > $game_actors[id].skill_tree[@table[id][@status_window.index]['req'][n-1]]
        end
      end
    else
      @nocall = false
    end
    # verificação do multiplicador de level
    @nocall = false if @table[id][@status_window.index]['mult'][1]*$game_actors[id].skill_tree[@table[id][@status_window.index]['skill']] + @table[id][@status_window.index]['req'][0] >$game_actors[id].level
    @confirm.close
    @status_window.active = true
    unless @nocall
      Sound.play_buzzer
      return
    end
    if $game_actors[id].skill_tree[@table[id][@status_window.index]['skill']] == 0
      $game_actors[id].learn_skill(@table[id][@status_window.index]['skill'])
    end
    $game_actors[id].skill_tree[@table[id][@status_window.index]['skill']] += 1
    $game_actors[id].skill_mult[@table[id][@status_window.index]['skill']] += @table[id][@status_window.index]['mult'][0]
    $game_actors[id].skill_tree[0] -= 1
    Sound.play_ok
    @status_window.refresh(@set[@actor_window.index])
  end
  #--------------------------------------------------------------------------
  # * Retorno ao menu principal
  #--------------------------------------------------------------------------
  def return_scene
    super
    @status_window.dispose
    @actor_window.dispose
    @desc_window.dispose
  end
end

#==============================================================================
# ** Window_Actor_Sk
#------------------------------------------------------------------------------
# Esta janela exibe os personagens do grupo.
#==============================================================================

class Window_Actor_Sk < Window_MenuStatus
  
  #--------------------------------------------------------------------------
  # * Largura da janela
  #--------------------------------------------------------------------------
  def window_width
    120 
  end
  #--------------------------------------------------------------------------
  # * Altura da janela
  #--------------------------------------------------------------------------
  def window_height
    Graphics.height
  end
end
#==============================================================================
# ** Window_Skill_Select
#------------------------------------------------------------------------------
# Janela Principal da Skill Tree
#==============================================================================

class Window_Skill_Select < Window_Base
attr_reader :index
  #--------------------------------------------------------------------------
  # * Inicialização da Janela
  #--------------------------------------------------------------------------
  def initialize(a)
    super(120, 0, window_width, Graphics.height - fitting_height(3))
    refresh(a)
    @page = 0
    @index = 0
    update_cursor
  end
  #--------------------------------------------------------------------------
  # * Largura da Janela
  #--------------------------------------------------------------------------
  def window_width
    Graphics.width - 120
  end
  #--------------------------------------------------------------------------
  #--------------------------------------------------------------------------
  # * Aquisição do retangulo para desenhar o item(cursor)
  #     index : índice do item
  #--------------------------------------------------------------------------
  def item_rect(index)
    rect = Rect.new
    rect.x = @table[index]['x']
    rect.y = @table[index]['y']
    rect.width = 24
    rect.height = 24
    rect
  end
  #--------------------------------------------------------------------------
  # * Atualização da janela
  #--------------------------------------------------------------------------
  def refresh(a)
    contents.clear
    if Skill_Tree::Images
      if @tree_load
        @tree_load.bitmap.dispose
        @tree_load.dispose
      end
      @tree_load = Sprite.new
      @tree_load.bitmap = Cache.system("Actor#{+a}")
      @tree_load.z = 200
    end
    @table = Skill_Tree::Actor[a]
    contents.font.color = text_color(1)
    @sum = 0
    $game_actors[a].skill_tree.each {|z| @sum += z}
    draw_text(50, -10, 180, 50, $game_actors[a].skill_tree[0].to_s + " "+ Skill_Tree::Rest) 
    draw_text(window_width - 200, -10, 180, 50, @sum.to_s + " "+ Skill_Tree::Total)
    contents.font.color = text_color(0)
    for i in 0...@table.size
      contents.font.size = 16
      draw_text(@table[i]['x'], @table[i]['y']+ 26, 40, 30, $game_actors[a].skill_tree[@table[i]['skill']].to_s + " /" + @table[i]['maxlvl'].to_s)
      draw_icon($data_skills[@table[i]['skill']].icon_index, @table[i]['x'], @table[i]['y'], $game_actors[a].skill_learn?($data_skills[@table[i]['skill']]))
    end
    contents.font.size = Font.default_size
    @page = 0
    @index = 0
    update_cursor
  end
  #--------------------------------------------------------------------------
  # * Renovação
  #--------------------------------------------------------------------------
  def update
    return if active == false
    if Input.repeat?(:RIGHT) || Input.repeat?(:DOWN)
      @index += 1 
      @index = 0 if @index >= @table.size
      Sound.play_cursor
    elsif Input.repeat?(:LEFT) || Input.repeat?(:UP)
      @index -= 1 
      @index = (@table.size - 1) if @index < 0
      Sound.play_cursor
    end
    update_cursor
  end
  #--------------------------------------------------------------------------
  # * Atualização do cursor
  #--------------------------------------------------------------------------
  def update_cursor
    cursor_rect.set(item_rect(@index))
  end
  #--------------------------------------------------------------------------
  # * Execução do movimento do cursor
  #--------------------------------------------------------------------------
  def process_cursor_move
    last_page = @page
    super
    update_cursor
    Sound.play_cursor if @page != last_page
  end
  #--------------------------------------------------------------------------
  # * Definição de controle de confirmação e cancelamento
  #--------------------------------------------------------------------------
  def process_handling
    return unless open? && active
    process_jump if Input.trigger?(:A)
    process_back if Input.repeat?(:B)
    process_ok   if Input.trigger?(:C)
  end
  #--------------------------------------------------------------------------
  # * Definição de resultado ao pressionar o botão de confirmação
  #--------------------------------------------------------------------------
  def process_ok
    if !character.empty?
      on_name_add
    elsif is_page_change?
      Sound.play_ok
      cursor_pagedown
    elsif is_ok?
      on_name_ok
    end
  end
  #--------------------------------------------------------------------------
  # * Adição ao nome do personagem
  #--------------------------------------------------------------------------
  def on_name_add
    if @edit_window.add(character)
      Sound.play_ok
    else
      Sound.play_buzzer
    end
  end
  #--------------------------------------------------------------------------
  # * Definição do nome
  #--------------------------------------------------------------------------
  def on_name_ok
    if @edit_window.name.empty?
      if @edit_window.restore_default
        Sound.play_ok
      else
        Sound.play_buzzer
      end
    else
      Sound.play_ok
      call_ok_handler
    end
  end
  #--------------------------------------------------------------------------
  # * Descarte
  #--------------------------------------------------------------------------
  def dispose
    super
    if @tree_load
      @tree_load.bitmap.dispose
      @tree_load.dispose
    end
  end
end


#==============================================================================
# ** Window_Help_Sk
#------------------------------------------------------------------------------
#  Esta janela exibe explicação de habilidades e informações sobre os requerimentos.
#==============================================================================

class Window_Help_Sk < Window_Base
  def initialize(a)
    super(120, Graphics.height - fitting_height(3), Graphics.width - 120, fitting_height(3))
    @table = Skill_Tree::Actor[a]
    refresh(a, 1)
  end
  #--------------------------------------------------------------------------
  # * Atualização da janela
  #--------------------------------------------------------------------------
  def refresh(a, index)
    contents.clear
    @table = Skill_Tree::Actor[a] unless Skill_Tree::Actor[a] == nil
    contents.font.color = text_color(20)
    draw_text(0, 0, Graphics.width - 120, line_height, @table[index]['desc1'])
    draw_text(0, line_height, Graphics.width - 120, line_height, @table[index]['desc2'])
    contents.font.color = text_color(0)
    draw_text(0, line_height*2, Graphics.width - 120, line_height, @table[index]['desc3'])
  end
end

#==============================================================================
# ** Window_MenuStatus
#------------------------------------------------------------------------------
#  Esta janela exibe os parâmetros dos membros do grupo na tela de menu.
#==============================================================================

class Window_Skill_Confirm < Window_Command

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
    add_command(Skill_Tree::Bot1,   :use_point,   true)
    add_command(Skill_Tree::Bot2,  :return_window,  true)
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
alias sk_tree_ini setup
alias sk_tree_lvl level_up
attr_accessor :skill_tree
attr_accessor :skill_mult
  #--------------------------------------------------------------------------
  # * Inicialização do objeto
  #     actor_id : ID do herói
  #--------------------------------------------------------------------------
  def setup(actor_id)
    sk_tree_ini(actor_id)
    @skill_tree = Array.new($data_skills.size + 1, 0)
    @skill_mult = Array.new($data_skills.size + 1, 0)
  end
  #--------------------------------------------------------------------------
  # * Aumento de nível
  #--------------------------------------------------------------------------
  def level_up
    sk_tree_lvl
    @skill_tree[0] += 1
  end
end




#==============================================================================
# ** Game_Party
#------------------------------------------------------------------------------
#  Esta classe gerencia o grupo. Contém informações sobre dinheiro, itens.
# A instância desta classe é referenciada por $game_party.
#==============================================================================

class Game_Party < Game_Unit
attr_accessor :actors
end

#==============================================================================
# ** Game_Battler
#------------------------------------------------------------------------------
#  Esta classe gerencia os battlers. Controla a adição de sprites e ações 
# dos lutadores durante o combate.
# É usada como a superclasse das classes Game_Enemy e Game_Actor.
#==============================================================================

class Game_Battler < Game_BattlerBase
  #--------------------------------------------------------------------------
  # * Cálculo de dano
  #     user : usuário
  #     item : habilidade/item
  #--------------------------------------------------------------------------
  def make_damage_value(user, item)
    value = item.damage.eval(user, self, $game_variables)
    value *= item_element_rate(user, item)
    value *= pdr if item.physical?
    value *= mdr if item.magical?
    value *= rec if item.damage.recover?
    value = apply_critical(value) if @result.critical
    value = apply_variance(value, item.damage.variance)
    value = apply_guard(value)
    value += (value * $game_actors[user.id].skill_mult[item.id])/100
    @result.make_damage(value.to_i, item)
  end
end