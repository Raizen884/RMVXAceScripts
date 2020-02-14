#=======================================================
#        Akea Battle Camera
# Author: Raizen
# Community: http://www.centrorpg.com/
# Compatibility: RMVXAce
#
#=======================================================
# =========================Don't Modify==============================
$included ||= Hash.new
$included[:akea_battlecamera] = true
module Akea_BattleCamera
Camera_Config = []
# =========================Don't Modify==============================
# Instruções:
# O sistema de camera permite zoom e movimentação da camera, você pode ajustar
# os alvos e o local que a camera se moverá durante a ação.
# Para realizar a chamada de uma das configurações de camera

# Chamar Script: akea_camera(n), aonde n é o id das configurações logo abaixo.

# Esse chamar script pode ser usado na aba de eventos das tropas, ou
# caso o sistema de batalha que use permita utilizar chamar script.

# Abaixo é configurado o movimento da camera, siga as instruções de cada
# variável para ter o melhor resultado.

#:focus é o local aonde a camera será movida, ela pode ser uma posição absoluta,
# do inimigo, da tela ou do usuário.

# Para posição absoluta é utilizado o seguinte.

# :focus => [x, y, type]
# Aonde x é a quantidade de pixels que vai mover horizontalmente,
# y verticalmente e type o tipo de movimento
# O type tem 2 tipos, 0 => move para a posição exata, 1 => move para a posição
# relativa.

# Por exemplo se eu quero que a camera se mova para a posição exata 300, 200
# eu colocaria [300, 200, 0]

# Se eu quero que se mova 300 pixels para a esquerda e 200 para baixo.
# eu colocaria [300, 200, 1]


# As outras tags para :focus são
# 'none' é que não haverá movimentação de camera
# 'target' a camera centraliza o alvo (SÓ FUNCIONA SE USAR O AKEA ANIMATED BATTLE SYSTEM).
# 'user' a camera centraliza o usuário
# 'center' a camera retorna a posição de origem.

# :zoom_x/:zoom_y é o zoom da camera, sendo que 1 seria 100%, para colocar
# números quebrados, como por exemplo 50% da tela, basta.. :zoom_x => 0.5,
# (lembre-se que é a notação americana, logo é ponto que divide os decimais)

# :time em frames que ocorrera o movimento da camera 
# :time => 20, isso seriam 20 frames 1/3 de segundo

# :offset_x/:offset_y seriam simplesmente caso queira fazer algum ajuste,
# por exemplo escolhi a tag 'user' mas a camera ficou alguns pixels descentralizado
# basta alterar esses valores para achar o melhor posicionamento da camera

#==============================================================================
# Camera_Config[0] => camera move 300 para a esquerda e
# da um zoom de 200%
#==============================================================================
Camera_Config[0] = {
:focus => [-300, 0, 1],
:zoom_x => 2,
:zoom_y => 2,
:time => 20,
:offset_x => 0,
:offset_y => 0,
}
#==============================================================================
# Camera_Config[1] => camera retorna a posição inicial com 
# zooms de 1 e 1
#==============================================================================
Camera_Config[1] = {
:focus => 'center',
:zoom_x => 1,
:zoom_y => 1,
:time => 20,
:offset_x => 0,
:offset_y => 0,
}
#==============================================================================
# Camera_Config[2] => camera vai em direção ao alvo com um leve zoom
#==============================================================================
Camera_Config[2] = {
:focus => 'target',
:zoom_x => 1.2,
:zoom_y => 1.2,
:time => 20,
:offset_x => 0,
:offset_y => 0,
}
#==============================================================================
# Camera_Config[3] => camera apenas da um zoom sem se movimentar
#==============================================================================
Camera_Config[3] = {
:focus => 'none',
:zoom_x => 2,
:zoom_y => 2,
:time => 60,
:offset_x => 0,
:offset_y => 0,
}
#==============================================================================
# Camera_Config[3] => camera vai em direção ao usuário com um zoom de 200%
#==============================================================================
Camera_Config[4] = {
:focus => 'user',
:zoom_x => 2,
:zoom_y => 2,
:time => 20,
:offset_x => 0,
:offset_y => 0,
}
end
#==============================================================================
#==============================================================================
# Aqui começa o script!
#==============================================================================
#==============================================================================
#==============================================================================
# ** Scene_Battle
#------------------------------------------------------------------------------
#  Esta classe executa o processamento da tela de batalha.
#==============================================================================

