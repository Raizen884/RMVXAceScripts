#=======================================================
#        Akea Animated Battle Hud
# Autor: Raizen
# Comunidade: http://www.centrorpg.com/
# Compatibilidade: RMVXAce
# Download da demo: http://www.mediafire.com/download/4dn4rvb83saddc9/Akea_ABW.exe
#=======================================================
# =========================Não modificar==============================
$imported ||= Hash.new
$imported[:akea_bw_animated] = true
module Akea_Battle_Window
Party_Pos = []
Party_Pos2 = []
Help_Pos = []
Help_Pos2 = []
# =========================Não modificar==============================
# Mostrar icone dos itens/skills?
Show_Icon = true

# Mostrar nome dos itens/skills?
Show_Name = true

# Mostrar custo/quantidade dos skills/itens?
Show_Cost = true

# Posição da janela de Lutar/Fugir
Fight_Pos = [200, 150]

# Distancia entre as 2 janelas
Fight_Pos_Dist = [0, 50]

# Posição das imagens de comando da party Party_Pos[id] = [x, y]
Party_Pos[0] = [250, 110]
Party_Pos[1] = [310, 145]
Party_Pos[2] = [250, 180]
Party_Pos[3] = [310, 215]

# Posição das imagens de skills da party Party_Pos[id] = [x, y]
Party_Pos2[0] = [100, 110]
Party_Pos2[1] = [160, 145]
Party_Pos2[2] = [100, 180]
Party_Pos2[3] = [160, 215]

# Velocidade do movimento das janelas = [x, y]
Move_Speed = [3, 4]

# Imagem de fundo(Lutar)
Fight_Pic = "Fight_Back"
# Imagem de fundo(Fugir)
Run_Pic = "Run_Back"
# Imagem de fundo dos comandos
Back_Base_Command_Pic = "Skill_Back"
# Imagem de fundo dos skills
Back_Base_Skills_Pic = "Skill_Back"


# Tamanho da janela de skills(para efeitos de correção)
Skill_Window_Size = [160, 50]

# Tamanho da janela de comandos(para efeitos de correção)
Command_Window_Size = [150, 50]
# Alinhamento do texto (0 = esquerda, 1 = centro, 2 = direita)
Text_Align = 0

# Para efeitos de correção da posição do custo/quantidade do item
Cost_Align = 70
# Posição da janela de help de acordo com a party
Help_Pos[0] = [0, 220]
Help_Pos[1] = [0, 220]
Help_Pos[2] = [0, 50]
Help_Pos[3] = [0, 50]
# Posição da imagem de help de acordo com a party
Help_Pos2[0] = [0, 170]
Help_Pos2[1] = [0, 170]
Help_Pos2[2] = [0, 0]
Help_Pos2[3] = [0, 0]

# Imagem de fundo da janela de Help
Help_Image = "Help_Back"
# Opacidade da janela de Help
Help_Opacity = 0

#  Imagens da janela de status, qualquer parte que não queira que seja
# por imagens, basta colocar como '' o nome da imagem

# Imagem de fundo dos status (1 para cada personagem)
Status_Window_Base = 'Fundo'

# Imagem de frente dos status (1 para cada personagem)
Status_Window_Over = 'Borda'

# Barras de status
Status_HP = 'HP_BAR'
Status_MP = 'MP_BAR'
Status_TP = 'TP_BAR'

# Num = Valor atual(HP, MP ou TP)
# Max = Valor máximo(HP, MP ou TP)
# Hash = a imagem da barra que separa o máximo do atual
HP_Num = 'Numbers_Hud'
HP_Max = ''
HP_Hash = ''
MP_Num = 'Numbers_Hud'
MP_Max = ''
MP_Hash = ''
TP_Num = 'Numbers_Hud'
TP_Max = ''
TP_Hash = ''

# Espaço entre os números do status
Number_Spacing = 8


# Recorte da face, caso não use uma face desse modo basta
# Face_Rect = false
# Face_Rect pode ser configurado por
# [x, y, largura, altura]
Face_Rect = [0, 27, 96, 27]

# Taxa de atualização do Estado do Personagem
State_Update = 60

# Aqui é configurado todas as posições de imagens da Hud por
# Personagem da party!
Status_Actor_Pos = []


# Posição de todas as imagens sempre seguindo o padrão
# [posição em X, posição em Y]
Status_Actor_Pos[0] = {
:Windows_Back => [26, 296],
:State_Pos => [142, 297],
:Hp_Bar => [180, 308],
:Mp_Bar => [256, 308],
:Tp_Bar => [332, 308],
:Hp_Num => [237, 299],
:Hp_Hash => [80, 296],
:Hp_Max => [70, 310],
:Mp_Num => [314, 299],
:Mp_Hash => [160, 296],
:Mp_Max => [150, 310],
:Tp_Num => [386, 299],
:Tp_Hash => [240, 296],
:Tp_Max => [230, 310],
:Face => [26, 296],
}
Status_Actor_Pos[1] = {
:Windows_Back => [26, 326],
:State_Pos => [142, 327],
:Hp_Bar => [180, 338],
:Mp_Bar => [256, 338],
:Tp_Bar => [332, 338],
:Hp_Num => [237, 326],
:Hp_Hash => [80, 326],
:Hp_Max => [70, 340],
:Mp_Num => [314, 326],
:Mp_Hash => [160, 326],
:Mp_Max => [150, 340],
:Tp_Num => [386, 326],
:Tp_Hash => [240, 326],
:Tp_Max => [230, 340],
:Face => [26, 326],
}
Status_Actor_Pos[2] = {
:Windows_Back => [26, 356],
:State_Pos => [142, 357],
:Hp_Bar => [180, 368],
:Mp_Bar => [256, 368],
:Tp_Bar => [332, 368],
:Hp_Num => [237, 356],
:Hp_Hash => [80, 356],
:Hp_Max => [70, 370],
:Mp_Num => [314, 356],
:Mp_Hash => [160, 356],
:Mp_Max => [314, 370],
:Tp_Num => [386, 356],
:Tp_Hash => [240, 356],
:Tp_Max => [230, 370],
:Face => [26, 356],
}
Status_Actor_Pos[3] = {
:Windows_Back => [26, 386],
:State_Pos => [142, 387],
:Hp_Bar => [180, 398],
:Mp_Bar => [256, 398],
:Tp_Bar => [332, 398],
:Hp_Num => [237, 386],
:Hp_Hash => [80, 386],
:Hp_Max => [70, 400],
:Mp_Num => [314, 386],
:Mp_Hash => [160, 386],
:Mp_Max => [150, 400],
:Tp_Num => [386, 386],
:Tp_Hash => [240, 386],
:Tp_Max => [230, 400],
:Face => [26, 386],
}

# Imagens especificas para os comandos do personagem,
# Apenas para demonstrar que o script permite essa configuração,
# Coloque 'Nome' => 'Nome_da_Imagem'
Back_Base_Pic = {
'Atacar' => 'Skill_Back',

}
end

#==============================================================================
# ** Scene_Battle
#------------------------------------------------------------------------------
#  Esta classe executa o processamento da tela de batalha.
#==============================================================================

