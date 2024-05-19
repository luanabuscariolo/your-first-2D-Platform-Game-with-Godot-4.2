# Passo a passo de como fazer moedas coletáveis e um báu que só abre se o jogador coletar a chave

![Exemplo de player coletando moedas e chave](/../main/images/collectables.gif)

### Pacote de sprites utilizadas:   
[Anokolisa - Legacy Fantasy Bundle](https://anokolisa.itch.io/sidescroller-pixelart-sprites-asset-pack-forest-16x16)  
[GrafxKid - Sprite Pack 6](https://grafxkid.itch.io/sprite-pack-6)  
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

- Quando o jogador chega ao baú, é emitido um sinal de alerta de que o jogador precisa da chave para abrir o baú;
- Ao coletar a chave e retornar ao báu, o jogador consegue abrí-lo.

Criaremos duas cenas novas, uma para o báu e outra para a chave. Os nós desses dois itens podem ser criados na árvore da cena principal, mas caso em outros cenários do jogo você deseje utilizar um novo báu e outra chave, será mais fácil se já tiver criado uma cena para ambos e assim só instanciar, ao invés de criá-los novamente em outra cena.

### Vamos começar pela cena da chave:

Os nós criados para compor a árvore de cena da chave são:

- Area2D
   - CollisionShape2D
   - Sprite2D
   - AnimationPlayer

Renomeei os nós da seguinte maneira:

![Árvore de nós da cena da chave](/../main/images/arvore_nos_key.png)

### Animação com AnimationPlayer

Diferente de ***AnimatedSprite2D*** usado para fazer as animações da moeda, o ****AnimationPlayer*** vai utilizar outro nó que é o Srite2D. A cada etapa da animação, pode ser adicionado características como posição, textura, alteração de cor ou transparência, frame específico, visibilidade e tantas outras configurações da aba `Inspector`. Para adicionar um ponto a ser animado, basta clicar na figura de uma chave ao lado de cada configuração. 

Para criar a animação, basta clicar no nó ***anim*** e na aba que abrirá para desenvolver a animação, clique em `Animation/New` e nomeie sua animação. 

Segue imagem exemplificando as propriedades usadas para fazer a animação:

![Animação da chave com o nó AnimationPlayer](/../main/images/animation_key.png)

Para adicionar cada uma dessas propriedades, clique no nó sprite, escolha um sprite para o nó e já adicione sua propriedade clicando na chave ao lado esquerdo de `Texture`. Faça isso para todas as propriedades listadas na imagem. 

Na posição de 0.4 segundos modifique as propriedades de `Position` e `Modulate`. Mova o sprite da chave no eixo Y para cima e após mover, clique na chave para salvar na animação a nova posição e na propriedade `Modulate`, na tabela de RGBA deixe o valor de A no zero, logo depois salve esse estado na animação clicando na chave ao lado da propriedade.  

Assim que o personagem colidir com a chave coletando ela, a animação a ser executada será da chave subindo levemente e desaparecendo.  

Uma configuração muito legal no AnimationPlayer é o uso de Métodos, como por exemplo chamar o método `queue_free()` na fim da animação para que o nó seja seja removido. Você se lembra que utilizamos o método _queue_free()_ no script da moeda para removê-la? Aqui não será passado no script, pois na própria linha do tempo da animação, chamaremos logo ao fim. 
 - Para chamar a função `queue_free()` ao fim da animação fazemos o seguinte:  `Add Track / Call Method Track`.  
 - Na linha do tempo, clicamos com o botão direito do mouse ao fim do tempo escolhido e escolhemos `Insert Key` e procuramos pelo método desejado e por fim `open` para adicioná-lo à animação.

### Tendo feito a animação, vamos para o script da chave.

 - Crie um script para o nó raiz `key` (Area2D);
 - Adicione o sinal `body_entered(body: Node2D)` do nó `key` ao script.
 
#### O código para a chave é:

```gd
extends Area2D

@onready var anim = $anim

func _on_body_entered(body):
  if body.name == "player":
    anim.play("collected")
```
1. A variável `anim` faz referência ao nó de animação `anim` (AnimationPLayer).
2. A `func _on_body_entered(body)` é um sinal (signal) conectado ao evento de colisão. Quando um corpo (neste caso, o jogador) entra na área da moeda, esta função é chamada.
     - Verifica se o corpo que entrou na área é o jogador (if body.name == "player").
     - Se for o jogador, a animação "collected" é reproduzida (anim.play("collected")).

#### No script do player é necessário adicionar o seguinte código para lidar com a posse da chave:

```gd
var has_key := false

@onready var key = %key

func _ready():
  key.body_entered.connect(collected)

func collected(body):
  has_key = true
  print("pegou chave")
```

### Explicando o código:

1. `var has_key := false`: Esta linha declara uma variável chamada `has_key` e a inicializa como false. Esta variável é um indicador booleano usado para rastrear se o personagem do jogador coletou a chave.

2. `@onready var key = %key`: Usa o @onready para atribuir o nó de Area2D `%key` à variável `key` assim que o nó for carregado.

3. `func _ready()`: Esta linha conecta o sinal `body_entered` do nó `key` à função `collected()`. Isso significa que quando o corpo do jogador entra em contato com o corpo da chave, a função `collected()` será chamada.

4. `func collected(body)`:
   - ***Parâmetro***: `body` representa o corpo que entrou na área da chave (geralmente o corpo do jogador);
   - ***Atribuição***: `has_key = true` altera o estado da variável `has_key` para true, indicando que o jogador coletou a chave;
   - ***Mensagem***: `print("pegou chave")` imprime uma mensagem no console indicando que a chave foi coletada (somente para teste, pode ser retirada). 

## Para terminar o Passo a passo de coletáveis, vamos ao baú e a ligação dele com a chave desenvolvida anteriormente:

Os nós que compõem a árvore da cena do baú são:
- Area2D
  - CollisionShape2D
  - AnimatedSprite2D
  - Sprite2D

Na imagem a seguir os mesmos nós renomeados:

![Árvore de nós da cena do baú](/../main/images/arvore_nos_bau.png)

O nó `anim`(AnimatedSprite2D) possui somente uma animação que é a de abertura do baú. Não tem o Looping e nem o Autoplay ativado. Segue imagem de exemplo:

![Animação de abertura do baú](/../main/images/animacao_bau.png)

### Sobre o alerta para o jogador sobre a chave:

- No nó `alert` (Sprite2D) vamos adicionar à `Inspector / Texture` o sprite de uma chave.
- Posicione o sprite logo acima do baú.
- Quando o jogador tiver colisão com a área do baú, o alerta aparecerá para que o jogador compreenda que necessita de uma chave para abrir aquele baú.
- Esse alerta será exibido somente se o jogador colidir seu personagem com a área do báu e se ele não estiver com a posse da chave.
- Ao coletar a chave e retornar ao baú, este se abrirá e o aviso não aparecerá mais.

### Vamos ao código:

- Crie um script para o nó `chest` (Area2D);
- Adicione dois sinais do nó `chest` ao script:
  - `body_entered(body: Node2D)`;
  - `body_exited(body: Node2D)`;

```gd
extends Area2D

@onready var anim = $anim
@onready var player = %player
@onready var alert = $alert

var open_chest := false

func _on_body_entered(body):
  if player.has_key:
    anim.play("open")
    player.has_key = false
    open_chest = true
  elif open_chest:
    alert.visible = false
  else:
    alert.visible = true

func _on_body_exited(body):
  alert.visible = false
```
1. ***Extensão e Variáveis***:
    - `extends Area2D`: Indica que o script está estendendo a classe Area2D, que é usada para detectar colisões em uma área 2D;
    - `@onready var anim = $anim`: Usa @onready para obter uma referência ao nó chamado `anim`;
    - `@onready var player = %player`: Usa @onready para obter uma referência ao nó chamado `player`;
    - `@onready var alert = $alert`: Usa @onready para obter uma referência ao nó chamado `alert`;
    - `var open_chest := false`: Variável booleana que rastreia se o baú está aberto.

2. ***Função*** `_on_body_entered(body)`: Essa função é chamada quando um corpo entra na área do baú.
    - Verificação da Chave: `if player.has_key`:
        - Se o jogador `player` tiver a chave `has_key`, a animação de abrir o baú é executada `anim.play("open")`;
        - A chave é consumida `player.has_key = false`;
        - Marca o baú como aberto `open_chest = true`;
    - Verificação do Estado do Baú: `elif open_chest`:
        - Se o baú já estiver aberto, o alerta é ocultado `alert.visible = false`.
    - Mostrar Alerta: `else`:
        - Se o jogador não tiver a chave e o baú não estiver aberto, o alerta é exibido `alert.visible = true`.

3. ***Função*** `_on_body_exited(body)`: Essa função é chamada quando um corpo sai da área do baú.
    - Ocultar Alerta: `alert.visible = false`;
    - Quando o corpo sai da área, o alerta é ocultado.


> [!NOTE]
> Pode-se observar que alguns nós referenciados no script iniciam com `$` ou `%`. A diferença é que os nós que iniciam nom `%` são nós exclusivos da cena. Para ativar essa mesma configuração basta clicar com o botão direito em cima do nó desejado e escolher a opção `Access as Unique Name`. Dessa maneira, mesmo que o caminho do nó seja alterado, não será necessário atualizar isso no script em que aquele nó é instanciado.

---

Acompanhe o [projeto atual](https://github.com/luanabuscariolo/your-first-2D-Platform-Game-with-Godot-4.2/tree/main/2D_Platformer).    
Veja [outros](https://github.com/luanabuscariolo/your-first-2D-Platform-Game-with-Godot-4.2/tree/main/Step_by_Step)  passo a passos desse projeto.

### É isso aí!  
### Bons estudos :sunglasses:




