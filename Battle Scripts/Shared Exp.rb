#=======================================================
#         (Lune add-ons) Experiência Dividida
# Autor: Raizen
# Compativel com: RMVXAce
#=======================================================

# Instruções.
# Plug n' play, coloque acima do main e abaixo do script de batalha
# principal, se houver algum.

# Não necessário configurar, o script dividirá a experiência igualmente
# entre os membros vivos do grupo ao fim da batalha.

#==============================================================================
# ** BattleManager
#------------------------------------------------------------------------------
#  Este módulo gerencia o andamento da batalha.
#==============================================================================

module BattleManager
  #--------------------------------------------------------------------------
  # * Ganho de experiência
  #--------------------------------------------------------------------------
  def self.gain_exp
    $game_party.alive_members.each do |actor|
      actor.gain_exp($game_troop.exp_total/$game_party.alive_members.size )
      actor.gain_exp(1) unless $game_troop.exp_total % $game_party.alive_members.size == 0
    end
    wait_for_message
  end
end