#=======================================================
#         Lune Element Level
# Autor: Raizen
# Compativel com: RMVXAce
# Comunidade: centrorpg.com
# O script permite que seja possivel subir niveis de elementos
# de acordo com o quanto cada elemento é utilizado.
# Os niveis aumentarão o dano causado por aquele elemento.

#IMPORTANTE: Não é muito simples a configuração, preste bastante
# atenção para deixar do jeito mais desejavel possivel.

# Lembrando que é possivel mudar uma afinidade elemental no próprio
# database, na classe de cada personagem.

# Para criar novos elementos, vá até a aba "Termos" dentro do database.

# É compativel com a maioria dos scripts que se baseiam no sistema padrão,
# que em geral é um número elevado.

# Para chamar a janela de elementos.
# Chamar Script: SceneManager.call(Scene_Raizen_Elements)


module Raizen_Elements
# Escolha os elementos do database que recebem dano
# extra e sobem de acordo com a exp.

Extra_Damage = [3,4,5,6,7,8,9,10]
# Indique as cores de cada elemento como aparecerá na janela de Elementos.
# Seguindo a mesma ordem dos Ids acima.
# lembrando da ordem (r, g, b) r = red(vermelho), g = green(verde)
# b = blue(azul)
# Para conseguir a cor desejada, olhe essa tabela por exemplo.
# http://shibolete.tripod.com/RGB.html

Damage_Elements = [
Color.new(255, 55, 55),
Color.new(30, 255, 255),
Color.new(255, 255, 30),
Color.new(50, 50, 255),
Color.new(92, 51, 23),
Color.new(20, 230, 100),
Color.new(240, 240, 240),
Color.new(255, 255, 255),]

# Mesma coisa que acima, mas dessa vez indique a nomenclatura para
# cada elemento. Sempre entre aspas
Name_Elements = [
"Fogo",
"Gelo",
"Trovão",
"Água",
"Terra",
"Vento",
"Sagrado",
"Sombrio",]




# Funciona apenas com magia? Caso seja uma arma ignora 
# o efeito de bonus de dano, além da experiência.
# true = aceita as armas, false = ignora armas.
Accept_Weapons = false

# formula da experiência.
# lembrando que o level é adquirido conforme a quantidade
# de dano causado.

def self.formula(level)
  level * level * 200 + 100 # modifique essa linha com os calculos da experiência.
end

# formula de dano extra a partir do level.

def self.damage(level)
  l = level.to_f
  l / 10 + 1  # modifique essa linha para obter o dano extra.
end

# Quantidade de elementos no database.

Size = 10

# Nomenclatura do level no Menu.

Lv = "Lv."

# Nome que aparecerá no menu.
Elements = "Elements"

# Nome que indicará os leveis no menu.
LevelTotal = "Level Total"

end

#==========================================================================
# ======================Aqui começa o Script===============================
#==========================================================================


#==============================================================================
# ** Scene_Status
#------------------------------------------------------------------------------
#  Esta classe executa o processamento da tela de atributos.
#==============================================================================

class Scene_Raizen_Elements < Scene_MenuBase

  #--------------------------------------------------------------------------
  # * Inicialização do processo
  #--------------------------------------------------------------------------
  def start
    super
    @status_window = Window_Raizen_Elements.new(@actor)
    @status_window.set_handler(:cancel,   method(:return_scene))
    @status_window.set_handler(:pagedown, method(:next_actor))
    @status_window.set_handler(:pageup,   method(:prev_actor))
    
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
# ** Window_Status
#------------------------------------------------------------------------------
#  Esta janela exibe as especificações completas na janela de atributos.
#==============================================================================

