#-*- encoding: utf-8; tab-width: 2 -*-
require 'activeadmin'

module ActiveAdmin
  class ResourceDSL
    def hstore_editor
      before_save do |object,args|
        request_namespace = object.class.name.underscore.gsub('/', '_')
        module_namespace = request_namespace.split('_', 3).last
        object_model_key = (params.key?(request_namespace) && request_namespace) || (params.key?(module_namespace) && module_namespace)

  
        if object_model_key
          object.class.columns_hash.select {|key,attr| attr.type == :hstore}.keys.each do |key|

            if params[object_model_key].key? key
              json_data = params[object_model_key][key]
              data = if json_data == 'null' or json_data.blank?
                {}
              else
                JSON.parse(json_data)
              end
              object.attributes = {key => data}
            end
          end
        else
          raise ActionController::ParameterMissing, request_namespace
        end
      end
    end
  end
end

# -*- encoding: utf-8; tab-width: 2 -*-
# require 'activeadmin'

# module ActiveAdmin
#   class ResourceDSL
#     def hstore_editor
#       before_save do |object,args|
#         request_namespace = object.class.name.underscore.gsub('/', '_')
#         module_namespace = request_namespace.split('_').last
#         object_model_key = (params.key?(request_namespace) && request_namespace) || (params.key?(module_namespace) && module_namespace)

#         if object_model_key
#           object.class.columns_hash.select {|key,attr| attr.type == :hstore}.keys.each do |key|

#             if params[object_model_key].key? key
#               json_data = params[object_model_key][key]
#               data = if json_data == 'null' or json_data.blank?
#                 {}
#               else
#                 JSON.parse(json_data)
#               end
#               object.attributes = {key => data}
#             end
#           end
#         else
#           raise ActionController::ParameterMissing, request_namespace
#         end
#       end
#     end
#   end
# end