require 'spec_helper'

describe RuleEngine do
  describe 'Associations' do
  end

  describe 'Callbacks' do
  end

  describe 'Factory' do
    it { expect(build(:rule_engine)).to be_valid }
  end

  describe 'Methods' do
  end

  describe 'Scopes' do
  end

  describe 'Validations' do
    subject { create(:rule_engine) }
    it { should validate_presence_of :name }
    it { should validate_presence_of :rule_for }
    it { should validate_presence_of :frequency }
    it { should validate_uniqueness_of :name }
  end
end

