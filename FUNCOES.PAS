{
	"Biblioteca" com os funções de manipulação interna

	Funções disponíveis:
	     preencheMenu,         caixaAlta,          paraByte,        paraWord,
	         paraReal,             busca,            status,  consisteCodigo,
	  consisteMemoria,           natural,     consistePreco,    consisteData,
	  desenhaRegistro,  preencheRegistro,  manipulaRegistro,   desenhaTabela,
	preencheRelatorio,     geraRelatorio.
}

{
	Preenche um vetor de string com o menu escolhido
	Uso: preencheMenu(menu, array of string)

	1) m: tipo do menu
	2) item: vetor a ser preenchido
}
procedure preencheMenu(m: menus; var item: array of string);
begin
	case m of
		PRINCIPAL:
			begin
				item[0] := 'Incluir';
				item[1] := 'Alterar';
				item[2] := 'Excluir';
				item[3] := 'Consultar';
				item[4] := 'Venda';
				item[5] := 'Relatorio';
				item[6] := 'Sobre';
				item[7] := 'Finalizar';
			end;
		MARCA:
			begin
				item[0] := 'Dell';
				item[1] := 'Lenovo';
				item[2] := 'HP';
				item[3] := 'Positivo';
				item[4] := 'Asus';
			end;
		PROCESSADOR:
			begin
				item[0] := 'Intel Core i3';
				item[1] := 'Intel Core i5';
				item[2] := 'Intel Core i7';
				item[3] := 'AMD Phenom II X6';
				item[4] := 'AMD Bulldozer FX';
			end;
		TELA:
			begin
				item[0] := '12"';
				item[1] := '13"';
				item[2] := '14"';
				item[3] := '15"';
				item[4] := '17"';
			end;
		ALTERAR:
			begin
				item[0] := 'Marca';
				item[1] := 'Modelo';
				item[2] := 'Processador';
				item[3] := 'Memoria';
				item[4] := 'Tela';
				item[5] := 'Estoque';
				item[6] := 'Preco';
				item[7] := 'Finalizar';
			end;
		RELATORIO:
			begin
				item[0] := 'Listar pelo codigo';
				item[1] := 'Listar estoque';
				item[2] := 'Listar vendidos';
				item[3] := 'Finalizar';
			end;
	end;
end;

{
	Converte uma string para caixa alta
	Uso: caixaAlta(string)

	1) texto: texto a ser escrito em caixa alta
}
procedure caixaAlta(var texto: string);
var
	i: byte;
begin
	if length(texto) > 0 then
		for i := low(texto) to high(texto) do
			texto[i] := upcase(texto[i]);
end;

{
	Converte uma string para byte
	Uso: paraByte(string)
	Retorno: byte caso tenha sucesso na conversão

	1) valor: texto a ser convertido para byte
}
function paraByte(valor: string): byte;
var
	z: integer;
	retorno: byte;
begin
	val(valor, retorno, z);
	if z = 0 then
		paraByte := retorno;
end;

{
	Converte uma string para word
	Uso: paraByte(string)
	Retorno: word caso tenha sucesso na conversão

	1) valor: texto a ser convertido para word
}
function paraWord(valor: string): word;
var
	z: integer;
	retorno: word;
begin
	val(valor, retorno, z);
	if z = 0 then
		paraWord := retorno;
end;

{
	Converte uma string para real
	Uso: paraByte(string)
	Retorno: real caso tenha sucesso na conversão

	1) valor: texto a ser convertido para real
}
function paraReal(valor: string): real;
var
	z: integer;
	retorno: real;
begin
	val(valor, retorno, z);
	if z = 0 then
		paraReal := retorno;
end;

{
	Busca um código no banco de dados
		e posiciona o ponteiro no item encontrado
		salvando os dados na variável global regNote
	Uso: busca(string)
	Retorno: boleano caso encontre o código

	1) codigoBusca: código para buscar no banco de dados
}
function busca(codigoBusca: string): boolean;
begin
	busca := false;
	seek(arqNote, 0);
	while not eof(arqNote) do
	begin
		read(arqNote, regNote);
		with regNote do
		begin
			if (status <> '*') and (codigo = codigoBusca) then
			begin
				busca := true;
				seek(arqNote, filepos(arqNote) - 1);
				break;
			end;
		end;
	end;
