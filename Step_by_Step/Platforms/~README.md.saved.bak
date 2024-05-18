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

Essa plataforma inicia fixa, mas se há colisão entre ela e o jogador, então a plataforma cai e após um tempo predeterminado ela reaparece no mesmo lugar antes de cair. 

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


    









