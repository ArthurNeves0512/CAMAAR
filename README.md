# Sprint 3 - Refatoração e Documentação do Código

Este documento apresenta as informações referentes à Sprint 3, cujo foco foi a refatoração e a documentação do código, conforme orientações do Capítulo 9 do livro *ESaaS, Edição 1.2.1*. 

---

## Informações do Grupo

- **Repositório**: [Link para o Repositório](https://github.com/seu-repositorio)
- **Integrantes**:
  - Cauã Lima  - Matrícula: 221018890
  - Mateus Lucas - Matrícula: 221000080
  - Ándre Filipe - Matrícula: 211020992
  - Gustavo Freitas - Matrícula: 202037669
  - Arthur Neves - Matrícula: 202014403

---

## Refatoração do Código

Foram realizadas refatorações em diversos controllers e classes de serviço. Abaixo, uma comparação entre os resultados antes e depois da refatoração:

### Alterações nos Controllers

| Controller                   | Linhas de Código | Métodos | Complexidade/Método | Churn | Complexidade Total | Duplicações |
|------------------------------|------------------|---------|---------------------|-------|--------------------|-------------|
| **Antes do Refatoramento**   |                  |         |                     |       |                    |             |
| ImportsController            | 269              | 12      | 30.4                | 9     | 365.01             | 174         |
| ReportsController            | 60               | 3       | 17.1                | 7     | 51.44              | 0           |
| **Após o Refatoramento**     |                  |         |                     |       |                    |             |
| ImportsController            | 42               | 1       | 21.5                | 14    | 21.51              | 0           |
| ReportsController            | 103              | 8       | 6.1                 | 11    | 48.47              | 0           |

### Alterações nas Classes de Serviço

| Classe de Serviço           | Linhas de Código | Métodos | Complexidade/Método | Churn | Complexidade Total | Duplicações |
|-----------------------------|------------------|---------|---------------------|-------|--------------------|-------------|
| ImportBuilder               | 106              | 8       | 6.1                 | 3     | 49.14              | 0           |
| ImportDataClasses           | 106              | 7       | 3.8                 | 3     | 26.52              | 0           |
| ImportParser                | 38               | 3       | 4.1                 | 3     | 12.2               | 0           |
| ImportService               | 64               | 6       | 5.3                 | 3     | 31.56              | 0           |
| ImportPopulator             | 11               | 1       | 3.5                 | 4     | 3.54               | 0           |
| SubjectProcessor            | 37               | 3       | 5.3                 | 2     | 15.79              | 0           |
| SubjectRepository           | 65               | 6       | 3.3                 | 4     | 20.08              | 0           |
| TeacherBuilder              | 12               | 1       | 1.0                 | 2     | 1.0                | 0           |
| TurmaProcessor              | 29               | 3       | 3.7                 | 2     | 11.22              | 0           |
| UserBuilder                 | 31               | 1       | 11.4                | 2     | 11.42              | 0           |
| EnrollmentHandler           | 40               | 4       | 2.9                 | 2     | 11.57              | 0           |
| ClassroomManager            | 23               | 1       | 10.7                | 3     | 10.71              | 0           |
| ClassroomBuilder            | 21               | 1       | 3.4                 | 2     | 3.35               | 0           |
| ClassBuilder                | 55               | 3       | 4.0                 | 3     | 12.14              | 0           |

---

## Observações Principais

- **ImportsController**: Após a refatoração, a complexidade foi significativamente reduzida, com o número de linhas diminuindo de 269 para 42.
- **ReportsController**: O refatoramento resultou em um aumento no número de linhas de código (de 60 para 103), mas houve uma redução na complexidade por método.
- **Classes de Serviço**: As alterações geraram serviços mais bem estruturados, com a maioria apresentando baixa complexidade por método e ausência de duplicações, o que contribui para uma melhor manutenibilidade.
- **Churn**: Alguns serviços, como `ImportPopulator` e `TeacherBuilder`, demonstraram um churn mais elevado, indicando que estes componentes sofreram mudanças mais frequentes.

---

## Conclusão

A Sprint 3 teve como foco principal a melhoria da qualidade do código por meio da refatoração e da atualização da documentação. Os resultados indicam que, apesar de alguns componentes terem aumentado o número de linhas, a complexidade geral e a duplicação foram significativamente reduzidas, alinhando o projeto às melhores práticas de desenvolvimento e manutenção.

