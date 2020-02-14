#=======================================================
#        Akea Battle Damage Pop-up
# Autor: Raizen
# Comunidade: http://www.centrorpg.com/
# Compatibilidade: RMVXAce
#
# Plug n' Play, basta colocar o script acima do main e configurar
# abaixo, o script permite exibição de dano nos inimigos e no personagem.
# Download Demo: http://www.mediafire.com/download/kzk164odmx5mquw/Akea+Damage+Popup.exe
#=======================================================
# =========================Não modificar==============================
$included ||= Hash.new
$included[:akea_battledamage] = true
module Akea_Damage
# =========================Não modificar==============================

  
# Número de casas de dano e cura
Max = 4
# Espaçamento dos números(em pixels)
Spacing = 15

# Correção da posição do dano em X
Correct_X = -50
# Correção da posição do dano em Y
Correct_Y = -60

# Tempo em frames que o pop-up fica exposto
Time = 15

# Tempo que leva para subir os números
Up_Time = 20

# Travar a batalha enquanto é exibido o dano 
# (true - normalmente bom para quando não tem battlers dos personagens)
# true = sim, false = não
Lock_Anime = true


# Imagens dos números, uma imagem contendo números de 0-9
# As imagens devem estar na pasta Graphics/Akea
Dmg_Image = 'Numbers' #Imagem de dano
Heal_Image = 'Numbers_H' # Imagem de cura
end

#==============================================================================
#------------------------------------------------------------------------------
#------------------------ A PARTIR DAQUI COMEÇA O SCRIPT!!  -------------------
#------------------------------------------------------------------------------
#==============================================================================


#==============================================================================
# ** Scene_Battle
#------------------------------------------------------------------------------
#  Esta classe executa o processamento da tela de batalha.
#==============================================================================

class Scene_Battle < Scene_Base
alias :akea_adp_start :start
alias :akea_adp_update :update
alias :adp_use_item :use_item
  #--------------------------------------------------------------------------
  # * Inicialização do processo
  #--------------------------------------------------------------------------
  def start
    start_popup_damage_config
    akea_adp_start
  end
  #--------------------------------------------------------------------------
  # * Inicialização da configuração de imagens e variáveis
  #--------------------------------------------------------------------------
  def start_popup_damage_config
    @adp_pics = Array.new
    @adp_damage_pop = Array.new
    @adp_count = 0
    for n in 0...Akea_Damage::Max
      @adp_pics[n] = Sprite.new
      @adp_pics[n].bitmap = Cache.akea(Akea_Damage::Dmg_Image)
      @adp_pics[n].z = 800
      @adp_pics[n].opacity = 0
    end
    for n in Akea_Damage::Max...Akea_Damage::Max*2
      @adp_pics[n] = Sprite.new
      @adp_pics[n].bitmap = Cache.akea(Akea_Damage::Heal_Image)
      @adp_pics[n].z = 800
      @adp_pics[n].opacity = 0
    end
    @adp_pw = @adp_pics[0].bitmap.width/10
    @adp_ph = @adp_pics[0].bitmap.height
  end
  #--------------------------------------------------------------------------
  # * Atualização do Processo
  #--------------------------------------------------------------------------
  def update(*args, &block)
    unless @adp_damage_pop.empty?
      perform_damage_popup 
      if Akea_Damage::Lock_Anime
        super
        return
      end
    end
    akea_adp_update(*args, &block)
  end
  #--------------------------------------------------------------------------
  # * Inicializar dano
  #--------------------------------------------------------------------------
  def perform_damage_popup
    @adp_count += 1
    if @adp_count == 1
      @adp_damage_pop.first[1] > 0 ? @dmg_count = 0 : @dmg_count = Akea_Damage::Max
       @adp_damage_pop.first[1] =  @adp_damage_pop.first[1].abs
      for n in @dmg_count...Akea_Damage::Max + @dmg_count
        frame = @adp_damage_pop.first[1] % 10
        if  @adp_damage_pop.first[1] == 0
          @adp_pics[n].src_rect.set(@adp_pw * 11, 0, @adp_pw, @adp_ph)
        else
          @adp_pics[n].src_rect.set(@adp_pw * frame, 0, @adp_pw, @adp_ph)
          @adp_pics[n].x = all_battle_members[@adp_damage_pop.first[0]].screen_x + Akea_Damage::Correct_X + (Akea_Damage::Max - (n- @dmg_count)) * Akea_Damage::Spacing
          @adp_pics[n].y = (n - @dmg_count)*4 + all_battle_members[@adp_damage_pop.first[0]].screen_y + Akea_Damage::Correct_Y
        end
        @adp_damage_pop.first[1] /= 10
      end
    elsif @adp_count < Akea_Damage::Up_Time + 4
      for n in @dmg_count...Akea_Damage::Max + @dmg_count
        @adp_pics[n].opacity += 20
        @adp_pics[n].y -= 2 if (@adp_count - (n - @dmg_count)*2 + Akea_Damage::Max) < Akea_Damage::Up_Time + 2
      end
    elsif @adp_count < Akea_Damage::Up_Time + 4 + Akea_Damage::Time

    elsif @adp_count < Akea_Damage::Up_Time + 20 + Akea_Damage::Time
      for n in @dmg_count...Akea_Damage::Max + @dmg_count
        @adp_pics[n].opacity -= 20
        @adp_pics[n].y += 1
      end
    else
      @adp_damage_pop.shift
      @adp_count = 0
    end
  end
  #--------------------------------------------------------------------------
  # * Uso de habilidades/itens
  #--------------------------------------------------------------------------
  def use_item
    adp_use_item
    @adp_count = 0
    all_battle_members.each {|member| 
    if member.hp_popup_call != 0 && member.use_sprite?
      @adp_damage_pop << [member.index, member.hp_popup_call] 
      @adp_damage_pop.last[0] += $game_party.battle_members.size if member.enemy?
    end
    member.hp_popup_call = 0
    }
  end
end
#==============================================================================
# ** Window_BattleLog
#------------------------------------------------------------------------------
#  Esta janela exibe o progresso da luta. Não exibe o quadro da
# janela, é tratado como uma janela por conveniência.
#==============================================================================

class Window_BattleLog < Window_Selectable
alias :adp_display_hp_damage :display_hp_damage
    #--------------------------------------------------------------------------
  # * Exibição de dano no HP
  #     target : alvo
  #     item   : habilidade/item
  #--------------------------------------------------------------------------
  def display_hp_damage(target, item)
    return if target.result.hp_damage == 0 && item && !item.damage.to_hp?
    if target.actor? && !target.use_sprite?
      adp_display_hp_damage(target, item)
    else
      if target.result.hp_damage > 0 && target.result.hp_drain == 0
        target.perform_damage_effect
      end
      Sound.play_recovery if target.result.hp_damage < 0
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
alias :adp_execute_damage :execute_damage
alias :adp_initialize :initialize
attr_accessor   :hp_popup_call
  #--------------------------------------------------------------------------
  # * Inicialização do objeto
  #--------------------------------------------------------------------------
  def initialize(*args, &block)
    @hp_popup_call = 0
    adp_initialize(*args, &block)
  end
  #--------------------------------------------------------------------------
  # * Processamento do dano
  #     user : usuário
  #--------------------------------------------------------------------------
  def execute_damage(user)
    @hp_popup_call = @result.hp_damage unless @result.hp_damage == 0
    adp_execute_damage(user)
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
    load_bitmap("Graphics/Akea/", filename)
  end
end