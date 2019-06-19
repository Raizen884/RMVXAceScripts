#=======================================================
# Autor: Raizen
#         Multiplos frames
# Comunidade : www.centrorpg.com
# Adiciona a função de usar mais do que 3 frames para
# o personagem e os eventos.
#=======================================================
module Frameset
# Quantidade de frames que terá para o personagem e os eventos
# lembrando que o padrão do VXAce é 3.
FRAMES = 3
# Você também pode configurar individualmente cada char
# pelo nome do arquivo, basta colocar no final do nome do arquivo
# [FRn], em que n é o numero de frames daquele char, por exemplo.
# Actor2[FR7].png
end
# Aqui começa o script.
#=======================================================
class Game_CharacterBase
  def update_anime_pattern
    if !@step_anime && @stop_count > 0
      @pattern = @original_pattern
    else
    if @character_name[/\[FR(\d+)\]/i]
      @pattern = (@pattern + 1) % $1.to_i 
    else
      @pattern = (@pattern + 1) % (Frameset::FRAMES + 1)
    end
      end
  end
end
class Sprite_Character < Sprite_Base
  def update_src_rect
    if @tile_id == 0
      index = @character.character_index
      if @character_name[/\[FR(\d+)\]/i]
      pattern = @character.pattern < $1.to_i ? @character.pattern : 1
      else
      pattern = @character.pattern < Frameset::FRAMES ? @character.pattern : 1
    end
    
      sx = (index % 4 * 3 + pattern) * @cw
      sy = (index / 4 * 4 + (@character.direction - 2) / 2) * @ch
      self.src_rect.set(sx, sy, @cw, @ch)
    end
  end
    def set_character_bitmap
    self.bitmap = Cache.character(@character_name)
    sign = @character_name[/^[\!\$]./]
    if sign && sign.include?('$')
      @character_name[/\[FR(\d+)\]/i] ? @cw = bitmap.width / $1.to_i : @cw = bitmap.width / Frameset::FRAMES
      @ch = bitmap.height / 4
    else
      @character_name[/\[FR(\d+)\]/i] ? @cw = bitmap.width / $1.to_i * 4 : @cw = bitmap.width / Frameset::FRAMES * 4
      @cw = bitmap.width / 12
      @ch = bitmap.height / 8
    end
    self.ox = @cw / 2
    self.oy = @ch
  end
end