class Scene_Battle < Scene_Base
alias :akea_bw_create_all_windows :create_all_windows
alias :akea_bw_update :update
alias :akea_bw_command_item :command_item
alias :akea_bw_turn_start :turn_start
alias :akea_bw_start_party_command_selection :start_party_command_selection
alias :akea_bw_dispose_all_windows :dispose_all_windows
alias :akea_bw_command_skill :command_skill
alias :akea_bw_command_item :command_item
  #--------------------------------------------------------------------------
  # * Criação da janela de atributos
  #--------------------------------------------------------------------------
  def create_status_window
    @status_window = Window_Akea_BattleStatus.new
    @status_window.x = 128
  end
  #--------------------------------------------------------------------------
  # * Criação de todas as janelas
  #--------------------------------------------------------------------------
  def create_all_windows(*args, &block)
    @akea_bw_icon = Array.new
    @akea_bw_old_icons = Array.new($game_party.battle_members.size, -1)
    for n in 0...$game_party.battle_members.size
      @akea_bw_icon[n] = Sprite.new
      @akea_bw_icon[n].bitmap = Cache.system("Iconset")
      @akea_bw_icon[n].opacity = 0
      @akea_bw_icon[n].x = Akea_Battle_Window::Status_Actor_Pos[n][:State_Pos][0] 
      @akea_bw_icon[n].y = Akea_Battle_Window::Status_Actor_Pos[n][:State_Pos][1] 
      @akea_bw_icon[n].z = 1
    end
    akea_bw_create_all_windows(*args, &block)
  end
  #--------------------------------------------------------------------------
  # * Comando [Skill]
  #--------------------------------------------------------------------------
  def command_skill
    akea_bw_command_skill
    @skill_window.refresh_aux_windows
  end
  #--------------------------------------------------------------------------
  # * Comando [Item]
  #--------------------------------------------------------------------------
  def command_item
    akea_bw_command_item
    @item_window.refresh_aux_windows
  end
  #--------------------------------------------------------------------------
  # * Disposição de todas as janelas
  #--------------------------------------------------------------------------
  def dispose_all_windows
    @akea_bw_icon.each{|icon| icon.bitmap.dispose; icon.dispose}
    akea_bw_dispose_all_windows
  end
  #--------------------------------------------------------------------------
  # * Iniciar seleção de grupo
  #--------------------------------------------------------------------------
  def start_party_command_selection
    akea_bw_start_party_command_selection
    @item_window.refresh_aux_windows
  end
  #--------------------------------------------------------------------------
  # * Início do turno
  #--------------------------------------------------------------------------
  def turn_start
    18.times{update}
    akea_bw_turn_start
  end
  #--------------------------------------------------------------------------
  # * Comando [Item]
  #--------------------------------------------------------------------------
  def command_item
    @item_window.actor = BattleManager.actor
    akea_bw_command_item
  end
  #--------------------------------------------------------------------------
  # * Atualização da tela
  #--------------------------------------------------------------------------
  def update
    update_state_icon if Graphics.frame_count % Akea_Battle_Window::State_Update == 0
    update_akea_windows unless BattleManager.in_turn?
    akea_bw_update
  end
  #--------------------------------------------------------------------------
  # * Atualização dos estados dos personagens
  #--------------------------------------------------------------------------
  def update_state_icon
    for n in 0...$game_party.battle_members.size
      update_state_icon_actor(n, $game_party.battle_members[n])
    end    
  end
  #--------------------------------------------------------------------------
  # * Desenho dos ícones de estado, foralecimento e enfraquecimento
  #     actor  : herói
  #     x      : coordenada X
  #     y      : coordenada Y
  #     width  : largura
  #--------------------------------------------------------------------------
  def update_state_icon_actor(n, actor)
    if actor.state_icons.empty? && actor.buff_icons.empty?
      @akea_bw_icon[n].opacity = 0
    else
      icons = (actor.state_icons + actor.buff_icons)
      y = icons.index(@akea_bw_old_icons[n])
      if y
        icons[y + 1] ?  y += 1 : y = 0 
      else
        y = 0
      end
      set_icon = icons[y]
      @akea_bw_icon[n].opacity = 255
      @akea_bw_icon[n].src_rect.set(set_icon % 16 * 24, set_icon / 16 * 24, 24, 24)
      @akea_bw_old_icons[n] = set_icon
    end
  end
  #--------------------------------------------------------------------------
  # * Atualização das janelas
  #--------------------------------------------------------------------------
  def update_akea_windows
    if @party_command_window.active
      @party_command_window.move_aux_windows
    else
      @party_command_window.return_aux_windows
    end
    if @actor_command_window.active
      @actor_command_window.move_aux_windows(true)
    elsif @skill_window.active || @item_window.active
      @actor_command_window.move_aux_windows(false)
    else
      @actor_command_window.return_aux_windows
    end
    if @skill_window.active
      @skill_window.update_contents
    else
      @skill_window.return_aux_windows
    end
    if @item_window.active
      @item_window.update_contents
    else
      @item_window.return_aux_windows
    end
  end
  #--------------------------------------------------------------------------
  # * Criação do viewport de informações
  #--------------------------------------------------------------------------
  def create_info_viewport
    @info_viewport = Viewport.new
    @info_viewport.rect.y = 0
    @info_viewport.rect.height = @status_window.height
    @info_viewport.z = 100
    @info_viewport.ox = 128
    @status_window.viewport = @info_viewport
  end
  #--------------------------------------------------------------------------
  # * Movimento da exibição do viewport de informações
  #     ox : nova coordenada x
  #--------------------------------------------------------------------------
  def move_info_viewport(ox)
  end
end

#==============================================================================
# ** Window_ActorCommand
#------------------------------------------------------------------------------
#  Esta janela é usada para selecionar os comandos do herói na tela de batalha.
#==============================================================================

