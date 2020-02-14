#=======================================================
#        Akea Animated Battle System
# Autor: Raizen
# Comunidade: http://www.centrorpg.com/
# Compatibilidade: RMVXAce
# Demo Download: http://www.mediafire.com/download/nkdm6eau7576iel/Akea+Ultimate+Battle+Engine.exe
# Update Log: http://pastebin.com/Ex1erFFr

#=======================================================

# =========================Não modificar==============================
$imported ||= Hash.new
$imported[:lune_animated_battle] = ['akea_version:1.1']
module Lune_Anime_Battle
Battle_Poses = []
Battle_Position = []
Actions = []
Actor = []
Enemy = []
Enemy_Poses = []
Conditions = []
Script_Call = []
Actor_Conditions = Array.new(load_data("Data/Actors.rvdata2").size)
Enemy_Conditions = Array.new(load_data("Data/Enemies.rvdata2").size)
for n in 0...load_data("Data/Actors.rvdata2").size
  Actor_Conditions[n] = Array.new
end
for n in 0...load_data("Data/Enemies.rvdata2").size
  Enemy_Conditions[n] = Array.new
end
# =========================Não modificar==============================

# Configuração começa Aqui



#=======================================================
#        INSTRUÇÕES
# Boa parte da configuração é feita aqui e nas notes do banco de dados
# Para cada skill ou item você pode adicionar o seguinte.


#<castskill n>

# castskill faz com que uma animação de batalha ocorra no usuário,
# útil para invocação de magias,
# basta trocar o n pelo id da animação de batalha

#<animation n>

# animation faz com que uma animação de batalha ocorra no alvo,
# útil para que tenha várias animações de batalha em um mesmo inimigo,
# ou aliado para magias de cura
# basta trocar o n pelo id da animação de batalha

# <playmovie name>

# animação de filme, utilize essa tag como a animation, no lugar de name
# basta colocar o nome do video que está na pasta Movie do seu projeto


#<movement n>

# animação do battler, essa animação é pré-configurada a seguir no script
# na parte Actions, basta colocar no lugar do n, o id desse Action

#<move_hit n>

# mesma função que o movement, porém para esse caso funciona no inimigo
# ao invés do personagem.

#<wait_for n>
# Função que permite que o personagem espere por n frames

#<wait_tar n>
# Mesmo que o acima, porém para alvos

#<make_hit n>

# essa função permite que você realize dano durante um movimento, assim é 
# possível realizar vários danos em um mesmo ataque, aonde n
# é a porcentagem do valor total. Por exemplo <make_hit 10>
# causaria 10% de dano do valor total da skill.

#<scriptcall n>
# Essa função permite uma chamada de script durante a batalha, configure
# abaixo os scriptcalls necessários e coloque a notetag no skill.
# script calls dentro de aspas ''
Script_Call[0] = 'akea_camera(0)'
Script_Call[1] = 'akea_camera(1)'
Script_Call[2] = 'akea_camera(2)'
Script_Call[3] = 'p "camera"'
# Se esse dano extra deve ser exibido no log de mensagens da batalha
# false é ideal se utilizar algum script que exibe o dano realizado.
Show_On_Log = true
# Isso é adicionado nas notetags no BD, pode ser adicionado para skills,
# ou para armas no caso do ataque comum, o ataque comum por padrão
# puxa as animações das armas.

#=======================================================




# Correção da posição de ataque do personagem
# por exemplo, se o offset_X é 50, ele atacará 
# 50 pixels a partir do centro do alvo.
Offset_X = 50 # Em X
Offset_Y = 5 # Em Y

# Correção da posição de ataque do inimigo
# por exemplo, se o offset_X é 50, ele atacará 
# 50 pixels a partir do centro do alvo.
E_Offset_X = -50
E_Offset_Y = 5


# Folhas de Sprites, use uma por personagem,
# Se houver mais, basta colocar todos os sprites em uma imagem apenas
# e configurar como é pedido abaixo.
# Nome das imagens, deve estar na pasta Graphics/Battlers
# Battle_Poses[n] = 'Nome da Imagem'
Battle_Poses[1] = 'Alex'
Battle_Poses[2] = 'Brenda'
Battle_Poses[3] = 'Safira2'
Battle_Poses[4] = 'Monk'


# Folhas de Sprites, use uma por inimigo,
# Configure exatamente como acima, caso não tenha, basta
# não adicionar o id do inimigo que será utilizado o modo padrão
Enemy_Poses[8] = 'scorpion2'
Enemy_Poses[31] = 'ifrito'
Enemy_Poses[32] = 'bafomet'
# Configuração padrão para a folha de personagens
# Actor[n] = {
Actor[1] = {
'Frames' => 4, # Quantidade máxima de frames
'Positions' => 14, # Quantidade máxima de posições
}
Actor[2] = {
'Frames' => 4, # Quantidade máxima de frames
'Positions' => 14, # Quantidade máxima de posições
}
Actor[3] = {
'Frames' => 4, # Quantidade máxima de frames
'Positions' => 32, # Quantidade máxima de posições
}
Actor[4] = {
'Frames' => 4, # Quantidade máxima de frames
'Positions' => 32, # Quantidade máxima de posições
}
# Com os inimigos, mesma coisa que os personagens
Enemy[8] = {
'Frames' => 4, # Quantidade máxima de frames
'Positions' => 14, # Quantidade máxima de posições
}
Enemy[31] = {
'Frames' => 4, # Quantidade máxima de frames
'Positions' => 14, # Quantidade máxima de posições
}
Enemy[32] = {
'Frames' => 4, # Quantidade máxima de frames
'Positions' => 32, # Quantidade máxima de posições
}

# Posição dos personagens na batalha, se usar mais que 4 personagens,
# basta adicionar novas linhas seguindo o abaixo.
# Battle_Position[n] = [pos em x, pos em y]
Battle_Position[0] = [400, 170]
Battle_Position[1] = [460, 205]
Battle_Position[2] = [400, 240]
Battle_Position[3] = [460, 275]

# Offset da posição inicial, para a entrada da batalha, caso ache necessário
# Se não quiser entrada especial na batalha basta Start_off = [0, 0, 0]
# Start_off = [offset em x, offset em y, numero da ação]
# A ação pode ser configurada logo abaixo no script

Start_off = [250, 0, 7]

# Animações de inicio, as animações são adicionadas no bloco de notas 
# dos personagens assim como é feito nos itens e habilidades
# Todos os personagens fazem animação do inicio de batalha 
# ou apenas um aleatório?
# true para todos, false para apenas um
Start_all = false

# Configuração de animação padrão
Standard = {
# Aqui será colocado a condição do personagem, basta colocar o valor do lado
# de acordo com as conditions pré-configuradas abaixo.
'Stand' => 1, # padrão, quando o personagem está parado
'Damage' => 2, # Ao ser acertado
'Weak' => 3, # Quando o personagem está com HP baixo
'Dead' => 4, # Quando está caido
'Victory' => 5, # Ao vencer a batalha
'Escape' => 7, # Fugindo de uma batalha
}

# HP necessário para entrar no modo "Weak" em porcentagem
Hp = 30
#==============================================================================
#------------------------------------------------------------------------------
# Conditions - Aqui são definidas as condições dos personagens
# Podem ser adicionadas quantas desejar.
# Todos seguem o mesmo padrão
# [linha do "spritesheet", velocidade, numero de frames, loop, mirror, tempo, turnos]
# velocidade, quanto menor mais rápido
# numero de frames, a quantidade de frames que tem para essa pose
# loops tipo de loop (0 = sem loop, 1 = loop continuo, 2 = looping (vai-e-vem))
# mirror, se a sprite é espelhada (true ou false)
# tempo, tempo que fará o movimento
# turnos, número de turnos com o movimento

# Para adicionar em uma skill, basta <condition n>
# na notetag da skill ou do item no Banco de Dados.

# Condições padrões, serve para todos os personagens que não tiverem
# condições especificas
#------------------------------------------------------------------------------
#==============================================================================
#==============================================================================
# Conditions[1] => Stand Condition
#==============================================================================
Conditions[1] = [0, 10, 4, 2, false]

#==============================================================================
# Conditions[2] => Damage Condition
#==============================================================================
Conditions[2] = [3, 10, 4, 0, false, 30]

#==============================================================================
# Conditions[3] => Weak Condition
#==============================================================================
Conditions[3] = [2, 15, 4, 2, false, 30]

#==============================================================================
# Conditions[4] => Dead Condition
#==============================================================================
Conditions[4] = [12, 15, 4, 0, false, 30]

#==============================================================================
# Conditions[5] => Victory Condition
#==============================================================================
Conditions[5] = [7, 10, 4, 2, false, 30]

