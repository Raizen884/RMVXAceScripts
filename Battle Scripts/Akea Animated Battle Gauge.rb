#=======================================================
#        Akea Animated Battle Gauge
# Author: Raizen
# Community: http://www.centrorpg.com/
# Compatibility: RMVXAce
# Demo: http://www.mediafire.com/file/oonw668494knu4g/Akea_Animated_Battle_Gauge.exe
#=======================================================
# Instructions: Put this script above main, and configure the following
# You can configure different gauges for each enemy using this on the
# enemy notetag:
# <akea_hud n>

# Example <akea_hud 2> for gauge 2

# Where n is the id of one of the gauges configured below, 
# if you do not configure this on notetag, it will automatically consider
# the gauge with id 0.

# =========================Don't Modify==============================
$imported ||= Hash.new
$imported[:akea_animated_enemy_gauge] = true
module Akea_AEG
  

Enemy_Gauge = Hash.new

# =========================Não modificar==============================



# Here you can configure as many gauges as you want, 
# there are no limits.

#==============================================================
# -- Enemy_Gauge[0] - Normal Gauge with 3 bars
#==============================================================
Enemy_Gauge[0] = {
:Gauge_Image => 'Enemy_Hud', # Image on Graphics/Akea for The Hud
:Bar_Image => ['Enemy_Bar', 'Enemy_Bar2', 'Enemy_Bar3'], # Image on Graphics/Akea for The Bars
:center => 'enemy_bottom', #enemy_bottom, enemy_top or global
:position => [-50, 0], #position correction
:bar_position => [13, 8], #bar position correction
:z => 30, # z of the bars, in case you need it above or below other images
:opening_animation_time => 30, # opening animation time
:animation_time => 10, # time of animation when the gauge is affected
:sound => 'Attack3' # Sound when the bar is filling up
}
#==============================================================
# -- Enemy_Gauge[1] - No Gauge, use this to not have any gauge for
# this enemy
#==============================================================
Enemy_Gauge[1] = {
:Gauge_Image => '', # Image on Graphics/Akea for The Hud
:Bar_Image => [''], # Image on Graphics/Akea for The Bars
:center => 'enemy_top', #enemy_bottom, enemy_top or global
:position => [0, 0], #position correction
:bar_position => [20, 20], #bar position correction
:z => 30, # z of the bars, in case you need it above or below other images
:opening_animation_time => 0, # opening animation time
:animation_time => 0, # time of animation when the gauge is affected
:sound => '' # Sound when the bar is filling up
}
#==============================================================
# -- Enemy_Gauge[2] - Boss Gauge with 4 bars
#==============================================================
Enemy_Gauge[2] = {
:Gauge_Image => 'Boss_Hud', # Image on Graphics/Akea for The Hud
:Bar_Image => ['Boss_Bar', 'Boss_Bar2', 'Boss_Bar3', 'Boss_Bar4'], # Image on Graphics/Akea for The Bars
:center => 'global', #enemy_bottom, enemy_top or global
:position => [165, 60], #position correction
:bar_position => [13, 14], #bar position correction
:z => 30, # z of the bars, in case you need it above or below other images
:opening_animation_time => 100, # opening animation time
:animation_time => 30, # time of animation when the gauge is affected
:sound => 'Thunder12' # Sound when the bar is filling up
}
end

#==============================================================================
# ** Spriteset_Battle
#------------------------------------------------------------------------------
#  Esta classe reune os sprites da tela de batalha. Esta classe é usada 
# internamente pela classe Scene_Battle. 
#==============================================================================

class Spriteset_Battle
attr_reader :enemy_sprites
end

#==============================================================================
# ** Scene_Battle
#------------------------------------------------------------------------------
#  Esta classe executa o processamento da tela de batalha.
#==============================================================================