class Window_ActorCommand < Window_Command
alias :akea_bw_animated_initialize :initialize
alias :akea_bw_setup :setup
alias :akea_bw_dispose :dispose
  #--------------------------------------------------------------------------
  # * Inicialização do objeto
  #--------------------------------------------------------------------------
  def initialize
    akea_bw_animated_initialize
    self.opacity = 0
    self.contents_opacity = 0
    self.y -= Graphics.height
    create_aux_windows
  end
  #--------------------------------------------------------------------------
  # * Atualização do cursor
  #--------------------------------------------------------------------------
  def update_cursor
    cursor_rect.empty
  end
  #--------------------------------------------------------------------------
  # * Atualização do cursor
  #--------------------------------------------------------------------------
  def update_cursor
    cursor_rect.empty
  end
  #--------------------------------------------------------------------------
  # * Criação das janelas auxiliares
  #--------------------------------------------------------------------------
  def create_aux_windows
    @actor_command_windows = Array.new($data_system.skill_types.size)
    for n in 0...($data_system.skill_types.size + 3)
      @actor_command_windows[n] = Window_Command_Akea.new(0, 0, Akea_Battle_Window::Command_Window_Size[0], Akea_Battle_Window::Command_Window_Size[1])
      @actor_command_windows[n].opacity = 0
      @actor_command_windows[n].contents_opacity = 0
      @actor_command_windows[n].y = n*40
      case n
      when 0
        @actor_command_windows[n].show_contents(Vocab::attack, Akea_Battle_Window::Back_Base_Pic[Vocab::attack] ? Akea_Battle_Window::Back_Base_Pic[Vocab::attack] : Akea_Battle_Window::Back_Base_Command_Pic)
      when 1...$data_system.skill_types.size
        @actor_command_windows[n].show_contents($data_system.skill_types[n], Akea_Battle_Window::Back_Base_Pic[$data_system.skill_types[n]] ? Akea_Battle_Window::Back_Base_Pic[$data_system.skill_types[n]] : Akea_Battle_Window::Back_Base_Command_Pic)
      when $data_system.skill_types.size
        @actor_command_windows[n].show_contents(Vocab::guard, Akea_Battle_Window::Back_Base_Pic[Vocab::guard] ? Akea_Battle_Window::Back_Base_Pic[Vocab::guard] : Akea_Battle_Window::Back_Base_Command_Pic)
      when $data_system.skill_types.size + 1
        @actor_command_windows[n].show_contents(Vocab::item, Akea_Battle_Window::Back_Base_Pic[Vocab::item] ? Akea_Battle_Window::Back_Base_Pic[Vocab::item] : Akea_Battle_Window::Back_Base_Command_Pic)
      end
    end
  end
  def dispose
    @actor_command_windows.each{|obj| obj.dispose}
    akea_bw_dispose
  end
  #--------------------------------------------------------------------------
  # * Criação da lista de comandos
  #--------------------------------------------------------------------------
  def make_command_list
    return unless @actor
    add_attack_command
    add_skill_commands
    add_guard_command
    add_item_command
  end
  #--------------------------------------------------------------------------
  # * Adicionar comados aos personagens
  #--------------------------------------------------------------------------
  def make_actor_commands
    @actor_has_command << 0 if @actor.attack_usable?
    @actor.added_skill_types.sort.each{|stype_id| @actor_has_command << stype_id}
    @actor_has_command << $data_system.skill_types.size if @actor.guard_usable?
    @actor_has_command << $data_system.skill_types.size + 1
  end
  #--------------------------------------------------------------------------
  # * Animação de retorno das janelas
  #--------------------------------------------------------------------------
  def return_aux_windows
    @actor_command_windows.each{|pic| pic.contents_opacity -= 20}
  end
  #--------------------------------------------------------------------------
  # * Movimentação das janelas
  #--------------------------------------------------------------------------
  def move_aux_windows(opac)
    for n in 1...(self.index)
      take_opacity(@actor_has_command[self.index - 1 - n])
      move_aux(@actor_has_command[self.index - 1 - n], (n + 1)*(Akea_Battle_Window::Move_Speed[0] * -10) + @actor_pos_x,  (n + 1)*Akea_Battle_Window::Move_Speed[1] * 10 + @actor_pos_y)
    end
    for n in (self.index + 2)...item_max
      take_opacity(@actor_has_command[n])
      move_aux(@actor_has_command[n], (n - self.index)*(Akea_Battle_Window::Move_Speed[0] * -10) + @actor_pos_x,  (n - self.index)*Akea_Battle_Window::Move_Speed[1] * -10 + @actor_pos_y)
    end 
    if self.index > 0
      if opac
        side_opacity(@actor_has_command[self.index - 1])
        move_aux(@actor_has_command[self.index - 1],  Akea_Battle_Window::Move_Speed[0] * -10 + @actor_pos_x,  Akea_Battle_Window::Move_Speed[1] * 10 + @actor_pos_y)
      else
        take_opacity(@actor_has_command[self.index - 1]) 
        move_aux(@actor_has_command[self.index - 1],  @actor_pos_x, @actor_pos_y)
      end
    end
    if self.index + 1 < item_max
      if opac
        side_opacity(@actor_has_command[self.index + 1])
        move_aux(@actor_has_command[self.index + 1],  Akea_Battle_Window::Move_Speed[0] * -10 + @actor_pos_x,  Akea_Battle_Window::Move_Speed[1] * -10 + @actor_pos_y)
      else
        take_opacity(@actor_has_command[self.index + 1]) 
        move_aux(@actor_has_command[self.index + 1], @actor_pos_x, @actor_pos_y)
      end
    end
    move_aux(@actor_has_command[self.index], @actor_pos_x, @actor_pos_y)
    center_opacity(@actor_has_command[self.index])
  end
  #--------------------------------------------------------------------------
  # * Comando de opacidade lateral
  #--------------------------------------------------------------------------
  def side_opacity(i)
    if @actor_command_windows[i].contents_opacity < 140
      @actor_command_windows[i].contents_opacity += 15
    elsif @actor_command_windows[i].contents_opacity  > 160
      @actor_command_windows[i].contents_opacity -= 15
    end
  end
  #--------------------------------------------------------------------------
  # * Comando de opacidade central
  #--------------------------------------------------------------------------
  def center_opacity(i)
    @actor_command_windows[i].contents_opacity += 15
  end
  #--------------------------------------------------------------------------
  # * Comando de tirar opacidade(com fade)
  #--------------------------------------------------------------------------
  def take_opacity(i)
    @actor_command_windows[i].contents_opacity -= 15
  end
  #--------------------------------------------------------------------------
  # * Comando de tirar opacidade(sem fade)
  #--------------------------------------------------------------------------
  def take_all_opacity
    @actor_command_windows.each{|com| com.contents_opacity = 0}
  end
  #--------------------------------------------------------------------------
  # * Método de movimentação das janelas
  #--------------------------------------------------------------------------
  def move_aux(n, pos_x, pos_y)
     @actor_command_windows[n].x += Akea_Battle_Window::Move_Speed[0] if @actor_command_windows[n].x < pos_x
     @actor_command_windows[n].x -= Akea_Battle_Window::Move_Speed[0] if @actor_command_windows[n].x > pos_x
     @actor_command_windows[n].y += Akea_Battle_Window::Move_Speed[1] if @actor_command_windows[n].y < pos_y
     @actor_command_windows[n].y -= Akea_Battle_Window::Move_Speed[1] if @actor_command_windows[n].y > pos_y
   end
  #--------------------------------------------------------------------------
  # * Movimento do cursor para cima
  #--------------------------------------------------------------------------
  def cursor_up(wrap = false)
    super(false)
  end
  #--------------------------------------------------------------------------
  # * Movimento do cursor para baixo
  #--------------------------------------------------------------------------
   def cursor_down(wrap = false)
    super(false)
  end 
  #--------------------------------------------------------------------------
  # * Configuração inicial
  #     actor : herói
  #--------------------------------------------------------------------------
  def setup(actor)
    p_index = $game_party.members.index(actor)
    @actor_has_command = []
    @actor_pos_x = Akea_Battle_Window::Party_Pos[p_index][0]
    @actor_pos_y = Akea_Battle_Window::Party_Pos[p_index][1]
    @actor_command_windows.each{|pic| pic.x = @actor_pos_x; pic.y = @actor_pos_y}
    akea_bw_setup(actor)
    select(1)
    make_actor_commands
    @actor_command_windows.each{|item| item.opacity = 0 ; item.contents_opacity = 0}
  end
