class Flecha
  attr_reader :x, :y, :angulo, :atirando
  def initialize(jogador, janela)
    @jogador, @janela = jogador, janela
    @atirando = false
    @x = (@jogador.pos_x+@jogador.pos_x+@jogador.width)/2
    @y = @jogador.pos_y
    @angulo = @jogador.angulo
    @icon = Gosu::Image.new(@janela, "images/flecha.png", true)
    @beep = Gosu::Sample.new(@janela, "sounds/Beep.wav")
  end
  #Função de atirar
  def atirar
    @atirando = true
    @x = @jogador.pos_x
    @y = @jogador.pos_y
    @angulo=@jogador.angulo
    @x += Gosu::offset_x(@angulo, 20)
    @y += Gosu::offset_y(@angulo, 20)
    @beep.play
  end
  #deleta as flechas fora do Layout
  def deleta_flecha(flechas, jogador)
      if  (Gosu::distance(jogador.pos_x,jogador.pos_y,@x,@y) > 40) then
       flechas.reject! do |fecha| end 
      end
  end
  #Se atirando, faz a flecha sair no angulo do jogador que definimos
  def update    
    if @atirando then
      @angulo=@jogador.angulo
      @x += Gosu::offset_x(@angulo, 20)
      @y += Gosu::offset_y(@angulo, 20) 
      if (@y<0) then 
        @atirando=false 
      end
    else
      @x = @jogador.pos_x
      @y = @jogador.pos_y
      @angulo=@jogador.angulo      
    end
  end
  def atingir_urso
    @atirando = false
  end  
  #desenha a flecha
  def draw
    if (@atirando) then
      @icon.draw_rot(@x, @y,2,@angulo)
    end
  end
end
