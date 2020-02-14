#=======================================================
#        Rickas VN Engine - Steam Message
# Autor: Raizen
# Compatibilidade: RMVXAce

# Adiciona um estilo de mensagem muito fácil de aplicar,
# e bem semelhante a Visual Novels
#=======================================================

# Instruções:

# Configure tudo que está abaixo, com suas devidas explicações,
# e ai sempre que quiser que a face mude de lado basta 
# Para colocar do lado esquerdo
# Chamar Script: $message_side = 1
# Para colocar do lado direito
# Chamar Script: $message_side = 2

# O nome do personagem é automático de acordo com o nome do arquivo
# da face, as faces são individuais, então um arquivo de imagem para
# cada face.

# Para expressões diferentes, para que apareça na parte do nome,
# Na mensagem apenas o nome, basta colocar um número entre aspas, que
# o script tira automaticamente do nome do personagem, assim.

# Carlos(3).png, o script considera o nome do personagem como Carlos.

# As imagens devem estar em uma pasta chamada Message, dentro da
# pasta Graphics do seu projeto.

module Rickas_VN_Engine
# Correção da Posição em X das mensagens
Pos_X = 30
# Correção da Posição em Y das mensagens
Pos_Y = 15

# Gráfico do fundo da mensagem, nomes de arquivos sempre entre aspas ""
MessageBack = 'MessageBack'

# Gráfico que fica a frente da imagem
MessageFront = 'Over'

# Exibir nome do personagem?(true = sim, false = não)
Exibir = true
# Posição do nome do personagem
Pers_X = 30
Pers_Y = 254

# Posição em Y das faces
Face_Y = 0

#Posição em X das faces
Face_X = -80

# Adição em X quando a face estiver invertida
Add_X = 280

# Face fica sobre ou abaixo do messageback? (true = sobre, false = abaixo)
Sobre = false

# Velocidade que aparece as faces
Speed = 15
end
#==============================================================================
#===================== A partir daqui começa o script =========================
#==============================================================================


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
$message_side = 1
#==============================================================================
# ** Window_Message
#------------------------------------------------------------------------------
#  Esta janela de mensagem é usada para exibir textos.
#==============================================================================

class Window_Message < Window_Base
include Rickas_VN_Engine
alias rickas_vn_initialize initialize
alias rickas_vn_update update
alias rickas_vn_dispose dispose
  #--------------------------------------------------------------------------
  # * Inicialização do objeto
  #--------------------------------------------------------------------------
  def initialize
    rickas_vn_initialize
    @messageback = Sprite.new
    @messageback.bitmap = Cache.message(MessageBack)
    @messageback.z = 190
    @messagefront = Sprite.new
    @messagefront.bitmap = Cache.message(MessageFront)
    @messagefront.opacity = 0
    @messagefront.z = 201
    @messageback.opacity = 0
    @message_name = Message_Name.new
    @message_name.z = 200
    @face_sprite = Sprite.new
  end
  def update
    rickas_vn_update
    self.opacity = 0
    self.openness == 0 ? @face_sprite.opacity = 0 : @face_sprite.opacity += Speed
    @messageback.opacity = @messagefront.opacity = @message_name.contents_opacity = self.openness
  end
  def window_height
    fitting_height(4)
  end
  #--------------------------------------------------------------------------
  # * Execução de espera de entrada
  #--------------------------------------------------------------------------
  def input_pause
    wait(10)
    Fiber.yield until Input.trigger?(:B) || Input.trigger?(:C)
    Input.update
  end
  #--------------------------------------------------------------------------
  # * Definição de quebra de página
  #     text : texto
  #     pos  : posição
  #--------------------------------------------------------------------------
  def new_page(text, pos)
    contents.clear
    @message_name.refresh($game_message.face_name)
    if $message_side == 1
      draw_vn_face($game_message.face_name, Face_X, Face_Y)
    else
      draw_vn_face($game_message.face_name, Face_X + Add_X, Face_Y)
    end
    reset_font_settings
    pos[:x] = new_line_x
    pos[:y] = 0 + Pos_Y
    pos[:new_x] = new_line_x
    pos[:height] = calc_line_height(text)
    clear_flags
  end
  #--------------------------------------------------------------------------
  # * Desenho do gráfico de rosto
  #     face_name  : nome do gráfico de face
  #     face_index : índice do gráfico de face
  #     x          : coordenada X
  #     y          : coordenada Y
  #     enabled    : habilitar flag, translucido quando false
  #--------------------------------------------------------------------------
  def draw_vn_face(face_name, x, y, enabled = true)
    @face_sprite.bitmap = Cache.face(face_name)
    @face_sprite.x = x
    @face_sprite.y = y
    @face_sprite.opacity = 0
    Sobre ? @face_sprite.z = 191 : @face_sprite.z = 189 
    @face_sprite.mirror = true if $message_side == 2
  end
  #--------------------------------------------------------------------------
  # * Definição de quebra de linha
  #--------------------------------------------------------------------------
  def new_line_x
    Pos_X
  end
  #--------------------------------------------------------------------------
  # * Disposição
  #--------------------------------------------------------------------------
  def dispose
    rickas_vn_dispose
    @messageback.bitmap.dispose
    @messageback.dispose
    @messagefront.bitmap.dispose
    @messagefront.dispose
    @message_name.dispose
    @face_sprite.bitmap.dispose if @face_sprite.bitmap
    @face_sprite.dispose
  end
end

class Message_Name < Window_Base
include Rickas_VN_Engine
  def initialize
    super(Pers_X, Pers_Y, 200, fitting_height(2))
    self.opacity = 0
    self.contents_opacity = 0
    refresh('')
  end
  def refresh(text)
    contents.clear   
    text = text.gsub(/\((\d+)\)/, "") if text[/\((\d+)\)/]
    draw_text(0, 0, self.width, self.height, text, 0)
  end
end
