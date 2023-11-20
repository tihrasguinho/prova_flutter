## Flutter Notes

Utilizei a versão mais recente do flutter 3.16 para esta tarefa.

Conforme solicitado os packages [shared_preferences](https://pub.dev/packages/shared_preferences) e [mobx](https://pub.dev/packages/mobx) foram utilizados para persistencia de dados e gerencia de estado respectivamente.

Para abrir páginas da web ao clicar no botão "Politica de Privacidade" utilizei o package [url_launcher](https://pub.dev/packages/url_launcher).

Utilizei do serviço [mockapi.io](https://mockapi.io) para simular uma API externa e para acessar a API utilizei o package [dio](https://pub.dev/packages/dio).

Para injeção de dependência utilizei o package [get_it](https://pub.dev/packages/get_it).

Na intenção de tornar este pequeno projeto o mais fiel a realidade, tomei a liberdade de criar na [mockapi.io](https://mockapi.io) uma estrutura de usuarios -> notas, no qual o usuário logado vê apenas suas notas. Utilizei o package [go_router](https://pub.dev/packages/go_router) para facilitar o redirecionamento de usuarios que não estejam logados para tela de login e o [connectivity_plus](https://pub.dev/packages/connectivity_plus) para verificar a conectividade do usuário, afim de tornar a experiência do usuário mais fiel a realidade. Nesta parte eu simulei os casos em que o usuário faz alguma alteração nas notas enquanto está sem conexão com a internet, e nesses casos quando ocorrer uma nova conexão os dados serão sincronizados.

#### Todos os packages utilizados tornam o app utilizavel no Android, iOS e Web!