#==============================================================================
# Conditions[6] => Defense Condition
#==============================================================================
Conditions[6] = [1, 10, 4, 0, false, 30, 2]

#==============================================================================
# Conditions[6] => Escape Condition
#==============================================================================
Conditions[7] = [8, 10, 4, 1, true, 30, 2]


# Condições para personagens especificos, para personagens
# Actor_Conditions[id_do_personagem][............... Seguindo o mesmo padrão de cima
# Para inimigos Enemy_Conditions[id_do_inimigo][....................

#==============================================================================
# Conditions[1] => Stand Condition - Personagem 1
#==============================================================================
Actor_Conditions[2][1] = [0, 10, 4, 2, false]

#==============================================================================
# Conditions[1] => Stand Condition - Inimigo 1
#==============================================================================
Enemy_Conditions[1][1] = [0, 10, 5, 2, false]

#==============================================================================
#------------------------------------------------------------------------------
# Actions - Aqui são definidas as animações dos personagens
# Podem ser adicionadas quantas desejar.
#------------------------------------------------------------------------------
#==============================================================================

#==============================================================================
#------------------------------------------------------------------------------
# Poses de movimentação(1-20) - Para fins de organização
#------------------------------------------------------------------------------
#==============================================================================


#==============================================================================
# Actions[1] => ir em direção ao alvo
#==============================================================================
Actions[1] = {
'Movement' => 'enemy', # 'enemy' ou [x, y] deslocamento em x e y
'Jump_Height' => 30, # Altura do pulo(se não houver, => 0)
'Time' => 25, # em frames
'Speed' => 2, # tempo que leva para troca de frame
'Frame' => 8, # posição na folha de sprites
'Frames' => 4, # Quantidade máxima de frames dessa ação
'Looping' => 1, # Se a animação tem loop
'Mirror' => false, # Se é espelhado
}
#==============================================================================
# Actions[2] => retornar a posição inicial
#==============================================================================
Actions[2] = {
'Movement' => 'return', # 'enemy' ou [x, y] deslocamento em x e y
'Jump_Height' => 30, # Altura do pulo(se não houver, => 0)
'Time' => 15, # em frames
'Speed' => 2, # tempo que leva para troca de frame
'Frame' => 8, # posição na folha de sprites
'Frames' => 4, # Quantidade máxima de frames dessa ação
'Looping' => 1, # Se a animação tem loop
'Mirror' => true, # Se é espelhado
}
#==============================================================================
# Actions[3] => deslocamento para a esquerda
#==============================================================================
Actions[3] = {
'Movement' => [-100, 0], # 'enemy' ou [x, y] deslocamento em x e y
'Jump_Height' => 0, # Altura do pulo(se não houver, => 0)
'Time' => 5, # em frames
'Speed' => 10, # tempo que leva para troca de frame
'Frame' => 8, # posição na folha de sprites
'Frames' => 4, # Quantidade máxima de frames dessa ação
'Looping' => 1, # Se a animação tem loop
'Mirror' => false, # Se é espelhado
}

#==============================================================================
# Actions[4] => deslocamento para a esquerda(menor)
#==============================================================================
Actions[4] = {
'Movement' => [-30, 0], # 'enemy' ou [x, y] deslocamento em x e y
'Jump_Height' => 0, # Altura do pulo(se não houver, => 0)
'Time' => 10, # em frames
'Speed' => 5, # tempo que leva para troca de frame
'Frame' => 9, # posição na folha de sprites
'Frames' => 4, # Quantidade máxima de frames dessa ação
'Looping' => false, # Se a animação tem loop
'Mirror' => false, # Se é espelhado
}
#==============================================================================
# Actions[5] => deslocamento para a direita
#==============================================================================
Actions[5] = {
'Movement' => [100, 0], # 'enemy' ou [x, y] deslocamento em x e y
'Jump_Height' => 0, # Altura do pulo(se não houver, => 0)
'Time' => 5, # em frames
'Speed' => 10, # tempo que leva para troca de frame
'Frame' => 8, # posição na folha de sprites
'Frames' => 4, # Quantidade máxima de frames dessa ação
'Looping' => 1, # Se a animação tem loop
'Mirror' => true, # Se é espelhado
}
#==============================================================================
# Actions[6] => deslocamento para a direita(menor)
#==============================================================================
Actions[6] = {
'Movement' => [30, 0], # 'enemy' ou [x, y] deslocamento em x e y
'Jump_Height' => 0, # Altura do pulo(se não houver, => 0)
'Time' => 10, # em frames
'Speed' => 5, # tempo que leva para troca de frame
'Frame' => 8, # posição na folha de sprites
'Frames' => 4, # Quantidade máxima de frames dessa ação
'Looping' => 1, # Se a animação tem loop
'Mirror' => false, # Se é espelhado
}

#==============================================================================
# Actions[7] => vai em direção ao posição inicial
#==============================================================================
Actions[7] = {
'Movement' => 'return', # 'enemy' ou [x, y] deslocamento em x e y
'Jump_Height' => 0, # Altura do pulo(se não houver, => 0)
'Time' => 40, # em frames
'Speed' => 2, # tempo que leva para troca de frame
'Frame' => 9, # posição na folha de sprites
'Frames' => 4, # Quantidade máxima de frames dessa ação
'Looping' => 0, # Se a animação tem loop
'Mirror' => false, # Se é espelhado
}
#==============================================================================
# Actions[8] => retornar a posição inicial 2 (sem mirror)
#==============================================================================
Actions[8] = {
'Movement' => 'return', # 'enemy' ou [x, y] deslocamento em x e y
'Jump_Height' => 0, # Altura do pulo(se não houver, => 0)
'Time' => 15, # em frames
'Speed' => 2, # tempo que leva para troca de frame
'Frame' => 8, # posição na folha de sprites
'Frames' => 4, # Quantidade máxima de frames dessa ação
'Looping' => 1, # Se a animação tem loop
'Mirror' => false, # Se é espelhado
}
#==============================================================================
# Actions[9] => deslocamento para a direita(levando dano)
#==============================================================================
Actions[9] = {
'Movement' => [20, 0], # 'enemy' ou [x, y] deslocamento em x e y
'Jump_Height' => 0, # Altura do pulo(se não houver, => 0)
'Time' => 10, # em frames
'Speed' => 5, # tempo que leva para troca de frame
'Frame' => 3, # posição na folha de sprites
'Frames' => 4, # Quantidade máxima de frames dessa ação
'Looping' => 1, # Tipo de loop: 0 - sem loop, 1 loop básico, 2 loop circular(vai-e-vem)
'Mirror' => false, # Se é espelhado
}
#==============================================================================
# Actions[10] => retornar a posição inicial (devagar)
#==============================================================================
Actions[10] = {
'Movement' => 'return', # 'enemy' ou [x, y] deslocamento em x e y
'Jump_Height' => 0, # Altura do pulo(se não houver, => 0)
'Time' => 16, # em frames
'Speed' => 8, # tempo que leva para troca de frame
'Frame' => 8, # posição na folha de sprites
'Frames' => 4, # Quantidade máxima de frames dessa ação
'Looping' => 1, # Tipo de loop: 0 - sem loop, 1 loop básico, 2 loop circular(vai-e-vem)
'Mirror' => true, # Se é espelhado
}

#==============================================================================
# Actions[11] => deslocamento para cima(levando dano)
#==============================================================================
Actions[11] = {
'Movement' => [0, -100], # 'enemy' ou [x, y] deslocamento em x e y
'Jump_Height' => 0, # Altura do pulo(se não houver, => 0)
'Time' => 10, # em frames
'Speed' => 5, # tempo que leva para troca de frame
'Frame' => 3, # posição na folha de sprites
'Frames' => 4, # Quantidade máxima de frames dessa ação
'Looping' => 1, # Tipo de loop: 0 - sem loop, 1 loop básico, 2 loop circular(vai-e-vem)
'Mirror' => false, # Se é espelhado
}

