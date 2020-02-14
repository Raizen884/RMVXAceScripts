module Lune_Message_Add
#=======================================================
#         Lune Message Add-ons
# Autor: Raizen
# Comunidade : www.centrorpg.com
# Compativel com: RMVXAce
# O script permite caracteres especias e adiciona novas
# funções aos scripts de mensagens, compátivel com a maioria
# dos scripts de mensagens que mudam apenas a aparência, e não
# seus caracteres.
# Mantenha esse script abaixo do script de mensagens que está
# utilizando, e acima do main.
#========================================================
#========================================================
# Configurações iniciais.
# Aqui será configurado o que será tido como padrão em todas as janelas.

# Fonte padrão?
Lune_Default_Font = "Comic Sans MS"
# Outline? se a fonte terá ou não um contorno (padrão = true)
Lune_Default_Outline = true
# Shadow? se a fonte terá ou não uma sombra atrás (padrão = false)
Lune_Default_Shadow = false
# Italic? se a fonte será italico por padrão (padrão = false)
Lune_Default_Italic = false
# Bold? se a fonte será bold por padrão (padrão = false)
Lune_Default_Bold = false
# tamanho padrão da fonte
Font.default_size = 24

#==========================================================
# Configurações de mensagem. Apenas afetará as mensagens!

# Windowskin das mensagens, para manter o mesmo das janelas basta
# Colocar o nome original, Window.

Windowskin = "Window"
=begin
#==========================================================
 Códigos para serem utilizados na janela de mensagens.

 Códigos padrões, esses estavam presentes mesmo na ausencia desse script.
 Usarei o x como variável.

\v[x]       =>  escreve o valor da variável x
\i[x]       =>  escreve o icone com indice x
\n[x]       =>  escreve o nome do personagem no database com ID x
\p[x]       =>  escreve o nome do personagem na party com ID x
\c[x]       =>  muda a cor da fonte nas mensagens, pelo indice da windowskin
\{          =>  aumenta a fonte
\}          =>  diminui a fonte
\.          =>  Esperar 15 frames
\|          =>  Esperar 60 frames
\!          =>  Esperar a tecla.
\^          =>  mensagem automatica, não espera a tecla.
#==========================================================
#==========================================================
# Códigos adicionados por esse script

 Códigos adicionados no script.
 Usarei o x como variável.

\fb         =>  bold = verdadeiro
\nob        =>  bold = falso
\fi         =>  italico = verdadeiro
\noi        =>  italico = falso
\fo         =>  outline = verdadeiro
\noo        =>  outline = falso
\fhs        =>  shadow = verdadeiro
\nos        =>  shadow = falso
\fs[x]      =>  tamanho da fonte = x
\hc[x][y][z]=>  Muda a cor da fonte no sistema (R,G,B) R = x, G = y, B = z
\w[x]       =>  espera x frames
   
\ne[x]      =>  nome da classe com ID x
\ie[x]      =>  icone mais o nome da classe com ID x 
\ns[x]      =>  nome do skill com ID x
\is[x]      =>  icone mais o nome do skill com ID x 
\ni[x]      =>  nome do item com ID x
\ii[x]      =>  icone mais o nome do item com ID x 
\nw[x]      =>  nome da arma com ID x
\iw[x]      =>  icone mais o nome da arma com ID x 
\na[x]      =>  nome da armadura com ID x
\ia[x]      =>  icone mais o nome da armadura com ID x 


=end
end


#==========================================================
# Inicio do script.
#==========================================================
# Reescreve os métodos.
# convert_escape_characters    =>  Window_Message
#==========================================================
# Alias dos métodos
# draw_text                    =>  Window_Base
# initialize                   =>  Window_Message
# open_and_wait                =>  Window_Message
# close_and_wait               =>  Window_Message
# process_escape_character     =>  Window_Base
#==========================================================
# Novos métodos
# actor_info                   =>  Window_Base
# lune_basic_configs           =>  Window_Message
# open_and_wait                =>  Window_Message
# close_and_wait               =>  Window_Message
# process_escape_character     =>  Window_Base
#==========================================================



class Lune_Window_Message < Window_Base
  alias lune_initialize_mes initialize
  def initialize(x, y, width, height)
    lune_initialize_mes(x, y, width, height)
    self.windowskin = Cache.system(Lune_Message_Add::Windowskin)
  end
end

