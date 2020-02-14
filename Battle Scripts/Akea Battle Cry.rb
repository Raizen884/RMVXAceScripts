#=======================================================
#        Akea Battle Cry
# Autor: Raizen
# Comunidade: http://www.centrorpg.com/
# Compatibilidade: RMVXAce
# Demo Download: http://www.mediafire.com/download/5lq2x090cij7mxb/Akea+Battle+Cry.exe
#=======================================================
# =========================Não modificar==============================
$included ||= Hash.new
$included[:akea_battlecry] = true
module Akea_BattleCry
Cry = []
Actors = []
Enemies = []
# =========================Não modificar==============================



#==============================================================================
#------------------------------------------------------------------------------
# Actors - Aqui são definidas aos sons de cada actor,
# os números são definidos na configuração Cry logo abaixo.
# podem ser adicionadas quantas linhas desejar por atores, basta
# o número ter na configuração Cry também.

# Podem ser adicionados quantos sons desejarem por ação e quantas
# ações desejar

# Os sons devem estar na pasta Audio/SE e o nome é colocado dentro de
# [] e separado por virgula, por exemplo [som1, som2, som3]
#------------------------------------------------------------------------------
#==============================================================================


#==============================================================================
# Actors[1]  1 == id do personagem no BD
#==============================================================================

Actors[1] = {
1 => ['1-Attack1', '1-Attack2'], # Ataque Normal
2 => ['1-Skill1'], # Habilidades
3 => ['1-Start1'], # Som de Entrada
4 => ['1-Hit1'], # Som ao ser atingido
5 => ['1-Dead1', '1-Dead2'], # Som ao cair
6 => ['1-Victory1'], #S Som de vitória
7 => ['1-Healed1'], #Som de recuperação de vida
}
#==============================================================================
# Actors[8] 8 == id do personagem no BD
#==============================================================================
Actors[8] = {
1 => ['8-Attack1', '8-Attack2'], # Ataque Normal
2 => ['8-Skill1'], # Habilidades
3 => ['8-Start1'], # Som de Entrada
4 => ['8-Hit1', '8-Hit2'], # Som ao ser atingido
5 => ['8-Dead1'], # Som ao cair
6 => ['8-Victory1'], #S Som de vitória
7 => ['8-Healed1'], #Som de recuperação de vida
}
#==============================================================================
#------------------------------------------------------------------------------
# Enemies o mesmo que acima, porém com inimigos se desejar
#------------------------------------------------------------------------------
#==============================================================================
#==============================================================================
# Enemies[1] 1 == id do inimigo no BD
#==============================================================================
Enemies[1] = {
1 => ['8-Attack1', '8-Attack2'], # Ataque Normal
2 => ['8-Skill1'], # Habilidades
3 => ['8-Start1'], # Som de Entrada
4 => ['8-Hit1', '8-Hit2'], # Som ao ser atingido
5 => ['8-Dead1'], # Som ao cair
6 => ['8-Victory1'], #S Som de vitória
}

#==============================================================================
#------------------------------------------------------------------------------
# Cry - Aqui são definidas as préconfigurações de  Battle Cry
# seguindo esse estilo
# Cry[id do cry] = [
#som, som que será chamado logo acima no Actors ou Enemies
# probabilidade de 0-100]

# Para adicionar o som ao skill basta colocar no bloco de notas no 
# database o seguinte <cry id> aonde id você substitui o id do cry
# configurado abaixo
#------------------------------------------------------------------------------
#==============================================================================
Cry[1] = [ # Por padrão é o som de entrada na batalha
3, # Id do Som que será tocado  no Actors ou Enemies
100] # Probabilidade em porcentagem
Cry[2] = [ # Por padrão o som ao ser atingido
4, # Id do Som que será tocado  no Actors ou Enemies
100] # Probabilidade em porcentagem
Cry[3] = [ # por padrão o som ao cair
5, # Id do Som que será tocado  no Actors ou Enemies
100] # Probabilidade em porcentagem
Cry[4] = [ # Por padrão o som de vitória
6, # Id do Som que será tocado  no Actors ou Enemies
100] # Probabilidade em porcentagem
Cry[5] = [ # Por padrão o som ao recuperar vida
7, # Id do Som que será tocado  no Actors ou Enemies
100] # Probabilidade em porcentagem

Cry[6] = [
1, # Id do Som que será tocado  no Actors ou Enemies
100] # Probabilidade em porcentagem

Cry[7] = [
2, # Id do Som que será tocado  no Actors ou Enemies
100] # Probabilidade em porcentagem

end
#==============================================================================
# ** Scene_Battle
#------------------------------------------------------------------------------
#  Esta classe executa o processamento da tela de batalha.
#==============================================================================

