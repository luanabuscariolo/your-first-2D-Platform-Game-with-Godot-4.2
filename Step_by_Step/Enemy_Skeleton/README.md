**Construindo o inimigo esqueleto**  

![](esqueleto.png)Descrição do inimigo:

- Esse inimigo especificamente não morre, ressurge após 3 segundos;
- Sofre dano quando o jogador pula na cabeça dele;
- Detecta o jogador através do nó *RayCast2D*;
- Não sobre ação da gravidade;
- No ataque, lança um osso em direção ao jogador;
- Seus estados são: patrulha, ataque, ferido, morrendo e ressurgindo.

A árvore de nós da cena do inimigo esqueleto ficou assim:

![](arvore_nos.png)

O nó **anim** possuí as seguintes animações:

- “*limping*”: movimento de patrulha;
- “*attack*”: estado de ataque ao detectar o jogador. Fica parado enquanto lança ossos (lançamento dos ossos é uma cena e código a parte);
- “*hurt*”: estado de ferido ao receber dano do jogador. O inimigo para por um tempo determinado e muda a cor para vermelho, dando assim um retorno visual para quem joga que houve dano no inimigo (o nó “***hurt\_sprite***” será usado exatamente para isso);
- “*dead*”: Após receber 3 danos do jogador, o esqueleto muda seu estado para morto, mas como dito anteriormente, ele não morre. Após um tempo determinado ele retorna chamando assim o próximo estado. A animação é de todos os seus ossos se desmontando;
- “*revive*”: Passado o tempo após morto, a animação dele levantando é chamada. Suas vidas retornam e ele continua a patrulha.

**Importante**: nenhuma dessas animações tem seu Autoplay ativado. Caso você ative o Autoplay para alguma animação, isso poderá acarretar em conflito com a máquina de estados do esqueleto que será feita no script dele.

**Posicionamento dos nós em relação ao esqueleto:**

![](posicionamento_nos.png)

O nó *hurt\_sprite* deve ter sua visibilidade desativada, pois a ativação se dará por código somente quando o jogador causar dano no esqueleto. Neste nó, basta adicionar o Sprite de dano em Texture na aba Inspector, fazer as modificações em Animation e mudar a cor para vermelho em Visibility: Self Modulate. 

O nó hitbox pode ser criado em um cena a parte, como eu fiz, ou simplesmente criado diretamente dentro da cena do esqueleto. Independe de como fizer, crie um script para esse nó e adicione a ele o sinal “body\_entered()”. O script será:

extends Area2D

func \_on\_body\_entered(body):

`	`if body.name == "player":

`		`body.velocity.y = body.jump\_velocity\_knockback

Antes de iniciarmos o script do esqueleto, é necessário criar uma nova cena para o osso que ele jogará no ataque, ajustando suas configurações e programação.

A cena é bem simples, contém somente 3 nós:

![](bones_nos.png)

- CharacterBody2D
- CollisionShape2D
- AnimatedSprite2D



No nó “anim”, a animação é do osso girando, com o Looping e Autoplay ativados.

Agora é só adicionar o script ao nó raiz “bones” e programar!

Segue abaixo o script do nó “bones”:

extends CharacterBody2D

var move\_speed := 50.0

var direction := 1

var time\_start = 0

var time\_now = 0

var dist = 0

func \_ready():

`	`time\_start = Time.get\_unix\_time\_from\_system()

func \_process(delta):

`	`position.x += move\_speed \* direction \* delta

`	`dist += abs(move\_speed \* direction \* delta)

`	`time\_now = Time.get\_unix\_time\_from\_system()

`	`var time\_elapsed = time\_now - time\_start

`	`if dist > 250 or time\_elapsed > 5:

`		`queue\_free()

func set\_direction(dir):

`	`direction = dir

`	`if dir < 0:

`		`$anim.flip\_h = true

`	`else: 

`		`$anim.flip\_h = false

Vamos para a sua explicação:

