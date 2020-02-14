module Lune_Custom_Config
Janela = []


#=======================================================
#         Lune Custom Window
# Autor: Raizen
# Comunidade: www.centrorpg.com
# O script permite que uma janela seja criada seguindo 
# as especificações do usuário, assim mesmo sem conhecimento
# algum em scripts, é possível criar uma tela para auxiliar 
# nos sistemas por eventos.
#=======================================================

# Como o script permite infinitas Janelas a serem criadas, uma variável será
# quem irá decidir qual janela aparecerá e ela é essa.
# $lune_custom_scene
# para escolher a janela 3 por exemplo basta,
# Chamar Script: $lune_custom_scene = 3

# Para ativar a Janela personalizada
# Chamar Script: SceneManager.call(Lune_Custom_Scene)


# é possível criar inúmeras janelas seguindo o template, 
# leia atentamente.

# IMPORTANTE:

# Para qualquer campo em branco, deixe da seguinte maneira "",
# Exemplo, não tenho imagens para colocar então...
# 'Pictures' => "",

# Imagens na pasta Graphics/Custom_Win, será necessário criar esse diretório.
#===========================================================================
#---------------------------------------------------------------------------
#  Janela 0, Essa janela cria absolutamente nada :) (descrição da sua janela)
#---------------------------------------------------------------------------
#===========================================================================


Janela[0] = { #Coloque o ID da janela a sua escolha, Janela[id]

# tempo de Fadein, exemplo 'Fadein' => 10,
'Fadein' => 10, 

# Nome da fonte, "" para pegar a fonte padrão, Ex 'FontName' => "Comic Sans MS",
'FontName' => "", 

# Som a ser tocado ao sair da tela , Ex: 'Sound' => "Cancel2",
'Sound' => "Cancel2",

# Janelas criadas, seguindo o seguinte template,
# 'Windows' => [[posição x, posição y, largura, altura]],
# é possível colocar um número ilimitado de janelas, basta colocar virgula
# e abrir outro colchete, exemplo com 3 janelas,
# 'Windows' => [[0, 0, 100, 100],[100, 100, 100, 100], [1, 2, 3, 4]],
# Depois da virgula pode pular linhas, ex:
# 'Windows' => [[0, 0, 100, 100],[100, 100, 100, 100], 
#[1, 2, 3, 4]],
'Windows' => [[0, 0, 100, 100],[100, 100, 100, 100]],

# Textos inseridos na janela, seguindo o template,
# 'Texts' => [["Texto", pos x, pos y, tamanho fonte (0 para padrão, 20), cor da fonte]],
# A cor da fonte é um número que é baseado na windowskin, veja as cores na windowskin.
# Assim como as janelas o procedimento é o mesmo para múltiplos textos.
'Texts' => [["Janela de Relacionamento", 0, 0, 0, 20],["Personagem1", 0, 200, 0, 0]],

# Variáveis inseridos na janela, seguindo o template,
# 'Variables' => [[numero da variavel, pos x, pos y, tamanho fonte(0 = padrão), cor fonte]],
# Ilimitadas variáveis, seguindo a mesma ideia dos demais.
'Variables' => [[1, 50, 70, 0, 1],[2, 50, 270, 20, 21]],

# Imagens inseridas na janela, seguindo o template,
# 'Pictures' => [["NomedaImagem", pos x, pos y, imagem superior ou inferior? true = superior, false = inferior]],
'Pictures' => [["ArrowDown", 200, 200, true],
["ArrowUp", 300, 200, true],
["ArrowLeft", 400, 200, true],
["ArrowRight", 300, 300, true]],

# Faces inseridas na janela, seguindo o template,
# 'Faces' => [['actor' ou 'party'(escolher se o id eh do ator ou da party), id do personagem, pos x, pos y]],
'Faces' => [['actor', 2, 200, 200], ['party', 0, 300, 300]],
# Faces inseridas na janela, seguindo o template,
# 'Faces' => [['actor' ou 'party', id do personagem, pos x, pos y]],
'Characters' => [['actor', 2, 300, 400], ['party', 3, 200, 300]],

}

