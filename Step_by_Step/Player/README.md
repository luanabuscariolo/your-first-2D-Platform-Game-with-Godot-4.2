# Passo a passo para fazer o Personagem

![Personagem](/../main/images/player.gif)

## Pacote de sprites utilizadas:   
[Anokolisa - Legacy Fantasy Bundle](https://anokolisa.itch.io/sidescroller-pixelart-sprites-asset-pack-forest-16x16)  
[GrafxKid - Sprite Pack 6](https://grafxkid.itch.io/sprite-pack-6)  

#### Necessário download da [Godot 4.2](https://godotengine.org/download/windows/)  para abrir o projeto e poder executar, modificar e criar.

## Descrição do personagem:

- Não possui super poderes;
- Sofre dano quando colide com inimigo, projétil ou algo prejudiial;
- Seus estados de animação são: parado, andando e ferido (em breve atacando).

### A árvore de nós da cena do Personagem ficou assim:

![Árvore de nós do Personagem](/../main/images/arvore_player.png)

Vou reescrever a árvore aqui com os nomes de cada nó:
- CharacterBody2D
  - RemoteTransform2D
  - AnimatedSprite2D
  - CollisionShape2D
  - Area2D
    - CollisionShape2D

O nó **anim** (AnimatedSprite2D) possui as seguintes animações:

- “***idle***”: estado de espera (Autoplay ativado);
- “***walk***”: personagem caminha para esquerda ou direita apertando a tecla <kbd>←</kbd> ou <kbd>→</kbd>;
- “***hurt***”: estado de ferido ao receber dano de inimigo ou algo prejudicial para ele. Se desloca com um salto baseado na posição do inimigo;
- “***jump***”: estado de pulo apertando a tecla <kbd>space</kbd>.

## Física aplicada ao pulo do Personagem  

A lógica de física aplicada ao pulo do Personagem fornecidade pela Godot ao criar um script para um nó CharacterBody2D, não é a mecânica mais ideal. A imagem a seguir ilustra o pulo como uma parábola. Resumindo muito todas as contas que levam ao resultado de velocidade inicial e gravidade, utilizando esses cálculos temos um pulo com maior controle e sensibilidade, ainda não é a mecânica ideal, mas já é bem melhor do que um código básico disponibilizado na engine. Essas fórmulas aparecerão em nosso script mais para frente! :wink:

![Ilustração do pulo do personagem como uma parábola e as fórmulas para velocidade e gravidade](/../main/images/calculo_pulo.png)

## Nós de colisões do Personagem  

Na imagem, a cápsula Azul Claro é o primeiro “CollisionShape2D” e a caixa vermelha é o “CollisionShape2D” do “hurtbox”.

![Ilustração dos nós de colisão no personagem](/../main/images/player_colisoes.png)

## Configurando a Câmera para seguir o Personagem

O nó da câmera (Camera2D) estará na cena principal do nível e não na cena do Personagem. Ao colocar o nó camera2D como filho do Personagem, podem ocorrer problemas, como por exemplo na morte do Personagem a câmera se perde, pois o nó raiz do qual ela era filha foi removido do cenário, mas estando a câmera na cena principal do nível, ela continuará funcionando corretamente mesmo que ocorra a morte do Personagem. Na imagem a seguir exemplifica a cena do Mundo 01 e o nó World-01 que recebe um script:

![Árvore de nós da cena principal](/../main/images/tree_world1.png)

Para fazer a câmera seguir o Personagem é muito simples. No nó raiz da cena do primeiro nível do jogo (neste projeto é a cena World-01), adicionamos um script e o seguinte código nele:
```gd
extends Node2D

@onready var player = $"%player" as CharacterBody2D
@onready var camera = $camera as Camera2D

func _ready():
  player.follow_camera(camera)
```
Observações:
 - As variáveis "player" e "camera" são referências de nós da cena World-01.
 - Dentro da função _reay(), o método follow_camera(camera) chamado será criado no script do player.

Antes de iniciarmos toda a explicação do código, adicione ao script do player o sinal body_entered(body) do nó "hurtbox" (Area2D) assim: 
 - clique no nó "hurtbox";
 - na aba a direita terá Inspector / Node / History, clique em Node;
 - na aba signals clique 2x no sinal body_entered();
 - abrirá uma nova tela para você selecionar para qual script o sinal irá;
 - clique sobre o nó player e depois no botão **Connect**;
 - A função já estará no script do player, só confirmar! 

Pronto! Agora podemos ir para o script do nosso Personagem player.

## Código do Personagem:
```gd
extends CharacterBody2D

const SPEED = 150.0
const AIR_FRICTION := 0.5

var is_jumping := false
var direction
var is_hurted := false
var knockback_vector := Vector2.ZERO
var knockback_power := 20

var jump_velocity
var gravity
var fall_gravity
var jump_velocity_knockback := -340

@export var jump_height := 64
@export var max_time_to_peak := 0.5

@onready var remote = $remote as RemoteTransform2D
@onready var anim = $anim

signal player_has_died()

func _ready():	
  Globals.player_life = 10
  jump_velocity = (jump_height * 2) / max_time_to_peak
  gravity = (jump_height * 2) / pow(max_time_to_peak, 2)
  fall_gravity = gravity * 2

func _physics_process(delta):
  if not is_on_floor():
    velocity.x = 0
  if Input.is_action_just_pressed("ui_accept") and is_on_floor():
    velocity.y = -jump_velocity
    is_jumping = true
  elif is_on_floor():
    is_jumping = false
  if velocity.y > 0 or not Input.is_action_pressed("ui_accept"):
    velocity.y += fall_gravity * delta
  else:
    velocity.y += gravity * delta
	
  direction = Input.get_axis("ui_left", "ui_right")
  if direction:
    velocity.x = lerp(velocity.x, direction * SPEED, AIR_FRICTION)
    anim.scale.x = direction
  else:
    velocity.x = move_toward(velocity.x, 0, SPEED)
	
  if knockback_vector != Vector2.ZERO:
    velocity = knockback_vector
	
  _set_state()
  move_and_slide()

func follow_camera(camera):
  var camera_path = camera.get_path()
  remote.remote_path = camera_path

func _set_state():
  var state = "idle"
  if !is_on_floor():
    state = "jump"
  elif direction != 0:
    state = "walk"
  if anim.name != state:
    anim.play(state)

func _on_hurtbox_body_entered(body):
  var knockback = Vector2((global_position.x - body.global_position.x) * knockback_power, -200)
  call_deferred("take_damage", knockback)
	
  if body.is_in_group("bones"):
    body.queue_free()

func take_damage(knockback_force := Vector2.ZERO, duration := 0.25):
  if Globals.player_life > 0:
    Globals.player_life -= 1
    print("perdeu 1 vida")
    if knockback_force != Vector2.ZERO:
      knockback_vector = knockback_force
      var knockback_tween := get_tree().create_tween()
      if knockback_tween != null:
        knockback_tween.parallel().tween_property(self, "knockback_vector", Vector2.ZERO, duration)
        anim.modulate = Color(1,0,0,1)
        knockback_tween.parallel().tween_property(anim, "modulate", Color(1,1,1,1), duration)
      else:
        print("Erro: falha ao criar tweener!")
    is_hurted = true
    await get_tree().create_timer(.3).timeout
    is_hurted = false
  else:
    call_deferred("queue_free")
    emit_signal("player_has_died")
```
## Explicação do código do Personagem por partes:

1.  **Constantes e Variáveis:**
    -	**SPEED:** Define a velocidade máxima de movimento horizontal do personagem.
    -	**AIR_FRICTION:** Define a fricção do ar, usada para suavizar o movimento horizontal enquanto o personagem está no ar.
    -	**is_jumping:** Indica se o personagem está atualmente pulando.
    -	**direction:** Armazena a direção do movimento horizontal do personagem (-1 para esquerda, 1 para direita, 0 para parado).
    -	**is_hurted:** Indica se o personagem está atualmente machucado.
    -	**knockback_vector:** Vetor que armazena a força de knockback aplicada ao personagem quando ele é atingido.
    -	**knockback_power:** Define a potência do knockback.
    -	**jump_velocity:** Velocidade inicial do pulo calculada com base na altura máxima de salto e no tempo necessário para alcançar o pico do pulo.
    -	**gravity:** Força da gravidade aplicada ao personagem durante o pulo.
    -	**fall_gravity:** Força da gravidade aplicada ao personagem enquanto ele está caindo.
    -	**jump_height:** Altura máxima do pulo.
    -	**max_time_to_peak:** Tempo máximo para alcançar o pico do pulo.
    -	**remote:** Referência ao nó RemoteTransform2D utilizado para sincronizar a posição do personagem com a câmera.
    -	**anim:** Referência ao nó da animação do personagem.

1.	**Método _ready():**
    -	Inicializa variáveis globais relacionadas à vida do jogador.
    -	Calcula a velocidade inicial do pulo (jump_velocity), a gravidade (gravity) e a gravidade de queda (fall_gravity) com base nos parâmetros definidos.
  
1.	**Método _physics_process(delta):**
    -	Lida com a lógica de movimento do personagem e aplicação de forças de gravidade.
    -	Verifica se o personagem está no chão e se o botão de pulo foi pressionado para aplicar uma força de pulo.
    -	Atualiza a direção e velocidade do personagem com base na entrada do jogador.
    -	Lida com o knockback, se aplicável.
    -	Chama _set_state() para atualizar a animação do personagem.
    -	Move e desliza o personagem no mundo.

1.	**Método follow_camera(camera):**
    -	Método para configurar o nó RemoteTransform2D para seguir a câmera.
1.	**Método _set_state():**
    -	Atualiza o estado da animação do personagem com base em sua ação atual (parado, andando, pulando).
1.	**Método _on_hurtbox_body_entered(body):**
    -	Chamado quando o corpo de colisão do personagem colide com um objeto de dano.
    -	Calcula e aplica o knockback ao personagem.
    -	Se o objeto colidido pertence ao grupo "bones", ele é removido do jogo.
1.	**Método take_damage(knockback_force, duration):**
    -	Método para lidar com o dano recebido pelo personagem.
    -	Reduz a vida do jogador e aplica knockback se necessário.
    -	Se a vida do jogador chegar a zero, o personagem é destruído e um sinal player_has_died é emitido.








