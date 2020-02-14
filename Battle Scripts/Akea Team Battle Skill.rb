#=======================================================
#        Akea Team Battle Skill
# Autor: Raizen
# Comunidade: http://www.centrorpg.com/
# Compatibilidade: RMVXAce
# Permite skills duplas, triplas, quadruplas etc... No mesmo estilo
# encontrado em Chrono Trigger
#=======================================================
$imported ||= Hash.new
$imported[:akea_team_battle] = true
module Akea_Team_Skill
Team_Skill = []
Data_Skill = []
# Nome da conjunção que ligará os nomes dos personagens na janela de batalha
Conj = ' e '


#==============================================================================
# Aqui são configurados as habilidades duplas, triplas etc...
# Para configurar siga o exemplo abaixo
#Data_Skill[id] = {
#'Actors' => [actor1, actor2],
#'Skills' => [id1, id2],
# aonde o id é o id da skill que será feita por mais de um membro
# actor1, actor2 e assim em diante são os actors que participarão do skill
# id1, id2 e assim em diante são as skills necessárias para liberar esse skill
# ligando sempre id1 para actor1, id2 para actor2...

# IMPORTANTE: Adicione o skill de equipe nas classes, pode ser para level 1, 
# Ele apenas aparecerá caso todos os requisitos acima sejam atingidos

#==============================================================================
Data_Skill[54] = { #id da skill
'Actors' => [1, 8], #actors envolvidos
'Skills' => [51, 51], #id das skills necessárias
}
Data_Skill[127] = { #id da skill
'Actors' => [1, 2, 4], #actors envolvidos
'Skills' => [3, 52, 89], #id das skills necessárias
}
Data_Skill[128] = { #id da skill
'Actors' => [2, 4], #actors envolvidos
'Skills' => [56, 89], #id das skills necessárias
}


#==============================================================================
#------------------------------------------------------------------------------
# -----------------------Configuração de Animações!! --------------------------
#------------------------------------------------------------------------------
#==============================================================================
# Para configurar uma animação é simples, basta fazer exatamente como é realizado
# no Akea Animated Battle System, porém colocando o actor na frente, ou seja
# os mesmos comandos de lá, que são <movement>, <castskill>, <animation>,
# <move_hit>

# pode adicionar quantas linhas quiser, mantendo o padrão de
# [id_do_actor, 'tipo_de_movimento'],

