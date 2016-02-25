require 'active_record'

class TablelessModel < ActiveRecord::Base
  def self.columns
    @columns ||= [];
  end

  def self.column(name, sql_type = nil, default = nil, null = true)
    columns << ActiveRecord::ConnectionAdapters::Column.new(name.to_s, default,
      sql_type.to_s, null)
  end

  # Override the save method to prevent exceptions.
  def save(validate = true)
    validate ? valid? : true
  end

  def method_missing(m, *args)
    method = m.to_s
    if method.ends_with?("_before_type_cast")
      return send(method.gsub("_before_type_cast", ""))
    else
      super
    end
  end
end

