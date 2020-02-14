#=======================================================
#        Akea Advanced Battle Pop-up
# Author: Raizen
# Community: http://www.centrorpg.com/
# Compatibility: RMVXAce
#
#=======================================================
# Instruções e Funcionalidades:
# O script adiciona a função de pop-up de estados/dano/buffs,
# O script permite TOTAL configuração das animações
# =========================Don't Modify==============================
$included ||= Hash.new
$included[:akea_battlepopup] = true
module Akea_BattlePop
# =========================Don't Modify==============================

# Instancias de imagens abertas, coloque quantas achar necessário, isso
# significa o máximo de imagens de pop-up que serão exibidas simultaneamente
Instances = 4

# Mostrar o Log?
Show_log = false

# Tamanho total da imagem [largura, altura]
Popup_Size = [100, 50]

# Espaço entre os números por imagens SE utilizar numeração por imagens
Popup_Spacing = 12

# Tempo entre um pop-up e outro
# (Time_Pop = 60 é igual a 1 segundo)
Time_Pop = 18
BattlePop = []

# Mostrar ganho de experiência e gold ao derrotar inimigos?
Show_Gold_Exp = true
# Nomenclatura de gold
Gold = " G"
# Nomenclatura de Exp
Exp = " Exp"

# Pop-up que subirá caso se recupere de um estado
Recover_Name = 'Recuperado'
# Estados que não serão considerados como "recuperado"
States_No_Pop = ['Defendendo']

# Aqui será configurado o padrão de Battle Pop-ups, 
# LEIA ATENTAMENTE, é possível adicionar TUDO por imagens, 
# mas deve se atentar a alguns pontos.
# 6 palavras estão RESERVADAS,
# num_dmg é para a numeração de dano CASO queira utilizar
# num_rec é para a numeração de recuperação CASO queira utilizar
# num_mp_dmg é para a numeração de dano mágico CASO queira utilizar
# num_mp_rec é para a numeração de recuperação de mana CASO queira utilizar
# num_tp_dmg é para a numeração de dano TP CASO queira utilizar
# num_tp_rec é para a numeração de recuperação de TP CASO queira utilizar

# Todos seguem o seguinte padrão
# 'num_dmg' => ['nome_da_imagem', id_do_Pop],
# id_do_pop segue o padrão configurado abaixo, você pode optar por usar
# uma imagem no lugar de 'nome_da_imagem' só colocar o gráfico na pasta
# Graphics/Akea
# Se optar por usar o desenho padrão do RPG Maker, basta colocar '' no
# lugar do nome da imagem.
# Para os outros que não sejam a numeração coloque
# 'texto' => ['nome_da_imagem', id_do_Pop],
# Por exemplo o estado envenenado

#Ex: 'Envenenado' => ['Poison', 9],
# O exemplo acima faria toda vez que o texto for Envenenado(o nome do estado),
# ele chamaria a configuração do pop-up 9 e a imagem seria a "Poison.png"
BattlePic = {
'num_dmg' => ['', 0],
'num_rec' => ['', 1],
'num_mp_dmg' => ['', 2],
'num_mp_rec' => ['', 3],
'num_tp_dmg' => ['', 2],
'num_tp_rec' => ['', 3],
'evaded' => ['', 5],
'Envenenado' => ['', 9],
}

#--------------------------------------------------------------------------
# * BattlePop[id] -> Pode adicionar quantas achar necessário
#--------------------------------------------------------------------------
# Instruções, aqui é configurado TODOS os movimentos de pop-ups e suas
# configurações, PRESTE bastante atenção na configuração.

#:base_set aqui não é necessário modificar:
#:movement => aqui é configurado TODOS os movimentos do pop-up, os 
# movimentos são sequenciais e configurados da seguinte maneira.
# [movimento em x, movimento em y, opacidade]
# sendo que o primeiro é em relação a posição do ALVO do pop-up

