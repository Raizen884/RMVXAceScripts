#=======================================================
#        Akea Battle Results
# Author: Raizen
# Community: http://www.centrorpg.com/
# Compatibility: RMVXAce
# Demo: http://www.mediafire.com/file/ibi0weas2503ctn/Akea+Battle+Results.exe
#=======================================================
# Instructions: The scripts adds a result screen to the battle, it
# shows all information the default one does, but with more information like
# damage dealt, damage taken, a ranking for how the battle went.
# This also gives a much more visual result then the usual

# =========================Don't Modify==============================
$imported ||= Hash.new
$imported[:akea_battle_results] = true

module Akea_AB
Fonte_Config = []
# =========================Don't Modify==============================
#--------------------------------------------------------------------
#----- Images Configuration -----
# Images must be on the folder Graphics/akea of your project
# Configure with the image name
#--------------------------------------------------------------------

# Results image back 
ImageBack = 'afterBattleResults'

# Image that will compliment the Result
Image = 'afterMath'
# This is the distance between the information
StartY = 70
DistanceY = 50

# Ranking Star image
ImageStar = 'estrela'

# Star positions in [x axis, y axis]
ImageStarPosition = [
[114, 218], # 1 star
[154, 218], # 2 stars
[194, 218], # 3 stars
[235, 218], # 4 stars
[276, 218]  # 5 stars
]

# Rate the opacity grows
OpacityRate = 10

# Difference in opacity between the information
OpacityDifference = 100

# Font configuration of the information
Fonte_Config[0] = 
{
:color => [200, 200, 200],
:font => 'Vecna', #leave empty ('') if you want to use default font
:size => 24,
:bold => false,
:italic => false
}

# Information that will be shown on the results,
# You can alter as you like, the tags that are available 
# are the following
# <Exp> - Total Experience
# <Gold> - Total Gold
# <Time> - Total Battle Time
# <Actor> - Individual Records, works with both:
# <Level> - If actor has leveled up
# <Skill> - If actor learned a new skill
# <Total Damage> - Total Damage made
# <Total Damage Taken> - Total Damage Taken
Info =
["Total Experience: <Exp>",
"Total Gold: <Gold>",
"Total Battle Time: <Time>",
"Adquired the Item: <Item>",
"<Actor> adquired the Level: <Level>",
"<Actor> learned the Skill: <Skill>",
"Total Damage dealt: <Total Damage>",
"Total Damage taken: <Total Damage Taken>",
]


# Font configuration for the individual Results
Fonte_Config[1] = 
{
:color => [255, 255, 255],
:font => 'Vecna',
:size => 22,
:bold => false,
:italic => false
}


# Information for the individual Results, it follows as the following:

#[x position, text]
InfoIndividual =
[[20, "<Actor> "], [120, "Damage done: <Damage Done>"], [320, "Damage taken: <Damage Taken>"]]

#----------------------------------------------------------------------------------
# ========================= Here Starts the Script! ==============================
#----------------------------------------------------------------------------------

end
#==============================================================================
# ** Scene_Battle
#------------------------------------------------------------------------------
#  Esta classe executa o processamento da tela de batalha.
#==============================================================================

class Scene_Battle < Scene_Base
  alias :akea_AB_apply_item_effects :apply_item_effects
  #--------------------------------------------------------------------------
  # * Variáveis públicas
  #--------------------------------------------------------------------------
  attr_accessor   :status_window            # Janela de atributos
  #--------------------------------------------------------------------------
  # * Aplicação do efeito da habilidades/item
  #     target : alvo
  #     item   : habilidade/item
  #--------------------------------------------------------------------------
  def apply_item_effects(target, item)
    akea_AB_apply_item_effects(target, item)
    BattleManager.set_damage_AB(target, target.result.hp_damage)
  end
end
#==============================================================================
# ** BattleManager
#------------------------------------------------------------------------------
#  Este módulo gerencia o andamento da batalha.
#==============================================================================

