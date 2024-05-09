# Construindo o inimigo esqueleto

![Inimigo Esqueleto](/../main/images/esqueleto.png)

## Descrição do inimigo:

- Esse inimigo não morre, ressurge após 3 segundos;
- Sofre dano quando o jogador pula na cabeça dele;
- Detecta o jogador através do nó *RayCast2D*;
- Não sobre ação da gravidade;
- No ataque, lança um osso em direção ao jogador;
- Seus estados são: patrulha, ataque, ferido, morrendo e ressurgindo.

### A árvore de nós da cena do inimigo esqueleto ficou assim:

![Árvore de nós da cena do inimigo esqueleto](/../main/images/arvore_nos.png)

O nó **anim** (AnimationPLayer) possui as seguintes animações:

- “***limping***”: movimento de patrulha;
- “***attack***”: estado de ataque ao detectar o jogador. Fica parado enquanto lança ossos (lançamento dos ossos é uma cena e código a parte);
- “***hurt***”: estado de ferido ao receber dano do jogador. O inimigo para por um tempo determinado e muda a cor para vermelho, dando assim um retorno visual para quem joga que houve dano no inimigo (o nó “***hurt_sprite***” será usado exatamente para isso);
- “***dead***”: Após receber 3 danos do jogador, o esqueleto muda seu estado para morto, mas como dito anteriormente, ele não morre. Após um tempo determinado ele retorna chamando assim o próximo estado. A animação é de todos os seus ossos se desmontando;
- “***revive***”: Passado o tempo após morto, a animação dele levantando é chamada. Suas vidas retornam e ele continua a patrulha.

> [!WARNING]
> Nenhuma dessas animações tem seu Autoplay ativado. Caso você ative o Autoplay para alguma animação, isso poderá acarretar em conflito com a máquina de estados do esqueleto que será feita no script dele.

**Posicionamento dos nós em relação ao esqueleto:**

![Posicionamento de alguns nós da cena em relação ao esqueleto](/../main/images/posicionamento_nos.png)

O nó *hurt_sprite* deve ter sua visibilidade desativada, pois a ativação se dará por código somente quando o jogador causar dano no esqueleto. Neste nó, basta adicionar o Sprite de dano em Texture na aba Inspector, fazer as modificações em Animation e mudar a cor para vermelho em Visibility: Self Modulate. 

O nó hitbox pode ser criado em um cena a parte, como eu fiz, ou simplesmente criado diretamente dentro da cena do esqueleto. Independe de como fizer, crie um script para esse nó e adicione a ele o sinal “body_entered()”. O script será:

```gd
extends Area2D

func _on_body_entered(body):
if body.name == "payer":
   body.velocity.y = body.jump_velocity_knockback
```

Antes de iniciarmos o script do esqueleto, é necessário criar uma nova cena para o osso que ele jogará no ataque, ajustando suas configurações e programação.

A cena é bem simples, contém somente 3 nós:

![Árvore de nós da cena bones](/../main/images/bones_nos.png)

- CharacterBody2D
   - CollisionShape2D
   - AnimatedSprite2D

No nó “anim”, a animação é do osso girando, com o Looping e Autoplay ativados.

Agora é só adicionar o script ao nó raiz “bones” e programar!

### Segue abaixo o script do nó “bones”:

```gd
extends CharacterBody2D

var move_speed := 50.0
var direction := 1
var time_start = 0
var time_now = 0
var dist = 0

func _ready():
   time_start = Time.get_unix_time_from_system()

func _process(delta):
   position.x += move_speed * direction * delta
   dist += abs(move_speed * direction * delta)
   time_now = Time.get_unix_time_from_system()
   var time_elapsed = time_now - time_start
   if dist > 250 or time_elapsed > 5:
      queue_free()

func set_direction(dir):
   direction = dir
   if dir < 0:
      $anim.flip_h = true
   else: 
      $anim.flip_h = false
```

