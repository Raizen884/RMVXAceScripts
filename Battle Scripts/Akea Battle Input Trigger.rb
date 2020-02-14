#=======================================================
#        Akea Battle Input Trigger
# Autor: Raizen
# Comunidade: http://www.centrorpg.com/
# Compatibilidade: RMVXAce
#
#=======================================================
# O Script permite que uma tecla ou várias, sejam apertadas para 
# tanto conjurar skills adicionais, quanto defender de skills adicionais 
# do adversário
($imported ||= {})[:akea_bit] = true
module Akea_ITT
# ============== Não Modificar! ==================
Input = Array.new
#--------------------------------------------------------
# ==================== Instruções =======================
#--------------------------------------------------------
# Para adicionar um Input a uma skill ou arma, basta adicionar
# isso ao bloco de notas,
# <getinput n|id|chance>
# Aonde:
 # n = n da input configurável abaixo no script
 # id = id da skill que será acionada
 # chance = chance em % da input ser acionada
 
# Um exemplo, se quero usar as configurações do Input[0],
# com a skill de id 55 no database, e ter 50% de chance de ocorrer
# bastaria 
# <getinput 0|55|50> dentro da notetag ou de uma skill ou de uma arma

#--------------------------------------------------------
# ================= Configurações ========================
#--------------------------------------------------------

# IMPORTANTE: As imagens devem estar na pasta Graphics/Akea do seu projeto!!

# Imagens das Huds
#Imagem da Base
Base_Hud = 'base_input_hud' 

#Imagem da Barra
Bar_Hud = 'bar_input'
# Todas as posições seguem o seguinte padrão
# [Pos em x, Pos em y, Pos em z]
# Pos em Z é apenas necessário para imagens, configure apenas
# se houver alguma imagem sobreposta na imagem de hud

# Imagem base da Hud(Base da posição é a posição dos Inputs)
Base_Hud_Pos = [-20, 40, 100]

# Barra da Hud(Base da posição é a posição dos Inputs)
Bar_Hud_Pos = [-14, 43, 99]

# Posição dos Inputs em relação ao inimigo
Enemy_Pos = [0, -80]

# Posição dos Inputs em relação ao ator
Actor_Pos = [0, -80]


#--------------------------------------------------------
# ================= Configuração de Inputs ========================
#--------------------------------------------------------
# Mapeamento de Teclas do RPG Maker VX Ace, para auxiliar na configuração
# X = Tecla A  ;  Y = Tecla S  ;  Z = Tecla D
# L = Tecla Q  ;  R = Tecla W  ;  SHIFT
# RIGHT = Direcional(Direita) ; LEFT Direcional(Esquerda)
# Up = Direcional(Cima) ; DOWN = Direcional(Baixo)
# ----------- Input 0 -----------------------
Input[0] = {
:triggers => [:X, :B, :Y, :C, :LEFT, :RIGHT, :DOWN, :UP], # Teclas desse Input, 
:pics => ['A', 'X', 'S', 'Z', 'LEFT', 'RIGHT', 'DOWN', 'UP'], # Imagens do Input
:time => 300, #Tempo limite para o input
:num_times => 6, #Quantidade de teclas que o input terá
:random? => true, #Randomizar as teclas? se false ele seguirá exatamente a mesma ordem acima
:position? => 'enemy', #pode ser, 'actor', 'enemy' ou [x, y] a posição
:success_se => 'Save', #SE que tocará caso acerte a sequencia
:failure_se => 'Buzzer2', #SE que tocará caso erre a sequencia
}

# ----------- Input 1 -----------------------
Input[1] = {
:triggers => [:X], # Teclas desse Input, 
:pics => ['A'], # Imagens do Input
:time => 30, #Tempo limite para o input
:num_times => 1, #Quantidade de teclas que o input terá
:random? => true, #Randomizar as teclas? se false ele seguirá exatamente a mesma ordem acima
:position? => [200, 200], #can be, 'actor', 'enemy' , or [x, y] a position
:success_se => 'Save', #SE que tocará caso acerte a sequencia
:failure_se => 'Buzzer2', #SE que tocará caso erre a sequencia
}

# Mapa de teclas : coloque todas as teclas possíveis para o 
# erro de input, caso o jogador aperte a tecla errada irá
# falhar a sequencia.
Key_Map = [:X, :Y, :C, :B, :LEFT, :RIGHT, :UP, :DOWN]
end

# AQUI COMEÇA O SCRIPT!!!!!!!!!!!
#==============================================================================
# ** Scene_Battle
#------------------------------------------------------------------------------
#  Esta classe executa o processamento da tela de batalha.
#==============================================================================

