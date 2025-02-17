require_relative "import_builders"
require_relative "import_data_classes"

# == ClassBuilder
#
# A classe `ClassBuilder` é responsável por construir objetos de classes com base em registros de importação.
# Utiliza `ImportBuilders` para transformar dados brutos em objetos estruturados.
#
# == Métodos de Classe
#
# === `build_from_record(record)`
#
# Constrói um objeto de classe a partir de um registro fornecido.
#
# @param [Hash] record Um hash contendo os dados da turma.
# @return [Object] Retorna uma instância da classe construída com os dados fornecidos.
#
# === `build_with_staff(record)`
#
# Constrói uma turma a partir de um registro e adiciona um docente.
#
# @param [Hash] record Um hash contendo os dados da turma e do docente.
# @return [Object] Retorna a instância da classe com o docente associado.
#
# === `add_students(class_obj, students_data)`
#
# Adiciona estudantes à turma a partir de um conjunto de dados.
#
# @param [Object] class_obj A instância da classe à qual os estudantes serão adicionados.
# @param [Array<Hash>] students_data Lista de hashes contendo os dados dos estudantes.
# @return [Object] Retorna a instância da classe com os estudantes adicionados.
#
class ClassBuilder
  # Constrói uma turma a partir dos dados do registro
  def self.build_from_record(record)
    ImportBuilders.build_class(record)
  end

  # Constrói uma turma e adiciona um docente
  def self.build_with_staff(record)
    new_class = build_from_record(record)
    new_class.docente = ImportBuilders.build_teacher(record["docente"])
    new_class
  end

  # Adiciona estudantes a uma turma existente
  def self.add_students(class_obj, students_data)
    Array(students_data).each do |student|
      enrollment = ImportEnrollment.new
      enrollment.user = ImportBuilders.build_student(student)
      class_obj.add_alunos(enrollment)
    end
    class_obj
  end
end