#==============================================================================
# Actions[12] => deslocamento para cima(pulando)
#==============================================================================
Actions[12] = {
'Movement' => [0, -60], # 'enemy' ou [x, y] deslocamento em x e y
'Jump_Height' => 0, # Altura do pulo(se não houver, => 0)
'Time' => 10, # em frames
'Speed' => 5, # tempo que leva para troca de frame
'Frame' => 9, # posição na folha de sprites
'Frames' => 4, # Quantidade máxima de frames dessa ação
'Looping' => 1, # Tipo de loop: 0 - sem loop, 1 loop básico, 2 loop circular(vai-e-vem)
'Mirror' => false, # Se é espelhado
}
#==============================================================================
# Actions[13] => deslocamento para baixo(pulando)
#==============================================================================
Actions[13] = {
'Movement' => [0, 60], # 'enemy' ou [x, y] deslocamento em x e y
'Jump_Height' => 0, # Altura do pulo(se não houver, => 0)
'Time' => 10, # em frames
'Speed' => 5, # tempo que leva para troca de frame
'Frame' => 9, # posição na folha de sprites
'Frames' => 4, # Quantidade máxima de frames dessa ação
'Looping' => 1, # Tipo de loop: 0 - sem loop, 1 loop básico, 2 loop circular(vai-e-vem)
'Mirror' => false, # Se é espelhado
}
#==============================================================================
# Actions[14] => deslocamento para direita(pulando)
#==============================================================================
Actions[14] = {
'Movement' => [30, 0], # 'enemy' ou [x, y] deslocamento em x e y
'Jump_Height' => 0, # Altura do pulo(se não houver, => 0)
'Time' => 10, # em frames
'Speed' => 5, # tempo que leva para troca de frame
'Frame' => 9, # posição na folha de sprites
'Frames' => 4, # Quantidade máxima de frames dessa ação
'Looping' => 1, # Tipo de loop: 0 - sem loop, 1 loop básico, 2 loop circular(vai-e-vem)
'Mirror' => false, # Se é espelhado
}
#==============================================================================
# Actions[15] => deslocamento para baixo(levando dano)
#==============================================================================
Actions[15] = {
'Movement' => [0, 30], # 'enemy' ou [x, y] deslocamento em x e y
'Jump_Height' => 0, # Altura do pulo(se não houver, => 0)
'Time' => 10, # em frames
'Speed' => 5, # tempo que leva para troca de frame
'Frame' => 3, # posição na folha de sprites
'Frames' => 4, # Quantidade máxima de frames dessa ação
'Looping' => 1, # Tipo de loop: 0 - sem loop, 1 loop básico, 2 loop circular(vai-e-vem)
'Mirror' => false, # Se é espelhado
}
#==============================================================================
#------------------------------------------------------------------------------
# Poses estáticas(21-40) - Para fins de organização
#------------------------------------------------------------------------------
#==============================================================================

#==============================================================================
# Actions[21] => animação de inicio de batalha
#==============================================================================
Actions[21] = {
'Movement' => [0, 0], # 'enemy' ou [x, y] deslocamento em x e y
'Jump_Height' => 0, # Altura do pulo(se não houver, => 0)
'Time' => 40, # em frames
'Speed' => 10, # tempo que leva para troca de frame
'Frame' => 7, # posição na folha de sprites
'Frames' => 4, # Quantidade máxima de frames dessa ação
'Looping' => 0, # Tipo de loop: 0 - sem loop, 1 loop básico, 2 loop circular(vai-e-vem)
'Mirror' => false, # Se é espelhado
}
#==============================================================================
# Actions[22] => invocação de habilidade
#==============================================================================
Actions[22] = {
'Movement' => [0, 0], # 'enemy' ou [x, y] deslocamento em x e y
'Jump_Height' => 0, # Altura do pulo(se não houver, => 0)
'Time' => 15, # em frames
'Speed' => 5, # tempo que leva para troca de frame
'Frame' => 10, # posição na folha de sprites
'Frames' => 4, # Quantidade máxima de frames dessa ação
'Looping' => 0, # Tipo de loop: 0 - sem loop, 1 loop básico, 2 loop circular(vai-e-vem)
'Mirror' => false, # Se é espelhado
}
#==============================================================================
# Actions[23] => movimento de defesa
#==============================================================================
Actions[23] = {
'Movement' => [0, 0], # 'enemy' ou [x, y] deslocamento em x e y
'Jump_Height' => 0, # Altura do pulo(se não houver, => 0)
'Time' => 30, # em frames
'Speed' => 10, # tempo que leva para troca de frame
'Frame' => 1, # posição na folha de sprites
'Frames' => 4, # Quantidade máxima de frames dessa ação
'Looping' => 0, # Tipo de loop: 0 - sem loop, 1 loop básico, 2 loop circular(vai-e-vem)
'Mirror' => false, # Se é espelhado
}
#==============================================================================
# Actions[24] => tomando dano
#==============================================================================
Actions[24] = {
'Movement' => [0, 0], # 'enemy' ou [x, y] deslocamento em x e y
'Jump_Height' => 0, # Altura do pulo(se não houver, => 0)
'Time' => 40, # em frames
'Speed' => 10, # tempo que leva para troca de frame
'Frame' => 3, # posição na folha de sprites
'Frames' => 4, # Quantidade máxima de frames dessa ação
'Looping' => 0, # Tipo de loop: 0 - sem loop, 1 loop básico, 2 loop circular(vai-e-vem)
'Mirror' => false, # Se é espelhado
}
#==============================================================================
# Actions[25] => animação de inicio de batalha
#==============================================================================
Actions[25] = {
'Movement' => [0, 0], # 'enemy' ou [x, y] deslocamento em x e y
'Jump_Height' => 0, # Altura do pulo(se não houver, => 0)
'Time' => 40, # em frames
'Speed' => 10, # tempo que leva para troca de frame
'Frame' => 0, # posição na folha de sprites
'Frames' => 4, # Quantidade máxima de frames dessa ação
'Looping' => 0, # Tipo de loop: 0 - sem loop, 1 loop básico, 2 loop circular(vai-e-vem)
'Mirror' => false, # Se é espelhado
}
#==============================================================================
# Actions[26] => animação de inicio de batalha
#==============================================================================
Actions[26] = {
'Movement' => [0, 0], # 'enemy' ou [x, y] deslocamento em x e y
'Jump_Height' => 0, # Altura do pulo(se não houver, => 0)
'Time' => 15, # em frames
'Speed' => 5, # tempo que leva para troca de frame
'Frame' => 0, # posição na folha de sprites
'Frames' => 4, # Quantidade máxima de frames dessa ação
'Looping' => 0, # Tipo de loop: 0 - sem loop, 1 loop básico, 2 loop circular(vai-e-vem)
'Mirror' => false, # Se é espelhado
}
#==============================================================================
#------------------------------------------------------------------------------
# Poses de ataque(41-em diante) - Para fins de organização
#------------------------------------------------------------------------------
#==============================================================================

#==============================================================================
# Actions[41] => movimento de ataque 1
#==============================================================================
Actions[41] = {
'Movement' => [0, 0], # 'enemy' ou [x, y] deslocamento em x e y
'Jump_Height' => 0, # Altura do pulo(se não houver, => 0)
'Time' => 22, # em frames
'Speed' => 3, # tempo que leva para troca de frame
'Frame' => 4, # posição na folha de sprites
'Frames' => 4, # Quantidade máxima de frames dessa ação
'Looping' => 0, # Tipo de loop: 0 - sem loop, 1 loop básico, 2 loop circular(vai-e-vem)
'Mirror' => false, # Se é espelhado
}
#==============================================================================
# Actions[42] => movimento de ataque 1 (espelhado)
#==============================================================================
Actions[42] = {
'Movement' => [0, 0], # 'enemy' ou [x, y] deslocamento em x e y
'Jump_Height' => 0, # Altura do pulo(se não houver, => 0)
'Time' => 12, # em frames
'Speed' => 3, # tempo que leva para troca de frame
'Frame' => 4, # posição na folha de sprites
'Frames' => 4, # Quantidade máxima de frames dessa ação
'Looping' => 0, # Tipo de loop: 0 - sem loop, 1 loop básico, 2 loop circular(vai-e-vem)
'Mirror' => true, # Se é espelhado
}

