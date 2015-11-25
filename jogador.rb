require 'gosu'

class Jogador 
  attr_accessor :placar, :lives, :angulo #o que pode ser modificado pelas classes
  attr_reader :pos_x, :pos_y #o que pode ser somente lido pelas classes
  def initialize (janela)
    @janela = janela
    @imagem = Gosu::Image.new(@janela,"images/jogador.png",true)
    @pos_x = @janela.width/2
    @pos_y = @janela.height/2
    @vel_x = 0
    @vel_y = 0
    @angulo = 0.0
    @placar = 0
    @lives = 3
    @lives_img =Gosu::Image.new(@janela, 'images/3lives.png', true)
  end 

  def reset
    @lives = 10, @janela.height/2, 3
  end
  #update das lives do jogador
  def update
    if @lives == 3 then @lives_img =Gosu::Image.new(@janela, 'images/3lives.png', true)
    elsif @lives == 2 then @lives_img =Gosu::Image.new(@janela, 'images/2lives.png', true)
    elsif @lives == 1 then @lives_img =Gosu::Image.new(@janela, 'images/1lives.png', true)
    end
  end

  #movimentos
  def girar_direita
    @angulo += 3.0
  end
  def girar_esquerda
    @angulo -= 3.0
  end
  def acelerar
    @vel_x += Gosu::offset_x(@angulo, 0.3)
    @vel_y += Gosu::offset_y(@angulo, 0.3)
  end
  def desacelerar
    @vel_x -= Gosu::offset_x(@angulo, 0.3)
    @vel_y -= Gosu::offset_y(@angulo, 0.3)
  end
  def mover
    @pos_x += @vel_x
    @pos_y += @vel_y
    @pos_x %= 1024
    @pos_y %= 600
    @vel_x *= 0.95
    @vel_y *= 0.95
  end

  def width
    return @imagem.width
  end

  #jogador morrer
  def morrer(ursos)
    for urso in ursos do
      if ((@pos_x - 30 >= urso.x) and (@pos_x - 30 <= (urso.x + 140))) or ((@pos_x + 30 >= urso.x) and (@pos_x + 30 <= (urso.x + 140))) then
        if ((@pos_y - 30 >= urso.y) and (@pos_y - 30 <= (urso.y + 170))) or ((@pos_y + 30 >= urso.y) and (@pos_y + 30 <= (urso.y + 140))) then
          @lives -= 1
          return "JOGANDO"
        end
        if @lives <= 0 then 
        @lives = 0 
        return "FIM"
        end  
      end      
    end
    return "JOGANDO"
  end

  def draw
    @imagem.draw_rot(@pos_x,@pos_y,5,@angulo)
    @lives_img.draw(10,40,3)
  end
end 