### Vamos quebrar o script do nó **bones** em partes e explicar a lógica por trás de cada uma delas::

1. **Declaração de variáveis:**
   - **move\_speed**: Velocidade de movimento do osso.
   - **direction**: Direção do movimento do osso, inicialmente definida como 1 (direita).
   - **time\_start**: Tempo inicial desde o sistema operacional.
   - **time\_now**: Tempo atual desde o sistema operacional.
   - **dist**: Distância percorrida pelo osso.
1. **\_ready() function:**
   - Esta função é chamada automaticamente quando o nó é adicionado ao nó da cena.
   - **time\_start** é definido como o tempo atual do sistema, marcando o início do movimento do osso.
1. **\_process() function:**
   - Esta função é chamada a cada quadro.
   - O osso se move horizontalmente com uma velocidade definida por **move\_speed** e **direction**.
   - **dist** é incrementado com a distância percorrida a cada quadro.
   - **time\_now** é atualizado para o tempo atual do sistema.
   - **time\_elapsed** representa o tempo decorrido desde que o osso começou a se mover. É calculado como a diferença entre **time\_now** e **time\_start**.
   - Se a distância percorrida (**dist**) for maior que 250 pixels OU o tempo decorrido (**time\_elapsed**) for maior que 5 segundos: O osso é destruído (**queue\_free()** é chamado).
1. **set\_direction() function:**
   - Esta função é usada para definir a direção do movimento do osso.
   - Recebe um parâmetro **dir** que indica a direção (1 para direita, -1 para esquerda).
   - Atualiza a variável **direction** de acordo com o parâmetro fornecido.
   - Se **direction** for menor que 0, o osso é girado horizontalmente para a esquerda (**flip\_h** é definido como **true**), caso contrário, ele é girado para a direita (**flip\_h** é definido como **false**).

Essencialmente, este código define o comportamento de movimento e destruição do osso, bem como sua orientação horizontal. 

Agora vejamos o script do esqueleto. Adicione ao nó skeleton(CharacterBody2D) um novo script. Vamos adicionar o sinal body\_entered() do nó hitbox(Area2D)  ao script skeleton. Adicionado ao script a nova função, veremos em seguida o seu conteúdo.

### Script do skeleton:

```gd
extends CharacterBody2D

const BONE = preload("res://prefabs/bones.tscn")
var move_speed := 30
var direction := 1
var health_points := 3

@onready var sprite = $sprite
@onready var anim = $anim
@onready var ground_detector = $ground_detector
@onready var player_detector = $player_detector
@onready var bone_spawn_point = $bone_spawn_point
@onready var hurt_sprite = $sprite/hurt_sprite

enum EnemyState {PATROL, ATTACK, HURT}
var current_state = EnemyState.PATROL
@export var target := CharacterBody2D

func _physics_process(delta):
   match (current_state):
      EnemyState.PATROL : patrol_state()
      EnemyState.ATTACK : attack_state()

func patrol_state():
   anim.play("limping")
   if is_on_wall():
      flip_enemy()
   if not ground_detector.is_colliding():
      flip_enemy()
   velocity.x = move_speed * direction
   if player_detector.is_colliding():
      _change_state(EnemyState.ATTACK)
   move_and_slide()

func attack_state():
   anim.play("attack")
   if not player_detector.is_colliding():
      _change_state(EnemyState.PATROL)

func hurt_state():
   anim.play("hurt")
   hurt_sprite.visible = true
   await get_tree().create_timer(0.3).timeout
   hurt_sprite.visible = false
   if health_points > 1:
      health_points -= 1
      print("Inimigo tomou dano")
      _change_state(EnemyState.PATROL)
   else:
      dead_state()
      await get_tree().create_timer(5).timeout
      revive_state()

func dead_state():
   anim.play("dead")
   $collision.disabled = true
   $hitbox/collision.disabled = true
   await  anim.animation_finished

func revive_state():
   anim.play("revive")
   $collision.disabled = false
   $hitbox/collision.disabled = false
   health_points = 3
   await  anim.animation_finished
   _change_state(EnemyState.PATROL)

func _change_state(state):
   current_state = state

func flip_enemy():
   direction *= -1
   sprite.scale.x *= -1
   player_detector.scale.x *= -1
   bone_spawn_point.position.x *= -1

func spawn_bone():
   var new_bone = BONE.instantiate()
   if sign(bone_spawn_point.position.x) == 1:
      new_bone.set_direction(1)
   else:
      new_bone.set_direction(- 1)
   add_sibling(new_bone)
   new_bone.global_position = bone_spawn_point.global_position

func _on_hitbox_body_entered(body):
   if current_state != EnemyState.HURT:
      _change_state(EnemyState.HURT)
      hurt_state()
```

