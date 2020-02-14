#===============================================================
# Reflex Script
# Compativel com RMVXAce
# Autor: Raizen
# Comunidade : www.centrorpg.com
# É permitido postar em outros lugares contanto que não seja mudado
# as linhas dos créditos.
#===============================================================
#===============================================================
# Descrição: O script fará com que seja reproduzido um reflexo na agua 
# ou outra superficie qualquer, basta colocar acima do main e seguir as
# instruções, o reflexo será reproduzido por eventos, personagens e 
# veiculos.
# Arquivos que tenham no nome [NOREFLEX] não terão reflexo.
# coloque aqui o valor da opacidade que terá os reflexo produzidos,
# para modifica-los durante o jogo, basta.
# Chamar Script: $reflexopacity = valor da opacidade.
# opacidade inicial.
$reflexopacity = 150
# coloque aqui o valor do corte em y que terá os reflexo produzidos,
# esse corte serve para identificar bordas de lagos, rios por exemplo.
# para modifica-los durante o jogo, basta.
# Chamar Script: $reflexborday = valor do corte.
# corte inicial.
$reflexborday = 8
# coloque aqui o valor do corte em x que terá os reflexo produzidos,
# esse corte serve para identificar bordas de lagos, rios por exemplo.
# para modifica-los durante o jogo, basta.
# Chamar Script: $reflexbordax = valor do corte.
# corte inicial.
$reflexbordax = 8
module Raizen_reflex
# Para configurar os tiles que vão refletir a imagem, basta ir no database
# Tilesets e terreno, o numero modificavel para cada tile, você indicará
# os tiles que refletem ou não a imagem.
# ID da tile que reflete a imagem.
Tile_ID = 1
end

#============================================================================
# Aqui começa o script
#============================================================================

#==============================================================================
# ** Sprite_Character
#------------------------------------------------------------------------------
#  Este sprite é usado para mostrar personagens. Ele observa uma instância
# da classe Game_Character e automaticamente muda as condições do sprite.
#==============================================================================
class Spriteset_Map
alias raizen_create_shadow create_characters
  def create_characters
    raizen_create_shadow
    $game_map.events.values.each do |event|
      @character_sprites.push(Sprite_Character_Shadow.new(@viewport1, event))
    end
    $game_map.vehicles.each do |vehicle|
      @character_sprites.push(Sprite_Character_Shadow.new(@viewport1, vehicle))
    end
    $game_player.followers.reverse_each do |follower|
    @character_sprites.push(Sprite_Character_Shadow.new(@viewport1, follower))
    end
    @character_sprites.push(Sprite_Character_Shadow.new(@viewport1, $game_player))
    @map_id = $game_map.map_id
  end
end

  
  