# Para chamar essa animação, basta colocar no bloco de notas do skill o seguinte
# <teamskill id>
# Aonde id é o número na frente do Team_Skill[id]
# por exemplo o Team_Skill[3]  você ativaria assim
# <teamskill 3>
#==============================================================================
# Team_Skill[3] => Triple Vulcano Fist
#==============================================================================
Team_Skill[3] = [
[1, '<movement 4>'],
[1, '<movement 21>'],
[1, '<movement 41>'],
[1, '<castskill 95>'],
[1, '<movement 41>'],
[1, '<movement 2>'],
[2, '<movement 4>'],
[2, '<castskill 43>'],
[2, '<movement 22>'],
[2, '<castskill 43>'],
[2, '<movement 22>'],
[2, '<castskill 43>'],
[2, '<movement 2>'],
[4, '<movement 1>'],
[4, '<movement 41>'],
[4, '<make_hit 15>'],
[4, '<movement 3>'],
[4, '<castskill 95>'],
[4, '<movement 46>'],
[4, '<animation 2>'],
[4, '<movement 2>'],
]
#==============================================================================
# Team_Skill[3] => Double Ice Combo
#==============================================================================
Team_Skill[4] = [
[2, '<movement 4>'],
[2, '<movement 22>'],
[2, '<castskill 43>'],
[2, '<movement 25>'],
[2, '<movement 25>'],
[2, '<movement 25>'],
[2, '<movement 22>'],
[2, '<castskill 43>'],
[2, '<movement 2>'],
[4, '<movement 4>'],
[4, '<movement 4>'],
[4, '<castskill 42>'],
[4, '<movement 1>'],
[4, '<movement 41>'],
[4, '<movement 43>'],
[4, '<make_hit 20>'],
[4, '<movement 45>'],
[4, '<make_hit 20>'],
[4, '<animation 3>'],
[4, '<movement 2>'],
]
end
#==============================================================================
# ** Scene_Battle
#------------------------------------------------------------------------------
#  Esta classe executa o processamento da tela de batalha.
#==============================================================================
class Scene_Battle < Scene_Base
alias :atbs_turn_start :turn_start
alias :atbs_start :start
alias :atbs_turn_start :turn_start
  def start(*args, &block)
    @force_team_skill = []
    atbs_start(*args, &block)
  end
  #--------------------------------------------------------------------------
  # * Início do turno
  #--------------------------------------------------------------------------
  def turn_start
    atbs_turn_start
    #@force_team_skill.sort! {|a, b| $game_actors[b].param(6) - $game_actors[a].param(6)}
    #@force_team_skill.pop
    for n in 0...@force_team_skill.size
      BattleManager.remove_action(@force_team_skill[n])
    end
    @force_team_skill = []
  end
  #--------------------------------------------------------------------------
  # * Verificação de notetags
  #--------------------------------------------------------------------------
  def atbs_team_skill(battle_notes)
    @remember_old_user = @subject
    @remember_old_target = @reuse_targets
    for n in 0...battle_notes.size - 10
      if battle_notes[n..n+10] == "<teamskill "
        y = 0
        y += 1 until battle_notes[n+11+y] == '>'
        team_skill = battle_notes[n+11..n+10+y].to_i
      end
    end
    for n in 0...Akea_Team_Skill::Team_Skill[team_skill].size
      battle_notes = Akea_Team_Skill::Team_Skill[team_skill][n][1]
      @subject = $game_actors[Akea_Team_Skill::Team_Skill[team_skill][n][0]]
      @reuse_targets = @remember_old_target
      if battle_notes[0..9] == "<movement "
        y = 0
        y += 1 until battle_notes[10+y] == '>'
        insert_battle_commands(battle_notes[10..9+y].to_i)
      elsif battle_notes[0..9] == "<make_hit "
        y = 0
        y += 1 until battle_notes[10+y] == '>'
        insert_battle_damage(battle_notes[10..9+y].to_i)
      elsif battle_notes[0..9] == "<move_hit "
        y = 0
        y += 1 until battle_notes[10+y] == '>'
        old_sub = @subject
        for z in 0...@reuse_targets.size
          insert_battle_commands(battle_notes[10..9+y].to_i, @reuse_targets[z], old_sub)
        end
        @subject = old_sub
          elsif battle_notes[0..10] == "<playmovie "
            y = 0
            y += 1 until battle_notes[11+y] == '>'
            insert_battle_animations(battle_notes[11..11+y])
      elsif battle_notes[0..10] == "<animation "
        y = 0
        y += 1 until battle_notes[11+y] == '>'
        insert_battle_animations(battle_notes[11..11+y].to_i)
      elsif battle_notes[0..10] == "<castskill "
        y = 0
        y += 1 until battle_notes[11+y] == '>'
        insert_self_battle_animations(battle_notes[11..11+y].to_i)
      elsif battle_notes[0..10] == "<condition "
        y = 0
        y += 1 until battle_notes[11+y] == '>'
        all_battle_members[@subject.index].current_condition = battle_notes[11..11+y].to_i
      end
    end
    @subject = @remember_old_user
    @reuse_targets = @remember_old_target
  end 
  
  #--------------------------------------------------------------------------
  # * Habilidade [Confirmação]
  #--------------------------------------------------------------------------
  def on_skill_ok
    @skill = @skill_window.item
    id = BattleManager.actor.id
    BattleManager.actor.input.set_skill(@skill.id)
    BattleManager.actor.last_skill.object = @skill
    if !@skill.need_selection?
      @skill_window.hide
      next_command
    elsif @skill.for_opponent?
      select_enemy_selection
    else
      select_actor_selection
    end
    if Akea_Team_Skill::Data_Skill[@skill.id]
      @force_team_skill << Akea_Team_Skill::Data_Skill[@skill.id]['Actors'].dup
      @force_team_skill.last << @skill.id
    end
  end
end


#==============================================================================
# ** Window_BattleSkill
#------------------------------------------------------------------------------
#  Esta janela para seleção de habilidades na tela de batalha.
#==============================================================================

class Window_BattleSkill < Window_SkillList
alias :atbs_include? :include?
  #--------------------------------------------------------------------------
  # * Inclusão do item na lista
  #     item : item
  #--------------------------------------------------------------------------
  def include?(item)
    return false if item.note.include?("<not_included>")
    atbs_include?(item)
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
alias :atbs_learn_skill :learn_skill
  #--------------------------------------------------------------------------
  # * Aprender habilidade
  #     skill_id : ID da habilidade
  #--------------------------------------------------------------------------
  def learn_skill(skill_id)
    atbs_learn_skill(skill_id)
    for n in 0...Akea_Team_Skill::Data_Skill.size
      if Akea_Team_Skill::Data_Skill[n]
        for i in 0...Akea_Team_Skill::Data_Skill[n]['Actors'].size
          atbs_learn_skill(n) if Akea_Team_Skill::Data_Skill[n]['Actors'][i] == @actor_id && skill_learn?($data_skills[Akea_Team_Skill::Data_Skill[n]['Skills'][i]])
        end
      end
    end
  end
