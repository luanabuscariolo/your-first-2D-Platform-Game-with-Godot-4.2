# Passo a passo para fazer plataformas :arrow_down: :left_right_arrow: :arrow_up_down: 

![Exemplo de player passando pelos tipos de plataforma](images/platforms.gif)

## vamos construir 3 tipos de plataformas e uma bônus :star:

- Plataforma fixa (a mais comum de todas).
- Plataforma de queda ao detectar colisão com jogador;
- Plataforma de movimento na horizontal ou vertical;
- BÔNUS: Uma plataforma de queda um pouquinho diferente! :smile:  

### Pacote de sprites utilizadas:   
- [Anokolisa - Legacy Fantasy Bundle](https://anokolisa.itch.io/sidescroller-pixelart-sprites-asset-pack-forest-16x16)  
- [GrafxKid - Sprite Pack 6](https://grafxkid.itch.io/sprite-pack-6)  
- [GrafxKid - Mini FX, Items & UI](https://grafxkid.itch.io/mini-fx-items-ui)  

> [!NOTE]
> Necessário download da [Godot 4.2](https://godotengine.org/download/windows/)  para abrir o projeto e poder executar, modificar e criar.

## 1ª Plataforma: plataforma fixa

Esse é o tipo mais básico e comum de plataforma. Para criá-la vamos criar uma nova cena e adicionar os seguintes nós:

- StaticBody2D
    - Sprite2D
    - CollisionShape2D

Renomeei os nós com os seguintes nomes:

![Nós renomeados da cena da plataforma](https://raw.githubusercontent.com/luanabuscariolo/your-first-2D-Platform-Game-with-Godot-4.2/main/Step_by_Step/Platforms/images/arvore_nos_platform_renomeados.png)

#### Próximos passos:

- Adicione ao nó `sprite` uma imagem para ser sua plataforma na aba `Inspector/Texture`;
- Ao nó `collision` determine qual será o shape de colisão que melhor se encaixe à sprite da plataforma. Vá para a aba `Inspector/Shape` e escolha a melhor forma para colisão. Eu escolhi para a minha plataforma o shape `RectangleShape2D`.
- Ainda no nó `collision` deixe habilitado a propriedade `One Way Collision`. Essa configuração permitirá ao jogador saltar para a plataforma de baixo para cima, mas não cair através dela de cima para baixo.

A imagem a seguir exemplifica a configuração do nó de colisão:

![COnfigurações do nó de colisão](https://raw.githubusercontent.com/luanabuscariolo/your-first-2D-Platform-Game-with-Godot-4.2/main/Step_by_Step/Platforms/images/collision_platform.png)

Com isso feito, nossa primeira plataforma já está feita. Agora basta instanciar a cena `platform` como filho do nó raiz da cena principal, por exemplo, cena de fase ou nível. Nesse projeto está como: `world_01` e então é só posicionar a plataforma no local que quiser na cena de seu jogo. :wink:

## 2ª Plataforma: plataforma de queda :arrow_down:

Essa plataforma reage à interação do jogador, caindo e depois retornando à sua posição original após um tempo.

Após criar uma nova cena, vamos aos nós que ela terá:

- RigidBody2D
    - Sprite2D
    - CollisionShape2D
    - Timer
    - Area2D
        - CollisionShape2D
    - AnimationPlayer

Renomeei os nós com os seguintes nomes:

![Nós renomeados da cena Plataforma de queda](https://raw.githubusercontent.com/luanabuscariolo/your-first-2D-Platform-Game-with-Godot-4.2/main/Step_by_Step/Platforms/images/arvore_nos_fall_platform_respawn.png)

Após adicionar ao nó `sprite` uma imagem que será sua plataforma de queda, vamos às colisões.

Teremos 2 colisões (como ilustrado na imagem a seguir):

![Colisões da plataforma de queda](https://raw.githubusercontent.com/luanabuscariolo/your-first-2D-Platform-Game-with-Godot-4.2/main/Step_by_Step/Platforms/images/platform_respawn_collisions.png)

- A colisão em verde representa o colisor da plataforma com o personagem;
- A colisão em vermelho indica o colisor da área do nó `body_detector`. Esse  colisor que dirá se o personagem entrou em contato com a plataforma para que ela caia;
- Não esqueça de especificar a camada em que o nó está e com quem ele colidirá.

> [!NOTE]
> É importante que o colisor do nó 'Area2D' fique acima do colisor do nó raiz, para que não haja interferências na detecção do personagem e não acabe ocasionando erro na queda da plataforma.

### Animação de alerta

Assim que o jogador colidir com a plataforma, ela vai tremer, informando ao jogador que ela vai cair e que ele precisa sair daquela plataforma. Esse tipo de alerta melhora a experiência do jogador ao ser avisado de possíveis acontecimentos enquanto ele joga.

Para fazer essa animação vamos ao nó `anim` criar uma nova animação `alert`. Vamos trabalhar com a propriedade `Position` do nó `sprite`.
- Crie a animação `alert`;
- Determine o tempo de animação (eu coloquei 0.4);
- Deixe ativado o botão de `Animation Looping` (aparecerá inicialmente com o símbolo de Looping :repeat:, clique novamente até mudar a imagem para um simbolo assim    :left_right_arrow:); 
- Selecione o nó `sprite` e vá na aba `Inspector/Position`;
- Agora clique na :old_key: da propriedade `Position`, isso adicionará um novo ponto na linha de animação;
- Agora repita isso para os instantes de tempo `0.1 --> x = 2`, `0.2 --> x = 0`, `0.3 --> x = -2` e `0.4 --> x = 0`. Os valores de X são os valores da propriedade `Position` no eixo X. Não esqueça de sempre finalizar a alteração de um valor clicando na chave da propriedade para que as alterações sejam salvas na linha do tempo da animação. 

A imagem abaixo exemplifica a linha do tempo da animação e as propriedades citadas como o tempo, o lopping e posição no eixo x para que você se localize melhor dentro da engine:

![Propriedades para animação](https://raw.githubusercontent.com/luanabuscariolo/your-first-2D-Platform-Game-with-Godot-4.2/main/Step_by_Step/Platforms/images/configurações_anim_plataforma_queda.png)

### Agora vamos criar o Spript da cena e Sinais necessários:

No nó `fall_platform_respawn` crie um novo script e adicione a ele dois sinais:
- Adicione ao script o sinal `body_entered(body: Node2D)` do nó `body_detector`;
- Adicione ao script o sinal `timeout()` do nó `respawn_timer`.

#### Não sabe adicionar sinais? Sem problema, é bem simples. Vamos lá!

- Selecione o nó desejado, por exemplo `respawn_detector (Timer)`;
- Na aba de propriedades temos `Inspector - Node - History`, clique em `Node`;
- Teremos `Signals` e `Groups`, clique em `Signals` se já não estiver selecionado;
- Procure o sinal desejado, no caso do nó `respawn_detector` queremos o sinal `timeout()`, clique duas vezes no sinal;
- Uma janela para conectar esse sinal a um método será aberta;
- Selecione o nó com o script que fará uso desse sinal (nesse caso o nó `fall_platform_respawn`);
- Clique em `Connect` e então é só partir para o script! :wink:

### Vamos ao código:

```gd
extends RigidBody2D

@onready var respawn_position = self.global_position
@onready var anim = $anim
```
- A classe do script herda de RigidBody2D;
- `respawn_position` armazena a posição inicial da plataforma;
- `anim` referencia o nó de animação `AnimationPlayer` cujo nome foi renomeado para `anim`.

```gd
func _on_body_detector_body_entered(body):
    if body.name == "player":
        anim.play("alert")
        await get_tree().create_timer(1).timeout
        set_deferred("freeze", false)
        $respawn_timer.start()
```
- A função `_on_body_detector_body_entered(body)` é chamada quando um corpo entra na área de detecção do nó `body_detector`;
- Primeiro, verifica se o corpo que entrou é o jogador;
- Se for, executa a animação de alerta, indicando que a plataforma vai cair;
- Aguarda 1 segundo;
- Define `freeze` como `false` (Se a propriedade `freeze` for verdadeira, o corpo fica congelado. A gravidade e a forças não são aplicadas, por isso é importante definir `false` quando quiser que a plataforma sofra com gravidade e outras forças);
-  Inicia um temporizador `(respawn_timer)` para a plataforma se reposicionar depois de cair.

```gd
func respawn_platform():
    global_position = respawn_position
    anim.play("RESET")
    set_deferred("freeze", true)
```
- A função `respawn_platform()` Define o comportamento para reposicionar a plataforma após a queda;
- `global_position = respawn_position:` Reposiciona a plataforma na posição inicial;
- `anim.play("RESET"):` Toca a animação de reset para a plataforma;
- `set_deferred("freeze", true):` Define freeze como true novamente, para que a plataforma fique congelada em sua posição inicial até a próxima colisão com o jogador.

```gd
func _on_respawn_timer_timeout():
    respawn_platform()
```
- A função `_on_respawn_timer_timeout():` é chamada quando o temporizador `(respawn_timer)` expira;
- `respawn_platform():` Chama a função `respawn_platform()` para reposicionar e "resetar" a plataforma.

## 3ª Plataforma: plataforma de movimento horizontal e vertical :left_right_arrow: :arrow_up_down: 

Chegamos na 3ª plataforma desse tutorial. Essa plataforma móvel tem direção no eixo X e Y é essa direção é escolhida de forma muito simples através de uma variavél externa na qual escolhemos o eixo de movimento de nossa plataforma.

Após criar uma nova cena para essa plataforma diferente das anteriores, vamos aos nós:

- AnimatableBody2D
    - CollisionShape2D
    - Sprite2D

Após renomeá-los, a árvore ficou assim:

![Árvore de nós da cena plataforma móvel](https://raw.githubusercontent.com/luanabuscariolo/your-first-2D-Platform-Game-with-Godot-4.2/main/Step_by_Step/Platforms/images/arvore_nos_move_platform_renomeados.png)

#### Próximos passos:
- Escolha sua sprite de plataforma;
- Defina a forma do colisor mais ideal para a sua plataforma;
- Não esqueça de ativar `One Way Collision` nas propriedades do nó `CollisionShape2D` caso você deseje que o personagem não sofra colisão ao pular na plataforma de baixo para cima;
- Crie um script para o nó `AnimatableBody2D`.

Agora que criamos uma cena para a plataforma, vamos instanciá-la :link: (Atalho: <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>A</kbd>)  em nossa cena principal e adicionar um novo nó filho do tipo `AnimationPlayer` a essa plataforma, como exemplifica a imagem a seguir:

![Árvore de nós da cena principal](https://raw.githubusercontent.com/luanabuscariolo/your-first-2D-Platform-Game-with-Godot-4.2/main/Step_by_Step/Platforms/images/arvore_cena_move_platform.png)

 > [!WARNING]
 > O nó "anim" (AnimationPLayer) deve ser filho do nó "move_platform". Se o nó for posto como filho do nó raiz "World-01" a animação da plataforma terá erros. Verifique o exemplo na imagem acima.


### Animação da plataforma:

A plataforma terá duas animações: deslocamento no eixo X (horizontal) e outra no eixo Y (vertical). Para fazermos essas animações no nó filho `anim` (AnimationPLayer) utilizaremos somente a propriedade `Position`.  

Vou citar duas maneiras de se fazer essa animação: 

1. **Salvar cada posição clicando na chave ao lado da propriedade manipulada**:
    - Você pode utilizar a chave :key: ao lado da propriedade `Position` para cada posição que você desejar salvar na linha do tempo da animação, como fizemos em exemplos anteriores.
    
2. **Salvar cada posição com** `Auto insert keys`:
    - Pode utilizar o botão `rec`para inserir chaves nos instantes de tempo selecionados na animação. Com o `Auto insert keys` selecionado (ele fica em vermelho) como na imagem abaixo mostra, escolha o instante de tempo, por exemplo em 0.5 segundos e mova o sprite da plataforma até a posição desejada na cena e solte o botão do mouse. Você notará que uma chave será criada na linha do tempo da animação com a posição em X e/ou Y alterada conforme posicionado;
    - Para essa simples animação determine o tempo em 1 segundo e deixe selecionado o `Animation Looping`. No instante 0 indique a posição inicial da plataforma, no instante de tempo 0.5 mova a plataforma na horizontal ou vertical e o instante de tempo 1 retorne à posição inicial da plataforma. Com isso a animação de ida e vinda estará feita;
    - Faça esse processo para a animação de movimento da horizontal `move_horizontal` e movimento na vertical `move_vertical`. Deixei minha animação `move_vertical` com o `Autoplay on Load` habilitado, pois será a animação qua a minha plataforma terá.
    - Por fim, configure a propriedade `Speed Scale` para a velocidade desejada para a  velocidade de deslocamento da plataforma.

Na imagem abaixo, está em destaque o local do botão `Auto insert keys`, local de criação de uma nova animação `Animation`, botão de `Autoplay on Load`, `Animation Looping` e `Speed Scale`.

![Configurações de animação da plataforma de movimento](https://raw.githubusercontent.com/luanabuscariolo/your-first-2D-Platform-Game-with-Godot-4.2/main/Step_by_Step/Platforms/images/animation_move_platform.png)

### Vamos ao código:

No script do nó `move_platform` adicione o script a seguir:

```gd
extends AnimatableBody2D

@onready var anim = $anim

@export_enum("move_horizontal", "move_vertical") var move_direction = 0

func _ready():
    pass
    anim.assigned_animation = "move_horizontal" if move_direction == 0 else "move_vertical"
```

#### Explicação resumida do script:

1. **Extensão de** `AnimatableBody2D`: 
    - A classe atual herda funcionalidades de `AnimatableBody2D`, um nó usado para corpos animáveis em 2D.

2. **Inicialização de** `anim`:
    - Utilizar `@onready` assegura que a variável `anim` seja inicializada apenas quando o nó estiver pronto. O `$anim` é um atalho para `get_node("anim")`, ou seja, ele está buscando um nó filho chamado `anim`. Isso geralmente é utilizado para acessar nós definidos na cena associada a este script.

3. **Exportar Direção de Movimento**:
    - Aqui, `@export_enum` cria uma propriedade exportada que pode ser editada diretamente no editor da Godot, sem necessidade de retornar ao código para alterar o eixo de direção da plataforma. Os valores possíveis definidos na animação feita anteriormente são `move_horizontal` e `move_vertical`, e `move_direction` será um inteiro que pode ser 0 ou 1, correspondendo a essas direções. `var move_direction = 0` define o valor padrão para `move_direction` como 0 (que representa `move_horizontal`);
    - Na imagem a seguir, podemos observar o resultado dessa exportação. Nas propriedades da animação, podemos escolher qual animação a plataforma terá sem que seja necesário acessar o código novamente.
    
        - ![Variáveis externas](https://raw.githubusercontent.com/luanabuscariolo/your-first-2D-Platform-Game-with-Godot-4.2/main/Step_by_Step/Platforms/images/move_platform_export_enum.png)

4. **Função** `_ready()`:
    - Quando o nó e seus filhos estão prontos, a função `_ready()` configura a animação do `anim` baseado no valor de `move_direction`: se for 0, a animação é `move_horizontal`; caso contrário, é `move_vertical`.

## Plataforma BÔNUS :star:

Você reparou no início do passo a passo o GIF exemplificando o funcionamento de cada plataforma? Notou na plataforma no rio que ao detectar a colisão com o jogador ela emite um alerta de que é instável e após um tempo determinado afunda e sobe novamente, semelhante ao comportamento de uma madeira no rio? Afunda com a colisão e após um tempo predeterminado sobe e continua boiando na água. Vamos construí-la? :wrench:

### Árvore de nós:

Crie uma nova cena para essa plataforma e adicione os seguintes nós:

- RigidBody2D
    - Sprite2D
    - CollisionShape2D
    - AnimationPlayer
    - Area2D
        - CollisionShape2D

Renomeados:

![Árvore de nós plataforma bônus](https://raw.githubusercontent.com/luanabuscariolo/your-first-2D-Platform-Game-with-Godot-4.2/main/Step_by_Step/Platforms/images/arvore_nos_bonus.png)

