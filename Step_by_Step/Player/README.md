# Passo a passo para fazer o Personagem

![Personagem](/../main/images/laranja.png)

## Pacote de sprites utilizadas:   
[Anokolisa - Legacy Fantasy Bundle](https://anokolisa.itch.io/sidescroller-pixelart-sprites-asset-pack-forest-16x16)  
[GrafxKid - Sprite Pack 6](https://grafxkid.itch.io/sprite-pack-6)  

#### Necessário download da [Godot 4.2](https://godotengine.org/download/windows/)  para abrir o projeto e poder executar, modificar e criar.

## Descrição do personagem:

- Não possui super poderes;
- Sofre dano quando o inimigo ou projétil o atingem;
- Seus estados de animação são: parado, andando e ferido.

### A árvore de nós da cena do Personagem ficou assim:

![Árvore de nós do Personagem](/../main/images/arvore_nos_player.png)

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

O nó da câmera (Camera2D) estará na cena principal do nível e não na cena do Personagem. Ao colocar o nó camera2D como filho do Personagem, podem ocorrer problemas, como por exemplo na morte do Personagem a câmera se perde, pois o nó raiz do qual ela era filha foi removido do cenário, mas estando a câmera na cena principal do nível, ela continuará funcionando corretamente mesmo que ocorra a morte do Personagem.
Para fazer a câmera seguir o Personagem é muito fácil








