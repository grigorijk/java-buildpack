require 'yaml'

class SecurityManifest

  def initialize(config_file)
    @config_file = config_file
    raise "Cannot find expected security config file: #{config_file}" unless File.exists? config_file
  end

  def local_policy_url
    yaml_file['local_policy_url']
  end

  def us_export_policy
    yaml_file['us_export_policy']
  end

  def yaml_file
    @yaml || YAML.load_file(@config_file)
  end

end