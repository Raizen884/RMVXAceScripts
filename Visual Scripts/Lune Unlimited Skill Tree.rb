#=======================================================
#         Lune Unlimited Skill Tree
# Autor: Raizen
# Comunidade: www.centrorpg.com
# Classica árvore de habilidades para jogos de rpg, 
# leia atentamente as instruções para configurar corretamente
# o script.
# Demo Download: http://www.mediafire.com/download/h6dng85i6j14tqx/Project9.exe
#=======================================================
$imported = {} if $imported == nil
$imported[:Lune_Skill_Tree] = true
module Lune_Skill_Tree
#=======================================================
# Não modificar!!!
#=======================================================
$data_actors = load_data("Data/Actors.rvdata2")
Actor = Array.new($data_actors.size, Array.new)
#=======================================================
#         Configurações de Imagens e atributos
#=======================================================

# Adicionar um ponto automaticamente ao subir de level?
# true = sim, false = não
Add_Skill_pt = true
# Para adicionar pontos manualmente, basta
# Chamar Script : add_tree_points(actor_id, points)
# Colocando o id do personagem e a quantidade de pontos a ser adicionado.
# Nome da imagem do cursor
Cursor = "cursor"
# Correção de X do cursor
Cursor_X = 20
# Correção de Y do cursor
Cursor_Y = 20


# Imagem para seleção do personagem
# Tamanho padrão do ace 384x416, se não deseja imagem extra
# coloque '' sem nada dentro das aspas
Actor_Select = 'actor_select'

#=======================================================
#         Configurações das janelas e fonte
#=======================================================
# Tamanho da janela de descrição.
Win_Size = 100
# Opacidade das janelas, caso use imagens, coloque o valor 0
Opacity = 0

# Tamanho da fonte para as skills
Font_Skills = 16
# Tamanho da fonte para a descrição
Font_Help = 22
# deixe entre '' e vazio para padrão, nome da fonte
Font_Name = "" 

# Correção das posições das informações das janelas
Corr_X = -10
Corr_Y = 20

# Posição do texto de pontos totais do usuário
Text_Y = 280
Text_X = 100
# Texto
Text = 'Pontos Totais: '


# Texto da janela de opções
Bot1 = 'Usar'
Bot2 = 'Distribuir'
Bot3 = 'Cancelar'



#=========================================================================
# Actor 8 => Configurações principais
# Note que o 0 na parte de skills sempre é para a configuração
# dos skill trees
#=========================================================================
Actor[8][0] = {
# Imagens das skill trees, coloque quantas forem necessárias
# se não deseja imagens use '' no lugar do nome da imagem
'Tree_Images' => ['fundo save', 'fundo save2'],
# Posição dos cursores que mudam as "árvores".
'Tree_Shift' => [[400, 50], [400, 80]],
}
  #=========================================================================
  # Actor 8 => Skill 1 -> Fire                                   
  #=========================================================================
Actor[8][1] = {
'Skill_id' => 51, # ID da habilidade no database
'Maxlevel' => 10, # Level máximo da habilidade
'Multiply' => 30, # Multiplicador do efeito em % 100 = 100%
'Level' => 1, # Level necessário para abrir habilidade
'Level_Add' => 2, # Adição do level necessário a cada level da habilidade
'Tree' => 1, # A árvore que essa habilidade pertence
'Left' => 0, # Skill a esquerda na árvore, 0 para nenhum
'Right' => 4, # Skill a direita na árvore, 0 para nenhum
'Down' => 2, # Skill abaixo na árvore, 0 para nenhum
'Up' => 0, # Skill acima na árvore, 0 para nenhum
'X' => 30, # Posição do ícone em X
'Y' => 50, # Posição do ícone em Y
'Image' => 'Fire', # Imagem do ícone, para ícones padrões coloque ''
'Req_skills' => [], # Skills necessárias para abrir a habilidade, qualquer quantidade
'Req_levels' => [], # Mesmo que acima, mas para os leveis de cada skill
'Desc1' => 'Fire - Ataque de Fogo', # Descrição 1
'Desc2' => 'Requer: Level 1 + 2x Level da habilidade', # Descrição 2
'Desc3' => '', # Descrição 3
}
  #=========================================================================
  # Actor 8 => Skill 2 -> Flare                                  
  #=========================================================================
Actor[8][2] = {
'Skill_id' => 53, # ID da habilidade no database
'Maxlevel' => 10, # Level máximo da habilidade
'Multiply' => 30, # Multiplicador do efeito em % 100 = 100%
'Level' => 5, # Level necessário para abrir habilidade
'Level_Add' => 3, # Adição do level necessário a cada level da habilidade
'Tree' => 1, # A árvore que essa habilidade pertence
'Left' => 0, # Skill a esquerda na árvore, 0 para nenhum
'Right' => 5, # Skill a direita na árvore, 0 para nenhum
'Down' => 3, # Skill abaixo na árvore, 0 para nenhum
'Up' => 1, # Skill acima na árvore, 0 para nenhum
'X' => 30, # Posição do ícone em X
'Y' => 150, # Posição do ícone em Y
'Image' => 'Flare', # Imagem do ícone, para ícones padrões coloque ''
'Req_skills' => [51], # Skills necessárias para abrir a habilidade, qualquer quantidade
'Req_levels' => [5], # Mesmo que acima, mas para os leveis de cada skill
'Desc1' => 'Flare - Ataque de Fogo em área', # Descrição 1
'Desc2' => 'Requer: Level 5 + 3x Level da habilidade', # Descrição 2
'Desc3' => '', # Descrição 3
}
  #=========================================================================
  # Actor 8 => Skill 3 -> Blaze                                 
  #=========================================================================