# Pode adicionar quando quiser, separados por vírgulas

# :color => [R, G, B] sendo 255 o valor máximo
# :font => nome da fonte('' usa a fonte padrão do RPG Maker)
# :size => tamanho da fonte
# :bold => true/false
# :italic => true/false
# :text => texto do pop-up, fará efeito em algumas situações apenas


#--------------------------------------------------------------------------
# * BattlePop[0] => Pop up padrão de dano
#--------------------------------------------------------------------------
BattlePop[0] = {
:base_set => 'subject',
:movement => [[-10, -50, 255], [0, -1, 255], [0, -1, 255], [0, -1, 255],
[0, -1, 255], [0, -1, 255], [0, -1, 255], [0, -1, 255],
[0, -1, 255], [0, -1, 255], [0, -1, 255], [0, -1, 255],
[0, -1, 255], [0, -1, 255], [0, -1, 255], [0, -1, 255],
[0, -1, 255], [0, -1, 255], [0, -1, 255], [0, -1, 255],
[0, -1, 255], [0, -1, 255], [0, -1, 255], [0, -1, 255],
[0, -1, 255], [0, -1, 255], [0, -1, 255], [0, -1, 255],
[0, -1, 255], [0, -1, 255], [0, -1, 255], [0, -1, 255],
[0, -1, 255], [0, -1, 255], [0, -1, 255], [0, -1, 255],
[0, -1, 255], [0, -1, 255], [0, -1, 200], [0, -1, 150], [0, -1, 50],
[0, -1, 0]],
:color => [255, 0, 0],
:font => '',
:size => 24,
:bold => false,
:italic => false,
:text => '',
}
#--------------------------------------------------------------------------
# * BattlePop[1] => Pop up padrão de recuperação de vida
#--------------------------------------------------------------------------
BattlePop[1] = {
:base_set => 'subject',
:movement => [[-10, -50, 255], [0, -1, 255], [0, -1, 255], [0, -1, 255],
[0, -1, 255], [0, -1, 255], [0, -1, 255], [0, -1, 255],
[0, -1, 255], [0, -1, 255], [0, -1, 255], [0, -1, 255],
[0, -1, 255], [0, -1, 255], [0, -1, 255], [0, -1, 255],
[0, -1, 255], [0, -1, 255], [0, -1, 255], [0, -1, 255],
[0, -1, 255], [0, -1, 255], [0, -1, 255], [0, -1, 255],
[0, -1, 255], [0, -1, 255], [0, -1, 255], [0, -1, 255],
[0, -1, 255], [0, -1, 255], [0, -1, 255], [0, -1, 255],
[0, -1, 255], [0, -1, 255], [0, -1, 255], [0, -1, 255],
[0, -1, 255], [0, -1, 255], [0, -1, 200], [0, -1, 150], [0, -1, 50],
[0, -1, 0]],
:color => [0, 255, 0],
:font => '',
:size => 24,
:bold => false,
:italic => false,
:text => '',
}
#--------------------------------------------------------------------------
# * BattlePop[2] => Pop up padrão de dano(mana)
#--------------------------------------------------------------------------
BattlePop[2] = {
:base_set => 'subject',
:movement => [[-10, -50, 255], [0, -1, 255], [0, -1, 255], [0, -1, 255],
[0, -1, 255], [0, -1, 255], [0, -1, 255], [0, -1, 255],
[0, -1, 255], [0, -1, 255], [0, -1, 255], [0, -1, 255],
[0, -1, 255], [0, -1, 255], [0, -1, 255], [0, -1, 255],
[0, -1, 255], [0, -1, 255], [0, -1, 255], [0, -1, 255],
[0, -1, 255], [0, -1, 255], [0, -1, 255], [0, -1, 255],
[0, -1, 255], [0, -1, 255], [0, -1, 255], [0, -1, 255],
[0, -1, 255], [0, -1, 255], [0, -1, 255], [0, -1, 255],
[0, -1, 255], [0, -1, 255], [0, -1, 255], [0, -1, 255],
[0, -1, 255], [0, -1, 255], [0, -1, 200], [0, -1, 150], [0, -1, 50],
[0, -1, 0]],
:color => [0, 0, 255],
:font => '',
:size => 24,
:bold => false,
:italic => false,
:text => '',
}
#--------------------------------------------------------------------------
# * BattlePop[3] => Pop up padrão de recuperação de mana
#--------------------------------------------------------------------------
BattlePop[3] = {
:base_set => 'subject',
:movement => [[-10, -50, 255], [0, -1, 255], [0, -1, 255], [0, -1, 255],
[0, -1, 255], [0, -1, 255], [0, -1, 255], [0, -1, 255],
[0, -1, 255], [0, -1, 255], [0, -1, 255], [0, -1, 255],
[0, -1, 255], [0, -1, 255], [0, -1, 255], [0, -1, 255],
[0, -1, 255], [0, -1, 255], [0, -1, 255], [0, -1, 255],
[0, -1, 255], [0, -1, 255], [0, -1, 255], [0, -1, 255],
[0, -1, 255], [0, -1, 255], [0, -1, 255], [0, -1, 255],
[0, -1, 255], [0, -1, 255], [0, -1, 255], [0, -1, 255],
[0, -1, 255], [0, -1, 255], [0, -1, 255], [0, -1, 255],
[0, -1, 255], [0, -1, 255], [0, -1, 200], [0, -1, 150], [0, -1, 50],
[0, -1, 0]],
:color => [0, 255, 255],
:font => '',
:size => 24,
:bold => false,
:italic => false,
:text => '',
}
#--------------------------------------------------------------------------
# * BattlePop[0] => Pop up padrão de erro(miss)
#--------------------------------------------------------------------------
BattlePop[4] = {
:base_set => 'subject',
:movement => [[-10, -50, 255], [0, -1, 255], [0, -1, 255], [0, -1, 255],
[0, -1, 255], [0, -1, 255], [0, -1, 255], [0, -1, 255],
[0, -1, 255], [0, -1, 255], [0, -1, 255], [0, -1, 255],
[0, -1, 255], [0, -1, 255], [0, -1, 255], [0, -1, 255],
[0, -1, 255], [0, -1, 255], [0, -1, 255], [0, -1, 255],
[0, -1, 255], [0, -1, 255], [0, -1, 255], [0, -1, 255],
[0, -1, 255], [0, -1, 255], [0, -1, 255], [0, -1, 255],
[0, -1, 255], [0, -1, 255], [0, -1, 255], [0, -1, 255],
[0, -1, 255], [0, -1, 255], [0, -1, 255], [0, -1, 255],
[0, -1, 255], [0, -1, 255], [0, -1, 200], [0, -1, 150], [0, -1, 50],
[0, -1, 0]],
:color => [255, 0, 255],
:font => '',
:size => 24,
:bold => false,
:italic => false,
:text => 'miss',
}
#--------------------------------------------------------------------------
# * BattlePop[0] => Pop up padrão de desvio(evade)
#--------------------------------------------------------------------------
BattlePop[5] = {
:base_set => 'subject',
:movement => [[-10, -50, 255], [0, -1, 255], [0, -1, 255], [0, -1, 255],
[0, -1, 255], [0, -1, 255], [0, -1, 255], [0, -1, 255],
[0, -1, 255], [0, -1, 255], [0, -1, 255], [0, -1, 255],
[0, -1, 255], [0, -1, 255], [0, -1, 255], [0, -1, 255],
[0, -1, 255], [0, -1, 255], [0, -1, 255], [0, -1, 255],
[0, -1, 255], [0, -1, 255], [0, -1, 255], [0, -1, 255],
[0, -1, 255], [0, -1, 255], [0, -1, 255], [0, -1, 255],
[0, -1, 255], [0, -1, 255], [0, -1, 255], [0, -1, 255],
[0, -1, 255], [0, -1, 255], [0, -1, 255], [0, -1, 255],
[0, -1, 255], [0, -1, 255], [0, -1, 200], [0, -1, 150], [0, -1, 50],
[0, -1, 0]],
:color => [255, 0, 255],
:font => '',
:size => 24,
:bold => false,
:italic => false,
:text => 'evaded',
}
#--------------------------------------------------------------------------
# * BattlePop[0] => Pop up padrão para os estados
#--------------------------------------------------------------------------
BattlePop[6] = {
:base_set => 'subject',
:movement => [[-10, -50, 255], [0, -1, 255], [0, -1, 255], [0, -1, 255],
[0, -1, 255], [0, -1, 255], [0, -1, 255], [0, -1, 255],
[0, -1, 255], [0, -1, 255], [0, -1, 255], [0, -1, 255],
[0, -1, 255], [0, -1, 255], [0, -1, 255], [0, -1, 255],
[0, -1, 255], [0, -1, 255], [0, -1, 255], [0, -1, 255],
[0, -1, 255], [0, -1, 255], [0, -1, 255], [0, -1, 255],
[0, -1, 255], [0, -1, 255], [0, -1, 255], [0, -1, 255],
[0, -1, 255], [0, -1, 255], [0, -1, 255], [0, -1, 255],
[0, -1, 255], [0, -1, 255], [0, -1, 255], [0, -1, 255],
[0, -1, 255], [0, -1, 255], [0, -1, 200], [0, -1, 150], [0, -1, 50],
[0, -1, 0]],
:color => [255, 0, 255],
:font => '',
:size => 24,
:bold => false,
:italic => false,
:text => '',
}
#--------------------------------------------------------------------------
# * BattlePop[0] => Pop up padrão de experiencia
#--------------------------------------------------------------------------
BattlePop[7] = {
:base_set => 'subject',
:movement => [[-10, -50, 255], [0, -1, 255], [0, -1, 255], [0, -1, 255],
[0, -1, 255], [0, -1, 255], [0, -1, 255], [0, -1, 255],
[0, -1, 255], [0, -1, 255], [0, -1, 255], [0, -1, 255],
[0, -1, 255], [0, -1, 255], [0, -1, 255], [0, -1, 255],
[0, -1, 255], [0, -1, 255], [0, -1, 255], [0, -1, 255],
[0, -1, 255], [0, -1, 255], [0, -1, 255], [0, -1, 255],
[0, -1, 255], [0, -1, 255], [0, -1, 255], [0, -1, 255],
[0, -1, 255], [0, -1, 255], [0, -1, 255], [0, -1, 255],
[0, -1, 255], [0, -1, 255], [0, -1, 255], [0, -1, 255],
[0, -1, 255], [0, -1, 255], [0, -1, 200], [0, -1, 150], [0, -1, 50],
[0, -1, 0]],
:color => [54, 128, 255],
:font => '',
:size => 24,
:bold => false,
:italic => false,
:text => 'exp',
}
#--------------------------------------------------------------------------
# * BattlePop[0] => Pop up padrão de gold
#--------------------------------------------------------------------------
BattlePop[8] = {
:base_set => 'subject',
:movement => [[-10, -50, 255], [0, -1, 255], [0, -1, 255], [0, -1, 255],
[0, -1, 255], [0, -1, 255], [0, -1, 255], [0, -1, 255],
[0, -1, 255], [0, -1, 255], [0, -1, 255], [0, -1, 255],
[0, -1, 255], [0, -1, 255], [0, -1, 255], [0, -1, 255],
[0, -1, 255], [0, -1, 255], [0, -1, 255], [0, -1, 255],
[0, -1, 255], [0, -1, 255], [0, -1, 255], [0, -1, 255],
[0, -1, 255], [0, -1, 255], [0, -1, 255], [0, -1, 255],
[0, -1, 255], [0, -1, 255], [0, -1, 255], [0, -1, 255],
[0, -1, 255], [0, -1, 255], [0, -1, 255], [0, -1, 255],
[0, -1, 255], [0, -1, 255], [0, -1, 200], [0, -1, 150], [0, -1, 50],
[0, -1, 0]],
:color => [204, 204, 0],
:font => '',
:size => 24,
:bold => false,
:italic => false,
:text => 'gold',
}
#--------------------------------------------------------------------------
# * BattlePop[0] => Pop up customizado de envenenamento
#--------------------------------------------------------------------------
BattlePop[9] = {
:base_set => 'subject',
:movement => [[-10, -50, 255], [0, -1, 255], [0, -1, 255], [0, -1, 255],
[0, -1, 255], [0, -1, 255], [0, -1, 255], [0, -1, 255],
[0, -1, 255], [0, -1, 255], [0, -1, 255], [0, -1, 255],
[0, -1, 255], [0, -1, 255], [0, -1, 255], [0, -1, 255],
[0, -1, 255], [0, -1, 255], [0, -1, 255], [0, -1, 255],
[0, -1, 255], [0, -1, 255], [0, -1, 255], [0, -1, 255],
[0, -1, 255], [0, -1, 255], [0, -1, 255], [0, -1, 255],
[0, -1, 255], [0, -1, 255], [0, -1, 255], [0, -1, 255],
[0, -1, 255], [0, -1, 255], [0, -1, 255], [0, -1, 255],
[0, -1, 255], [0, -1, 255], [0, -1, 200], [0, -1, 150], [0, -1, 50],
[0, -1, 0]],
:color => [20, 255, 30],
:font => '',
:size => 24,
:bold => false,
:italic => false,
:text => '',
}
end
#==============================================================================
#------------------------------------------------------------------------------
#  AQUI COMEÇA O SCRIPT
#------------------------------------------------------------------------------
#==============================================================================
#==============================================================================
# ** Scene_Battle
#------------------------------------------------------------------------------
#  Esta classe executa o processamento da tela de batalha.
#==============================================================================