end;

{
	Atualiza a barra de status do programa
	Uso: status(boolean, string)

	1) erro: valor boleano caso seja o status de erro
			 true: borda de erro (registro de cor.bordaErro)
			false: borda normal (registro de cor.bordaOK)
	2) texto: texto a ser escrito no status
}
procedure status(erro: boolean; texto: string);
var
	c: byte;
begin
	if erro then
		c := cor.bordaErro
	else
		c := cor.bordaOK;
	borda(0, 23, 78, 3, c, false);
	textoCentralizado(0, 23, 78, 3, texto);
end;

{
	Consiste se o código é válido
		Código precisa ter 6 caracteres de A a Z ou 0 a 9
	Uso: consisteCodigo(string)
	Retorno: boleano caso o código seja válido

	1) codigo: código para verificação de consistência
}
function consisteCodigo(codigo: string): boolean;
var
	i: byte;
begin
	consisteCodigo := true;
	if length(codigo) <> 6 then
		consisteCodigo := false;
	for i := 1 to 6 do
		if not (codigo[i] in ['A'..'Z', '0'..'9']) then
		begin
			consisteCodigo := false;
			break;
		end;
end;

{
	Consiste se a memória é válida
		A memória precisa estar entre 1 e 16
	Uso: consisteMemoria(string)
	Retorno: boleano caso a memória seja válida

	1) texto: valor da memória para verificação de consistência
}
function consisteMemoria(texto: string): boolean;
var
	memoria: integer;
	z: integer;
begin
	consisteMemoria := true;
	val(texto, memoria, z);
	if z > 0 then
		consisteMemoria := false;
	if (memoria < 1) or (memoria > 16) then
		consisteMemoria := false
end;

{
	Consiste se o texto é um número maior que zero
	Uso: natural(string)
	Retorno: boleano caso a número seja válido

	1) texto: número para verificação de consistência
}
function natural(texto: string): boolean;
var
	quantidade: integer;
	z: integer;
begin
	natural := true;
	val(texto, quantidade, z);
	if (z > 0) or (quantidade < 1) then
		natural := false;
end;

{
	Consiste se a preço é válido
		O preço precisa ser entre 500 e 10 mil reais
	Uso: consistePreco(string)
	Retorno: boleano caso a preço seja válido

	1) texto: preço para verificação de consistência
}
function consistePreco(texto: string): boolean;
var
	preco: real;
	z: integer;
begin
	consistePreco := true;
	val(texto, preco, z);
	if z > 0 then
		consistePreco := false;
	if (preco < 500) or (preco > 10000) then
		consistePreco := false
end;

{
	Consiste se a data é válida
		Data precisa estar no formato DD/MM/AAAA
	Uso: consisteData(string)
	Retorno: boleano caso a memória seja válida

	1) texto: data para verificação de consistência
}
function consisteData(data: string): boolean;
var
	dia, mes, ano: word;
begin
	consisteData := false;
	{ Consistência do formato: DD/MM/AAAA }
	if (length(data) = 10) and (data[3] = '/') and (data[6] = '/') then
	begin
		{ Verifica se os 3 valores são números e maiores que zero }
		if (natural(copy(data, 1, 2))) and (natural(copy(data, 4, 2))) and (natural(copy(data, 7, 4))) then
		begin
			dia := paraWord(copy(data, 1, 2));
			mes := paraWord(copy(data, 4, 2));
			ano := paraWord(copy(data, 7, 4));
			{ Consistência do valor do mês }
			if mes <= 12 then
			begin
				{ Consistência dos meses de 30 dias }
				if ((mes = 4) OR (mes = 6) OR (mes = 9) OR (mes = 11)) AND (dia <= 30) then
					consisteData := true
				{ Consistência do mês de fevereiro }
				else if mes = 2 then
				begin
					{ Consistência de fevereiro dos anos bissextos }
					if ((ano mod 400 = 0) or ((ano mod 4 = 0) and (ano mod 100 <> 0))) and (dia <= 29) then
						consisteData := true
					{ Consistência de fevereiro dos anos não bissextos }
					else if dia <= 28 then
						consisteData := true;
				end
				{ Consistência dos meses de 31 dias }
				else if dia <= 31 then
					consisteData := true;
			end;
		end;
	end;