class Scene_Battle < Scene_Base
alias :akea_aeg_start :start
alias :akea_aeg_terminate :terminate
alias :akea_aeg_update_basic :update_basic
alias :akea_aeg_refresh_status :refresh_status
  #--------------------------------------------------------------------------
  # * Renovação das informações da janela de atributos
  #--------------------------------------------------------------------------
  def refresh_status
    @currentAegTimeUpdate = @maxAegTimeUpdate
    akea_aeg_refresh_status
  end
  #--------------------------------------------------------------------------
  # * Inicialização do processo
  #--------------------------------------------------------------------------
  def start
    akea_aeg_start
    create_aeg_variables
    create_aeg_gauges
  end
  #--------------------------------------------------------------------------
  # * Atualização da tela (básico)
  #--------------------------------------------------------------------------
  def update_basic
    update_aeg_gauge_update unless @maxAegTime == 0
    update_aeg_modify unless @currentAegTimeUpdate == 0  
    akea_aeg_update_basic
  end
  #--------------------------------------------------------------------------
  # * Updates the gauges
  #--------------------------------------------------------------------------
  def update_aeg_gauge_update
    RPG::SE.new(@gauge_Aeg_Sound).play
    for n in 0...$game_troop.members.size
    (@currentAegTimeUpdate).times {|i| akea_aeg_update_basic if i < (@currentAegTimeUpdate);
                                      update_aeg_gauges_collapse(n, 255 - 255 * (i + 1) / @currentAegTimeUpdate);
                                      }    
    end
    (@maxAegTime).times {|i| akea_aeg_update_basic if i < (@maxAegTime);
                                      update_aeg_gauges_opening((10000 * (i + 1))/@maxAegTime);
                                      }
    for n in 0...$game_troop.members.size
      @akeaAegBar[n].each {|g| g.zoom_x = 1}
      $game_troop.members[n].nil? ? @akeaAegConfig[n][3] = 0 : @akeaAegConfig[n][3] = $game_troop.members[n].hp * 10000 / $game_troop.members[n].mhp
    end
    @maxAegTime = 0;
  end
  #--------------------------------------------------------------------------
  # * Updates the gauges if the HP is modifies
  #--------------------------------------------------------------------------
  def update_aeg_modify
    @currentAegTimeUpdate -= 1
    update_aeg_gauges_opening(10000 - (10000 * @currentAegTimeUpdate / @maxAegTimeUpdate))
    for n in 0...$game_troop.members.size
      if $game_troop.members[n].dead?
        next if @akeaAegGauge[n].opacity == 0
        update_aeg_gauges_collapse(n, (255 * (@maxAegTimeUpdate - @currentAegTimeUpdate))/@currentAegTimeUpdate)
 
        @akeaAegBar[n].each {|g| g.zoom_x = 0}
        @akeaAegConfig[n][3] = 0
      else
        @akeaAegConfig[n][3] = $game_troop.members[n].hp * 10000 / $game_troop.members[n].mhp if @currentAegTimeUpdate == 0
      end
    end
     
   end
  #--------------------------------------------------------------------------
  # * Updates collapse Animation
  #--------------------------------------------------------------------------
  def update_aeg_gauges_collapse(n, op)
    @akeaAegBar[n].each{|g| g.opacity = 255 - op}
    @akeaAegGauge[n].opacity = 255 - op
  end
  #--------------------------------------------------------------------------
  # * Updates the gauge bars
  #--------------------------------------------------------------------------
  def update_aeg_gauges_opening(currentHP)
    for n in 0...$game_troop.members.size
      beginHP = @akeaAegConfig[n][3]
      endHP = $game_troop.members[n].hp * 10000 / $game_troop.members[n].mhp
      range = (endHP - beginHP) * currentHP / 10000
      currentHP_temp = (beginHP + range)/10
      gauge = @akeaAegConfig[n][2] * currentHP_temp / 1000
      gauge -=1 if gauge > 0 && currentHP_temp == 1000
      @akeaAegBar[n][gauge].zoom_x = currentHP_temp * @akeaAegConfig[n][2] / 1000.0 - gauge
      @akeaAegBar[n][gauge - 1].zoom_x = 1 if gauge > 0
      @akeaAegBar[n][gauge + 1].zoom_x = 0 if @akeaAegBar[n].size > (gauge + 1)
    end
  end
  #--------------------------------------------------------------------------
  # * Creates Gauge Variables
  #--------------------------------------------------------------------------
  def create_aeg_variables
    @maxAegTime = 0
    @maxAegTimeUpdate = 0
    @currentAegTimeUpdate = 0
    @currentAegTime = 0
  end
  #--------------------------------------------------------------------------
  # * Creates Gauge Graphics
  #--------------------------------------------------------------------------
  def create_aeg_gauges
    @akeaAegGauge = Array.new
    @akeaAegBar = Array.new
    @akeaAegConfig = Array.new
    for n in 0...$game_troop.members.size
      $game_troop.members[n].enemy.note =~ /<akea_hud (\d+)>/i ? i = $1.to_i : i = 0
      @akeaAegGauge[n] = Sprite.new
      @akeaAegBar[n] = Array.new
      @akeaAegGauge[n].bitmap = Cache.akea(Akea_AEG::Enemy_Gauge[i][:Gauge_Image])
      @akeaAegGauge[n].x = akea_aeg_gauge_position(0, n, Akea_AEG::Enemy_Gauge[i][:center], Akea_AEG::Enemy_Gauge[i][:position][0])
      @akeaAegGauge[n].y = akea_aeg_gauge_position(1, n, Akea_AEG::Enemy_Gauge[i][:center], Akea_AEG::Enemy_Gauge[i][:position][1])
      for b in 0...Akea_AEG::Enemy_Gauge[i][:Bar_Image].size
        @akeaAegBar[n][b] = Sprite.new
        @akeaAegBar[n][b].bitmap = Cache.akea(Akea_AEG::Enemy_Gauge[i][:Bar_Image][b])
        @akeaAegBar[n][b].x = akea_aeg_gauge_position(0, n, Akea_AEG::Enemy_Gauge[i][:center], Akea_AEG::Enemy_Gauge[i][:position][0])
        @akeaAegBar[n][b].y = akea_aeg_gauge_position(1, n, Akea_AEG::Enemy_Gauge[i][:center], Akea_AEG::Enemy_Gauge[i][:position][1])
        @akeaAegBar[n][b].x += Akea_AEG::Enemy_Gauge[i][:bar_position][0]
        @akeaAegBar[n][b].y += Akea_AEG::Enemy_Gauge[i][:bar_position][1]
        @akeaAegBar[n][b].zoom_x = 0
        @akeaAegBar[n][b].opacity = 0
      end
      @akeaAegGauge[n].opacity = 0
      @maxAegTime = Akea_AEG::Enemy_Gauge[i][:opening_animation_time] if @maxAegTime < Akea_AEG::Enemy_Gauge[i][:opening_animation_time]
      @currentAegTime = @maxAegTime
      @maxAegTimeUpdate = Akea_AEG::Enemy_Gauge[i][:animation_time] if @maxAegTimeUpdate < Akea_AEG::Enemy_Gauge[i][:animation_time]
      @currentAegTimeUpdate = @maxAegTimeUpdate
      @akeaAegConfig[n] = [Akea_AEG::Enemy_Gauge[i][:animation_time], Akea_AEG::Enemy_Gauge[i][:opening_animation_time], @akeaAegBar[n].size, 0]
    end
    @gauge_Aeg_Sound = Akea_AEG::Enemy_Gauge[i][:sound]
  end
  #--------------------------------------------------------------------------
  # * Adjusts Gauge Position
  #--------------------------------------------------------------------------
  def akea_aeg_gauge_position(axis, n, center, position)
    if axis == 0
      case center
        when 'enemy_bottom'
          pos = $game_troop.members[n].screen_x + position
        when 'enemy_top'
          pos = $game_troop.members[n].screen_x + position
        when 'global'
          pos = position
      end
    else
      case center
        when 'enemy_bottom'
          pos = $game_troop.members[n].screen_y + position
        when 'enemy_top'
          pos = $game_troop.members[n].screen_y + position - @spriteset.enemy_sprites[n].height
        when 'global'
          pos = position
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Finalização do processo
  #--------------------------------------------------------------------------
  def terminate
    @akeaAegGauge.each{|battler|battler.bitmap.dispose; battler.dispose}
    for n in 0...@akeaAegBar.size
      @akeaAegBar[n].each{|battler|battler.bitmap.dispose; battler.dispose}
    end
    akea_aeg_terminate
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
  # * Carregamento dos gráficos de animação
  #     filename : nome do arquivo
  #     hue      : informações da alteração de tonalidade
  #--------------------------------------------------------------------------
  def self.akea(filename)
    load_bitmap("Graphics/akea/", filename)
  end
end