class Scene_Battle < Scene_Base
alias :akea_bcry_process_action :process_action
alias :akea_bcry_start :start
alias :akea_bcry_use_item :use_item
  #--------------------------------------------------------------------------
  # * Inicialização do processo
  #--------------------------------------------------------------------------
  def start
    akea_bcry_start
    @random_anim = rand($game_party.battle_members.size) unless @random_anim
    battle_cry($game_party.battle_members[@random_anim] , 1)
  end
  
  #--------------------------------------------------------------------------
  # * Processamento de ações
  #--------------------------------------------------------------------------
  def process_action
    unless $included[:lune_animated_battle]
      if !@subject || !@subject.current_action
        @subject = BattleManager.next_subject
      end
      if @subject && @subject.current_action
        battle_notes = @subject.current_action.item.note
        for n in 0...battle_notes.size - 3
          if battle_notes[n..n+4] == "<cry "
            y = 0
            y += 1 until battle_notes[n+4+y] == '>'
            battle_cry(@subject,  battle_notes[n+4..n+4+y].to_i)
          end
        end
      end
      akea_bcry_process_action
    else
      akea_bcry_process_action
      if @subject && @subject.current_action
        battle_notes = @subject.current_action.item.note
        for n in 0...battle_notes.size - 3
          if battle_notes[n..n+4] == "<cry "
            y = 0
            y += 1 until battle_notes[n+4+y] == '>'
            battle_cry(@subject,  battle_notes[n+4..n+4+y].to_i)
          end
        end
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Criar chance de som
  #--------------------------------------------------------------------------
  def make_random_cry(n)
    rand(100) < n ? true : false
  end
  #--------------------------------------------------------------------------
  # * Chamada Principal
  #--------------------------------------------------------------------------
  def battle_cry(n, cry_id)
    if n.actor? && Akea_BattleCry::Actors[n.id] && Akea_BattleCry::Actors[n.id][Akea_BattleCry::Cry[cry_id][0]] 
      sound = Akea_BattleCry::Actors[n.id][Akea_BattleCry::Cry[cry_id][0]].shuffle.first
      RPG::SE.new(sound).play if make_random_cry(Akea_BattleCry::Cry[cry_id][1])
    elsif n.enemy? && Akea_BattleCry::Enemies[n.enemy_id] && Akea_BattleCry::Enemies[n.enemy_id][Akea_BattleCry::Cry[cry_id][0]] 
      sound = Akea_BattleCry::Enemies[n.enemy_id][Akea_BattleCry::Cry[cry_id][0]].shuffle.first
      RPG::SE.new(sound).play if make_random_cry(Akea_BattleCry::Cry[cry_id][1])
    end
  end
  #--------------------------------------------------------------------------
  # * Usar Item
  #--------------------------------------------------------------------------
  def use_item
    akea_bcry_use_item
    if $game_troop.all_dead?
      if @subject && @subject.actor?
        @random_anim = @subject.index
      else
        @random_anim = rand($game_party.alive_members.size)
      end
      battle_cry($game_party.alive_members[@random_anim] , 4)
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
alias :akea_bcry_execute_damage :execute_damage
  #--------------------------------------------------------------------------
  # * Processamento do dano
  #     user : usuário
  #--------------------------------------------------------------------------
  def execute_damage(user)
    akea_bcry_execute_damage(user)
    @result.hp_damage > 0 ? nu = 2 : nu = 5
    nu = 0 if @result.hp_damage == 0
    self.hp == 0 ? n = 3 : n = nu
    if Akea_BattleCry::Cry[n] && self.actor? && Akea_BattleCry::Actors[self.id] && Akea_BattleCry::Actors[self.id][Akea_BattleCry::Cry[n][0]] 
      sound = Akea_BattleCry::Actors[self.id][Akea_BattleCry::Cry[n][0]].shuffle.first
      RPG::SE.new(sound).play if make_random_cry(Akea_BattleCry::Cry[n][1])
    elsif Akea_BattleCry::Cry[n] && self.enemy? && Akea_BattleCry::Enemies[self.enemy_id] && Akea_BattleCry::Enemies[self.enemy_id][Akea_BattleCry::Cry[n][0]] 
      sound = Akea_BattleCry::Enemies[self.enemy_id][Akea_BattleCry::Cry[n][0]].shuffle.first
      RPG::SE.new(sound).play if make_random_cry(Akea_BattleCry::Cry[n][1])
    end
  end
  #--------------------------------------------------------------------------
  # * Criar chance de som
  #--------------------------------------------------------------------------
  def make_random_cry(n)
    rand(100) < n ? true : false
  end
end