# Passo a passo de como fazer moedas coletáveis e um báu que abre após o jogador pegar a chave

![Personagem](/../main/images/collectables.gif)

### Pacote de sprites utilizadas:   
[Anokolisa - Legacy Fantasy Bundle](https://anokolisa.itch.io/sidescroller-pixelart-sprites-asset-pack-forest-16x16)  
[GrafxKid - Mini FX, Items & UI](https://grafxkid.itch.io/mini-fx-items-ui)  

#### Necessário download da [Godot 4.2](https://godotengine.org/download/windows/)  para abrir o projeto e poder executar, modificar e criar.

## Vamos iniciar com as moedas:
- As moedas são coletáveis pelo jogador após colisão (sem valor computado no momento);
- Após colidir com o personagem, a moeda desaparece com uma animação de partículas.

#### A árvore de nós da moeda é:
![Moeda](/../main/images/arvore_nos_coins.png)
