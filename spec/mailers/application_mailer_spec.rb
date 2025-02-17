require 'rails_helper'

RSpec.describe ApplicationMailer, type: :mailer do
  describe 'default settings' do
    let(:mail) { ApplicationMailer.new }

    it 'sets the default from address' do
      expect(mail.class.default[:from]).to eq('from@example.com')
    end

    it 'sets the default layout' do
        expect(mail.class.send(:_layout)).to eq('mailer')
    end
  end
end