#==============================================================================
# Actions[43] => movimento de ataque 2
#==============================================================================
Actions[43] = {
'Movement' => [0, 0], # 'enemy' ou [x, y] deslocamento em x e y
'Jump_Height' => 0, # Altura do pulo(se não houver, => 0)
'Time' => 12, # em frames
'Speed' => 3, # tempo que leva para troca de frame
'Frame' => 5, # posição na folha de sprites
'Frames' => 4, # Quantidade máxima de frames dessa ação
'Looping' => 0, # Tipo de loop: 0 - sem loop, 1 loop básico, 2 loop circular(vai-e-vem)
'Mirror' => false, # Se é espelhado
}
#==============================================================================
# Actions[44] => movimento de ataque 2 (espelhado)
#==============================================================================
Actions[44] = {
'Movement' => [0, 0], # 'enemy' ou [x, y] deslocamento em x e y
'Jump_Height' => 0, # Altura do pulo(se não houver, => 0)
'Time' => 12, # em frames
'Speed' => 3, # tempo que leva para troca de frame
'Frame' => 5, # posição na folha de sprites
'Frames' => 4, # Quantidade máxima de frames dessa ação
'Looping' => 0, # Tipo de loop: 0 - sem loop, 1 loop básico, 2 loop circular(vai-e-vem)
'Mirror' => true, # Se é espelhado
}
#==============================================================================
# Actions[45] => movimento de ataque 3
#==============================================================================
Actions[45] = {
'Movement' => [0, 0], # 'enemy' ou [x, y] deslocamento em x e y
'Jump_Height' => 0, # Altura do pulo(se não houver, => 0)
'Time' => 12, # em frames
'Speed' => 3, # tempo que leva para troca de frame
'Frame' => 6, # posição na folha de sprites
'Frames' => 4, # Quantidade máxima de frames dessa ação
'Looping' => 0, # Tipo de loop: 0 - sem loop, 1 loop básico, 2 loop circular(vai-e-vem)
'Mirror' => false, # Se é espelhado
}
#==============================================================================
# Actions[46] => movimento de ataque 3 (espelhado)
#==============================================================================
Actions[46] = {
'Movement' => [0, 0], # 'enemy' ou [x, y] deslocamento em x e y
'Jump_Height' => 0, # Altura do pulo(se não houver, => 0)
'Time' => 12, # em frames
'Speed' => 3, # tempo que leva para troca de frame
'Frame' => 6, # posição na folha de sprites
'Frames' => 4, # Quantidade máxima de frames dessa ação
'Looping' => 0, # Tipo de loop: 0 - sem loop, 1 loop básico, 2 loop circular(vai-e-vem)
'Mirror' => true, # Se é espelhado
}
#==============================================================================
# Actions[47] => movimento de ataque 4
#==============================================================================
Actions[47] = {
'Movement' => [0, 0], # 'enemy' ou [x, y] deslocamento em x e y
'Jump_Height' => 0, # Altura do pulo(se não houver, => 0)
'Time' => 12, # em frames
'Speed' => 3, # tempo que leva para troca de frame
'Frame' => 13, # posição na folha de sprites
'Frames' => 4, # Quantidade máxima de frames dessa ação
'Looping' => 0, # Tipo de loop: 0 - sem loop, 1 loop básico, 2 loop circular(vai-e-vem)
'Mirror' => false, # Se é espelhado
}
#==============================================================================
# Actions[48] => movimento de ataque 5(no ar)
#==============================================================================
Actions[48] = {
'Movement' => [0, 0], # 'enemy' ou [x, y] deslocamento em x e y
'Jump_Height' => 0, # Altura do pulo(se não houver, => 0)
'Time' => 12, # em frames
'Speed' => 3, # tempo que leva para troca de frame
'Frame' => 16, # posição na folha de sprites
'Frames' => 4, # Quantidade máxima de frames dessa ação
'Looping' => 0, # Tipo de loop: 0 - sem loop, 1 loop básico, 2 loop circular(vai-e-vem)
'Mirror' => false, # Se é espelhado
}
#==============================================================================
# A PARTIR DAQUI COMEÇA O SCRIPT
#==============================================================================

end
#==============================================================================
# ** Scene_Battle
#------------------------------------------------------------------------------
#  Esta classe executa o processamento da tela de batalha.
#==============================================================================

