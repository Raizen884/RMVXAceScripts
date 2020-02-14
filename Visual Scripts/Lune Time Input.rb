#=======================================================
#         Lune Time Input
# Autor: Raizen
# Comunidade: www.centrorpg.com
# O script adiciona uma tela de input que é necessário o jogador
# acertar as teclas na sequencia para obter sucesso,
# pode ser usado como mini-game para abrir portas, tesouros, ou inclusive contra
# inimigos em ABS, as opção são inúmeras.
# Demo Download: https://www.mediafire.com/?2m3versr9rftosj
#=======================================================

module Lune_Time_Input
Game = Array.new
# Para ativar o Script
# Chamar Script: time_input(id, switch, error)

# Aonde id é o id do game que é configurado logo abaixo no script,
# switch é a switch que será ligada caso o jogador acerte a sequencia
# ou desligada caso ele erre,
# e error é true ou false
# aonde true permite que o jogador aperte as teclas erradas e false
# não permite teclas incorretas.


# Imagem do texto de sucesso (dentro da pasta Graphics\Time_Input do seu projeto)
Success = 'Success'

# Imagem do texto de falha
Failure = 'Failed'

# SE que tocará caso tenha sucesso (dentro da pasta Graphics\Time_Input do seu projeto)
Victory_SE = 'Applause1'

# SE que tocará caso tenha falhe
Defeat_SE = 'Buzzer2'

#Fechamento automatico do puzzle?
# 0 para desativar, e qualquer outro número para fechar automaticamente depois de
# X segundos
Auto_Close = 4


# Configuração de teclas, cada tecla é configurado da seguinte maneira.
# 'Sua Escolha de tecla' => [Tecla do RPG Maker, Nome da Imagem],
# Então se quero adicionar o Shift (No RPG Maker o Shift é :SHIFT, e o nome da imagem
# dele é shif, logo eu posso configurar desse modo.
#'SHIFT' => [:SHIFT, 'shif'],
# O SHIFT será usado na próxima configuração após essa para indicar as teclas
# utilizadas,

#DICA, você PODE usar o meu Keyboard Module para esse script, ficaria da seguinte
# maneira
#'SHIFT' => [Key::Shift, 'shif'],


Keys_Config = {
'A' => [:X, 'A'],
'S' => [:Y, 'S'],
'Z' => [:C, 'Z'],
'X' => [:B, 'X'],
'LEFT' => [:LEFT, 'LEFT'],
'RIGHT' => [:RIGHT, 'RIGHT'],
'DOWN' => [:DOWN, 'DOWN'],
'UP' => [:UP, 'UP'],
}


# Abaixo é configurado individualmente cada id dos "jogos" diferentes, 
# Assim pode modificar e altera-los conforme o jogo, lembrando que todos os gráficos
# devem estar na pasta Graphics\Time_Input do seu projeto

# Pode adicionar quantos Games quiser seguindo o mesmo padrão
#--------------------------------------------------------------------------
# Game[0]
#--------------------------------------------------------------------------
Game[0] = {

'Base_Image' => 'Back_Time', # Gráfico de fundo de tela
'Front_Image' => '', # Gráfico da frente da tela
'Bar_Image' => 'Time_Bar', #Gráfico da barra de tempo
'Bar_Position' => [120, 127], #Posição da barra [Posição X, Posição Y]
'Bar_Direction' => 'Horizontal', #Direção da barra e do input (Horizontal ou Vertical)
'Time' => 6, # Tempo em segundos para falhar o mini-game
'Keys' => 15, # Teclas que irão aparecer para o jogador(apenas válido para a opção random)
'Move_Speed' => 2, # Velocidade do movimento das teclas
'Random?' => false, # Criar jogo aleatório a partir das teclas?
#Sequencia, se o jogo for aleatório será as teclas de input, se não, será na mesma ordem adicionado aqui.
'Sequence' => ['X', 'Z', 'A', 'S', 'LEFT', 'RIGHT', 'DOWN', 'UP'], 
'Start_Pos' => [120, 160], #Posição Inicial das teclas [Posição X, Posição Y]
'Distance' => 35, #Distancia em pixels entre as teclas
'BGM' => 'Battle4' #Música do mini-game(se deixar desse modo 'BGM' => '' será a música do mapa atual)
}
#--------------------------------------------------------------------------
# Game[1]
#--------------------------------------------------------------------------
Game[1] = {
'Base_Image' => 'Back_Time', # Gráfico de fundo de tela
'Front_Image' => '', # Gráfico da frente da tela
'Bar_Image' => 'Time_Bar', #Gráfico da barra de tempo
'Bar_Position' => [120, 127], #Posição da barra [Posição X, Posição Y]
'Bar_Direction' => 'Horizontal', #Direção da barra e do input (Horizontal ou Vertical)
'Time' => 9, # Tempo em segundos para falhar o mini-game
'Keys' => 15, # Teclas que irão aparecer para o jogador(apenas válido para a opção random)
'Move_Speed' => 2, # Velocidade do movimento das teclas
'Random?' => true, # Criar jogo aleatório a partir das teclas?
#Sequencia, se o jogo for aleatório será as teclas de input, se não, será na mesma ordem adicionado aqui.
'Sequence' => ['X', 'Z', 'A', 'S', 'LEFT', 'RIGHT', 'DOWN', 'UP'], 
'Start_Pos' => [120, 160], #Posição Inicial das teclas [Posição X, Posição Y]
'Distance' => 35, #Distancia em pixels entre as teclas
'BGM' => 'Battle4' #Música do mini-game(se deixar desse modo 'BGM' => '' será a música do mapa atual)
}
#--------------------------------------------------------------------------
# Game[2]
#--------------------------------------------------------------------------
Game[2] = {

'Base_Image' => 'Back_Time', # Gráfico de fundo de tela
'Front_Image' => '', # Gráfico da frente da tela
'Bar_Image' => 'Time_Bar', #Gráfico da barra de tempo
'Bar_Position' => [120, 127], #Posição da barra [Posição X, Posição Y]
'Bar_Direction' => 'Horizontal', #Direção da barra e do input (Horizontal ou Vertical)
'Time' => 7, # Tempo em segundos para falhar o mini-game
'Keys' => 45, # Teclas que irão aparecer para o jogador(apenas válido para a opção random)
'Move_Speed' => 15, # Velocidade do movimento das teclas
'Random?' => true, # Criar jogo aleatório a partir das teclas?
#Sequencia, se o jogo for aleatório será as teclas de input, se não, será na mesma ordem adicionado aqui.
'Sequence' => ['Z'], 
'Start_Pos' => [120, 160], #Posição Inicial das teclas [Posição X, Posição Y]
'Distance' => 30, #Distancia em pixels entre as teclas
'BGM' => 'Battle5' #Música do mini-game(se deixar desse modo 'BGM' => '' será a música do mapa atual)
}

