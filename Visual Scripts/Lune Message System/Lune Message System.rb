module Lune_Message
#=======================================================
# Lune Message System
# Author: Raizen
# Compatible with: RMVXAce
# The script allows message boxes above and below the
# character, with automatic size making a more interatvice
# message system between characters.
 
 
 
# Instructions
 
# To use the message just call the show message
# either with a face or not.
 
# before showing the message configure the character that
# will receive the message box.
# Also configure if it is below or above the character.
 
# It is also possible to toggle between the new message system
# and the old message system
 
# To configure the message system just do the following.
 
# Call Script:Lune_Message.config(p, id)
 
# Being p the position of the message box.
# 1 = above the character
# 0 = below the character
# 2 = old message system
 
# To deactivate this script just
# Call Script this way
# Call Script:Lune_Message.config(2, 0)
# Put a 1 frame wait before changing between the message systems,
# to give the system the time to reconfigure all the positions back to
# the old system, or from the old to the new system.
 
# ID is the event ID, being the ID 0 it is the Hero.
# The windows size is configured automatically, being that you
# will need to choose the length of the font to ajust better to the
# message box. (In pixels)
 
Espacamento = 11
 
# Size of the characters that you are using, an estimate to calculate
# the Boxes position.
 
Tamanho = 48
 
# Name of the picture file that will put a cursor above the character
# which is talking.
# In case you do not need any picture files put the constant this way.
# Imagem = ""
# The image needs to be in the file Graphics/System inside your project.
Imagem = "arrow"
# Height of the arrow image, for position displacement.
Alt = 10
# Movement of the arrow, 0 to deactivate.
Mov = 0
# ========================================================================
# Here starts the script.
# ========================================================================
 
def self.config(p, id)
posicao(p)
identificacao(id)
end

def self.posicao(p = nil)
@p = p unless p == nil
return @p
end

def self.identificacao(id = nil)
@id = id unless id == nil
return @id
end
end

#==============================================================================
# ** Janela auxiliar
#==============================================================================
class Lune_Window_Message < Window_Base
include Lune_Message
  def initialize(x, y, window_width, window_height)
    super(x, y, window_width, window_height)
    self.z = 199
    self.openness = 0
    @get_sprite = true
    @sprite_arrow = Sprite.new
    @sprite_arrow.bitmap = Cache.system(Imagem)
    if Lune_Message.identificacao == 0
      @lune_x = $game_player.screen_x
      @lune_y = $game_player.screen_y
      else
      @lune_x = $game_map.events[Lune_Message.identificacao].screen_x
      @lune_y = $game_map.events[Lune_Message.identificacao].screen_y
    end
    @sprite_arrow.x = @lune_x - 8
    @sprite_arrow.y = @lune_y - Lune_Message::Tamanho
  end
  def refresh
  if @get_sprite == true
  @sprite_arrow.y += Lune_Message::Mov
  @get_sprite = false
  else
  @sprite_arrow.y -= Lune_Message::Mov
  @get_sprite = true
  end
  end
  def openlune
    self.openness += 40
    self.openness <= 254 ? (return false) : (return true)
  end
  def closelune
    @sprite_arrow.opacity = 0 unless Imagem.nil?
    self.openness -= 40
    self.openness >= 1 ? (return false) : (return true)
  end
  def dispose
  @sprite_arrow.dispose
  super
  end
end

    
class Game_Message
# Retorna o valor da quantidade de linhas
   def get_lune_lines
     @lune_text_size = 0
     @texts.inject("") {|r, text| @lune_text_size += 1}
     return @lune_text_size
   end
# Retorna o valor do tamanho do texto.
  def get_lune_length
     @lune_length_size = 0
     @biggest = 0
     @texts.inject("") {|r, text| 
     if text.size > @lune_length_size
      @lune_length_size = text.size 
      @biggest = text.dup
      @biggest.delete! "\."
      @biggest.delete! "\!"
      @biggest.delete! "\c["
      @biggest.delete! "]"
      @biggest.delete! "["
      p @biggest
      end
     }
     return @biggest
   end
 end
 
#==============================================================================
# ** Window_Message
#------------------------------------------------------------------------------
#  Esta janela de mensagem é usada para exibir textos.
#==============================================================================
  #--------------------------------------------------------------------------
  # * Aquisição da largura da janela
  #--------------------------------------------------------------------------
