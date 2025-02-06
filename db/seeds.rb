puts "Iniciando povoamento do banco..."

# Criando departamentos, se ainda não existirem
departments = [ "Ciência da Computação", "Engenharia Elétrica", "Matemática" ].map do |name|
  Department.find_or_create_by!(name: name)
end
puts "Departamentos criados!"

# Criando usuários (alunos, professores e admin)
users = []

# Criando 5 usuários alunos, se ainda não existirem
5.times do |i|
  student = User.find_or_initialize_by(email: "aluno#{i + 1}@email.com")
  if student.new_record?
    student.matricula = "20250#{i + 1}"
    student.nome = "Aluno #{i + 1}"
    student.role = :student  # Utilizando o símbolo definido no enum
    student.password = "123456"
    student.password_confirmation = "123456"
    student.confirmed_at = Time.now
    student.highest_degree = "Bacharelado"
    student.active_degree = "CANNABIS/CASESO"
    student.save!
    users << student
    puts "Aluno criado: #{student.email} | Senha: 123456"
  else
    puts "Aluno já existe: #{student.email}"
  end
  rescue ActiveRecord::RecordInvalid => e
    puts "Erro ao criar registro: #{e.record.errors.full_messages}"
    raise e
  end

# Criando 2 usuários professores, se ainda não existirem
professors = []
2.times do |i|
  teacher = User.find_or_initialize_by(email: "professor#{i + 1}@email.com")
  if teacher.new_record?
    teacher.matricula = "PROF#{i + 1}"
    teacher.nome = "Professor #{i + 1}"
    teacher.password = "123456"
    teacher.password_confirmation = "123456"
    teacher.confirmed_at = Time.now
    teacher.role = :teacher
    teacher.highest_degree = "Doutorado"
    teacher.active_degree = "POSDOC"
    teacher.department = departments.sample
    teacher.save!
    professors << teacher
    users << teacher
    puts "Professor criado: #{teacher.email} | Senha: 123456"
  else
    puts "Professor já existe: #{teacher.email}"
  end
end

# Criando 1 administrador, se ainda não existir
admin = User.find_or_initialize_by(email: "admin@email.com")
if admin.new_record?
  admin.matricula = "ADMIN01"
  admin.nome = "Administrador"
  admin.password = "123456"
  admin.password_confirmation = "123456"
  admin.confirmed_at = Time.now
  admin.role = :admin
  admin.save!
  users << admin
  puts "Administrador criado: #{admin.email} | Senha: 123456"
else
  puts "Administrador já existe: #{admin.email}"
end

puts "Usuários criados!"

# Criando coordenadores para os professores, associando cada um a um departamento (pela ordem dos índices)
professors.each_with_index do |professor, index|
  department = departments[index] # Associa o coordenador ao departamento com o mesmo índice
  coordinator = Coordinator.find_or_initialize_by(user: professor)
  if coordinator.new_record?
    coordinator.department = department
    coordinator.save!
    puts "Coordenador para o departamento #{department.name} criado!"
  else
    puts "Coordenador para o departamento #{department.name} já existe!"
  end
end
puts "Coordenadores criados!"

# Criando disciplinas (subjects), se ainda não existirem
subjects = []
departments.each do |dept|
  2.times do |i|
    subject = Subject.find_or_initialize_by(name: "Disciplina #{i + 1} - #{dept.name}")
    if subject.new_record?
      subject.code = "D#{dept.id}#{i + 1}"
      subject.department = dept
      subject.user = User.find_or_initialize_by(email: "professor#{i + 1}@email.com")
      subject.save!
      subjects << subject
      puts "Disciplina criada: #{subject.name}"
    else
      puts "Disciplina já existe: #{subject.name}"
      subjects << subject
    end
  end
end
puts "Disciplinas criadas!"

# Criando turmas (classrooms), se ainda não existirem
classrooms = []
subjects.each do |subject|
  2.times do |i|
    # Usando um código baseado no id da disciplina e em um sufixo
    classroom = Classroom.find_or_initialize_by(code: "T#{subject.id}A")
    if classroom.new_record?
      def generate_subject_time
        days = (1..6).to_a.sample(2).sort.join # Randomly selects 2 different days
        period = [ 'M', 'T', 'N' ].sample         # Randomly selects a time period
        slots = (1..6).to_a.sample(2).sort.join # Randomly selects 2 class slots
        "#{days}#{period}#{slots}"
      end
      classroom.time = generate_subject_time
      classroom.semester = "2025/1"
      classroom.subject = subject
      classroom.save!

      classrooms << classroom
      puts "Turma criada: #{classroom.code}"
    else
      puts "Turma já existe: #{classroom.code}"
      classrooms << classroom
    end
  end
