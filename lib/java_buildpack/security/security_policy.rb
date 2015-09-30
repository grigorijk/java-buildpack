class SecurityPolicy

  JAVA_SECURITY_LIB = 'lib/security'.freeze
  LOCAL_POLICY_JAR = 'local_policy.jar'.freeze
  US_EXPORT_POLICY_JAR = 'US_export_policy.jar'.freeze

  def initialize(http_access, security_manifest)
    @http_access = http_access
    @security_manifest = security_manifest
  end

  def install(java_home)
    install_local_policy_url(java_home)
    install_us_export_policy(java_home)
  end

  private

  def install_us_export_policy(java_home)
    install_path = "#{java_home}/#{JAVA_SECURITY_LIB}/#{US_EXPORT_POLICY_JAR}"
    @http_access.get(@security_manifest.us_export_policy, install_path)
  end

  def install_local_policy_url(java_home)
    install_path = "#{java_home}/#{JAVA_SECURITY_LIB}/#{LOCAL_POLICY_JAR}"
    @http_access.get(@security_manifest.local_policy_url, install_path)
  end

end