#===========================================================================
#---------------------------------------------------------------------------
#===========================================================================



#===========================================================================
#---------------------------------------------------------------------------
#  Janela 1, Essa janela tem o sistema de namoro
#  Template reduzido
#---------------------------------------------------------------------------
#===========================================================================


Janela[1] = { 
'Fadein' => 10, 
'FontName' => "", 
'Sound' => "Cancel2",
#[x, y, largura, altura]
'Windows' => [[0, 0, 272, 208],
[272, 0, 272, 208],
[0, 208, 272, 208],
[272, 208, 272, 208]],
#["Texto", x, y, tamanho fonte, cor fonte]
'Texts' => [["Janela de Relacionamento", 120, 0, 0, 30],
["Natty", 0, 30, 0, 0],
["May", 272, 30, 0, 0],
["KaHh", 0, 238, 0, 0],
["Pretty", 272, 238, 0, 0],
["Relacionamento", 100, 50, 0, 0],
["Relacionamento", 372, 50, 0, 0],
["Relacionamento", 100, 258, 0, 0],
["Relacionamento", 372, 258, 0, 0],
["/ 100", 140, 80, 0, 0],
["/ 100", 412, 80, 0, 0],
["/ 100", 140, 288, 0, 0],
["/ 100", 412, 288, 0, 0],
],
#[num variavel, x, y, tamanho fonte, cor fonte]
'Variables' => [
[1, 100, 80, 0, 20],
[2, 372, 80, 0, 20],
[3, 100, 288, 0, 20],
[4, 372, 288, 0, 20],],
#["NomeImagem", x, y, Imagemsuperior?]
'Pictures' => "",
# ['actor' ou 'party', id, x, y]
'Faces' => [['actor', 2, 0, 50], 
['actor', 6, 0, 258], 
['actor', 8, 272, 50], 
['actor', 9, 272, 258],],
# ['actor' ou 'party', id, x, y]
'Characters' => "",

}


#===========================================================================
#---------------------------------------------------------------------------
#===========================================================================


end
#==============================================================================
#              TEMPLATE, NÃO MODIFIQUE, UTILIZE CASO SUA
#              JANELA PAROU DE FUNCIONAR.

=begin

#===========================================================================
#---------------------------------------------------------------------------
#  Janela 0, Essa janela cria absolutamente nada :) (descrição da sua janela)
#---------------------------------------------------------------------------
#===========================================================================