#==============================================================================
#==============================================================================
# ******** ABAIXO COMEÇA O SCRIPT, NÃO MODIFICAR ****************
#==============================================================================
#==============================================================================


  def self.chosen_game(id = nil)
	@game_id = id unless id == nil
	return @game_id
  end
  def self.chosen_switch(switch = nil)
	@switch = switch unless switch == nil
	return @switch
  end
   def self.allow_error(error = nil)
	@error = error unless error == nil
	return @error
  end
end


#==============================================================================
# ** Scene_TimeBattle
#------------------------------------------------------------------------------
#  Esta classe executa o processamento da Time Input
#==============================================================================

class Scene_TimeBattle < Scene_MenuBase
include Lune_Time_Input
  #--------------------------------------------------------------------------
  # * Inicialização do processo
  #--------------------------------------------------------------------------
  def start
	@count = 0
    super
	get_variables
  @saved_bgm = RPG::BGM.last
  RPG::BGM.new(@game['BGM']).play if @game['BGM'] != ''
	create_base_pictures
  end
  #--------------------------------------------------------------------------
  # * Inicialização das variáveis
  #--------------------------------------------------------------------------
  def get_variables
  	@game_id = Lune_Time_Input.chosen_game
    @game_switch = Lune_Time_Input.chosen_switch
    @allow_error = Lune_Time_Input.allow_error
    @game = Game[@game_id]
    @get_max_time = @game['Time']
    if @game['Random?']
      @get_max_keys = @game['Keys']
      @keys_array = Array.new
      @get_max_keys.times {@keys_array << @game['Sequence'].shuffle.first}
    else
      @get_max_keys = [@game['Keys'], @game['Sequence'].size].min
      @keys_array = @game['Sequence']
    end
    @keys_max = @keys_array.size
    @process_result = false
  end
  #--------------------------------------------------------------------------
  # * Inicialização das imagens
  #--------------------------------------------------------------------------
  def create_base_pictures
    @base_sprite = Sprite.new
    @base_sprite.bitmap = Cache.time_input(@game['Base_Image'])
    @bar_sprite = Sprite.new
    @bar_sprite.bitmap = Cache.time_input(@game['Bar_Image'])
    @bar_sprite.x = @game['Bar_Position'][0]
    @bar_sprite.y = @game['Bar_Position'][1]
    @front_sprite = Sprite.new
    @front_sprite.bitmap = Cache.time_input(@game['Front_Image'])
    @success = Sprite.new
    @success.bitmap = Cache.time_input(Success)
    @success.ox = @success.bitmap.width/2
    @success.oy = @success.bitmap.height/2
    @success.x = Graphics.width/2
    @success.y = Graphics.height/2
    @success.z = 100
    @success.zoom_y = 0
    @failure = Sprite.new
    @failure.bitmap = Cache.time_input(Failure)
    @failure.ox = @failure.bitmap.width/2
    @failure.oy = @failure.bitmap.height/2
    @failure.x = Graphics.width/2
    @failure.y = Graphics.height/2
    @failure.z = 100
    @failure.zoom_y = 0
    @buttons_pics = Array.new
    for n in 0...@keys_array.size
      @buttons_pics << Sprite.new
      @buttons_pics[n].bitmap = Cache.time_input(@keys_array[n])
      if @game['Bar_Direction'] == 'Horizontal'
        @buttons_pics[n].x = @game['Start_Pos'][0] + @game['Distance'] * n
        @buttons_pics[n].y = @game['Start_Pos'][1]
      else
        @buttons_pics[n].x = @game['Start_Pos'][0]
        @buttons_pics[n].y = @game['Start_Pos'][1] + @game['Distance'] * n
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Atualização de cena
  #--------------------------------------------------------------------------
  def update
    super
    get_result
    move_buttons
    if @processing_result
      process_result
      return 
    end
    update_bar
  end
  #--------------------------------------------------------------------------
  # * Inicialização da barra de tempo
  #--------------------------------------------------------------------------
  def update_bar
    if @game['Bar_Direction'] == 'Horizontal'
      @bar_sprite.zoom_x = 1.0 - (@count.to_f / (@game['Time'] * Graphics.frame_rate))
    else
      @bar_sprite.zoom_y = 1.0 - (@count.to_f / (@game['Time'] * Graphics.frame_rate))
    end
    @count += 1
  end
  #--------------------------------------------------------------------------
  # * Obtenção do resultado
  #--------------------------------------------------------------------------
  def get_result
    return if @processing_result
    if @keys_array.empty?
      call_victory
      return
    end
    if @count > (@game['Time'] * Graphics.frame_rate)
      call_defeat
      return
    end
    unless check_input
      unless @allow_error
        call_defeat
        return
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Verificador de teclas
  #--------------------------------------------------------------------------
  def check_input
    Keys_Config.each{|key| 
    if Input.trigger?(Keys_Config.fetch(key[0]).first) 
      p @keys_array.first
      return false if key[0] != @keys_array.first
      Sound.play_ok
      @keys_array.shift
    end
    }
    return true
  end
  #--------------------------------------------------------------------------
  # * Chamada de sucesso
  #--------------------------------------------------------------------------
  def call_victory
     RPG::SE.new(Victory_SE).play
     @victory = true
     @processing_result = true
   end
  #--------------------------------------------------------------------------
  # * Chamada de falha
  #--------------------------------------------------------------------------
  def call_defeat
     RPG::SE.new(Defeat_SE).play
     @victory = false
     @processing_result = true
   end
  #--------------------------------------------------------------------------
  # * Movimentação das Imagens
  #--------------------------------------------------------------------------
  def move_buttons
    num_dif = @keys_max - @keys_array.size
    if @keys_array.empty?
      @buttons_pics[num_dif - 1].opacity -= 20
      return
    end
    if @buttons_pics[num_dif].x > @game['Start_Pos'][0] || @buttons_pics[num_dif].y > @game['Start_Pos'][1]
      for n in (num_dif - 1)...@keys_max
        if @game['Bar_Direction'] == 'Horizontal'
          @buttons_pics[n].x -= @game['Move_Speed']
        else
          @buttons_pics[n].y -= @game['Move_Speed']
        end
      end
      @buttons_pics[num_dif - 1].opacity -= 20
    end
    if num_dif > 0
      @buttons_pics[num_dif - 1].opacity = 0
      @buttons_pics[num_dif - 1].x = @game['Start_Pos'][0]
      @buttons_pics[num_dif - 1].y = @game['Start_Pos'][1]
    end
  end
  #--------------------------------------------------------------------------
  # * Processamento de Resultado
  #--------------------------------------------------------------------------
  def process_result
    if @victory
      if @success.zoom_y < 1
        @success.zoom_y += 0.05
      else
        @success.zoom_y = 1
        if Auto_Close == 0
          return_scene if Input.trigger?(:B)
        else
          (Auto_Close*60).times { Graphics.update }
          terminate_graphics
          return_scene
        end
      end
    else
      if @failure.zoom_y < 1
        @failure.zoom_y += 0.05
      else
        @failure.zoom_y = 1
        if Auto_Close == 0
          return_scene if Input.trigger?(:B)
        else
          (Auto_Close*60).times { Graphics.update }
          terminate_graphics
          return_scene
        end
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Finalização da Cena
  #--------------------------------------------------------------------------
  def terminate_graphics
    $game_switches[@game_switch] = @victory
    @saved_bgm.replay if @saved_bgm
    @base_sprite.bitmap.dispose
    @base_sprite.dispose
    @bar_sprite.bitmap.dispose
    @bar_sprite.dispose
    @front_sprite.bitmap.dispose
    @front_sprite.dispose
    @success.bitmap.dispose
    @success.dispose
    @failure.bitmap.dispose
    @failure.dispose
    @buttons_pics.each{|button| button.bitmap.dispose; button.dispose}
    @buttons_pics = Array.new
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
  # * comando de Input Scene
  #--------------------------------------------------------------------------
  def time_input(id, switch, error)
	Lune_Time_Input.chosen_game(id)
	Lune_Time_Input.chosen_switch(switch)
	Lune_Time_Input.allow_error(error)
  SceneManager.call(Scene_TimeBattle)
  wait(1)
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
  def self.time_input(filename)
    load_bitmap("Graphics/Time_Input/", filename)
  end
end