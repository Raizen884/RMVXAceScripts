#=======================================================
#         Lune Frame Skipper
# Autor: Raizen
# Compativel com: RMVXAce
# Comunidade: www.centrorpg.com
# O script permite um pulo de frames na atualização de gráficos, 
# muito útil para jogos que tem uma programação pesada, e 
# atualização de gráficos, funcionando com um anti-lag.
# Detalhe: anti-lags são compátiveis com esse script.
#========================================================

# Total de Frames por segundo.(Padrão 60, diminua para aumentar o desempenho)
Graphics.frame_rate = 30

# Você pode alterar a taxa de FPS fazendo.
# Chamar Script: Graphics.frame_rate = Taxa de FPS

#========================================================
# Aqui começa o Script
#========================================================

#==============================================================================
# ** Scene_Base
#------------------------------------------------------------------------------
#  Esta é a superclasse de todas as cenas do jogo.
#==============================================================================
class Scene_Base
alias skipper_main main
  #--------------------------------------------------------------------------
  # * Processamento principal
  #--------------------------------------------------------------------------
  def main
    @fr_cont = 0
    skipper_main
  end
  #--------------------------------------------------------------------------
  # * Execução da transição
  #--------------------------------------------------------------------------
  def perform_transition
    Graphics.transition(transition_speed * Graphics.frame_rate / 60)
  end
  #--------------------------------------------------------------------------
  # * Atualização da tela (básico)
  #--------------------------------------------------------------------------
  def update_basic
    if @fr_cont >= 60
      Graphics.update       
      @fr_cont -= 60
    end
    @fr_cont += Graphics.frame_rate
    update_all_windows
    Input.update
  end
end