Puppet::Type.newtype(:yaml_file) do
  @doc = 'generate a YAML file from hiera data'
  ensurable

  newparam(:path) do
    desc 'file to create'

    validate do |value|
      raise ArgumentError, 'file must be string' unless value.is_a?(String)
    end

    isnamevar
  end

  newparam(:content) do
    desc 'a hash from which to build the file'

    validate do |value|
      raise ArgumentError, 'content is not a hash' unless value.is_a?(Hash)
    end

  end

  newproperty(:mode) do
    desc 'set permissions'
    defaultto '644'
  end
end