Janela[0] = { #Coloque o ID da janela a sua escolha, Janela[id]

# tempo de Fadein, exemplo 'Fadein' => 10,
'Fadein' => 10, 

# Nome da fonte, "" para pegar a fonte padrão, Ex 'FontName' => "Comic Sans MS",
'FontName' => "", 

# Som a ser tocado ao sair da tela , Ex: 'Sound' => "Cancel2",
'Sound' => "Cancel2",

# Janelas criadas, seguindo o seguinte template,
# 'Windows' => [[posição x, posição y, largura, altura]],
# é possível colocar um número ilimitado de janelas, basta colocar virgula
# e abrir outro colchete, exemplo com 3 janelas,
# 'Windows' => [[0, 0, 100, 100],[100, 100, 100, 100], [1, 2, 3, 4]],
# Depois da virgula pode pular linhas, ex:
# 'Windows' => [[0, 0, 100, 100],[100, 100, 100, 100], 
#[1, 2, 3, 4]],
'Windows' => [[0, 0, 100, 100],[100, 100, 100, 100]],

# Textos inseridos na janela, seguindo o template,
# 'Texts' => [["Texto", pos x, pos y, tamanho fonte (0 para padrão, 20), cor da fonte]],
# A cor da fonte é um número que é baseado na windowskin, veja as cores na windowskin.
# Assim como as janelas o procedimento é o mesmo para múltiplos textos.
'Texts' => [["Janela de Relacionamento", 0, 0, 0, 20],["Personagem1", 0, 200, 0, 0]],

# Variáveis inseridos na janela, seguindo o template,
# 'Variables' => [[numero da variavel, pos x, pos y, tamanho fonte(0 = padrão), cor fonte]],
# Ilimitadas variáveis, seguindo a mesma ideia dos demais.
'Variables' => [[1, 50, 70, 0, 1],[2, 50, 270, 20, 21]],

# Imagens inseridas na janela, seguindo o template,
# 'Pictures' => [["NomedaImagem", pos x, pos y, imagem superior ou inferior? true = superior, false = inferior]],
'Pictures' => [["ArrowDown", 200, 200, true],
["ArrowUp", 300, 200, true],
["ArrowLeft", 400, 200, true],
["ArrowRight", 300, 300, true]],

# Faces inseridas na janela, seguindo o template,
# 'Faces' => [['actor' ou 'party'(escolher se o id eh do ator ou da party), id do personagem, pos x, pos y]],
'Faces' => [['actor', 2, 200, 200], ['party', 0, 300, 300]],
# Faces inseridas na janela, seguindo o template,
# 'Faces' => [['actor' ou 'party', id do personagem, pos x, pos y]],
'Characters' => [['actor', 2, 300, 400], ['party', 3, 200, 300]],

}
#===========================================================================
#---------------------------------------------------------------------------
#===========================================================================


=end



#==============================================================================
#==============================================================================

#                  AQUI COMEÇA O SCRIPT

#==============================================================================
#==============================================================================
$lune_custom_scene = 0


#==============================================================================
# ** Lune_Custom_Scene
#------------------------------------------------------------------------------
#  Esta classe executa os processos de imagem pela sua janela personalizada
#==============================================================================

class Lune_Custom_Scene < Scene_MenuBase
  #--------------------------------------------------------------------------
  # * Inicialização do processo
  #--------------------------------------------------------------------------
  def initialize
    create_windows
    @fadeout = false
    @speed = Lune_Custom_Config::Janela[$lune_custom_scene]['Fadein']
    super
  end
  #--------------------------------------------------------------------------
  # * Atualização do processo
  #--------------------------------------------------------------------------
  def update
    super
    @main_window.contents_opacity >= 255 ? continue_update : fadein    
  end
  #--------------------------------------------------------------------------
  # * Efeito de transição de tela
  #--------------------------------------------------------------------------
  def fadein
    @main_window.contents_opacity += @speed
    @pics.each {|pic| pic.opacity += @speed} if @pics
    @windows.each {|pic| pic.opacity += @speed} if @windows
  end
  #--------------------------------------------------------------------------
  # * Criação das Janelas
  #--------------------------------------------------------------------------
  def create_windows
    win = Lune_Custom_Config::Janela[$lune_custom_scene]['Windows']
    @main_window = Lune_Custom_Window.new
    @main_window.opacity = 0
    @main_window.contents_opacity = 0
    @main_window.z = 50
    return if win.empty?
    @windows = Array.new
    for n in 0...win.size
      @windows[n] = Window_Base.new(win[n][0], win[n][1], win[n][2], win[n][3])
      @windows[n].z = 30
      @windows[n].opacity = 0
    end
  end
  #--------------------------------------------------------------------------
  # * Atualização pós
  #--------------------------------------------------------------------------
  def continue_update
    if Input.trigger?(:B)
        RPG::SE.new(Lune_Custom_Config::Janela[$lune_custom_scene]['Sound']).play
        return_scene
    end
  end
  #--------------------------------------------------------------------------
  # * Finalização do processo
  #--------------------------------------------------------------------------
  def terminate
    @pics.each {|pic| pic.bitmap.dispose; pic.dispose} if @pics
    @windows.each {|pic| pic.dispose} if @windows
    super
  end
