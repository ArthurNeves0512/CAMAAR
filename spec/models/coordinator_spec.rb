require 'rails_helper'

RSpec.describe Coordinator, type: :model do
  # Criar instâncias de User e Department manualmente para usar nos testes
  let(:user) { User.create(nome: "John Doe", matricula: "12345", email: "john.doe@example.com", password: "password", role: 0) }
  let(:department) { Department.create(name: "Departamento de TI") }

  # Testar as associações manualmente
  it 'belongs to user' do
    association = Coordinator.reflect_on_association(:user)
    expect(association.macro).to eq(:belongs_to)
  end

  it 'belongs to department' do
    association = Coordinator.reflect_on_association(:department)
    expect(association.macro).to eq(:belongs_to)
  end

  # Testar a criação de um Coordinator com as associações
  context 'when creating a coordinator' do
    it 'is valid with a user and a department' do
      coordinator = Coordinator.new(user: user, department: department)
      expect(coordinator).to be_valid
    end

    it 'is invalid without a user' do
      coordinator = Coordinator.new(user: nil, department: department)
      expect(coordinator).to_not be_valid
      expect(coordinator.errors[:user]).to include("não pode ficar em branco")
    end

    it 'is invalid without a department' do
      coordinator = Coordinator.new(user: user, department: nil)
      expect(coordinator).to_not be_valid
      expect(coordinator.errors[:department]).to include("não pode ficar em branco")
    end
  end
end
