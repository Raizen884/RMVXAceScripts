#=======================================================
#        Lune Picture Hud
# Autor: Raizen
# Comunidade: www.centrorpg.com
# Compatibilidade: RMVXAce

# Muda as tradicionais barras de HP e MP do menu e da batalha para imagens,
# deixando as barras de hp e mp bem mais ajustáveis
#=======================================================


# Basta configurar abaixo como é pedido em cada campo.
module Lune_Pic_config
  
# Nome das imagens nessa ordem, na pasta Graphics/System
# [Imagem de fundo da hud de vida, Barra de HP, 
# Imagem de fundo da hud de mana, Barra de MP, 
# Imagem de fundo da hud de TP, Barra de TP]

Pic = ['BACK_BAR', 'HP_BAR', 'BACK_BAR', 'MP_BAR', 'BACK_BAR', 'TP_BAR']

# Correção da posição em X
# Modifique os valores, pode ser negativo, até as barras atingirem a posição ideal.
Todos_X = 3
HP_X = 1
MP_X = 1
TP_X = 1
# Correção da posição em Y
Todos_Y = 6
HP_Y = 4
MP_Y = 4
TP_Y = 4

# Manter Texto de HP/MP?

Text = false

# Manter numeração? (Ex 100/253)
Num = true

# Tamanho da fonte
Fonte = 14

end

#==============================================================================
#==============================================================================
#================   Aqui Começa o Script   ====================================
#==============================================================================
#==============================================================================
#==============================================================================
# ** Window_Base
#------------------------------------------------------------------------------
#  Esta é a superclasse para todas as janelas no jogo.
#==============================================================================

class Window_Base < Window
alias lune_pic_initialize initialize
  #--------------------------------------------------------------------------
  # * Inicialização do objeto
  #     x      : coordenada X
  #     y      : coordenada Y
  #     width  : largura
  #     height : altura
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height)
    lune_pic_initialize(x, y, width, height)
  end
  #--------------------------------------------------------------------------
  # * Desenho do HP
  #     actor  : herói
  #     x      : coordenada X
  #     y      : coordenada Y
  #     width  : largura
  #--------------------------------------------------------------------------
  def draw_actor_hp(actor, x, y, width = 124)
    x += Lune_Pic_config::Todos_X + Lune_Pic_config::HP_X
    y += Lune_Pic_config::HP_Y + Lune_Pic_config::Todos_Y
    bitmap = Cache.system(Lune_Pic_config::Pic[1])
    rect = Rect.new(0, 0, bitmap.width*actor.hp/actor.mhp, bitmap.height)
    contents.blt(x, y, bitmap, rect, 255)
    bitmap = Cache.system(Lune_Pic_config::Pic[0])
    rect = Rect.new(0, 0, bitmap.width, bitmap.height)
    contents.blt(x - Lune_Pic_config::HP_X, y-Lune_Pic_config::HP_Y, bitmap, rect, 255)
    x -= Lune_Pic_config::Todos_X + Lune_Pic_config::HP_X
    y -= Lune_Pic_config::HP_Y + Lune_Pic_config::Todos_Y
    change_color(system_color)
    contents.font.size = Lune_Pic_config::Fonte
    draw_text(x, y, 30, line_height, Vocab::hp_a) if Lune_Pic_config::Text
    draw_current_and_max_values(x, y, width, actor.hp, actor.mhp,
    hp_color(actor), normal_color) if Lune_Pic_config::Num
    contents.font.size = Font.default_size
  end
  #--------------------------------------------------------------------------
  # * Desenho do MP
  #     actor  : herói
  #     x      : coordenada X
  #     y      : coordenada Y
  #     width  : largura
  #--------------------------------------------------------------------------
  def draw_actor_mp(actor, x, y, width = 124)
    x += Lune_Pic_config::Todos_X + Lune_Pic_config::MP_X
    y += Lune_Pic_config::MP_Y + Lune_Pic_config::Todos_Y
    bitmap = Cache.system(Lune_Pic_config::Pic[3])
    rect = Rect.new(0, 0, bitmap.width*actor.mp/actor.mmp, bitmap.height)
    contents.blt(x, y, bitmap, rect, 255)
    bitmap = Cache.system(Lune_Pic_config::Pic[2])
    rect = Rect.new(0, 0, bitmap.width, bitmap.height)
    contents.blt(x - Lune_Pic_config::MP_X, y-Lune_Pic_config::MP_Y, bitmap, rect, 255)
    x -= Lune_Pic_config::Todos_X + Lune_Pic_config::MP_X
    y -= Lune_Pic_config::MP_Y + Lune_Pic_config::Todos_Y
    change_color(system_color)
    contents.font.size = Lune_Pic_config::Fonte
    draw_text(x, y, 30, line_height, Vocab::mp_a) if Lune_Pic_config::Text
    draw_current_and_max_values(x, y, width, actor.mp, actor.mmp,
      mp_color(actor), normal_color) if Lune_Pic_config::Num
    contents.font.size = Font.default_size
  end
  #--------------------------------------------------------------------------
  # * Desenho do TP
  #     actor  : herói
  #     x      : coordenada X
  #     y      : coordenada Y
  #     width  : largura
  #--------------------------------------------------------------------------
  def draw_actor_tp(actor, x, y, width = 124)
    x += Lune_Pic_config::Todos_X + Lune_Pic_config::TP_X
    y += Lune_Pic_config::TP_Y + Lune_Pic_config::Todos_Y
    bitmap = Cache.system(Lune_Pic_config::Pic[5])
    rect = Rect.new(0, 0, bitmap.width*actor.tp/100, bitmap.height)
    contents.blt(x, y, bitmap, rect, 255)
    bitmap = Cache.system(Lune_Pic_config::Pic[4])
    rect = Rect.new(0, 0, bitmap.width, bitmap.height)
    contents.blt(x - Lune_Pic_config::TP_X, y-Lune_Pic_config::TP_Y, bitmap, rect, 255)
    x -= Lune_Pic_config::Todos_X + Lune_Pic_config::TP_X
    y -= Lune_Pic_config::TP_Y + Lune_Pic_config::Todos_Y
    change_color(system_color)
    contents.font.size = Lune_Pic_config::Fonte
    draw_text(x, y, 30, line_height, Vocab::tp_a) if Lune_Pic_config::Text
    draw_text(x + width - 42, y, 42, line_height, actor.tp.to_i, 2) if Lune_Pic_config::Num
    contents.font.size = Font.default_size
  end
end