end;

{
	Desenha a tela de registro
	Uso: desenhaRegistro(boolean)

	1) alterar: valor boleano que diz se a tela é de inclusão ou de alteração
			 true: tela de alteração
			false: tela de inclusão
}
procedure desenhaRegistro(alterar: boolean);
begin
	borda(1, 4, 80, 19, cor.borda, false);
	textoDireita(17, 6, 'Codigo:');
	caixaTexto(18, 6, 34, 1, false);
	textoDireita(17, 8, 'Marca:');
	caixaTexto(18, 8, 34, 1, false);
	textoDireita(17, 10, 'Modelo:');
	caixaTexto(18, 10, 34, 1, false);
	textoDireita(17, 12, 'Processador:');
	caixaTexto(18, 12, 34, 1, false);
	textoDireita(17, 14, 'Memoria:');
	caixaTexto(18, 14, 12, 1, false);
	textoDireita(39, 14, 'Tela:');
	caixaTexto(40, 14, 12, 1, false);
	textoDireita(17, 16, 'Estoque:');
	caixaTexto(18, 16, 12, 1, false);
	textoDireita(39, 16, 'Preco:');
	caixaTexto(40, 16, 12, 1, false);
	if alterar then
	begin
		textoDireita(17, 18, 'Ultima venda:');
		caixaTexto(18, 18, 12, 1, false);
		textoDireita(39, 18, 'Vendas:');
		caixaTexto(40, 18, 12, 1, false);
	end;
	textbackground(cor.backreverso);
	textoDireita(23, 14, 'GB');
	escreve(40, 16, 'R$');
	textbackground(cor.backreverso);
end;

{
	Preenche a tela de registro
	Uso: preencheRegistro(boolean)

	1) alterar: valor boleano que diz se a tela é de inclusão ou de alteração
			 true: preenche tela de alteração
			false: preenche tela de inclusão
}
procedure preencheRegistro(alterar: boolean);
var
	temp: string;
begin
	desenhaRegistro(alterar);
	with regNote do
	begin
		escreveReverso(18, 6, codigo);
		escreveReverso(18, 8, marca);
		escreveReverso(18, 10, modelo);
		escreveReverso(18, 12, processador);
		str(memoria, temp);
		escreveReverso(18, 14, temp);
		escreveReverso(40, 14, tela);
		str(estoque, temp);
		escreveReverso(18, 16, temp);
		str(preco:0:2, temp);
		escreveReverso(43, 16, temp);
		if alterar then
		begin
			escreveReverso(18, 18, ultimaVenda);
			str(vendidos, temp);
			escreveReverso(40, 18, temp); 
		end;
	end;
end;

{
	Manipula cada linha do registro de inclusão ou alteração
		Variável global regNote usada para salvar os dados manipulados
	Uso: manipulaRegistro(registros)

	1) r: enumerador do registro a ser manipulado
			registros = (
					CODIGOREG, MARCAREG, MODELOREG, PROCESSADORREG,
					MEMORIAREG, TELAREG, ESTOQUEREG, PRECOREG
				);
}
procedure manipulaRegistro(r: registros);
var
	menuSel: byte;
	temp: string;