class Scene_Battle < Scene_Base
alias :lune_anime_update :update
alias :lune_anime_start :start
alias :lune_anime_process_action :process_action
alias :lune_anime_execute_action :execute_action
alias :lune_anime_turn_end :turn_end
  #--------------------------------------------------------------------------
  # * Fase inicial
  #--------------------------------------------------------------------------
  def start(*args, &block)
    @start_battler_positions = Array.new
    $akea_hit_porcentage = 0
    for n in 0...$game_party.battle_members.size
      $game_party.battle_members[n].update_current_condition(0)
      $game_party.battle_members[n].screen_y = Lune_Anime_Battle::Battle_Position[n][1]
      $game_party.battle_members[n].screen_x = Lune_Anime_Battle::Battle_Position[n][0]
      @start_battler_positions << [all_battle_members[n].screen_x, all_battle_members[n].screen_y]
      $game_party.battle_members[n].screen_y += Lune_Anime_Battle::Start_off[1]
      $game_party.battle_members[n].screen_x += Lune_Anime_Battle::Start_off[0]
    end
	for n in 0...$game_troop.members.size
    $game_troop.members[n].update_current_condition(0)
		@start_battler_positions << [$game_troop.members[n].screen_x, $game_troop.members[n].screen_y]
    if Lune_Anime_Battle::Enemy[$game_troop.members[n].enemy_id]
      $game_troop.members[n].screen_x -= Lune_Anime_Battle::Start_off[0]
      $game_troop.members[n].screen_y -= Lune_Anime_Battle::Start_off[1]
    end
	end
    all_battle_members.each{|member| member.insert_actions}
    lune_anime_start(*args, &block)
    move_initial_battlers
  end
  #--------------------------------------------------------------------------
  # * Processamento pós-inicio
  #--------------------------------------------------------------------------
  def post_start
    super
    battle_start if @poss_start
  end
  #--------------------------------------------------------------------------
  # * Movimento inicial dos battlers
  #--------------------------------------------------------------------------
  def move_initial_battlers
    return if Lune_Anime_Battle::Start_off[2] == 0
    for n in 0...$game_party.battle_members.size
      insert_battle_commands(Lune_Anime_Battle::Start_off[2], $game_party.battle_members[n])
    end
    for n in 0...$game_troop.members.size
      if Lune_Anime_Battle::Enemy[$game_troop.members[n].enemy_id]
        insert_battle_commands(Lune_Anime_Battle::Start_off[2], $game_troop.members[n])
      end
    end
    @poss_start = false
    post_start
    @poss_start = true
    looping_basic_animations
    if Lune_Anime_Battle::Start_all
      for n in 0...$game_party.battle_members.size
        insert_start_commands_anime($game_party.battle_members[n])
        looping_basic_animations
      end
    else
      @random_anim = rand($game_party.battle_members.size)
      insert_start_commands_anime($game_party.battle_members[@random_anim])
      looping_basic_animations
    end
  end
  #--------------------------------------------------------------------------
  # * Animações iniciais dos battlers
  #--------------------------------------------------------------------------
  def looping_basic_animations
    loop do
      move_battlers_start 
      Graphics.update
      @spriteset.update
      break if all_battle_members.count{|battler| battler.battle_actions.empty?} == all_battle_members.size 
    end
  end
  #--------------------------------------------------------------------------
  # * Movimento inicial dos battlers
  #--------------------------------------------------------------------------
  def move_battlers_start
    move_battlers 
    go_to_next_command = false
    for n in 0...all_battle_members.size
      unless all_battle_members[n].battle_actions.empty?
        all_battle_members[n].decrease_timer
        go_to_next_command = true
        if all_battle_members[n].battle_actions.first.size == 7
          show_normal_animation(all_battle_members[n].battle_actions.first[0], all_battle_members[n].battle_actions.first[1])
          all_battle_members[n].remove_actions
          return
        end
        if all_battle_members[n].battle_actions.first[2] <= 0
          if all_battle_members[n].battle_actions[1] == nil
            change_character_animation(all_battle_members[n].battle_actions.first[0], get_condition(n, all_battle_members[all_battle_members[n].battle_actions.first[0]].current_condition))
          end
          if all_battle_members[n].battle_actions[1] && all_battle_members[n].battle_actions[1].size == 13
            change_character_animation(all_battle_members[n].battle_actions[1][0], [all_battle_members[n].battle_actions[1][1],all_battle_members[n].battle_actions[1][10],all_battle_members[n].battle_actions[1][3],all_battle_members[n].battle_actions[1][4], all_battle_members[n].battle_actions[1][11]])
            all_battle_members[n].battle_actions[1][7] = (all_battle_members[n].battle_actions[1][5] -  all_battle_members[n].screen_x) / all_battle_members[n].battle_actions[1][9]
            all_battle_members[n].battle_actions[1][8] = (all_battle_members[n].battle_actions[1][6] -  all_battle_members[n].screen_y) / all_battle_members[n].battle_actions[1][9]
          end
          all_battle_members[n].remove_actions
        end
      end
    end
    if go_to_next_command
      return
    end
  end
  #--------------------------------------------------------------------------
  # * Execução da ação de inicio
  #--------------------------------------------------------------------------
  def insert_start_commands_anime(subject)
    @subject = subject
    battle_notes = @subject.actor.note
    for n in 0...battle_notes.size - 11
      if battle_notes[n..n+9] == "<movement "
        y = 0
        y += 1 until battle_notes[n+10+y] == '>'
        insert_battle_commands(battle_notes[n+10..n+9+y].to_i, @subject)
      elsif battle_notes[n..n+10] == "<animation "
        y = 0
        y += 1 until battle_notes[n+11+y] == '>'
        insert_battle_animations(battle_notes[n+11..n+11+y].to_i, @subject)
      elsif battle_notes[n..n+10] == "<castskill "
        y = 0
        y += 1 until battle_notes[n+11+y] == '>'
        insert_self_battle_animations(battle_notes[n+11..n+11+y].to_i, @subject)
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Movimento dos battlers
  #--------------------------------------------------------------------------
  def move_battlers
    for n in 0...all_battle_members.size
      next if all_battle_members[n].battle_actions.empty? || all_battle_members[n].battle_actions.first.size <= 7
      all_battle_members[n].execute_actions if all_battle_members.count {|battler| battler.battle_actions.size <= 1 } == all_battle_members.size || all_battle_members[n].battle_actions.size >= 2
    end
  end
  #--------------------------------------------------------------------------
  # * Obter Condição Atual
  #--------------------------------------------------------------------------
  def get_condition(n, condition)
    if all_battle_members[n].actor?
		if Lune_Anime_Battle::Actor_Conditions[all_battle_members[n].id][condition]
			return Lune_Anime_Battle::Actor_Conditions[all_battle_members[n].id][condition]
		else
			return Lune_Anime_Battle::Conditions[condition]
		end
	else
		if Lune_Anime_Battle::Enemy_Conditions[all_battle_members[n].enemy_id][condition]
			return Lune_Anime_Battle::Enemy_Conditions[all_battle_members[n].enemy_id][condition]
		else
			return Lune_Anime_Battle::Conditions[condition]
		end
	end
  end
  #--------------------------------------------------------------------------
  # * Atualização de batalha
  #--------------------------------------------------------------------------
  def update(*args, &block)
    if $game_troop.all_dead?
      for n in 0...all_battle_members.size
        change_character_animation(n, Lune_Anime_Battle::Standard['Victory']) if all_battle_members[n].alive?
      end
      @adp_pics.each{|pic| pic.opacity = 0} if $imported[:akea_battledamage]
      BattleManager.process_victory
    end
    move_battlers
    go_to_next_command = false
    for n in 0...all_battle_members.size
      unless all_battle_members[n].battle_actions.empty?
        if all_battle_members[n].battle_actions.first[0] == "Wait_For" && all_battle_members[n].battle_actions.first[2] >= 1
          all_battle_members[n].decrease_timer
          p all_battle_members[n].battle_actions.first[2]
          next
        elsif all_battle_members[n].battle_actions.first[0] == "Script_Call" && all_battle_members[n].battle_actions.first[2] == 1
          all_battle_members[n].decrease_timer
          conf = Lune_Anime_Battle::Script_Call[all_battle_members[n].battle_actions.first[1]]
          eval(conf)
          if all_battle_members[n].battle_actions.first.size == 13 && all_battle_members[n].battle_actions.size > 1
            change_character_animation(all_battle_members[n].battle_actions[0][0], [all_battle_members[n].battle_actions[0][1],all_battle_members[n].battle_actions[0][10],all_battle_members[n].battle_actions[0][3],all_battle_members[n].battle_actions[0][4], all_battle_members[n].battle_actions[0][11]])
          end
          next
        elsif all_battle_members[n].battle_actions.first[0] == "Make_Hit"
          $akea_hit_porcentage = all_battle_members[n].battle_actions.first[1]
          use_item
          $akea_hit_porcentage = 0
          all_battle_members[n].remove_actions
          next
        elsif all_battle_members[n].battle_actions.first[0] == "Movie" && all_battle_members[n].battle_actions.first[2] == 1
          all_battle_members[n].decrease_timer
          Graphics.play_movie('Movies/' + all_battle_members[n].battle_actions.first[3])
          all_battle_members[n].remove_actions
          next
        end
        if all_battle_members[n].battle_actions.first[0].is_a?(Integer) && all_battle_members[n].battle_actions.first[0] != n
          all_battle_members[all_battle_members[n].battle_actions[0][0]].insert_actions(all_battle_members[n].battle_actions.first)
          all_battle_members[n].remove_actions
          return
        end
        all_battle_members[n].decrease_timer if all_battle_members.count {|battler| battler.battle_actions.size <= 1 } == all_battle_members.size || all_battle_members[n].battle_actions.size >= 2
        go_to_next_command = true
        if all_battle_members[n].battle_actions.first.size == 7 && all_battle_members[n].battle_actions.first[2] == $data_animations[all_battle_members[n].battle_actions.first[1]].frame_max - 1
          show_normal_animation(all_battle_members[n].battle_actions.first[0], all_battle_members[n].battle_actions.first[1])
          next
        elsif all_battle_members[n].battle_actions.first.size == 7 && all_battle_members[n].battle_actions.first[2] == 0
          all_battle_members[n].remove_actions
          if all_battle_members[n].battle_actions.first.size == 13
            change_character_animation(all_battle_members[n].battle_actions[0][0], [all_battle_members[n].battle_actions[0][1],all_battle_members[n].battle_actions[0][10],all_battle_members[n].battle_actions[0][3],all_battle_members[n].battle_actions[0][4], all_battle_members[n].battle_actions[0][11]])
          end
        end
        if all_battle_members[n].battle_actions.first[2] <= 0
          if all_battle_members[n].battle_actions[1] == nil
            change_character_animation(all_battle_members[n].battle_actions.first[0], get_condition(n, all_battle_members[all_battle_members[n].battle_actions.first[0]].current_condition))
          else
            if all_battle_members.count {|battler| battler.battle_actions.size <= 2 } == all_battle_members.size
              unless @akea_on_battle_moves
                all_battle_members[n].remove_actions if  all_battle_members[n].battle_actions.size <= 2
                next 
              end
              process_event
              lune_anime_process_action   
              @akea_on_battle_moves = false
              all_battle_members.each{|m| change_character_animation(m.battle_actions[0][0], [m.battle_actions[0][1],m.battle_actions[0][10],m.battle_actions[0][3],m.battle_actions[0][4], m.battle_actions[0][11]]) unless m.battle_actions.empty?}
            end
          end
          if all_battle_members[n].battle_actions[1] && all_battle_members[n].battle_actions[1].size == 13
            if @akea_on_battle_moves && all_battle_members[n].battle_actions.size <= 2
              all_battle_members[n].remove_actions
              next
            end
            change_character_animation(all_battle_members[n].battle_actions[1][0], [all_battle_members[n].battle_actions[1][1],all_battle_members[n].battle_actions[1][10],all_battle_members[n].battle_actions[1][3],all_battle_members[n].battle_actions[1][4], all_battle_members[n].battle_actions[1][11]])
            all_battle_members[n].battle_actions[1][7] = (all_battle_members[n].battle_actions[1][5] -  all_battle_members[n].screen_x) / all_battle_members[n].battle_actions[1][9]
            all_battle_members[n].battle_actions[1][8] = (all_battle_members[n].battle_actions[1][6] -  all_battle_members[n].screen_y) / all_battle_members[n].battle_actions[1][9]
          end
          all_battle_members[n].remove_actions
        end
      end
    end
    if go_to_next_command
      super
      return
    end
    lune_anime_update(*args, &block) if all_battle_members.count {|battler| battler.battle_actions.size <= 1 } == all_battle_members.size
  end
  #--------------------------------------------------------------------------
  # * Processamento de ações
  #--------------------------------------------------------------------------
  def process_action
    if !@subject || !@subject.current_action
      @atbs_actions = []
      @subject = BattleManager.next_subject
      @reuse_targets = @subject.current_action.make_targets.compact if @subject && @subject.current_action
      if @subject && (@subject.actor? || Lune_Anime_Battle::Enemy[@subject.enemy_id]) && @subject.current_action
        battle_notes = @subject.current_action.item.note
        if @subject.current_action.item.id == 1 && @subject.actor? && @subject.equips[0] && @subject.current_action.item.is_a?(RPG::Skill)
          battle_notes = @subject.equips[0].note
        end
        @akea_on_battle_moves = true
        if battle_notes.include?('<teamskill') && $imported[:akea_team_battle]
          atbs_team_skill(battle_notes)
          return
        end
        for n in 0...battle_notes.size - 11
          if battle_notes[n..n+9] == "<movement "
            y = 0
            y += 1 until battle_notes[n+10+y] == '>'
            insert_battle_commands(battle_notes[n+10..n+9+y].to_i)
          elsif battle_notes[n..n+9] == "<wait_for "
            y = 0
            y += 1 until battle_notes[n+10+y] == '>'
            insert_battle_wait(battle_notes[n+10..n+9+y].to_i)
          elsif battle_notes[n..n+9] == "<wait_tar "
            y = 0
            y += 1 until battle_notes[n+10+y] == '>'
            for z in 0...@reuse_targets.size
              old_subject = @subject
              insert_battle_wait(battle_notes[n+10..n+9+y].to_i,@reuse_targets[z])
              @subject = old_subject
            end
          elsif battle_notes[n..n+9] == "<move_hit "
            y = 0
            y += 1 until battle_notes[n+10+y] == '>'
            for z in 0...@reuse_targets.size
              old_subject = @subject
              insert_battle_commands(battle_notes[n+10..n+9+y].to_i, @reuse_targets[z], @subject)
              @subject = old_subject
            end
          elsif battle_notes[n..n+11] == "<scriptcall "
            y = 0
            y += 1 until battle_notes[n+12+y] == '>'
            insert_battle_script(battle_notes[n+12..n+11+y].to_i)
          elsif battle_notes[n..n+9] == "<make_hit "
            y = 0
            y += 1 until battle_notes[n+10+y] == '>'
            insert_battle_damage(battle_notes[n+10..n+9+y].to_i)
          elsif battle_notes[n..n+10] == "<a_special "
            msgbox("Requires Akea Special Skill!!") unless $imported[:akea_special_skill]
            y = 0
            y += 1 until battle_notes[n+11+y] == '>'
            insert_akea_special(battle_notes[n+11..n+11+y].to_i)
            targets = @subject.current_action.make_targets.compact
            $game_troop.members.each {|troop| @spriteset.enemy_opacity($game_troop.members.index(troop), 0) unless targets.include?(troop)}
            $game_party.members.each {|actor| @spriteset.actor_opacity($game_party.members.index(actor), 0) unless @subject == actor}
          elsif battle_notes[n..n+10] == "<animation "
            y = 0
            y += 1 until battle_notes[n+11+y] == '>'
            insert_battle_animations(battle_notes[n+11..n+11+y].to_i)
          elsif battle_notes[n..n+10] == "<playmovie "
            y = 0
            y += 1 until battle_notes[n+11+y] == '>'
            insert_battle_animations(battle_notes[n+11..n+11+y])
          elsif battle_notes[n..n+10] == "<castskill "
            y = 0
            y += 1 until battle_notes[n+11+y] == '>'
            insert_self_battle_animations(battle_notes[n+11..n+11+y].to_i)
          elsif battle_notes[n..n+10] == "<condition "
            y = 0
            y += 1 until battle_notes[n+11+y] == '>'
            all_battle_members[@subject.index].current_condition = battle_notes[n+11..n+11+y].to_i
          end
        end
        return
      end
    end
    lune_anime_process_action
  end


  #--------------------------------------------------------------------------
  # * Adicionando animações do usuário
  #--------------------------------------------------------------------------
  def insert_battle_commands(n = 1, subject = nil, enen = nil)
    @subject = subject if subject
    action = Lune_Anime_Battle::Actions[n]
    enemy = @reuse_targets
    if action['Movement'].is_a?(String)
      if action['Movement'] == 'enemy'
        if @subject.actor?
          x = enemy.first.screen_x + Lune_Anime_Battle::Offset_X
          y = enemy.first.screen_y + Lune_Anime_Battle::Offset_Y
        else
          x = enemy.first.screen_x + Lune_Anime_Battle::E_Offset_X
          y = enemy.first.screen_y + Lune_Anime_Battle::E_Offset_Y
        end
      else
        index = 0
        if @subject.enemy?
          index += $game_party.battle_members.size
        end
        x = @start_battler_positions[@subject.index + index][0]
        y = @start_battler_positions[@subject.index + index][1]
      end
    else
      reserve_battle_actions = @subject.battle_actions.dup
      reserve_battle_actions.pop until reserve_battle_actions.empty? || reserve_battle_actions.last[0] == all_battle_members.index(@subject)
      if reserve_battle_actions.empty?
        x = action['Movement'][0] + @subject.screen_x
        y = action['Movement'][1] + @subject.screen_y
        if @subject.enemy?
          x -= action['Movement'][0] * 2
        end
      else
        x = action['Movement'][0] + reserve_battle_actions.last[5]
        y = action['Movement'][1] + reserve_battle_actions.last[6]
        if @subject.enemy?
          x -= action['Movement'][0] * 2
          y -= action['Movement'][1] * 2
        end
      end
    end
      get_to_x = (x -  @subject.screen_x) / action['Time']
      get_to_y = (y -  @subject.screen_y)  / action['Time']
    if enen
      if enen.actor?
        @subject.insert_actions([all_battle_members.index(@subject),action['Frame'], action['Time'], action['Frames'], action['Looping'], x, y, get_to_x, get_to_y, action['Time'], action['Speed'], action['Mirror'], action['Jump_Height']])
      else
        enen.insert_actions([all_battle_members.index(@subject),action['Frame'], action['Time'], action['Frames'], action['Looping'], x, y, get_to_x, get_to_y, action['Time'], action['Speed'], action['Mirror'], action['Jump_Height']])
      end
    else
      @subject.insert_actions([all_battle_members.index(@subject),action['Frame'], action['Time'], action['Frames'], action['Looping'], x, y, get_to_x, get_to_y, action['Time'], action['Speed'], action['Mirror'], action['Jump_Height']])
      change_character_animation(@subject.battle_actions[0][0], [@subject.battle_actions[0][1],@subject.battle_actions[0][10],@subject.battle_actions[0][3],@subject.battle_actions[0][4], @subject.battle_actions[0][11]])
    end
  end
  #--------------------------------------------------------------------------
  # * Adicionando animações de batalha
  #--------------------------------------------------------------------------
  def insert_battle_animations(n = 0, dmg = 0)
    enemy = @reuse_targets
    if n == 0
      @subject.insert_actions(["Make_Hit", dmg])
    elsif n.is_a?(String)
      @subject.insert_actions(["Movie", dmg, 1, n])
    else
      @subject.insert_actions([enemy, n])
      @subject.battle_actions.last[2] = $data_animations[n].frame_max
    end
    if @subject.battle_actions.size == 1
      @subject.battle_actions.last[5] = 0
      @subject.battle_actions.last[6] = 0
    else
      @subject.battle_actions.last[5] = @subject.battle_actions[@subject.battle_actions.size - 2][5]
      @subject.battle_actions.last[6] = @subject.battle_actions[@subject.battle_actions.size - 2][6]
      @subject.insert_actions(@subject.battle_actions[@subject.battle_actions.size - 2])
    end
  end
  def insert_battle_damage(n)
    insert_battle_animations(0, n)
  end
  def insert_battle_script(n)
    @subject.insert_actions(["Script_Call", n, 1])
  end
  def insert_battle_wait(n, sub = nil)
    if sub
      sub.insert_actions(["Wait_For", 0, n])
    else
      @subject.insert_actions(["Wait_For", 0, n])
    end
    
  end
  #--------------------------------------------------------------------------
  # * Adicionando animações no usuário
  #--------------------------------------------------------------------------
  def insert_self_battle_animations(n = 0)
    enemy = [@subject]
     @subject.insert_actions([enemy, n])
    last_battler = false
    @subject.battle_actions.last[2] = $data_animations[n].frame_max
    for n in 0... @subject.battle_actions.size - 1
      last_battler = n if @subject.battle_actions[n][0] == @subject.index
    end
    if  @subject.battle_actions.size == 1 || !last_battler
       @subject.battle_actions.last[5] = 0
       @subject.battle_actions.last[6] = 0
     else
      @subject.battle_actions.last[5] = @subject.battle_actions[last_battler][5]
      @subject.battle_actions.last[6] = @subject.battle_actions[last_battler][6]
      @subject.insert_actions(@subject.battle_actions[last_battler])
    end
  end
  #--------------------------------------------------------------------------
  # * Mudar a Sprite de batalha
  #--------------------------------------------------------------------------
  def change_character_animation(id, array)
    if array.is_a?(Integer)
      array = get_condition(id, array)
    end
    return if array[1] == nil
    all_battle_members[id].condition_time = array[6] if array[6] && all_battle_members[id].condition_time == 0
    all_battle_members[id].change_stance(array[0])
    all_battle_members[id].change_frames(array[1],array[2])
    all_battle_members[id].mirror_battler(array[4])
    all_battle_members[id].battler_loops?(array[3])
    all_battle_members[id].reset_count = true unless all_battle_members[id].dead?
  end
  #--------------------------------------------------------------------------
  # * Uso de habilidades/itens
  #--------------------------------------------------------------------------
  def use_item
    targets = @reuse_targets
    item = @subject.current_action.item
    if item.damage.type != 0 && item.damage.type != 3
      dm = Lune_Anime_Battle::Standard['Damage']
      targets.each {|target| 
        change_character_animation(all_battle_members.index(target), dm)
      }
    end
    @log_window.display_use_item(@subject, item) if $akea_hit_porcentage == 0 || Lune_Anime_Battle::Show_On_Log
    @subject.use_item(item)
    refresh_status
    show_animation(targets, item.animation_id) if $akea_hit_porcentage == 0
    targets.each {|target| item.repeats.times { invoke_item(target, item) }}
    if $game_troop.all_dead? && $akea_hit_porcentage == 0
      for n in 0...all_battle_members.size
        change_character_animation(n, Lune_Anime_Battle::Standard['Victory']) if all_battle_members[n].alive?
      end
    end
  end

  #--------------------------------------------------------------------------
  # * Execução da ação
  #--------------------------------------------------------------------------
  def execute_action
    lune_anime_execute_action
    return if $game_troop.all_dead?
     for n in 0...all_battle_members.size
       all_battle_members[n].current_hp_condition
       change_character_animation(n, get_condition(n, all_battle_members[n].current_condition))
     end
  end
  #--------------------------------------------------------------------------
  # * Final do turno
  #--------------------------------------------------------------------------
  def turn_end
    for n in 0...all_battle_members.size
      all_battle_members[n].condition_turn
      all_battle_members[n].update_current_condition(1)
      change_character_animation(n, get_condition(n, all_battle_members[n].current_condition))
    end
    lune_anime_turn_end
  end
