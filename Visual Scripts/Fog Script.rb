#=======================================================
#         Script de Névoa
# Autor: Raizen
# Comunidade: www.centrorpg.com
# Compativel com: RMVXAce
# O script permite que seja criado uma névoa, a famosa fog
# que pode ser nuvens, folhas, neblina entre outros.
# para ativar a fog, basta 
# Chamar Script:$game_map.change_fog(name, sx, sy, opacidade1, opacidade2,
# taxa)
# em que,
# name = nome do arquivo, colocar entre aspas por exemplo, "Fog", "Névoa3"
# o arquivo de imagem, deve estar dentro de uma pasta com nome
# Fog, dentro da pasta Graphics do seu projeto.
# sx = velocidade do loop em x(0 = sem loop)
# sy = velocidade do loop em y(0 = sem loop)
# opacidade1 = opacidade da névoa inicial. (255 = 100%, 0 = invisivel)
# opacidade2 = opacidade da névoa final. (255 = 100%, 0 = invisivel)
# taxa = o quão rápido acontece a mudança.
# Um exemplo valido de como Chamar o script.
# $game_map.change_fog("Fog", 2, 1, 10, 150, 2)
# para desativar a névoa, basta colocar no lugar do name
# 2 aspas desse modo, "".
# Chamar Script:$game_map.change_fog("", 0, 0, 0, 0, 0)
#=======================================================
# Aqui começa o script
#=======================================================

$fog_opacity = 0
$fog_opacitybegin = 0
module Cache
  def self.fog(filename)
    load_bitmap("Graphics/Fog/", filename)
  end
end

class Spriteset_Map
alias raizenmap_initialize initialize
alias raizenmap_create_viewports create_viewports
alias raizenmap_dispose dispose
alias raizenmap_update update
alias raizenmap_update_viewports update_viewports
  def initialize
    create_fog
    raizenmap_initialize
  end
  def create_viewports
    raizenmap_create_viewports
    @viewport4 = Viewport.new    
  end
  def create_fog
    @fog = Plane.new(@viewport4)
    @fog.z = 100
  end
    def dispose
    raizenmap_dispose
    dispose_fog
  end
  def dispose_fog
    @fog.bitmap.dispose if @fog.bitmap
    @fog.dispose
  end
  def update
  update_fog
  raizenmap_update
  end
  def update_fog
    if @fog.opacity < $fog_opacity and $fog_opacity > $fog_opacitybegin 
    @fog.opacity += $game_fogtime if $game_fogtime != nil
    elsif @fog.opacity > $fog_opacity and $fog_opacity < $fog_opacitybegin
    @fog.opacity -= $game_fogtime if $game_fogtime != nil
    end
    if @fog_name != $game_fog_name
      @fog.opacity = $fog_opacitybegin
      @fog_name = $game_fog_name
      @fog.bitmap.dispose if @fog.bitmap
      @fog.bitmap = Cache.fog(@fog_name) if @fog_name != ""
      Graphics.frame_reset
    end
    if @fog_name != nil and $game_fog_name != ""
    @fog.ox = $game_map.fog_ox(@fog.bitmap) 
    @fog.oy = $game_map.fog_oy(@fog.bitmap)
    end
  end
  def update_viewports
    @viewport4.tone.set($game_map.screen.tone)
    @viewport4.update
    raizenmap_update_viewports
  end
end


class Game_Map
alias raizen_map_setup setup_parallax
alias raizen_map_update update_parallax
  def setup_parallex
    setup_fog
    raizen_map_setup
  end
  def setup_fog
    $game_fog_name = nil
    @fog_loop_x = 0
    @fog_loop_y = 0
    @fog_sx = 0
    @fog_sy = 0
    @fog_x = 0
    @fog_y = 0
  end
  def fog_ox(bitmap)
    if @fog_loop_x
      @fog_x * 16
    else
      w1 = [bitmap.width - Graphics.width, 0].max
      w2 = [width * 32 - Graphics.width, 1].max
      @fog_x * 16 * w1 / w2
    end
  end
  def fog_oy(bitmap)
    if @fog_loop_y
      @fog_y * 16
    else
      if $game_fog_name != ""
      h1 = [bitmap.height - Graphics.height, 0].max
      h2 = [height * 32 - Graphics.height, 1].max
      @fog_y * 16 * h1 / h2
      end
    end
  end

  def update_parallax
    raizen_map_update
    update_fog if @fog_name != ""
  end

  def update_fog
    @fog_x += @fog_sx / 64.0 if @fog_loop_x
    @fog_y += @fog_sy / 64.0 if @fog_loop_y
  end

  def change_fog(name, sx, sy, opacidade1, opacidade2, tempo)
    $game_fog_name = name
    $game_fogtime = tempo
    $fog_opacitybegin = opacidade1
    $fog_opacity = opacidade2
    @fog_x = 0  
    @fog_y = 0 
    sx != 0 ? (@fog_loop_x = true) : @fog_loop_x = false
    sy != 0 ? (@fog_loop_y = true) : @fog_loop_y = false
    @fog_sx = sx
    @fog_sy = sy
  end
end