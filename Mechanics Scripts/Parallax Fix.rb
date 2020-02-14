#===============================================================
# Parallax Fix
# Compativel com RMVXAce
# Autor: Raizen884
# É permitido postar em outros lugares contanto que não seja mudado
# as linhas dos créditos.
# Descrição: Permite fixar o panorama, permitindo assim o mapeamento
# "parallax mapping" e outros usos que seja necessários que o panorama
# não tenha movimento.
#===============================================================


module Raizen_fixp
# O que devera estar contido no nome do arquivo para que o panorama
# seja fixado, graficos sem isso funcionaram como panoramas normalmente.
Fixparallax = "(FIX)"
end

# Aqui começa o script.

class Spriteset_Map
alias update_raizen_parallax update_parallax
  def update_parallax
    update_raizen_parallax
      if @parallax_name.include? (Raizen_fixp::Fixparallax)
      @parallax.ox = $game_map.display_x * 32 
      @parallax.oy = $game_map.display_y * 32 
      end
   end
end