end
#==============================================================================
# ** Window_Command_Akea
#------------------------------------------------------------------------------
#  Esta janela é a janela que exibe os comandos do personagem
#==============================================================================
class Window_Command_Akea < Window_Base
  #--------------------------------------------------------------------------
  # * Inicialização
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height)
    @self_width = width
    @self_height = height
    super(x, y, width, height)
  end
  #--------------------------------------------------------------------------
  # * Mostrar o conteúdo da janela
  #--------------------------------------------------------------------------
  def show_contents(item, back_pic, skill = false)
    contents.clear
    bitmap = Cache.akea(back_pic)
    rect = Rect.new(0, 0, bitmap.width, bitmap.height)
    contents.blt(0, 0, bitmap, rect, 255)
    if item.is_a?(String)
      draw_text(0, 0, @self_width, line_height, item , Akea_Battle_Window::Text_Align)
      return
    end
    x = 30
    x = 80 if Akea_Battle_Window::Show_Cost
    if Akea_Battle_Window::Show_Icon
      draw_icon(item.icon_index, 0, 0, true)
      draw_text(30, 0, @self_width - x, line_height, item.name , Akea_Battle_Window::Text_Align) if Akea_Battle_Window::Show_Name
    else
      draw_text(0, 0, @self_width, line_height, item.name , Akea_Battle_Window::Text_Align) if Akea_Battle_Window::Show_Name
    end
    rect = Rect.new(@self_width - Akea_Battle_Window::Cost_Align, 0, 30, line_height)
    if skill
      draw_skill_cost(rect, item)
    else
      draw_item_number(rect, item)
    end
  end
  #--------------------------------------------------------------------------
  # * Desenho do custo das habilidades
  #     rect  : retângulo
  #     skill : habilidade
  #--------------------------------------------------------------------------
  def draw_skill_cost(rect, skill)
    if skill.tp_cost > 0
      change_color(tp_cost_color)
      draw_text(rect, skill.tp_cost, 2)
    elsif skill.mp_cost > 0
      change_color(mp_cost_color)
      draw_text(rect, skill.mp_cost, 2)
    end
    change_color(normal_color)
  end
  #--------------------------------------------------------------------------
  # * Desenho do número de itens possuido
  #     rect : retângulo
  #     item : item
  #--------------------------------------------------------------------------
  def draw_item_number(rect, item)
    draw_text(rect, sprintf(":%2d", $game_party.item_number(item)), 2)
  end
end


#==============================================================================
# ** Window_BattleStatus
#------------------------------------------------------------------------------
#  Esta janela exibe as condições de todos membros do grupo na tela de batalha.
#==============================================================================

