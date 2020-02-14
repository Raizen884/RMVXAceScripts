#=======================================================
#        Akea Battle Order
# Autor: Raizen
# Comunidade: http://www.centrorpg.com/
# Compatibilidade: RMVXAce
# Demo Download: http://www.mediafire.com/download/m4nlst0aa6gtkx6/Akea+Battle+Order.exe
#=======================================================
# =========================Não modificar==============================
$included ||= Hash.new
$included[:akea_battleorder] = true
module Akea_BattleOrder
Party_Images = []
Monster_Images = []
Enemy_Characters = []
# =========================Não modificar==============================

# Configuração começa Aqui

#=======================================================
#        INSTRUÇÕES
# Bem simples, basta colocar o script acima do main e configurar como é
# pedido abaixo, o script adiciona a função de mostrar a ordem de batalha,
# Combine esse script com outros add-ons de batalha para fazer algo bem legalz :)
#=======================================================


# Se vai usar face para personagem, true usa face, false usa charset
# Se true ele vai utilizar uma parte da imagem das faces
# Se false vai utilizar o charset
Party_Face = true

# Se vai usar face para inimigo, true usa face, false usa charset
# Se true ele vai utilizar uma parte da imagem dos battlers
# Se false vai utilizar o charset, configurado logo mais no script
Enemy_Face = true

# Imagem adicional que ficará na tela de batalha
Battle_Image = 'Battle_Order'
Image_X = 500
Image_Y = 40

# Imagem de moldura, caso os chars precisem de moldura
# Caso não queira adicionar uma moldura basta colocar como
# Mold = ''
Mold = 'mold2'

# Correção da posição da moldura
Mold_X = -4
Mold_Y = -4


# Correção do recorte das faces ou charsets
Size = {
'Sx' => 30, # em %, no eixo X ele irá recortar
'Sy' => 30, # em %, no eixo Y ele irá recortar
'X' => 60, # Tamanho da imagem recortada em X
'Y' => 30, # Tamanho da imagem recortada em Y

}
# Tempo que leva para os quadros se movimentarem em frames
Movement_Time = 5

# Posição de inicio dos quadros [x, y]
Start_Position = [465, 250]

# Posição de fim dos quadros [x, y]
End_Position = [465, 50]

# Opacidade das faces/characters de batalha,
# a opacidade do membro que está no turno é 255(100%), 
# A opacidade dos demais pode ser configurado aqui
Opacity = 150
# Imagens para personagens e inimigos # OPCIONAL
# Para utilizar uma imagem ao invés da face ou char,
# basta colocar
# Party_Images[id] = 'nome_da_imagem'
# Id sendo o id do actor no database

Party_Images[0] = 'Battle_Order'

# Monster_Images[id] = 'nome_da_imagem'
# Id sendo o id do inimigo no database
Monster_Images[0] = 'Battle_Order'

# Enemy_Characters, Configure APENAS se o Enemy_Face = false
# Caso contrário o script termina aqui.

#==============================================================================
# ** Enemy_Characters[0] => Padrão, caso o inimigo não tenha charset pre-configurado aqui.
#==============================================================================
# Padrão, caso o inimigo não tenha charset pre-configurado aqui.
Enemy_Characters[0] = {
'CharName' => 'Monster1', #Nome da imagem na pasta Characters
'Index' => 1, # Indice nos charsets com 8 chars, começando do 0.
}
#==============================================================================
# ** Enemy_Characters[1] => Slime
#==============================================================================
Enemy_Characters[1] = {
'CharName' => 'Monster2', #Nome da imagem na pasta Characters
'Index' => 2, # Indice nos charsets com 8 chars, começando do 0.
}
end


#==============================================================================
# ** Scene_Battle
#------------------------------------------------------------------------------
#  Esta classe executa o processamento da tela de batalha.
#==============================================================================

