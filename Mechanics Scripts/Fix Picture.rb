#=======================================================
#         Fix Picture
# Autor: Raizen
# Exclusividade da comunidade : www.centrorpg.com
# O script fixa qualquer imagem na posição (0,0) que contém o 
# prefixo (FIX), e assim posibilita ao maker fazer
# iluminações e panomaps com essa imagem fixa.
#=======================================================

class Sprite_Picture < Sprite
alias raizen_picture_update update_position
  def update_position
  @picture.name.include?("(FIX)") ?  update_position_raizen : raizen_picture_update
  end
  def update_position_raizen
    self.x = -$game_map.display_x*32
    self.y = -$game_map.display_y*32
    self.z = @picture.number
  end
end