class Scene_Battle < Scene_Base
alias :akea_bcamera_update_basic :update_basic
alias :akea_bcamera_start :start
  #--------------------------------------------------------------------------
  # * Inicialização do processo
  #--------------------------------------------------------------------------
  def start
    @akea_camera_time = 0
    @akea_camera_config = Hash.new
    akea_bcamera_start
  end
  #--------------------------------------------------------------------------
  # * Atualização das animações de camera
  #--------------------------------------------------------------------------
  def update_akea_camera
    @akea_camera_time -= 1
    time = @akea_camera_config[:time] - @akea_camera_time
    @spriteset.move_camera(@akea_camera_config[:final_x] * time/@akea_camera_config[:time], @akea_camera_config[:final_y] * time/@akea_camera_config[:time])
    @spriteset.make_zoom(@akea_camera_config[:speed_zoom_x], @akea_camera_config[:speed_zoom_y])
    if @akea_camera_time == 0
      @spriteset.set_zoom(@akea_camera_config[:zoom_x], @akea_camera_config[:zoom_y])
    end
  end
  #--------------------------------------------------------------------------
  # * Atualização
  #--------------------------------------------------------------------------
  def update_basic
    akea_bcamera_update_basic
    update_akea_camera if @akea_camera_time > 0
  end
  #--------------------------------------------------------------------------
  # * Método de definição da configuração
  #--------------------------------------------------------------------------
  def akea_camera(n)
    @akea_camera_config = Akea_BattleCamera::Camera_Config[n].dup
    @akea_camera_time = @akea_camera_config[:time]
    get_akea_camera_speed
    get_akea_camera_zoom
  end
  #--------------------------------------------------------------------------
  # * Método que obtém a velocidade da camera
  #--------------------------------------------------------------------------
  def get_akea_camera_speed
    @akea_camera_config[:final_y] = @akea_camera_config[:offset_y] + camera_akea_position_y(@akea_camera_config[:focus])
    @akea_camera_config[:final_x] = @akea_camera_config[:offset_x] + camera_akea_position_x(@akea_camera_config[:focus])
    @spriteset.set_ox_oy_camera
  end
  #--------------------------------------------------------------------------
  # * Método que obtem o zoom da camera
  #--------------------------------------------------------------------------
  def get_akea_camera_zoom
    @akea_camera_config[:speed_zoom_y] = (@akea_camera_config[:zoom_y] - @spriteset.zoom_sprites_y).to_f/@akea_camera_time.to_f
    @akea_camera_config[:speed_zoom_x] = (@akea_camera_config[:zoom_x] - @spriteset.zoom_sprites_x).to_f/@akea_camera_time.to_f
    @spriteset.set_ox_oy_zoom
  end
  #--------------------------------------------------------------------------
  # * Método de verificação da posição y 
  #--------------------------------------------------------------------------
  def camera_akea_position_y(type)
    if type.is_a?(Array)
      if type[2] == 0
        return type[1] - @spriteset.get_viewport1_oy
      else
        return type[1]
      end
    end
    case type
    when 'none'
      return 0
    when 'target'
      return @reuse_targets[0].screen_y - Graphics.height/2 - @spriteset.get_viewport1_ox
    when 'user'
      return @subject.screen_y - Graphics.height/2 - @spriteset.get_viewport1_ox
    when 'center'
      return -@spriteset.get_viewport1_oy
    end
  end
  #--------------------------------------------------------------------------
  # * Método de verificação da posição x 
  #--------------------------------------------------------------------------
  def camera_akea_position_x(type)
    if type.is_a?(Array)
      if type[2] == 0
        return type[0] - @spriteset.get_viewport1_ox
      else
        return type[0]
      end
    end
    case type
    when 'none'
      return 0
    when 'target'
      return @reuse_targets[0].screen_x - Graphics.width/2 - @spriteset.get_viewport1_oy
    when 'user'
      return @subject.screen_x - Graphics.width/2 - @spriteset.get_viewport1_oy
    when 'center'
      return -@spriteset.get_viewport1_ox
    end
  end
  
