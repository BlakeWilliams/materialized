# frozen_string_literal: true

require 'test_helper'

class Materialized::BuilderTest < Minitest::Test
  # see test/test_helper.rb for the PostView model schema
  class PostViewBuilder < Materialized::Builder
    depends_on Post,
               attrs: [:title],
               on_create: :on_post_create,
               on_destroy: :on_post_destroy
    depends_on Comment,
               on_create: :comment_created,
               on_destroy: :comment_destroyed

    def init_model(post)
      PostView.new(
        post: post,
        title: format_title(post.title),
        comment_count: 0
      )
    end

    def on_post_create(post)
      init_model(post).save!
    end

    def on_post_destroy(post)
      PostView.where(post: post).destroy_all
    end

    def on_post_update(post, changes)
      post_view = PostView.where(post: post).first || init_model(post)

      title = format_title(post.title) if changes.include?('title')
      post_view.update!(title: title)
    end

    def comment_created(comment); end

    def comment_destroyed(comment); end

    private

    def format_title(title)
      return title unless title.start_with?('#')

      "<h1>#{title.gsub(/^#\s+/, '')}</h1>"
    end
  end

  def test_post_updated
    post = Post.create!(title: '# Hello, world!')
    post.update!(title: '# I want to believe')
    PostViewBuilder.new.on_post_update(post, ['title'])

    assert_equal 1, PostView.count

    post_view = PostView.first
    assert_equal '<h1>I want to believe</h1>', post_view.title
  end

  def test_post_create
    post = Post.create!(title: '# Hello, world!')
    PostViewBuilder.new.on_post_create(post)
    assert_equal 1, PostView.count

    post_view = PostView.first
    assert_equal '<h1>Hello, world!</h1>', post_view.title
  end

  def test_post_destroy
    post = Post.create!(title: '# Hello, world!')
    PostViewBuilder.new.on_post_create(post)
    assert_equal 1, PostView.count

    post.destroy!
    PostViewBuilder.new.on_post_destroy(post)
    assert_equal 0, PostView.count
  end
end
