#=======================================================
#         Message Sound
# Autor : Raizen
# Comunidade : Centrorpg.com
# Função do script: O script adiciona um som a cada tecla digitada
# nas mensagens, perfeito para fazer efeito de maquina de escrever por exemplo
#=======================================================
#=======================================================
module Raizen_Message
# Volume do Som
Volume = 80
# Arquivo que será tocado na pasta SE
Sound = "Key"
# Frequencia que será tocado o som (0 equivale a cada tecla digitada)
Freq = 4
# Switch que ativa e desativa o efeito.
Switch = 1
end
# Aqui começa o script
#=======================================================
class Window_Message < Window_Base
alias :raizen_sound_message :wait_for_one_character
alias :raizen_initialize_sound initialize
  def initialize
  raizen_initialize_sound
  @charcount = 0
  end
  def wait_for_one_character
    raizen_sound_message
    if $game_switches[Raizen_Message::Switch]
      if @charcount == Raizen_Message::Freq
        RPG::SE.new(Raizen_Message::Sound, @volume = Raizen_Message::Volume).play
        @charcount = 0
      else
        @charcount += 1
      end
    end
  end
end
