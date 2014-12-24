require 'rails_helper'

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
    it { should have_db_column(:is_draft).of_type(:boolean) }
  end

  describe 'Validations' do
    it { should validate_presence_of :content }
    it { should validate_presence_of :subject }
    it { should validate_presence_of :slug }
  end

  describe 'scope::post_date' do
    let!(:old_posts)    { create_list :post, 4, updated_at: 2.days.ago }
    let!(:latest_posts) { create_list :post, 2 }

    it "should return post's for date" do
      posts = Post.post_date(old_posts.first)
      expect(posts.count).to eq(4)
      expect(Post.count).to eq(6)
    end
  end

  describe 'Activity Creation' do
    let!(:user) { create :user }
    let!(:post) { create :post, tag_list: "new tag after create", user: user }
    let!(:draft) { create :draft, user: user }

    before do
      fetch_activity_type('post.newTag')
    end

    describe 'create_new_tag_actvitiy' do
      it "should create 'new_tag actvitiy' on create" do
        act = find_activity(user, "post.newTag")
        expect(act).to_not be_nil
        expect(act.parameters).not_to be_empty
      end
    end

    describe 'post_activity' do
      it "should create 'update post activity'" do
        fetch_activity_type('post.update')
        post.update_attributes(subject: "post update")
        act = find_activity(user, "post.update")
        expect(act).to_not be_nil
      end
    end

    describe 'destroy_post_activity' do
      it "should create 'destroy post activity'" do
        fetch_activity_type('post.destroy')
        post.destroy
        act = find_activity(user, "post.destroy")
        expect(act).to_not be_nil
      end

      it "should not create 'destroy post activity'" do
        draft.destroy
        act = find_activity(user, "post.destroy")
        expect(act).to be_nil
      end
    end
  end

  describe 'Review Callbacks' do
    let!(:post) { create :post }

    describe 'after_create' do
      it 'should run the proper callbacks' do
        expect(post).to receive(:post_activity)
        post.run_callbacks(:create)
      end
    end

    describe 'around_save' do
      it 'should run the proper callbacks' do
        expect(post).to receive(:create_new_tag_activity)
        post.run_callbacks(:save)
      end
    end

    describe 'after_update' do
      it 'should run the proper callbacks' do
        expect(post).to receive(:post_activity)
        post.run_callbacks(:update)
      end
    end

    describe 'before_destroy' do
      it 'should run the proper callbacks' do
        expect(post).to receive(:destroy_post_activity)
        post.run_callbacks(:destroy)
      end
    end

    describe 'after_validation' do
      it 'should save the post' do
        expect(post).to receive(:set_is_draft)
        post.run_callbacks(:validation)
      end
    end
  end

  describe 'Scope' do
    let!(:post) { create :post }
    let!(:draft) { create :draft, user_id: post.user_id }

    describe 'draft' do
      it 'should return all draft' do
        expect(Post.draft).to eq [draft]
        expect(Post.draft).to_not include(post)
      end
    end

    describe 'published' do
      it 'should return all published post' do
        expect(Post.published).to eq [post]
        expect(Post.published).to_not include(draft)
      end
    end
  end

  describe 'Instance Methods' do
    before :all do
      @post = create :post, user: @user
      @draft = create :draft, user: @user
    end

    describe "allowed?" do
      it "should return weather user is allowed to see post" do
        expect(@post.allowed?(@user)).to be true
        other_user = create :user
        expect(@draft.allowed?(@user)).to be true
        expect(@draft.allowed?(other_user)).to be false
      end
    end

    describe "published?" do
      it "should return post is published or not" do
        expect(@post.published?).to be true
        expect(@draft.published?).to be false
      end
    end

    describe 'to_s' do
      it 'should return subject' do
        expect(@post.to_s).to eq @post.subject
      end
    end
  end

  describe 'Class Methods' do
    describe 'get_post(post_id)' do
      it 'should' do
        post = create :post
        expect(Post.get_post(post.id)).to eq post
      end
    end

    describe 'invalid_attachments' do
      it 'should delete invalid attachments' do
        attachment1 = Attachment.create()
        attachment2 = Attachment.create()
        expect(Post.invalid_attachments).to eq [attachment1,attachment2]
      end
    end

    describe 'tag_cloud' do
      it 'should show tags in order' do
        fetch_activity_type('post.newTag')
        create_list(:post, 5, tag_list: "a")
        create_list(:post, 2, tag_list: "b")
        create :post, tag_list: "c"
        expect(Post.tag_cloud.keys.map(&:name)).to include("a","b","c")
      end
    end
  end

  describe 'publish post' do
    it 'should set is_draft false' do
      post = create :draft
      expect{ post.save }.to change(post, :is_draft).from(true).to(false)
    end

    it 'should set published details' do
      post = create :draft
      expect{ post.save }.to change(post, :publish_at)
      expect(post.is_published).to eq(true)
    end
  end
end
