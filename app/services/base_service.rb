class BaseService
  attr_accessor :params

  def initialize(params = {})
    @params = params
  end

  def call
    raise 'Not implemented'
  end

  def self.call(params = {})
    new(params).call
  end

  def returned_format(status = :ok, data = nil)
    {status: status, data: data}
  end
end