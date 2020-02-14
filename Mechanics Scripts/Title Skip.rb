#=======================================================
#         Script de Pular Title
# Autor: Raizen
# Comunidade: www.centrorpg.com
# O script fará com que vá direto ao primeiro mapa do jogo,
# útil para criar Titles feitas por eventos.
#=======================================================

class Scene_Title < Scene_Base
  def start
    super
    DataManager.setup_new_game
    $game_map.autoplay
    $game_map.update
    SceneManager.goto(Scene_Map)
  end
  def dispose_background
  end
  def dispose_foreground
  end
end