class Window_Akea_BattleStatus < Window_BattleStatus
alias :akea_bw_initialize :initialize
alias :akea_bw_open :open
alias :akea_bw_close :close
alias :akea_bw_dispose :dispose
  #--------------------------------------------------------------------------
  # * Inicialização do objeto
  #--------------------------------------------------------------------------
  def initialize
    akea_bw_initialize
    self.opacity = 0
    draw_static_windows
  end
  #--------------------------------------------------------------------------
  # * Método de abertura da janela
  #--------------------------------------------------------------------------
  def open
    akea_bw_open
    @back_actor_status.each{|window| window.opacity = 255}
    @front_actor_status.each{|window| window.opacity = 255}
  end
  #--------------------------------------------------------------------------
  # * Método de fechamento da janela
  #--------------------------------------------------------------------------
  def close
    akea_bw_close
    @back_actor_status.each{|window| window.opacity = 0}
    @front_actor_status.each{|window| window.opacity = 0}
  end
  #--------------------------------------------------------------------------
  # * Desenho das imagens auxiliares
  #--------------------------------------------------------------------------
  def draw_static_windows
    @back_actor_status = Array.new
    @front_actor_status = Array.new
    for n in 0...$game_party.battle_members.size
      param = Akea_Battle_Window::Status_Actor_Pos[n]
      draw_actor_back($game_party.battle_members[n], param, n)
      draw_actor_front($game_party.battle_members[n], param, n)
    end
  end
  #--------------------------------------------------------------------------
  # * Desenho das imagens de fundo
  #--------------------------------------------------------------------------
  def draw_actor_back(actor, param, n)
    @back_actor_status[n] = Sprite.new
    @back_actor_status[n].bitmap = Cache.akea(Akea_Battle_Window::Status_Window_Base)
    @back_actor_status[n].x = param[:Windows_Back][0] 
    @back_actor_status[n].y = param[:Windows_Back][1] 
    @back_actor_status[n].opacity = 0
  end
  #--------------------------------------------------------------------------
  # * Desenho das imagens de frente
  #--------------------------------------------------------------------------
  def draw_actor_front(actor, param, n)
    @front_actor_status[n] = Sprite.new
    @front_actor_status[n].bitmap = Cache.akea(Akea_Battle_Window::Status_Window_Over)
    @front_actor_status[n].x = param[:Windows_Back][0] 
    @front_actor_status[n].y = param[:Windows_Back][1] 
    @front_actor_status[n].opacity = 0
    @front_actor_status[n].z = 200
  end
  #--------------------------------------------------------------------------
  # * Atualização do cursor
  #--------------------------------------------------------------------------
  def update_cursor
    cursor_rect.empty
  end
  #--------------------------------------------------------------------------
  # * Atualização do espaçamento abaixo
  #--------------------------------------------------------------------------
  def update_padding_bottom
    #surplus = (height - standard_padding * 2) % item_height
    self.padding_bottom = 0
  end
  #--------------------------------------------------------------------------
  # * Aquisição do espaçamento entre os itens
  #--------------------------------------------------------------------------
  def spacing
    return 0
  end
  #--------------------------------------------------------------------------
  # * Espaçamento lateral padrão
  #--------------------------------------------------------------------------
  def standard_padding
    return 0
  end
  #--------------------------------------------------------------------------
  # * Aquisição da largura da janela
  #--------------------------------------------------------------------------
  def window_width
    Graphics.width
  end
  #--------------------------------------------------------------------------
  # * Aquisição da altura da janela
  #--------------------------------------------------------------------------
  def window_height
    Graphics.height + 20
  end
  #--------------------------------------------------------------------------
  # * Aquisição do número máximo de itens
  #--------------------------------------------------------------------------
  def item_max
    $game_party.battle_members.size
  end
  #--------------------------------------------------------------------------
  # * Renovação
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    draw_all_items
  end
  #--------------------------------------------------------------------------
  # * Desenho do item
  #     index : índice do item
  #--------------------------------------------------------------------------
  def draw_item(index)
    actor = $game_party.battle_members[index]
    draw_basic_area(actor, index)
  end
  #--------------------------------------------------------------------------
  # * Aquisição da largura da área do medidor
  #--------------------------------------------------------------------------
  def gauge_area_width
    return 220
  end
  #--------------------------------------------------------------------------
  # * Desenho da área básica
  #     rect  : retângulo
  #     actor : herói
  #--------------------------------------------------------------------------
  def draw_basic_area(actor, index)
    param = Akea_Battle_Window::Status_Actor_Pos[index]
    draw_actor_akea_hp(actor, param)
    draw_actor_akea_mp(actor, param)
    draw_actor_akea_tp(actor, param)
    draw_actor_akea_hp_num(actor, param)
    draw_actor_akea_mp_num(actor, param)
    draw_actor_akea_tp_num(actor, param)
    draw_akea_face(actor.face_name, actor.face_index, param) if Akea_Battle_Window::Face_Rect
  end
  #--------------------------------------------------------------------------
  # * Método de desenho : HP
  #--------------------------------------------------------------------------
  def draw_actor_akea_hp(actor, param)
    bitmap = Cache.akea(Akea_Battle_Window::Status_HP)
    rect = Rect.new(0, 0, bitmap.width * actor.hp_rate, bitmap.height)
    contents.blt(param[:Hp_Bar][0], param[:Hp_Bar][1], bitmap, rect, 255)
  end
  #--------------------------------------------------------------------------
  # * Método de desenho : MP
  #--------------------------------------------------------------------------
  def draw_actor_akea_mp(actor, param)
    bitmap = Cache.akea(Akea_Battle_Window::Status_MP)
    rect = Rect.new(0, 0, bitmap.width * actor.mp_rate, bitmap.height)
    contents.blt(param[:Mp_Bar][0], param[:Mp_Bar][1], bitmap, rect, 255)
  end
  #--------------------------------------------------------------------------
  # * Método de desenho : TP
  #--------------------------------------------------------------------------
  def draw_actor_akea_tp(actor, param)
    bitmap = Cache.akea(Akea_Battle_Window::Status_TP)
    rect = Rect.new(0, 0, bitmap.width * actor.tp_rate, bitmap.height)
    contents.blt(param[:Tp_Bar][0], param[:Tp_Bar][1], bitmap, rect, 255)
  end
  #--------------------------------------------------------------------------
  # * Método de desenho : HP - Valor
  #--------------------------------------------------------------------------
  def draw_actor_akea_hp_num(actor, param)
    bitmap = Cache.akea(Akea_Battle_Window::HP_Num)
    spacing_num = 0
    hp = actor.hp
    if hp == 0
      rect = Rect.new(0, 0, bitmap.width/10, bitmap.height)
      contents.blt(param[:Hp_Num][0], param[:Hp_Num][1], bitmap, rect, 255)
    end
    until hp == 0
      rest = hp % 10
      hp = hp/10
      rect = Rect.new((bitmap.width*rest)/10, 0, bitmap.width/10, bitmap.height)
      contents.blt(param[:Hp_Num][0] - spacing_num, param[:Hp_Num][1], bitmap, rect, 255)
      spacing_num += Akea_Battle_Window::Number_Spacing
    end
    bitmap = Cache.akea(Akea_Battle_Window::HP_Hash)
    rect = Rect.new(0, 0, bitmap.width, bitmap.height)
    contents.blt(param[:Hp_Hash][0], param[:Hp_Hash][1], bitmap, rect, 255)
    return if Akea_Battle_Window::HP_Max == ''
    bitmap = Cache.akea(Akea_Battle_Window::HP_Max)
    hp = actor.mhp
    spacing_num = 0
    until hp == 0
      rest = hp % 10
      hp = hp/10
      rect = Rect.new((bitmap.width*rest)/10, 0, bitmap.width/10, bitmap.height)
      contents.blt(param[:Hp_Max][0] - spacing_num, param[:Hp_Max][1], bitmap, rect, 255)
      spacing_num += Akea_Battle_Window::Number_Spacing
    end
  end
  #--------------------------------------------------------------------------
  # * Método de desenho : MP - Valor
  #--------------------------------------------------------------------------
  def draw_actor_akea_mp_num(actor, param)
    bitmap = Cache.akea(Akea_Battle_Window::MP_Num)
    spacing_num = 0
    mp = actor.mp
    if mp == 0
      rect = Rect.new(0, 0, bitmap.width/10, bitmap.height)
      contents.blt(param[:Mp_Num][0], param[:Mp_Num][1], bitmap, rect, 255)
    end
    until mp == 0
      rest = mp % 10
      mp = mp/10
      rect = Rect.new((bitmap.width*rest)/10, 0, bitmap.width/10, bitmap.height)
      contents.blt(param[:Mp_Num][0] - spacing_num, param[:Mp_Num][1], bitmap, rect, 255)
      spacing_num += Akea_Battle_Window::Number_Spacing
    end
    bitmap = Cache.akea(Akea_Battle_Window::MP_Hash)
    rect = Rect.new(0, 0, bitmap.width, bitmap.height)
    contents.blt(param[:Mp_Hash][0], param[:Mp_Hash][1], bitmap, rect, 255)
    return if Akea_Battle_Window::MP_Max == ''
    bitmap = Cache.akea(Akea_Battle_Window::MP_Max)
    mp = actor.mmp
    spacing_num = 0
    until mp == 0
      rest = mp % 10
      mp = mp/10
      rect = Rect.new((bitmap.width*rest)/10, 0, bitmap.width/10, bitmap.height)
      contents.blt(param[:Mp_Max][0] - spacing_num, param[:Mp_Max][1], bitmap, rect, 255)
      spacing_num += Akea_Battle_Window::Number_Spacing
    end
  end
  #--------------------------------------------------------------------------
  # * Método de desenho : TP - Valor
  #--------------------------------------------------------------------------
  def draw_actor_akea_tp_num(actor, param)
    bitmap = Cache.akea(Akea_Battle_Window::TP_Num)
    spacing_num = 0
    tp = actor.tp.to_i
    if tp == 0
      rect = Rect.new(0, 0, bitmap.width/10, bitmap.height)
      contents.blt(param[:Tp_Num][0], param[:Tp_Num][1], bitmap, rect, 255)
    end
    until tp == 0
      rest = tp % 10
      tp = tp/10
      rect = Rect.new((bitmap.width*rest)/10, 0, bitmap.width/10, bitmap.height)
      contents.blt(param[:Tp_Num][0] - spacing_num, param[:Tp_Num][1], bitmap, rect, 255)
      spacing_num += Akea_Battle_Window::Number_Spacing
    end
    bitmap = Cache.akea(Akea_Battle_Window::TP_Hash)
    rect = Rect.new(0, 0, bitmap.width, bitmap.height)
    contents.blt(param[:Tp_Hash][0], param[:Tp_Hash][1], bitmap, rect, 255)
    return if Akea_Battle_Window::TP_Max == ''
    bitmap = Cache.akea(Akea_Battle_Window::TP_Max)
    tp = 100
    spacing_num = 0
    until tp == 0
      rest = tp % 10
      tp = tp/10
      rect = Rect.new((bitmap.width*rest)/10, 0, bitmap.width/10, bitmap.height)
      contents.blt(param[:Tp_Max][0] - spacing_num, param[:Tp_Max][1], bitmap, rect, 255)
      spacing_num += Akea_Battle_Window::Number_Spacing
    end
  end
  #--------------------------------------------------------------------------
  # * Desenho do gráfico de rosto
  #     face_name  : nome do gráfico de face
  #     face_index : índice do gráfico de face
  #     x          : coordenada X
  #     y          : coordenada Y
  #     enabled    : habilitar flag, translucido quando false
  #--------------------------------------------------------------------------
  def draw_akea_face(face_name, face_index, param)
    bitmap = Cache.face(face_name)
    rect = Rect.new(face_index % 4 * 96 + Akea_Battle_Window::Face_Rect[0], face_index / 4 * 96 + Akea_Battle_Window::Face_Rect[1], Akea_Battle_Window::Face_Rect[2], Akea_Battle_Window::Face_Rect[3])
    contents.blt(param[:Face][0], param[:Face][1], bitmap, rect, 255)
    bitmap.dispose
  end
  #--------------------------------------------------------------------------
  # * Desenho da área do medidor (com TP)
  #     rect  : retângulo
  #     actor : herói
  #--------------------------------------------------------------------------
  def draw_gauge_area_with_tp(rect, actor)
    draw_actor_hp(actor, rect.x + 0, rect.y, 72)
    draw_actor_mp(actor, rect.x + 82, rect.y, 64)
    draw_actor_tp(actor, rect.x + 156, rect.y, 64)
  end
  #--------------------------------------------------------------------------
  # * Desenho da área do medidor (sem TP)
  #     rect  : retângulo
  #     actor : herói
  #--------------------------------------------------------------------------
  def draw_gauge_area_without_tp(rect, actor)
    draw_actor_hp(actor, rect.x + 0, rect.y, 134)
    draw_actor_mp(actor, rect.x + 144,  rect.y, 76)
  end
  def dispose
    @front_actor_status.each{|obj| obj.bitmap.dispose; obj.dispose}
    @back_actor_status.each{|obj| obj.bitmap.dispose; obj.dispose}
    akea_bw_dispose
  end
