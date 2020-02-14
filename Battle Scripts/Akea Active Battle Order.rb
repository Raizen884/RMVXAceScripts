#=======================================================
#        Akea Active Battle Order
# Author: Raizen
# Community: http://www.centrorpg.com/
# Compatibility: RMVXAce
# Demo: http://www.mediafire.com/file/crpa5cjxvzrn6l9/Akea+Active+Battle+Order.exe
#=======================================================
# Instructions: First you need a Active Time Battle System on your project,
# It can be any active Time battle, as long as the scripter has used the name
# atb as its attribute.
# =========================Don't Modify==============================
$imported ||= Hash.new
$imported[:akea_active_battle_order] = true
module Akea_Active_Battle_Order
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

Max_ATB_Value = 1000

# Se vai usar face para personagem, true usa face, false usa charset
# Se true ele vai utilizar uma parte da imagem das faces
# Se false vai utilizar o charset
Party_Face = true

# Se vai usar face para inimigo, true usa face, false usa charset
# Se true ele vai utilizar uma parte da imagem dos battlers
# Se false vai utilizar o charset, configurado logo mais no script
Enemy_Face = false

# Imagem adicional que ficará na tela de batalha
Battle_Image = 'Battle_Order'
Image_X = 40
Image_Y = 40

# Imagem de moldura, caso os chars precisem de moldura
# Caso não queira adicionar uma moldura basta colocar como
# Mold = ''
Mold = 'base_hud'

# Correção da posição da moldura
Mold_X = -4
Mold_Y = -4


# Correção do recorte das faces ou charsets
Size = {
'Sx' => 30, # em %, no eixo X ele irá recortar
'Sy' => 50, # em %, no eixo Y ele irá recortar
'X' => 35, # Tamanho da imagem recortada em X
'Y' => 30, # Tamanho da imagem recortada em Y

}
# Tempo que leva para os quadros se movimentarem em frames
Movement_Time = 5

# Posição de inicio dos quadros [x, y]
Start_Position = [70, 47]

