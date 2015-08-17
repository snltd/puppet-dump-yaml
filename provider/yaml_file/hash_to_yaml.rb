require 'pathname'
require 'yaml'

Puppet::Type.type(:yaml_file).provide(:hash_to_yaml) do

  desc 'dump some hiera config as a YAML file'

  def generate_file(data)
    data.to_yaml
  end

  def create
    Puppet.info "creating #{@resource[:path]}"
    File.open(@resource[:path], 'w') do |fh|
      fh.write(generate_file(@resource[:content]))
    end
  end

  def exists?
    #
    # It looks like we have to do the work of not only seeing if the
    # file exists, but if its contents are correct
    #
    if Pathname.new(@resource[:path]).exist?
      return true unless @resource[:content]
      YAML.load(IO.read(@resource[:path])) == @resource[:content]
    else
      false
    end

  end

  def destroy
    File.unlink(@resource[:path])
  end

  def mode
    if File.exists?(@resource[:path])
      "%o" % (File.stat(@resource[:path]).mode & 007777)
    else
      :absent
    end
  end

  def mode=(value)
    File.chmod(Integer('0' + value), @resource[:path])
  end
end