end
#==============================================================================
# ** Window_BattleSkill
#------------------------------------------------------------------------------
#  Esta janela para seleção de habilidades na tela de batalha.
#==============================================================================

class Window_BattleSkill < Window_SkillList
alias :akea_bw_initialize :initialize
alias :akea_bw_dispose :dispose
  #--------------------------------------------------------------------------
  # * Inicialização do objeto
  #     info_viewport : viewport para exibir informações
  #--------------------------------------------------------------------------
  def initialize(help_window, info_viewport)
    akea_bw_initialize(help_window, info_viewport)
    @index_window = 0
    @help_Sprite = Sprite.new
    @help_Sprite.opacity = 0
    @help_Sprite.bitmap = Cache.akea(Akea_Battle_Window::Help_Image)
    create_aux_windows
  end
  def dispose
    @actor_command_windows.each{|obj| obj.dispose}
    @help_Sprite.bitmap.dispose
    @help_Sprite.dispose
    akea_bw_dispose
  end
  def col_max
    return 1
  end
  #--------------------------------------------------------------------------
  # * Definição de herói
  #     actor : herói
  #--------------------------------------------------------------------------
  def actor=(actor)
    @p_index = $game_party.members.index(actor)
    @actor_pos_x = Akea_Battle_Window::Party_Pos2[@p_index][0]
    @actor_pos_y = Akea_Battle_Window::Party_Pos2[@p_index][1]
    @actor_command_windows.each{|pic| pic.x = @actor_pos_x; pic.y = @actor_pos_y}
    return if @actor == actor
    @actor = actor
    refresh
    self.oy = 0
    initialize_aux_windows
  end
  #--------------------------------------------------------------------------
  # * Criação de janelas auxiliares
  #--------------------------------------------------------------------------
  def create_aux_windows
    @actor_command_windows = Array.new(7)
    for n in 0...7
      @actor_command_windows[n] = Window_Command_Akea.new(0, 0, Akea_Battle_Window::Skill_Window_Size[0], Akea_Battle_Window::Skill_Window_Size[1])
      @actor_command_windows[n].opacity = 0
      @actor_command_windows[n].contents_opacity = 250
      @actor_command_windows[n].show_contents(@data[n], Akea_Battle_Window::Back_Base_Skills_Pic, true) if @data[n]
    end
  end
  #--------------------------------------------------------------------------
  # * Inicialização da posição e indice das janelas
  #--------------------------------------------------------------------------
  def initialize_aux_windows
    @index_window = -1
    @actor_command_windows.each{|window| window.x = @actor_pos_x; window.y = @actor_pos_y}
  end
  #--------------------------------------------------------------------------
  # * Atualização do conteúdo
  #--------------------------------------------------------------------------
  def update_contents
    return unless @actor_pos_x
    for n in 0...7
      get_rest = (self.index - n) % 7
      case get_rest
      when 0
        x = 0
        y = 0
      when 1
        x = 1
        y = -1
      when 2
        x = 2
        y = -2
      when 3
        x = 3
        y = -3
      when 4
        x = 3
        y = 3
      when 5
        x = 2
        y = 2
      when 6
        x = 1
        y = 1
      end
      if x == 3
        set_aux(n , x * Akea_Battle_Window::Move_Speed[0] * - 10 + @actor_pos_x, y * Akea_Battle_Window::Move_Speed[1] * 10 + @actor_pos_y)
      else
        move_aux(n , x * Akea_Battle_Window::Move_Speed[0] * - 10 + @actor_pos_x, y * Akea_Battle_Window::Move_Speed[1] * 10 + @actor_pos_y)
      end
      if @data[self.index + y]
        if y.abs >= 2 || self.index == 0 && y < 0
          take_opacity(n)
        elsif y.abs == 1
          side_opacity(n)
        else
          center_opacity(n)
        end
        next if @index_window == self.index
        @actor_command_windows[n].show_contents(@data[self.index + y], Akea_Battle_Window::Back_Base_Skills_Pic, true) 
      else
        take_opacity(n)
      end
    end
    @help_Sprite.opacity = @actor_command_windows[self.index % 7].contents_opacity
    @index_window = self.index 
  end
  #--------------------------------------------------------------------------
  # * Método de atualização das janelas
  #--------------------------------------------------------------------------
  def refresh_aux_windows
    for n in 0...7
      if @data[n] 
        @actor_command_windows[n].show_contents(@data[n], Akea_Battle_Window::Back_Base_Skills_Pic, true)
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Opacidade lateral
  #--------------------------------------------------------------------------
  def side_opacity(i)
    if @actor_command_windows[i].contents_opacity < 140
      @actor_command_windows[i].contents_opacity += 15
    elsif @actor_command_windows[i].contents_opacity  > 160
      @actor_command_windows[i].contents_opacity -= 15
    end
  end
  #--------------------------------------------------------------------------
  # * Método de opacidade central
  #--------------------------------------------------------------------------
  def center_opacity(i)
    @actor_command_windows[i].contents_opacity += 15
  end
  #--------------------------------------------------------------------------
  # * Método de reduzir opacidade(com fade)
  #--------------------------------------------------------------------------
  def take_opacity(i)
    @actor_command_windows[i].contents_opacity -= 15
  end
  #--------------------------------------------------------------------------
  # * Método de reduzir opacidade(sem fade)
  #--------------------------------------------------------------------------
  def take_all_opacity
    @actor_command_windows.each{|com| com.contents_opacity = 0}
  end
  #--------------------------------------------------------------------------
  # * Método de retornar as janelas auxiliares
  #--------------------------------------------------------------------------
  def return_aux_windows
    @actor_command_windows.each{|pic| pic.contents_opacity -= 15}
    @help_Sprite.opacity -= 15
  end
  #--------------------------------------------------------------------------
  # * Método de movimento das janelas
  #--------------------------------------------------------------------------
  def move_aux(n, pos_x, pos_y)
     @actor_command_windows[n].x += Akea_Battle_Window::Move_Speed[0] if @actor_command_windows[n].x < pos_x
     @actor_command_windows[n].x -= Akea_Battle_Window::Move_Speed[0] if @actor_command_windows[n].x > pos_x
     @actor_command_windows[n].y += Akea_Battle_Window::Move_Speed[1] if @actor_command_windows[n].y < pos_y
     @actor_command_windows[n].y -= Akea_Battle_Window::Move_Speed[1] if @actor_command_windows[n].y > pos_y
   end
  #--------------------------------------------------------------------------
  # * Método que seta a posição das janelas
  #--------------------------------------------------------------------------
  def set_aux(n, pos_x, pos_y)
     @actor_command_windows[n].x = pos_x
     @actor_command_windows[n].y = pos_y
  end
  #--------------------------------------------------------------------------
  # * Movimento do cursor para baixo
  #     wrap : cursor retornar a primeira ou ultima posição
  #--------------------------------------------------------------------------
  def cursor_down(wrap = false)
    super(false)
  end
  #--------------------------------------------------------------------------
  # * Movimento do cursor para cima
  #     wrap : cursor retornar a primeira ou ultima posição
  #--------------------------------------------------------------------------
  def cursor_up(wrap = false)
    super(false)
  end
  #--------------------------------------------------------------------------
  # * Movimento do cursor para baixo
  #     wrap : cursor retornar a primeira ou ultima posição
  #--------------------------------------------------------------------------
  def cursor_left(wrap = false)
    super(false)
  end
  #--------------------------------------------------------------------------
  # * Movimento do cursor para cima
  #     wrap : cursor retornar a primeira ou ultima posição
  #--------------------------------------------------------------------------
  def cursor_right(wrap = false)
    super(false)
  end
  #--------------------------------------------------------------------------
  # * Exibição da janela
  #--------------------------------------------------------------------------
  def show
    select_last
    @help_window.show
    @help_window.opacity = Akea_Battle_Window::Help_Opacity
    @help_window.x = Akea_Battle_Window::Help_Pos[@p_index][0]
    @help_window.y = Akea_Battle_Window::Help_Pos[@p_index][1]
    @help_Sprite.x = Akea_Battle_Window::Help_Pos2[@p_index][0]
    @help_Sprite.y = Akea_Battle_Window::Help_Pos2[@p_index][1]
    super
  end
  #--------------------------------------------------------------------------
  # * Ocultação da janela
  #--------------------------------------------------------------------------
  def hide
    @help_window.hide
    @help_window.opacity = 255
    @help_window.x = 0
    @help_window.y = 0
    super
  end