# Posição de fim dos quadros [x, y]
End_Position = [439, 47]

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
Party_Images[1] = 'Erik'
Party_Images[2] = 'Luna'
Party_Images[3] = 'Safira'
Party_Images[4] = 'Raizen'
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
alias :akea_bo_update :update
alias :akea_bo_terminate :terminate
  #--------------------------------------------------------------------------
  # * Inicialização do processo
  #--------------------------------------------------------------------------
  def start(*args, &block)
    create_battle_order_images
    create_akea_battle_rates
    akea_bo_start(*args, &block)
  end
  def create_akea_battle_rates
    @akea_max_atb = Akea_Active_Battle_Order::Max_ATB_Value
    @akea_Bo_Rate = [Akea_Active_Battle_Order::End_Position[0] - Akea_Active_Battle_Order::Start_Position[0], Akea_Active_Battle_Order::End_Position[1] - Akea_Active_Battle_Order::Start_Position[1]]
  end
  
  #--------------------------------------------------------------------------
  # * Atualização da tela
  #--------------------------------------------------------------------------
  def update(*args, &block)
    update_akea_bo_movement
    akea_bo_update(*args, &block)
  end
  
  def update_akea_bo_movement
    max_x = [0, 0]
    @bo_battlers.each {|b| b.opacity = Akea_Active_Battle_Order::Opacity; b.z = 20}
    @mold_battlers.each {|m| m.opacity = Akea_Active_Battle_Order::Opacity; m.z = 20}
    for n in 0...$game_party.battle_members.size
      if $game_party.battle_members[n].dead?
        @mold_battlers[n].opacity = @bo_battlers[n].opacity = 0
        next
      end
      @mold_battlers[n].x = @bo_battlers[n].x = (@akea_Bo_Rate[0] * $game_party.battle_members[n].atb)/ @akea_max_atb + Akea_Active_Battle_Order::Start_Position[0]
      @mold_battlers[n].y = @bo_battlers[n].y = (@akea_Bo_Rate[1] * $game_party.battle_members[n].atb)/ @akea_max_atb + Akea_Active_Battle_Order::Start_Position[1]
      max_x = [n, @mold_battlers[n].x] if @mold_battlers[n].x > max_x[1]
    end
    for n in $game_party.battle_members.size...($game_troop.members.size + $game_party.battle_members.size)
      if $game_troop.members[n-$game_party.battle_members.size].dead?
        @mold_battlers[n].opacity = @bo_battlers[n].opacity = 0
        next
      end
      @mold_battlers[n].x = @bo_battlers[n].x = (@akea_Bo_Rate[0] * $game_troop.members[n-$game_party.battle_members.size].atb)/ @akea_max_atb + Akea_Active_Battle_Order::Start_Position[0]
      @mold_battlers[n].y = @bo_battlers[n].y = (@akea_Bo_Rate[1] * $game_troop.members[n-$game_party.battle_members.size].atb)/ @akea_max_atb + Akea_Active_Battle_Order::Start_Position[1]
      max_x = [n, @mold_battlers[n].x] if @mold_battlers[n].x > max_x[1]
    end
    @bo_battlers[max_x[0]].opacity = 255
    @bo_battlers[max_x[0]].z = 21
    @mold_battlers[max_x[0]].opacity = 255
    @mold_battlers[max_x[0]].z = 21
  end

  
  
  #--------------------------------------------------------------------------
  # * Criação das imagens dos battlers
  #--------------------------------------------------------------------------
  def create_battle_order_images
    @bo_Image = Sprite.new
    @bo_Image.bitmap = Cache.akea(Akea_Active_Battle_Order::Battle_Image)
    @bo_Image.x = Akea_Active_Battle_Order::Image_X
    @bo_Image.y = Akea_Active_Battle_Order::Image_Y
    @bo_battlers = Array.new
    @mold_battlers = Array.new
    akea_size = Akea_Active_Battle_Order::Size
    for n in 0...$game_party.battle_members.size
      act = $game_party.battle_members[n]
      @bo_battlers[n] = Sprite.new
      if Akea_Active_Battle_Order::Party_Images[$game_party.battle_members[n].id]
        @bo_battlers[n].bitmap = Cache.akea(Akea_Active_Battle_Order::Party_Images[$game_party.battle_members[n].id])
        @bo_battlers[n].opacity = Akea_Active_Battle_Order::Opacity
        @bo_battlers[n].z = 20
        @bo_battlers[n].x = Akea_Active_Battle_Order::Start_Position[0]
        @bo_battlers[n].y = Akea_Active_Battle_Order::Start_Position[1]
        @mold_battlers[n] = Sprite.new
        @mold_battlers[n].bitmap = Cache.akea('')
        next
      end
      if Akea_Active_Battle_Order::Party_Face
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
      @bo_battlers[n].opacity = Akea_Active_Battle_Order::Opacity
      @mold_battlers[n] = Sprite.new
      @mold_battlers[n].bitmap = Cache.akea(Akea_Active_Battle_Order::Mold)
    end
    for n in $game_party.battle_members.size...($game_troop.members.size + $game_party.battle_members.size)
      act = $game_troop.members[n-$game_party.battle_members.size]
      @bo_battlers[n] = Sprite.new
      if Akea_Active_Battle_Order::Monster_Images[all_battle_members[n].enemy_id]
        @bo_battlers[n].bitmap = Cache.akea(Akea_Active_Battle_Order::Monster_Images[all_battle_members[n].enemy_id])
        @bo_battlers[n].opacity = Akea_Active_Battle_Order::Opacity
        @mold_battlers[n] = Sprite.new
        @mold_battlers[n].bitmap = Cache.akea('')
        next
      end
      if Akea_Active_Battle_Order::Enemy_Face
        @bo_battlers[n].bitmap = Cache.battler($data_enemies[act.enemy_id].battler_name, act.battler_hue)
        sx = @bo_battlers[n].bitmap.width * akea_size['Sx'] / 100
        sy = @bo_battlers[n].bitmap.height * akea_size['Sy'] / 100
        @bo_battlers[n].src_rect.set(sx, sy, akea_size['X'], akea_size['Y'])
      else
        if Akea_Active_Battle_Order::Enemy_Characters[act.enemy_id]
          @bo_battlers[n].bitmap = Cache.character(Akea_Active_Battle_Order::Enemy_Characters[act.enemy_id]['CharName'])
          face_index = Akea_Active_Battle_Order::Enemy_Characters[act.enemy_id]['Index']
          sign = Akea_Active_Battle_Order::Enemy_Characters[act.enemy_id]['CharName'][/^[\!\$]./]
        else
          @bo_battlers[n].bitmap = Cache.character(Akea_Active_Battle_Order::Enemy_Characters[0]['CharName'])
          face_index = Akea_Active_Battle_Order::Enemy_Characters[0]['Index']
          sign = Akea_Active_Battle_Order::Enemy_Characters[0]['CharName'][/^[\!\$]./]
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
      @bo_battlers[n].opacity = Akea_Active_Battle_Order::Opacity
      @mold_battlers[n] = Sprite.new
      @mold_battlers[n].bitmap = Cache.akea(Akea_Active_Battle_Order::Mold)
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
  def self.Akea(filename)
    load_bitmap("Graphics/akea/", filename)
  end
end