end



#==============================================================================
# ** Spriteset_Battle
#------------------------------------------------------------------------------
#  Esta classe reune os sprites da tela de batalha. Esta classe é usada 
# internamente pela classe Scene_Battle. 
#==============================================================================

class Spriteset_Battle
alias :akea_bcamera_initialize :initialize
attr_reader :zoom_sprites_x
attr_reader :zoom_sprites_y
  #--------------------------------------------------------------------------
  # * Inicialização do objeto
  #--------------------------------------------------------------------------
  def initialize
    @akea_bcamera_x = 0
    @akea_bcamera_y = 0
    @zoom_sprites_x = 1
    @zoom_sprites_y = 1
    akea_bcamera_initialize
  end
  #--------------------------------------------------------------------------
  # * Método que retem os valores de camera
  #--------------------------------------------------------------------------
  def move_camera(x, y)
    @akea_bcamera_x = x + @viewport_cam_1_ox
    @akea_bcamera_y = y + @viewport_cam_1_oy
  end
  #--------------------------------------------------------------------------
  # * Método que realiza os zooms
  #--------------------------------------------------------------------------
  def make_zoom(x, y)
    @actor_sprites.each{|sprt| sprt.zoom_x += x; sprt.zoom_y += y}
    @enemy_sprites.each{|sprt| sprt.zoom_x += x; sprt.zoom_y += y}
    @back1_sprite.zoom_x += x
    @back1_sprite.zoom_y += y
    @back2_sprite.zoom_x += x
    @back2_sprite.zoom_y += y
    @zoom_sprites_x += x
    @zoom_sprites_y += y
  end
  #--------------------------------------------------------------------------
  # * Método quue seta os valores de zoom(correção de bug)
  #--------------------------------------------------------------------------
  def set_zoom(x, y)
    @actor_sprites.each{|sprt| sprt.zoom_x = x; sprt.zoom_y = y}
    @enemy_sprites.each{|sprt| sprt.zoom_x = x; sprt.zoom_y = y}
    @back1_sprite.zoom_x = x
    @back1_sprite.zoom_y = y
    @back2_sprite.zoom_x = x
    @back2_sprite.zoom_y = y
    @zoom_sprites_x = x
    @zoom_sprites_y = y
  end
  #--------------------------------------------------------------------------
  # * Obtenção do ox do viewport1
  #--------------------------------------------------------------------------
  def get_viewport1_ox
    @viewport1.ox
  end
  #--------------------------------------------------------------------------
  # * Obtenção do oy do viewport1
  #--------------------------------------------------------------------------
  def get_viewport1_oy
    @viewport1.oy
  end
  #--------------------------------------------------------------------------
  # * Setar os valores iniciais de zoom
  #--------------------------------------------------------------------------
  def set_ox_oy_zoom
    @zoom_sprites_x = @back1_sprite.zoom_x
    @zoom_sprites_y = @back1_sprite.zoom_y
  end
  #--------------------------------------------------------------------------
  # * Setar a posção inicial da camera
  #--------------------------------------------------------------------------
  def set_ox_oy_camera
    @viewport_cam_1_ox = @viewport1.ox
    @viewport_cam_1_oy = @viewport1.oy
  end
  #--------------------------------------------------------------------------
  # * Atualização do viewports
  #--------------------------------------------------------------------------
  def update_viewports
    @viewport1.tone.set($game_troop.screen.tone)
    @viewport1.ox = $game_troop.screen.shake
    @viewport1.ox += @akea_bcamera_x
    @viewport1.oy = @akea_bcamera_y
    @viewport2.color.set($game_troop.screen.flash_color)
    @viewport3.color.set(0, 0, 0, 255 - $game_troop.screen.brightness)
    @viewport1.update
    @viewport2.update
    @viewport3.update
  end
end

class Game_Interpreter
  def akea_camera(n)
    SceneManager.scene.akea_camera(n)
  end
end