#=======================================================
#        Akea Animated Battle States
# Author: Raizen
# Comunity: http://www.centrorpg.com/
# Compatibility: RMVXAce
#

# Instructions:
# The script adds animated states in the battle, these states are
# both buffs, and other states like poisoned, paralysed...
# They can use pictures, or be without pictures


#=======================================================
# =========================Don't modify!==============================
$imported ||= Hash.new
$imported[:akea_battlestates] = true
module Akea_BattleStates
States = Hash.new
# =========================Don't modify!==============================

# Animation instances, for example if Instances = 3,
# then it is possible to have up to 3 parallel state animations,
# If a state with a same instance is activated, that battle animation will
# play instead of the older one, this is made this way, because you can choose
# which animations do not go well with each other, and which can be played simultaneous

Instances = 2


# Instance configuration, put the state name and 
# + in front of it, if he is getting that state/Buff, and 
# - if he is loosing that state or getting a debuff(agility down for example)
# Follow the template bellow
# States[+State] = {   or
# States[-State] = {

# There are 2 main ways to configure the animation, using a picture, or 
# without a picture, pictures must be in Graphics/Akea folder

# Exemple with image
States['+Agility'] = {
:image => "Darkness1", # "image_name"
:frames => 4, # Amount of frames on the image
:speed => 3, # Frame change speed(lower = faster)
:instance => 1, # Instance number(starting from 0)
:position => [-50, -70, 10] # Position IN case you use images
}
# Exemple without image
States['+Poisoned'] = {
:image => [50, 255, 50],# [R, G, B] until 255
:frames => 20, # How long the flash will be on
:speed => 100, # Speed that makes the flash start(lower = faster)
:instance => 0, # Instance number(starting from 0)
:position => [-50, -70, 10] # Position IN case you use images
}
# Add this in case you want a flash to stop when you recover from that state
States['-Poisoned'] = {
:instance => 0,
}

end
#==============================================================================
# Here starts the script!!
#==============================================================================

#==============================================================================
# ** Scene_Battle
#------------------------------------------------------------------------------
#  Esta classe executa o processamento da tela de batalha.
#==============================================================================

class Scene_Battle < Scene_Base
alias :akea_abs_update_basic :update_basic
alias :akea_abs_start :start
alias :akea_abs_terminate :terminate
  #--------------------------------------------------------------------------
  # * Inicialização da cena
  #--------------------------------------------------------------------------
  def start
    @akea_state = Array.new(Akea_BattleStates::Instances)
    @akea_state_sprites = Array.new(Akea_BattleStates::Instances)
    for n in 0...Akea_BattleStates::Instances
      @akea_state[n] = Array.new(all_battle_members.size, [])
      @akea_state_sprites[n] = Array.new(all_battle_members.size)
      for i in 0...@akea_state_sprites[n].size
        @akea_state_sprites[n][i] = Sprite.new
      end
    end
    for n in 0...$game_party.members.size
      $game_party.members[n].states.each{|state| add_state_anime($game_party.members[n], "+" + state.name)}
    end
    akea_abs_start
  end
  #--------------------------------------------------------------------------
  # * Atualização Padrão
  #--------------------------------------------------------------------------
  def update_basic
    update_akea_state
    akea_abs_update_basic
  end
  #--------------------------------------------------------------------------
  # * Atualização principal
  #--------------------------------------------------------------------------
  def update_akea_state
    for x in 0...@akea_state.size
      for y in 0...@akea_state[x].size
        update_akea_battle_state(x, y, @akea_state[x][y]) unless @akea_state[x][y].empty?
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Atualização do estado
  #--------------------------------------------------------------------------
  def update_akea_battle_state(i, n, state)
    target = all_battle_members[n]
    if @akea_state_sprites[i][n].bitmap
      @akea_state_sprites[i][n].x = target.screen_x + @akea_state[i][n][:position][0]
      @akea_state_sprites[i][n].y = target.screen_y + @akea_state[i][n][:position][1]
      if Graphics.frame_count % @akea_state[i][n][:speed] == 0
        if @akea_state[i][n][:act] + 1 == @akea_state[i][n][:frames]
          @akea_state[i][n][:act] = 0
        else
          @akea_state[i][n][:act] += 1 
        end
        @akea_state_sprites[i][n].src_rect.set(@akea_state_sprites[i][n].bitmap.width/@akea_state[i][n][:frames] * @akea_state[i][n][:act], 0, @akea_state_sprites[i][n].bitmap.width/@akea_state[i][n][:frames], @akea_state_sprites[i][n].bitmap.height)
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Método de adição do estado
  #--------------------------------------------------------------------------
  def add_state_anime(target, state_name)
    return unless Akea_BattleStates::States[state_name] && target.use_sprite?
    state_config = Akea_BattleStates::States[state_name].dup
    i = state_config[:instance]
    n = all_battle_members.index(target)
    @akea_state[i][n] = Akea_BattleStates::States[state_name].dup
    @akea_state[i][n][:act] = 0
    @akea_state_sprites[i][n].bitmap.dispose if @akea_state_sprites[i][n].bitmap
    all_battle_members[n].remove_animated_state(i)
    if state_config[:image].is_a?(String)
      @akea_state_sprites[i][n].bitmap = Cache.akea(state_config[:image])
      @akea_state_sprites[i][n].x = target.screen_x + state_config[:position][0]
      @akea_state_sprites[i][n].y = target.screen_y + state_config[:position][1]
      @akea_state_sprites[i][n].z = state_config[:position][2]
      @akea_state_sprites[i][n].src_rect.set(0, 0, @akea_state_sprites[i][n].bitmap.width/state_config[:frames], @akea_state_sprites[i][n].bitmap.height)
    else
      all_battle_members[n].add_animated_state(i,state_config[:image], state_config[:frames], state_config[:speed])
    end
  end
  #--------------------------------------------------------------------------
  # * Método de remoção da animação do estado
  #--------------------------------------------------------------------------
  def remove_state_anime(target, state_name)
    return unless Akea_BattleStates::States[state_name] && target.use_sprite?
    state_config = Akea_BattleStates::States[state_name]
    n = all_battle_members.index(target)
    all_battle_members[n].remove_animated_state(state_config[:instance])
    @akea_state[state_config[:instance]][n] = []
    @akea_state_sprites[state_config[:instance]][n].bitmap.dispose if @akea_state_sprites[state_config[:instance]][n].bitmap
  end
  #--------------------------------------------------------------------------
  # * Dispoe as imagens
  #--------------------------------------------------------------------------
  def dispose_akea_state
    @akea_state_sprites.each{|sprt| sprt.each {|spt|
    spt.bitmap.dispose if spt.bitmap; spt.dispose}}
    for n in 0...all_battle_members.size
      for i in 0...Akea_BattleStates::Instances
        all_battle_members[n].remove_animated_state(i)
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Finalização de Scene
  #--------------------------------------------------------------------------
  def terminate
    dispose_akea_state
    akea_abs_terminate
  end