end

#==============================================================================
# ** Lune_Custom_Window
#------------------------------------------------------------------------------
#  Esta janela desenha de acordo com o que é configurado pelo usuário.
#==============================================================================

class Lune_Custom_Window < Window_Base
include Lune_Custom_Config
  #--------------------------------------------------------------------------
  # * Inicialização do processo
  #--------------------------------------------------------------------------
  def initialize
    super(0, 0, Graphics.width, Graphics.height)
    @var = $lune_custom_scene
    refresh
  end
  #--------------------------------------------------------------------------
  # * Atualização de imagens
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    create_variables
    create_texts
    create_pictures
    create_faces
    create_characters
  end
  #--------------------------------------------------------------------------
  # * Criação das variáveis
  #--------------------------------------------------------------------------
  def create_variables
  win = Janela[@var]['Variables']
    return if win.empty?
    for n in 0...win.size
      contents.font.size = win[n][3] unless win[n][3] == 0
      contents.font.color = text_color(win[n][4])
      contents.font.name = Janela[@var]['FontName'] unless Janela[@var]['FontName'].empty?
      draw_text_ex(win[n][1], win[n][2], $game_variables[win[n][0]].to_s)
      reset_font_settings
    end
  end
  #--------------------------------------------------------------------------
  # * Criação dos Textos
  #--------------------------------------------------------------------------
  def create_texts
  win = Janela[@var]['Texts']
    return if win.empty?
    for n in 0...win.size
      contents.font.size = win[n][3] unless win[n][3] == 0
      contents.font.color = text_color(win[n][4])
      contents.font.name = Janela[@var]['FontName'] unless Janela[@var]['FontName'].empty?
      draw_text_ex(win[n][1], win[n][2], win[n][0])
      reset_font_settings
    end
  end
  #--------------------------------------------------------------------------
  # * Renderização das Imagens
  #--------------------------------------------------------------------------
  def create_pictures
  win = Janela[@var]['Pictures']
    return if win.empty?
    @pics = Array.new
    for n in 0...win.size
      @pics[n] = Sprite.new
      @pics[n].bitmap = Cache.custom_win(win[n][0])
      win[n][3] == true ? @pics[n].z = 60 : @pics[n].z = 40
      @pics[n].x = win[n][1]
      @pics[n].y = win[n][2]
      @pics[n].opacity = 0
    end
  end
  #--------------------------------------------------------------------------
  # * Renderização das Faces
  #--------------------------------------------------------------------------
  def create_faces
  win = Janela[@var]['Faces']
    return if win.empty?
    for n in 0...win.size
      win[n][0] == 'actor' ? act = $game_actors[win[n][1]] : act = $game_party.members[win[n][1]]
      draw_actor_face(act, win[n][2], win[n][3])
    end
  end
  #--------------------------------------------------------------------------
  # * Renderização dos Personagens
  #--------------------------------------------------------------------------
  def create_characters
  win = Janela[@var]['Characters']
    return if win.empty?
    for n in 0...win.size
      win[n][0] == 'actor' ? act = $game_actors[win[n][1]] : act = $game_party.members[win[n][1]]
      draw_character(act.character_name, act.character_index, win[n][2], win[n][3])
    end
  end
  #--------------------------------------------------------------------------
  # * Desenho do texto com caracteres de controle
  #     x    : coordenada X
  #     y    : coordenada Y
  #     text : string de texto
  #--------------------------------------------------------------------------
  def draw_text_ex(x, y, text)
    text = convert_escape_characters(text)
    pos = {x: x, y: y, new_x: x, height: calc_line_height(text)}
    process_character(text.slice!(0, 1), text, pos) until text.empty?
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
  def self.custom_win(filename)
    load_bitmap("Graphics/Custom_Win/", filename)
  end
end