class Sprite_Character_Shadow < Sprite_Base
  #--------------------------------------------------------------------------
  # * Variáveis públicas
  #--------------------------------------------------------------------------
  attr_accessor :character
  #--------------------------------------------------------------------------
  # * Inicialização do objeto
  #     viewport  : camada
  #     character : personagem (Game_Character)
  #--------------------------------------------------------------------------
  def initialize(viewport, character = nil)
    super(viewport)
    @character = character
    @in_water = false
    if $game_map.terrain_tag(@character.x, @character.y + 1) != Raizen_reflex::Tile_ID
    @corte = @corte2 = 40 
    else
    @corte = @corte2 = 0
    end
    @corte3 = 0
    update
  end
  #--------------------------------------------------------------------------
  # * Disposição
  #--------------------------------------------------------------------------
  def dispose
    end_animation
    super
  end
  #--------------------------------------------------------------------------
  # * Atualização da tela
  #--------------------------------------------------------------------------
  def update
    super
    if @character.screen_x < 0 or @character.screen_x > 544 or @character.screen_y < -32 or @character.screen_y > 384 or character.character_name.include? "[NOREFLEX]"
    self.opacity = 0
    return 
    end
    update_bitmap
    update_position
    update_other
    setup_new_effect
    if $game_map.terrain_tag(@character.x, @character.y + 1) == Raizen_reflex::Tile_ID
    @getcorte = @character.screen_x
    @getcortey = @character.screen_y
      self.opacity = $reflexopacity
     if $game_map.terrain_tag(@character.x + 1, @character.y + 1) != Raizen_reflex::Tile_ID and @in_water == false and character.direction == 4
      if @getcorte2 != nil
      @corte2 = -@character.screen_x + @getcorte2 + $reflexbordax
      @corte2 = 48 - @corte2
      @corte = @corte2
      @corte3 = 0
      end
      update_src_rect_shadow2
    elsif $game_map.terrain_tag(@character.x - 1, @character.y + 1) != Raizen_reflex::Tile_ID and @in_water == false and character.direction == 6
      if @getcorte2 != nil
      @corte2 = @character.screen_x - @getcorte2 + $reflexbordax
      @corte2 = 48 - @corte2
      @corte3 = 0
      end
      update_src_rect_shadow2
    elsif @in_water == false and @corte3 != 0
      if @getcortey2 != nil
      @corte3 = @character.screen_y - @getcortey2 
      @corte3 = 32 - @corte3
      end
      update_src_rect_correct
    else
      @in_water = true
      @corte = @corte2 = 0
      update_src_rect_shadow2
    end
  elsif $game_map.terrain_tag(@character.x + 1, @character.y + 1) == Raizen_reflex::Tile_ID
      self.opacity = $reflexopacity
      self.opacity = 0 if character.direction != 4
      @corte = -@character.screen_x + @getcorte + $reflexbordax if @getcorte != nil
      update_src_rect_shadow
    elsif $game_map.terrain_tag(@character.x - 1, @character.y + 1) == Raizen_reflex::Tile_ID
      self.opacity = $reflexopacity
      self.opacity = 0 if character.direction != 6
      @corte = +@character.screen_x - @getcorte + $reflexbordax if @getcorte != nil
      update_src_rect_shadow
    elsif $game_map.terrain_tag(@character.x, @character.y + 2) == Raizen_reflex::Tile_ID
      self.opacity = $reflexopacity 
      self.opacity = 0 if character.direction != 8
      @corte = -@character.screen_y + @getcortey if @getcortey != nil
      update_src_rect_shadow 
    else
    self.opacity = 0
    @corte = @corte2 = 0
    @corte3 = 1
    update_src_rect_shadow
  end
end
  #--------------------------------------------------------------------------
  # * Aquisição da imagem do tileset que contém o tile designado
  #     tile_id : ID do tile
  #--------------------------------------------------------------------------
  def tileset_bitmap(tile_id)
    Cache.tileset($game_map.tileset.tileset_names[5 + tile_id / 256])
  end
  #--------------------------------------------------------------------------
  # * Atualização do bitmap de origem
  #--------------------------------------------------------------------------
  def update_bitmap
    if graphic_changed?
      @tile_id = @character.tile_id
      @character_name = @character.character_name
      @character_index = @character.character_index
      if @tile_id > 0
        set_tile_bitmap
      else
        set_character_bitmap_shadow
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Definição de mudança de gráficos
  #--------------------------------------------------------------------------
  def graphic_changed?
    @tile_id != @character.tile_id ||
    @character_name != @character.character_name ||
    @character_index != @character.character_index
  end
  #--------------------------------------------------------------------------
  # * Definição de bitmap do tile
  #--------------------------------------------------------------------------
  def set_tile_bitmap
    sx = (@tile_id / 128 % 2 * 8 + @tile_id % 8) * 32;
    sy = @tile_id % 256 / 8 % 16 * 32;
    self.bitmap = tileset_bitmap(@tile_id)
    self.src_rect.set(sx, sy, 32, 32)
    self.ox = 16
    self.oy = 32
  end
  #--------------------------------------------------------------------------
  # * Definição de bitmap do personagem
  #--------------------------------------------------------------------------
  def set_character_bitmap_shadow
    self.bitmap = Cache.character(@character_name)
    sign = @character_name[/^[\!\$]./]
    if sign && sign.include?('$')
      @cw = bitmap.width / 3
      @ch = bitmap.height / 4
    else
      @cw = bitmap.width / 12
      @ch = bitmap.height / 8
    end
    self.ox = @cw / 2
    self.oy = @ch
    self.angle = 180
    self.mirror = true
  end

    def update_src_rect_shadow
    @getcorte2 = @character.screen_x
    @getcortey2 = @character.screen_y
 @in_water = false   
    if @tile_id == 0
      index = @character.character_index
      pattern = @character.pattern < 3 ? @character.pattern : 1
      sx = (index % 4 * 3 + pattern) * @cw
      sy = (index / 4 * 4 + (@character.direction - 2) / 2) * @ch
      @corte = 0 if @corte == nil
    if $game_map.terrain_tag(@character.x - 1, @character.y + 1) != Raizen_reflex::Tile_ID
    self.src_rect.set(sx + @corte, sy, @cw - @corte, @ch - $reflexborday)
    elsif $game_map.terrain_tag(@character.x + 1, @character.y + 1) != Raizen_reflex::Tile_ID
    self.src_rect.set(sx, sy, @cw - @corte, @ch - $reflexborday)
    else
      self.src_rect.set(sx, sy, @cw, @ch - $reflexborday)
    end
    if $game_map.terrain_tag(@character.x, @character.y + 2) == Raizen_reflex::Tile_ID
    self.src_rect.set(sx, sy, @cw, @ch  - @corte - $reflexborday)
    end
  end
