{
	"Biblioteca" usada para manipula��o da tela

	Fun��es dispon�veis:
	          escreve,  escreveReverso,  telaInteira,   limpaTela,
	      limpaDialog,     esperaEnter,        canto,       borda,
	textoCentralizado,    textoDireita,   caixaTexto,    confirma,
	          questao,            menu,         info.
}

{
	Escreve um texto na posi��o definida (X, Y) da tela
	Uso: escreve(byte, byte, string)

	1) x: posi��o inicial do texto na posi��o horizontal
	2) y: posi��o inicial do texto na posi��o vertical
	3) texto: texto a ser impresso na tela
}
procedure escreve(x, y: byte; texto: string);
begin
	gotoxy(x, y);
	write(texto);
end;

{
	Escreve um texto na posi��o definida (X, Y) da tela com fundo invertido
	Uso: escreveReverso(byte, byte, string)

	1) x: posi��o inicial do texto na posi��o horizontal
	2) y: posi��o inicial do texto na posi��o vertical
	3) texto: texto a ser impresso na tela
}
procedure escreveReverso(x, y: byte; texto: string);
begin
	textbackground(cor.backReverso);
	textcolor(cor.texto);
	escreve(x, y, texto);
	textbackground(cor.background);
end;

{
	Seleciona a tela toda para impress�o (1, 1, 80, 25)
	Uso: telaInteira
}
procedure telaInteira;
begin
	window(1, 1, 80, 25);
end;

{
	Limpa a tela do programa
	Uso: limpaTela(boolean)

	1) todaTela: define se vai limpar a tela toda
			 true: limpa a tela toda
			false: limpa entre o t�tulo e a barra de status
}
procedure limpaTela(todaTela: boolean);
begin
	if not todaTela then
		window(1, 4, 80, 22);
	textbackground(cor.background);
	clrscr;
	telaInteira;
end;

{
	Limpa uma parte espec�fica da tela
	Uso: limpaDialog(byte, byte, byte, byte)

	1) x: posici��o inicial horizontal a limpar
	2) y: posici��o inicial vertical a limpar
	3) w: tamanho horizontal a limpar
	4) h: tamanho vertical a limpar
}
procedure limpaDialog(x, y, w, h: byte);
begin
	window(x, y, x + w - 1, y + h - 1);
	textbackground(cor.background);
	clrscr;
	telaInteira;
end;

{
	Pausa o programa at� que a tecla enter seja pressionada
	Uso: esperaEnter
}
procedure esperaEnter;
var
	tecla: char;
begin
	repeat
		tecla := readkey;
	until ord(tecla) = 13;
end;

{
	Retorna o caracter ASCII referente a posi��o da borda
	Uso: canto(byte, boolean)
	Retorno: caracter que foi pedido pelo primeiro par�metro

	1) posicao: posi��o da borda
			78888888888889
			4 Cria borda 6
			12222222222223
	2) 	bordaDupla: define se a borda vai ser dupla ou simples
			true: borda dupla
			false: borda simples
}
function canto(posicao: byte; bordaDupla: boolean): char;
begin
	case posicao of
		1:
			if bordaDupla then
				canto := #200
			else
				canto := #192;
		2, 8:
			if bordaDupla then
				canto := #205
			else
				canto := #196;
		3:
			if bordaDupla then
				canto := #188
			else
				canto := #217;
		4, 6:
			if bordaDupla then
				canto := #186
			else
				canto := #179;
		7:
			if bordaDupla then
				canto := #201
			else
				canto := #218;
		9:
			if bordaDupla then
				canto := #187
			else
				canto := #191;
	end;
end;

