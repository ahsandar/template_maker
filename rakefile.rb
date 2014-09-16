require 'yaml'
require 'erb'

namespace :template do
  desc 'tempalte maker'
  task :maker, :name, :type do |t,args|
    setup_options(args)
    load_variables(name)
  end
end

def load_variables(env)
  env_settings(env)
  write_template
end

def write_template(template = "contact_details.txt.erb")
  erb = File.read(File.join(Dir.getwd ,"templates", template))
  write_erb(setup_values,erb)
end

def write_erb(values,erb)
  File.open(output_file,"w") do  |f|
    f.write(ERB.new(erb).result(binding))
  end
end

def yml(file_name = "settings.yml")
  @yml ||= File.join(Dir.getwd , file_name)
end

def env_settings(env)
  @settings ||= YAML.load_file(yml)[env]
end

def output_directory(dir = 'output')
  @output_dir ||= File.join(Dir.getwd , dir)
end

def output_file(ext = 'txt')
  @output_file ||= File.join(output_directory, "#{name}_#{type}.#{ext}")
end

def setup_options(args)
  @name = args.name
  @type = args.type
end

def name ;@name ;end

def type ;@type ;end

def setup_values
  {"name" => name}.merge(@settings[type])
end