class Scene_Battle < Scene_Base
alias :akea_bo_start :start
alias :akea_bo_turn_start :turn_start
alias :akea_bo_update :update
alias :akea_bo_process_action :process_action
alias :akea_bo_terminate :terminate
  #--------------------------------------------------------------------------
  # * Inicialização do processo
  #--------------------------------------------------------------------------
  def start(*args, &block)
    @start_bo_anime = false
    @bo_turn_start = false
    create_battle_order_images
    @bo_action = []
    akea_bo_start(*args, &block)
  end
  #--------------------------------------------------------------------------
  # * Início do turno
  #--------------------------------------------------------------------------
  def turn_start
    @start_bo_anime = true
    akea_bo_turn_start
    @battle_order = []
    for n in 0...all_battle_members.size
      @battle_order.push(all_battle_members.index(BattleManager.akea_battle_turn[n])) if BattleManager.akea_battle_turn[n].alive?
    end
    @bo_pos_x = (Akea_BattleOrder::End_Position[0] - Akea_BattleOrder::Start_Position[0])/ @battle_order.size
    @bo_pos_y = (Akea_BattleOrder::End_Position[1] - Akea_BattleOrder::Start_Position[1])/ @battle_order.size
    @battle_order.reverse!
    @bo_correction = 0
    for n in 0...@battle_order.size
      @bo_battlers[@battle_order[n]].x = Akea_BattleOrder::Start_Position[0] + @bo_pos_x*n
      @bo_battlers[@battle_order[n]].y = Akea_BattleOrder::Start_Position[1] + @bo_pos_y*n
      @mold_battlers[@battle_order[n]].x = Akea_BattleOrder::Start_Position[0] + @bo_pos_x*n + Akea_BattleOrder::Mold_X
      @mold_battlers[@battle_order[n]].y = Akea_BattleOrder::Start_Position[1] + @bo_pos_y*n + Akea_BattleOrder::Mold_Y
      @bo_battlers[@battle_order[n]].z = 100 + n*2
      @mold_battlers[@battle_order[n]].z = 100 + n*2 + 1 
      @mold_battlers[@battle_order[n]].opacity = 0
    end
    @battle_order.reverse!
    @reserve_order = []
    @bo_timer_count = 0
  end
  #--------------------------------------------------------------------------
  # * Processamento de ações
  #--------------------------------------------------------------------------
  def process_action    
    return if @start_bo_anime
    return if scene_changing?
    if (!@subject || !@subject.current_action)
      if @battle_order.include?(all_battle_members.index(BattleManager.akea_battle_turn[0])) && BattleManager.akea_battle_turn[0] && BattleManager.akea_battle_turn[0].dead?
        @check_condition = BattleManager.akea_battle_turn
        n = 0
        while @check_condition[n] && @check_condition[n].dead?
          n += 1
          @bo_action.push(@battle_order.first)
          @reserve_order.push(@battle_order.first)
          @battle_order.shift
        end
        return unless @reserve_order.empty?
      end
      @bo_action.push(@battle_order.first)
      @battle_order.shift
    end
    if @bo_action.first
      @bo_battlers[@bo_action.first].opacity = 255 
      @mold_battlers[@bo_action.first].opacity = 255
    end
    akea_bo_process_action
  end
  
  #--------------------------------------------------------------------------
  # * Atualização da tela
  #--------------------------------------------------------------------------
  def update(*args, &block)
    if @start_bo_anime
      start_bo_pics 
      super
      return
    end
    unless moving_bo_order
      super
      return
    end
    akea_bo_update(*args, &block)
  end
  #--------------------------------------------------------------------------
  # * Animação de inicio
  #--------------------------------------------------------------------------
  def start_bo_pics
    for n in 0...@battle_order.size
      @bo_battlers[@battle_order[n]].opacity += 20 if @bo_battlers[@battle_order[n]].opacity < Akea_BattleOrder::Opacity
      @mold_battlers[@battle_order[n]].opacity += 20 if @mold_battlers[@battle_order[n]].opacity < Akea_BattleOrder::Opacity
    end
    @bo_Image.opacity += 20
    @start_bo_anime = false if @bo_Image.opacity == 255
  end
  #--------------------------------------------------------------------------
  # * Movimento das faces dos battlers
  #--------------------------------------------------------------------------
  def moving_bo_order
    return true if @bo_action.compact.empty?
    unless @bo_action.compact.empty?
      if @bo_action.first == nil
        @bo_action.shift
        return false
      end
      if @bo_battlers[@bo_action.first].opacity > 0
        @bo_battlers[@bo_action.first].opacity -= 30
        @mold_battlers[@bo_action.first].opacity -= 30
        @bo_Image.opacity -= 30 if @battle_order.size == 0
      else 
        @bo_timer_count += 1
        for n in 0...@battle_order.size
          if @bo_timer_count != Akea_BattleOrder::Movement_Time + 1
            @bo_battlers[@battle_order[n]].y += @bo_pos_y / Akea_BattleOrder::Movement_Time
            @bo_battlers[@battle_order[n]].x += @bo_pos_x / Akea_BattleOrder::Movement_Time
            @mold_battlers[@battle_order[n]].y += @bo_pos_y / Akea_BattleOrder::Movement_Time
            @mold_battlers[@battle_order[n]].x += @bo_pos_x / Akea_BattleOrder::Movement_Time
          else
            @bo_battlers[@battle_order[n]].y += @bo_pos_y % Akea_BattleOrder::Movement_Time
            @bo_battlers[@battle_order[n]].x += @bo_pos_x % Akea_BattleOrder::Movement_Time
            @mold_battlers[@battle_order[n]].y += @bo_pos_y % Akea_BattleOrder::Movement_Time
            @mold_battlers[@battle_order[n]].x += @bo_pos_x % Akea_BattleOrder::Movement_Time
          end
        end
        @reserve_order.compact!
        for n in 0...@reserve_order.size
          if @bo_timer_count != Akea_BattleOrder::Movement_Time + 1
            @bo_battlers[@reserve_order[n]].y += @bo_pos_y / Akea_BattleOrder::Movement_Time
            @bo_battlers[@reserve_order[n]].x += @bo_pos_x / Akea_BattleOrder::Movement_Time
            @mold_battlers[@reserve_order[n]].y += @bo_pos_y / Akea_BattleOrder::Movement_Time
            @mold_battlers[@reserve_order[n]].x += @bo_pos_x / Akea_BattleOrder::Movement_Time
          else
            @bo_battlers[@reserve_order[n]].y += @bo_pos_y % Akea_BattleOrder::Movement_Time
            @bo_battlers[@reserve_order[n]].x += @bo_pos_x % Akea_BattleOrder::Movement_Time
            @mold_battlers[@reserve_order[n]].y += @bo_pos_y % Akea_BattleOrder::Movement_Time
            @mold_battlers[@reserve_order[n]].x += @bo_pos_x % Akea_BattleOrder::Movement_Time
          end
        end
        if @bo_timer_count == Akea_BattleOrder::Movement_Time
          @bo_action.shift 
          @bo_timer_count = 0
        end
      end
    else
      @bo_action.shift
      @bo_timer_count = 0
    end
    false
  end
  #--------------------------------------------------------------------------
  # * Criação das imagens dos battlers
  #--------------------------------------------------------------------------
  def create_battle_order_images
    @bo_Image = Sprite.new
    @bo_Image.bitmap = Cache.akea(Akea_BattleOrder::Battle_Image)
    @bo_Image.x = Akea_BattleOrder::Image_X
    @bo_Image.y = Akea_BattleOrder::Image_Y
    @bo_Image.opacity = 0
    @bo_battlers = Array.new
    @mold_battlers = Array.new
    akea_size = Akea_BattleOrder::Size
    for n in 0...$game_party.battle_members.size
      act = $game_party.battle_members[n]
      @bo_battlers[n] = Sprite.new
      if Akea_BattleOrder::Party_Images[$game_party.battle_members[n].id]
        @bo_battlers[n].bitmap = Cache.akea(Akea_BattleOrder::Party_Images[$game_party.battle_members[n].id])
        @bo_battlers[n].opacity = 0
        @mold_battlers[n] = Sprite.new
        @mold_battlers[n].bitmap = Cache.akea('')
        next
      end
      if Akea_BattleOrder::Party_Face
        @bo_battlers[n].bitmap = Cache.face(act.face_name)
        face_index = act.face_index
        sx = @bo_battlers[n].bitmap.width/4 * akea_size['Sx'] / 100
        sy = @bo_battlers[n].bitmap.height/2 * akea_size['Sy'] / 100
        @bo_battlers[n].src_rect.set(sx + face_index % 4 * 96, sy + face_index / 4 * 96, akea_size['X'], akea_size['Y'])
      else
        @bo_battlers[n].bitmap = Cache.character(act.character_name)
        face_index = act.character_index
        sign = act.character_name[/^[\!\$]./]
        if sign && sign.include?('$')
          cw = @bo_battlers[n].bitmap.width
          ch = @bo_battlers[n].bitmap.height
          sx = @bo_battlers[n].bitmap.width * akea_size['Sx'] / 100
          sy = @bo_battlers[n].bitmap.height * akea_size['Sy'] / 100
        else
          cw = @bo_battlers[n].bitmap.width / 4
          ch = @bo_battlers[n].bitmap.height / 2
          sx = @bo_battlers[n].bitmap.width/4 * akea_size['Sx'] / 100
          sy = @bo_battlers[n].bitmap.height/2 * akea_size['Sy'] / 100
        end
        @bo_battlers[n].src_rect.set(sx + face_index % 4 * cw + cw/3, sy + face_index / 4 * ch, akea_size['X'], akea_size['Y'])
      end
      @bo_battlers[n].opacity = 0
      @mold_battlers[n] = Sprite.new
      @mold_battlers[n].bitmap = Cache.akea(Akea_BattleOrder::Mold)
    end
    for n in $game_party.battle_members.size...($game_troop.members.size + $game_party.battle_members.size)
      act = $game_troop.members[n-$game_party.battle_members.size]
      @bo_battlers[n] = Sprite.new
      if Akea_BattleOrder::Monster_Images[all_battle_members[n].enemy_id]
        @bo_battlers[n].bitmap = Cache.akea(Akea_BattleOrder::Monster_Images[all_battle_members[n].enemy_id])
        @bo_battlers[n].opacity = 0
        @mold_battlers[n] = Sprite.new
        @mold_battlers[n].bitmap = Cache.akea('')
        next
      end
      if Akea_BattleOrder::Enemy_Face
        @bo_battlers[n].bitmap = Cache.battler($data_enemies[act.enemy_id].battler_name, act.battler_hue)
        sx = @bo_battlers[n].bitmap.width * akea_size['Sx'] / 100
        sy = @bo_battlers[n].bitmap.height * akea_size['Sy'] / 100
        @bo_battlers[n].src_rect.set(sx, sy, akea_size['X'], akea_size['Y'])
      else
        if Akea_BattleOrder::Enemy_Characters[act.enemy_id]
          @bo_battlers[n].bitmap = Cache.character(Akea_BattleOrder::Enemy_Characters[act.enemy_id]['CharName'])
          face_index = Akea_BattleOrder::Enemy_Characters[act.enemy_id]['Index']
          sign = Akea_BattleOrder::Enemy_Characters[act.enemy_id]['CharName'][/^[\!\$]./]
        else
          @bo_battlers[n].bitmap = Cache.character(Akea_BattleOrder::Enemy_Characters[0]['CharName'])
          face_index = Akea_BattleOrder::Enemy_Characters[0]['Index']
          sign = Akea_BattleOrder::Enemy_Characters[0]['CharName'][/^[\!\$]./]
        end
        if sign && sign.include?('$')
          cw = @bo_battlers[n].bitmap.width
          ch = @bo_battlers[n].bitmap.height
          sx = @bo_battlers[n].bitmap.width * akea_size['Sx'] / 100
          sy = @bo_battlers[n].bitmap.height * akea_size['Sy'] / 100
        else
          cw = @bo_battlers[n].bitmap.width / 4
          ch = @bo_battlers[n].bitmap.height / 2
          sx = @bo_battlers[n].bitmap.width/4 * akea_size['Sx'] / 100
          sy = @bo_battlers[n].bitmap.height/2 * akea_size['Sy'] / 100
        end
        @bo_battlers[n].src_rect.set(sx + face_index % 4 * cw + cw/3, sy + face_index / 4 * ch, akea_size['X'], akea_size['Y'])
      end
        @bo_battlers[n].opacity = 0
        @mold_battlers[n] = Sprite.new
        @mold_battlers[n].bitmap = Cache.akea(Akea_BattleOrder::Mold)
    end
  end
  #--------------------------------------------------------------------------
  # * Finalização do processo
  #--------------------------------------------------------------------------
  def terminate
    @bo_Image.bitmap.dispose
    @bo_Image.dispose
    @bo_battlers.each{|battler|battler.bitmap.dispose; battler.dispose}
    @mold_battlers.each{|battler|battler.bitmap.dispose; battler.dispose}
    akea_bo_terminate
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
#==============================================================================
# ** BattleManager
#------------------------------------------------------------------------------
#  Este módulo gerencia o andamento da batalha.
#==============================================================================

module BattleManager
  #--------------------------------------------------------------------------
  # * Configuração inicial
  #--------------------------------------------------------------------------
  def self.akea_battle_turn
    @action_battlers
  end
end