$LOAD_PATH << '.'

require 'gosu'
require 'jogador'
require 'flecha'
require 'urso'

class Jogo01 < Gosu::Window
  @@formato = [3, 1.0, 1.0, 0xff1a1757]  #acessado na mensagem de fim

  def initialize 
    super(1024,600,false)
    self.caption = "Female Killer"
    @imagem_fundo = Gosu::Image.new(self, "images/grama.gif", true)
    @pos_x_background = 0
    @aux = 0
    @jogador = Jogador.new(self)
    @urso = Array.new
    @flecha = Array.new
    @font = Gosu::Font.new(self, Gosu::default_font_name, 30)
    @estado = "INICIO"
    @imagem_nome = Gosu::Image.new(self, "images/female.png", true)
    @imagem_menu = Gosu::Image.new(self, "images/bravep.png", true)
    @start = Gosu::Image.new(self, "images/Start.png", true)
    @restart = Gosu::Image.new(self, "images/Restart.png", true)
    @cursor = Gosu::Image.new(self, "images/cursor.png",true)

    #cria flecha
    for i in 0..10 do
      @flecha << Flecha.new(@jogador, self)
    end
    #cria urso
    for i in 0..5 do
      @urso << Urso.new(self)
    end
  end 

  def draw
    @imagem_fundo.draw(@pos_x_background,0,0)
    if    @estado == "INICIO"  then draw_inicio
    elsif @estado == "JOGANDO" then draw_jogando
    elsif @estado == "FIM" then draw_fim 
    end
  end
  
  def draw_inicio
    @imagem_nome.draw(90,-90,1)
    @imagem_menu.draw(-60,0,0)
    @cursor.draw(mouse_x, mouse_y, 2)
    @start.draw(353,250,1) #posição da imagem
  end

  def draw_jogando
    @jogador.draw()
    for urso in @urso do
      urso.draw
    end
    for flecha in @flecha do
    flecha.draw()
    end 
    @font.draw("Placar: #{@jogador.placar}", 10, 10, 3, 1.0, 1.0, 0xffff4500) #desenhando o placar no jogo
  end

  def draw_fim
    @imagem_menu.draw(0,0,0)
    @cursor.draw(mouse_x, mouse_y, 2)
    @restart.draw(353,250,1) #posição da imagem
    msg = "FIM DE JOGO, VOCE FEZ #{@jogador.placar} PONTOS"
    x = self.width / 2 - @font.text_width(msg,1) / 2
    @font.draw(msg, x, self.height/4, *@@formato)
  end

  def update    
    if @estado =="JOGANDO" then update_jogando end
  end

  def update_jogando
    if ( button_down?(Gosu::Button::KbRight) ) then
      @jogador.girar_direita
    end 
    if ( button_down?(Gosu::Button::KbLeft) ) then
      @jogador.girar_esquerda
    end 
    if ( button_down?(Gosu::Button::KbUp) ) then
      @jogador.acelerar
      @aux = @aux+1
    end 
    if (button_down?(Gosu::Button::KbDown)) then
      @jogador.desacelerar
      @aux = @aux+1
    end
    if (button_down?(Gosu::Button::KbSpace)) then
      for flecha in @flecha do
        flecha.atirar
        flecha.deleta_flecha(@flecha, @jogador)
      end
    end
    @jogador.update
    
    #movimenta o background
    if (@aux >= 1) then
      @pos_x_background = @pos_x_background - 5
      if(@pos_x_background<(-1024))then 
        @pos_x_background = 0 
      end
    end
    #cria novos ursos
    if (rand(20) < 10 && @urso.size < 5) then
      @urso.push(Urso.new(self))
    end

    for i in 0..@urso.size-1 do 
      @urso[i].update(@flecha,@jogador,@urso) unless @urso[i].nil?
    end
    for flecha in @flecha do
      flecha.update
    end
    @jogador.mover
    @estado = @jogador.morrer(@urso)
  end

  #checar estado final, e return ao jogo caso o restart esteja pressed
  def button_up(id)
    if @estado == "INICIO"
      if (mouse_x > 353) && (mouse_x < 671) && (mouse_y > 250) && (mouse_y < 344) && (id == Gosu::MsLeft)
        @estado = "JOGANDO"
      end
    end
    if @estado == "FIM"
      if (mouse_x > 353) && (mouse_x < 671) && (mouse_y > 250) && (mouse_y < 344) && (id == Gosu::MsLeft)
        @estado = "JOGANDO"
        zerar_valores
      end
    end
  end

  def zerar_valores  
    @aux = 0
    @flecha = Array.new
    @jogador.lives = 0

    @jogador.placar = 0
    @urso = Array.new  
    @jogador = Jogador.new(self)  
    @jogador.angulo = 0.0
    for i in 0..10 do
      @flecha << Flecha.new(@jogador, self)
    end
    #cria urso
    for i in 0..5 do
      @urso << Urso.new(self)
    end
  end
end