Actor[8][3] = {
'Skill_id' => 54, # ID da habilidade no database
'Maxlevel' => 5, # Level máximo da habilidade
'Multiply' => 30, # Multiplicador do efeito em % 100 = 100%
'Level' => 20, # Level necessário para abrir habilidade
'Level_Add' => 5, # Adição do level necessário a cada level da habilidade
'Tree' => 1, # A árvore que essa habilidade pertence
'Left' => 0, # Skill a esquerda na árvore, 0 para nenhum
'Right' => 0, # Skill a direita na árvore, 0 para nenhum
'Down' => 0, # Skill abaixo na árvore, 0 para nenhum
'Up' => 2, # Skill acima na árvore, 0 para nenhum
'X' => 30, # Posição do ícone em X
'Y' => 250, # Posição do ícone em Y
'Image' => 'Blaze', # Imagem do ícone, para ícones padrões coloque ''
'Req_skills' => [51, 53], # Skills necessárias para abrir a habilidade, qualquer quantidade
'Req_levels' => [7, 5], # Mesmo que acima, mas para os leveis de cada skill
'Desc1' => 'Blaze - Ataque de Fogo Supremo', # Descrição 1
'Desc2' => 'Requer: Level 20 + 5x Level da habilidade', # Descrição 2
'Desc3' => '', # Descrição 3
}
  #=========================================================================
  # Actor 8 => Skill 4 -> Wind                                
  #=========================================================================
Actor[8][4] = {
'Skill_id' => 67, # ID da habilidade no database
'Maxlevel' => 10, # Level máximo da habilidade
'Multiply' => 30, # Multiplicador do efeito em % 100 = 100%
'Level' => 1, # Level necessário para abrir habilidade
'Level_Add' => 2, # Adição do level necessário a cada level da habilidade
'Tree' => 1, # A árvore que essa habilidade pertence
'Left' => 1, # Skill a esquerda na árvore, 0 para nenhum
'Right' => 6, # Skill a direita na árvore, 0 para nenhum
'Down' => 5, # Skill abaixo na árvore, 0 para nenhum
'Up' => 0, # Skill acima na árvore, 0 para nenhum
'X' => 130, # Posição do ícone em X
'Y' => 50, # Posição do ícone em Y
'Image' => 'Wind', # Imagem do ícone, para ícones padrões coloque ''
'Req_skills' => [], # Skills necessárias para abrir a habilidade, qualquer quantidade
'Req_levels' => [], # Mesmo que acima, mas para os leveis de cada skill
'Desc1' => 'Wind - Ataque de Vento', # Descrição 1
'Desc2' => 'Requer: Level 1 + 2x Level da habilidade', # Descrição 2
'Desc3' => '', # Descrição 3
}
  #=========================================================================
  # Actor 8 => Skill 5 -> Hurricane                                 
  #=========================================================================
Actor[8][5] = {
'Skill_id' => 68, # ID da habilidade no database
'Maxlevel' => 5, # Level máximo da habilidade
'Multiply' => 30, # Multiplicador do efeito em % 100 = 100%
'Level' => 10, # Level necessário para abrir habilidade
'Level_Add' => 5, # Adição do level necessário a cada level da habilidade
'Tree' => 1, # A árvore que essa habilidade pertence
'Left' => 2, # Skill a esquerda na árvore, 0 para nenhum
'Right' => 7, # Skill a direita na árvore, 0 para nenhum
'Down' => 0, # Skill abaixo na árvore, 0 para nenhum
'Up' => 4, # Skill acima na árvore, 0 para nenhum
'X' => 130, # Posição do ícone em X
'Y' => 150, # Posição do ícone em Y
'Image' => 'Hurricane', # Imagem do ícone, para ícones padrões coloque ''
'Req_skills' => [67], # Skills necessárias para abrir a habilidade, qualquer quantidade
'Req_levels' => [5], # Mesmo que acima, mas para os leveis de cada skill
'Desc1' => 'Hurricane - Furacão', # Descrição 1
'Desc2' => 'Requer: Level 10 + 5x Level da habilidade', # Descrição 2
'Desc3' => '', # Descrição 3
}
  #=========================================================================
  # Actor 8 => Skill 6 -> Ice                                
  #=========================================================================
Actor[8][6] = {
'Skill_id' => 55, # ID da habilidade no database
'Maxlevel' => 10, # Level máximo da habilidade
'Multiply' => 30, # Multiplicador do efeito em % 100 = 100%
'Level' => 1, # Level necessário para abrir habilidade
'Level_Add' => 2, # Adição do level necessário a cada level da habilidade
'Tree' => 1, # A árvore que essa habilidade pertence
'Left' => 4, # Skill a esquerda na árvore, 0 para nenhum
'Right' => 8, # Skill a direita na árvore, 0 para nenhum
'Down' => 7, # Skill abaixo na árvore, 0 para nenhum
'Up' => 0, # Skill acima na árvore, 0 para nenhum
'X' => 230, # Posição do ícone em X
'Y' => 50, # Posição do ícone em Y
'Image' => 'Ice', # Imagem do ícone, para ícones padrões coloque ''
'Req_skills' => [], # Skills necessárias para abrir a habilidade, qualquer quantidade
'Req_levels' => [], # Mesmo que acima, mas para os leveis de cada skill
'Desc1' => 'Ice - Ataque de Gelo', # Descrição 1
'Desc2' => 'Requer: Level 1 + 2x Level da habilidade', # Descrição 2
'Desc3' => '', # Descrição 3
}
  #=========================================================================
  # Actor 8 => Skill 7 -> Blizzard                                  
  #=========================================================================