end


#==============================================================================
# ** Window_BattleItem
#------------------------------------------------------------------------------
#  Esta janela para seleção de itens na tela de batalha.
#==============================================================================

class Window_BattleItem < Window_ItemList
alias :akea_bw_initialize :initialize
alias :akea_bw_dispose :dispose
  #--------------------------------------------------------------------------
  # * Inicialização do objeto
  #     info_viewport : viewport para exibir informações
  #--------------------------------------------------------------------------
  def initialize(help_window, info_viewport)
    akea_bw_initialize(help_window, info_viewport)
    @index_window = 0
    @help_Sprite = Sprite.new
    @help_Sprite.opacity = 0
    @help_Sprite.bitmap = Cache.akea(Akea_Battle_Window::Help_Image)
    create_aux_windows
  end
  def dispose
    @actor_command_windows.each{|obj| obj.dispose}
    @help_Sprite.bitmap.dispose
    @help_Sprite.dispose
    akea_bw_dispose
  end
  #--------------------------------------------------------------------------
  # * Número de colunas
  #--------------------------------------------------------------------------
  def col_max
    return 1
  end
  #--------------------------------------------------------------------------
  # * Definição de herói
  #     actor : herói
  #--------------------------------------------------------------------------
  def actor=(actor)
    @p_index = $game_party.members.index(actor)
    @actor_pos_x = Akea_Battle_Window::Party_Pos2[@p_index][0]
    @actor_pos_y = Akea_Battle_Window::Party_Pos2[@p_index][1]
    @actor_command_windows.each{|pic| pic.x = @actor_pos_x; pic.y = @actor_pos_y}
    return if @actor == actor
    @actor = actor
    refresh
    self.oy = 0
    initialize_aux_windows
  end
  #--------------------------------------------------------------------------
  # * Método de criação das janelas auxiliares
  #--------------------------------------------------------------------------
  def create_aux_windows
    @actor_command_windows = Array.new(7)
    for n in 0...7
      @actor_command_windows[n] = Window_Command_Akea.new(0, 0, Akea_Battle_Window::Skill_Window_Size[0], Akea_Battle_Window::Skill_Window_Size[1])
      @actor_command_windows[n].opacity = 0
      @actor_command_windows[n].contents_opacity = 250
      @actor_command_windows[n].show_contents(@data[n].name, Akea_Battle_Window::Back_Base_Skills_Pic) if @data[n]
    end
  end
  #--------------------------------------------------------------------------
  # * Método de atualização das janelas
  #--------------------------------------------------------------------------
  def refresh_aux_windows
    for n in 0...7
      if @data[n] 
        @actor_command_windows[n].show_contents(@data[n], Akea_Battle_Window::Back_Base_Skills_Pic)
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Método de inicialização do indice e posições da janela
  #--------------------------------------------------------------------------
  def initialize_aux_windows
    @index_window = -1
    @actor_command_windows.each{|window| window.x = @actor_pos_x; window.y = @actor_pos_y}
  end
  #--------------------------------------------------------------------------
  # * Método de atualização do conteúdo
  #--------------------------------------------------------------------------
  def update_contents
    return unless @actor_pos_x
    for n in 0...7
      get_rest = (self.index - n) % 7
      case get_rest
      when 0
        x = 0
        y = 0
      when 1
        x = 1
        y = -1
      when 2
        x = 2
        y = -2
      when 3
        x = 3
        y = -3
      when 4
        x = 3
        y = 3
      when 5
        x = 2
        y = 2
      when 6
        x = 1
        y = 1
      end
      if x == 3
        set_aux(n , x * Akea_Battle_Window::Move_Speed[0] * - 10 + @actor_pos_x, y * Akea_Battle_Window::Move_Speed[1] * 10 + @actor_pos_y)
      else
        move_aux(n , x * Akea_Battle_Window::Move_Speed[0] * - 10 + @actor_pos_x, y * Akea_Battle_Window::Move_Speed[1] * 10 + @actor_pos_y)
      end
      if @data[self.index + y]
        if y.abs >= 2 || self.index == 0 && y < 0
          take_opacity(n)
        elsif y.abs == 1
          side_opacity(n)
        else
          center_opacity(n)
        end
        next if @index_window == self.index
        @actor_command_windows[n].show_contents(@data[self.index + y], Akea_Battle_Window::Back_Base_Skills_Pic) 
      else
        take_opacity(n)
      end
    end
    @help_Sprite.opacity = @actor_command_windows[self.index % 7].contents_opacity
    @index_window = self.index 
  end
  #--------------------------------------------------------------------------
  # * Opacidade lateral
  #--------------------------------------------------------------------------
  def side_opacity(i)
    if @actor_command_windows[i].contents_opacity < 140
      @actor_command_windows[i].contents_opacity += 15
    elsif @actor_command_windows[i].contents_opacity  > 160
      @actor_command_windows[i].contents_opacity -= 15
    end
  end
  #--------------------------------------------------------------------------
  # * Método de opacidade central
  #--------------------------------------------------------------------------
  def center_opacity(i)
    @actor_command_windows[i].contents_opacity += 15
  end
  #--------------------------------------------------------------------------
  # * Método de reduzir opacidade(com fade)
  #--------------------------------------------------------------------------
  def take_opacity(i)
    @actor_command_windows[i].contents_opacity -= 15
  end
  #--------------------------------------------------------------------------
  # * Método de reduzir opacidade(sem fade)
  #--------------------------------------------------------------------------
  def take_all_opacity
    @actor_command_windows.each{|com| com.contents_opacity = 0}
  end
  #--------------------------------------------------------------------------
  # * Método de retornar as janelas auxiliares
  #--------------------------------------------------------------------------
  def return_aux_windows
    @actor_command_windows.each{|pic| pic.contents_opacity -= 15}
    @help_Sprite.opacity -= 15
  end
  #--------------------------------------------------------------------------
  # * Método de movimentação das janelas auxiliares
  #--------------------------------------------------------------------------
  def move_aux(n, pos_x, pos_y)
     @actor_command_windows[n].x += Akea_Battle_Window::Move_Speed[0] if @actor_command_windows[n].x < pos_x
     @actor_command_windows[n].x -= Akea_Battle_Window::Move_Speed[0] if @actor_command_windows[n].x > pos_x
     @actor_command_windows[n].y += Akea_Battle_Window::Move_Speed[1] if @actor_command_windows[n].y < pos_y
     @actor_command_windows[n].y -= Akea_Battle_Window::Move_Speed[1] if @actor_command_windows[n].y > pos_y
   end
  #--------------------------------------------------------------------------
  # * Método para setar a posição das janelas
  #--------------------------------------------------------------------------
  def set_aux(n, pos_x, pos_y)
     @actor_command_windows[n].x = pos_x
     @actor_command_windows[n].y = pos_y
  end
  #--------------------------------------------------------------------------
  # * Movimento do cursor para baixo
  #     wrap : cursor retornar a primeira ou ultima posição
  #--------------------------------------------------------------------------
  def cursor_down(wrap = false)
    super(false)
  end
  #--------------------------------------------------------------------------
  # * Movimento do cursor para cima
  #     wrap : cursor retornar a primeira ou ultima posição
  #--------------------------------------------------------------------------
  def cursor_up(wrap = false)
    super(false)
  end
  #--------------------------------------------------------------------------
  # * Movimento do cursor para baixo
  #     wrap : cursor retornar a primeira ou ultima posição
  #--------------------------------------------------------------------------
  def cursor_left(wrap = false)
    super(false)
  end
  #--------------------------------------------------------------------------
  # * Movimento do cursor para cima
  #     wrap : cursor retornar a primeira ou ultima posição
  #--------------------------------------------------------------------------
  def cursor_right(wrap = false)
    super(false)
  end
  #--------------------------------------------------------------------------
  # * Exibição da janela
  #--------------------------------------------------------------------------
  def show
    select_last
    @help_window.show
    @help_window.opacity = Akea_Battle_Window::Help_Opacity
    @help_window.x = Akea_Battle_Window::Help_Pos[@p_index][0]
    @help_window.y = Akea_Battle_Window::Help_Pos[@p_index][1]
    @help_Sprite.x = Akea_Battle_Window::Help_Pos2[@p_index][0]
    @help_Sprite.y = Akea_Battle_Window::Help_Pos2[@p_index][1]
    super
  end
  #--------------------------------------------------------------------------
  # * Ocultação da janela
  #--------------------------------------------------------------------------
  def hide
    @help_window.hide
    @help_window.opacity = 255
    @help_window.x = 0
    @help_window.y = 0
    super
  end
