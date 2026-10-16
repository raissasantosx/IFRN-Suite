# Módulo Refeitório (Grupo 8)

Gerencia o cardápio do refeitório (`Menu`) e as solicitações de refeição
(`SolicitacaoDeRefeicao`). Módulo independente, sem dependência de outros pacotes.

## Como integrar em um projeto
1. Copie a pasta `refeitorio/` para a raiz do projeto.
2. No `pubspec.yaml` do projeto, adicione `refeitorio: {path: refeitorio}`.
3. No `bin/ifrn.dart`, adicione o import e a linha do menu:
   - `import 'package:refeitorio/refeitorio.dart' show Refeitorio;`
   - `opcoes += Refeitorio.menu;`

## Permissões
- `admin`: cadastrar, atualizar e excluir cardápios.
- Sem permissão especial: listar cardápios, solicitar/cancelar refeição e consultar status.

## Validação de entradas
Datas (`dd/mm/aaaa`), IDs e respostas `s/n` inválidos, IDs inexistentes ou
negativos e textos sem letras são recusados com mensagem, sem encerrar o programa.

## Testes
`cd refeitorio && dart pub get && dart test`
