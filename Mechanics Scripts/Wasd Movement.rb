#=======================================================
#         Perfect ASDW Move
# Autor: Raizen
# Comunidade: www.centrorpg.com
# O script adciona troca o movimento das setas pelo ASDW, lembrando
# que esse é diferente dos outros, ele faz exatamente a mesma função das setas
#=======================================================


#=======================================================
#========= Aqui começa o script ========================
#=======================================================

$imported = {} if $imported.nil?
$imported[:lune_asdw] = true

class << Input
  def initi
    @asdw_array = Array.new
  end
  def dir4
    @asdw_array.delete(4) unless Input.press?(:X)
    @asdw_array.delete(2) unless Input.press?(:Y)
    @asdw_array.delete(6) unless Input.press?(:Z)
    @asdw_array.delete(8) unless Input.press?(:R)
    @asdw_array << 4 if Input.press?(:X) && !@asdw_array.include?(4)
    @asdw_array << 2 if Input.press?(:Y) && !@asdw_array.include?(2)
    @asdw_array << 6 if Input.press?(:Z) && !@asdw_array.include?(6)
    @asdw_array << 8 if Input.press?(:R) && !@asdw_array.include?(8)
    return @asdw_array.last if @asdw_array.last.is_a?(Integer)
    0
  end
end

Input.initi