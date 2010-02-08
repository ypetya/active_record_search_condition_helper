Object.send :include, Virgo::Core::Object::InstanceMethods
String.send :include, Virgo::Core::String::InstanceMethods
String.extend Virgo::Core::String::ClassMethods
Float.send :include, Virgo::Core::Float::InstanceMethods
Array.send :include, Virgo::Core::Array::InstanceMethods

#Spec::Example::ExampleGroupMethods.module_eval do
#  include Virgo::Spec::ExampleGroupExtensions
#end

# kiszedtem, mert alias_method_chain depricated volt, és itt nincs rá szükség
#require 'virgo/active_record/validations.rb'
#require 'virgo/action_controller/test_process.rb'

ActiveRecord::Base.extend Virgo::ActiveRecord::Base::ClassMethods

module Kernel

  # kezdetben a condition 3 féle lehet 
  # 1. nincs még. 
  # 2. string. 
  # 3. tömb [string]
  # 4. Ez a tökéletes forma, amivel működik a fv: [string, hash]
  def normalize_condition condition
    # 1. 
    condition = ["", {}] unless condition
    condition = ["", {}] if condition.empty?
    # 2.
    condition = [condition, {}] if condition.is_a? String
    # 3.
    condition << {} if condition.is_a? Array and condition.length == 1 and condition.first.is_a? String
    # 4.
    throw 'condition format error' unless condition.is_a? Array and condition.first.is_a? String and condition.last.is_a? Hash
    condition
  end
  
  def extend_condition condition, string_part, value_part = {}
    # normál alakra hozás [ '', {} ]
    condition = normalize_condition( condition )

    # hozzáfűzés
    # ha még üres, első elem akkor nincs AND
    if condition.first.empty?
      [ string_part, condition.last.merge( value_part ) ]
    else
      [ [condition.first,string_part].join(' AND '), condition.last.merge( value_part ) ]
    end
  end

end