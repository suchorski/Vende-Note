{
	"Biblioteca" com os módulos do programa

	Funções disponíveis:
	incluir,      editar,  excluir, consultar,
	  venda,  relatorios,    sobre.
}

{ Módulo de inclusão }
procedure incluir;
var
	i: registros;
begin
	desenhaRegistro(false);
	{ Chama a função manipulando todas as linhas do registro }
	for i := CODIGOREG to PRECOREG do
		manipulaRegistro(i);
	{ Termina a inclusão dos registros de venda }
	regNote.status := #32;
	regNote.vendidos := 0;
	regNote.ultimaVenda := '**/**/****';
	{ Confirma se a inclusão está certa }
	if confirma(56, 0, 'Confirma os dados?') then
	begin
		seek(arqNote, filesize(arqNote));
		write(arqNote, regNote);
	end;
end;

{ Módulo de alteração }
procedure editar;
var
	codigo: string;
	menuSel: byte;
begin
	status(false, 'Modulo de alteracao de notebooks do sistema.');
	{ Salva o código para busca e consistência }
	codigo := questao(0, 0, 'Digite o codigo para alterar:');
	caixaAlta(codigo);
	{ Testa a consistência do código }
	if not consisteCodigo(codigo) then
		info(0, 0, false, 'Codigo invalido.')
	{ Busca pelo código no banco de dados }
	else if busca(codigo) then
	begin
		preencheRegistro(true);
		repeat
			preencheMenu(ALTERAR, menuItens);
			menuSel := menu(59, 0, 8, false, menuItens);
			case menuSel of
				1: manipulaRegistro(MARCAREG);
				2: manipulaRegistro(MODELOREG);
				3: manipulaRegistro(PROCESSADORREG);
				4: manipulaRegistro(MEMORIAREG);
				5: manipulaRegistro(TELAREG);
				6: manipulaRegistro(ESTOQUEREG);
				7: manipulaRegistro(PRECOREG);
			end;
		until menuSel = 8;
		write(arqNote, regNote);
	end
	else
		info(0, 0, false, 'Registro nao encontrado.');
end;

{ Módulo de exclusão }
procedure excluir;
var
	codigo: string;
begin
	status(false, 'Modulo de exclusao de notebooks do sistema.');
	{ Salva o código para busca e consistência }
	codigo := questao(0, 0, 'Digite o codigo para excluir:');
	caixaAlta(codigo);
	{ Testa a consistência do código }
	if not consisteCodigo(codigo) then
		info(0, 0, false, 'Codigo invalido.')
	{ Busca pelo código no banco de dados }
	else if busca(codigo) then
	begin
		preencheRegistro(true);
		if confirma(56, 0, 'Excluir registro?') then
		begin
			regNote.status := '*';
			write(arqNote, regNote);
			limpaTela(false);
			info(0, 0, false, 'Registro excluido com sucesso.');
		end;
	end
	else
		info(0, 0, false, 'Registro nao encontrado.');
end;

{ Módulo de consulta }
procedure consultar;
var
	codigo: string;
