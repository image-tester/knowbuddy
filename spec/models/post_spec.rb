require 'spec_helper'

describe Post do

  describe 'Associations' do
    it { should belong_to :user }
    it { should have_many :attachments }
    it { should have_many :comments }
  end

   describe 'Database Columns' do
    it { should have_db_column(:subject).of_type(:string) }
    it { should have_db_column(:content).of_type(:text) }
    it { should have_db_column(:slug).of_type(:string) }
    it { should have_db_column(:user_id).of_type(:integer) }
    it { should have_db_column(:created_at).of_type(:datetime) }
    it { should have_db_column(:publish_at).of_type(:datetime) }
    it { should have_db_column(:updated_at).of_type(:datetime) }
    it { should have_db_column(:deleted_at).of_type(:datetime) }
  end

  describe 'Validations' do
    it { should validate_presence_of :content }
    it { should validate_presence_of :subject }
    it { should validate_presence_of :slug }
  end

  describe 'scope::post_date' do
    before do
      4.times do |n|
        @user = create :user
        @post = create :post, created_at: Time.now, user: @user
      end

      @user = create :user
      post = create :post, created_at: 2.days.ago, user: @user
    end

    it "should return post's for date" do
      posts = Post.post_date(Post.first)
      posts.count.should == 4
      Post.count.should == 5
    end
  end

  describe 'activity creation' do
    before do
      fetch_activity_type('post.newTag')
      @user = create :user
      @post = create :post, tag_list: "new tag after create", user: @user
    end

    describe 'create_new_tag_actvitiy' do
      it 'should create new_tag actvitiy on create' do
        act = PublicActivity::Activity.find_by_owner_id_and_key(@user.id, "post.newTag")
        expect(act.parameters).not_to be_empty
        act.should_not be_nil
      end
    end

    describe 'update_post_activity' do
      it 'should update post activity' do
        fetch_activity_type('post.update')
        @post.update_attributes(subject: "post update")
        act = PublicActivity::Activity.find_by_owner_id_and_key(@user.id, "post.update")
        act.should_not be_nil
      end
    end

    describe 'destroy_post_activity' do
      it 'should destroy post activity' do
        fetch_activity_type('post.destroy')
        @post.destroy
        act = PublicActivity::Activity.find_by_owner_id_and_key(@user.id, "post.destroy")
        act.should_not be_nil
      end
    end
  end

  describe 'review callbacks' do
    let!(:post) { create :post }

    describe 'after_create' do
      it 'should run the proper callbacks' do
        post.should_receive(:create_post_activity)
        post.run_callbacks(:create)
      end
    end

    describe 'around_save' do
      it 'should run the proper callbacks' do
        post.should_receive(:create_new_tag_activity)
        post.run_callbacks(:save)
      end
    end

    describe 'after_update' do
      it 'should run the proper callbacks' do
        post.should_receive(:update_post_activity)
        post.run_callbacks(:update)
      end
    end

    describe 'before_destroy' do
      it 'should run the proper callbacks' do
        post.should_receive(:destroy_post_activity)
        post.run_callbacks(:destroy)
      end
    end
  end
end