class Scene_Battle < Scene_Base
alias :akea_abp_start :start
alias :akea_abp_update_basic :update_basic
alias :akea_abp_terminate :terminate
  #--------------------------------------------------------------------------
  # * Inicialização do processo
  #--------------------------------------------------------------------------
  def start
    akea_abp_start
    create_popup_sprites
  end
  #--------------------------------------------------------------------------
  # * Atualização do pop_up
  #--------------------------------------------------------------------------
  def update_akea_popup
    for n in 0...@abp_sprite_movement.size
      next if @abp_sprite_movement[n].empty?
      update_abp_movement(n)
    end
  end
  #--------------------------------------------------------------------------
  # * Atualização do movimento do pop-up
  #--------------------------------------------------------------------------
  def update_abp_movement(n)
    @abp_sprite[n].x += @abp_sprite_movement[n].first[0]
    @abp_sprite[n].y += @abp_sprite_movement[n].first[1]
    @abp_sprite[n].opacity = @abp_sprite_movement[n].first[2]
    @abp_sprite_movement[n].shift
  end
  #--------------------------------------------------------------------------
  # * Atualização geral da tela
  #--------------------------------------------------------------------------
  def update_basic
    update_akea_popup
    akea_abp_update_basic
  end
  #--------------------------------------------------------------------------
  # * Criação da tela de pop-ups
  #--------------------------------------------------------------------------
  def create_popup_sprites
    @abp_sprite = Array.new
    @abp_sprite_movement = Array.new(Akea_BattlePop::Instances, [])
    @abp_instance = 0
    for n in 0...Akea_BattlePop::Instances
      @abp_sprite[n] = Sprite.new
      @abp_sprite[n].bitmap = Bitmap.new(Akea_BattlePop::Popup_Size[0], Akea_BattlePop::Popup_Size[1])
    end
  end
  #--------------------------------------------------------------------------
  # * Rotacionar as instancias
  #--------------------------------------------------------------------------
  def rotate_abp_instances
    if @abp_instance < Akea_BattlePop::Instances - 1
      @abp_instance += 1
    else
      @abp_instance = 0
    end
    return @abp_instance
  end
  #--------------------------------------------------------------------------
  # * Desenhar a imagem de pop-up
  #--------------------------------------------------------------------------
  def draw_akea_popup(id, text, subject = false, type = '')
    n = rotate_abp_instances
    @abp_sprite[n].bitmap.dispose
    @abp_sprite[n].bitmap = Bitmap.new(Akea_BattlePop::Popup_Size[0], Akea_BattlePop::Popup_Size[1])
    text = text.to_s if type == '' || Akea_BattlePop::BattlePic[type][0] == ''
    if type != ''
      id = Akea_BattlePop::BattlePic[type][1] if Akea_BattlePop::BattlePic[type]
    end
    if text.is_a?(Integer)
      var = Cache.akea(Akea_BattlePop::BattlePic[type][0])
      hp = text
      spacing_num = 0
      hp_array = []
      until hp == 0
        rest = hp % 10
        hp = hp/10
        hp_array.unshift(rest)
      end
      for i in 0...hp_array.size
        @abp_sprite[n].bitmap.rect.set((@abp_sprite[n].bitmap.width*hp_array[i])/10, 0, @abp_sprite[n].bitmap.width/10, @abp_sprite[n].bitmap.height)
        rect = Rect.new((@abp_sprite[n].bitmap.width*hp_array[i])/10, 0, @abp_sprite[n].bitmap.width/10, @abp_sprite[n].bitmap.height)
        @abp_sprite[n].bitmap.blt(spacing_num, 0, var, rect, 255)
        spacing_num += Akea_BattlePop::Popup_Spacing
      end
    elsif Akea_BattlePop::BattlePic[text] && Akea_BattlePop::BattlePic[text][0] != ''
      @abp_sprite[n].bitmap = Cache.akea(Akea_BattlePop::BattlePic[text][0])
    else
      if Akea_BattlePop::BattlePic[text]
        id = Akea_BattlePop::BattlePic[text][1]
      end
      if Akea_BattlePop::BattlePop[id][:font] == ''
        @abp_sprite[n].bitmap.font.name = Font.default_name
      else
        @abp_sprite[n].bitmap.font.name = Akea_BattlePop::BattlePop[id][:font]
      end
      @abp_sprite[n].bitmap.font.color.set(*Akea_BattlePop::BattlePop[id][:color])
      @abp_sprite[n].bitmap.font.size = Akea_BattlePop::BattlePop[id][:size]
      @abp_sprite[n].bitmap.font.bold = Akea_BattlePop::BattlePop[id][:bold]
      @abp_sprite[n].bitmap.font.italic = Akea_BattlePop::BattlePop[id][:italic]
      @abp_sprite[n].bitmap.draw_text(0, 0, Akea_BattlePop::Popup_Size[0], Akea_BattlePop::Popup_Size[1], text)
    end
    @abp_sprite_movement[n] = Akea_BattlePop::BattlePop[id][:movement].dup
    @abp_sprite[n].x = subject.screen_x
    @abp_sprite[n].y = subject.screen_y
  end
  #--------------------------------------------------------------------------
  # * Retorna o tipo de popup
  #--------------------------------------------------------------------------
  def get_abp_type(target, item = nil, text = '', id = false)
    if text != ''
      id ? draw_akea_popup(id, text, target) : draw_akea_popup(6, text, target)
    elsif target.result.hp_damage > 0
      value = target.result.hp_damage
      draw_akea_popup(0, value.to_i, target, 'num_dmg')
      target.perform_damage_effect
      Sound.play_actor_damage
    elsif target.result.hp_damage < 0
      value = target.result.hp_damage
      draw_akea_popup(1, value.to_i.abs, target, 'num_rec')
      Sound.play_recovery
    elsif target.result.mp_damage > 0
      value = target.result.mp_damage
      draw_akea_popup(2, value.to_i, target, 'num_mp_dmg')
    elsif target.result.mp_damage < 0
      value = target.result.mp_damage
      draw_akea_popup(3, value.to_i.abs, target, 'num_mp_rec')
      Sound.play_recovery
    elsif target.result.tp_damage > 0
      value = target.result.tp_damage
      draw_akea_popup(2, value.to_i, target, 'num_tp_dmg')
    elsif target.result.tp_damage < 0
      value = target.result.tp_damage
      draw_akea_popup(3, value.to_i.abs, target, 'num_tp_rec')
      Sound.play_recovery
    elsif target.result.missed
      value = Akea_BattlePop::BattlePop[4][:text]
      draw_akea_popup(4, value, target)
      Sound.play_miss
    elsif target.result.evaded
      value = Akea_BattlePop::BattlePop[5][:text]
      draw_akea_popup(5, value, target)
      Sound.play_evasion
    end
  end
  #--------------------------------------------------------------------------
  # * Dispoe as imagens
  #--------------------------------------------------------------------------
  def dispose_akea_popup
    @abp_sprite.each{|sprt| sprt.bitmap.dispose; sprt.dispose}
  end
  #--------------------------------------------------------------------------
  # * Finalização de Scene
  #--------------------------------------------------------------------------
  def terminate
    dispose_akea_popup
    akea_abp_terminate
  end
