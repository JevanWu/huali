require 'nulldb_rspec'
NullDB.configure do |ndb| 
  def ndb.project_root
    File.expand_path('../../', __FILE__)
  end
end
ActiveRecord::Base.establish_connection(adapter: :nulldb)