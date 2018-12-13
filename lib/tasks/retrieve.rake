require 'json'
require 'oxford_dictionary'

namespace :words do
    desc 'Retrive from OD API'

    task :retrieve, [:term] => :environment do |t, args|
      client = OxfordDictionary::Client.new(app_id: '0cd7449e', app_key: 'ae4b0f3d52fb1ce1b612f9b93c85a0f6')
      client = OxfordDictionary.new(app_id: '0cd7449e', app_key: 'ae4b0f3d52fb1ce1b612f9b93c85a0f6')

      meaning = client.entry(args[:term])[:lexical_entries].entries[0].entries[0].senses[0].definitions

      puts meaning

      # rake 'words:retrieve[truth]' would return the task
    end


end