Actor[8][7] = {
'Skill_id' => 57, # ID da habilidade no database
'Maxlevel' => 5, # Level máximo da habilidade
'Multiply' => 30, # Multiplicador do efeito em % 100 = 100%
'Level' => 10, # Level necessário para abrir habilidade
'Level_Add' => 5, # Adição do level necessário a cada level da habilidade
'Tree' => 1, # A árvore que essa habilidade pertence
'Left' => 5, # Skill a esquerda na árvore, 0 para nenhum
'Right' => 9, # Skill a direita na árvore, 0 para nenhum
'Down' => 0, # Skill abaixo na árvore, 0 para nenhum
'Up' => 6, # Skill acima na árvore, 0 para nenhum
'X' => 230, # Posição do ícone em X
'Y' => 150, # Posição do ícone em Y
'Image' => 'Blizzard', # Imagem do ícone, para ícones padrões coloque ''
'Req_skills' => [55], # Skills necessárias para abrir a habilidade, qualquer quantidade
'Req_levels' => [5], # Mesmo que acima, mas para os leveis de cada skill
'Desc1' => 'Blizzard - Ataque de gelo em área', # Descrição 1
'Desc2' => 'Requer: Level 10 + 5x Level da habilidade', # Descrição 2
'Desc3' => '', # Descrição 3
}
  #=========================================================================
  # Actor 8 => Skill 8 -> Thunder                                   
  #=========================================================================
Actor[8][8] = {
'Skill_id' => 59, # ID da habilidade no database
'Maxlevel' => 10, # Level máximo da habilidade
'Multiply' => 30, # Multiplicador do efeito em % 100 = 100%
'Level' => 1, # Level necessário para abrir habilidade
'Level_Add' => 2, # Adição do level necessário a cada level da habilidade
'Tree' => 1, # A árvore que essa habilidade pertence
'Left' => 6, # Skill a esquerda na árvore, 0 para nenhum
'Right' => 0, # Skill a direita na árvore, 0 para nenhum
'Down' => 9, # Skill abaixo na árvore, 0 para nenhum
'Up' => 0, # Skill acima na árvore, 0 para nenhum
'X' => 330, # Posição do ícone em X
'Y' => 50, # Posição do ícone em Y
'Image' => 'thunder', # Imagem do ícone, para ícones padrões coloque ''
'Req_skills' => [], # Skills necessárias para abrir a habilidade, qualquer quantidade
'Req_levels' => [], # Mesmo que acima, mas para os leveis de cada skill
'Desc1' => 'Thunder - Ataque de Trovão', # Descrição 1
'Desc2' => 'Requer: Level 1 + 2x Level da habilidade', # Descrição 2
'Desc3' => '', # Descrição 3
}
  #=========================================================================
  # Actor 8 => Skill 9 -> Spark                                 
  #=========================================================================
Actor[8][9] = {
'Skill_id' => 61, # ID da habilidade no database
'Maxlevel' => 5, # Level máximo da habilidade
'Multiply' => 30, # Multiplicador do efeito em % 100 = 100%
'Level' => 10, # Level necessário para abrir habilidade
'Level_Add' => 5, # Adição do level necessário a cada level da habilidade
'Tree' => 1, # A árvore que essa habilidade pertence
'Left' => 7, # Skill a esquerda na árvore, 0 para nenhum
'Right' => 0, # Skill a direita na árvore, 0 para nenhum
'Down' => 0, # Skill abaixo na árvore, 0 para nenhum
'Up' => 8, # Skill acima na árvore, 0 para nenhum
'X' => 330, # Posição do ícone em X
'Y' => 150, # Posição do ícone em Y
'Image' => 'Spark', # Imagem do ícone, para ícones padrões coloque ''
'Req_skills' => [59], # Skills necessárias para abrir a habilidade, qualquer quantidade
'Req_levels' => [5], # Mesmo que acima, mas para os leveis de cada skill
'Desc1' => 'Spark - Ataque de Trovão em Área', # Descrição 1
'Desc2' => 'Requer: Level 10 + 5x Level da habilidade', # Descrição 2
'Desc3' => '', # Descrição 3
}
  #=========================================================================
  # Actor 8 => Skill 10 -> Cura                                 
  #=========================================================================
Actor[8][10] = {
'Skill_id' => 26, # ID da habilidade no database
'Maxlevel' => 10, # Level máximo da habilidade
'Multiply' => 20, # Multiplicador do efeito em % 100 = 100%
'Level' => 1, # Level necessário para abrir habilidade
'Level_Add' => 3, # Adição do level necessário a cada level da habilidade
'Tree' => 2, # A árvore que essa habilidade pertence
'Left' => 0, # Skill a esquerda na árvore, 0 para nenhum
'Right' => 12, # Skill a direita na árvore, 0 para nenhum
'Down' => 11, # Skill abaixo na árvore, 0 para nenhum
'Up' => 0, # Skill acima na árvore, 0 para nenhum
'X' => 100, # Posição do ícone em X
'Y' => 100, # Posição do ícone em Y
'Image' => 'Cura1', # Imagem do ícone, para ícones padrões coloque ''
'Req_skills' => [], # Skills necessárias para abrir a habilidade, qualquer quantidade
'Req_levels' => [], # Mesmo que acima, mas para os leveis de cada skill
'Desc1' => 'Recuperação de vida básica', # Descrição 1
'Desc2' => 'Requer: Level 1 + 3x Level da habilidade', # Descrição 2
'Desc3' => '', # Descrição 3
}
  #=========================================================================
  # Actor 8 => Skill 11 -> Salvation                                  
  #=========================================================================
