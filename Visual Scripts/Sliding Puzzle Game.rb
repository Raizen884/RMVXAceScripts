module Lune_Sliding
Game = []

#=======================================================
#         Sliding Puzzle Game
# Author: Raizen
# Comunidade: www.centrorpg.com
# 
# O mini-game consiste em mover blocos até
# que a imagem esteja completa.
#=======================================================
# NOTA: O script PODE ser adicionado a qualquer momento 
# na produção do jogo

# Para chamar o Script basta utilizar o seguinte comando,
# Chamar Script: slide_game(n)
# aonde n é o número do jogo que pode ser configurado abaixo.


# A velocidade com o qual os blocos se movem
Speed = 10 

# Som no momento que um bloco se mover
Sound_B = 'Wind7' 

# Som no caso de conseguir resolver
Victory = 'Decision2' 

# A quantidade de vezes que é embaralhado, quanto maior
# mais embaralhado, mas demora mais para carregar.
Shuffle = 200 


# Crie aqui os jogos que deseja, basta seguir o seguinte,
# Game[n] = { Aonde n é o número do jogo.


# Todas Imagens dentro de Graphics/Sliding
#==============================================================================
# Game 1 => Miku
#==============================================================================
Game[1] = {
'Background' => 'back1', # Imagem de fundo
'Image' => 'Miku', # Imagem dos blocos
'Xaxis' => 3, # Quantidade de blocos no eixo X
'Yaxis' => 3, # Quantidade de blocos no eixo Y
'Escape?' => false, # É possível sair no meio do jogo?
'Switch' => 1, #Switch ativada após completar o jogo
'Music' => 'Dungeon6', #música do jogo
}

#==============================================================================
# Game 2 => Misa
#==============================================================================
Game[2] = {
'Background' => 'back1', # Imagem de fundo
'Image' => 'Misa', # Imagem dos blocos
'Xaxis' => 4, # Quantidade de blocos no eixo X
'Yaxis' => 5, # Quantidade de blocos no eixo Y
'Escape?' => true, # É possível sair no meio do jogo?
'Switch' => 1, #Switch ativada após completar o jogo
'Music' => 'Dungeon6', #música do jogo
}
end

#==============================================================================
# ** Scene_Panel
#------------------------------------------------------------------------------
#  Esta classe é a classe principal do mini-game.
#==============================================================================

