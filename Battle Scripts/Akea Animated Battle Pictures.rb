#=======================================================
#        Akea Animated Battle Pictures
# Author: Raizen
# Comunity: http://www.centrorpg.com/
# Compatibility: RMVXAce
#

# Instructions:
# The script adds the function that, you can use it to animate
# pictures or icons, this allows portraits to be shown, items to be thrown
# (arrows and spells), and many things that you can think of.



#=======================================================
# =========================Don't modify!==============================
$imported ||= Hash.new
$imported[:akea_battlepictures] = 1.0
module Akea_BattlePic
Battle_Pic = Array.new
Movement = Array.new
# =========================Don't modify!==============================

# Instances is the number of max pictures simultaneous on the screen
Instances = 5

# Below is Configured the Battle Pic, Battle_Pic is where the initial
# and global configuration will be, they all use this template

=begin
  id is the id number, must be unique
Battle_Pic[id] = {     
  this is where the picture goes, put picture name inside "", you
  can also use icons, just putting the icon index without ""
  Picture must be in folder Graphics/Akea of your project
:picture => "arrow",    
  This is the movement it will make, check the Movement configuration below
  and put the id inside [], you can have as many movement as wanted, just
  separate them by commas ,
:movement => [0],
  Here goes the initial position, it can be a exact position, [pos x, pos y]
  'user', or 'target' target only works for akea, contact me for other system supports
:position => 'user',
  Offset is like the position, but from the position, how
  many pixels in x and y I will "offset"
:offset => [-10, -40],
  Here is the z position, for picture overlay correction
:z_pos => 100,
  Total frames, put 1 if the picture has no more then 1 frame
:frames => 1,
  Time to change frames, put 1 if the picture has no more then 1 frame
:time => 1,
} <- don't take this out


=end

# To call this script just, 
# akea_picture(n), where n is the id
# Some systems can have script calls different, 
# if akea_picture(n) does not work, use SceneManager.scene.akea_picture(n)

#==============================================================================
# Battle_Pic[0] => arrow animation
#==============================================================================
Battle_Pic[0] = {
:picture => "arrow",
:movement => [0],
:position => 'user',
:offset => [-10, -30],
:z_pos => 100,
:frames => 1,
:time => 1,
}
#==============================================================================
# Battle_Pic[1] => throw axe animation
#==============================================================================
Battle_Pic[1] = {
:picture => 144,
:movement => [1],
:position => 'user',
:offset => [-10, -40],
:z_pos => 100,
:frames => 1,
:time => 1,
}
#==============================================================================
# Battle_Pic[2] => wind animation
#==============================================================================
Battle_Pic[2] = {
:picture => 'animated_state2',
:movement => [2],
:position => 'user',
:offset => [-10, -40],
:z_pos => 100,
:frames => 12,
:time => 5,
}
#==============================================================================
# Battle_Pic[3] => special skill animation
#==============================================================================
Battle_Pic[3] = {
:picture => 'special',
:movement => [3, 4],
:position => [300, 200],
:offset => [0, 0],
:z_pos => 100,
:frames => 1,
:time => 1,
}

# Below is Configured the Movement, the movement is the id
# that will go inside the :movement =>, in above configuration

=begin
  id is the id number, must be unique
Movement[id] = {
  this is the end position of the movement, can be an exact position [pos x, pos y]
  or 'user' or 'target', target only works with akea animated battle, for
  other battler systems contact me
:end => 'target',
  offset is the same offset from BattlePic, it is how much it will
  offset from the final position
:offset => [-10, -40],
  time is the tame this movement will take
:time => 30,
  jumpheight is the height of the jump, good for animation of throwing items
:jumpheight => 0,
  rotate is if the picture will rotate, and how much it will,
  0 = no rotation, the higher the faster.
:rotate => 0,
} <- don't take this out