Actor[8][11] = {
'Skill_id' => 28, # ID da habilidade no database
'Maxlevel' => 10, # Level máximo da habilidade
'Multiply' => 30, # Multiplicador do efeito em % 100 = 100%
'Level' => 15, # Level necessário para abrir habilidade
'Level_Add' => 5, # Adição do level necessário a cada level da habilidade
'Tree' => 2, # A árvore que essa habilidade pertence
'Left' => 0, # Skill a esquerda na árvore, 0 para nenhum
'Right' => 13, # Skill a direita na árvore, 0 para nenhum
'Down' => 0, # Skill abaixo na árvore, 0 para nenhum
'Up' => 10, # Skill acima na árvore, 0 para nenhum
'X' => 100, # Posição do ícone em X
'Y' => 240, # Posição do ícone em Y
'Image' => 'Salvation', # Imagem do ícone, para ícones padrões coloque ''
'Req_skills' => [26], # Skills necessárias para abrir a habilidade, qualquer quantidade
'Req_levels' => [8], # Mesmo que acima, mas para os leveis de cada skill
'Desc1' => 'Salvation - Recuperação de Vida avançada', # Descrição 1
'Desc2' => 'Requer: Level 15 + 5x Level da habilidade', # Descrição 2
'Desc3' => '', # Descrição 3
}
  #=========================================================================
  # Actor 8 => Skill 12 -> Attack Up                                  
  #=========================================================================
Actor[8][12] = {
'Skill_id' => 41, # ID da habilidade no database
'Maxlevel' => 7, # Level máximo da habilidade
'Multiply' => 30, # Multiplicador do efeito em % 100 = 100%
'Level' => 20, # Level necessário para abrir habilidade
'Level_Add' => 5, # Adição do level necessário a cada level da habilidade
'Tree' => 2, # A árvore que essa habilidade pertence
'Left' => 10, # Skill a esquerda na árvore, 0 para nenhum
'Right' => 0, # Skill a direita na árvore, 0 para nenhum
'Down' => 13, # Skill abaixo na árvore, 0 para nenhum
'Up' => 0, # Skill acima na árvore, 0 para nenhum
'X' => 300, # Posição do ícone em X
'Y' => 100, # Posição do ícone em Y
'Image' => 'Attack_Up', # Imagem do ícone, para ícones padrões coloque ''
'Req_skills' => [26, 11], # Skills necessárias para abrir a habilidade, qualquer quantidade
'Req_levels' => [10, 3], # Mesmo que acima, mas para os leveis de cada skill
'Desc1' => 'Attack Up - Aumenta a força ofensiva', # Descrição 1
'Desc2' => 'Requer: Level 20 + 5x Level da habilidade', # Descrição 2
'Desc3' => '', # Descrição 3
}
  #=========================================================================
  # Actor 8 => Skill 13 -> Magic UP                                   
  #=========================================================================
Actor[8][13] = {
'Skill_id' => 120, # ID da habilidade no database
'Maxlevel' => 5, # Level máximo da habilidade
'Multiply' => 40, # Multiplicador do efeito em % 100 = 100%
'Level' => 25, # Level necessário para abrir habilidade
'Level_Add' => 7, # Adição do level necessário a cada level da habilidade
'Tree' => 2, # A árvore que essa habilidade pertence
'Left' => 11, # Skill a esquerda na árvore, 0 para nenhum
'Right' => 0, # Skill a direita na árvore, 0 para nenhum
'Down' => 0, # Skill abaixo na árvore, 0 para nenhum
'Up' => 12, # Skill acima na árvore, 0 para nenhum
'X' => 300, # Posição do ícone em X
'Y' => 240, # Posição do ícone em Y
'Image' => 'MagicUP', # Imagem do ícone, para ícones padrões coloque ''
'Req_skills' => [12], # Skills necessárias para abrir a habilidade, qualquer quantidade
'Req_levels' => [4], # Mesmo que acima, mas para os leveis de cada skill
'Desc1' => 'Magic Up - Aumenta o poder mágico', # Descrição 1
'Desc2' => 'Requer: Level 25 + 7x Level da habilidade', # Descrição 2
'Desc3' => '', # Descrição 3
}

  #=========================================================================
  # Actor 9 => Skill 1 -> ...                              
  #=========================================================================
  
  

end


#==============================================================================
# ** Scene_Skill
#------------------------------------------------------------------------------
#  Esta classe executa o processamento da tela de habilidades. Por conveniência
# dos processos em comum, as habilidades são tratdas como [Itens].
#==============================================================================