end


#==============================================================================
# ** Window_BattleLog
#------------------------------------------------------------------------------
#  Esta janela exibe o progresso da luta. Não exibe o quadro da
# janela, é tratado como uma janela por conveniência.
#==============================================================================

class Window_BattleLog < Window_Selectable
alias :akea_abp_display_use_item :display_use_item
alias :akea_abp_display_action_results :display_action_results
alias :akea_abp_display_damage :display_damage
alias :akea_abp_display_added_states :display_added_states
alias :akea_abp_display_removed_states :display_removed_states
alias :akea_abp_display_buffs :display_buffs
alias :akea_abp_display_critical :display_critical
alias :akea_abp_display_failure :display_failure
  #--------------------------------------------------------------------------
  # * Exibição de uso de habilidade/item
  #     subject : lutador
  #     item    : habilidade/item
  #--------------------------------------------------------------------------
  def display_use_item(subject, item)
    akea_abp_display_use_item(subject, item)
  end
  #--------------------------------------------------------------------------
  # * Exibição de dano
  #     target : alvo
  #     item   : habilidade/item
  #--------------------------------------------------------------------------
  def display_damage(target, item)
    SceneManager.scene.get_abp_type(target, item)
    unless Akea_BattlePop::Show_log
      @num_wait += 1
      @get_all_pop_wait = (Akea_BattlePop::BattlePop[0][:movement].size - Akea_BattlePop::Time_Pop)
      @method_wait.call(Akea_BattlePop::Time_Pop) if @method_wait
      return
    end
    akea_abp_display_damage(target, item)
  end
  #--------------------------------------------------------------------------
  # * Exibição de resultados da ação
  #     target : alvo
  #     item   : habilidade/item
  #--------------------------------------------------------------------------
  def display_action_results(target, item)
    @get_all_pop_wait = 0
    akea_abp_display_action_results(target, item)
    @num_wait += 1
    @method_wait.call(@get_all_pop_wait)
  end
  #--------------------------------------------------------------------------
  # * Exibição de estados adicionados
  #     target : alvo
  #--------------------------------------------------------------------------
  def display_added_states(target)
    target.result.added_state_objects.each do |state|
      target.perform_collapse_effect if state.id == target.death_state_id
      SceneManager.scene.get_abp_type(target, nil, state.name)
      @method_wait.call(Akea_BattlePop::Time_Pop)
      @get_all_pop_wait = (Akea_BattlePop::BattlePop[6][:movement].size - Akea_BattlePop::Time_Pop)
      if Akea_BattlePop::Show_Gold_Exp && target.enemy? && state.id == target.death_state_id
        SceneManager.scene.get_abp_type(target, nil, target.gold.to_s + Akea_BattlePop::Gold, 8)
        @method_wait.call(Akea_BattlePop::Time_Pop)
        @get_all_pop_wait = (Akea_BattlePop::BattlePop[6][:movement].size - Akea_BattlePop::Time_Pop)
        SceneManager.scene.get_abp_type(target, nil, target.exp.to_s + Akea_BattlePop::Exp, 7)
        @method_wait.call(Akea_BattlePop::Time_Pop)
        @get_all_pop_wait = (Akea_BattlePop::BattlePop[6][:movement].size - Akea_BattlePop::Time_Pop)
      end
    end
    akea_abp_display_added_states(target) if Akea_BattlePop::Show_log
  end
  #--------------------------------------------------------------------------
  # * Exibição de estados removidos
  #     target : alvo
  #--------------------------------------------------------------------------
  def display_removed_states(target)
    target.result.removed_state_objects.each do |state|
      next if Akea_BattlePop::States_No_Pop.include?(state.name)
      SceneManager.scene.get_abp_type(target, nil, Akea_BattlePop::Recover_Name)
      @method_wait.call(Akea_BattlePop::Time_Pop)
      @get_all_pop_wait = (Akea_BattlePop::BattlePop[6][:movement].size - Akea_BattlePop::Time_Pop)
    end
    akea_abp_display_removed_states(target) if Akea_BattlePop::Show_log
  end
  #--------------------------------------------------------------------------
  # * Exibição de fortalecimentos/enfraquecimentos(individual)
  #     target : alvo
  #     buffs  : lista de enfraquicimentos/fortalecimentos
  #     fmt    : mensagem
  #--------------------------------------------------------------------------
  def display_buffs(target, buffs, fmt)
    buffs.each do |param_id|
      SceneManager.scene.get_abp_type(target, nil, Vocab::param(param_id))
      @method_wait.call(Akea_BattlePop::Time_Pop)
      @get_all_pop_wait = (Akea_BattlePop::BattlePop[6][:movement].size - Akea_BattlePop::Time_Pop)
    end
    akea_abp_display_buffs(target, buffs, fmt) if Akea_BattlePop::Show_log
  end
  #--------------------------------------------------------------------------
  # * Exibição de acerto crítico
  #     target : alvo
  #     item   : habilidade/item
  #--------------------------------------------------------------------------
  def display_critical(target, item)
    if target.result.critical
      text = target.actor? ? Vocab::CriticalToActor : Vocab::CriticalToEnemy
      SceneManager.scene.get_abp_type(target, item, text)
      @method_wait.call(Akea_BattlePop::Time_Pop)
      @get_all_pop_wait = (Akea_BattlePop::BattlePop[6][:movement].size - Akea_BattlePop::Time_Pop)
    end
    akea_abp_display_critical(target, item) if Akea_BattlePop::Show_log
  end
  #--------------------------------------------------------------------------
  # * Exibição de falha
  #     target : alvo
  #     item   : habilidade/item
  #--------------------------------------------------------------------------
  def display_failure(target, item)
    if target.result.hit? && !target.result.success
      SceneManager.scene.get_abp_type(target, item, Vocab::ActionFailure)
      @method_wait.call(Akea_BattlePop::Time_Pop)
      @get_all_pop_wait = (Akea_BattlePop::BattlePop[6][:movement].size - Akea_BattlePop::Time_Pop)
    end
    akea_abp_display_failure(target, item) if Akea_BattlePop::Show_log
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