end

    def update_src_rect_shadow2
    if @tile_id == 0
      index = @character.character_index
      pattern = @character.pattern < 3 ? @character.pattern : 1
      sx = (index % 4 * 3 + pattern) * @cw
      sy = (index / 4 * 4 + (@character.direction - 2) / 2) * @ch
      @corte2 = 0 if @corte == nil
    if $game_map.terrain_tag(@character.x - 1, @character.y + 1) != Raizen_reflex::Tile_ID
    self.src_rect.set(sx + @corte2, sy,@cw - @corte2, @ch - $reflexborday)
    elsif $game_map.terrain_tag(@character.x + 1, @character.y + 1) != Raizen_reflex::Tile_ID
    self.src_rect.set(sx, sy,@cw - @corte2, @ch - $reflexborday)
    else
      self.src_rect.set(sx, sy, @cw, @ch - $reflexborday)
    end
  end
end
  def update_src_rect_correct
    if @tile_id == 0
      index = @character.character_index
      pattern = @character.pattern < 3 ? @character.pattern : 1
      sx = (index % 4 * 3 + pattern) * @cw
      sy = (index / 4 * 4 + (@character.direction - 2) / 2) * @ch
      @corte3 = 40 if @corte3 == nil
      self.src_rect.set(sx, sy, @cw, @ch  - @corte3 - $reflexborday)
    end
  end
  #--------------------------------------------------------------------------
  # * Atualização da posição
  #--------------------------------------------------------------------------
  def update_position
    self.x = @character.screen_x
    self.x -= @corte if $game_map.terrain_tag(@character.x + 1, @character.y + 1) != Raizen_reflex::Tile_ID and $game_map.terrain_tag(@character.x - 1, @character.y + 1) == Raizen_reflex::Tile_ID and character.direction != 2
    self.y = @character.screen_y
   self.z = @character.screen_z
  end
  #--------------------------------------------------------------------------
  # * Atualizações variadas
  #--------------------------------------------------------------------------
  def update_other
    self.opacity = @character.opacity
    self.blend_type = @character.blend_type
    self.bush_depth = @character.bush_depth
    self.visible = !@character.transparent
  end
  #--------------------------------------------------------------------------
  # * Definição de um novo efeito
  #--------------------------------------------------------------------------
  def setup_new_effect
    if !animation? && @character.animation_id > 0
      animation = $data_animations[@character.animation_id]
      start_animation(animation)
    end
  end
  #--------------------------------------------------------------------------
  # * Finalização da animação
  #--------------------------------------------------------------------------
  def end_animation
    super
    @character.animation_id = 0
  end
end