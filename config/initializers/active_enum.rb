# Form helper integration
require 'active_enum/form_helpers/simple_form'
# require 'active_enum/form_helpers/formtastic

ActiveEnum.setup do |config|

  # Extend classes to add enumerate method
  # config.extend_classes = [ ActiveRecord::Base ]

  # Return name string as value for attribute method
  config.use_name_as_value = true

  # Storage of values
  # config.storage = :memory

end

# ActiveEnum.define do
# 
#   enum(:enum_name) do
#     value 1 => 'Name'
#   end
# 
# end

ActiveEnum.define do
    enum(:status) do
        value 1 => 'job-seeking'
        value 2 => 'employed'
        value 3 => 'employed (ext)'
        value 4 => 'no interest'
        value 5 => 'alumni'

    end
end