begin
	case r of
		CODIGOREG:
			begin
				status(false, 'O codigo precisa ter 6 caracteres de "A" a "Z" ou "0" a "9".');
				repeat
					caixaTexto(18, 6, 34, 1, true);
					readln(temp);
					caixaAlta(temp);
					if consisteCodigo(temp) then
					begin
						if busca(temp) then
							status(true, 'Codigo existente.')
					end
					else
					begin
						status(true, 'Codigo invalido.');
					end;
				until (consisteCodigo(temp)) and not (busca(temp));
				caixaTexto(18, 6, 34, 1, false);
				escreveReverso(18, 6, temp);
				regNote.codigo := temp;
			end;
		MARCAREG:
			begin
				status(false, 'Selecione a marca no menu ao lado.');
				caixaTexto(18, 8, 34, 1, true);
				telaInteira;
				preencheMenu(MARCA, menuItens);
				menuSel := menu(54, 8, 5, false, menuItens);
				caixaTexto(18, 8, 34, 1, false);
				escreveReverso(18, 8, menuItens[menuSel]);
				regNote.marca := menuItens[menuSel];
			end;
		MODELOREG:
			begin
				status(false, 'Digite o modelo.');
				repeat
					caixaTexto(18, 10, 34, 1, true);
					readln(temp);
					if (length(temp) = 0)  or (length(temp) > 20) then
						status(true, 'O modelo nao pode ser em branco ou com mais de 20 caracteres.');
				until (length(temp) > 0) and (length(temp) < 20);
				caixaTexto(18, 10, 34, 1, false);
				escreveReverso(18, 10, temp);
				regNote.modelo := temp;
			end;
		PROCESSADORREG:
			begin
				status(false, 'Selecione o processador no menu ao lado.');
				caixaTexto(18, 12, 34, 1, true);
				telaInteira;
				preencheMenu(PROCESSADOR, menuItens);
				menuSel := menu(54, 12, 5, false, menuItens);
				caixaTexto(18, 12, 34, 1, false);
				escreveReverso(18, 12, menuItens[menuSel]);
				regnote.processador := menuItens[menuSel];
			end;
		MEMORIAREG:
			begin
				status(false, 'Digite a quantidade de memoria.');
				repeat
					caixaTexto(18, 14, 12, 1, true);
					textoDireita(6, 1, 'GB');
					gotoxy(1, 1);
					window(18, 14, 20, 14);
					readln(temp);
					if not consisteMemoria(temp) then
						status(true, 'A memoria precisa ser de 1 a 16 GB.');
				until consisteMemoria(temp);
				caixaTexto(18, 14, 12, 1, false);
				escreveReverso(18, 14, temp);
				escreveReverso(21, 14, 'GB');
				regNote.memoria := paraByte(temp);
			end;
		TELAREG:
			begin
				status(false, 'Selecione o tamanho da tela no menu ao lado.');
				caixaTexto(40, 14, 12, 1, true);
				telaInteira;
				preencheMenu(TELA, menuItens);
				menuSel := menu(54, 14, 5, false, menuItens);
				caixaTexto(40, 14, 12, 1, false);
				escreveReverso(40, 14, menuItens[menuSel]);
				regNote.tela := menuItens[menuSel];
			end;
		ESTOQUEREG:
			begin
				status(false, 'Digite a quantidade de notebooks em estoque.');
				repeat
					caixaTexto(18, 16, 12, 1, true);
					readln(temp);
					if not natural(temp) then
						status(true, 'O estoque precisa ser um numero maior que 0.');
				until natural(temp);
				caixaTexto(18, 16, 12, 1, false);
				escreveReverso(18, 16, temp);
				regNote.estoque := paraWord(temp);
			end;
		PRECOREG:
			begin
				status(false, 'Digite o preco do notebook.');
				repeat
					caixaTexto(40, 16, 12, 1, true);
					write('R$ ');
					window(43, 16, 51, 16);
					readln(temp);
					if not consistePreco(temp) then
						status(true, 'O preco precisa estar entre 500 e 10 mil reais.');
				until consistePreco(temp);
				caixaTexto(40, 16, 12, 1, false);
				escreveReverso(40, 16, 'R$ ' + temp);
				regNote.preco := paraReal(temp);
			end;
	end;
end;

{
	Desenha a tabela de relatório
	Uso: desenhaTabela
}
procedure desenhaTabela;
const
	itens: array[1..7] of string = ('Codigo',
									'Marca',
									'Modelo',
									'Processador',
									'Preco',
									'Vendas',
									'Total');
