#=======================================================
#        Akea Special Skill
# Autor: Raizen
# Comunidade: http://www.centrorpg.com/
# Compatibilidade: RMVXAce
# Permite uma tela exclusiva para certos skills, 
# esse script faz com que personagens que não participem da ação 
# não apareçam na tela, além de colocar um fundo atrás animado
#=======================================================

# =========================Não modificar==============================
$imported ||= Hash.new
$imported[:akea_special_skill] = true
module Akea_Special_Skill
Special_Back = []


#=====================================================================
#---------------- Configure o fundo de batalha --------------------------
#=====================================================================

# Basta adicionar desse modo
# Special_Back[id] = { NAO REPETIR o ID
#'X' => 3, #velocidade da tela em X
#'Y' => 2, #velocidade da tela em Y
#'bitmap' => 'Skill_Special_Back', #Nome da Imagem
#}

# Para chamar um skill como skill especial basta adicionar no bloco de notas
# do skill o seguinte.
#<a_special id>
# Aonde id é o id configurado abaixo
#=====================================================================
Special_Back[0] = {
'X' => 3, #velocidade da tela em X
'Y' => 2, #velocidade da tela em Y
'bitmap' => 'Skill_Special_Back', #Nome da Imagem
}
#=====================================================================
Special_Back[1] = {
'X' => 3, #velocidade da tela em X
'Y' => 2, #velocidade da tela em Y
'bitmap' => 'Skill_Special_Back', #Nome da Imagem
}


end
# =========================Não modificar==============================

#==============================================================================
# ** Spriteset_Battle
#------------------------------------------------------------------------------
#  Esta classe reune os sprites da tela de batalha. Esta classe é usada 
# internamente pela classe Scene_Battle. 
#==============================================================================

class Spriteset_Battle
alias :akea_special_initialize :initialize
  #--------------------------------------------------------------------------
  # * Inicialização do objeto
  #--------------------------------------------------------------------------
  def initialize(*args, &block)
    akea_special_initialize(*args, &block)
    create_special_battleback
  end
  #--------------------------------------------------------------------------
  # * Criação do sprite de fundo de batalha (piso)
  #--------------------------------------------------------------------------
  def create_special_battleback
    @akea_back_plane = Plane.new(@viewport1)
    @akea_back_plane.bitmap = Cache.akea('')
    @akea_back_plane.z = 0
    @akea_back_plane_move_x = 0
    @akea_back_plane_move_y = 0
    #@back1_sprite.opacity = 0
  end
  #--------------------------------------------------------------------------
  # * Modificar opacidade do inimigo
  #--------------------------------------------------------------------------
  def enemy_opacity(id, opacity)
    return unless id
    id = @enemy_sprites.size - id - 1
    @enemy_sprites[id].opacity = opacity
  end
  def actor_opacity(id, opacity)
    return unless id
    @actor_sprites[id].opacity = opacity
  end
  #--------------------------------------------------------------------------
  # * Mostrar todos os battlers
  #--------------------------------------------------------------------------
  def show_all_battlers
    @actor_sprites.each{|actor| actor.opacity = 255}
    for n in 0...@enemy_sprites.size
      @enemy_sprites[n].opacity = 255 unless $game_troop.members[@enemy_sprites.size - n - 1].dead?
    end
  end
  #--------------------------------------------------------------------------
  # * Movimento de fundo
  #--------------------------------------------------------------------------
  def special_plane_move
    @akea_back_plane.ox += @akea_back_plane_move_x
    @akea_back_plane.oy += @akea_back_plane_move_y
  end
  #--------------------------------------------------------------------------
  # * Adicionar opacidade no fundo
  #--------------------------------------------------------------------------
  def add_back_opacity
    return if @back1_sprite.opacity >= 255
    @back1_sprite.opacity += 25
    @back2_sprite.opacity += 25
  end
  #--------------------------------------------------------------------------
  # * Retirar opacidade no fundo
  #--------------------------------------------------------------------------
  def add_special_opacity
    return if @back1_sprite.opacity <= 0
    @back1_sprite.opacity -= 25
    @back2_sprite.opacity -= 25
  end
  #--------------------------------------------------------------------------
  # * Disposição do fundo de batalha (piso)
  #--------------------------------------------------------------------------
  def dispose_battleback1
    @akea_back_plane.bitmap.dispose
    @akea_back_plane.dispose
    @back1_sprite.bitmap.dispose
    @back1_sprite.dispose
  end
  #--------------------------------------------------------------------------
  # * Setar configurações do fundo
  #--------------------------------------------------------------------------
  def set_special_configuration(n)
    @akea_back_plane.bitmap.dispose
    @akea_back_plane.bitmap = Cache.akea(Akea_Special_Skill::Special_Back[n]['bitmap'])
    @akea_back_plane_move_x = Akea_Special_Skill::Special_Back[n]['X']
    @akea_back_plane_move_y = Akea_Special_Skill::Special_Back[n]['Y']
  end
end
#==============================================================================
# ** Scene_Battle
#------------------------------------------------------------------------------
#  Esta classe executa o processamento da tela de batalha.
#==============================================================================

class Scene_Battle < Scene_Base
alias :akea_special_update :update
alias :akea_special_process_action :process_action
alias :akea_special_process_action_end :process_action_end
alias :akea_special_use_item :use_item
  #--------------------------------------------------------------------------
  # * Uso de habilidades/itens
  #--------------------------------------------------------------------------
  def use_item
    akea_special_use_item
    @spriteset.show_all_battlers if @on_akea_special
  end
  #--------------------------------------------------------------------------
  # * Processamento do fim da ação
  #--------------------------------------------------------------------------
  def process_action_end
    akea_special_process_action_end
    stop_akea_special
  end
  #--------------------------------------------------------------------------
  # * Processamento de ações
  #--------------------------------------------------------------------------
  def process_action
    if $imported[:lune_animated_battle]
      akea_special_process_action
      return
    end
    if !@subject || !@subject.current_action
      @atbs_actions = []
      @subject = BattleManager.next_subject
      @reuse_targets = @subject.current_action.make_targets.compact if @subject && @subject.current_action
      if @subject && @subject.current_action
        battle_notes = @subject.current_action.item.note
        if @subject.current_action.item.id == 1 && @subject.actor? && @subject.equips[0]
          battle_notes = @subject.equips[0].note
        end
        for n in 0...battle_notes.size - 11
          if battle_notes[n..n+10] == "<a_special "
            msgbox("Requires Akea Special Skill!!") unless $imported[:akea_special_skill]
            y = 0
            y += 1 until battle_notes[n+11+y] == '>'
            insert_akea_special(battle_notes[n+11..n+11+y].to_i)
          end
        end
      end
    end
    akea_special_process_action
  end   
  #--------------------------------------------------------------------------
  # * Parar habilidade especial
  #--------------------------------------------------------------------------
  def stop_akea_special(n=1)
    @on_akea_special = false
  end
  #--------------------------------------------------------------------------
  # * Inserir habilidade especial
  #--------------------------------------------------------------------------
  def insert_akea_special(n)
    @on_akea_special = true
    @spriteset.set_special_configuration(n)
  end
  #--------------------------------------------------------------------------
  # * Inicialização do processo
  #--------------------------------------------------------------------------
  def update(*args, &block)
    if @on_akea_special
      @spriteset.add_special_opacity
    else
      @spriteset.add_back_opacity
    end
    @spriteset.special_plane_move 
    akea_special_update(*args, &block)
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