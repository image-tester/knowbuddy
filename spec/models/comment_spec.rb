require 'rails_helper'

describe Comment do

  describe 'Associations' do
    it { should belong_to :user }
    it { should belong_to :post }
  end

  describe 'Database Columns' do
    it { should have_db_column(:comment).of_type(:text) }
    it { should have_db_column(:user_id).of_type(:integer) }
    it { should have_db_column(:post_id).of_type(:integer) }
    it { should have_db_column(:created_at).of_type(:datetime) }
    it { should have_db_column(:updated_at).of_type(:datetime) }
  end

  describe 'Validations' do
    it { should validate_presence_of :comment }
  end

  before do
    @user = create :user
    @post = create :post, user: @user
    @comment = create :comment, post: @post, user: @user
  end

  describe 'create_comment_activity' do
    it 'should create comment activity' do
      act = PublicActivity::Activity.find_by_owner_id_and_key(@user.id, "comment.create")
      expect(act).to_not be_nil
    end
  end

  describe "update_comment_activity" do
    it "should create 'update' activity" do
      fetch_activity_type('comment.update')
      @comment.update(:comment => "Good")
      act = PublicActivity::Activity.find_by_owner_id_and_key(@user.id, "comment.update")
      expect(act).to_not be_nil
    end
  end

  describe "destroy_comment_activity" do
    it "should create 'destroy' activity" do
      fetch_activity_type('comment.destroy')
      @comment.destroy
      act = PublicActivity::Activity.find_by_owner_id_and_key(@user.id, "comment.destroy")
      expect(act).to_not be_nil
    end
  end

  describe 'after_create' do
    it 'should run the proper callbacks' do
      expect(@comment).to receive(:create_comment_activity)
      @comment.run_callbacks(:create)
    end
  end

  describe 'after_update' do
    it 'should run the proper callbacks' do
      expect(@comment).to receive(:update_comment_activity)
      @comment.run_callbacks(:update)
    end
  end

  describe 'before_destroy' do
    it 'should run the proper callbacks' do
      expect(@comment).to receive(:destroy_comment_activity)
      @comment.run_callbacks(:destroy)
    end
  end
end
