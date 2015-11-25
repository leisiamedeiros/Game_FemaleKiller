class Urso
  attr_reader :x, :y, :ativa
  def initialize(janela)
    @janela = janela
    @icon = Gosu::Image.new(@janela, 'images/monstro.png', true)
    @icon_explosao = Gosu::Image.new(@janela, 'images/explosao.png', true)

    #lado aleatório em que vai ser criado o urso.
    lado = rand(4)+1
      if (lado==2) then
        @x=rand(@janela.width)
        @y= 0
      elsif (lado==3) then
        @x=@janela.width
        @y=rand(janela.height)
      else
        @x=rand(janela.width)
        @y=@janela.height
      end
    @atingida = false
  end

  def atingida?
    return @atingida
  end 

  def update(flechas,jogador,ursos) #no urso
    mover(jogador)
    for flecha in flechas do
        #verifica em que ponto a flecha atinge o urso
        if ((flecha.x - 30 >= @x) and (flecha.x - 30 <= (@x + 140))) or ((flecha.x + 30 >= @x) and (flecha.x + 30 <= (@x + 140))) then
          if ((flecha.y - 30 >= @y) and (flecha.y - 30 <= (@y + 170))) or ((flecha.y + 30 >= @y) and (flecha.y + 30 <= (@y + 140))) and flecha.atirando == true then
           jogador.placar += 10 unless @atingida
           @atingida = true
           flecha.atingir_urso
           ursos.delete(self)
         end
       end
    end
  end

  #faz o urso mover-se atras do jogador
  def mover(jogador)
    mover_x = jogador.pos_x-@x
    mover_y = jogador.pos_y-@y
    @x=@x+(mover_x/300)
    @y=@y+(mover_y/300) 
  end

  #desenha o icon blood caso o urso seja atingido
  def draw
    if (atingida?) then
      @icon_explosao.draw(@x, @y, 4)
    else
      @icon.draw(@x, @y, 3)
    end
  end  
end
