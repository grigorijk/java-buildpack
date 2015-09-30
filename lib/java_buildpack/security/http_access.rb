require 'net/http'

class HttpAccess

  # Downloads the source file to the remote location
  def get(source, destination)
    resp = Net::HTTP.get_response(URI(source))
    File.open(destination, 'w') do |file|
      file.write(resp.body)
    end
  end

end