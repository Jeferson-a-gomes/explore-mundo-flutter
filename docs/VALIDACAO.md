# Validação e limites

## Executado em 14/11/2026

- PASS: busca sem acentos.
- PASS: busca sem distinção de maiúsculas.
- PASS: busca por múltiplos termos.
- PASS: consulta sem resultados.
- PASS: catálogo completo com consulta vazia.
- PASS: formatação monetária em reais.
- PASS: formatação do valor zero.
- PASS: separador de milhares em valores grandes.
- PASS: identificadores únicos.
- Formatador Dart aplicado aos 5 arquivos.
- Existência e decodificação dos 3 assets JPEG verificadas.
- PDF renderizado e revisado visualmente.

## Pendente de execução Flutter

Não foi possível executar `flutter analyze`, `flutter test`, `flutter build web` nem abrir o aplicativo neste ambiente. A inicialização do SDK foi bloqueada pela revisão automática devido a uma tentativa de acesso a metadados da infraestrutura. Essa restrição não comprova um defeito no código, mas impede afirmar que a interface foi validada em execução. O workflow do GitHub fará as verificações completas quando o projeto for publicado.

## Roteiro manual para navegador e Android

1. Abrir o app: verificar banner, cabeçalho e navegação.
2. Tocar no banner: conferir imagem, título, localização, estrelas, botões e texto.
3. Pesquisar "SUICA": apenas Refúgio dos Lagos; pesquisar "lua": nenhum resultado; limpar: restaurar catálogo.
4. Testar tela estreita (320 px), largura de tablet e desktop, com rolagem até o fim.
5. Favoritar um destino, voltar e reabrir: estado mantido na sessão.
6. Copiar resumo: colar em editor e conferir o texto; verificar a permissão da área de transferência no navegador, se solicitada.
7. Simular reserva com campos vazios: ver erros; preencher dados fictícios, selecionar viajantes e conferir o total.
8. Cancelar uma reserva: não deve adicionar uma solicitação.
9. Confirmar uma reserva: conferir mensagem e lista em Pacotes de viagem.
10. Publicar comentário vazio: ver mensagem; publicar comentário válido: mostrar na lista.
11. Enviar contato inválido: ver erros; preencher dados fictícios: mostrar confirmação sem envio real.
12. Recarregar: confirmar que os dados da sessão são descartados, como avisado pela interface.

Nenhum item desta lista manual está marcado como executado sem evidência.
