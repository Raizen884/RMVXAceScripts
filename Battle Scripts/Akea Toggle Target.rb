#=======================================================
#        Akea Toggle Target
# Autor: Raizen
# Comunidade: http://www.centrorpg.com/
# Compatibilidade: RMVXAce
#
#=======================================================
# =========================Não modificar==============================
# Funcionalidade:
# O Script permite target toggle na batalha, target toggle são skills
# que podem ser ativados para serem usados em vários inimigos ao invés de um, 
# ou/e skills que podem ser usado tanto em aliados quanto em inimigos.
# ----------------------- Não modificar -------------------------
$imported ||= Hash.new
$imported[:akea_toggletarget] = true
module Akea_Toggle_Target
# ----------------------- Aqui começa a configuração -------------------------
# Teclas que ativam o toggle para vários alvos
# Podem haver mais de um, basta separar por vírgulas Ex: [:L, :X, :Q]
# Mapeamento de teclas do RPG Maker
# X = Tecla A  ;  Y = Tecla S  ;  Z = Tecla D
# L = Tecla Q  ;  R = Tecla W  ;  SHIFT
Toggle_Input = [:L]

#Teclas que ativam a troca de lado do cursor
# Podem haver mais de um, basta separar por vírgulas Ex: [:L, :X, :Q]
Change_Input = [:R]

# Coloque o abaixo no bloco de notas de cada skill que desejar
# <can_toggle>
# Permite que uma skill possa realizar o toggle para todos os alvos

# <change_toggle_side>
# Permite que uma skill possa ser usada ambos em inimigos como aliados

# <toggle_split n>
# Coloque isso para que o skill tenha divisão de dano caso esteja no 
# modo Toggle, n é a % de dano base para o skill, por exemplo
# <toggle_split 100>
# Para 2 inimigos significa 50% de dano em cada um.



end
# =========================Não modificar==============================

#==============================================================================
# ** Scene_Battle
#------------------------------------------------------------------------------
#  Esta classe executa o processamento da tela de batalha.
#==============================================================================

class Scene_Battle < Scene_Base
alias :akea_tt_update_basic :update_basic
alias :akea_tt_on_skill_ok :on_skill_ok
alias :akea_tt_on_enemy_cancel :on_enemy_cancel
alias :akea_tt_on_actor_cancel :on_actor_cancel
  #--------------------------------------------------------------------------
  # * Atualização da tela (básico)
  #--------------------------------------------------------------------------
  def update_basic
    akea_tt_update_basic
    if @enemy_window.active
      Akea_Toggle_Target::Toggle_Input.each{|input| change_toggle_enemy if Input.trigger?(input)}
      Akea_Toggle_Target::Change_Input.each{|input| change_input_enemy if Input.trigger?(input)}
    elsif @actor_window.active
      Akea_Toggle_Target::Toggle_Input.each{|input| change_toggle_actor if Input.trigger?(input)}
      Akea_Toggle_Target::Change_Input.each{|input| change_input_actor if Input.trigger?(input)}
    end
  end
  #--------------------------------------------------------------------------
  # * Ativar Toggle(Actor)
  #--------------------------------------------------------------------------
  def change_toggle_actor
    return unless BattleManager.actor.current_action.item.note.include?("<can_toggle>")
    @actor_window.set_rect_cursor 
    BattleManager.actor.current_action.akea_toggle = @actor_window.cursor_set_all
    @akea_target_all = BattleManager.actor.current_action.akea_toggle
    Sound.play_cursor
  end
  #--------------------------------------------------------------------------
  # * Mudança de Alvo(Para Inimigos)
  #--------------------------------------------------------------------------
  def change_input_actor
    return unless BattleManager.actor.current_action.item.note.include?("<change_toggle_side>")
    #BattleManager.actor.current_action.akea_toggle = false
    #@akea_target_all = false
    BattleManager.actor.current_action.cursor_opposit_set = !BattleManager.actor.current_action.item.for_opponent?
    @actor_window.hide
    @actor_window.deactivate
    @skill_window.deactivate
    Sound.play_cursor
    select_enemy_selection
  end
  #--------------------------------------------------------------------------
  # * Ativar Toggle(Enemy)
  #--------------------------------------------------------------------------
  def change_toggle_enemy
    return unless BattleManager.actor.current_action.item.note.include?("<can_toggle>")
    @enemy_window.set_rect_cursor 
    BattleManager.actor.current_action.akea_toggle = @enemy_window.cursor_set_all
    @akea_target_all = BattleManager.actor.current_action.akea_toggle
    Sound.play_cursor
  end
  #--------------------------------------------------------------------------
  # * Mudança de Alvo(Para Personagens)
  #--------------------------------------------------------------------------
  def change_input_enemy
    return unless BattleManager.actor.current_action.item.note.include?("<change_toggle_side>")
    #BattleManager.actor.current_action.akea_toggle = false
    #@akea_target_all = false
    BattleManager.actor.current_action.cursor_opposit_set = BattleManager.actor.current_action.item.for_opponent?
    @enemy_window.hide
    @enemy_window.deactivate
    @skill_window.deactivate
    Sound.play_cursor
    select_actor_selection
  end
  #--------------------------------------------------------------------------
  # * Habilidade [Confirmação]
  #--------------------------------------------------------------------------
  def on_skill_ok
    akea_tt_on_skill_ok
    BattleManager.actor.current_action.akea_toggle = false
    BattleManager.actor.current_action.cursor_opposit_set = false
  end
  #--------------------------------------------------------------------------
  # * Tela Inimigos [Cancelamento]
  #--------------------------------------------------------------------------
  def on_enemy_cancel
    akea_tt_on_enemy_cancel
    BattleManager.actor.current_action.akea_toggle = false
    BattleManager.actor.current_action.cursor_opposit_set = false
  end
  #--------------------------------------------------------------------------
  # * Tela Persnagens [Cancelamento]
  #--------------------------------------------------------------------------
  def on_actor_cancel
    akea_tt_on_actor_cancel
    @actor_command_window.activate if @actor_command_window.current_symbol == :attack
    BattleManager.actor.current_action.akea_toggle = false
    BattleManager.actor.current_action.cursor_opposit_set = false
  end
