#=======================================================
#         Lune Frontal Battle System
# Autor: Raizen
# Compativel com: RMVXAce
#=======================================================

# Instruções.
# Plug n' play, coloque acima do main e todos os scripts de
# adições na batalha coloque abaixo desse script.
# Configure de acordo com o pedido na linha abaixo.
#=======================================================

# Confgurações:

module Lune_Frontal_Battle
# Gráfico dos personagens caidos.
# Basta adicionar uma nova linha desse modo.
# DeadG[1] = "Monster1", com o ID e o gráfico dele caido ou outro
# gráfico que funcione para tal.
DeadG = []

DeadG[1] = "Monster1"
DeadG[2] = "Monster1"
DeadG[3] = "Monster1"
DeadG[4] = "Monster1"
DeadG[5] = "Monster1"
DeadG[6] = "Monster1"
DeadG[7] = "Monster1"
DeadG[8] = "Monster1"
DeadG[9] = "Monster1"

# Ataques a curta distancia, lembrando que 1 é o ataque normal, 
# e será considerado a arma.
Dist = [1, 3, 4, 10, 21, 80, 81, 85, 100]

# Armas com ataque a distancia
# Lembrando que para facilitar é o id dos tipos de arma, e não da
# arma em si.
Weapdist = [6, 10]

# Habilidades que não tem conjuração.
Nocast = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11,
12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 80, 76, 77, 78, 85,
81, 83, 84, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 99, 102, 103, 104,
105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 
86, 100]

# Id da animação de conjuração
Castid = 43
# Tempo de conjuração
Casttime = 20

# Centralizar personagens?
# true = sim, false = não
Center = true
end

#==============================================================================
# ==================  A partir daqui começa o script  ======================
#==============================================================================

#==============================================================================
# Reescrita dos seguintes métodos 
#  ==> Scene_Battle <==
# show_normal_animation
#  ==> Game_Actor <==
# use_sprite?
#==============================================================================

#==============================================================================
# Alias dos seguintes métodos 

# ==> Scene_Battle <==
# update_basic
# start
# start_actor_command_selection
# dispose_spriteset

# ==> Game_Actor <==
# initialize
#==============================================================================

#==============================================================================
# ** Scene_Battle
#------------------------------------------------------------------------------
#  Esta classe executa o processamento da tela de batalha.
#==============================================================================

class Scene_Battle < Scene_Base
  
  #--------------------------------------------------------------------------
  # * Aliasing
  #--------------------------------------------------------------------------
alias lune_front_update update_basic
alias lune_front_start start
alias lune_front_start_actor_command start_actor_command_selection
alias lune_front_dispose dispose_spriteset
    
  #--------------------------------------------------------------------------
  # * Inicialização do processo
  #--------------------------------------------------------------------------
  def start
    create_battlers
    lune_front_start
  end
  #--------------------------------------------------------------------------
  # * Atualização das tropas
  #--------------------------------------------------------------------------
  def update_basic
    update_move_troops
    lune_front_update
    
  end

  #--------------------------------------------------------------------------
  # * Inicialização das variáveis
  #--------------------------------------------------------------------------
  def create_battlers
    @bitmap = Array.new(4) { Sprite_Battler.new(@viewport1) }
    @cw = []
    @ch = []
    @pattern = []
    @index = []
  for actor in $game_party.members
      draw_battler(actor.character_name, actor.character_index, battler_position(actor.index), actor.index)
  end
