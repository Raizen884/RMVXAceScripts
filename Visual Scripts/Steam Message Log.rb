#=======================================================
#        Rickas VN Engine - Message Log & Message Skip
# Autor: Raizen
# Compatibilidade: RMVXAce
# Comunidade: centrorpg.com
# Adiciona um log de mensagens para poder visualizar, 
# As mensagens recentes que foram fechadas.
# Além disso o script permite um skip muito rápido de
# mensagens, que ignora os caracteres \| \. etc...
#=======================================================

# Instruções.

# Para ativar o message log, basta..
# Chamar Script: SceneManager.call(Scene_Message_Log)

# Configure abaixo como desejar.

module Rickas_Log
# Velocidade do fast skip?
# 0-3 = Extremamente Rápido, 4-7 = Muito Rápido, 8-10 = Rápido.
Speed = 2

# Tecla que dará o skip de mensagens, 
# Lembrando que é compatível com o Full Keyboard Module, 
# bastando colocar o Key::Ctrl por exemplo
# Teclas do maker, basta colocar o : na frente, exemplo.
# :X, :Y, :C, :L...
Key_Skip = :L

# Número de linhas?
Line_Num = 17
# Usando o Script de Steam Message? ( Para efeito de reconhecimento
# de nomes) (true/false)
Steam = true

# Espaço para o texto aparecer, caso use o Steam Message
# é o espaço dado para escrever o nome do personagem no log.

Name_Space = 120
end


#==============================================================================
#===================== A partir daqui começa o script =========================
#==============================================================================


#==============================================================================
# ** Window_Message
#------------------------------------------------------------------------------
#  Esta janela de mensagem é usada para exibir textos.
#==============================================================================

class Window_Message < Window_Base
#------------------------------------------------------------------------------
#------------- Aliasing ----------------
#------------------------------------------------------------------------------
alias rickas_show update_show_fast
alias rickas_wait wait
alias rickas_page new_page
  #--------------------------------------------------------------------------
  # * Execução de espera de entrada
  #--------------------------------------------------------------------------
  def input_pause
    self.pause = true
    wait_real(10)
    Fiber.yield until Input.trigger?(:B) || Input.trigger?(:C) || Input.press?(Rickas_Log::Key_Skip)
    Input.update
    self.pause = false
  end
  #--------------------------------------------------------------------------
  # * Atualização de exibição rápida
  #--------------------------------------------------------------------------
  def update_show_fast
    rickas_show
    @show_fast = true if Input.press?(Rickas_Log::Key_Skip)
  end
  #--------------------------------------------------------------------------
  # * Tempo de espera
  #     duration : duração
  #--------------------------------------------------------------------------
  def wait_real(duration)
    if Input.press?(Rickas_Log::Key_Skip)
      duration = Rickas_Log::Speed
      duration.times {Fiber.yield }
      return 
    end
    duration.times { Fiber.yield }
  end
  def wait(duration)
    return if Input.press?(Rickas_Log::Key_Skip)
    rickas_wait(duration)
  end
  #--------------------------------------------------------------------------
  # * Processamento de caracteres
  #     c    : caractere
  #     text : texto a ser desenhado
  #     pos  : posição de desenho {:x, :y, :new_x, :height}
  #--------------------------------------------------------------------------
  def process_character(c, text, pos)
    case c
    when "\n"   # Quebra de linha
      process_new_line(text, pos)
      add_rickas_text(c, 1)
    when "\f"   # Quebra de página
      process_new_page(text, pos)
    when "\e"   # Caractere de controle
      process_escape_character(obtain_escape_code(text), text, pos)
    else        # Caracteres comuns
      process_normal_character(c, pos)
      add_rickas_text(c, 0)
    end
  end
  #--------------------------------------------------------------------------
  # * Processamento de caracteres do Message Log.
  #--------------------------------------------------------------------------
  def add_rickas_text(c, n)
    case n
    when 0
      $game_map.rickas_saved_text[$game_map.rickas_num] += c
    when 1
      if $game_map.rickas_num < Rickas_Log::Line_Num - 1
        $game_map.rickas_num += 1 
      else
        $game_map.rickas_saved_text.shift
        $game_map.rickas_saved_names.shift
        $game_map.rickas_saved_text.push(String.new)
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Definição de quebra de página
  #     text : texto
  #     pos  : posição
  #--------------------------------------------------------------------------
  def new_page(text, pos)
    text_na = $game_message.face_name
    text_na = text_na.gsub(/\((\d+)\)/, "") if text_na[/\((\d+)\)/]
    $game_map.rickas_saved_names[$game_map.rickas_num] = text_na
    rickas_page(text,pos)
  end
end
#==============================================================================
# ** Game_Map
#------------------------------------------------------------------------------
#  Esta classe gerencia o mapa. Inclui funções de rolagem e definição de 
# passagens. A instância desta classe é referenciada por $game_map.
#==============================================================================

class Game_Map
  
alias rickas_initialize initialize
  #--------------------------------------------------------------------------
  # * Variáveis públicas
  #--------------------------------------------------------------------------
attr_accessor :rickas_saved_text
attr_accessor :rickas_saved_names
attr_accessor :rickas_num
  #--------------------------------------------------------------------------
  # * Inicialização do objeto
  #     actor_id : ID do herói
  #--------------------------------------------------------------------------
  def initialize
    rickas_initialize
    #--------------------------------------------------------------------------
    # * Inicialização das variáveis que contém os textos do Message Log
    #--------------------------------------------------------------------------
    @rickas_saved_text = Array.new(Rickas_Log::Line_Num){|a| a = String.new}
    @rickas_saved_names = Array.new(Rickas_Log::Line_Num){|a| a = String.new}
    @rickas_num = 0
  end
end




#==============================================================================
# ** Window_Log
#------------------------------------------------------------------------------
#  Esta janela de textos exibirá os textos salvos.
#==============================================================================
class Window_Log < Window_Base
include Rickas_Log
  #--------------------------------------------------------------------------
  # * Inicialização 
  #--------------------------------------------------------------------------
  def initialize
    super(0, 0, Graphics.width, Graphics.height)
    self.opacity = 0
    refresh
  end
  #--------------------------------------------------------------------------
  # * Textos a serem escritos
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    for n in 0...Line_Num - 1
      draw_text(Name_Space, n * line_height, Graphics.width - Name_Space , line_height, $game_map.rickas_saved_text[n], 0)
      draw_text(0, n * line_height, Name_Space , line_height, $game_map.rickas_saved_names[n].to_s + " :", 0)
    end
  end
end

#==============================================================================
# ** Scene_Message_Log
#------------------------------------------------------------------------------
#  Esta scene executa a cena de log de mensagens
#==============================================================================
class Scene_Message_Log < Scene_MenuBase
  #--------------------------------------------------------------------------
  # * Inicialização 
  #--------------------------------------------------------------------------
  def start
    super
    @message_log = Window_Log.new
  end
  #--------------------------------------------------------------------------
  # * Atualização
  #--------------------------------------------------------------------------
  def update
    super
    if Input.trigger?(:B)
      Sound.play_ok
      return_scene
    end
  end
end