1. **Declaração de variáveis:**
   1. **move\_speed**: Velocidade de movimento do osso.
   1. **direction**: Direção do movimento do osso, inicialmente definida como 1 (direita).
   1. **time\_start**: Tempo inicial desde o sistema operacional.
   1. **time\_now**: Tempo atual desde o sistema operacional.
   1. **dist**: Distância percorrida pelo osso.
1. **\_ready() function:**
   1. Esta função é chamada automaticamente quando o nó é adicionado ao nó da cena.
   1. **time\_start** é definido como o tempo atual do sistema, marcando o início do movimento do osso.
1. **\_process() function:**
   1. Esta função é chamada a cada quadro.
   1. O osso se move horizontalmente com uma velocidade definida por **move\_speed** e **direction**.
   1. **dist** é incrementado com a distância percorrida a cada quadro.
   1. **time\_now** é atualizado para o tempo atual do sistema.
   1. **time\_elapsed** representa o tempo decorrido desde que o osso começou a se mover. É calculado como a diferença entre **time\_now** e **time\_start**.
   1. Se a distância percorrida (**dist**) for maior que 250 pixels OU o tempo decorrido (**time\_elapsed**) for maior que 5 segundos:
      1. O osso é destruído (**queue\_free()** é chamado).
1. **set\_direction() function:**
   1. Esta função é usada para definir a direção do movimento do osso.
   1. Recebe um parâmetro **dir** que indica a direção (1 para direita, -1 para esquerda).
   1. Atualiza a variável **direction** de acordo com o parâmetro fornecido.
   1. Se **direction** for menor que 0, o osso é girado horizontalmente para a esquerda (**flip\_h** é definido como **true**), caso contrário, ele é girado para a direita (**flip\_h** é definido como **false**).

Essencialmente, este código define o comportamento de movimento e destruição do osso, bem como sua orientação horizontal. 

Agora vejamos o script do esqueleto. Adicione ao nó skeleton(CharacterBody2D) um novo script. Vamos adicionar o sinal body\_entered() do nó hitbox(Area2D)  ao script skeleton. Adicionado ao script a nova função, veremos em seguida o seu conteúdo.

Script do skeleton:

extends CharacterBody2D

const BONE = preload("res://prefabs/bones.tscn")

var move\_speed := 30

var direction := 1

var health\_points := 3

@onready var sprite = $sprite

@onready var anim = $anim

@onready var ground\_detector = $ground\_detector

@onready var player\_detector = $player\_detector

@onready var bone\_spawn\_point = $bone\_spawn\_point

@onready var hurt\_sprite = $sprite/hurt\_sprite

enum EnemyState {PATROL, ATTACK, HURT}

var current\_state = EnemyState.PATROL

@export var target := CharacterBody2D

func \_physics\_process(delta):

`	`match (current\_state):

`		`EnemyState.PATROL : patrol\_state()

`		`EnemyState.ATTACK : attack\_state()

func patrol\_state():

`	`anim.play("limping")

`	`if is\_on\_wall():

`		`flip\_enemy()

`	`if not ground\_detector.is\_colliding():

`		`flip\_enemy()

`	`velocity.x = move\_speed \* direction

`	`if player\_detector.is\_colliding():

`		`\_change\_state(EnemyState.ATTACK)

`	`move\_and\_slide()

func attack\_state():

`	`anim.play("attack")

`	`if not player\_detector.is\_colliding():

`		`\_change\_state(EnemyState.PATROL)

func hurt\_state():

`	`anim.play("hurt")

`	`hurt\_sprite.visible = true

`	`await get\_tree().create\_timer(0.3).timeout

`	`hurt\_sprite.visible = false

`	`if health\_points > 1:

`		`health\_points -= 1

`		`print("Inimigo tomou dano")

`		`\_change\_state(EnemyState.PATROL)

`	`else:

`		`dead\_state()

`		`await get\_tree().create\_timer(5).timeout

`		`revive\_state()

func dead\_state():

`	`anim.play("dead")

`	`$collision.disabled = true

`	`$hitbox/collision.disabled = true

`	`await  anim.animation\_finished

func revive\_state():

`	`anim.play("revive")

`	`$collision.disabled = false

`	`$hitbox/collision.disabled = false

