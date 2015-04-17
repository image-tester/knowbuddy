require 'rails_helper'

describe RuleEngine do

  describe 'Factory' do
    it "has valid factory" do
      expect(build(:rule_engine)).to be_valid
    end
  end

  describe 'Class Methods' do
    it "should return frequency array" do
      expect(RuleEngine.frequency_array).to eq(RuleEngine.
        generate_options_array(RULE_ENGINE_SCHEDULE))
    end

    it "should return duration array" do
      expect(RuleEngine.duration_array).to eq(RuleEngine.
        generate_options_array(RULE_ENGINE_DURATION_OPTIONS))
    end

    it "should return rule_for array" do
      expect(RuleEngine.rule_for_array).to eq(RuleEngine.
        generate_options_array(RULE_ENGINE_PARAMS))
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

    it "should validate min-max range" do
      expect(build(:rule_engine, min_count: 0, max_count: 0)).to_not be_valid
      expect(build(:rule_engine, min_count: 2, max_count: 1)).to_not be_valid
      expect(build(:rule_engine, min_count: 0, max_count: 1)).to be_valid
    end

    it "should validate schedule presence if frequency is not 'daily'" do
      expect(build(:rule_engine, schedule: nil)).to_not be_valid
    end

    it "should not validate schedule presence if frequency is 'daily'" do
      expect(build(:rule_engine, frequency: "daily", schedule: nil)).
        to be_valid
    end

    it "should not validate body if rule_for 'general'" do
      expect(build(:general_rule, body: nil)).to be_valid
    end

    it "should not validate min_count and max_count if rule_for 'general'" do
      expect(build(:general_rule, min_count: nil, max_count: nil)).to be_valid
    end

    it "should not validate max_duration if rule_for 'general'" do
      expect(build(:general_rule, max_duration: nil)).to be_valid
    end
  end
end
