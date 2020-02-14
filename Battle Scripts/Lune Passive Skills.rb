#=======================================================
#         Lune Passive Skills
# Autor : Raizen
# Communidade Centro RPG Maker
# Descrição: O script permite que o jogador crie skills passivas para
# o seu jogo.

# Esse script é compátivel e feito para o Lune Skill Tree 2.0, 
# Pode ser usado separado.
#=======================================================


# Para uma habilidade ser passiva, basta adicionar o seguinte ao bloco de notas
# daquela skill <passive>

# A skill estará apenas visível no mapa, na batalha ela não irá aparecer na
# lista de habilidades.

#==============================================================================
# A Partir daqui começa o script.
#==============================================================================


#==============================================================================
# ** Scene_Battle
#------------------------------------------------------------------------------
#  Esta classe executa o processamento da tela de batalha.
#==============================================================================
$imported = {} if $imported == nil
$imported[:Lune_Passive_Skills] = true

class Scene_Battle < Scene_Base
alias :lune_passive_start :start
alias :lune_pre_terminate :pre_terminate
  #--------------------------------------------------------------------------
  # * Inicialização do processo
  #--------------------------------------------------------------------------
  def start(*args, &block)
    lune_passive_start(*args, &block)
    for n in 0...$game_party.members.size
      for i in 0...all_battle_members[n].skills.size
        i = all_battle_members[n].skills[i].id
        if $data_skills[i].note == "<passive>"
          all_battle_members[n].make_damage_value(all_battle_members[n], $data_skills[i])
          all_battle_members[n].execute_damage(all_battle_members[n])
          apply_passive_effects(all_battle_members[n], $data_skills[i])
        end
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Aplicação do efeito da habilidades/item
  #     target : alvo
  #     item   : habilidade/item
  #--------------------------------------------------------------------------
  def apply_passive_effects(target, item)
    target.passive_apply(target, item)
    refresh_status
    @log_window.display_action_results(target, item)
  end
  #--------------------------------------------------------------------------
  # * Processamento pré finalização
  #--------------------------------------------------------------------------
  def pre_terminate
    for n in 0...$game_party.members.size
      for i in 0...all_battle_members[n].skills.size
        i = all_battle_members[n].skills[i].id
        if $data_skills[i].note == "<passive>"
          apply_reverse_passive_effects(all_battle_members[n], $data_skills[i])
        end
      end
    end
    lune_pre_terminate
  end
  #--------------------------------------------------------------------------
  # * Reversão do efeito da habilidades/item
  #     target : alvo
  #     item   : habilidade/item
  #--------------------------------------------------------------------------
  def apply_reverse_passive_effects(target, item)
    target.passive_reverse_apply(@subject, item)
    refresh_status
    @log_window.display_action_results(target, item)
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
  # * Aplicar habilidades/itens
  #     user : usuário
  #     item : habilidade/item
  #--------------------------------------------------------------------------
  def passive_apply(user, item)
    @result.clear
    @result.used = item_test(user, item)
    @result.missed = (@result.used && rand >= item_hit(user, item))
    @result.evaded = (!@result.missed && rand < item_eva(user, item))
    if @result.hit?
      unless item.damage.none?
        @result.critical = (rand < item_cri(user, item))
        make_damage_value(user, item)
        execute_damage(user)
      end
      item.effects.each {|effect| item_effect_apply(user, item, effect) }
    end
  end
  #--------------------------------------------------------------------------
  # * Aplicar habilidades/itens
  #     user : usuário
  #     item : habilidade/item
  #--------------------------------------------------------------------------
  def passive_reverse_apply(user, item)
    @result.clear
    @result.used = item_test(user, item)
    @result.missed = (@result.used && rand >= item_hit(user, item))
    @result.evaded = (!@result.missed && rand < item_eva(user, item))
    if @result.hit?
      unless item.damage.none?
        @result.critical = (rand < item_cri(user, item))
        make_damage_value(user, item)
        execute_damage(user)
      end
      item.effects.each {|effect| item_reverse_effect_apply(user, item, effect) }
    end
  end
  #--------------------------------------------------------------------------
  # * Aplicar efeito do uso habilidades/itens
  #     user   : usuário
  #     item   : habilidade/item
  #     effect : efeito
  #--------------------------------------------------------------------------
  def item_reverse_effect_apply(user, item, effect)
    method_table = {
      EFFECT_RECOVER_HP    => :item_effect_recover_hp,
      EFFECT_RECOVER_MP    => :item_effect_recover_mp,
      EFFECT_GAIN_TP       => :item_effect_gain_tp,
      EFFECT_ADD_STATE     => :item_effect_add_state,
      EFFECT_REMOVE_STATE  => :item_effect_remove_state,
      EFFECT_ADD_BUFF      => :item_effect_add_buff,
      EFFECT_ADD_DEBUFF    => :item_effect_add_debuff,
      EFFECT_REMOVE_BUFF   => :item_effect_remove_buff,
      EFFECT_REMOVE_DEBUFF => :item_effect_remove_debuff,
      EFFECT_SPECIAL       => :item_effect_special,
      EFFECT_GROW          => :item_effect_grow,
      EFFECT_LEARN_SKILL   => :item_effect_learn_skill,
      EFFECT_COMMON_EVENT  => :item_effect_common_event,
    }
    method_name = method_table[effect.code]
    if $imported[:Lune_Skill_Tree]
      @old_effect1 = effect.value1
      @old_effect2 = effect.value2
      effect.value1 += (effect.value1 * $game_actors[user.id].skill_mult[item.id])/100 
      effect.value2 += (effect.value2 * $game_actors[user.id].skill_mult[item.id])/100 
    end
    effect.value1 *= -1
    effect.value2 *= -1
    send(method_name, user, item, effect) if method_name
    effect.value1 *= -1
    effect.value2 *= -1
    if $imported[:Lune_Skill_Tree]
      effect.value1 = @old_effect1
      effect.value2 = @old_effect2
    end
  end
end


#==============================================================================
# ** Window_BattleSkill
#------------------------------------------------------------------------------
#  Esta janela para seleção de habilidades na tela de batalha.
#==============================================================================

class Window_BattleSkill < Window_SkillList
alias :lune_include? :include?
  #--------------------------------------------------------------------------
  # * Inclusão do item na lista
  #     item : item
  #--------------------------------------------------------------------------
  def include?(item)
    return false if item.note == "<passive>"
    lune_include?(item)
  end
end