class Scene_Skill < Scene_ItemBase
include Lune_Skill_Tree
  #--------------------------------------------------------------------------
  # * Inicialização do processo
  #--------------------------------------------------------------------------
  def start
    super
    create_actor_window
    create_windows
    create_tree
    create_images
    create_variables
  end
  #--------------------------------------------------------------------------
  # * Criação das Janelas
  #--------------------------------------------------------------------------
  def create_windows
    @info_window = Sk_Tree_Window.new
    @dummy = []
    for n in 0...Actor[@actor.id][0]['Tree_Images'].size
      @dummy[n] = Window_Base.new(0, 0, Graphics.width, Graphics.height - Win_Size)
      @dummy[n].opacity = Opacity
      @dummy[n].opacity = 0 unless n == 0
    end
    @info_skill = Sk_Descri_Window.new(0, Graphics.height - Win_Size, Graphics.width, Win_Size)
    @info_window.refresh(@actor, 0)
    @info_skill.refresh(@actor.id, 1)
    @info_skill.opacity = Opacity
    @confirm = Window_Skill_Confirm.new # inicialização do menu de confirmação
    @confirm.set_handler(:use_skill, method(:determine_item))
    @confirm.set_handler(:use_point, method(:command_use_point))
    @confirm.set_handler(:return_window, method(:command_return))
    @confirm.close
    @confirm.active = false
    @actor_window = Window_MenuActor_Tree.new
    @actor_window.set_handler(:ok,     method(:on_actor_ok))
    @actor_window.set_handler(:cancel, method(:on_actor_cancel))
    @actor_window.z = 201
  end
  #--------------------------------------------------------------------------
  # * Criação de habilidades
  #--------------------------------------------------------------------------
  def create_tree
    @skills_icons = []
    for n in 1...Actor[@actor.id].size
      @skills_icons[n] = Sprite.new
      @skills_icons[n].bitmap = Cache.skill_tree(Actor[@actor.id][n]['Image'])
      @skills_icons[n].x = Actor[@actor.id][n]['X']
      @skills_icons[n].y = Actor[@actor.id][n]['Y']
      @skills_icons[n].z = 199
      @skills_icons[n].opacity = 150 if $game_actors[@actor.id].skill_tree[Actor[@actor.id][n]['Skill_id']] == 0
    end
    @skills_icons.each_index {|n| @skills_icons[n].opacity = 0 if Actor[@actor.id][n]['Tree'] != 1 && n != 0}
  end
  #--------------------------------------------------------------------------
  # * Criação de Imagens
  #--------------------------------------------------------------------------
  def create_images
    @cursor = Sprite.new
    @cursor.bitmap = Cache.skill_tree(Cursor)
    @actor_image = Sprite.new
    @actor_image.bitmap = Cache.skill_tree(Actor_Select)
    @actor_image.z = 200
    @actor_image.opacity = 0
    @background_image = Array.new
    for n in 0...Actor[@actor.id][0]['Tree_Images'].size
      @background_image[n] = Sprite.new
      @background_image[n].bitmap = Cache.skill_tree(Actor[@actor.id][0]['Tree_Images'][n])
    end
    @cursor.z = 300
    @background_image.each_index {|n| @background_image[n].opacity = 0 unless n == 0}
  end
  #--------------------------------------------------------------------------
  # * Criação das Variáveis
  #--------------------------------------------------------------------------
  def create_variables
    @goto_x = 0
    @goto_y = 0
    @tree = 0
    @phase = 1
    @count = 15
    @skill_selected = 0
    Actor[@actor.id].each{|n| @phase = 0 if n['Tree'] == 2}
    move_to_cursor(Actor[@actor.id][0]['Tree_Shift'][@tree][0], Actor[@actor.id][0]['Tree_Shift'][@tree][1])
  end
  #--------------------------------------------------------------------------
  # * Atualização do Processo
  #--------------------------------------------------------------------------
  def update
    super
    return if @actor_window.active
    @actor_image.opacity = 0
    unless @confirm.close?
      if Input.repeat?(:B)
        @confirm.close
        @confirm.active = false
      end
      return
    end
    if @goto_x != @cursor.x || @goto_y != @cursor.y
      cursor_move 
      return
    end
    if @count < 15
      update_tree_opacity(@tree)
      return
    end
    case @phase
    when 0
      update_tree
    when 1
      update_skills
    end
  end
  #--------------------------------------------------------------------------
  # * Atualização da árvore
  #--------------------------------------------------------------------------
  def update_tree
    return_scene if Input.repeat?(:B)
    if Input.repeat?(:RIGHT)
      if @tree + 1 == Actor[@actor.id][0]['Tree_Shift'].size
        @tree = 0
      else
        @tree += 1
      end
      @count = 0
      @info_window.contents_opacity = 0
      @info_window.refresh(@actor, @tree)
      move_to_cursor(Actor[@actor.id][0]['Tree_Shift'][@tree][0], Actor[@actor.id][0]['Tree_Shift'][@tree][1])
    elsif Input.repeat?(:LEFT)
      if @tree - 1 < 0
        @tree = Actor[@actor.id][0]['Tree_Shift'].size - 1
      else
        @tree -= 1
      end
      @info_window.contents_opacity = 0
      @info_window.refresh(@actor, @tree)
      move_to_cursor(Actor[@actor.id][0]['Tree_Shift'][@tree][0], Actor[@actor.id][0]['Tree_Shift'][@tree][1])
      @count = 0
    elsif Input.repeat?(:UP)
      if @tree - 1 < 0
        @tree = Actor[@actor.id][0]['Tree_Shift'].size - 1
      else
        @tree -= 1
      end
      @info_window.contents_opacity = 0
      @info_window.refresh(@actor, @tree)
      move_to_cursor(Actor[@actor.id][0]['Tree_Shift'][@tree][0], Actor[@actor.id][0]['Tree_Shift'][@tree][1])
      @count = 0
    elsif Input.repeat?(:DOWN)
      if @tree + 1 == Actor[@actor.id][0]['Tree_Shift'].size
        @tree = 0
      else
        @tree += 1
      end
      @count = 0
      @info_window.contents_opacity = 0
      @info_window.refresh(@actor, @tree)
      move_to_cursor(Actor[@actor.id][0]['Tree_Shift'][@tree][0], Actor[@actor.id][0]['Tree_Shift'][@tree][1])
    elsif Input.repeat?(:C)
      @phase = 1
      n = 0
      n += 1 until Actor[@actor.id][n]['Tree'] == @tree + 1
      @skill_selected = n
      @info_skill.refresh(@actor.id, @skill_selected)
      move_to_cursor(Actor[@actor.id][n]['X'], Actor[@actor.id][n]['Y'])
    end
  end
  #--------------------------------------------------------------------------
  # * Comando de usar um skill point
  #--------------------------------------------------------------------------
  def command_use_point
    if $game_actors[@actor.id].skill_tree[0] == 0 || confirm_skill_add
      Sound.play_buzzer
      @confirm.close
      @confirm.active = false
    else
      @skills_icons[@skill_selected].opacity = 255
      $game_actors[@actor.id].skill_tree[0] -= 1
      $game_actors[@actor.id].skill_mult[Actor[@actor.id][@skill_selected]['Skill_id']] += Actor[@actor.id][@skill_selected]['Multiply']
      $game_actors[@actor.id].skill_tree[Actor[@actor.id][@skill_selected]['Skill_id']] += 1
      $game_actors[@actor.id].learn_skill(Actor[@actor.id][@skill_selected]['Skill_id'])
      @info_window.refresh(@actor, @tree)
      Sound.play_ok
      @confirm.close
      @confirm.active = false
    end
  end
  #--------------------------------------------------------------------------
  # * Comando de retorno
  #--------------------------------------------------------------------------
  def command_return
    @confirm.close
  end
  #--------------------------------------------------------------------------
  # * Atualização de habilidades
  #--------------------------------------------------------------------------
  def update_skills
    if Input.trigger?(:B)
      Sound.play_cancel
      @phase = 1
      Actor[@actor.id].each{|n| @phase = 0 if n['Tree'] == 2}
      return_scene if @phase == 1
      move_to_cursor(Actor[@actor.id][0]['Tree_Shift'][@tree][0], Actor[@actor.id][0]['Tree_Shift'][@tree][1])
    elsif Input.repeat?(:RIGHT)
      unless Actor[@actor.id][@skill_selected]['Right'] == 0
        @skill_selected = Actor[@actor.id][@skill_selected]['Right']
        @info_skill.refresh(@actor.id, @skill_selected)
        move_to_cursor(Actor[@actor.id][@skill_selected]['X'], Actor[@actor.id][@skill_selected]['Y'])
      end
    elsif Input.repeat?(:LEFT)
      unless Actor[@actor.id][@skill_selected]['Left'] == 0
        @skill_selected = Actor[@actor.id][@skill_selected]['Left']
        @info_skill.refresh(@actor.id, @skill_selected)
        move_to_cursor(Actor[@actor.id][@skill_selected]['X'], Actor[@actor.id][@skill_selected]['Y'])
      end
    elsif Input.repeat?(:UP)
      unless Actor[@actor.id][@skill_selected]['Up'] == 0
        @skill_selected = Actor[@actor.id][@skill_selected]['Up']
        @info_skill.refresh(@actor.id, @skill_selected)
        move_to_cursor(Actor[@actor.id][@skill_selected]['X'], Actor[@actor.id][@skill_selected]['Y'])
      end
    elsif Input.repeat?(:DOWN)
      unless Actor[@actor.id][@skill_selected]['Down'] == 0
        @skill_selected = Actor[@actor.id][@skill_selected]['Down']
        @info_skill.refresh(@actor.id, @skill_selected)
        move_to_cursor(Actor[@actor.id][@skill_selected]['X'], Actor[@actor.id][@skill_selected]['Y'])
      end
    elsif Input.repeat?(:C)
      @confirm.open
      @confirm.active = true
    end
  end
  #--------------------------------------------------------------------------
  # * Atualização da opacidade da Skill Tree
  #--------------------------------------------------------------------------
  def update_tree_opacity(tree)
    @count += 1
    @info_window.contents_opacity += 20
    @background_image.each_index {|n| @background_image[n].opacity -= 20 unless n == @tree}
    @background_image.each_index {|n| @background_image[n].opacity += 20 if n == @tree}
    @skills_icons.each_index {|n| @skills_icons[n].opacity -= 10 if Actor[@actor.id][n]['Tree'] != @tree + 1 && n != 0}
    @skills_icons.each_index {|n| @skills_icons[n].opacity += 10 if Actor[@actor.id][n]['Tree'] == @tree + 1 && n != 0}
    @skills_icons.each_index {|n| @skills_icons[n].opacity -= 10 if n != 0 && $game_actors[@actor.id].skill_tree[Actor[@actor.id][n]['Skill_id']] > 0 && Actor[@actor.id][n]['Tree'] != @tree + 1}
    @skills_icons.each_index {|n| @skills_icons[n].opacity += 10 if n != 0 && $game_actors[@actor.id].skill_tree[Actor[@actor.id][n]['Skill_id']] > 0 && Actor[@actor.id][n]['Tree'] == @tree + 1}
  end
  #--------------------------------------------------------------------------
  # * Cálculo da posição do cursor
  #--------------------------------------------------------------------------
  def move_to_cursor(x, y)
    Sound.play_cursor
    @goto_x = x + Cursor_X
    @goto_y = y + Cursor_Y
    @speed_x = (@goto_x - @cursor.x)/ 10
    @speed_y = (@goto_y - @cursor.y)/ 10
  end
  #--------------------------------------------------------------------------
  # * Atualização da posição do cursor
  #--------------------------------------------------------------------------
  def cursor_move
    if (@cursor.x - @goto_x).abs >= 10
      @cursor.x += @speed_x
    elsif (@cursor.x - @goto_x).abs != 0
      @cursor.x -= (@cursor.x - @goto_x)
    end
    if (@cursor.y - @goto_y).abs >= 10
      @cursor.y += @speed_y
    elsif (@cursor.y - @goto_y).abs != 0
      @cursor.y -= (@cursor.y - @goto_y)
    end
  end
  #--------------------------------------------------------------------------
  # * Aquisição das informações do item selecionado
  #--------------------------------------------------------------------------
  def item
    $data_skills[Actor[@actor.id][@skill_selected]['Skill_id']]
  end
  #--------------------------------------------------------------------------
  # * Usando um item
  #--------------------------------------------------------------------------
  def use_item
    super
    @actor_window.open
  end
  #--------------------------------------------------------------------------
  # * Definição do item
  #--------------------------------------------------------------------------
  def determine_item
    if item.for_friend? && $game_actors[@actor.id].skill_tree[Actor[@actor.id][@skill_selected]['Skill_id']] > 0
      show_sub_window(@actor_window)
      @confirm.close
      @confirm.active = false
      @actor_image.opacity = 255
      @actor_image.x = 0
      @actor_image.x += Graphics.width - @actor_window.width if cursor_left?
      @actor_window.select_for_item(item)
    else
      @confirm.close
      @confirm.active = false
      Sound.play_buzzer
    end
  end
  #--------------------------------------------------------------------------
  # * Definição de cursor na coluna da esquerda
  #--------------------------------------------------------------------------
  def cursor_left?
    @cursor.x < Graphics.width/2
  end
  #--------------------------------------------------------------------------
  # * Ativação da janela do item
  #--------------------------------------------------------------------------
  def activate_item_window
  end
  #--------------------------------------------------------------------------
  # * Confirmação se adicionará um ponto
  #--------------------------------------------------------------------------
  def confirm_skill_add
    return true if $game_actors[@actor.id].skill_tree[Actor[@actor.id][@skill_selected]['Skill_id']] == Actor[@actor.id][@skill_selected]['Maxlevel']
    return true if $game_actors[@actor.id].level < Actor[@actor.id][@skill_selected]['Level'] + $game_actors[@actor.id].skill_tree[Actor[@actor.id][@skill_selected]['Skill_id']] * Actor[@actor.id][@skill_selected]['Level_Add']
    return false if Actor[@actor.id][@skill_selected]['Req_skills'].empty?
    for n in 0...Actor[@actor.id][@skill_selected]['Req_skills'].size
      return true if $game_actors[@actor.id].skill_tree[Actor[@actor.id][@skill_selected]['Req_skills'][n]] < Actor[@actor.id][@skill_selected]['Req_levels'][n]
    end
    return false
  end
  #--------------------------------------------------------------------------
  # * Finalização do processo
  #--------------------------------------------------------------------------
  def terminate
    super
    @background_image.each{|n| n.bitmap.dispose; n.dispose}
    @actor_image.bitmap.dispose
    @actor_image.dispose
    @skills_icons.each{|n| n.bitmap.dispose unless n == nil; n.dispose unless n == nil}
    @cursor.bitmap.dispose
    @cursor.dispose
  end 
  #--------------------------------------------------------------------------
  # * retorna a cena anterior
  #--------------------------------------------------------------------------
  def return_scene
    Sound.play_cancel
    super
  end