{
	Desenha uma borda nos tamanhos definidos
	Uso: limpaDialog(byte, byte, byte, byte, byte, boolean)

	1) x: posici��o inicial horizontal da borda
			   0: para centraliza��o horizontal na tela
			1-80: defini��o manual do valor
	2) y: posici��o inicial vertical da borda
			   0: para centraliza��o vertical na tela
			1-80: defini��o manual do valor
	3) w: tamanho horizontal da borda
			Valor m�nimo: 3 (defini��o autom�tica para valores menores)
	4) h: tamanho vertical da borda
			Valor m�nimo: 3 (defini��o autom�tica para valores menores)
	5) c: cor da borda
	6) bordaDupla: define se a borda vai ser dupla ou simples
			 true: borda dupla
			false: borda simples
}
procedure borda(x, y, w, h, c: byte; bordaDupla: boolean);
var
	i: byte;
begin  
	{cursoroff;}
	{ C�lculo da centraliza��o horizontal e vertical na tela }
	if x = 0 then
		x := (80 - w) div 2 + 1;
	if y = 0 then
		y := (25 - h) div 2 + 1;
	{ Defini��o autom�tica caso valor menor que 3 }
	if w < 3 then
		x := 3;
	if h < 3 then
		y := 3;
	limpaDialog(x, y, w, h);
	textcolor(c);
	escreve(x, y, canto(7, bordaDupla));
	{ Desenho da borda }
	for i := 1 to w - 2 do
		write(canto(8, bordaDupla));
	write(canto(9, bordaDupla));
	escreve(x, y + h - 1, canto(1, bordaDupla));
	for i := 1 to w - 2	do
		write(canto(2, bordaDupla));
	write(canto(3, bordaDupla));
	for i := 1 to h - 2 do
	begin
		escreve(x, y + i, canto(4, bordaDupla));
		escreve(x + w - 1, y + i, canto(6, bordaDupla));
	end;
	textcolor(cor.texto);
end;

{
	Escreve um texto centralizando-o num espa�o definido
	Uso: textoCentralizado(byte, byte, byte, byte, string)

	1) x: posici��o inicial horizontal para centraliza��o
			   0: para centraliza��o horizontal na tela
			1-80: defini��o manual do valor
	2) y: posici��o inicial vertical para centraliza��o
			   0: para centraliza��o vertical na tela
			1-80: defini��o manual do valor
	3) w: tamanho horizontal para centraliza��o
	4) h: tamanho vertical para centraliza��o
	5) texto: Texto a ser impresso
}
procedure textoCentralizado(x, y, w, h: byte; texto: string);
var
	cX, cY: byte;
begin
	{ C�lculo da centraliza��o horizontal e vertical na tela }
	if x = 0 then
		x := (80 - w) div 2 + 1;
	if y = 0 then
		y := (25 - h) div 2 + 1;
	{ C�lculo da centraliza��o do texto }
	cX := x + (w - length(texto)) div 2;
	cY := y + (h - 1) div 2;
	escreve(cX, cY, texto);
end;

{
	Escreve um texto alinhando-o a direita
	Uso: textoDireita(byte, byte, string)

	1) x: posici��o final horizontal
			1-80: defini��o manual do valor
	2) y: posici��o final vertical
			1-80: defini��o manual do valor
	3) texto: Texto a ser impresso
}
procedure textoDireita(x, y: byte; texto: string);
begin
	{ C�lculo de onde deve come�ar a impress�o }
	x := x - length(texto);
	{ Se ficar antes da tela ele joga pro come�o da linha }
	if x < 1 then
		x := 1;
	escreve(x, y, texto);
end;

