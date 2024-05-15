# Passo a passo de como fazer moedas coletáveis e um báu que só abre se o jogador coletar a chave

![Exemplo de player coletando moedas e chave](/../main/images/collectables.gif)

### Pacote de sprites utilizadas:   
[Anokolisa - Legacy Fantasy Bundle](https://anokolisa.itch.io/sidescroller-pixelart-sprites-asset-pack-forest-16x16)  
[GrafxKid - Mini FX, Items & UI](https://grafxkid.itch.io/mini-fx-items-ui)  

#### Necessário download da [Godot 4.2](https://godotengine.org/download/windows/)  para abrir o projeto e poder executar, modificar e criar.

## Vamos iniciar com as moedas: :moneybag:
- As moedas são coletáveis pelo jogador após colisão (sem valor computado no momento);
- Após colidir com o personagem, a moeda desaparece com uma animação de partículas.

### A árvore de nós da moeda é:
![Árvore de nós da cena da moeda](/../main/images/arvore_nos_coins.png)

Os nós renomeados ficarm assim:
- coin
  - collision
  - anim

O nó ***anim*** tem duas animações:
- ***idle***: moeda girando;
- ***collected***: partículas de se desintegrando.

### Animação com AnimatedSprite2D:

Para criar uma animação com AnimatedSprite2D é simples, mas não intuitivo.   
Após criar o nó, na parte de  `Inspector / Animation`, clique em `Sprite Frames / <empty>` e em `New SpriteFrames` como exemplifica a imagem a seguir:   

![Exemplo de como adicionar uma animação ao nó AnimatedSprite2D](/../main/images/add_animation_coin.png)

>[!NOTE]
> Caso ainda não abra uma nova parte para animação na região inferior da área de trabalho da engine, clique novamente em `SpriteFrames`.

Agora é só criar as animações que quiser, podendo arrastar sprites diretamente, mas se seus sprites estão todos em uma única imagem, é necessário adicionar de outra maneira, através do botão `Add frames from sprite sheet` (parece um quadrado cheio de quadradinhos) ou seu atalho <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>O</kbd>. Dessa forma, você poderá ajustar os frames na Vertical e Horizontal para que fiquem individualizados e assim exportar todos os frame. A imagem abaixo mostra isso:   

![Exemplo de como selecionar os frames de uma imagem para animá-los](/../main/images/SelectFrames.png)

Criada uma nova animação com seus respectivos frames, há várias configurações que podem ser feitas nessa janela de animação:
- *Autoplay on Load*: A animação inicia junto com o jogo. Se sua animação não deve inicializar sozinha, mas precisa de alguma colisão ou uma interação, deixe desabilitado essa opção;
- *Animation Looping*: A animação continuará eternamente a não ser que seja destruída ou pelo script seja alterada. Caso sua animação não deva entrar um loop de repetição, deixe desativado;
- *Botões de execução*: Você pode visualizar sua animação com play e stop/pause.

### Atenção com as camadas de colisão!   
Se atente com as camadas que pré determinou para cada coisa no seu cenário. Respeite as camadas e com quem elas colidem. Vai por mim, as configurações estarão todas certas, o script estará correto e mesmo assim não vai funcionar na hora do teste porque você esqueceu de colocar na camada certa. A solução NÃO É colocar tudo na mesma camada! Pare de ser preguiçoso. Separe cada tipo na sua camada. Na imagem a seguir mostro como separei minhas camadas para cada tipo.

![Organizando as camadas](/../main/images/layers_collision.png)

O caminho para chegar nessa janela e modificar de forma simples o nome de cada camada foi: `Project/Project Settings/General/Layer Names/2D Physics`.

Por fim, a cada item, cenário, personagem, inimigo ou qualquer outra coisa que tiver colisão, você deve escolher a camada dele em `Collision/Layer` e escolher a qual a camada que estará o objeto com o qual ele colidirá. No meu caso, a moeda está na camada 3 (itens) e ela colidirá somente com o personagem que está na camada 2 (player). Segue exemplo abaixo:

![Camada de colisões](/../main/images/collision_coin.png)

### Vamos ao código

Crie um script para o nó ***coin*** (Area2D) e vamos adicionar a ele dois sinais do nó ***anim*** (AnimatedSprite2D) e do prório nó ***coin*** (Aread2D). Para adicionar ao script um sinal do nó desejado, basta clicar no nó e ao lado direito da tela, onde aparece a aba `Inspector`, o lado dele teremos `Node`, clique em Node e depois `Signals`. Agora é só escolher o sinal desejado dando duplo clique ou clicando uma vez e apertando <kbd>enter</kbd>. Após fazer isso, abrirá uma jalena para você escolher em qual script será adicionado o sinal, Escolha o nó em que está o script e depois `Connect`. Os sinais que precisamos no script são:

- `body_entered(body: Node2D)` do nó ***coin*** (Area2D);
- `animation_finished()` do nó ***anim*** (AnimatedSprite2D).

Tendo feito isso, abra o script e adicione o seguinte código:

```gd
extends Area2D

@onready var anim = $anim

func _on_body_entered(body):
  if body.name == "player":
    anim.play("collected")

func _on_anim_animation_finished():
  queue_free()
```

É um código bem simples. Aqui está o que cada parte do script faz:

1. `extends Area2D`: Indica que o script está estendendo a classe Area2D, que é uma área 2D que detecta colisões.

2. `@onready var anim = $anim`: Usa o @onready para atribuir o nó de animação $anim à variável anim assim que o nó for carregado.

3. `func _on_body_entered(body)`: Esta função é um sinal (signal) conectado ao evento de colisão. Quando um corpo (neste caso, o jogador) entra na área da moeda, esta função é chamada.
    - Verifica se o corpo que entrou na área é o jogador (if body.name == "player").
    - Se for o jogador, a animação "collected" é reproduzida (anim.play("collected")).

> [!NOTE]
>Lembra da importância de usar corretamente o Looping e o Autoplay na animação? Caso você deixe selecionado o loop nessa animação, com o script até esse ponto, a reprodução de partículas nunca acabaria, ficaria recomeçando e isso não faz sentido, pois queremos que seja executada uma única vez.

4. `func _on_anim_animation_finished()`: Esta função é chamada quando a animação "collected" termina.
Dentro desta função, a moeda é removida da cena usando queue_free(), que marca o nó para ser destruído no próximo ciclo de processamento.

#### Por que o nó da moeda deve ser removido?
 - **Sincronização com a Animação**: Garantir que a moeda só seja destruída após a conclusão da animação "collected". Isso permite que o jogador veja a animação completa de coleta, melhorando a experiência visual e de feedback no jogo.
 - **Gerenciamento de Recursos**: Remover a moeda da cena com queue_free() libera os recursos associados a ela (memória, texturas, etc.), evitando desperdício de recursos e potenciais problemas de desempenho, especialmente se houver muitas moedas sendo coletadas durante o jogo.
 - **Lógica do Jogo**: Após a coleta e a animação associada, a moeda não é mais necessária. Removê-la evita possíveis colisões futuras com uma moeda que já foi coletada, mantendo a lógica do jogo consistente e clara.

> [!WARNING]
> Cada nó na cena consome memória e outros recursos. Se moedas coletadas não forem removidas, esses recursos continuarão sendo usados desnecessariamente, o que pode levar a problemas de desempenho, especialmente em jogos com muitos objetos coletáveis.

Prontinho! Agora é só instanciar na cena principal (a minha é `World-01`) as moedas e posicioná-las onde desejar. Para instanciar, basta clicar no botão `Instaniate Child Scene` (ele parece uma corrente) ou com o atalho <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>A</kbd> e escolher a cena da moeda que foi criada. Outra forma é procurar nos próprios arquivos em `FileSystem` e arrastar o arquivo da cena da moeda para a cena principal. Automaticamente o nó da moeda aparecerá na árvore da cena principal. 

## Agora vamos fazer uma chave coletável que abre um baú: :key: :unlock:








