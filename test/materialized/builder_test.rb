# frozen_string_literal: true

require 'test_helper'

class Materialized::BuilderTest < Minitest::Test
  # see test/test_helper.rb for the PostView model schema
  class PostViewBuilder < Materialized::Builder
    depends_on Post, :title
    depends_on_destruction_of Post

    depends_on_creation_of Post
    depends_on_creation_of Comment
    depends_on_destruction_of Comment

    def on_post_create(posts)
      posts.each do |post|
        PostView.create!(post: post, title: format_title(post.title), comment_count: 0)
      end
    end

    def on_post_destroy(posts)
      posts.each do |post|
        PostView.where(post: post).destroy_all
      end
    end

    def on_post_update(post, changes)
      post_view = PostView.where(post: post)

      title = format_title(changes[:title]) if changes.include?(:title)
      post_view.update(title: title)
    end

    def on_comment_create(_comments)
      PostView.create!(title: post.title, comment_count: 0)
    end

    private

    def format_title(title)
      return title unless title.start_with?('#')

      "<h1>#{title.gsub(/^#\s+/, '')}</h1>"
    end
  end

  def test_post_updated
    post = Post.create!(title: '# Hello, world!')
    PostViewBuilder.new.on_post_create(Array(post))

    post = Post.update!(title: '# I want to believe')
    PostViewBuilder.new.on_post_update(post, { title: '# I want to believe' })

    assert_equal 1, PostView.count

    post_view = PostView.first
    assert_equal '<h1>I want to believe</h1>', post_view.title
  end

  def test_post_create
    post = Post.create!(title: '# Hello, world!')
    PostViewBuilder.new.on_post_create(Array(post))
    assert_equal 1, PostView.count

    post_view = PostView.first
    assert_equal '<h1>Hello, world!</h1>', post_view.title
  end

  def test_post_destroy
    post = Post.create!(title: '# Hello, world!')
    PostViewBuilder.new.on_post_create(Array(post))
    assert_equal 1, PostView.count

    post.destroy!
    PostViewBuilder.new.on_post_destroy(Array(post))
    assert_equal 0, PostView.count
  end
end
