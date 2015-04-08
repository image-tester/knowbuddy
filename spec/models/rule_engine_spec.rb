require 'rails_helper'

describe RuleEngine do

  describe 'Factory' do
    it "has valid factory" do
      expect(build(:rule_engine)).to be_valid
    end
  end

  describe 'Class Methods' do

    it "should return rule_for_array" do
      expect(RuleEngine.rule_for_array).to eq(RuleEngine.generate_options_array(RULE_ENGINE_PARAMS))
    end

    it "should return frequency_array" do
      expect(RuleEngine.frequency_array).to eq(RuleEngine.generate_options_array(RULE_ENGINE_SCHEDULE))
    end

    it "should return duration_array" do
      expect(RuleEngine.duration_array).to eq(RuleEngine.generate_options_array(RULE_ENGINE_DURATION_OPTIONS))
    end
  end

  describe 'Scopes' do
    let!(:active_rule) { create(:rule_engine) }
    let!(:inactive_rule) { create(:rule_engine, active: false) }

    it "returns all active rules" do
      expect(RuleEngine.active).to include(active_rule)
      expect(RuleEngine.active).to_not include(inactive_rule)
    end
  end

  describe 'Validations' do
    it { should validate_presence_of :rule }
    it { should validate_presence_of :rule_for }
    it { should validate_presence_of :min_count }
    it { should validate_presence_of :max_count }
    it { should validate_presence_of :frequency }
    it { should validate_presence_of :subject }
    it { should validate_presence_of :body }
    it { should validate_uniqueness_of :rule }
  end
end
