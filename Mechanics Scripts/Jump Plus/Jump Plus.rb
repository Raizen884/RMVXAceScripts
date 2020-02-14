#=======================================================
#         Jump Plus
# Autor : Raizen

# Descrição: O script corrigirá os bugs dos pulos, que
# é de atravessar tilesets e pular em tiles não passaveis.
# Adiciona também uma pequena função de pulo simples.
#=======================================================

module Lune_jump_plus
# tag de terreno para o pulo, para escolher tags de terreno
# vá no database, na aba tileset e procure a opção terreno.
# Terrenos com essa tag, o personagem não conseguirá pular
# sobre.
Tag = 1

# Switch que liga a tecla de pulo
Switch = 2
# Tecla de pulo
# coloque um : na frente, veja a seguir a lista
# X = Tecla A  ;  Y = Tecla S  ;  Z = Tecla D
# L = Tecla Q  ;  R = Tecla W  ;  SHIFT
Key = :X
# Som do Pulo
# nome do arquivo dentro de aspas ""
# se não quiser som coloque desse modo 
# Sound = ""
Sound = "Jump1"
# Atraso do Pulo em segundos/2
Jump_Delay = 2
#=======================
# Distancias dos pulos
#=======================
# Correndo
Run = 4
# Andando
Walk = 2
end

#===================================================================#
#======================= Aqui Começa o Script ======================#
#===================================================================#


#==============================================================================
# ** Game_Player
#------------------------------------------------------------------------------
#  Esta classe gerencia o jogador. 
# A instância desta classe é referenciada por $game_player.
#==============================================================================
class Game_Player < Game_Character
alias lune_jump jump
alias lune_initialize_jump initialize
alias lune_update_map update
  def initialize(*args)
    @jump_delay = Lune_jump_plus::Jump_Delay
    lune_initialize_jump(*args)
  end
  #--------------------------------------------------------------------------
  # * Atualização da tela
  #--------------------------------------------------------------------------
  def update
    @jump_delay += 1 if Graphics.frame_count % 30 == 1 && @jump_delay < Lune_jump_plus::Jump_Delay
    if Input.trigger?(:X) && $game_switches[Lune_jump_plus::Switch] && @jump_delay == Lune_jump_plus::Jump_Delay
      dash? ? (get_jump = Lune_jump_plus::Run) : (get_jump = Lune_jump_plus::Walk)
      get_jump = 0 unless moving?
      @jump_delay = 0
      RPG::SE.new(Lune_jump_plus::Sound).play
      case @direction 
      when 2
        jump(0, get_jump)
      when 4
        jump(-get_jump, 0)
      when 6
        jump(get_jump, 0)
      when 8
        jump(0, -get_jump)
      end
    end
    lune_update_map
  end
  #--------------------------------------------------------------------------
  # * Movimento de Pulo
  #--------------------------------------------------------------------------
  def jump(x_plus, y_plus)
    @get_to_x = 0
    @get_to_y = 0
    while @get_to_x.abs < x_plus.abs # Loop para a tag de terreno em x
      x_plus > 0 ? @get_to_x += 1 : @get_to_x -= 1
      break if $game_map.terrain_tag(@x + @get_to_x, @y) == Lune_jump_plus::Tag
    end
    while @get_to_y.abs < y_plus.abs # Loop para a tag de terreno em y
      y_plus > 0 ? @get_to_y += 1 : @get_to_y -= 1
      break if $game_map.terrain_tag(@x + @get_to_x, @y + @get_to_y) == Lune_jump_plus::Tag
    end  
    x_plus = @get_to_x
    y_plus = @get_to_y
    # Loop de passabilidade
    while !$game_map.check_passage(x_plus + @x, y_plus + @y, 0x0f)
      if x_plus.abs > y_plus.abs
        x_plus > 0 ? (x_plus -= 1) : (x_plus += 1 unless x_plus == 0)
      else
        y_plus > 0 ? (y_plus -= 1) : (y_plus += 1 unless y_plus == 0)
      end
      break if x_plus == 0 && y_plus == 0
    end
    super(x_plus, y_plus) 
    # Pulo dos seguidores
    if x_plus == 0 && y_plus == 0
      @followers.each {|follower| follower.jump(0, 0)}
    else
      @followers.each {|follower| follower.jump(@x - follower.x, @y - follower.y)}
    end
  end
end