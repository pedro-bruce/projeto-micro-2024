# Projeto de Microprocessadores
## Grupo: Pedro Bruce de Lima e Vitor Ferreira


Neste projeto final seu grupo deve desenvolver um aplicativo console que aceite comandos do usuario e, para cada comando, desempenhe uma certa ac ̧ao na placa DE2 Altera. O console deve ser implementado via comunicação UART, utilizando a janela terminal do programa Altera Monitor. Ao ser iniciado, seu programa deve mostrar a seguinte frase no terminal:

***Entre com o comando:***

e esperar que o usuario entre com algum comando. Os comandos são compostos por, no máximo, dois inteiros conforme a tabela a seguir.

| Comando   | Ação                                                                                           | 
| --------- | ---------------------------------------------------------------------------------------------- |
| 00 xx     | Acender xx-esimo led vermelho.                                                                 | 
| 01 xx     | Apagar xx-esimo led vermelho.                                                                  |  
| 10        | Animação com os leds vermelhos dada pelo estado da chave SW0: se para baixo, a animação ocorre da esquerda para direita; se para cima, da direita para esquerda. A animação consiste em  acender um led vermelho por 200ms, apaga-lo e então acender seu vizinho, dependendo do estado da chave SW0. Este processo deve ser continuado repetidamente para todos os leds vermelhos. |
| 11        | Parar animação dos leds.                                                                        |  
| 20        | Inicia cronometro de segundos, utilizando 4 displays de 7 segmentos. Adicionalmente, o botão KEY1 deve controlar a pausa do cronometro: se contagem em andamento, deve ser pausada; se pausada, contagem deve ser resumida. |
| 21        |  Cancela cronometro.                                                                            | 

Observe que o enunciado deixa algumas questoes em aberto. Por exemplo, o que deve acontecer caso exista um led aceso e um comando de animac ̧ao seja digitado: perder o estado do led aceso ou restaurá-lo assim que a animação for cancelada? O grupo está livre para escolher a melhor forma de enfrentar essa e outras questôes. No entanto, isso deve estar presente no relatorio do projeto a ser entregue ao professor no final do semestre. Para implementação do aplicativo utilize a linguagem de montagem do Nios II e os recursos da  ̃*DE2 Media Computer*.