end



#==============================================================================
# ** Game_Enemy
#------------------------------------------------------------------------------
#  Esta classe gerencia os inimigos. Ela é utilizada internamente pela 
# classe Game_Troop ($game_troop).
#==============================================================================

class Game_Enemy < Game_Battler
alias :lunemy_anime_initialize :initialize
  #--------------------------------------------------------------------------
  # * Aquisição da ID da animação de ataque normal
  #--------------------------------------------------------------------------
  def atk_animation_id1
    0
  end
  #--------------------------------------------------------------------------
  # * Aquisição da ID da animação de ataque normal
  #--------------------------------------------------------------------------
  def atk_animation_id2
    0
  end
  attr_accessor :current_position
  attr_accessor :frame_count
  attr_accessor :frame_rate
  attr_accessor :frame_index
  attr_accessor :battler_mirror
  attr_accessor :looping_animation
  attr_accessor :reset_count
  #--------------------------------------------------------------------------
  # * Inicialização do objeto
  #     actor_id : ID do herói
  #--------------------------------------------------------------------------
  def initialize(index, enemy_id)
    lunemy_anime_initialize(index, enemy_id)
    @battler_name = Lune_Anime_Battle::Enemy_Poses[enemy_id] if Lune_Anime_Battle::Enemy_Poses[enemy_id]
    @frame_count = 0
    @frame_rate = 0
    @current_position = 0
    @battler_mirror = false
    @looping_animation = 1
    @reset_count == true
  end
  #--------------------------------------------------------------------------
  # * Definição de uso de sprites
  #--------------------------------------------------------------------------
  def use_sprite?
    return true
  end
  #--------------------------------------------------------------------------
  # * Aquisição do coordenada Z na tela
  #--------------------------------------------------------------------------
  def screen_z
    return 110
  end
  #--------------------------------------------------------------------------
  # * Mudança de pose
  #--------------------------------------------------------------------------
  def change_stance(n)
    @current_position = n
  end
  #--------------------------------------------------------------------------
  # * Mudança de frames
  #--------------------------------------------------------------------------
  def change_frames(rate, index)
    @frame_count = 0
    @frame_rate = rate
    @frame_index = index
  end
  #--------------------------------------------------------------------------
  # * Espelhar o personagem?
  #--------------------------------------------------------------------------
  def mirror_battler(mirror = false)
    @battler_mirror = mirror
  end
  #--------------------------------------------------------------------------
  # * Loops?
  #--------------------------------------------------------------------------
  def battler_loops?(loop = 1)
    @looping_animation = loop
  end