module BattleManager 
  class << self
  alias :akea_AB_setup :setup
  #--------------------------------------------------------------------------
  # * Creates the After Battle Rank
  #--------------------------------------------------------------------------
  def make_akea_rank
    if getABTotalDamage > getABTotalTaken * 5
      @akeaAB_rank = 5
    elsif getABTotalDamage > getABTotalTaken * 2
      @akeaAB_rank = 4
    elsif getABTotalDamage > getABTotalTaken
      @akeaAB_rank = 3
    elsif getABTotalDamage > getABTotalTaken / 2
      @akeaAB_rank = 2
    elsif getABTotalDamage > getABTotalTaken / 5
      @akeaAB_rank = 1
    else
      @akeaAB_rank = 0
    end
  end
  #--------------------------------------------------------------------------
  # * Sets the user for damage capture
  #--------------------------------------------------------------------------
  def set_user_AB(user)
    return if user.enemy?
    @user_AB_index = $game_party.battle_members.index(user)
  end
  #--------------------------------------------------------------------------
  # * adds the damage taken and dealt
  #--------------------------------------------------------------------------
  def set_damage_AB(target, damage)
    if target.enemy?
      @user_AB[@user_AB_index][0] += damage
    else
      @user_AB_index = $game_party.battle_members.index(target)
      @user_AB[@user_AB_index][1] += damage
    end
  end
  #--------------------------------------------------------------------------
  # * Returns the damage dealt by the member n in the party - n is the index
  #--------------------------------------------------------------------------
  def akeaAB_damage(n)
    return  @user_AB[n][0]
  end
  #--------------------------------------------------------------------------
  # * Returns the damage took by the member n in the party - n is the index
  #--------------------------------------------------------------------------
   def akeaAB_taken(n)
    return  @user_AB[n][1]
  end
  #--------------------------------------------------------------------------
  # * Gets total damage Dealt
  #--------------------------------------------------------------------------
    def getABTotalDamage
      totaldamage = 0
      @user_AB.each{|dmg| totaldamage += dmg.first}
      totaldamage
    end
  #--------------------------------------------------------------------------
  # * Gets total damage Taken
  #--------------------------------------------------------------------------
     def getABTotalTaken
      totaldamage = 0
      @user_AB.each{|dmg| totaldamage += dmg.last}
      totaldamage
    end 
  #--------------------------------------------------------------------------
  # * Adds new skills to be shown
  #--------------------------------------------------------------------------
  def add_akeaAB_skill(user, skill)
    @user_AB_newSkills << [user, skill]
  end
  #--------------------------------------------------------------------------
  # * Adds new level to be shown
  #--------------------------------------------------------------------------
   def add_akeaAB_level(user, level)
    @user_AB_newLevel << [user, level]
  end 
  #--------------------------------------------------------------------------
  # * Configuração inicial
  #--------------------------------------------------------------------------
  def setup(troop_id, can_escape = true, can_lose = false)
    @time_AB = Time.now
    @user_AB = Array.new($game_party.battle_members.size) {[0,0]}
    @user_AB_index = 0
    @akeaAB_rank = 5
    @user_AB_newLevel = []
    @user_AB_newSkills = []
    akea_AB_setup(troop_id, can_escape = true, can_lose = false)
  end
  #--------------------------------------------------------------------------
  # * Exibição e aquisição de itens
  #--------------------------------------------------------------------------
    def gain_drop_items
      $game_troop.make_drop_items.each do |item|
        @items_akea_AB << item
        $game_party.gain_item(item, 1)
      end
      wait_for_message
    end
  #--------------------------------------------------------------------------
  # * Processes the Victory
  #--------------------------------------------------------------------------
    def process_victory
      @time_AB = Time.at((Time.now - @time_AB)).strftime("%M:%S")
      @items_akea_AB = []
      play_battle_end_me
      replay_bgm_and_bgs
      $game_party.gain_gold($game_troop.gold_total)
      gain_drop_items
      gain_exp
      SceneManager.scene.status_window.opacity = 0
      SceneManager.scene.status_window.contents_opacity = 0
      SceneManager.return
      battle_end(0)
      make_akea_rank
      create_akeaAB_windows
      create_akeaAB_rank
      update_akeaAB_windows_entry
      wait_akeaAB(30)
      update_akeaAB_windows_update
      dispose_akeaAB_all_windows
      return true
    end
  #--------------------------------------------------------------------------
  # * Creates Rank Images
  #--------------------------------------------------------------------------
    def create_akeaAB_rank
      @akeaAB_rank_image = []
      for n in 0...@akeaAB_rank
        @akeaAB_rank_image[n] = Sprite.new
        @akeaAB_rank_image[n].bitmap = Cache.akea(Akea_AB::ImageStar)
        @akeaAB_rank_image[n].x = Akea_AB::ImageStarPosition[n][0]
        @akeaAB_rank_image[n].y = Akea_AB::ImageStarPosition[n][1]
        @akeaAB_rank_image[n].z = 2
      end
    end
  #--------------------------------------------------------------------------
  # * Creates Result Window and Information
  #--------------------------------------------------------------------------
    def create_akeaAB_windows
      @akea_ab_actorWindow = Window_AkeaAB_Actors.new
      @akea_ab_window = Array.new
      @akea_ab_back = Sprite.new
      @akea_ab_back.bitmap = Cache.akea(Akea_AB::ImageBack)
      @akea_ab_back.z = 0
      @akea_ab_back.opacity = 0
      @akea_ab_actorWindow.contents_opacity = 0
      for n in 0...Akea_AB::InfoIndividual.size
        @akea_ab_actorWindow.create_characters_info($game_party.battle_members, Akea_AB::InfoIndividual[n][1], Akea_AB::InfoIndividual[n][0])
      end
      n = 0
      index = 0
      while Akea_AB::Info[n]
        if Akea_AB::Info[n].include?("<Level>")
          @user_AB_newLevel.each {|member| create_akea_AB_after(index, member, Akea_AB::Info[n]); index += 1}
        elsif Akea_AB::Info[n].include?("<Skill>")
          @user_AB_newSkills.each {|member| create_akea_AB_after(index, member, Akea_AB::Info[n]); index += 1}
        elsif Akea_AB::Info[n].include?("<Actor>")
          $game_party.battle_members.each {|member| create_akea_AB_after(index, member, Akea_AB::Info[n]); index += 1}
        elsif Akea_AB::Info[n].include?("<Item>")
          @items_akea_AB.each {|item| create_akea_AB_after(index, item, Akea_AB::Info[n]); index += 1}
        else        
          create_akea_AB_after(index, nil, Akea_AB::Info[n])
          index += 1
        end
        n += 1
      end
    end
  #--------------------------------------------------------------------------
  # * Creates individual Results information
  #--------------------------------------------------------------------------
    def create_akea_AB_after(index, subject, text)
      @akea_ab_window[index] = Sprite.new
      @akea_ab_window[index].bitmap = Cache.akea(Akea_AB::Image).dup
      @akea_ab_window[index].y = Akea_AB::StartY
      @akea_ab_window[index].y =  Graphics.height + Akea_AB::DistanceY
      @akea_ab_window[index].z = 1
      @akea_ab_window[index].opacity = 0
      if Akea_AB::Fonte_Config[0][:font] == ''
        @akea_ab_window[index].bitmap.font.name = Font.default_name
      else
        @akea_ab_window[index].bitmap.font.name = Akea_AB::Fonte_Config[0][:font]
      end
      @akea_ab_window[index].bitmap.font.color.set(*Akea_AB::Fonte_Config[0][:color])
      @akea_ab_window[index].bitmap.font.size = Akea_AB::Fonte_Config[0][:size]
      @akea_ab_window[index].bitmap.font.bold = Akea_AB::Fonte_Config[0][:bold]
      @akea_ab_window[index].bitmap.font.italic = Akea_AB::Fonte_Config[0][:italic]
      text = text.gsub("<Actor>", subject[0]) if text.include?("<Level>") || text.include?("<Skill>")
      text = text.gsub("<Level>", subject[1].to_s) if text.include?("<Level>")
      text = text.gsub("<Skill>", subject[1].to_s) if text.include?("<Skill>")
      text = text.gsub("<Actor>", subject.name) if text.include?("<Actor>")
      text = text.gsub("<Exp>", $game_troop.exp_total.to_s) if text.include?("<Exp>")
      text = text.gsub("<Gold>", $game_troop.gold_total.to_s) if text.include?("<Gold>")
      text = text.gsub("<Item>", subject.name) if text.include?("<Item>")
      text = text.gsub("<Time>", @time_AB) if text.include?("<Time>")
      text = text.gsub("<Total Damage>", getABTotalDamage.to_s) if text.include?("<Total Damage>")
      text = text.gsub("<Total Damage Taken>", getABTotalTaken.to_s) if text.include?("<Total Damage Taken>")
      @akea_ab_window[index].bitmap.draw_text(@akea_ab_window[index].bitmap.rect, text, 1)
    end
  #--------------------------------------------------------------------------
  # * Implicit Wait
  #--------------------------------------------------------------------------
    def wait_akeaAB(time)
      time.times {Graphics.update}
    end
  #--------------------------------------------------------------------------
  # * Updates the Result Entry
  #--------------------------------------------------------------------------
    def update_akeaAB_windows_entry
      while @akea_ab_window[0].opacity < 255
        for n in 0...@akea_ab_window.length
          @akea_ab_window[n].y -= Akea_AB::OpacityRate * Graphics.height / 500
          @akea_ab_window[n].y = Akea_AB::StartY + n * Akea_AB::DistanceY if @akea_ab_window[n].y < Akea_AB::StartY + n * Akea_AB::DistanceY
          @akea_ab_window[n].opacity += Akea_AB::OpacityRate if @akea_ab_window[n].opacity < 255 - Akea_AB::OpacityDifference * n     
        end
        @akea_ab_back.opacity += Akea_AB::OpacityRate
        @akea_ab_actorWindow.contents_opacity += Akea_AB::OpacityRate
        Graphics.update
      end
      while @akea_ab_window[0].y != Akea_AB::StartY
        for n in 0...@akea_ab_window.length
          @akea_ab_window[n].y -= Akea_AB::OpacityRate * Graphics.height / 500
          @akea_ab_window[n].y = Akea_AB::StartY + n * Akea_AB::DistanceY if @akea_ab_window[n].y < Akea_AB::StartY + n * Akea_AB::DistanceY
        end
        Graphics.update
      end
    end
  #--------------------------------------------------------------------------
  # * Updates the Information by the Input
  #--------------------------------------------------------------------------
    def update_akeaAB_windows_update
      while @akea_ab_window[0]
        update_akeaAB_windows_entry
        if Input.repeat?(:C)
          Sound.play_ok
          @akea_ab_window[0].bitmap.dispose
          @akea_ab_window[0].dispose
          @akea_ab_window.shift 
        end
        if Input.trigger?(:B)
          Sound.play_cancel
          return
        end
        Input.update
        Graphics.update
      end
    end
  #--------------------------------------------------------------------------
  # * Disposes all windows
  #--------------------------------------------------------------------------
    def dispose_akeaAB_all_windows
      @akea_ab_actorWindow.close
      @akea_ab_actorWindow.dispose
      @akeaAB_rank_image.each {|window| window.bitmap.dispose; window.dispose} if @akeaAB_rank_image
      @akea_ab_window.each{|window| window.bitmap.dispose; window.dispose}
      @akea_ab_back.bitmap.dispose
      @akea_ab_back.dispose
    end
  end
