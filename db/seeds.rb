puts "Iniciando povoamento do banco..."

  # Criando departamentos, se ainda não existirem
  departments = ["Ciência da Computação", "Engenharia Elétrica", "Matemática"].map do |name|
    Department.find_or_create_by!(name: name)
  end
  puts "Departamentos criados!"
  
  # Criando usuários (alunos, professores e admin)
  users = []
  
  # Criando 5 alunos
  5.times do |i|
    users << User.find_or_create_by!(
      email: "aluno#{i + 1}@email.com"
    ) do |student|
      student.assign_attributes(
        matricula: "20250#{i + 1}",
        nome: "Aluno #{i + 1}",
        role: :student,
        password: "123456",
        password_confirmation: "123456",
        confirmed_at: Time.now,
        highest_degree: "Bacharelado",
        active_degree: "Ciência da Computação"
      )
      puts "Aluno criado: #{student.email}"
    end
  end
  
  # Criando 2 professores
  professors = []
  2.times do |i|
    professors << User.find_or_create_by!(
      email: "professor#{i + 1}@email.com"
    ) do |teacher|
      teacher.assign_attributes(
        matricula: "PROF#{i + 1}",
        nome: "Professor #{i + 1}",
        role: :teacher,
        password: "123456",
        password_confirmation: "123456",
        confirmed_at: Time.now,
        highest_degree: "Doutorado",
        active_degree: "POSDOC",
        department: departments.sample
      )
      puts "Professor criado: #{teacher.email}"
    end
  end
  
  # Criando Administrador
  User.find_or_create_by!(email: "admin@email.com") do |admin|
    admin.assign_attributes(
      matricula: "ADMIN01",
      nome: "Administrador",
      role: :admin,
      password: "123456",
      password_confirmation: "123456",
      confirmed_at: Time.now
    )
    puts "Administrador criado: #{admin.email}"
  end
  
  puts "Usuários criados!"
  
  # Criando coordenadores
  professors.each_with_index do |professor, index|
    Coordinator.find_or_create_by!(user: professor) do |coordinator|
      coordinator.department = departments[index % departments.length]
      puts "Coordenador criado para #{coordinator.department.name}"
    end
  end
  
  # Criando disciplinas
  subjects = []
  departments.each do |dept|
    2.times do |i|
      subjects << Subject.find_or_create_by!(
        name: "Disciplina #{i + 1} - #{dept.name}",
        department: dept
      ) do |subject|
        subject.code = "D#{dept.id}#{i + 1}"
        puts "Disciplina criada: #{subject.name}"
      end
    end
  end
  
  # Criando turmas
  classrooms = []
  subjects.each do |subject|
    classrooms << Classroom.find_or_create_by!(
      code: "T#{subject.id}A"
    ) do |classroom|
      classroom.assign_attributes(
        semester: "2025/1",
        subject: subject,
        time: "#{(1..6).to_a.sample(2).sort.join}#{["M", "T", "N"].sample}#{(1..5).to_a.sample(2).sort.join}",
        teacher: User.where(role: :teacher).order("RANDOM()").first
      )
      puts "Turma criada: #{classroom.code}"
    end
  end
  
  # Criando matrículas
  users.select { |u| u.role.to_s == "student" }.each do |student|
    classrooms.each do |classroom|
      Enrollment.find_or_create_by!(user: student, classroom: classroom) do
        puts "Aluno #{student.nome} matriculado em #{classroom.code}"
      end
    end
  end
  
  # Criando templates de questionários
  templates = []
  2.times do |i|
    templates << Template.find_or_create_by!(
      name: "Template #{i + 1}"
    ) do |template|
      template.assign_attributes(target_audience: "Alunos", semester: "2025/1")
      puts "Template criado: #{template.name}"
    end
  end
  
  # Criando questionários
  questionnaires = []
  classrooms.each do |classroom|
    questionnaires << Questionnaire.find_or_create_by!(
      name: "Questionário - #{classroom.code}"
    ) do |questionnaire|
      questionnaire.assign_attributes(
        classroom_info: "Turma #{classroom.code}",
        template: templates.sample
      )
      puts "Questionário criado: #{questionnaire.name}"
    end
  end
  
  # Criando perguntas
  questions = []
  templates.each do |template|
    3.times do |i|
      questions << Question.find_or_create_by!(
        name: "Pergunta #{i + 1}",
        template: template
      ) do |question|
        question.assign_attributes(
          text: "Texto da pergunta #{i + 1}",
          question_type: "Múltipla escolha"
        )
        puts "Pergunta criada: #{question.name}"
      end
    end
  end
  
  # Criando opções de resposta fixas
  options_texts = ["Muito bom", "Bom", "Satisfatório", "Ruim", "Péssimo"]
  
  questions.each do |question|
    options_texts.each do |option_text|
      QuestionOption.find_or_create_by!(
        text: option_text,
        question: question
      ) do
        puts "Opção '#{option_text}' criada para #{question.name}"
      end
    end
  end
  
  # Criando submissões
  submissions = []
  users.select { |u| u.role.to_s == "student" }.each do |student|
    questionnaires.each do |questionnaire|
      submissions << Submission.find_or_create_by!(
        user: student,
        questionnaire: questionnaire
      ) do |submission|
        puts "Submissão criada: #{submission.id}"
      end
    end
  end
  
  # Criando respostas
  submissions.each do |submission|
    submission.questionnaire.template.questions.each do |question|
      Answer.find_or_create_by!(
        question: question,
        questionnaire: submission.questionnaire,
        submission: submission
      ) do |answer|
        answer.value = "Resposta escolhida"
        puts "Resposta criada: #{answer.value}"
      end
    end
  end
  
  puts "Banco de dados populado com sucesso!"
  