var
	i: byte;
begin
	borda(0, 4, 80, 19, cor.borda, false);
	for i := low(itens) to high(itens) do
		escreve(posicaoRelatorio[i], 5, itens[i]);
	escreve(3, 6, '----------------------------------------------------------------------------');
end;

{
	Escreve uma linha do relatório definida
		Variável global regNote usada para escrever os dados
	Uso: preencheRelatório(byte)

	1) y: número da linha do relatório onde vão aparecer os valores
}
procedure preencheRelatorio(y: byte);
var
	temp: string;
begin
	inc(y, 6);
	with regNote do
	begin
		escreve(posicaoRelatorio[1], y, codigo);
		escreve(posicaoRelatorio[2], y, marca);
		escreve(posicaoRelatorio[3], y, copy(modelo, 1, 10));
		escreve(posicaoRelatorio[4], y, processador);
		str(preco:0:2, temp);
		escreve(posicaoRelatorio[5], y, 'R$' + temp);
		str(vendidos, temp);
		escreve(posicaoRelatorio[6], y, temp);
		str((preco * vendidos):0:2, temp);
		escreve(posicaoRelatorio[7], y, 'R$' + temp);
	end;
end;

{
	Gera o relatório definido
		Variável global regNote usada para salvar os dados manipulados
		A tela do relatório é gerada de 13 em 13 registros
	Uso: geraRelatorio(tipoRelatorio)

	1) r: enumerador do tipo de relatório a ser gerado
			tipoRelatorio = (SIMPLES, ESTOQUES, VENDAS);
}
procedure geraRelatorio(r: tipoRelatorio);
var
	codigo, temp: string;
	lidos, totalEstoque: word;
	totalValor: real;
	emBranco: boolean;
begin
	emBranco := true;
	case r of
		SIMPLES:
			begin
				status(false, 'Relatorio simples.');
				codigo := questao(0, 0, 'Digite o codigo para gerar o relatorio:');
				caixaAlta(codigo);
				if not consisteCodigo(codigo) then
					info(0, 0, false, 'Codigo invalido.')
				else if busca(codigo) then
				begin
					desenhaTabela;
					preencheRelatorio(1);
					emBranco := false;
					escreve(3, 21, 'Totais:         ');
					status(false, 'Relatorio finalizado. Pressione ' + #17 + #217 + ' para sair.');
					esperaEnter;
				end
				else
					info(0, 0, false, 'Registro nao encontrado.');
			end;
		else
		begin
			lidos := 0;
			totalEstoque := 0;
			totalValor := 0;
			seek(arqNote, 0);
			status(false, 'Pressione ' + #17 + #217 + ' para continuar.');
			while not eof(arqNote) do
			begin
				read(arqNote, regNote);
				with regNote do
				begin
					{ Verifica se o registro não foi excluído para geração do relatório }
					if (status <> '*') and (((r = VENDAS) and (vendidos > 0)) or (r = ESTOQUES)) then
					begin
						inc(lidos);
						if emBranco then
						begin
							desenhaTabela;
							emBranco := false;
						end;
						if lidos = 13 then
						begin
							lidos := 1;
							esperaEnter;
							desenhaTabela;
						end;
						preencheRelatorio(lidos);
						inc(totalEstoque, vendidos);
						totalValor := totalValor + vendidos * preco;
						escreve(3, 21, 'Totais parciais:');
						str(totalEstoque, temp);
						escreve(posicaoRelatorio[6], 21, temp);
						str(totalValor:0:2, temp);
						escreve(posicaoRelatorio[7], 21, 'R$' + temp);
					end;
				end;
			end;
			if emBranco then
				info(0, 0, false, 'Nenhum item a ser impresso no relatorio.')
			else
			begin
				escreve(3, 21, 'Totais:         ');
				status(false, 'Relatorio finalizado. Pressione ' + #17 + #217 + ' para sair.');
				esperaEnter;
			end;
		end;
	end;
	limpaTela(false);
end;