end


#==============================================================================
# ** Sk_Tree_Window
#------------------------------------------------------------------------------
#  Esta janela exibe os pontos das habilidades
#==============================================================================
class Sk_Tree_Window < Window_Base
include Lune_Skill_Tree
  #--------------------------------------------------------------------------
  # * Inicialização
  #--------------------------------------------------------------------------
  def initialize
    super(0, 0, Graphics.width, Graphics.height)
    self.z = 200
    self.opacity = 0
  end
  #--------------------------------------------------------------------------
  # * Atualização
  #--------------------------------------------------------------------------
  def refresh(actor, tree)
    contents.clear
    tree += 1
    act = Actor[actor.id]
    contents.font.size = Font_Skills + 8
    contents.font.name = Font_Name unless Font_Name.empty?
    draw_text(Text_X, Text_Y, 300, 40, Text + actor.skill_tree[0].to_s + " / " + actor.skill_tree.sum.to_s, 0)
    contents.font.size = Font_Skills
    for n in 1...Actor[actor.id].size
      if tree == act[n]['Tree']
        draw_icon($data_skills[act[n]['Skill_id']].icon_index, act[n]['X'], act[n]['Y']) if act[n]['Image'].empty?
        draw_text(act[n]['X'] + Corr_X, act[n]['Y'] + Corr_Y, 120, 30, $game_actors[actor.id].skill_tree[act[n]['Skill_id']].to_s + "/" + act[n]['Maxlevel'].to_s, 0)
      end
    end
    reset_font_settings
  end
