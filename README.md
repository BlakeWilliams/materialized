# Materialized

Proof-of-concept to make it extremely easy for Rails applications to implement "materialization". For example, if we wanted to take a variety of data from a GitHub repository page to create a fast, and eventually consistent experience we could create a materializer that tracks:

```ruby
class RepositoryLayoutMaterializer < Materialized::Builder
  depends_on Repository, :title
  depends_on User, :login

  def call
    case
    when user_changed?:
     user.repositories.in_batches(100) do |repo|
       RepositoryLayout.where(repository_id: repo.id).update(user_login: user.login)
     end
    when repository_changed?
      RepositoryLayout.where(repository_id: repository.id).update(title: repository.title)
    end
  end
end
```

## Installation

TODO: Replace `UPDATE_WITH_YOUR_GEM_NAME_IMMEDIATELY_AFTER_RELEASE_TO_RUBYGEMS_ORG` with your gem name right after releasing it to RubyGems.org. Please do not do it earlier due to security reasons. Alternatively, replace this section with instructions to install your gem from git if you don't plan to release to RubyGems.org.

Install the gem and add to the application's Gemfile by executing:

    $ bundle add UPDATE_WITH_YOUR_GEM_NAME_IMMEDIATELY_AFTER_RELEASE_TO_RUBYGEMS_ORG

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install UPDATE_WITH_YOUR_GEM_NAME_IMMEDIATELY_AFTER_RELEASE_TO_RUBYGEMS_ORG

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/BlakeWilliams/materialized. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/BlakeWilliams/materialized/blob/main/CODE_OF_CONDUCT.md).

## Code of Conduct

Everyone interacting in the Materialized project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/BlakeWilliams/materialized/blob/main/CODE_OF_CONDUCT.md).