end

#==============================================================================
# ** Window_Help
#------------------------------------------------------------------------------
#  Esta janela exibe explicação de habilidades e itens e outras informações.
#==============================================================================

class Window_AkeaAB_Actors < Window_Base
include Akea_AB
  #--------------------------------------------------------------------------
  # * Inicialização do objeto
  #     line_number : número de linhas
  #--------------------------------------------------------------------------
  def initialize
    super(0, Graphics.height - fitting_height(4), Graphics.width, fitting_height(4))
      if Akea_AB::Fonte_Config[1][:font] == ''
        contents.font.name = Font.default_name
      else
        contents.font.name = Akea_AB::Fonte_Config[1][:font]
      end
      contents.font.color.set(*Akea_AB::Fonte_Config[1][:color])
      contents.font.size = Akea_AB::Fonte_Config[1][:size]
      contents.font.bold = Akea_AB::Fonte_Config[1][:bold]
      contents.font.italic = Akea_AB::Fonte_Config[1][:italic]
    self.opacity = 0
  end
  #--------------------------------------------------------------------------
  # * Writes Character information
  #--------------------------------------------------------------------------
  def create_characters_info(actors, text, x)
    for n in 0...actors.size
      new_text = text.gsub("<Actor>", actors[n].name) if text.include?("<Actor>")
      new_text = text.gsub("<Damage Done>", BattleManager.akeaAB_damage(n).to_s) if text.include?("<Damage Done>")
      new_text = text.gsub("<Damage Taken>", BattleManager.akeaAB_taken(n).to_s) if text.include?("<Damage Taken>")
      draw_text(x, n * fitting_height(0), Graphics.width, fitting_height(0), new_text, 0)
    end
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
alias :akeaAB_execute_damage :execute_damage
    #--------------------------------------------------------------------------
  # * Processamento do dano
  #     user : usuário
  #--------------------------------------------------------------------------
  def execute_damage(user)
    BattleManager.set_user_AB(user)
    akeaAB_execute_damage(user)
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
alias :akea_AB_display_level_up :display_level_up
  #--------------------------------------------------------------------------
  # * Mostra mensagem de aumento de nível
  #     new_skills : Conjunto de habilidades recém-adquiridas
  #--------------------------------------------------------------------------
  def display_level_up(new_skills)
    BattleManager.add_akeaAB_level(@name, @level)
    new_skills.each do |skill|
      BattleManager.add_akeaAB_skill(@name, skill.name)
    end
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