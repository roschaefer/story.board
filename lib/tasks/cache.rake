# frozen_string_literal: true

namespace :cache do
  desc 'Delete cached files'
  task delete: :environment do
    FileUtils.rm_rf(Rails.root.join('public', 'reports'))
  end
end