end
#==============================================================================
# ** Window_BattleLog
#------------------------------------------------------------------------------
#  Esta janela exibe o progresso da luta. Não exibe o quadro da
# janela, é tratado como uma janela por conveniência.
#==============================================================================

class Window_BattleLog < Window_Selectable
alias :akea_abs_display_added_states :display_added_states
alias :akea_abs_display_removed_states :display_removed_states
alias :akea_abs_display_buffs :display_buffs
  #--------------------------------------------------------------------------
  # * Exibição de estados adicionados
  #     target : alvo
  #--------------------------------------------------------------------------
  def display_added_states(target)
    target.result.added_state_objects.each do |state|
    SceneManager.scene.add_state_anime(target, "+" + state.name)
    end
    akea_abs_display_added_states(target)
  end
  #--------------------------------------------------------------------------
  # * Exibição de estados removidos
  #     target : alvo
  #--------------------------------------------------------------------------
  def display_removed_states(target)
    target.result.removed_state_objects.each do |state|
      SceneManager.scene.remove_state_anime(target, "-" + state.name)
    end
    akea_abs_display_removed_states(target)
  end
  #--------------------------------------------------------------------------
  # * Exibição de fortalecimentos/enfraquecimentos(individual)
  #     target : alvo
  #     buffs  : lista de enfraquicimentos/fortalecimentos
  #     fmt    : mensagem
  #--------------------------------------------------------------------------
  def display_buffs(target, buffs, fmt)
    text = ''
    buffs.each do |param_id|
      case fmt
      when Vocab::BuffAdd
        text = "+" + Vocab::param(param_id)
        SceneManager.scene.add_state_anime(target, text)
      when Vocab::DebuffAdd
        text = "-" + Vocab::param(param_id)
        SceneManager.scene.add_state_anime(target, text)
      when Vocab::BuffRemove
        text = "-" + Vocab::param(param_id)
        SceneManager.scene.remove_state_anime(target, text)
        text = "+" + Vocab::param(param_id)
        SceneManager.scene.remove_state_anime(target, text)
      end
    end
    akea_abs_display_buffs(target, buffs, fmt)
  end
end


#==============================================================================
# ** Sprite_Battler
#------------------------------------------------------------------------------
#  Este sprite é usado para exibir lutadores. Ele observa uma instância
# da classe Game_Battler e automaticamente muda as condições do sprite.
#==============================================================================

class Sprite_Battler < Sprite_Base
alias :akea_abs_update_bitmap :update_bitmap
  #--------------------------------------------------------------------------
  # * Atualização do bitmap de origem
  #--------------------------------------------------------------------------
  def update_bitmap
    akea_abs_update_bitmap
    update_added_animated_states
  end
  #--------------------------------------------------------------------------
  # * Atualização do bitmap de estado
  #--------------------------------------------------------------------------
  def update_added_animated_states
    for n in 0...Akea_BattleStates::Instances
      flash_animated_state(n) if @battler.self_animated_states[n]
    end
  end
  #--------------------------------------------------------------------------
  # * Animação de Flash
  #--------------------------------------------------------------------------
  def flash_animated_state(n)
    self.flash(Color.new(*@battler.self_animated_states[n][0]), @battler.self_animated_states[n][1]) if Graphics.frame_count % @battler.self_animated_states[n][2] == 0
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
alias :akea_abs_initialize :initialize
attr_accessor :self_animated_states
  #--------------------------------------------------------------------------
  # * Inicialização do Personagem
  #--------------------------------------------------------------------------
  def initialize(*args, &block)
    @self_animated_states = Array.new(Akea_BattleStates::Instances, false)
    akea_abs_initialize(*args, &block)
  end
  #--------------------------------------------------------------------------
  # * Método de adicionar o estado a um personagem
  #--------------------------------------------------------------------------
  def add_animated_state(instance, color, time, speed)
    @self_animated_states[instance] = [color, time, speed]
  end
  #--------------------------------------------------------------------------
  # * Redução de estado de um personagem
  #--------------------------------------------------------------------------
  def remove_animated_state(instance)
    @self_animated_states[instance] = false
  end
end