`	`health\_points = 3

`	`await  anim.animation\_finished

`	`\_change\_state(EnemyState.PATROL)

func \_change\_state(state):

`	`current\_state = state

func flip\_enemy():

`	`direction \*= -1

`	`sprite.scale.x \*= -1

`	`player\_detector.scale.x \*= -1

`	`bone\_spawn\_point.position.x \*= -1

func spawn\_bone():

`	`var new\_bone = BONE.instantiate()

`	`if sign(bone\_spawn\_point.position.x) == 1:

`		`new\_bone.set\_direction(1)

`	`else:

`		`new\_bone.set\_direction(- 1)

`	`add\_sibling(new\_bone)

`	`new\_bone.global\_position = bone\_spawn\_point.global\_position

func \_on\_hitbox\_body\_entered(body):

`	`if current\_state != EnemyState.HURT:

`		`\_change\_state(EnemyState.HURT)

`		`hurt\_state()

Vamos quebrar o script do inimigo esqueleto em partes e explicar a lógica por trás de cada uma delas:

1. **Variáveis e constantes:**
   1. **BONE**: Constante que armazena a cena dos ossos.
   1. **move\_speed**: Velocidade de movimento do inimigo.
   1. **direction**: Direção do movimento do inimigo.
   1. **health\_points**: Pontos de vida do inimigo.
1. **Referências a nós da cena:**
   1. **sprite**, **anim**, **ground\_detector**, **player\_detector**, **bone\_spawn\_point**: Referências a diferentes nós da cena, como sprites, detectores de chão, jogador e ponto de spawn de ossos.
1. **Enumeração de estados do inimigo:**
   1. **EnemyState**: Enumeração dos estados do inimigo (patrulha, ataque, ferido).
   1. **current\_state**: Variável que armazena o estado atual do inimigo.
1. **\_physics\_process() function:**
   1. Esta função é chamada no processamento de física a cada quadro.
   1. Dependendo do estado atual do inimigo, chama diferentes funções para executar a lógica correspondente.
1. **Função de estado de patrulha (patrol\_state()):**
   1. Controla o comportamento de patrulha do inimigo.
   1. Alterna a direção do inimigo quando atinge uma parede ou um obstáculo.
   1. Move o inimigo na direção correta e verifica se o jogador está próximo para mudar para o estado de ataque.
1. **Função de estado de ataque (attack\_state()):**
   1. Controla o comportamento de ataque do inimigo.
   1. Verifica se o jogador não está mais detectado e volta ao estado de patrulha.
1. **Função de estado ferido (hurt\_state()):**
   1. Controla o comportamento quando o inimigo é ferido.
   1. Mostra uma animação de ferimento e diminui os pontos de vida.
   1. Retorna ao estado de patrulha se houver pontos de vida restantes, caso contrário, passa para o estado de morte.
1. **Função de estado morto (dead\_state()):**
   1. Controla o comportamento quando o inimigo está morto.
   1. Desabilita as colisões e espera até que a animação de morte seja concluída.
1. **Função de estado de reviver (revive\_state()):**
   1. Controla o comportamento quando o inimigo é revivido.
   1. Habilita as colisões, restaura os pontos de vida e espera até que a animação de reviver seja concluída.
1. **Função para mudar de estado (\_change\_state()):**
   1. Atualiza o estado atual do inimigo.
1. **Função para virar o inimigo (flip\_enemy()):**
   1. Inverte a direção do inimigo e seus sprites relacionados.
1. **Função para gerar ossos (spawn\_bone()):**
   1. Instancia um osso na cena, definindo sua direção com base na posição do ponto de spawn.
1. **\_on\_hitbox\_body\_entered() function:**
   1. É chamada quando o corpo colide com outro corpo.
   1. Se o inimigo não estiver atualmente ferido, muda seu estado para ferido e executa a função **hurt\_state()**.

Essa estrutura de script controla o comportamento do inimigo esqueleto, permitindo que ele patrulhe, ataque, seja ferido, morra e reviva, fornecendo uma interação dinâmica com o jogador no jogo.


