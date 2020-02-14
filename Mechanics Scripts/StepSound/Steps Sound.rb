#=======================================================
#         Som de passos
# Autor:Raizen884
# Compatibilidade: RMVXAce
# Comunidade : www.centrorpg.com
# Adiciona um som ao se movimentar com o personagem.
#=======================================================
module Som_passos
# Coloque o nome do arquivo de som ao ser tocado,
# caso o som não seja algum padrão do rpg maker,
# basta adicionar o arquivo a pasta SE do seu projeto.
# Coloque aqui os IDs do terreno e seu respectivo
# som naquele terreno.
Sound = []
# Sound[valor da tag de terreno que pode ser configurado no database] = Som
# que tocará quando o personagem pisar nesse terreno.
Sound[0] = "Evasion1"
Sound[1] = "Fog1"
# Caso queira mais sons para mais ids de terreno basta
# adicionar uma linha com o nome do arquivo do mesmo modo
# como está colocado aqui no modulo.
# variavel para modificar os passsos, assim da para modificar o som
# dependendo de uma variavel e não pelo ID do terreno.
# ID da variavel, lembrando que o valor dela, tem que ser o mesmo
# dom ID do Sound. Se a variavel tiver valor 0, desabilita essa função.
# Isso apenas para o personagem.
Variavel = 1
# volume a ser colocado para o som do personagem.
Volume = 100
# Variação do volume, para dar um som mais real aos passos do player.
Var = 20
# Variação da frequencia dos passos, para passos mais realistas
# algumas vezes o som não tocará, 0 desativa essa função.
Freq = 0
# Nome que deverá estar no arquivo dos chars para que o script
# reconheça para tocar o som de passos.
Name = "Actor"
end
# Aqui começa o script.
class Game_Player < Game_Character
alias sound_move move_straight
alias sound_diagonal move_diagonal
  def move_straight(d, turn_ok = true)
    sound_move(d, turn_ok = true)
    freq = rand(Som_passos::Freq) if Som_passos::Freq != 0
    if freq == nil or freq < Som_passos::Freq - 1 and @move_succeed and Som_passos::Sound[$game_player.terrain_tag] != nil and $game_variables[Som_passos::Variavel] == 0
    RPG::SE.new(Som_passos::Sound[$game_player.terrain_tag], @volume = Som_passos::Volume - rand(Som_passos::Var)).play unless vehicle
    elsif $game_variables[Som_passos::Variavel] != 0 and Som_passos::Sound[$game_variables[Som_passos::Variavel]] != nil
    RPG::SE.new(Som_passos::Sound[$game_variables[Som_passos::Variavel]], @volume = Som_passos::Volume - rand(Som_passos::Var)).play unless vehicle
  end
end
    def move_diagonal(horz, vert)
    freq = rand(Som_passos::Freq) if Som_passos::Freq != 0
    if freq == nil or freq < Som_passos::Freq - 1
    sound_diagonal(horz, vert)
    RPG::SE.new(Som_passos::Sound[$game_player.terrain_tag], @volume = Som_passos::Volume - rand(Som_passos::Var)).play if @move_succeed and Som_passos::Sound[$game_player.terrain_tag] != nil
    end
    end
end
class Game_Event < Game_Character
  def update_self_movement
    if near_the_screen? && @stop_count > stop_count_threshold
      case @move_type
      when 1;  move_type_random 
      sound_screen
      when 2;  move_type_toward_player
      sound_screen
      when 3;  move_type_custom
      sound_screen
      end
    end
  end
    def sound_screen
      distx = $game_map.events[@id].x - $game_player.x
      disty = $game_map.events[@id].y - $game_player.y
      distx *= distx
      disty *= disty
      soma = distx + disty
      soma = Som_passos::Volume if soma > Som_passos::Volume
      freq = rand(Som_passos::Freq) if Som_passos::Freq != 0
      if freq == nil or freq < Som_passos::Freq - 1
      RPG::SE.new(Som_passos::Sound[$game_map.events[@id].terrain_tag], @volume = Som_passos::Volume - soma).play if $game_map.events[@id].moving? and $game_map.events[@id].character_name.include?(Som_passos::Name)
      end
   end
end