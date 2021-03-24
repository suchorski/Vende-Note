{
	Auto Instrucional de LTP2
	Professor: Air Rabelo
	Alunos: Thiago Bastos Suchorski
			Rodrigo Braga Pessanha
			César Augusto Santos de Oliveira
			Vitor de Oliveira Castanheira
}
program AutoInstrucinal;

uses crt;

type
	{ Tipo de menu usado para geração de menus }
	menus = (PRINCIPAL, MARCA, PROCESSADOR, TELA, ALTERAR, RELATORIO);
	{ Tipo de registro usado para função de manipulação de registros (Incluir e Alterar) }
	registros = (CODIGOREG, MARCAREG, MODELOREG, PROCESSADORREG, MEMORIAREG, TELAREG, ESTOQUEREG, PRECOREG);
	{ Tipo de relatórios que podem ser feitos (geraRelatorio) }
	tipoRelatorio = (SIMPLES, ESTOQUES, VENDAS);
	{ Registro das cores usadas no programa }
	cores = record
		texto: 			byte;
		selecao: 		byte;
		borda: 			byte;
		bordaOK: 		byte;
		bordaErro: 		byte;
		background:		byte;
		backReverso:	byte;
	end;
	{ Registro de dados do estoque }
	reg = record
		status: 		char;
		codigo: 		string[6];
		marca: 			string[20];
		modelo: 		string[10];
		processador: 	string[20];
		memoria: 		byte;
		tela: 			string[3];
		estoque: 		word;
		preco: 			real;
		vendidos: 		word;
		ultimaVenda: 	string[10];
	end;

const
	{ Cores definidas usadas no programa }
	cor: cores = (
		texto: 			15;
		selecao: 		4;
		borda: 			15;
		bordaOK: 		10;
		bordaErro: 		12;
		background: 	0;
		backReverso: 	15
	);
	{ Posições das colunas dos relatórios (desenhaTabela, geraRelatorio e preencheRelatorio) }
	posicaoRelatorio: array[1..7] of byte = (3, 10, 19, 30, 47, 58, 65);

var
	menuPrincipal: byte;
	menuItens: array[1..10] of string;
	regNote: reg;
	arqNote: file of reg;

{$I GRAFICO}
{$I FUNCOES}
{$I MODULOS}

begin
	{ Limpa a tela com a cor de fundo }
	textcolor(cor.texto);
	textbackground(cor.background);
	clrscr;
	{ Inicia o móudo de informação do programa }
	sobre;
	{ Solicita a criação do arquivo do banco de dados caso não exista }
	{ Na existência do arquivo ele somente abre o existente }
	assign(arqNote, 'note.dat');
	{$I-}
	reset(arqNote);
	{$I+}
	if ioresult <> 0 then
		if confirma(0, 0, 'Criar novo arquivo de dados?') then
			rewrite(arqNote)
		else
			halt;
	{ Manipulação do menu principal }
	repeat
		borda(0, 1, 80, 3, cor.borda, true);
		textoCentralizado(0, 1, 80, 3, 'Sistema de Vendas *** VENDENOTE 2012');
		status(false, 'Use as teclas ' + #24 + ' e ' + #25 + ' para navegar e ' + #17 + #217 + ' para selecionar.');
		limpaTela(false);
		preencheMenu(PRINCIPAL, menuItens);
		menuPrincipal := menu(0, 0, 8, true, menuItens);
		case menuPrincipal of
			1: incluir;
			2: editar;
			3: excluir;
			4: consultar;
			5: venda;
			6: relatorios;
			7: sobre;
		end;
	until menuPrincipal = 8;
	{ Finaliza o arquivo do banco de dados }
	close(arqNote);
end.