{
	Desenha uma "editbox" para digita��o de algum texto
	Uso: caixaTexto(byte, byte, byte, byte, boolean)

	1) x: posici��o inicial horizontal da "editbox"
			   0: para centraliza��o horizontal na tela
			1-80: defini��o manual do valor
	2) y: posici��o inicial vertical da "editbox"
			   0: para centraliza��o vertical na tela
			1-80: defini��o manual do valor
	3) w: tamanho horizontal da "editbox"
	4) h: tamanho vertical da "editbox"
	5) selecao: define se a "editbox" vai estar selecionada
			 true: "editbox" selecionada
			false: "editbox" n�o selecionada
}
procedure caixaTexto(x, y, w, h: byte; selecao: boolean);
begin
	{ C�lculo da centraliza��o horizontal e vertical na tela }
	if x = 0 then
		x := (80 - w) div 2 + 1;
	if y = 0 then
		y := (25 - h) div 2 + 1;
	window(x, y, x + w - 1, y + h - 1);
	if selecao then
	begin
		textbackground(cor.selecao);
		clrscr;
		{cursoron;}
	end
	else
	begin
		textbackground(cor.backReverso);
		clrscr;
		telaInteira;
		textbackground(cor.background);
	end;
end;

{
	Mostra uma tela de confirma��o com o texto definido
	Uso: confirma(byte, byte, string)
	Retorno: boleano de confirma��o

	1) x: posici��o inicial horizontal da caixa de confirma��o
			   0: para centraliza��o horizontal na tela
			1-80: defini��o manual do valor
	2) y: posici��o inicial vertical da caixa de confirma��o
			   0: para centraliza��o vertical na tela
			1-80: defini��o manual do valor
	3) texto: texto a ser impresso na tela de confirma��o
}
function confirma(x, y: byte; texto: string): boolean;
var
	w, h: byte;
	tecla: char;
	retorno: boolean;
begin
	{ C�lculo do tamanho horizontal da tela de confirma��o }
	w := length(texto) + 4;
	{ Tamanho vertical da tela de confirma��o }
	h := 7;
	{
		C�lculo caso o texto seja menor que o
		tamanho necess�rio para os bot�es de confirma��o
	}
	if w < 18 then
		w := 18;
	{ C�lculo da centraliza��o horizontal e vertical na tela }
	if x = 0 then
		x := (80 - w) div 2 + 1;
	if y = 0 then
		y := (25 - h) div 2 + 1;
	borda(x, y, w, h, cor.borda, false);
	gotoxy(x + 2, y + 2);
	if length(texto) < 18 then
		textoCentralizado(x + 2, y + 2, w - 4, 1, texto)
	else
		write(texto);
	{ Manipula��o das teclas para ficar movimentando entre o OK e o Cancelar }
	retorno := true;
	repeat
		gotoxy(x + 2, y + h - 2);
		if retorno then
			textcolor(cor.texto)
		else
			textcolor(cor.selecao);
		write('Cancelar');
		gotoxy(x + w - 4, y + h - 2);
		if retorno then
			textcolor(cor.selecao)
		else
			textcolor(cor.texto);
		write('OK');
		tecla := readkey;
		case tecla of
			'K': { Seta para a esquerda }
				retorno := false;
			'M': { Seta para a direita }
				retorno := true;
			#27: { ESC }
				retorno := false;
		end;
	until (ord(tecla) = 13) or (ord(tecla) = 27);
	confirma := retorno;
	limpaDialog(x, y, w, h);
end;

{
	Mostra uma tela de pergunta para digita��o de um texto
	Uso: questao(byte, byte, string)
	Retorno: string com o texto digitado

	1) x: posici��o inicial horizontal da caixa de pergunta
			   0: para centraliza��o horizontal na tela
			1-80: defini��o manual do valor
	2) y: posici��o inicial vertical da caixa de pergunta
			   0: para centraliza��o vertical na tela
			1-80: defini��o manual do valor
	3) texto: texto a ser impresso na caixa de pergunta
}
function questao(x, y: byte; texto: string): string;
var
	w, h: byte;
	retorno: string;