class Scene_Panel < Scene_MenuBase
include Lune_Sliding
  #--------------------------------------------------------------------------
  # * Inicialização do processo
  #--------------------------------------------------------------------------
  def start
    @map_bgm = RPG::BGM.last
    @map_bgs = RPG::BGS.last
    RPG::BGS.stop
    @game = Game[$config_panel_game]
    super
    create_game_variables
    create_game_pictures
    shuffle_board
  end
  #--------------------------------------------------------------------------
  # * Criação das variáveis
  #--------------------------------------------------------------------------
  def create_game_variables
    @speed = Speed
    @cursor = 0
    @aux = []
    @move = 0
    @block = []
    @direction = 0
    @count = 10
    @victory = false
  end
  #--------------------------------------------------------------------------
  # * Criação das Imagens
  #--------------------------------------------------------------------------
  def create_game_pictures
    @back = Sprite.new
    @im = Array.new
    RPG::BGM.new(@game['Music']).play
    @back.bitmap = Cache.sliding(@game['Background'])
    @back.x = (Graphics.width - @back.bitmap.width)/2
    @back.x = (Graphics.height - @back.bitmap.height)/2
    @map = Array.new(@game['Xaxis'])
    for n in 0...@game['Xaxis']
      @im[n] = Array.new
      @map[n] = Array.new
    end
    for x in 0...@game['Xaxis']
      for y in 0...@game['Yaxis']
        @im[x][y] = Sprite.new
        @im[x][y].bitmap = Cache.sliding(@game['Image'])
        @im[x][y].x = (Graphics.width - @im[x][y].bitmap.width)/2 + x*@im[x][y].bitmap.width/@game['Xaxis']
        @im[x][y].y = (Graphics.height - @im[x][y].bitmap.height)/2 + y*@im[x][y].bitmap.height/@game['Yaxis']
        @im[x][y].src_rect.set(x*@im[x][y].bitmap.width/@game['Xaxis'], y*@im[x][y].bitmap.height/@game['Yaxis'], @im[x][y].bitmap.width/@game['Xaxis'], @im[x][y].bitmap.height/@game['Yaxis'])        
        @map[x][y] = [@im[x][y].x, @im[x][y].y]
        @im[x][y].bitmap = Cache.sliding('') if (x+1) == @game['Xaxis'] && (y+1) == @game['Yaxis']
        @map[x][y] = (x+1) + y*@game['Xaxis']
      end
    end
    @cursor = @game['Xaxis'] * @game['Yaxis']
  end
  #--------------------------------------------------------------------------
  # * Atualização da classe
  #--------------------------------------------------------------------------
  def update
    super
    if @victory
      return_scene if Input.trigger?(:B)
      return
    end
    return if block_moving?
    if Input.trigger?(:B)
      @game['Escape?'] ? return_scene : Sound.play_buzzer
    end
    move_block(Input.dir4)
  end
  #--------------------------------------------------------------------------
  # * Mover os quadros
  #--------------------------------------------------------------------------
  def block_moving?
    return false if @direction == 0
    x = @block[0]
    y = @block[1]
    case @direction
    when 8
      if @count < @speed
        @im[x][y].y -= (@im[x][y].bitmap.height/@game['Yaxis'])/@speed
      else
        @im[x][y].y -= @correctiony
      end
    when 6
      if @count < @speed
        @im[x][y].x += (@im[x][y].bitmap.width/@game['Xaxis'])/@speed
      else
        @im[x][y].x += @correctionx
      end
    when 4
      if @count < @speed
        @im[x][y].x -= (@im[x][y].bitmap.width/@game['Xaxis'])/@speed
      else
        @im[x][y].x -= @correctionx
      end
    when 2
      if @count < @speed
        @im[x][y].y += (@im[x][y].bitmap.height/@game['Yaxis'])/@speed
      else
        @im[x][y].y += @correctiony
      end
    end
    @count += 1
    if @count == (@speed + 1)
      @direction = 0 
      if orded
        $game_switches[@game['Switch']] = true
        @victory = true 
        RPG::SE.new(Victory).play
      end
    end
    true
  end
  #--------------------------------------------------------------------------
  # * Mover o bloco
  #--------------------------------------------------------------------------
  def move_block(dir)
  return if dir == 0
  @move = @map[(@cursor-1) % @game['Xaxis']][(@cursor-1)/@game['Xaxis']]
  @aux = [(@move-1) % @game['Xaxis'],(@move-1)/@game['Xaxis']]
  @old_cursor = @cursor
  case dir
  when 8
    if @cursor + @game['Xaxis'] <= @game['Xaxis']*@game['Yaxis']
      @cursor += @game['Xaxis']
    else
      return
    end
  when 6
    if (@cursor - 1) % @game['Xaxis'] != 0
      @cursor -= 1
    else
      return
    end
  when 4
    if @cursor % @game['Xaxis'] != 0
      @cursor += 1
    else
      return
    end
  when 2
    if @cursor - @game['Xaxis'] > 0
      @cursor -= @game['Xaxis']
    else
      return
    end
  end
    RPG::SE.new(Sound_B).play
    @move = @map[(@cursor-1) % @game['Xaxis']][(@cursor-1)/@game['Xaxis']]
    @block = [(@move-1) % @game['Xaxis'],(@move-1)/@game['Xaxis']]
    @old = @map[(@cursor-1) % @game['Xaxis']][(@cursor-1)/@game['Xaxis']]
    @map[(@cursor-1) % @game['Xaxis']][(@cursor-1)/@game['Xaxis']] = @map[(@old_cursor-1) % @game['Xaxis']][(@old_cursor-1)/@game['Xaxis']]
    @map[(@old_cursor-1) % @game['Xaxis']][(@old_cursor-1)/@game['Xaxis']] = @old
    @correctionx = @im[0][0].bitmap.width/@game['Xaxis'] % @speed
    @correctiony = @im[0][0].bitmap.height/@game['Yaxis'] % @speed
    @count = 0
    @direction = dir
  end
  #--------------------------------------------------------------------------
  # * Embaralhar o quadro
  #--------------------------------------------------------------------------
  def shuffle_board
    @count = 0
    while @count <= Shuffle
      move_shuffle
      block_shuffle
      @count+= 1
    end
    until @cursor == @game['Xaxis'] * @game['Yaxis']
      move_shuffle
      block_shuffle
    end
    @count = 0
  end
  #--------------------------------------------------------------------------
  # * Embaralhar os quadros
  #--------------------------------------------------------------------------
  def block_shuffle
    return false if @direction == 0
    x = @block[0]
    y = @block[1]
    case @direction
    when 8
      @im[x][y].y -= (@im[x][y].bitmap.height/@game['Yaxis'])
    when 6
      @im[x][y].x += (@im[x][y].bitmap.width/@game['Xaxis'])
    when 4
      @im[x][y].x -= (@im[x][y].bitmap.width/@game['Xaxis'])
    when 2
      @im[x][y].y += (@im[x][y].bitmap.height/@game['Yaxis'])
    end
    @direction = 0
    true
  end
  #--------------------------------------------------------------------------
  # * Embaralhar as variáveis
  #--------------------------------------------------------------------------
  def move_shuffle
  @move = @map[(@cursor-1) % @game['Xaxis']][(@cursor-1)/@game['Xaxis']]
  @aux = [(@move-1) % @game['Xaxis'],(@move-1)/@game['Xaxis']]
  @old_cursor = @cursor
  dir = (rand(4)+1)*2
  p dir
  case dir
  when 8
    if @cursor + @game['Xaxis'] <= @game['Xaxis']*@game['Yaxis']
      @cursor += @game['Xaxis']
    else
      return
    end
  when 6
    if (@cursor - 1) % @game['Xaxis'] != 0
      @cursor -= 1
    else
      return
    end
  when 4
    if @cursor % @game['Xaxis'] != 0
      @cursor += 1
    else
      return
    end
  when 2
    if @cursor - @game['Xaxis'] > 0
      @cursor -= @game['Xaxis']
    else
      return
    end
  end
    @move = @map[(@cursor-1) % @game['Xaxis']][(@cursor-1)/@game['Xaxis']]
    @block = [(@move-1) % @game['Xaxis'],(@move-1)/@game['Xaxis']]
    @old = @map[(@cursor-1) % @game['Xaxis']][(@cursor-1)/@game['Xaxis']]
    @map[(@cursor-1) % @game['Xaxis']][(@cursor-1)/@game['Xaxis']] = @map[(@old_cursor-1) % @game['Xaxis']][(@old_cursor-1)/@game['Xaxis']]
    @map[(@old_cursor-1) % @game['Xaxis']][(@old_cursor-1)/@game['Xaxis']] = @old
    @direction = dir
  end
  #--------------------------------------------------------------------------
  # * Verificação de vitória
  #--------------------------------------------------------------------------
  def orded
    for x in 0...@game['Xaxis']
      for y in 0...@game['Yaxis']
        return false unless @map[x][y] == (y*@game['Xaxis']+x+1)
      end
    end
    true
  end
  #--------------------------------------------------------------------------
  # * Retornar para cena anterior
  #--------------------------------------------------------------------------
  def return_scene
    super
    Sound.play_cancel
    @map_bgm.replay
    @map_bgs.replay
    for x in 0...@game['Xaxis']
      for y in 0...@game['Yaxis']
        @im[x][y].bitmap.dispose
        @im[x][y].dispose
        @back.dispose
      end
    end
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
  # * Inicialização do objeto
  #     depth : profundidade
  #--------------------------------------------------------------------------
  def slide_game(index)
    $config_panel_game = index
    SceneManager.call(Scene_Panel)
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
  # * Carregamento dos gráficos de batalha (piso)
  #     filename : nome do arquivo
  #     hue      : informações da alteração de tonalidade
  #--------------------------------------------------------------------------
  def self.sliding(filename)
    load_bitmap("Graphics/Sliding/", filename)
  end
end