class Window_Raizen_Elements  < Window_Selectable
include Raizen_Elements
  #--------------------------------------------------------------------------
  # * Inicialização do objeto
  #     actor : herói
  #--------------------------------------------------------------------------
  def initialize(actor)
    super(0, 0, Graphics.width, Graphics.height)
    @actor = actor
    refresh
    activate
  end
  #--------------------------------------------------------------------------
  # * Definição de herói
  #     actor : herói
  #--------------------------------------------------------------------------
  def actor=(actor)
    return if @actor == actor
    @actor = actor
    refresh
  end
  #--------------------------------------------------------------------------
  # * Renovação
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    draw_block1   (line_height * 0)
    draw_block2   (line_height * 2)
    draw_block3   (line_height * 7)
    draw_vert_line (250)
    for n in 0...Extra_Damage.size
    draw_bars(n)
    end
  end
  #--------------------------------------------------------------------------
  # * Desenho do bloco 1
  #     y : coordenada Y
  #--------------------------------------------------------------------------
  def draw_bars(n)
  y = n * 360 / Extra_Damage.size + 40
  contents.fill_rect(300, y, 200, 12, bar_color)
  contents.fill_rect(302, y + 2, 196, 8, line_color)
  x = 196
  e = Extra_Damage[n]
  x *= $affinity_exp[@actor.class_id][e] / Raizen_Elements.formula($affinity_levels[@actor.class_id][e])
  contents.fill_rect(302, y + 2, x, 8, Damage_Elements[n])
  draw_text(310, y - 14, 100, 25, Name_Elements[n], 0)
  draw_text(430, y - 14, 100, 25, Lv, 0)
  draw_text(410, y - 14, 80, 25, $affinity_levels[@actor.class_id][e], 2)
  end
  def draw_block1(y)
    draw_actor_name(@actor, 4, y)
    draw_actor_class(@actor, 128, y)
  end
  #--------------------------------------------------------------------------
  # * Desenho do bloco 1
  #     y : coordenada Y
  #--------------------------------------------------------------------------
   def bar_color
    color = Color.new(0,0,0, 150)
    color
  end 
  def draw_block2(y)
    draw_actor_face(@actor, 8, y)
    draw_exp_info(0, 330)
  end
  #--------------------------------------------------------------------------
  # * Desenho do bloco 3
  #     y : coordenada Y
  #--------------------------------------------------------------------------
  def draw_block3(y)
    draw_parameters(32, y)
  end
  #--------------------------------------------------------------------------
  # * Desenho de uma linha horzontal
  #--------------------------------------------------------------------------
  def draw_vert_line(x)
    line_x = x
    contents.fill_rect(line_x, 0, 2, contents_height, line_color)
  end
  #--------------------------------------------------------------------------
  # * Aquisção da cor da linha horizontal
  #--------------------------------------------------------------------------
  def line_color
    color = normal_color
    color.alpha = 48
    color
  end
  #--------------------------------------------------------------------------
  # * Desenho das informações básicas
  #     x : coordenada X
  #     y : coordenada Y
  #--------------------------------------------------------------------------
  def draw_basic_info(x, y)
    draw_actor_icons(@actor, x, y + line_height * 1)
    draw_actor_hp(@actor, x, y + line_height * 2)
    draw_actor_mp(@actor, x, y + line_height * 3)
  end
  #--------------------------------------------------------------------------
  # * Desenho dos parâmetros
  #     x : coordenada X
  #     y : coordenada Y
  #--------------------------------------------------------------------------
  def draw_parameters(x, y)
    6.times {|i| draw_actor_param(@actor, x, y + line_height * i, i + 2) }
  end
  #--------------------------------------------------------------------------
  # * Desenho das informações de experiência
  #     x : coordenada X
  #     y : coordenada Y
  #--------------------------------------------------------------------------
  def draw_exp_info(x, y)
    s1 = 0
    for n in 1...Raizen_Elements::Size
    s1 += $affinity_levels[@actor.class_id][n]
    end
    change_color(system_color)
    draw_text(x, y + line_height * 0, 180, line_height, LevelTotal)
    change_color(normal_color)
    draw_text(x, y + line_height * 1, 180, line_height, s1, 2)
  end

  #--------------------------------------------------------------------------
  # * Desenho da descrição
  #     x : coordenada X
  #     y : coordenada Y
  #--------------------------------------------------------------------------
  def draw_description(x, y)
    draw_text_ex(x, y, @actor.description)
  end
end

class Game_Actor < Game_Battler
alias raizen_element_initialize initialize
  def initialize(actor_id)
    raizen_element_initialize(actor_id)
    if $affinity_start == nil
      $affinity_levels = []
      $affinity_exp = []
      for i in 1...$data_classes.size
        $affinity_levels[i] = Array.new(Raizen_Elements::Size + 1, 0)
        $affinity_exp[i] = Array.new(Raizen_Elements::Size + 1, 0)
      end
    $affinity_start = true
    end
  end
end
module DataManager
  def self.make_save_contents
    contents = {}
    contents[:system]        = $game_system
    contents[:timer]         = $game_timer
    contents[:message]       = $game_message
    contents[:switches]      = $game_switches
    contents[:variables]     = $game_variables
    contents[:self_switches] = $game_self_switches
    contents[:actors]        = $game_actors
    contents[:party]         = $game_party
    contents[:troop]         = $game_troop
    contents[:map]           = $game_map
    contents[:player]        = $game_player
    contents[:affin]         = $affinity_levels
    contents[:affinl]        = $affinity_exp
    contents
  end

  #--------------------------------------------------------------------------
  # * Extrair conteúdo salvo
  #--------------------------------------------------------------------------
  def self.extract_save_contents(contents)
    $game_system        = contents[:system]
    $game_timer         = contents[:timer]
    $game_message       = contents[:message]
    $game_switches      = contents[:switches]
    $game_variables     = contents[:variables]
    $game_self_switches = contents[:self_switches]
    $game_actors        = contents[:actors]
    $game_party         = contents[:party]
    $game_troop         = contents[:troop]
    $game_map           = contents[:map]
    $game_player        = contents[:player]
    $affinity_levels    = contents[:affin]
    $affinity_exp       = contents[:affinl]
  end
end

class Game_Battler < Game_BattlerBase
  def make_damage_value(user, item)
    value = item.damage.eval(user, self, $game_variables)
    value *= item_element_rate(user, item)
    value *= pdr if item.physical?
    value *= mdr if item.magical?
    value *= rec if item.damage.recover?
    value = apply_critical(value) if @result.critical
    value = apply_variance(value, item.damage.variance)
    value = apply_guard(value)
    if @class_id == nil
    value *= item_element_afinity(user.class_id, user.atk_elements.pop) 
    value.to_i
    call_exp_element(user.class_id, user.atk_elements.pop, value, item)
    end
    @result.make_damage(value.to_i, item)
  end
  def call_exp_element(id, elem, value, item)
    return if item.damage.element_id < 0 and !Raizen_Elements::Accept_Weapons 
    return unless Raizen_Elements::Extra_Damage.include?(elem)
    $affinity_exp[id][elem] += value 
    if $affinity_exp[id][elem] >= Raizen_Elements.formula($affinity_levels[id][elem])
    $affinity_exp[id][elem] = 0
    $affinity_levels[id][elem] += 1
    end
  end
  def item_element_afinity(class_id, item)
  item_damage = item
  return 1 unless item_damage >= 0 or Raizen_Elements::Accept_Weapons
  value = Raizen_Elements.damage($affinity_levels[class_id][item_damage])
  return value
  end
end  