=end
#==============================================================================
# Movement[0] => picture goes toward the target
#==============================================================================
Movement[0] = {
:end => 'target',
:offset => [-10, -40],
:time => 30,
:jumpheight => 0,
:rotate => 0,
}
#==============================================================================
# Movement[1] => picture goes toward the target(but with jump and rotation)
#==============================================================================
Movement[1] = {
:end => 'target',
:offset => [-10, -40],
:time => 30,
:jumpheight => 30,
:rotate => 10,
}
#==============================================================================
# Movement[2] => picture goes toward the target(longer)
#==============================================================================
Movement[2] = {
:end => 'target',
:offset => [-10, -40],
:time => 60,
:jumpheight => 0,
:rotate => 0,
}
#==============================================================================
# Movement[3] => picture goes to position 300, 200
#==============================================================================
Movement[3] = {
:end => [300, 200],
:offset => [0, 0],
:time => 30,
:jumpheight => 0,
:rotate => 0,
}
#==============================================================================
# Movement[4] => picture goes to position -100, 200
#==============================================================================
Movement[4] = {
:end => [-100, 200],
:offset => [0, 0],
:time => 60,
:jumpheight => 0,
:rotate => 0,
}
end
#==============================================================================
#--------------------------------------------------------------------------
# HERE STARTS THE SCRIPT!!!
#--------------------------------------------------------------------------
#==============================================================================
#==============================================================================
# ** Scene_Battle
#------------------------------------------------------------------------------
#  Esta classe executa o processamento da tela de batalha.
#==============================================================================

