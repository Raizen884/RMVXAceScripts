#=======================================================
# Autor: Raizen
#         Lune Hardcore Mode
# Comunidade : www.centrorpg.com
# Adiciona a função de hardcore ao jogo, aonde personagens caídos não retornam
# função encontrada em Diablo 2, Fire Emblem Awakening e entre outros jogos.
#=======================================================
$imported ||= {}
$imported[:Lune_Hardcore] = true


#=================================================================#
#====================  Comandos  =============================#
#=================================================================#
# Para ativar o modo hardcore, 
# Chamar Script : hardcore_mode_on
# Para desativar
# Chamar Script : hardcore_mode_off

# Para verificar se um personagem está vivo, é para ser usado 
# nas condições, Condição Script
# Chamar Script : alive_hardcore(actor_id)
# aonde actor_id é o id do actor no database

# $game_party.turn_down_member(actor_id)
# Remove um personagem do jogo

# $game_party.rise_down_member(actor_id)
# Retorna um personagem fora do jogo de volta ao mesmo

#=================================================================#
#====================  Configuração  =============================#
#=================================================================#
module Lune_Hardcore_Mode

# Forçar o jogador a sempre utilizar o mesmo save?
Forced_Save = true

# Travar o Save?( Ou seja não permitir que o jogador jogue mais caso não tenha
# personagens vivos naquele save)
Lock_Save = false

# Configure abaixo caso não trave o save, o jogo sairá do modo hardcore

#Personagem a ser adicionado ( a party estará vazia)
Party_First_Member = 1

# ID do mapa a retornar
Map_id = 2

# Posição a retornar
Pos_X = 1
Pos_Y = 1
end
#=================================================================#
#====================  Alias methods =============================#
# judge_win_loss          => BattleManager
# add_actor               => Game_Party
# initialize              => Game_Party
# dead?                   => Game_Actor
# check_gameover          => Scene_Base
# start                   => Scene_Gameover
# on_load_success         => Scene_Load
# start                   => Scene_Save
# on_save_success         => Scene_Save
#=================================================================#
#====================  Rewrite methods ===========================#
# ---------------------------------------------------------
#=================================================================#
#=================================================================#
# Aqui começa o script.
#=======================================================

#==============================================================================
# ** BattleManager
#------------------------------------------------------------------------------
#  Este módulo gerencia o andamento da batalha.
#==============================================================================

module BattleManager 
  class << self
  alias :lune_hardcore_judge_win_loss :judge_win_loss
    #--------------------------------------------------------------------------
    # * Definição de vitória ou derrota
    #--------------------------------------------------------------------------
    def judge_win_loss
      return process_defeat  if @phase && $game_party.members.empty?
      lune_hardcore_judge_win_loss
    end
  end
end

#==============================================================================
# ** Game_Party
#------------------------------------------------------------------------------
#  Esta classe gerencia o grupo. Contém informações sobre dinheiro, itens.
# A instância desta classe é referenciada por $game_party.
#==============================================================================