end

#==============================================================================
# ** Sk_Descri_Window
#------------------------------------------------------------------------------
#  Esta janela exibe as informações das habilidades
#==============================================================================
class Sk_Descri_Window < Window_Base
include Lune_Skill_Tree
  #--------------------------------------------------------------------------
  # * Inicialização
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height)
    super(x, y, width, height)
  end
  #--------------------------------------------------------------------------
  # * Atualização
  #--------------------------------------------------------------------------
  def refresh(actor_id, skill)
    contents.clear
    contents.font.size = Font_Help
    contents.font.name = Font_Name unless Font_Name.empty?
    draw_text(0, 0, self.width, line_height, Actor[actor_id][skill]['Desc1'], 0)
    draw_text(0, line_height, self.width, line_height, Actor[actor_id][skill]['Desc2'], 0)
    draw_text(0, line_height*2, self.width, line_height, Actor[actor_id][skill]['Desc3'], 0)
    reset_font_settings
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
alias :lune_sk_initialize :initialize
alias :lune_sk_level_up :level_up
  #--------------------------------------------------------------------------
  # * Variáveis públicas
  #--------------------------------------------------------------------------
  attr_accessor :skill_tree                  # Nome
  attr_accessor :skill_mult
  #--------------------------------------------------------------------------
  # * Inicialização do objeto
  #     actor_id : ID do herói
  #--------------------------------------------------------------------------
  def initialize(actor_id)
    lune_sk_initialize(actor_id)
    @skill_tree = Array.new($data_skills.size + 1, 0)
    @skill_mult = Array.new($data_skills.size + 1, 0)
  end
  #--------------------------------------------------------------------------
  # * Aumento de nível
  #--------------------------------------------------------------------------
  def level_up
    lune_sk_level_up
    @skill_tree[0] += 1 if Lune_Skill_Tree::Add_Skill_pt
  end
