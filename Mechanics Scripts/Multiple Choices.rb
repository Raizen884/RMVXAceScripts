# Multiplas mensagens
# Autor: Raizen
# Compativel com RMVXAce
# Comunidade: www.centrorpg.com
# Instruções:

# Para usar é bem simples
# Chamar script: @get_choices = [a,b,c,d,e,f,g]
#                   
# aonde nas letras apenas colocar as escolhas a ser usada.
# por exemplo
# deixe as escolhes entre aspas.
# Chamar script: @get_choices = ["bola", "casa", "carro", "azul", "vermelho"]

# Para haver condição de cancelamento, basta colocar um número SEM ASPAS
# no final desse modo.
# Chamar script: @get_choices = ["bola", "casa", "carro", "azul", "vermelho", 5]
# Sendo que o número representa a escolha de cancelamento.
#   
# coloque as frases entre parenteses.
# para decidir o que cada opção faz, basta colocar uma condição
# com a variavel escolhida no modulo.

# após o chamar script.

# Faça como normalmente criaria o mostrar opções, não importa

# Quais opções você crie, depois de chamar o script ele vai criar
# as opções com o que você escolher.

# Mostrar mensagem.
# Mostrar Opção e depois.

# Condição Variavel tal == 1 <- para a primeira escolha
# Condição Variavel tal == 2 <- para a segunda escolha e assim adiante.

# OBS: CASO continue com dúvidas, acesse essa imagem pelo navegador
# para esclarecer como é usado o script.


#  http://i.imgur.com/Pu3aY.png


module Raizen_choices
#variavel de escolha, ela será usada para decidir cada uma das escolhas
#feitas.
Variable = 1
end
#=========================Aqui começa o script============================
class Game_Interpreter
alias raizen_choices setup_choices
  def show_choices(choices)
  n = 0
  while choices[n].is_a?(String) 
  $game_message.choices.push(choices[n])
  n += 1
  end
  $game_message.choice_cancel_type = choices[n] - 1 if choices[n].is_a?(Integer)
  @get_choices = nil
    $game_message.choice_proc = Proc.new {|n| @branch[@indent] = n
    $game_variables[Raizen_choices::Variable] = n + 1 }
    Fiber.yield while $game_message.choice?
  end
    def setup_choices(params)
    @get_choices.nil? ? raizen_choices(params) : show_choices(@get_choices)
  end
end