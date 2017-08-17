require 'rails/generators'
require 'rails/generators/active_record'

class EavMigrationGenerator < ActiveRecord::Generators::Base

  source_root File.expand_path "../templates", __FILE__
  # small hack to override NamedBase displaying NAME
  argument :name, :required => true, :type => :string, :banner => "<ModelName>"
  argument :hash_name, :required => true, :type => :string, :banner => "<hash_name>"
  argument :custom_table_name, :required => false, :type => :string, :banner => "table_name"

  def create_eav_migration
    p name
    adapter_name = ActiveRecord::Base.connection.adapter_name
    template_name = 'eav_' + (adapter_name == 'Kudu' ? 'kudu_' : '') + 'migration.erb'
    migration_template template_name, "db/migrate/#{migration_file_name}.rb"
  end

  def migration_file_name
    "create_" + table_name
  end

  def migration_name
    migration_file_name.camelize
  end

  def table_name
    custom_table_name || "#{name}_#{hash_name}".underscore.gsub(/\//, '_')
  end

  def model_name
    name
  end

  def model_association_name
    model_name.underscore.gsub(/\//,'_')
  end
end