class Scene_Battle < Scene_Base
alias :akea_bp_update_basic :update_basic
alias :akea_battlepictures_start :start   
  #--------------------------------------------------------------------------
  # * Inicialização do processo
  #--------------------------------------------------------------------------
  def start
    @akea_bp_pic = Array.new(Akea_BattlePic::Instances)
    @akea_cont_pic = Array.new(Akea_BattlePic::Instances)
    @akea_act_mov = Array.new(Akea_BattlePic::Instances)
    for n in 0...@akea_bp_pic.size
      @akea_bp_pic[n] = Sprite.new
      @akea_cont_pic[n] = Array.new
      @akea_act_mov[n] = Array.new
    end
    akea_battlepictures_start
  end
  #--------------------------------------------------------------------------
  # * atualização basica
  #--------------------------------------------------------------------------
  def update_basic
    update_abp_pictures
    akea_bp_update_basic
  end
  #--------------------------------------------------------------------------
  # * Atualização das imagens
  #--------------------------------------------------------------------------
  def update_abp_pictures
    for n in 0...Akea_BattlePic::Instances
      upt_ind_akea_pictures(n) unless @akea_cont_pic[n].empty?
    end
  end
  #--------------------------------------------------------------------------
  # * Atualização do frame das imagens
  #--------------------------------------------------------------------------
  def update_pic_akea_frame(z)
    if @akea_cont_pic[z][:c_frames] < @akea_cont_pic[z][:frames] 
      @akea_cont_pic[z][:c_frames] += 1
    else
      @akea_cont_pic[z][:c_frames] = 1
    end
    cx = @akea_cont_pic[z][:c_frames] - 1
    @akea_bp_pic[z].src_rect.set(cx * @akea_bp_pic[z].bitmap.width/@akea_cont_pic[z][:frames], 0, @akea_bp_pic[z].bitmap.width/@akea_cont_pic[z][:frames], @akea_bp_pic[z].bitmap.height)
  end
  #--------------------------------------------------------------------------
  # * Atualização d posição das imagens
  #--------------------------------------------------------------------------
  def upt_ind_akea_pictures(n) 
    @akea_act_mov[n][:time] -= 1
    update_pic_akea_frame(n) if @akea_cont_pic[n][:frames] > 1 && Graphics.frame_count % @akea_cont_pic[n][:time] == 0
    @akea_bp_pic[n].x += @akea_cont_pic[n][:move_to][0]
    @akea_bp_pic[n].y += @akea_cont_pic[n][:move_to][1]
    @akea_bp_pic[n].y += get_pic_akea_height(@akea_cont_pic[n][:move_init][0], @akea_cont_pic[n][:move_final][0], @akea_act_mov[n][:jumpheight], @akea_bp_pic[n].x) 
    @akea_bp_pic[n].angle += @akea_act_mov[n][:rotate]
    if @akea_act_mov[n][:time] <= 0
      @akea_act_mov[n] = []
      @akea_cont_pic[n][:movement].shift
      akea_calc_movement(n)
    end
  end
  #--------------------------------------------------------------------------
  # * Processo principal
  #--------------------------------------------------------------------------
  def akea_picture(n)
    z = 0
    z += 1 until @akea_cont_pic[z].empty?
    @akea_cont_pic[z] = Marshal::load(Marshal.dump(Akea_BattlePic::Battle_Pic[n]))
    @akea_bp_pic[z].bitmap.dispose if @akea_bp_pic[z].bitmap
    if Akea_BattlePic::Battle_Pic[n][:picture].is_a?(Integer)
      icon_index = Akea_BattlePic::Battle_Pic[n][:picture]
      @akea_bp_pic[z].bitmap = Cache.system("Iconset")
      @akea_bp_pic[z].src_rect.set(icon_index % 16 * 24, icon_index / 16 * 24, 24, 24)
      @akea_bp_pic[z].ox = 12
      @akea_bp_pic[z].oy = 12
    else
      @akea_bp_pic[z].bitmap = Cache.akea(Akea_BattlePic::Battle_Pic[n][:picture])
      if @akea_cont_pic[z][:frames] > 1
        @akea_bp_pic[z].src_rect.set(0, 0, @akea_bp_pic[z].bitmap.width/@akea_cont_pic[z][:frames], @akea_bp_pic[z].bitmap.height)
      end
      @akea_bp_pic[z].ox =  @akea_bp_pic[z].bitmap.width/(2*@akea_cont_pic[z][:frames])
      @akea_bp_pic[z].oy =  @akea_bp_pic[z].bitmap.height/2
    end
    if @akea_cont_pic[z][:position].is_a?(Array)
      @akea_bp_pic[z].x = @akea_cont_pic[z][:position][0]
      @akea_bp_pic[z].y = @akea_cont_pic[z][:position][1]
    else
      case @akea_cont_pic[z][:position]
      when 'target'
        @akea_bp_pic[z].x = @reuse_targets[0].screen_x
        @akea_bp_pic[z].y = @reuse_targets[0].screen_y
      when 'user'
        @akea_bp_pic[z].x = @subject.screen_x
        @akea_bp_pic[z].y = @subject.screen_y
      end
    end
    @akea_bp_pic[z].x += @akea_cont_pic[z][:offset][0]
    @akea_bp_pic[z].y += @akea_cont_pic[z][:offset][1]
    @akea_bp_pic[z].z = @akea_cont_pic[z][:z_pos]
    @akea_cont_pic[z][:c_frames] = 1
    @akea_bp_pic[z].angle = 0
    akea_calc_movement(z)
  end
  #--------------------------------------------------------------------------
  # * Cálculo da distancia e velocidade do movimento
  #--------------------------------------------------------------------------
  def akea_calc_movement(z)
    if @akea_cont_pic[z][:movement].empty?
      @akea_cont_pic[z] = []
      @akea_bp_pic[z].bitmap.dispose
      return
    else
      @akea_act_mov[z] = Akea_BattlePic::Movement[@akea_cont_pic[z][:movement].first].dup
    end
    x = @akea_bp_pic[z].x
    y = @akea_bp_pic[z].y
    if @akea_act_mov[z][:end].is_a?(Array)
        final_x = @akea_act_mov[z][:end][0]
        final_y = @akea_act_mov[z][:end][1]
      else
      case @akea_act_mov[z][:end]
      when 'target'
        final_x = @reuse_targets[0].screen_x
        final_y = @reuse_targets[0].screen_y
      when 'user'
        final_x = @subject.screen_x
        final_y = @subject.screen_y
      end
    end
    final_x += @akea_act_mov[z][:offset][0]
    final_y += @akea_act_mov[z][:offset][1]
    @akea_cont_pic[z][:move_init] = [x, y]
    @akea_cont_pic[z][:move_final] = [final_x, final_y]
    @akea_cont_pic[z][:move_to] = [(final_x - x)/@akea_act_mov[z][:time], (final_y - y)/@akea_act_mov[z][:time]]
  end
  #--------------------------------------------------------------------------
  # * Cálculo da altura
  #--------------------------------------------------------------------------
  def get_pic_akea_height(initial, final, height , moment)
    if initial > final
      jump_peak = (final - initial)/2
      jump_peak += initial
      pos_x = (jump_peak - moment).to_f / [jump_peak, 1].max
      [height * pos_x, height].min
    else
      jump_peak = (initial - final)/2
      jump_peak += final
      pos_x = (jump_peak - moment).to_f / [jump_peak, 1].max
      pos_x *= -1
      [height * pos_x, height].min
    end
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
  def self.akea(filename)
    load_bitmap("Graphics/Akea/", filename)
  end
end

#==============================================================================
# ** Game_Interpreter
#------------------------------------------------------------------------------
#  Um interpretador para executar os comandos de evento. Esta classe é usada
# internamente pelas classes Game_Map, Game_Troop e Game_Event.
#==============================================================================
class Game_Interpreter
  #--------------------------------------------------------------------------
  # * M[etodo de picture
  #--------------------------------------------------------------------------
  def akea_picture(n)
    SceneManager.scene.akea_picture(n)
  end
end