end

#==============================================================================
# ** Spriteset_Battle
#------------------------------------------------------------------------------
#  Esta classe reune os sprites da tela de batalha. Esta classe é usada 
# internamente pela classe Scene_Battle. 
#==============================================================================

class Spriteset_Battle
  #--------------------------------------------------------------------------
  # * Criação dos sprites dos heróis
  #    Por padrão, não são exibidas imagens para os heróis. 
  #--------------------------------------------------------------------------
  def create_actors
    @actor_sprites = $game_party.members.reverse.collect do |actor|
      Sprite_Battler.new(@viewport1, actor)
    end
  end
end

#==============================================================================
# ** Game_Actor
#------------------------------------------------------------------------------
#  Esta classe gerencia os heróis. Ela é utilizada internamente pela classe
# Game_Actors ($game_actors). A instância desta classe é referenciada
# pela classe Game_Party ($game_party).
#==============================================================================
class Game_Actor < Game_Battler
alias :lune_anime_initialize :initialize
  attr_accessor :current_position
  attr_accessor :frame_count
  attr_accessor :frame_rate
  attr_accessor :frame_index
  attr_accessor :battler_mirror
  attr_accessor :looping_animation
  attr_accessor :reset_count
  #--------------------------------------------------------------------------
  # * Inicialização do objeto
  #     actor_id : ID do herói
  #--------------------------------------------------------------------------
  def initialize(actor_id)
    lune_anime_initialize(actor_id)
    @battler_name = Lune_Anime_Battle::Battle_Poses[actor_id]
    @frame_count = 0
    @frame_rate = 0
    @current_position = 0
    @battler_mirror = false
    @looping_animation = 1
    @reset_count == true
  end
  #--------------------------------------------------------------------------
  # * Definição de uso de sprites
  #--------------------------------------------------------------------------
  def use_sprite?
    return true
  end
  #--------------------------------------------------------------------------
  # * Aquisição do coordenada Z na tela
  #--------------------------------------------------------------------------
  def screen_z
    return 110
  end
  #--------------------------------------------------------------------------
  # * Mudança de pose
  #--------------------------------------------------------------------------
  def change_stance(n)
    @current_position = n
  end
  #--------------------------------------------------------------------------
  # * Mudança de frames
  #--------------------------------------------------------------------------
  def change_frames(rate, index)
    @frame_count = 0
    @frame_rate = rate
    @frame_index = index
  end
  #--------------------------------------------------------------------------
  # * Espelhar o personagem?
  #--------------------------------------------------------------------------
  def mirror_battler(mirror = false)
    @battler_mirror = mirror
  end
  #--------------------------------------------------------------------------
  # * Loops?
  #--------------------------------------------------------------------------
  def battler_loops?(loop = 1)
    @looping_animation = loop
  end

end

#==============================================================================
# ** Sprite_Battler
#------------------------------------------------------------------------------
#  Este sprite é usado para exibir lutadores. Ele observa uma instância
# da classe Game_Battler e automaticamente muda as condições do sprite.
#==============================================================================

