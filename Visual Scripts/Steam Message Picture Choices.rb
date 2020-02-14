#=======================================================
#        Rickas VN Engine - Picture Choice
# Autor: Raizen
# Compatibilidade: RMVXAce
# Comunidade: centrorpg.com
# Adiciona um estilo de escolhas por imagens, lembrando muito
# as escolhas de Visual Novels
#=======================================================


module Rai_VN_Engine
# Correção da posição em X e Y das escolhas
Opt_X = 20
Opt_Y = 50
# Espaçamento em Y das imagens de escolha
Space = 50

# Correção da posição dos textos
Text_Y = -10

# Opacidade de escolha, caso não esteja selecionado
Opacity = 170

# As imagens devem estar em uma pasta chamada Message, dentro da
# pasta Graphics do seu projeto.
#Imagem de fundo das escolhas, coloque o nome da imagem entre aspas "".
Image = "choices"
end
#==============================================================================
#===================== A partir daqui começa o script =========================
#==============================================================================

#==============================================================================
# ** Game_Interpreter
#------------------------------------------------------------------------------
#  Um interpretador para executar os comandos de evento. Esta classe é usada
# internamente pelas classes Game_Map, Game_Troop e Game_Event.
#==============================================================================

class Game_Interpreter
  #--------------------------------------------------------------------------
  # * Configuação de escolhas
  #     params : parâmetros
  #--------------------------------------------------------------------------
  def setup_choices(params)
    $choices_pics = Array.new(params[0].size)
    for n in 0...$choices_pics.size
      $choices_pics[n] = Sprite.new
      $choices_pics[n].bitmap = Cache.message(Rai_VN_Engine::Image)
      $choices_pics[n].opacity = 255
      $choices_pics[n].y = Rai_VN_Engine::Opt_Y + n * Rai_VN_Engine::Space + (4 - $choices_pics.size)*Rai_VN_Engine::Space
      $choices_pics[n].x = Rai_VN_Engine::Opt_X
      $choices_pics[n].z = 210
    end
    params[0].each {|s| $game_message.choices.push(s) }
    $game_message.choice_cancel_type = params[1]
    $game_message.choice_proc = Proc.new {|n| @branch[@indent] = n }
  end
end


#==============================================================================
# ** Cache
#------------------------------------------------------------------------------
#  Este modulo carrega cada gráfico, cria um objeto de Bitmap e retém ele.
# Para acelerar o carregamento e preservar memória, este módulo matém o
# objeto de Bitmap em uma Hash interna, permitindo que retorne objetos
# pré-existentes quando mesmo Bitmap é requerido novamente.
#==============================================================================


module Cache
  #--------------------------------------------------------------------------
  # * Carregamento dos gráficos de animação
  #     filename : nome do arquivo
  #     hue      : informações da alteração de tonalidade
  #--------------------------------------------------------------------------
  def self.message(filename)
    load_bitmap("Graphics/Message/", filename)
  end
end
#==============================================================================
# ** Window_ChoiceList
#------------------------------------------------------------------------------
#  Esta janela é utilizada para o comando de eventos [Mostrar Escolhas]
#==============================================================================

class Window_ChoiceList < Window_Command
  #--------------------------------------------------------------------------
  # * Inicialização do objeto
  #     message_window : janela de mensagem
  #--------------------------------------------------------------------------
  def initialize(message_window)
    @message_window = message_window
    super(0, 0)
    self.openness = 0
    self.opacity = 0
    deactivate
  end
  #--------------------------------------------------------------------------
  # * Atualização do processo
  #--------------------------------------------------------------------------
  def update
   super
   if $choices_pics
     $choices_pics.each{|pic| pic.opacity = Rai_VN_Engine::Opacity}
     $choices_pics[index].opacity = 255
   end
  end
  #--------------------------------------------------------------------------
  # * Atualização da posição da janela
  #--------------------------------------------------------------------------
  def update_placement
    self.width = Graphics.width
    self.width = [width, Graphics.width].min
    self.height = fitting_height($game_message.choices.size)*2
    self.x = 0
    if @message_window.y >= Graphics.height / 2
      self.y = @message_window.y - height
    else
      self.y = @message_window.y + @message_window.height
    end
    self.y += Rai_VN_Engine::Text_Y
    self.z = 211
  end
  #--------------------------------------------------------------------------
  # * Cálculo da altura do conteúdo da janela
  #--------------------------------------------------------------------------
  def contents_height
    fitting_height($game_message.choices.size)*2 - 30
  end
  #--------------------------------------------------------------------------
  # * Desenho de um item
  #     index : índice do item
  #--------------------------------------------------------------------------
  def draw_item(index)
    draw_text(0, index * Rai_VN_Engine::Space, Graphics.width, fitting_height(1) - 5, command_name(index), 1)
  end
  #--------------------------------------------------------------------------
  # * Definição de cancelamento
  #--------------------------------------------------------------------------
  def cancel_enabled?
    $game_message.choice_cancel_type > 0
  end
  #--------------------------------------------------------------------------
  # * Atualização do cursor
  #--------------------------------------------------------------------------
  def update_cursor
      cursor_rect.empty
  end
  #--------------------------------------------------------------------------
  # * Chamada de controlador de cancelamento
  #--------------------------------------------------------------------------
  def call_cancel_handler
    $game_message.choice_proc.call($game_message.choice_cancel_type - 1)
    close
  end
  def close
    super
    $choices_pics.each{|pics| pics.bitmap.dispose; pics.dispose}
    $choices_pics = nil
  end
end