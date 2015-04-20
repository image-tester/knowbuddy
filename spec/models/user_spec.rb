require "rails_helper"

describe User do
  describe 'scope::top' do
    before do
      5.times do |n|
        user = create :user
        user.posts = create_list :post, n, user: user
      end
    end

    it "should return top 5 contributors" do
      expect(User.top).to_not be_nil
      expect(User.top[5]).to be_nil
      expect(User.top[0].total).to be >= User.top[1].total
    end
  end

  describe 'Callbacks' do
    it 'should run create callback' do
      user = create :user
      expect(user).to receive(:create_user_activity) #should pass
      user.run_callbacks(:create)
    end
    it 'should run update callback' do
      user = create :user, password: "password",
        password_confirmation: "password"
      user.password = "new_password"
      user.password_confirmation = "new_password"
      user.save
      user.run_callbacks(:update)
    end
  end
  describe 'Validations' do
    it { should validate_presence_of :name }
  end

  describe 'Associations' do
    it { should have_many :comments }
    it { should have_many :posts }
  end

  describe 'Class Methods' do
    let!(:user1) { create :user }
    let!(:user2) { create :user }

    describe 'user_collection_email_name' do
      it 'should return user name and id' do
        user2.destroy
        expect(User.user_collection_email_name).to eq [[user1.name,user1.id]]
      end

      it 'should return email and id' do
        user1.name = nil
        user1.save(validate: false)
        user2.destroy
        expect(User.user_collection_email_name).to eq [[user1.email,user1.id]]
      end
    end

    describe 'within_rule_range' do
      let!(:user3) { create :user }
      let!(:user2_post) { create(:post, user: user2) }
      let!(:user3_post1) { create(:post, user: user3) }
      let!(:user3_post2) { create(:post, created_at: 9.days.ago, user: user3) }
      let(:rule_for_no_post_in_week) { create :no_post_in_week_rule }
      let(:rule_for_1_post_in_week) { create :one_post_in_week_rule }
      let(:rule_for_2_posts_in_2_weeks) { create :two_post_rule,
        max_duration: "2_weeks" }

      it "should return users who didn't wrote post in last 1 week" do
        expect(User.within_rule_range(rule_for_no_post_in_week)).to eq([user1])
      end

      it "should not return users who wrote post in last 1 week" do
        expect(User.within_rule_range(rule_for_no_post_in_week)).
          to_not include(user2)
      end

      it "should return users having 1 post in last 1 week" do
        expect(User.within_rule_range(rule_for_1_post_in_week)).
          to eq([user2,user3])
      end

      it "should return users with 2 posts in last 2 weeks" do
        expect(User.within_rule_range(rule_for_2_posts_in_2_weeks)).
          to eq([user3])
      end

      it "should not return users with 1 post in last 2 weeks" do
        expect(User.within_rule_range(rule_for_2_posts_in_2_weeks)).
          to_not include(user2)
      end
    end

    describe 'find_gap_boundary' do
      let(:rule_for_no_post_in_week) { create :no_post_in_week_rule }

      it 'should return gap bondary date based on rule passed' do
        expect(User.find_gap_boundary(rule_for_no_post_in_week.max_duration).
          to_date).to eq(7.days.ago.to_date)
      end
    end

    describe 'get_user(user_id)' do
      it 'should return proper user' do
        user = create :user
        expect(User.get_user(user.id)).to eq user
      end
    end

    describe 'by_name_email' do
      let!(:user1) { create :user, name: "Abc" }
      let!(:user2) { create :user, name: "Zzz" }
      let!(:post1) { create :post, user_id: user1.id }
      let!(:post2) { create :post, user_id: user2.id }

      it 'should display names in order and should be unique' do
        create :post, user_id: user1.id
        expect(User.by_name_email).to eq [user1,user2]
      end
    end
  end

  describe 'Instance Methods' do
    describe 'activate' do
      let!(:user) { create :user }

      it 'should recover a valid record' do
        user.destroy
        expect(user.activate).to eq user
      end

      it 'should recover a invalid record' do
        user.name = nil
        user.save(validates: false)
        expect(user.activate).to eq true
      end
    end

    describe 'display_name' do
      let!(:user) { create :user }

      it 'should display name' do
        expect(user.display_name).to eq user.name.titleize
      end

      it 'should display email if name not persent' do
        user.name = nil
        user.save(validate: false)
        expect(user.display_name).to eq user.email
      end
    end

    describe 'get_first_name' do
      let!(:user) { create(:user, name: "firstname surname",
        email: "firstname@xyz.com") }
      let!(:test_user) { build(:user, name: "firstname") }

      it 'should return first name of user' do
        expect(user.get_first_name).to eq(test_user.name.titleize)
      end

      it 'should return name from email if name is not present' do
        user.name = nil
        user.save(validate: false)
        expect(user.get_first_name).to eq(test_user.name.titleize)
      end
    end

    describe 'activity_params' do
      it 'should display user name' do
        user = create :user
        expect(user.activity_params).to eq(user: "#{user.name}")
      end
    end

    describe 'active?' do
      it 'shows user is active or not' do
        user = create :user
        expect(user.active?).to eq true
      end
    end

    describe 'is_voted?' do
      let!(:post1) { create :post }
      let!(:post2) { create :post }
      let!(:user)  { create :user }

      before do
        post1.liked_by user
        post2.downvote_from user
      end

      it "should check users like" do
        expect(user.voted_up_on? post1).to eq true
        expect(user.voted_up_on? post2).to eq false
      end

      it "should check users dislike" do
        expect(user.voted_down_on? post1).to eq false
        expect(user.voted_down_on? post2).to eq true
      end
    end
  end
end