class Sprite_Battler < Sprite_Base
alias :lune_animation_initialize :initialize
alias :lune_anime_update_bitmap :update_bitmap
alias :lune_anime_revert_to_normal :revert_to_normal

  #--------------------------------------------------------------------------
  # * Inicialização do processo
  #--------------------------------------------------------------------------
  def initialize(viewport, battler = nil)
    lune_animation_initialize(viewport, battler)
    @charac_index = 0
    @charac_pattern = 0
    if @battler.actor? || Lune_Anime_Battle::Enemy[@battler.enemy_id]
      @battler.frame_index = get_condition(Lune_Anime_Battle::Standard['Stand'], 2)
      @battler.frame_rate = get_condition(Lune_Anime_Battle::Standard['Stand'], 1)
      @battler.frame_count = 0
      @battler.current_position = get_condition(Lune_Anime_Battle::Standard['Stand'], 0)
    end
  end
  def get_condition(condition, n)
    if @battler.actor?
		if Lune_Anime_Battle::Actor_Conditions[@battler.id][condition]
			return Lune_Anime_Battle::Actor_Conditions[@battler.id][condition][n]
		else
			return Lune_Anime_Battle::Conditions[condition][n]
		end
	else
		if Lune_Anime_Battle::Enemy_Conditions[@battler.enemy_id][condition]
			return Lune_Anime_Battle::Enemy_Conditions[@battler.enemy_id][condition][n]
		else
			return Lune_Anime_Battle::Conditions[condition][n]
		end
	end
  end
  #--------------------------------------------------------------------------
  # * Atualização do retângulo de origem
  #--------------------------------------------------------------------------
  def update_battler_position
    update_battler_movement
    if @battler.enemy?
      @cut_w = bitmap.width / Lune_Anime_Battle::Enemy[battler.enemy_id]['Frames']
      @cut_h = bitmap.height / Lune_Anime_Battle::Enemy[battler.enemy_id]['Positions']
    else
      @cut_w = bitmap.width / Lune_Anime_Battle::Actor[battler.id]['Frames']
      @cut_h = bitmap.height / Lune_Anime_Battle::Actor[battler.id]['Positions']
    end
    sx = @charac_index * @cut_w
    sy = @battler.current_position * @cut_h
    self.src_rect.set(sx, sy, @cut_w, @cut_h)
  end
  #--------------------------------------------------------------------------
  # * Atualização do frame
  #--------------------------------------------------------------------------
  def update_battler_movement
    if @battler.reset_count == true
      @charac_index = 0
      @battler.reset_count = false
    end
    @battler.frame_count += 1
    self.mirror = @battler.battler_mirror
    return unless @battler.frame_count % @battler.frame_rate == 0
    if @battler.looping_animation == 2
      if @charac_index == (@battler.frame_index - 1)
        @battler.looping_condition = true
        @charac_index -= 1
      elsif @charac_index < (@battler.frame_index - 1)
        @battler.looping_condition = false if @charac_index == 0
        @battler.looping_condition ? @charac_index -= 1 : @charac_index += 1
      end
    elsif @charac_index == (@battler.frame_index - 1) && @battler.looping_animation == 1
      @charac_index = 0
    elsif @charac_index < (@battler.frame_index - 1)
      @charac_index += 1
    end
  end
  #--------------------------------------------------------------------------
  # * Atualização do bitmap de origem
  #--------------------------------------------------------------------------
  def update_bitmap
    lune_anime_update_bitmap
    update_battler_position if @battler.actor? || Lune_Anime_Battle::Enemy[@battler.enemy_id]
  end
  #--------------------------------------------------------------------------
  # * Atualização da origem
  #--------------------------------------------------------------------------
  def update_origin
    if bitmap
      if @battler.enemy? && !Lune_Anime_Battle::Enemy[@battler.enemy_id]
        self.ox = bitmap.width / 2
        self.oy = bitmap.height
      elsif @battler.enemy?
        self.ox = bitmap.width / (2* Lune_Anime_Battle::Enemy[battler.enemy_id]['Frames'])
        self.oy = bitmap.height / Lune_Anime_Battle::Enemy[battler.enemy_id]['Positions']
      else
        self.ox = bitmap.width / (2* Lune_Anime_Battle::Actor[battler.id]['Frames'])
        self.oy = bitmap.height / Lune_Anime_Battle::Actor[battler.id]['Positions']
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Voltar ao normal
  #--------------------------------------------------------------------------
  def revert_to_normal
    lune_anime_revert_to_normal
    return if (@battler.enemy? && !Lune_Anime_Battle::Enemy[@battler.enemy_id]) || !bitmap
    if @battler.enemy?
      self.ox = bitmap.width / (2* Lune_Anime_Battle::Enemy[battler.enemy_id]['Frames'])
    else
      self.ox = bitmap.width / (2* Lune_Anime_Battle::Actor[battler.id]['Frames'])
    end
  end
  #--------------------------------------------------------------------------
  # * Atualização do efeito de colapso
  #--------------------------------------------------------------------------
  def update_collapse
    return unless @battler.enemy?
    self.blend_type = 1
    self.color.set(255, 128, 128, 128)
    self.opacity = 256 - (48 - @effect_duration) * 6
  end
end
#==============================================================================
# ** Game_Battler
#------------------------------------------------------------------------------
#  Esta classe gerencia os battlers. Controla a adição de sprites e ações 
# dos lutadores durante o combate.
# É usada como a superclasse das classes Game_Enemy e Game_Actor.
#==============================================================================

class Game_Battler < Game_BattlerBase
alias :lune_anime_initialize_b :initialize
alias :lune_anime_execute :execute_damage
  attr_accessor   :current_condition
  attr_reader     :battler_wait
  attr_accessor   :screen_x
  attr_accessor   :screen_y
  attr_accessor   :battle_actions
  attr_accessor   :condition_time
  attr_accessor   :looping_condition
  attr_accessor   :jump_height
  #--------------------------------------------------------------------------
  # * Inicialização do objeto
  #--------------------------------------------------------------------------
  def initialize
    lune_anime_initialize_b
    @battle_actions = Array.new
    @battler_wait = 0
    @screen_x = 0
    @screen_y = 0
    @condition_time = 0
    @starting_battle_x = 0
    @starting_battle_y = 0
    @jump_height = 0
    @looping_condition = false
    @current_condition = Lune_Anime_Battle::Standard['Stand']
  end
  def current_hp_condition
    hp_calc = self.hp * 100 / self.mhp
    if hp_calc > Lune_Anime_Battle::Hp
      @current_condition = Lune_Anime_Battle::Standard['Stand'] if @current_condition == Lune_Anime_Battle::Standard['Dead'] || @current_condition == Lune_Anime_Battle::Standard['Stand']
      return Lune_Anime_Battle::Standard['Stand']
    elsif self.hp != 0
      @current_condition = Lune_Anime_Battle::Standard['Weak'] if @current_condition == Lune_Anime_Battle::Standard['Dead'] || @current_condition == Lune_Anime_Battle::Standard['Stand']
      return Lune_Anime_Battle::Standard['Weak']
    else
      @current_condition = Lune_Anime_Battle::Standard['Dead']
      @battle_actions = []
      return Lune_Anime_Battle::Standard['Dead']
    end  
  end
  def update_current_condition(condition)
    if self.hp == 0 || condition == 0 || @condition_time <= 0
      @current_condition = current_hp_condition
      @condition_time = 0
      return 
    end
  end
  def insert_actions(array = 0)
    if array == 0
      @starting_battle_x = self.screen_x
      @starting_battle_y = self.screen_y
      @battle_actions = []
    else
      @battle_actions << array
    end
    @looping_condition = false
  end
  def unshift_actions(array = 0)
    if array == 0
      @battle_actions = []
    else
      @battle_actions.unshift(array)
    end
    @looping_condition = false
  end
  def execute_actions
    return if @battle_actions.empty?
    self.screen_x += @battle_actions.first[7]
    self.screen_y += @battle_actions.first[8] + get_jump_height
    if @battle_actions.first[2] <= 1
      self.screen_x = @battle_actions.first[5]
      self.screen_y = @battle_actions.first[6]
      @starting_battle_x = self.screen_x
      @starting_battle_y = self.screen_y
    end
  end
  def get_jump_height
    if @battle_actions.first[5] < @starting_battle_x
      jump_peak = (@starting_battle_x - @battle_actions.first[5])/2
      jump_peak += @battle_actions.first[5]
      pos_x = (jump_peak - self.screen_x).to_f / [jump_peak, 1].max
      [@battle_actions.first[12] * pos_x, @battle_actions.first[12]].min
    else
      jump_peak = (@battle_actions.first[5] - @starting_battle_x)/2
      jump_peak += @starting_battle_x
      pos_x = (jump_peak - self.screen_x).to_f / [jump_peak, 1].max
      pos_x *= -1
      [@battle_actions.first[12] * pos_x, @battle_actions.first[12]].min
    end
  end
  def decrease_timer
    return if @battle_actions.empty?
    @battle_actions.first[2] -= 1
  end
  def remove_actions
    if @battle_actions.size > 1 && @battle_actions[1][0].is_a?(Integer)
      get_to_x = (@battle_actions[1][5] -  all_battle_members[@battle_actions[1][0]].screen_x) / @battle_actions[1][9]
      get_to_y = (@battle_actions[1][6] -  all_battle_members[@battle_actions[1][0]].screen_y) / @battle_actions[1][9]
      @battle_actions[1][7] = get_to_x
      @battle_actions[1][8] = get_to_y
    end
    @battle_actions.shift
  end
  def condition_turn
    @condition_time -= 1
  end
  #--------------------------------------------------------------------------
  # * Aquisição combinada de todos os membros aliados e inimigos
  #--------------------------------------------------------------------------
  def all_battle_members
    $game_party.members + $game_troop.members
  end
end

#==============================================================================
# ** Game_ActionResult
#------------------------------------------------------------------------------
#  Esta classe gerencia os resultados das ações nos combates.
# Esta classe é usada internamente pela classe Game_Battler.
#==============================================================================

class Game_ActionResult
alias :akea_animated_make_damage :make_damage
  #--------------------------------------------------------------------------
  # * Criação do dano
  #     value : valor do dano
  #     item  : objeto
  #--------------------------------------------------------------------------
  def make_damage(value, item)
    unless $akea_hit_porcentage == 0
      value *= $akea_hit_porcentage 
      value /= 100
      value = value.to_i
    end
    akea_animated_make_damage(value, item)
  end
end