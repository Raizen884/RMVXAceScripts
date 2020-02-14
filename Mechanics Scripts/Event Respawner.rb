#=======================================================
#         Event Spawner
# Autor: Raizen
# Comunidade: www.centrorpg.com
# Compativel com: RMVXAce
# O script permite que um evento qualquer, apareça em qualquer
# ponto aleatório do mapa.
# O script permite que o evento apareça, ou não em tiles
# apenas passaveis.
# Ele também permite que o evento ao ter "spawn" apareça a uma
# certa distancia do personagem.
# Instruções.


# Basta usar o comando Chamar Script: na terceira aba dos eventos.
# e digitar o seguinte comando.
# event_spawn(check, move, distance, switch)
# aonde move pode ter valor de 0 ou 1.
# 1 = evento irá apenas aparecer em tiles passaveis
# 0 = evento aparecerá em qualquer ponto do mapa.
# O primeiro valor check, verifica se após o evento ser colocado,
# continuará permitindo a passabilidade do personagem e de outros eventos.
# podendo ter o valor de true(verifica), false(não verifica)
# distance representa a distancia que o evento aparecerá do personagem
# switch é a switch local que será desativado ao usar o comando, coloque
# a letra entre aspas.
# Um exemplo de como usar o comando corretamente.

# Chamar Script: event_spawn(true, 1, 4, "A")

# Você também pode deixar sem o switch, caso não queira desativar um
# desse modo.
# Chamar Script: event_spawn(true, 1, 4)

# Você também pode utilizar esse comando em outros eventos, basta no lugar
# do switch colocar o valor do número do evento e não a switch local dele

# Exemplo: Chamar Script: event_spawn(false, 1, 4, 5, "A")
# Nesse exemplo eu dou o spawn no evento de ID 5 do mesmo mapa.
# e desligará o switch Local A daquele evento.
# Pode deixar sem o switch Local desse modo aqui.
# Exemplo: Chamar Script: event_spawn(true, 1, 4, 5)

# Lembrete!: A cada nova condição "verificar passabilidade ou distancia"
# o processamento aumenta um pouco, então teste o melhor modo de usar
# no seu jogo :)

# Aqui começa o script.

#=======================================================



class Game_Interpreter
  def event_spawn(check, move, distance, switch = "", switch2 = "")
  switch.is_a?(Integer) ? event_id = switch : event_id = @event_id
  switch = switch2 unless switch2 == ""
  x = $game_map.width
  y = $game_map.height
  cx = $game_player.x
  cy = $game_player.y
  count = - 1
  while count <= distance
  if move == 1
  x = rand($game_map.width)
  y = rand($game_map.height)
  x - cx >= 0 ? count = x - cx  : count = - x + cx
  y - cy >= 0 ? count2 = y - cy  : count2 = - y + cy
  count = count2 if count2 >= count
  count = - 1 unless $game_map.check_passage(x, y, 0x0f)
  else
  x = rand($game_map.width)
  y = rand($game_map.height)
  x - cx >= 0 ? count = x - cx  : count = - x + cx
  y - cy >= 0 ? count2 = y - cy  : count2 = - y + cy
  count = count2 if count2 >= count 
  end
  if check
  count = - 1 if $game_map.spawner_passable(x, y)
  end
  end
    $game_map.events[event_id].moveto(x,y)
    $game_self_switches[[@map_id, event_id, switch]] = false unless switch == ""
    return
  end
end

class Game_Map
  def spawner_passable(x, y)
  return false if check_passage(x - 1,y , 0x0f) and check_passage(x ,y -1, 0x0f) and check_passage(x - 1,y -1, 0x0f)
  return false if check_passage(x + 1,y , 0x0f) and check_passage(x ,y -1, 0x0f) and check_passage(x + 1,y -1, 0x0f)
  return false if check_passage(x - 1,y , 0x0f) and check_passage(x ,y +1, 0x0f) and check_passage(x - 1,y +1, 0x0f)
  return false if check_passage(x + 1,y , 0x0f) and check_passage(x ,y +1, 0x0f) and check_passage(x + 1,y +1, 0x0f)
  return true
  end
end