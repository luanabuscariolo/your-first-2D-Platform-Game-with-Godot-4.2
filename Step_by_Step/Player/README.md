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