class Scene_Battle < Scene_Base
alias :akea_itt_process_action :process_action
alias :akea_itt_use_item :use_item
alias :akea_itt_start :start
alias :akea_itt_terminate :terminate
  #--------------------------------------------------------------------------
  # * Inicialização do processo
  #--------------------------------------------------------------------------
  def start
    akea_itt_start
    @akea_itt_pic = Sprite.new
    @akea_itt_pic.z = Akea_ITT::Base_Hud_Pos[2]
    @akea_itt_bar = Sprite.new
    @akea_itt_bar.bitmap = Cache.akea(Akea_ITT::Bar_Hud)
    @akea_itt_bar.opacity = 0
    @akea_itt_bar.z = Akea_ITT::Bar_Hud_Pos[2]
    @akea_itt_bar_base = Sprite.new
    @akea_itt_bar_base.bitmap = Cache.akea(Akea_ITT::Base_Hud)
    @akea_itt_bar_base.opacity = 0
    @akea_itt_bar_base.z = Akea_ITT::Base_Hud_Pos[2]
  end
  #--------------------------------------------------------------------------
  # * Uso de habilidades/itens
  #--------------------------------------------------------------------------
  def use_item
    akea_itt_use_item
    battle_notes = @subject.current_action.item.note
    if @subject.current_action.item.id == 1 && @subject.actor? && @subject.equips[0]
      battle_notes = @subject.equips[0].note
    end
    @akea_itt = []
    @akea_trigger_shuffle = -1
    for n in 0...battle_notes.size
      if battle_notes[n..n+9] == "<getinput "
        y = 0
        y += 1 until battle_notes[n+10+y] == '|'
        w = 0
        w += 1 until battle_notes[n+11+y+w] == '|'
        z = 0
        z += 1 until battle_notes[n+11+y+w+z] == '>'
        insert_akea_input(battle_notes[n+10..n+9+y].to_i, battle_notes[n+11+y..n+10+y+w].to_i, battle_notes[n+13+w..n+12+y+w+z].to_i)
      end
    end
    party_id = all_battle_members.index(@subject)
    start_akea_input_trigger
    until @akea_itt.empty?
      break unless party_id
      move_akea_input_bars
      self.class.superclass.instance_method(:update).bind(self).call
      if @akea_input_timer <= 0 && @akea_input_success
        next unless akea_input_animation
        RPG::SE.new(Akea_ITT::Input[@akea_itt.first[0]][:success_se]).play
        @subject.actor? ? call_akea_skill : @akea_itt = []
      elsif @akea_input_timer <= 0 || check_input == 2
        @akea_input_timer = 0
        next unless akea_input_animation
        RPG::SE.new(Akea_ITT::Input[@akea_itt.first[0]][:failure_se]).play
        @subject.actor? ? @akea_itt = [] : call_akea_skill
      elsif check_input == 1
        Sound.play_ok
        @akea_num_triggers -= 1
        if @akea_num_triggers == 0
          @akea_input_success = true
          @akea_input_timer = 0
        else
          if Akea_ITT::Input[@akea_itt.first[0]][:random?]
            @akea_trigger_shuffle = rand(Akea_ITT::Input[@akea_itt.first[0]][:triggers].size)
          else
            @akea_trigger_shuffle += 1
          end
          while @akea_itt_pic.opacity > 0
            self.class.superclass.instance_method(:update).bind(self).call
            @akea_itt_pic.opacity -= 30
          end
          @akea_itt_pic.bitmap.dispose
          @akea_itt_pic.opacity = 255
          @akea_itt_pic.bitmap = Cache.akea(Akea_ITT::Input[@akea_itt.first[0]][:pics][@akea_trigger_shuffle])
        end
      end
      @akea_input_timer -= 1
    end
  end
  #--------------------------------------------------------------------------
  # * Inserir o input na array
  #--------------------------------------------------------------------------
  def insert_akea_input(n, id, chance)
    p [n, id, chance]
    @akea_itt << [n, id] if rand(100) < chance
  end
  #--------------------------------------------------------------------------
  # * Animação de fade do input
  #--------------------------------------------------------------------------
  def akea_input_animation
    @akea_itt_pic.opacity -= 30
    @akea_itt_bar_base.opacity -= 30
    @akea_itt_bar.opacity -= 30
    return false if @akea_itt_pic.opacity > 0
    return true
  end
  #--------------------------------------------------------------------------
  # * Inicialização do processo de input
  #--------------------------------------------------------------------------
  def start_akea_input_trigger
    return if @akea_itt.empty? 
    @akea_input_success = false
    if Akea_ITT::Input[@akea_itt.first[0]][:random?]
      @akea_trigger_shuffle = rand(Akea_ITT::Input[@akea_itt.first[0]][:triggers].size)
    else
      @akea_trigger_shuffle += 1
    end
    @akea_num_triggers = Akea_ITT::Input[@akea_itt.first[0]][:num_times]
    if Akea_ITT::Input[@akea_itt.first[0]][:position?] == 'actor' || (Akea_ITT::Input[@akea_itt.first[0]][:position?] == 'enemy' && @subject.enemy?)
      @akea_itt_pic.x = @subject.screen_x + Akea_ITT::Actor_Pos[0]
      @akea_itt_pic.y = @subject.screen_y + Akea_ITT::Actor_Pos[1]
    elsif Akea_ITT::Input[@akea_itt.first[0]][:position?] == 'enemy'
      targets = @subject.current_action.make_targets.compact
      @akea_itt_pic.x = targets[0].screen_x + Akea_ITT::Enemy_Pos[0]
      @akea_itt_pic.y = targets[0].screen_y + Akea_ITT::Enemy_Pos[1]
    else 
      @akea_itt_pic.x = Akea_ITT::Input[@akea_itt.first[0]][:position?][0]
      @akea_itt_pic.y = Akea_ITT::Input[@akea_itt.first[0]][:position?][1]
    end
    @akea_itt_bar.x = @akea_itt_pic.x + Akea_ITT::Bar_Hud_Pos[0]
    @akea_itt_bar.y = @akea_itt_pic.y + Akea_ITT::Bar_Hud_Pos[1]
    @akea_itt_bar_base.x = @akea_itt_pic.x + Akea_ITT::Base_Hud_Pos[0]
    @akea_itt_bar_base.y = @akea_itt_pic.y + Akea_ITT::Base_Hud_Pos[1]
    @akea_input_timer = Akea_ITT::Input[@akea_itt.first[0]][:time]
    @akea_itt_pic.bitmap.dispose if @akea_itt_pic.bitmap
    @akea_itt_pic.opacity = @akea_itt_bar.opacity = @akea_itt_bar_base.opacity = 255
    @akea_itt_bar.zoom_x = 1
    @akea_itt_pic.bitmap = Cache.akea(Akea_ITT::Input[@akea_itt.first[0]][:pics][@akea_trigger_shuffle])
  end
  #--------------------------------------------------------------------------
  # * Movimento das barras de Input
  #--------------------------------------------------------------------------
  def move_akea_input_bars
    @akea_itt_bar.zoom_x = @akea_input_timer.to_f/Akea_ITT::Input[@akea_itt.first[0]][:time]
  end
  #--------------------------------------------------------------------------
  # * Verificador de teclas
  #--------------------------------------------------------------------------
  def check_input
    Akea_ITT::Key_Map.each{|key| 
    if Input.trigger?(key) 
      return 2 if key != Akea_ITT::Input[@akea_itt.first[0]][:triggers][@akea_trigger_shuffle]
    end
    }
    return 1 if Input.trigger?(Akea_ITT::Input[@akea_itt.first[0]][:triggers][@akea_trigger_shuffle])
    return 0
  end
  #--------------------------------------------------------------------------
  # * Chamada de invocação de habilidade
  #--------------------------------------------------------------------------
  def call_akea_skill
    @akea_trigger_shuffle = -1
    party_id = all_battle_members.index(@subject)
    BattleManager.add_input_trigger_action(party_id)
    if all_battle_members[party_id].actor?
      $game_party.members[party_id].input.set_skill(@akea_itt.first[1])
    else
      targets = @subject.current_action.make_targets.compact
      $game_troop.members[party_id - $game_party.members.size].force_action(@akea_itt.first[1], $game_party.members.index(targets[0]))
    end
    @akea_itt.shift
    akea_itt_use_item 
    self.class.superclass.instance_method(:update).bind(self).call until akea_input_animation
    BattleManager.remove_action_trigger
    unless @akea_itt.empty?
      @akea_input_success = false
      start_akea_input_trigger
    end
  end
  #--------------------------------------------------------------------------
  # * Finalização do processo
  #--------------------------------------------------------------------------
  def terminate
    @akea_itt_bar_base.bitmap.dispose
    @akea_itt_bar_base.dispose
    @akea_itt_bar.bitmap.dispose
    @akea_itt_bar.dispose
    @akea_itt_pic.bitmap.dispose if @akea_itt_pic.bitmap
    @akea_itt_pic.dispose    
    akea_itt_terminate
  end
end


#==============================================================================
# ** BattleManager
#------------------------------------------------------------------------------
#  Este módulo gerencia o andamento da batalha.
#==============================================================================

module BattleManager
  #--------------------------------------------------------------------------
  # * Criação da seqüencia de ações
  #--------------------------------------------------------------------------
  def self.add_input_trigger_action(id)
    @action_battlers = [] unless @action_battlers.is_a?(Array)
    @action_battlers.unshift($game_party.members[id])
  end
  #--------------------------------------------------------------------------
  # * Remove um actor
  #--------------------------------------------------------------------------
  def self.remove_action_trigger
    @action_battlers.shift
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