end


#==============================================================================
# ** Window_BattleEnemy
#------------------------------------------------------------------------------
#  Esta janela para seleção de inimigos na tela de batalha.
#==============================================================================

class Window_BattleEnemy < Window_Selectable
alias :akea_tt_item_rect :item_rect
attr_reader :cursor_set_all
  #--------------------------------------------------------------------------
  # * Ativar a Janela
  #--------------------------------------------------------------------------
  def activate
    @cursor_set_all = false
    super
  end
  #--------------------------------------------------------------------------
  # * Selecionar o cursor
  #--------------------------------------------------------------------------
  def set_rect_cursor
    @cursor_set_all = !@cursor_set_all
    update_cursor
  end
  #--------------------------------------------------------------------------
  # * Aquisição do retangulo para desenhar o item
  #     index : índice do item
  #--------------------------------------------------------------------------
  def item_rect(index)
    if @cursor_set_all
      rect = Rect.new
      rect.width = item_width * [col_max, item_max].min + spacing
      rect.height = item_height * (item_max.to_f/col_max).ceil
      rect.x = 0
      rect.y = 0
      rect
    else
      akea_tt_item_rect(index)
    end
  end
  #--------------------------------------------------------------------------
  # * Aquisição do retangulo para desenhar o item (para texto)
  #     index : índice do item
  #--------------------------------------------------------------------------
  def item_rect_for_text(index)
    rect = akea_tt_item_rect(index)
    rect.x += 4
    rect.width -= 8
    rect
  end
end

#==============================================================================
# ** Window_BattleActor
#------------------------------------------------------------------------------
#  Esta janela para seleção de heróis na tela de batalha.
#==============================================================================

