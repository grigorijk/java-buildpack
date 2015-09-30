require 'net/http'

class CdpDependencies

  def initialize(droplet)
    @droplet = droplet
  end

  def add_to_web_inf_lib

    # DO MAVEN COPY (PART 1)
    command = "export #{java_home}; \\
    #{maven_home}/bin/mvn \\
               -s #{maven_settings} \\
               -f #{local_pom_uri} \\
               -P cf-buildpack-deploy \\
               dependency:copy \\
              -DoutputDirectory=#{output_directory}"

    print "Executing #{command}"
#    `#{command}`

    # DO MAVEN COPY (PART 2)
    command = "export #{java_home}; \\
    #{maven_home}/bin/mvn \\
               -s #{maven_settings} \\
               -f #{local_pom_uri} \\
               dependency:copy-dependencies \\
              -DoutputDirectory=#{output_directory}"

    print "Executing #{command}"
#    `#{command}`
    Dir["#{output_directory}/*"]
  end

  private

  def output_directory
    @droplet.root + 'WEB-INF/lib'
  end

  def maven_home
    "#{@droplet.sandbox}/../maven"
  end

  def java_home
    "JAVA_HOME=#{@droplet.sandbox}/../open_jdk_jre"
  end

  def maven_settings
    File.expand_path('../../../../config/settings.xml', __FILE__)
  end

  def host
    'http://192.168.3.10:8081'
  end

  def file
    cdp_framework_version = ENV['cdpversion'] ||= '0.11-MILESTONE'
    "nexus/content/groups/public/uk/co/postoffice/cdp/basebuild/cdp-basebuild/#{cdp_framework_version}/cdp-basebuild-#{cdp_framework_version}.pom"
  end

  def pom_download_path
    @pom_download_path || URI("#{host}/#{file}")
  end

  def local_pom_uri
    @pom ||= begin
      @pom = '/tmp/cdp/pom.xml'
      FileUtils.mkdir_p '/tmp/cdp/'
      resp = Net::HTTP.get_response(pom_download_path)
      print "Downloading pom from #{pom_download_path}"
      File.open(@pom, 'w') { |file| file.write(resp.body) }
      @pom
    end
  end


end