class Game_Party < Game_Unit
alias :lune_hardcore_initialize :initialize
alias :lune_hardcore_add_actor :add_actor 
attr_accessor :lune_hardcore_active
attr_accessor :has_saved
  #--------------------------------------------------------------------------
  # * Hardcore_Alive
  #--------------------------------------------------------------------------
  def initialize(*args, &block)
    lune_hardcore_initialize(*args, &block)
    @has_saved = false
    @lune_hardcore_active = false
    @lune_hardcore_alive_members = Array.new($data_actors.size + 1, true)
  end
  #--------------------------------------------------------------------------
  # * Adição do herói
  #     actor_id : ID do herói
  #--------------------------------------------------------------------------
  def add_actor(actor_id)
    return unless @lune_hardcore_alive_members[actor_id]
    lune_hardcore_add_actor(actor_id)
  end
  #--------------------------------------------------------------------------
  # * Remove um personagem do jogo
  #--------------------------------------------------------------------------
  def turn_down_member(actor_id)
    @lune_hardcore_alive_members[actor_id] = false
  end
  #--------------------------------------------------------------------------
  # * Levanta um personagem Caído
  #--------------------------------------------------------------------------
  def rise_down_member(actor_id)
    @lune_hardcore_alive_members[actor_id] = true
  end
  #--------------------------------------------------------------------------
  # * Retorna todos os personagens ao jogo
  #--------------------------------------------------------------------------
  def lune_hardcore_turn_off
    @lune_hardcore_alive_members.fill(true)
  end
  #--------------------------------------------------------------------------
  # * Verifica se personagem está vivo
  #--------------------------------------------------------------------------
  def alive_hardcore(actor_id)
    @lune_hardcore_alive_members[actor_id]
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
alias :lune_hardcore_dead? :dead?
  #--------------------------------------------------------------------------
  # * Verifica se personagem está vivo
  #--------------------------------------------------------------------------
  def alive_hardcore
    $game_party.alive_hardcore(@actor_id)
  end
  #--------------------------------------------------------------------------
  # * Remove Personagem do jogo
  #--------------------------------------------------------------------------
  def dead?
    if exist? && death_state? && $game_party.lune_hardcore_active
      $game_party.turn_down_member(@actor_id)
      $game_party.remove_actor(@actor_id) 
    end
    lune_hardcore_dead?
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
  # * Ativar o modo hardcore
  #--------------------------------------------------------------------------
  def hardcore_mode_on
    $game_party.lune_hardcore_active = true
  end
  #--------------------------------------------------------------------------
  # * Desativar o modo hardcore
  #--------------------------------------------------------------------------
  def hardcore_mode_off
    $game_party.lune_hardcore_active = false
    $game_party.lune_hardcore_turn_off
  end
  #--------------------------------------------------------------------------
  # * Verifica se personagem está vivo
  #--------------------------------------------------------------------------
  def alive_hardcore(actor_id)
    $game_party.alive_hardcore(actor_id)
  end
end


#==============================================================================
# ** Scene_Base
#------------------------------------------------------------------------------
#  Esta é a superclasse de todas as cenas do jogo.
#==============================================================================

class Scene_Base
alias :lune_hardcore_check_gameover :check_gameover
  #--------------------------------------------------------------------------
  # * Definição de game over
  #--------------------------------------------------------------------------
  def check_gameover
    SceneManager.goto(Scene_Gameover) if $game_party.members.empty?
    lune_hardcore_check_gameover
  end
end

#==============================================================================
# ** Scene_Gameover
#------------------------------------------------------------------------------
#  Esta classe executa o processamento da tela de game over.
#==============================================================================

class Scene_Gameover < Scene_Base
alias :lune_hardcore_start :start
  #--------------------------------------------------------------------------
  # * Processamento principal
  #--------------------------------------------------------------------------
  def start
    DataManager.save_game(DataManager.last_savefile_index) if $game_party.members.empty?
    lune_hardcore_start
  end
end
#==============================================================================
# ** Scene_Load
#------------------------------------------------------------------------------
#  Esta classe executa o processamento da tela de carregar.
#==============================================================================

class Scene_Load < Scene_File
alias :lune_on_load_success :on_load_success
  #--------------------------------------------------------------------------
  # * Processo de carregamento aquivo bem sucedido
  #--------------------------------------------------------------------------
  def on_load_success
    if $game_party.members.empty? && Lune_Hardcore_Mode::Lock_Save
      Sound.play_buzzer
      return
    elsif $game_party.members.empty?
      $game_party.lune_hardcore_active = false
      $game_party.lune_hardcore_turn_off     
      $game_party.add_actor(Lune_Hardcore_Mode::Party_First_Member)
      $game_party.members[0].change_hp(1, false)
      $game_map.setup(Lune_Hardcore_Mode::Map_id)
      $game_player.moveto(Lune_Hardcore_Mode::Pos_X, Lune_Hardcore_Mode::Pos_Y)
    end
    lune_on_load_success
  end
end
#==============================================================================
# ** Scene_Save
#------------------------------------------------------------------------------
#  Esta classe executa o processamento da tela de salvar.
#==============================================================================

class Scene_Save < Scene_File
alias :lune_hardcore_start :start
alias :lune_hardcore_on_save_success :on_save_success
  #--------------------------------------------------------------------------
  # * Inicialização do processo
  #--------------------------------------------------------------------------
  def start
    if $game_party.has_saved
      super
      DataManager.save_game(DataManager.last_savefile_index)
      return_scene
      Sound.play_save
      return
    end
    lune_hardcore_start
  end
  #--------------------------------------------------------------------------
  # * Processo de salvar aquivo bem sucedido
  #--------------------------------------------------------------------------
  def on_save_success
    $game_party.has_saved = true if Lune_Hardcore_Mode::Forced_Save
    lune_hardcore_on_save_success
  end
end