end
#==============================================================================
# ** Window_SkillList
#------------------------------------------------------------------------------
#  Esta janela exibe uma lista de habilidades usáveis na tela de habilidades.
#==============================================================================

class Window_SkillList < Window_Selectable
alias :atbs_include? :include?
  #--------------------------------------------------------------------------
  # * Inclusão do item na lista
  #     item : item
  #--------------------------------------------------------------------------
  def include?(item)
    if Akea_Team_Skill::Data_Skill[item.id]
      check_inc = true
      Akea_Team_Skill::Data_Skill[item.id]['Actors'].each{|member| check_inc = false unless $game_party.members.include?($game_actors[member])}
      for n in 0...Akea_Team_Skill::Data_Skill[item.id]['Actors'].size
       check_inc = false unless $game_actors[Akea_Team_Skill::Data_Skill[item.id]['Actors'][n]].skill_learn?($data_skills[Akea_Team_Skill::Data_Skill[item.id]['Skills'][n]])
      end
      atbs_include?(item) && check_inc
    else
      atbs_include?(item)
    end
  end
end

#==============================================================================
# ** BattleManager
#------------------------------------------------------------------------------
#  Este módulo gerencia o andamento da batalha.
#==============================================================================

module BattleManager
  #--------------------------------------------------------------------------
  # * Forçar ação
  #--------------------------------------------------------------------------
  def self.remove_action(battler)
    for i in 0...battler.size - 1
      @action_battlers.delete($game_actors[battler[i]]) unless $game_actors[battler[i]].current_action.item == $data_skills[battler.last]
    end
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
alias :atbs_make_damage_value :make_damage_value
  #--------------------------------------------------------------------------
  # * Cálculo de dano
  #     user : usuário
  #     item : habilidade/item
  #--------------------------------------------------------------------------
  def make_damage_value(user, item)
    unless Akea_Team_Skill::Data_Skill[item.id] 
      atbs_make_damage_value(user, item)
      return
    end
    value = 0
    for n in 0...Akea_Team_Skill::Data_Skill[item.id]['Actors'].size - 1
      user = $game_actors[Akea_Team_Skill::Data_Skill[item.id]['Actors'][n]]
      value += item.damage.eval(user, self, $game_variables)
      value *= item_element_rate(user, item)
      value *= pdr if item.physical?
      value *= mdr if item.magical?
      value *= rec if item.damage.recover?
      value = apply_critical(value) if @result.critical
      value = apply_variance(value, item.damage.variance)
      value = apply_guard(value)
    end
    @result.make_damage(value.to_i, item)
  end
end

#==============================================================================
# ** Window_BattleLog
#------------------------------------------------------------------------------
#  Esta janela exibe o progresso da luta. Não exibe o quadro da
# janela, é tratado como uma janela por conveniência.
#==============================================================================

class Window_BattleLog < Window_Selectable
alias :atbs_display_use_item :display_use_item
    #--------------------------------------------------------------------------
  # * Exibição de uso de habilidade/item
  #     subject : lutador
  #     item    : habilidade/item
  #--------------------------------------------------------------------------
  def display_use_item(subject, item)
    if item.is_a?(RPG::Skill)
      unless Akea_Team_Skill::Data_Skill[item.id] 
        atbs_display_use_item(subject, item)
        return
      end
      name = ''
      for n in 0...Akea_Team_Skill::Data_Skill[item.id]['Actors'].size
        next unless Akea_Team_Skill::Data_Skill[item.id]['Actors'][n]
        if n == 0
          name += $game_actors[Akea_Team_Skill::Data_Skill[item.id]['Actors'][n]].name
        elsif n != Akea_Team_Skill::Data_Skill[item.id]['Actors'].size - 1
          name += ', ' + $game_actors[Akea_Team_Skill::Data_Skill[item.id]['Actors'][n]].name
        else
          name += Akea_Team_Skill::Conj + $game_actors[Akea_Team_Skill::Data_Skill[item.id]['Actors'][n]].name
        end
      end
      add_text(name + item.message1)
      unless item.message2.empty?
        wait
        add_text(item.message2)
      end
    else
      atbs_display_use_item(subject, item)
    end
  end
end