begin
	status(false, 'Modulo de consulta de notebooks no sistema.');
	{ Salva o código para busca e consistência }
	codigo := questao(0, 0, 'Digite o codigo para consultar:');
	caixaAlta(codigo);
	{ Testa a consistência do código }
	if not consisteCodigo(codigo) then
		info(0, 0, false, 'Codigo invalido.')
	{ Busca pelo código no banco de dados }
	else if busca(codigo) then
	begin
		preencheRegistro(true);
		info(53, 19, false, 'Pressione ' + #17 + #217 + ' para sair.');
	end
	else
		info(0, 0, false, 'Registro nao encontrado.');
end;

{ Módulo de venda }
procedure venda;
var
	codigo: string;
	temp: string;
	vendidosTemp: word;
	consisteVenda: boolean;
begin
	status(false, 'Modulo de inclusao de vendas no sistema.');
	{ Salva o código para busca e consistência }
	codigo := questao(0, 0, 'Digite o codigo do notebook:');
	caixaAlta(codigo);
	{ Testa a consistência do código }
	if not consisteCodigo(codigo) then
		info(0, 0, false, 'Codigo invalido.')
	{ Busca pelo código no banco de dados }
	else if busca(codigo) then
	begin
		{ Verifica se existe o notebook em estoque }
		if regNote.estoque = 0 then
			info(0, 0, false, 'Sem produto em estoque para venda.')
		else
		begin
			consisteVenda := false;
			repeat
				{ Salva e consiste o número de vendas }
				temp := questao(0, 0, 'Quantos notebooks foram vendidos?');
				if natural(temp) then
				begin
					vendidosTemp := paraWord(temp);
					{ Verifica disponibilidade em estoque }
					if vendidosTemp > regNote.estoque then
					begin
						status(true, 'A quantidade nao pode ser maior que a do estoque.');
						str(regNote.estoque, temp);
						info(0, 0, false, 'Quantidade em estoque: ' + temp);
					end
					else
					begin
						{ Tira do estoque e coloca em vendidos }
						dec(regNote.estoque, vendidosTemp);
						inc(regNote.vendidos, vendidosTemp);
						status(false, 'Digite a data da ultima venda no formato "DD/MM/AAAA".');
						repeat
							{ Salva data da última venda }
							temp := questao(0, 0, 'Data da ultima venda:');
							{ Consiste se a data é válida }
							if not consisteData(temp) then
								status(true, 'Data invalida. (Formato: "DD/MM/AAAA")');
						until consisteData(temp);
						regNote.ultimaVenda := temp;
						status(false, 'Modulo de inclusao de vendas no sistema.');
						{ Confirma se a venda está correta  }
						if confirma(0, 0, 'Confirma a venda do produto?') then
						begin
							write(arqNote, regNote);
							info(0, 0, false, 'Venda cadastrada.');
						end
						else
							info(0, 0, false, 'Venda nao cadastrada.');
						consisteVenda := true;
					end;
				end
				else
					status(true, 'A quantidade precisa ser um numero inteiro maior que 0.');
			until (consisteVenda);
		end;
	end
	else
		info(0, 0, false, 'Registro nao encontrado.');
end;

{ Módulo de relatórios }
procedure relatorios;
var
	menuSel: byte;
begin
	preencheMenu(RELATORIO, menuItens);
	repeat
		status(false, 'Modulo de geracao de relatorios.');
		menuSel := menu(0, 0, 4, false, menuItens);
		case menuSel of
			1: geraRelatorio(SIMPLES);
			2: geraRelatorio(ESTOQUES);
			3: geraRelatorio(VENDAS);
		end;
	until menuSel = 4;
end;

{ Módulo de informação do programa }
procedure sobre;
var
	texto: array[1..11] of string;
	x, y, i, j, maior: word;
begin
	{ Texto para efeito na tela }
	texto[1] := 'Auto Instrucional';
	texto[2] := 'Materia: Linguagem e Tecnicas de Programacao II';
	texto[3] := 'Professor: Air Rabelo';
	texto[4] := 'Universidade: FUMEC';
	texto[5] := ' ';
	texto[6] := 'Alunos: Thiago Bastos Suchorski';
	texto[7] := '        Rodrigo Braga Pessanha';
	texto[8] := '        César Augusto Santos Oliveira';
	texto[9] := '        Vitor de Oliveira Castanheira';
	texto[10] := ' ';
	texto[11] := 'Sistema de Vendas ' + #184 + ' VENDENOTE 2012';
	limpatela(true);
	{ Cálculo do maior texto do vetor }
	maior := 0;
	for i := low(texto) to high(texto) do
	begin
		if length(texto[i]) > maior then
			maior := length(texto[i]);
	end;
	{ Posições (X, Y) do primeiro texto do vetor na tela }
	x := 78;
	y := 12;
	{cursoroff;}
	{ Efeito de transição da direita para a esquerda }
	for i := 1 to maior do
	begin
		for j := low(texto) to high(texto) do
		begin
			if i <= length(texto[j]) then
				escreve(x, y + j - 1, copy(texto[j], 1, i) + ' ');
		end;
		delay(70);
		dec(x);
	end;
	info(0, 23, false, 'Pressione ' + #17 + #217 + ' para prosseguir.');
	limpadialog(1, 23, 79, 3);
	gotoxy(1, 25);
	{ Efeito de transição de baixo para cima }
	for i := 1 to 25 do
	begin
		writeln;
		delay(100);
	end;
end;