end
puts "Turmas criadas!"

# Criando matrículas (enrollments) de alunos nas turmas, se ainda não existirem
users.select { |u| u.role.to_s == "student" }.each do |student|
  classrooms.each do |classroom|
    enrollment = Enrollment.find_or_initialize_by(user: student, classroom: classroom)
    if enrollment.new_record?
      enrollment.save!
      puts "Matrícula criada para o aluno #{student.nome} na turma #{classroom.code}"
    else
      puts "Matrícula para o aluno #{student.nome} já existe na turma #{classroom.code}"
    end
  end
end
puts "Matrículas criadas!"

# Criando templates de questionários, se ainda não existirem
templates = []
2.times do |i|
  template = Template.find_or_initialize_by(name: "Template #{i + 1}")
  if template.new_record?
    template.target_audience = "Alunos"
    template.semester = "2025/1"
    template.save!
    templates << template
    puts "Template criado: #{template.name}"
  else
    puts "Template já existe: #{template.name}"
    templates << template
  end
end
puts "Templates criados!"

# Criando questionários, se ainda não existirem
questionnaires = []
classrooms.each do |classroom|
  questionnaire = Questionnaire.find_or_initialize_by(name: "Questionário - #{classroom.code}")
  if questionnaire.new_record?
    questionnaire.classroom_info = "Turma #{classroom.code}"
    questionnaire.template = templates.sample  # Seleciona um template aleatório
    questionnaire.save!
    questionnaires << questionnaire
    puts "Questionário criado para a turma #{classroom.code}"
  else
    puts "Questionário já existe para a turma #{classroom.code}"
    questionnaires << questionnaire
  end
end
puts "Questionários criados!"

# Criando perguntas associadas aos templates, se ainda não existirem
# Como o schema indica que a pergunta pertence a um template, criamos perguntas para cada template
questions = []
templates.each do |template|
  3.times do |i|
    question = Question.find_or_initialize_by(name: "Pergunta #{i + 1}", template: template)
    if question.new_record?
      question.text = "Texto da pergunta #{i + 1}"
      question.question_type = "Múltipla escolha"
      question.save!
      questions << question
      puts "Pergunta criada: #{question.name} para o template #{template.name}"
    else
      puts "Pergunta já existe: #{question.name} para o template #{template.name}"
      questions << question
    end
  end
end
puts "Perguntas criadas!"

# Criando opções de resposta (question_options), se ainda não existirem
questions.each do |question|
  3.times do |i|
    option = QuestionOption.find_or_initialize_by(name: "Opção #{i + 1}", question: question)
    if option.new_record?
      option.text = "Opção de resposta #{i + 1}"
      option.save!
      puts "Opção de resposta criada para a pergunta #{question.name}"
    else
      puts "Opção de resposta já existe para a pergunta #{question.name}"
    end
  end
end
puts "Opções de resposta criadas!"

# Criando submissões (submissions), se ainda não existirem
submissions = []
users.select { |u| u.role.to_s == "student" }.each do |student|
  questionnaires.each do |questionnaire|
    submission = Submission.find_or_initialize_by(user: student, questionnaire: questionnaire)
    if submission.new_record?
      submission.save!
      submissions << submission
      puts "Submissão criada para o aluno #{student.nome} no questionário #{questionnaire.name}"
    else
      puts "Submissão já existe para o aluno #{student.nome} no questionário #{questionnaire.name}"
      submissions << submission
    end
  end
end
puts "Submissões criadas!"

# Criando respostas (answers), se ainda não existirem
# Utilizamos as perguntas associadas ao template do questionário da submissão
submissions.each do |submission|
  submission.questionnaire.template.questions.each do |question|
    answer = Answer.find_or_initialize_by(question: question, questionnaire: submission.questionnaire)
    if answer.new_record?
      answer.value = "Resposta escolhida"
      answer.save!
      puts "Resposta criada para a pergunta #{question.name} no questionário #{submission.questionnaire.name}"
    else
      puts "Resposta já existe para a pergunta #{question.name} no questionário #{submission.questionnaire.name}"
    end
  end
end
puts "Respostas criadas!"

puts "Banco de dados populado com sucesso!"
