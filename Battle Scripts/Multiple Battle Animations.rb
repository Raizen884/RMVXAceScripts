#=======================================================
#         Multiple battle animations
# Autor: Raizen
# Comunidade: www.centrorpg.com
# Permite qualquer número de animações de batalha vindas de uma 
# mesma habilidade.
#=======================================================

module Lune_add_anima
Animation = []
# basta colocar o número da habilidade = as animações extras

# Exemplo
# Animation[52] = [59, 60]
# Irá aparecer normalmente a animação do skill 52 que é fogo 2,
# depois irá aparecer 2 animações de id 59 e 60 respectivamente.
# Adicione quantas linhas desejar
Animation[69] = [76,76]
Animation[52] = [59, 60]
end


#==============================================================================
# Aqui começa o script.
#==============================================================================
# ** Scene_Battle
#------------------------------------------------------------------------------
#  Esta classe executa o processamento da tela de batalha.
#==============================================================================

class Scene_Battle < Scene_Base
alias :rai_repeat_invoke :use_item
alias :rai_repeat_show :show_animation
  #--------------------------------------------------------------------------
  # * Uso de habilidades/itens
  #--------------------------------------------------------------------------
  def use_item
    @skill_rai_id = @subject.current_action.item.id
    rai_repeat_invoke
  end
  #--------------------------------------------------------------------------
  # * Exibição de animações
  #     targets      : lista dos alvos
  #     animation_id : ID da animação (-1: animação do ataque normal)
  #--------------------------------------------------------------------------
  def show_animation(targets, animation_id)
    rai_repeat_show(targets, animation_id)
    @allocate_skills = Lune_add_anima::Animation[@skill_rai_id]
    @allocate_skills = Array.new unless @allocate_skills.is_a?(Array)
    n = 0
    while @allocate_skills[n] != nil
      show_normal_animation(targets, @allocate_skills[n])
      @log_window.wait
      wait_for_animation
      n += 1
    end
  end
end