begin
	{ C�lculo do tamanho horizontal da tela de confirma��o }
	w := length(texto) + 4;
	{ Tamanho vertical da tela de confirma��o }
	h := 8;
	{
		C�lculo caso o texto seja menor que o
		tamanho necess�rio para os bot�es de confirma��o
	}
	if w < 18 then
		w := 18;
	{ C�lculo da centraliza��o horizontal e vertical na tela }
	if x = 0 then
		x := (80 - w) div 2 + 1;
	if y = 0 then
		y := (25 - h) div 2 + 1;
	borda(x, y, w, h, cor.borda, false);
	textoCentralizado(x + 2, y + 2, w - 4, 1, texto);
	caixaTexto(x + 2, y + h - 3, w - 4, 1, true);
	readln(retorno);
	questao := retorno;
	{cursoroff;}
	textbackground(cor.background);
	limpaDialog(x, y, w, h);
end;

{
	Mostra uma menu para sele��o de uma op��o
	Uso: menu(byte, byte, byte, byte, array of string)
	Retorno: n�mero da op��o selecionada

	1) x: posici��o inicial horizontal do menu
			   0: para centraliza��o horizontal na tela
			1-80: defini��o manual do valor
	2) y: posici��o inicial vertical do menu
			   0: para centraliza��o vertical na tela
			1-80: defini��o manual do valor
	3) tamanho: n�mero de itens no vetor de itens
	4) bordaDupla: define se o menu vai ter borda dupla ou simples
			 true: borda dupla
			false: borda simples
	5) item: vetor com os itens a serem usados no menu
}
function menu(x, y, tamanho: byte; bordaDupla: boolean; item: array of string): byte;
var
	i, maiorTamanho, w, h, retorno: byte;
	tecla: char;
begin
	{
		C�lculo do tamanho horizontal do menu
		pegando o tamanho do maior item
	}
	maiorTamanho := 0;
	for i := 1 to tamanho do
		if length(item[i-1]) > maiorTamanho then
			maiorTamanho := length(item[i-1]);
	w := maiorTamanho + 4;
	{ C�lculo do tamanho vertical do menu }
	h := tamanho + 2;
	{ C�lculo da centraliza��o horizontal e vertical na tela }
	if x = 0 then
		x := (80 - w) div 2 + 1;
	if y = 0 then
		y := (25 - h) div 2 + 1;
	borda(x, y, w, h, cor.borda, bordaDupla);
	{ Manipula��o das teclas para ficar movimentando entre os itens do menu }
	retorno := 1;
	repeat
		for i := 1 to tamanho do
		begin
			if retorno = i then
				textcolor(cor.selecao)
			else
				textcolor(cor.texto);
			textoCentralizado(x, y + i, w, 1, item[i-1]);
		end;
		tecla := readkey;
		case tecla of
			'H': { Seta para cima }
				if retorno = 1 then
					retorno := tamanho
				else
					dec(retorno);
			'P': { Seta para baixo }
				if retorno = tamanho then
					retorno := 1
				else
					inc(retorno);
			#27: { ESC }
				retorno := tamanho;
		end;
	until (ord(tecla) = 13) or (ord(tecla) = 27);
	menu := retorno;
	limpaDialog(x, y, w, h);
end;

{
	Mostra uma tela informa��o com um texto definido
	Uso: info(byte, byte, boolean, string)
	Retorno: string com o texto digitado

	1) x: posici��o inicial horizontal da caixa de informa��o
			   0: para centraliza��o horizontal na tela
			1-80: defini��o manual do valor
	2) y: posici��o inicial vertical da caixa de informa��o
			   0: para centraliza��o vertical na tela
			1-80: defini��o manual do valor
	3) texto: texto a ser impresso na caixa de informa��o
}
procedure info(x, y: byte; bordaDupla: boolean; texto: string);
var
	w, h: byte;
begin
	{ C�lculo do tamanho horizontal da caixa de informa��o }
	w := length(texto) + 4;
	{ Tamanho vertical da caixa de informa��o }
	h := 3;
	borda(x, y, w, h, cor.borda, bordaDupla);
	textcolor(cor.texto);
	textoCentralizado(x, y, w, h, texto);
	esperaEnter;
	limpaDialog(x, y, w, h);
end;