class Window_BattleActor < Window_BattleStatus
alias :akea_tt_item_rect :item_rect
attr_reader :cursor_set_all
  #--------------------------------------------------------------------------
  # * Ativar a Janela
  #--------------------------------------------------------------------------
  def activate
    @cursor_set_all = false
    super
  end
  #--------------------------------------------------------------------------
  # * Selecionar o cursor
  #--------------------------------------------------------------------------
  def set_rect_cursor
    @cursor_set_all = !@cursor_set_all
    update_cursor
  end
  #--------------------------------------------------------------------------
  # * Aquisição do retangulo para desenhar o item
  #     index : índice do item
  #--------------------------------------------------------------------------
  def item_rect(index)
    if @cursor_set_all
      rect = Rect.new
      rect.width = item_width * col_max + spacing
      rect.height = item_height * (item_max.to_f/col_max).ceil
      rect.x = 0
      rect.y = 0
      rect
    else
      akea_tt_item_rect(index)
    end
  end
  #--------------------------------------------------------------------------
  # * Aquisição do retangulo para desenhar o item (para texto)
  #     index : índice do item
  #--------------------------------------------------------------------------
  def item_rect_for_text(index)
    rect = akea_tt_item_rect(index)
    rect.x += 4
    rect.width -= 8
    rect
  end
end


#==============================================================================
# ** Game_Action
#------------------------------------------------------------------------------
#  Esta classe gerencia as ações do combate.
# Esta classe é usada internamente pela classe Game_Battler.
#==============================================================================

class Game_Action
alias :akea_tt_initialize :initialize
alias :akea_tt_targets_for_opponents :targets_for_opponents
alias :akea_tt_targets_for_friends :targets_for_friends
attr_accessor   :akea_toggle
attr_accessor :cursor_opposit_set
  #--------------------------------------------------------------------------
  # * Inicialização do objeto
  #--------------------------------------------------------------------------
  def initialize(subject, forcing = false)
    @akea_toggle = false
    @cursor_opposit_set = false
    akea_tt_initialize(subject, forcing = false)
  end
  #--------------------------------------------------------------------------
  # * Alvos para inimigos
  #--------------------------------------------------------------------------
  def targets_for_opponents
    return opponents_unit.alive_members if @akea_toggle || (@cursor_opposit_set && !item.for_one?)
    if @cursor_opposit_set && item.for_one?
      num = 1 + (attack? ? subject.atk_times_add.to_i : 0)
      if @target_index < 0
        return [opponents_unit.random_target] * num
      else
        return [opponents_unit.smooth_target(@target_index)] * num
      end
    end
    akea_tt_targets_for_opponents
  end
  #--------------------------------------------------------------------------
  # * Alvos para aliados
  #--------------------------------------------------------------------------
  def targets_for_friends
    return friends_unit.alive_members if @akea_toggle || (@cursor_opposit_set && !item.for_one?)
    if @cursor_opposit_set && item.for_one?
      return [friends_unit.smooth_target(@target_index)]
    end
    akea_tt_targets_for_friends
  end
  #--------------------------------------------------------------------------
  # * Criação da lista de alvos
  #--------------------------------------------------------------------------
  def make_targets
    return unless item
    if !forcing && subject.confusion?
      [confusion_target]
    elsif item.for_opponent?
      if @cursor_opposit_set
        targets_for_friends
      else
        targets_for_opponents
      end
    elsif item.for_friend?
      if @cursor_opposit_set
        targets_for_opponents
      else
        targets_for_friends
      end
    else
      []
    end
  end
end

#==============================================================================
# ** Game_ActionResult
#------------------------------------------------------------------------------
#  Esta classe gerencia os resultados das ações nos combates.
# Esta classe é usada internamente pela classe Game_Battler.
#==============================================================================

class Game_ActionResult
alias :akea_tt_make_damage :make_damage
  #--------------------------------------------------------------------------
  # * Criação do dano
  #     value : valor do dano
  #     item  : objeto
  #--------------------------------------------------------------------------
  def make_damage(value, item)
    akea_tt_make_damage(value, item)
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
  #--------------------------------------------------------------------------
  # * Cálculo de dano
  #     user : usuário
  #     item : habilidade/item
  #--------------------------------------------------------------------------
  def make_damage_value(user, item)
    value = item.damage.eval(user, self, $game_variables)
    if user.current_action.akea_toggle
      note = /<toggle_split *(\d+)?>/i
      if  item.note =~ note
        value *= ($1.to_f/$game_troop.alive_members.size)/100.0
      end
    end
    value *= item_element_rate(user, item)
    value *= pdr if item.physical?
    value *= mdr if item.magical?
    value *= rec if item.damage.recover?
    value = apply_critical(value) if @result.critical
    value = apply_variance(value, item.damage.variance)
    value = apply_guard(value)
    @result.make_damage(value.to_i, item)
  end
end