end
  #--------------------------------------------------------------------------
  # * Posição dos battlers
  #--------------------------------------------------------------------------
  def battler_position(index)
    if Lune_Frontal_Battle::Center
      (Graphics.width/2 - $game_party.members.size * 110) + (index + 1) * 110 + ($game_party.members.size - 1) * 50
    else
      100 + index*110
    end
  end
  #--------------------------------------------------------------------------
  # * Criação dos gráficos dos personagens
  #--------------------------------------------------------------------------
   def draw_battler(character_name, index, x, y)
    return unless character_name
    @bitmap[y].bitmap = Cache.character(character_name)
    @bitmap[y].x = $game_party.members[y].screen_x = x
    @bitmap[y].y = $game_party.members[y].screen_y = 250
    $game_party.members[y].screen_x += 16
    $game_party.members[y].screen_y += 24
    @bitmap[y].z = 0
    @pattern[y] = 0
    @index[y] = index
    sign = character_name[/^[\!\$]./]
    if sign && sign.include?('$')
      @cw[y] = @bitmap[y].width / 3
      @ch[y] = @bitmap[y].height / 4
    else
      @cw[y] = @bitmap[y].width / 12
      @ch[y] = @bitmap[y].height / 8
    end
    sx = (@index[y] % 4 * 3) * @cw[y]
    sy = (@index[y] / 4 * 4 + 6 / 2) * @ch[y]
    @bitmap[y].src_rect.set(sx + @cw[y], sy, @cw[y], @ch[y])
  end
  #--------------------------------------------------------------------------
  # * Movimento dos gráficos dos personagens
  #--------------------------------------------------------------------------
  def move_actors_front(y, target = nil)
    return unless y
    unless target
      @bitmap[y].y -= 2 if @bitmap[y].y >= 220 
      @pattern[y] = (@bitmap[y].y % 24) / 8
      sx = (@index[y] % 4 * 3 + @pattern[y]) * @cw[y]
      sy = (@index[y] / 4 * 4 + 6 / 2) * @ch[y]
      @bitmap[y].src_rect.set(sx, sy, @cw[y], @ch[y])
    else
      @distance_in_y = @bitmap[y].y - (@target.screen_y - 50)
      @distance_in_x = @bitmap[y].x - (@target.screen_x)
      if @bitmap[y].y >= @distance_in_y
      @bitmap[y].y -= @distance_in_y / 20 
      @bitmap[y].x -= @distance_in_x / 18
      end
      @pattern[y] = (@bitmap[y].y % 24) / 8
      sx = (@index[y] % 4 * 3 + @pattern[y]) * @cw[y]
      sy = (@index[y] / 4 * 4 + 6 / 2) * @ch[y]
      @bitmap[y].src_rect.set(sx, sy, @cw[y], @ch[y])
    end
    
  end
  def move_actors_back(n)
    for y in 0...$game_party.members.size
      unless y == n
        @bitmap[y].y += 2 if @bitmap[y].y <= 248 
        @distance_in_x = @bitmap[y].x - battler_position($game_party.members[y].index)
        @bitmap[y].x -= @distance_in_x / 15
      end
        character_name = $game_party.members[y].character_name
    if $game_party.members[y].dead?
      @index[y] = 0
      @bitmap[y].bitmap = Cache.character(Lune_Frontal_Battle::DeadG[$game_party.members[y].id]) if @bitmap[y].bitmap != Cache.character(Lune_Frontal_Battle::DeadG[$game_party.members[y].id])
    else
      @index[y] = $game_party.members[y].character_index
      @bitmap[y].bitmap = Cache.character(character_name) if @bitmap[y].bitmap != Cache.character(character_name)
    end
    @pattern[y] = (@bitmap[y].y % 24) / 8
    sx = (@index[y] % 4 * 3 + @pattern[y]) * @cw[y]
    sy = (@index[y] / 4 * 4 + 6 / 2) * @ch[y]
    @bitmap[y].src_rect.set(sx, sy, @cw[y], @ch[y])
    @bitmap[y].opacity += 4 unless @bitmap[y].opacity >= 255
    end
  end
  #--------------------------------------------------------------------------
  # * Atualização dos movimentos dos personagens
  #--------------------------------------------------------------------------
  def update_move_troops
    @startmove = nil if @party_command_window.active
    pattern = 0
    move_actors_front(@startmove, @target)
    move_actors_back(@startmove)    
  end
  #--------------------------------------------------------------------------
  # * atualização do indice.
  #--------------------------------------------------------------------------
  def start_actor_command_selection
    @startmove = BattleManager.actor.index
    lune_front_start_actor_command
  end
  def dispose_spriteset
    lune_front_dispose
    for y in 0...$game_party.members.size
    @bitmap[y].dispose 
    end
  end
  
  #--------------------------------------------------------------------------
  # * atualização do indice no processamento.
  #--------------------------------------------------------------------------

  def process_action
    return if scene_changing?
    if !@subject || !@subject.current_action
      @subject = BattleManager.next_subject
      if @subject
      @subject.actor? ? @startmove = @subject.index : @startmove = nil
      end
    end
    return turn_end unless @subject
    if @subject.current_action
      @subject.current_action.prepare
      if @subject.current_action.valid?
        @status_window.open
        execute_action
      end
      @subject.remove_current_action
    end    
    process_action_end unless @subject.current_action
  end
 
  #--------------------------------------------------------------------------
  # * animações de ataque
  #--------------------------------------------------------------------------
  
  def show_attack_animation(targets)
    if @subject.actor?
      show_normal_animation(targets, @subject.atk_animation_id1, false)
      show_normal_animation(targets, @subject.atk_animation_id2, true)
    else
      show_monster_animation(targets, @subject.atk_animation_id1, false)
      abs_wait_short
    end
  end
  #--------------------------------------------------------------------------
  # * Exibição da animação normal
  #     targets      : lista dos alvos
  #     animation_id : ID da animação
  #     mirror       : inversão
  #--------------------------------------------------------------------------
  def show_monster_animation(targets, animation_id, mirror = false)
    animation_id = 1 if animation_id.nil?
      animation = $data_animations[animation_id]
    if animation
      targets.each do |target|
        @bitmap[target.index].opacity = 0
        target.animation_id = animation_id
        target.animation_mirror = mirror
        abs_wait_short unless animation.to_screen?
      end
      abs_wait_short if animation.to_screen?
    end
  end
    def show_normal_animation(targets, animation_id, mirror = false)
    animation = $data_animations[animation_id]
    if animation
      onecast = true
      targets.each do |target|
        @target = target unless from_distance?
        if !Lune_Frontal_Battle::Nocast.include?(@subject.current_action.item.id) and onecast
          abs_wait(Lune_Frontal_Battle::Casttime)
          @subject.animation_id = Lune_Frontal_Battle::Castid 
          onecast = false
          abs_wait(30)
        end
        @bitmap[target.index].opacity = 0 if target.actor?
        target.animation_id = animation_id
        target.animation_mirror = mirror
        abs_wait_short unless animation.to_screen?
      end
      abs_wait_short if animation.to_screen?
    end
    @target = nil
  end
  #--------------------------------------------------------------------------
  # * verificação de ataque a distancia
  #--------------------------------------------------------------------------
  def from_distance?
    return true unless @subject.actor?
    return true if !Lune_Frontal_Battle::Dist.include?(@subject.current_action.item.id) and @subject.current_action.item.id != 1
    return true if Lune_Frontal_Battle::Weapdist.include?(@subject.weapon_type)
    return false
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
  # * Aliasing
  #--------------------------------------------------------------------------
alias lune_frontal_initialize initialize
  #--------------------------------------------------------------------------
  # * Variáveis públicas
  #--------------------------------------------------------------------------
  attr_accessor   :screen_x               # posição x na tela do battler
  attr_accessor   :screen_y               # posição y na tela do battler
  attr_accessor   :screen_z               # posição z na tela do battler
  #--------------------------------------------------------------------------
  # * Inicialização do objeto
  #     actor_id : ID do herói
  #--------------------------------------------------------------------------
  def initialize(actor_id)
    lune_frontal_initialize(actor_id)
    @screen_x = 0
    @screen_y = 0
    @screen_z = 0
  end
  def weapon_type
    weapons.any? {|weapon| return weapon.wtype_id } 
  end
  def use_sprite?
    return true
  end
end

class Game_Enemy < Game_Battler
  def atk_animation_id1
  end
end