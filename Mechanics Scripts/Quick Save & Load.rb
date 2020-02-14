#=======================================================
#         Script de Quick Save e Load
# Autor: Raizen
# Comunidade: www.centrorpg.com
# O script permite que seja salvo com o apertar de uma tecla,
# e que esse save seja carregado com o apertar de outra tecla.
#=======================================================
module Raizen_Savefile
# Para desativar a função de quick save, quando bem entender no jogo
# O Quick Save estará ativo apenas se tal switch estiver ligada.
Switchquick = 1
# Slot que ficará salvo o Quick Save, para esse eu recomendo que
# escolha um slot alto para que não possa ser visualizado no Save/Load.
# Para o Save/Load Padrão, acima de 15.
Slot_Quick = 101
# Tecla que será apertada para que ocorra o Quick Save,
Inputsave = :F5
# Tecla que será apertada para que ocorra o Quick Load
Inputload = :F7
# Texto que será escrito no momento em que o jogo for salvo.
# Caso não queira nenhum texto, basta colocar Textsave = nil
Textsave = "O Jogo foi Salvo"
# Texto logo antes de carregar o jogo.
# Caso não queira nenhum texto, basta colocar Textload = nil
Textload = "Carregando Jogo, Esc ou X cancela o carregamento"
# Qual som tocará a acontecer o save, caso não queira nenhum
# basta substituir a próxima linha por Sound = nil
Sound = "Save"
# Posição do texto em Y
Py = 300
# Tempo que ficará exposto o texto do save e load, em frames.
Time = 120
end

#==================================================================
# Aqui começa o script, mexa apenas se souber o que estiver fazendo
#==================================================================

class Scene_Map < Scene_Base
alias raizen_quick_save update
alias raizen_quick_load start
def start
  raizen_quick_load
  @count_save = 0
  @raizen_quicksave = nil if @raizen_quicksave != nil
  @load_raizen = false
  end
def update
  raizen_quick_save
  DataManager.save_game(Raizen_Savefile::Slot_Quick) if Input.press?(Raizen_Savefile::Inputsave)
   if Input.press?(Raizen_Savefile::Inputsave) and @count_save == 0 and $game_switches[1]
   RPG::SE.new(Raizen_Savefile::Sound).play if Raizen_Savefile::Sound != nil
   @raizen_quicksave = Window_Savemsg.new(Raizen_Savefile::Py, 0)
   @count_save = 1
   end
   if Input.press?(Raizen_Savefile::Inputload) and @count_save == 0 and $game_switches[1]
   RPG::SE.new(Raizen_Savefile::Sound).play if Raizen_Savefile::Sound != nil
   @raizen_quicksave = Window_Savemsg.new(Raizen_Savefile::Py, 1)
   @count_save = 1
   @load_raizen = true
   end
   DataManager.load_game(Raizen_Savefile::Slot_Quick) and SceneManager.call(Scene_Map)if @count_save > Raizen_Savefile::Time and @load_raizen == true
   @raizen_quicksave.close and @count_save = 0 if @count_save > Raizen_Savefile::Time
   @count_save += 1 if @count_save != 0
   end
end
class Window_Savemsg < Window_Base
  def initialize(y, b)
    super(0, y, 544, y + 100)
    self.opacity = 0
    if b == 0
    self.contents.draw_text(0, 0, 544, 100,Raizen_Savefile::Textsave, 1) if Raizen_Savefile::Textsave != nil
  else
    self.contents.draw_text(0, 0, 544, 100,Raizen_Savefile::Textload, 1) if Raizen_Savefile::Textload != nil
  end
  end
end