end


#==============================================================================
# ** Window_Skill_Confirm
#------------------------------------------------------------------------------
#  Esta janela exibe a confirmação da janela de skills
#==============================================================================

class Window_Skill_Confirm < Window_Command

  #--------------------------------------------------------------------------
  # * Inicialização do objeto
  #--------------------------------------------------------------------------
  def initialize
    super(0, 0)
    self.z = 9999
    self.x = (Graphics.width / 2) - (window_width / 2)
    self.y = Graphics.height / 2
    self.openness = 0
  end
  #--------------------------------------------------------------------------
  # * Aquisição da largura da janela
  #--------------------------------------------------------------------------
  def window_width
    return 160
  end
  #--------------------------------------------------------------------------
  # * Criação da lista de comandos
  #--------------------------------------------------------------------------
  def make_command_list
    add_main_commands
  end
  #--------------------------------------------------------------------------
  # * Adição dos comandos principais
  #--------------------------------------------------------------------------
  def add_main_commands
    add_command(Lune_Skill_Tree::Bot1,   :use_skill,   true)
    add_command(Lune_Skill_Tree::Bot2,  :use_point,  true)
    add_command(Lune_Skill_Tree::Bot3,  :return_window,  true)
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
  def self.skill_tree(filename)
    load_bitmap("Graphics/Skill_Tree/", filename)
  end
end

#==============================================================================
# ** Window_MenuActor_Tree
#------------------------------------------------------------------------------
#  Esta janela é utilizada para selecionar os herois para as habilidades.
#==============================================================================

class Window_MenuActor_Tree < Window_MenuActor
include Lune_Skill_Tree
  #--------------------------------------------------------------------------
  # * Inicialização do objeto
  #--------------------------------------------------------------------------
  def initialize
    super
    self.opacity = Opacity
  end
end

#==============================================================================
# ** Game_Interpreter
#------------------------------------------------------------------------------
#  Um interpretador para executar os comandos de evento. Esta classe é usada
# internamente pelas classes Game_Map, Game_Troop e Game_Event.
#==============================================================================

class Game_Interpreter
  #--------------------------------------------------------------------------
  # * Adicionar pontos para o personagem
  #--------------------------------------------------------------------------
  def add_tree_points(actor_id, points)
    $game_actors[actor_id].skill_tree[0] += points
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
alias :item_rai_lune_effect :item_effect_apply
  #--------------------------------------------------------------------------
  # * Cálculo de dano
  #     user : usuário
  #     item : habilidade/item
  #--------------------------------------------------------------------------
  def make_damage_value(user, item)
    value = item.damage.eval(user, self, $game_variables)
    value *= item_element_rate(user, item)
    value *= pdr if item.physical?
    value *= mdr if item.magical?
    value *= rec if item.damage.recover?
    value = apply_critical(value) if @result.critical
    value = apply_variance(value, item.damage.variance)
    value = apply_guard(value)
    value += (value * $game_actors[user.id].skill_mult[item.id])/100 unless user.enemy?
    @result.make_damage(value.to_i, item)
  end
  #--------------------------------------------------------------------------
  # * Aplicar efeito do uso habilidades/itens
  #     user   : usuário
  #     item   : habilidade/item
  #     effect : efeito
  #--------------------------------------------------------------------------
  def item_effect_apply(user, item, effect)
    @old_value1 = effect.value1
    @old_value2 = effect.value2
    effect.value1 += (effect.value1 * $game_actors[user.id].skill_mult[item.id])/100 unless user.enemy?
    effect.value2 += (effect.value2 * $game_actors[user.id].skill_mult[item.id])/100 unless user.enemy?
    item_rai_lune_effect(user, item, effect)
    effect.value1 = @old_value1 unless user.enemy?
    effect.value2 = @old_value2 unless user.enemy?
  end
end


#==============================================================================
# ** Arrays
#------------------------------------------------------------------------------
# Novo método para somar os valores dentro da array
#==============================================================================
class Array
  def sum
    a = 0
    for n in 0...size
      a += self[n]
    end
    return a
  end
end