class Window_Message < Window_Base
# aliasing
alias lune_message_update update  
alias lune_process_all_text process_all_text
alias lune_message_dispose dispose
alias lune_input_choice input_choice
  def initialize
    super(0, 0, Graphics.width, fitting_height(4))
    self.z = 200
    self.openness = 0
    create_all_windows
    create_back_bitmap
    create_back_sprite
    clear_instance_variables
    
  end
  def window_width
    text_size($game_message.get_lune_length).width + Lune_Message::Espacamento
  end
  #--------------------------------------------------------------------------
  # * Aquisição da altura da janela
  #--------------------------------------------------------------------------
  def window_height
    fitting_height($game_message.get_lune_lines)
  end
  def update(*args)
    lune_message_update(*args)
    unless Lune_Message.posicao == 2
    @lune_message.refresh if @lune_message and Graphics.frame_count % 25 == 1
    self.opacity = 0
    end
  end
  def fiber_main
    $game_message.visible = true
    update_background
    lune_update_placement if Lune_Message.posicao == 2
    loop do
      if Lune_Message.posicao == 2
      lune_process_all_text if $game_message.has_text?
      else
      process_all_text if $game_message.has_text?
      end
      process_input
      $game_message.clear
      @gold_window.close
      Fiber.yield
      break unless text_continue?
    end
    @lune_message.opacity = 0 unless @lune_message == nil and Lune_Message.posicao == 2
    close_and_wait
    $game_message.visible = false
    @fiber = nil
  end
  def lune_update_placement
    @position = $game_message.position
    self.y = @position * (Graphics.height - height) / 2
    self.x = 0
    @gold_window.y = y > 0 ? 0 : Graphics.height - @gold_window.height
  end
  def update_placement
    @gold_window.y = y > 0 ? 0 : Graphics.height - @gold_window.height
    unless Lune_Message.identificacao.nil?
      self.x = @lune_x - window_width / 2
      self.x -= (self.x + window_width - Graphics.width) if self.x + window_width >= Graphics.width
      self.x -= new_line_x
      self.x = [self.x,0].max    
      self.y = @lune_y
      self.y -= window_height + Lune_Message::Tamanho if Lune_Message.posicao == 1
      self.y = [self.y,0].max
      self.y -= (self.y + window_height - Graphics.height) if self.y + window_height >= Graphics.height
    end
  end
  #--------------------------------------------------------------------------
  # * Execução de todos texto
  #--------------------------------------------------------------------------
  def process_all_text
    if Lune_Message.identificacao == 0
      @lune_x = $game_player.screen_x
      @lune_y = $game_player.screen_y
      else
      @lune_x = $game_map.events[Lune_Message.identificacao].screen_x
      @lune_y = $game_map.events[Lune_Message.identificacao].screen_y
    end
    @lune_message.dispose unless @lune_message.nil?
    w = @lune_x - window_width / 2
    h = @lune_y
    $game_message.face_name.empty? ? (w = [w,0].max) : (w = [w,112].max)
    h -= window_height + Lune_Message::Tamanho if Lune_Message.posicao == 1
    h = [h,0].max
    w -= (w + window_width - Graphics.width) if w + window_width >= Graphics.width
    h -= (h + window_height - Graphics.height) if h + window_height >= Graphics.height
    @lune_message = Lune_Window_Message.new(w, h, window_width, window_height)
    @lune_face = Window_Base.new(w - 104, h + 8, 104, 104) unless $game_message.face_name.empty?
    update_placement
    text = convert_escape_characters($game_message.all_text)
    pos = {}
    new_page(text, pos)
    open_and_wait
    process_character(text.slice!(0, 1), text, pos) until text.empty?
  end
    #--------------------------------------------------------------------------
  # * Abertura da janela e espeta até abertura total
  #--------------------------------------------------------------------------
  def open_and_wait
    unless Lune_Message.posicao == 2
    @lune_message.openlune 
    Fiber.yield until @lune_message.openlune
    open
  else 
    open
    Fiber.yield until open?
  end
  end
    #--------------------------------------------------------------------------
  # * Fechamento da janela e espeta até fechamento total
  #--------------------------------------------------------------------------
  def close_and_wait
    close
    Fiber.yield until all_close?
    @lune_message.closelune if @lune_message 
    Fiber.yield until @lune_message.closelune unless Lune_Message.posicao == 2
  end
    #--------------------------------------------------------------------------
  # * Execução de espera de entrada
  #--------------------------------------------------------------------------
  def input_pause
    self.pause = true if Lune_Message.posicao == 2
    wait(10)
    Fiber.yield until Input.trigger?(:B) || Input.trigger?(:C)
    Input.update
    @lune_face.dispose unless @lune_face.nil?
    self.pause = false
  end
  def dispose
    @lune_message.dispose if @lune_message
    Lune_Message.config(2,0)
    lune_message_dispose
  end
  #--------------------------------------------------------------------------
  # * Execução de entrada de escolhas
  #--------------------------------------------------------------------------
  def input_choice
    lune_input_choice
    @lune_face.dispose unless @lune_face.nil?
  end
end