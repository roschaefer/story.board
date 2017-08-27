require 'rails_helper'

RSpec.describe QuestionAnswer, type: :model do
  describe '#question' do
    context 'more than 640 characters' do
      subject { build(:question_answer, question: ("q" * 641)) }
      it { is_expected.not_to be_valid }
    end
  end

  describe '#answer' do
    context 'more than 640 characters' do
      subject { build(:question_answer, answer: ("a" * 641)) }
      it { is_expected.not_to be_valid }
    end
  end
end
