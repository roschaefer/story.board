require 'rails_helper'

RSpec.describe DiaryEntry, type: :model do
  let(:report) { Report.current }
  describe '::after_initialize' do
    let(:diary_entry) { DiaryEntry.new }
    subject { diary_entry }
    it 'initializes #moment with the current timestamp' do
      expect(subject.moment).to be_a Time
    end

    it '#moment is a time after save' do
      subject.save
      subject.reload
      expect(subject.moment).to be_a Time
    end
  end

  describe '#compose' do
    let(:diary_entry) { DiaryEntry.new(report: report) }
    subject { diary_entry.compose }

    before { report.text_components << create(:text_component, heading: 'Assigned heading', main_part: 'Main part') }
    it 'assigns heading' do
      expect{ subject }.to(change{diary_entry.heading}.from('').to('Assigned heading'))
    end

    it 'assigns main_part' do
      expect{ subject }.to(change{diary_entry.main_part}.from('').to("<p>Main part<span class='resi-thread'>\n</span>\n</p>\n"))
    end
  end

  describe '#text_components' do
    subject { diary_entry.text_components }
    let(:diary_entry) { DiaryEntry.new(report: report) }
    let(:text_components) { create_list(:text_component, 3, report: report) }
    it 'returns the active text components of the report' do
      text_components
      expect(subject.count).to eq 3
    end
  end


  describe '#live?' do
    context 'saved' do
      subject { create(:diary_entry) }
      it { is_expected.not_to be_live }
    end

    context 'not saved' do
      subject { build(:diary_entry) }
      it { is_expected.to be_live }
    end
  end

  describe '#archive!' do
    let(:release) { :final }
    let(:diary_entry) { described_class.new(report: report, release: release) }
    subject { diary_entry.archive! }
    it 'stores a new diary entry' do
     expect{ subject } .to change{ DiaryEntry.count }.from(0).to(1)
    end

    it 'adds a new diary entry to the report' do
     expect{ subject; report.reload }.to change{ report.diary_entries.size }.from(0).to(1)
    end

    context 'for :debug data' do
      let(:release) { :debug }
      it 'stores the release along with the diary entry' do
        subject
        expect(report.diary_entries.first.release).to eq 'debug'
      end
    end

    context 'when maximum limit is reached' do
      before do
        DiaryEntry::LIMIT.times do 
          diary_entry = DiaryEntry.new(report: Report.current)
          diary_entry.archive!
        end
      end
      it 'number of diary entries stay the same' do
        expect{ subject }.not_to change{ report.diary_entries.size }
      end

      context 'but for another release' do
        let(:release) { :debug }
        it 'can exceed' do
          expect{ subject }.to change{ report.diary_entries.size }
        end
      end
    end
  end
end
