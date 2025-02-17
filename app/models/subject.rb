# app/models/subject.rb
#
# Modelo que representa um assunto (disciplina) de um departamento.
# O assunto está associado a um departamento específico e pode ter várias salas de aula associadas.
# Cada assunto possui um nome e código exclusivos, e sua validade é garantida por validações.
#
# == Associações
#
# - +belongs_to :department+ - Indica que um assunto pertence a um departamento específico.
#   Cada assunto está associado a um departamento, representando a área ou departamento acadêmico que oferece a disciplina.
#
# - +has_many :classrooms+ - Indica que um assunto pode ter várias salas de aula associadas a ele.
#   Cada assunto pode ser oferecido em várias turmas, cada uma representada por uma sala de aula.
#
# == Validações
#
# - +validates :name, :code, presence: true+ - Garante que o nome e o código do assunto sejam fornecidos.
#   Essas validações são importantes para garantir que cada assunto tenha identificadores válidos.
#
# - +validates_uniqueness_of :code+ - Garante que o código do assunto seja único no banco de dados.
#   Essa validação impede que dois assuntos tenham o mesmo código, assegurando a unicidade.
#
# == Exemplo de código:
# subject = Subject.new(name: "Matemática", code: "MAT101", department: some_department)
# subject.save
#

class Subject < ApplicationRecord
  # Relacionamento com o modelo Department
  belongs_to :department

  # Relacionamento com o modelo Classroom
  has_many :classrooms, dependent: :destroy

  # Validações para garantir que o nome e o código do assunto sejam fornecidos
  validates :name, :code, presence: true

  # Validação para garantir que o código seja único dentro do banco de dados
  validates_uniqueness_of :code
end
