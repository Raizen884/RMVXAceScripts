=begin
===========================Quebra de limites=======================
Autor:Raizen
Comunidade: www.centrorpg.com
Descrição: Permite configurar para que se tenha valores superiores de level,
atributos, itens e dinheiro superior ao limite imposto pelo database do
RPG Maker VX Ace. Basta configurar os atributos máximos e rodar normalmente
o jogo.
É possível configurar atributos máximos por personagem.

=end
module EngineCRM
#=======================================================================
# valor máximo de gold.
Maxgold = 99999999
# numero maximo de itens carregados.
Maxitens = 999
#=======================================================================
#=======================================================================
# Configure aqui os atributos máximos dos personagens e inimigos.
# Vida máxima do personagem
HPP = 9999
# Vida máxima dos inimigos
HP = 999999
# Mana máxima
MP = 99999
# Ataque máximo
AT = 9999
# Defesa máxima
DF = 9999
# Inteligência máxima
IN = 9999
# Agilidade máxima
AG = 9999
# Resistencia máxima
RS = 9999
# Sorte máxima
LK = 9999
# Level máximo, LEMBRANDO QUE, valores acima de 99 É
# necessário configurar os atributos máximos, assim com uma estimativa
# da para se ter atributos a cada level diferente. Lembramos também
# que o valor 99, resultará em padrão e todas as configurações
# serão no Database.
Maxlevel = 999
#=======================================================================
# Apenas configure aqui, caso o Level maximo seja 99, como funciona
Maxat = []
#você pode retirar e adicionar uma linha para cada nova classe, 
#funcionando dessa maneira:
#Maxat[ID no database da classe] = [Vida , Mana, Ataque, Defesa, 
# Inteligencia, Agilidade, Resistencia, Sorte]
# todos os valores de atributos que esse personagem vai atingir
# ao alcançar o level máximo escolhido.
Maxat[1] = [95482, 9999, 9432, 9932, 7000, 9976, 8999, 9799]
Maxat[2] = [999999, 9999, 9999, 99, 999, 9999, 99999, 99999]
Maxat[3] = [999999, 9999, 999, 99, 999, 9999, 99999, 99999]
Maxat[4] = [999999, 9999, 999, 99, 999, 9999, 99999, 99999]
Maxat[5] = [999999, 9999, 999, 99, 999, 9999, 99999, 99999]
Maxat[6] = [999999, 9999, 999, 99, 999, 9999, 99999, 99999]
#=======================================================================
end
#=======================================================================
class Game_Party < Game_Unit
  def max_gold
    return EngineCRM::Maxgold
  end
  def max_item_number(item)
    return EngineCRM::Maxitens
  end
end

class Game_BattlerBase
  def param_max(param_id)
    return EngineCRM::HP if param_id == 0  # MHP
    return EngineCRM::MP if param_id == 1  # MMP
    return EngineCRM::AT if param_id == 2  # ATK
    return EngineCRM::DF if param_id == 3  # DEF
    return EngineCRM::IN if param_id == 4  # INT
    return EngineCRM::RS if param_id == 5  # RES
    return EngineCRM::AG if param_id == 6  # AGI
    return EngineCRM::LK if param_id == 7  # LUK
  end
end

class Game_Actor < Game_Battler
  def param_max(param_id)
    return EngineCRM::HPP if param_id == 0  # MHP
    return super
  end
  def max_level
    return EngineCRM::Maxlevel if EngineCRM::Maxlevel != 99
    actor.max_level
  end
    def param_base(param_id)  
    @level <= 99 ? self.class.params[param_id, @level] : param_over99(param_id)
  end
  def param_over99(param_id)
    self.class.params[param_id, 99] + EngineCRM::Maxat[class_id][param_id]*@level/EngineCRM::Maxlevel
  end
end