class Window_Message < Window_Base
alias lune_initialize_mes initialize
alias lune_process_allt open_and_wait
alias lune_process_allc close_and_wait
  def initialize
    lune_initialize_mes
    self.windowskin = Cache.system(Lune_Message_Add::Windowskin)
  end
  def open_and_wait    
    @lune_face.windowskin = Cache.system(Lune_Message_Add::Windowskin) unless @lune_face.nil?
    lune_process_allt
  end
  def close_and_wait
    lune_process_allc
    @lune_face = nil
  end
end



class Window_Base < Window
alias lune_process_escape_character process_escape_character
alias lune_mes_initialize draw_text
  def process_escape_character(code, text, pos)
    lune_process_escape_character(code, text, pos)
    case code.upcase
      when 'FB'
        contents.font.bold = true
      when 'FI'
        contents.font.italic = true      
      when 'FO'
        contents.font.outline = true
      when 'FHS'
        contents.font.shadow = true   
      when 'NOB'
        contents.font.bold = false
      when 'NOO'
        contents.font.outline = false
      when 'NOI'
        contents.font.italic = false
      when 'NOS'
        contents.font.shadow = false
      when 'FS'
        contents.font.size = obtain_escape_param(text)
      when 'HC'
        change_color(Color.new(obtain_escape_param(text),obtain_escape_param(text),obtain_escape_param(text)))
      when 'W'
        wait(obtain_escape_param(text))
      when 'FN'
        text.sub!(/\[(.*?)\]/, "")
        contents.font.name = $1.to_s
      end
    end 

  def convert_escape_characters(text)
    result = text.to_s.clone
    result.gsub!(/\\/)            { "\e" }
    result.gsub!(/\e\e/)          { "\\" }
    result.gsub!(/\eV\[(\d+)\]/i) { $game_variables[$1.to_i] }
    result.gsub!(/\eV\[(\d+)\]/i) { $game_variables[$1.to_i] }
    result.gsub!(/\eN\[(\d+)\]/i) { actor_name($1.to_i) }
    result.gsub!(/\eP\[(\d+)\]/i) { party_member_name($1.to_i) }
    result.gsub!(/\eG/i)          { Vocab::currency_unit }
    
    result.gsub!(/\eIE\[(\d+)\]/i) { actor_info($1.to_i, 1) }
    result.gsub!(/\eIS\[(\d+)\]/i) { actor_info($1.to_i, 2) }
    result.gsub!(/\eII\[(\d+)\]/i) { actor_info($1.to_i, 3) }
    result.gsub!(/\eIW\[(\d+)\]/i) { actor_info($1.to_i, 4) }
    result.gsub!(/\eIA\[(\d+)\]/i) { actor_info($1.to_i, 5) }    

    
    result.gsub!(/\eNE\[(\d+)\]/i) { $data_states[$1.to_i] }
    result.gsub!(/\eNS\[(\d+)\]/i) { $data_skills[$1.to_i] }
    result.gsub!(/\eNI\[(\d+)\]/i) { $data_items[$1.to_i] }
    result.gsub!(/\eNW\[(\d+)\]/i) { $data_weapons[$1.to_i] }
    result.gsub!(/\eNA\[(\d+)\]/i) { $data_armors[$1.to_i] }    
    result
  end
  def actor_info(n, z)
    case z
    when 1
      name = $data_states[n].name
      icon = $data_states[n].icon_index
    when 2
      name = $data_skills[n].name
      icon = $data_skills[n].icon_index
    when 3
      name = $data_items[n].name
      icon = $data_items[n].icon_index
    when 4
      name = $data_weapons[n].name
      icon = $data_weapons[n].icon_index
    when 5
      name = $data_armors[n].name
      icon = $data_armors[n].icon_index
    end
    text = "\eI[#{icon}]" + name
  end
  def draw_text(*args)
    lune_basic_configs
    lune_mes_initialize(*args)
  end
  def lune_basic_configs
    return if @get_lune_configs
    @get_lune_configs = true
    self.contents.font.name = Lune_Message_Add::Lune_Default_Font
    self.contents.font.outline = Lune_Message_Add::Lune_Default_Font
    self.contents.font.shadow = Lune_Message_Add::Lune_Default_Shadow  
    self.contents.font.italic = Lune_Message_Add::Lune_Default_Italic
    self.contents.font.bold = Lune_Message_Add::Lune_Default_Bold
  end
end