end

#==============================================================================
# ** Window_PartyCommand
#------------------------------------------------------------------------------
#  Esta janela é usada para se escolher se deseja lutar ou fugir na 
# tela de batalha.
#==============================================================================

class Window_PartyCommand < Window_Command
alias :akea_bw_initialize :initialize
alias :akea_bw_dispose :dispose
  #--------------------------------------------------------------------------
  # * Inicialização do objeto
  #--------------------------------------------------------------------------
  def initialize
    akea_bw_initialize
    @aux_sprite = []
    for n in 0...2
      @aux_sprite[n] = Sprite.new
      @aux_sprite[n].opacity = 0
      @aux_sprite[n].x = Akea_Battle_Window::Fight_Pos[0]
      @aux_sprite[n].y = Akea_Battle_Window::Fight_Pos[1]
    end
    @aux_sprite[0].bitmap = Cache.akea(Akea_Battle_Window::Fight_Pic)
    @aux_sprite[1].bitmap = Cache.akea(Akea_Battle_Window::Run_Pic)
    @aux_sprite[0].bitmap.draw_text(0, 0, @aux_sprite[0].bitmap.width, @aux_sprite[0].bitmap.height, Vocab::fight, 1)
    @aux_sprite[1].bitmap.draw_text(0, 0, @aux_sprite[1].bitmap.width, @aux_sprite[1].bitmap.height, Vocab::escape, 1)
    self.x = -150
    self.y = -150
  end
  def dispose
    @aux_sprite.each{|obj| obj.bitmap.dispose; obj.dispose}
    akea_bw_dispose
  end
  #--------------------------------------------------------------------------
  # * Movimento de janelas auxiliares
  #--------------------------------------------------------------------------
  def move_aux_windows
    if self.index == 0
      @aux_sprite[0].opacity += 15
      side_opacity(1)
      move_aux(0, Akea_Battle_Window::Fight_Pos[0], Akea_Battle_Window::Fight_Pos[1])
      move_aux(1, Akea_Battle_Window::Fight_Pos[0] + Akea_Battle_Window::Fight_Pos_Dist[0], Akea_Battle_Window::Fight_Pos[1] + Akea_Battle_Window::Fight_Pos_Dist[1])
    else
      @aux_sprite[1].opacity += 15
      side_opacity(0)
      move_aux(1, Akea_Battle_Window::Fight_Pos[0], Akea_Battle_Window::Fight_Pos[1])
      move_aux(0, Akea_Battle_Window::Fight_Pos[0] - Akea_Battle_Window::Fight_Pos_Dist[0], Akea_Battle_Window::Fight_Pos[1] - Akea_Battle_Window::Fight_Pos_Dist[1])
    end
  end
  #--------------------------------------------------------------------------
  # * Movimento de retorno das janelas
  #--------------------------------------------------------------------------
  def return_aux_windows
    for n in 0..1
      @aux_sprite[n].opacity -= 25
      move_aux(0, Akea_Battle_Window::Fight_Pos[0], Akea_Battle_Window::Fight_Pos[1])
      move_aux(1, Akea_Battle_Window::Fight_Pos[0], Akea_Battle_Window::Fight_Pos[1])
    end
  end
  #--------------------------------------------------------------------------
  # * Opacidade lateral
  #--------------------------------------------------------------------------
  def side_opacity(i)
    if @aux_sprite[i].opacity < 140
      @aux_sprite[i].opacity += 15
    elsif @aux_sprite[i].opacity  > 160
      @aux_sprite[i].opacity -= 15
    end
  end
  #--------------------------------------------------------------------------
  # * Método de movimento das janelas
  #--------------------------------------------------------------------------
  def move_aux(n, pos_x, pos_y)
     @aux_sprite[n].x += Akea_Battle_Window::Move_Speed[0] if @aux_sprite[n].x < pos_x
     @aux_sprite[n].x -= Akea_Battle_Window::Move_Speed[0] if @aux_sprite[n].x > pos_x
     @aux_sprite[n].y += Akea_Battle_Window::Move_Speed[1] if @aux_sprite[n].y < pos_y
     @aux_sprite[n].y -= Akea_Battle_Window::Move_Speed[1] if @aux_sprite[n].y > pos_y
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