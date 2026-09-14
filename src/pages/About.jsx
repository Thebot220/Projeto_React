function About() {
    return (
        <div className="paragrafo">
            <h1>Sobre o Trabalho</h1>
            <p className="text">
                A atividade "Lista de Tarefas" usa como princípio base o uso da ferramenta React para componentizar as
                funcionalidades e páginas deste sistema. Como você pode ver, também foi usado o ReactRouter para permitir uma navegação simples (e põe simples nisso kkkkk) entre duas páginas.
            </p>
            <p>
                A página principal, chamada de Lista de Tarefas, conta com as seguintes funcionalidades:
            </p>
            <ul>
                <div className="clist"> 
                    <li className="itemtext">
                        Adicionar Tarefa:
                    </li>
                    <p>Permite que você adicione uma tarefa à lista inserindo seu nome e categoria (infelizmente quando a página é recarregada os novos dados se perdem)</p>
                </div>
                <div className="clist">
                    <li className="itemtext">
                        Pesquisar Tarefa:
                    </li>
                    <p>Permite que você pesquise por uma tarefa da sua lista</p>
                </div>
                <div className="clist">
                    <li className="itemtext">
                        Lista Pendentes:
                    </li>
                    <p>Suas tarefas que ainda não foram completadas vão aparecer aqui</p>
                </div>
                <div className="clist">
                    <li className="itemtext">
                        Lista Concluídas:
                    </li>
                    <p>Suas tarefas que ainda que já foram completadas estarão aqui</p>
                </div>
            </ul>
        </div>
    )
}

export default About