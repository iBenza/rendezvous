require 'rails_helper'

describe Tag do
  describe '#move_all_posts_to!' do
    before :each do
      @tag_ruby = Tag.create(name: 'ruby')
      @tag_java = Tag.create(name: 'java')
      @author = create(:author)
      @post1 = Post.create id: 1001, author: @author, title: 'ruby rspec', body: 'hoge', tags: [@tag_ruby]
      @post2 = Post.create id: 1002, author: @author, title: 'ruby is better than java', body: 'hoge', tags: [@tag_ruby, @tag_java]
      @post3 = Post.create id: 1003, author: @author, title: 'java java...', body: 'hoge', tags: [@tag_java]
    end

    it 'successfully moved' do
      expect(Tag.find_by(name: 'ruby').posts.size).to eq(2)
      expect(Tag.find_by(name: 'java').posts.size).to eq(2)
      @tag_java.move_all_posts_to!(@tag_ruby)
      expect(Tag.find_by(name: 'ruby').posts.size).to eq(3)
      expect(Tag.find_by(name: 'java').posts.size).to eq(0)
    end
  end

  describe '#parent_tag=' do
    before :each do
      @tag_ruby = Tag.create(name: 'ruby')
      @tag_lang = Tag.create(name: 'lang')
    end

    it 'successfully moved' do
      expect(@tag_ruby.parent).not_to eq(@tag_lang)
      expect(@tag_lang.children).not_to include(@tag_ruby)
      @tag_ruby.parent_tag = @tag_lang
      expect(@tag_ruby.parent).to eq(@tag_lang)
      expect(@tag_lang.children).to include(@tag_ruby)
    end
  end
end