### Vamos quebrar o script do inimigo esqueleto em partes e explicar a lógica por trás de cada uma delas:

1. **Variáveis e constantes:**
   - **BONE**: Constante que armazena a cena dos ossos.
   - **move\_speed**: Velocidade de movimento do inimigo.
   - **direction**: Direção do movimento do inimigo.
   - **health\_points**: Pontos de vida do inimigo.
1. **Referências a nós da cena:**
   - **sprite**, **anim**, **ground\_detector**, **player\_detector**, **bone\_spawn\_point**: Referências a diferentes nós da cena, como sprites, detectores de chão, jogador e ponto de spawn de ossos.
1. **Enumeração de estados do inimigo:**
   - **EnemyState**: Enumeração dos estados do inimigo (patrulha, ataque, ferido).
   - **current\_state**: Variável que armazena o estado atual do inimigo.
1. **\_physics\_process() function:**
   - Esta função é chamada no processamento de física a cada quadro.
   - Dependendo do estado atual do inimigo, chama diferentes funções para executar a lógica correspondente.
1. **Função de estado de patrulha (patrol\_state()):**
   - Controla o comportamento de patrulha do inimigo.
   - Alterna a direção do inimigo quando atinge uma parede ou um obstáculo.
   - Move o inimigo na direção correta e verifica se o jogador está próximo para mudar para o estado de ataque.
1. **Função de estado de ataque (attack\_state()):**
   - Controla o comportamento de ataque do inimigo.
   - Verifica se o jogador não está mais detectado e volta ao estado de patrulha.
1. **Função de estado ferido (hurt\_state()):**
   - Controla o comportamento quando o inimigo é ferido.
   - Mostra uma animação de ferimento e diminui os pontos de vida.
   - Retorna ao estado de patrulha se houver pontos de vida restantes, caso contrário, passa para o estado de morte.
1. **Função de estado morto (dead\_state()):**
   - Controla o comportamento quando o inimigo está morto.
   - Desabilita as colisões e espera até que a animação de morte seja concluída.
1. **Função de estado de reviver (revive\_state()):**
   - Controla o comportamento quando o inimigo é revivido.
   - Habilita as colisões, restaura os pontos de vida e espera até que a animação de reviver seja concluída.
1. **Função para mudar de estado (\_change\_state()):**
   - Atualiza o estado atual do inimigo.
1. **Função para virar o inimigo (flip\_enemy()):**
   - Inverte a direção do inimigo e seus sprites relacionados.
1. **Função para gerar ossos (spawn\_bone()):**
   - Instancia um osso na cena, definindo sua direção com base na posição do ponto de spawn.
1. **\_on\_hitbox\_body\_entered() function:**
   - É chamada quando o corpo colide com outro corpo.
   - Se o inimigo não estiver atualmente ferido, muda seu estado para ferido e executa a função **hurt\_state()**.

Essa estrutura de script controla o comportamento do inimigo esqueleto, permitindo que ele patrulhe, ataque, seja ferido, morra e reviva, fornecendo uma interação dinâmica com o jogador no jogo.


